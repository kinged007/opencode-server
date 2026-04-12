# ============================================
# OpenCode Server - Arch Linux Docker Image
# ============================================
# Lightweight base with npm, pnpm, bun, uv, Rust

# ──────────────────────────────────────────────
# Stage 1: Builder - Install all package managers
# ──────────────────────────────────────────────
FROM archlinux:base-devel AS builder

ENV HOME=/root
ENV LANG=en_US.UTF-8
ENV LC_ALL=C

# Update and install base build dependencies
RUN pacman -Sy --noconfirm && \
    pacman -S --noconfirm \
    ca-certificates \
    nodejs \
    npm \
    python \
    python-pip \
    git \
    github-cli \
    curl \
    wget \
    unzip \
    base-devel \
    && rm -rf /var/cache/pacman/*

# ─── pnpm ───
RUN npm install -g pnpm@latest && pnpm --version

# ─── bun ───
RUN curl -fsSL https://bun.sh/install | bash && \
    ln -s /root/.bun/bin/bun /usr/local/bin/bun && \
    bun --version

# ─── uv (Python package manager - written in Rust) ───
RUN pip install uv --break-system-packages && uv --version

# ─── Rust (via rustup) ───
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable && \
    . /root/.cargo/env && \
    rustc --version && \
    cargo --version

# ──────────────────────────────────────────────
# Stage 2: Runtime - OpenCode Server
# ──────────────────────────────────────────────
FROM archlinux:base

ENV HOME=/root
ENV LANG=en_US.UTF-8
ENV LC_ALL=C
ENV OPENCODE_CONFIG_DIR=/home/opencode/.config/opencode
ENV WORKSPACE_DIR=/home/opencode/workspaces
ENV PATH="/root/.cargo/bin:/usr/bin:${PATH}"

# Install runtime dependencies only (no base-devel)
RUN pacman -Sy --noconfirm && \
    pacman -S --noconfirm \
    ca-certificates \
    nodejs \
    npm \
    python \
    python-pip \
    git \
    github-cli \
    curl \
    wget \
    unzip \
    && rm -rf /var/cache/pacman/*

# Copy package managers from builder
# Copy bun
COPY --from=builder /root/.bun/bin/bun /usr/bin/bun
# Copy Rust toolchain (including .rustup directory for installed toolchains)
COPY --from=builder /root/.cargo/bin/cargo /usr/bin/cargo
COPY --from=builder /root/.cargo/bin/rustc /usr/bin/rustc
COPY --from=builder /root/.cargo/bin/rustup /usr/bin/rustup
COPY --from=builder /root/.rustup /root/.rustup
# Copy uv
COPY --from=builder /usr/bin/pip /usr/bin/pip
COPY --from=builder /usr/bin/uv /usr/bin/uv

# Verify installations (pnpm will be installed in next step with opencode)
RUN node --version && npm --version && \
    git --version && \
    gh --version && \
    curl --version && \
    wget --version && \
    /usr/bin/bun --version && \
    /usr/bin/rustc --version && \
    /usr/bin/cargo --version && \
    /usr/bin/uv --version

# Create opencode user
RUN useradd -m -s /bin/bash opencode && \
    mkdir -p /home/opencode/.config/opencode && \
    mkdir -p /home/opencode/workspaces && \
    chown -R opencode:opencode /home/opencode && \
    chmod 775 /home/opencode/workspaces /home/opencode/.config/opencode

USER opencode

# Set HOME to opencode user's home directory for npm cache
ENV HOME=/home/opencode
ENV PATH="/home/opencode/.local/bin:${PATH}"

# Configure npm to use user-writable global directory
RUN mkdir -p /home/opencode/.local/bin && \
    npm config set prefix '/home/opencode/.local' && \
    npm config set cache '/home/opencode/.npm-cache'

# Install pnpm, OpenCode, and context-mode globally via npm
RUN npm install -g pnpm opencode-ai context-mode && \
    pnpm --version && \
    opencode --version

USER root

WORKDIR /home/opencode/workspaces

# Copy config directory
COPY --chown=opencode:opencode config/ /home/opencode/.config/

# Runtime entrypoint handles permission fixes for mounted volumes, then drops to opencode user
COPY scripts/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Expose default port
EXPOSE 4096

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD opencode server health || exit 1

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["opencode", "serve", "--hostname", "0.0.0.0", "--port", "4096"]
