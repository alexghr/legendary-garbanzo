FROM mcr.microsoft.com/devcontainers/base:bookworm

RUN apt update && apt install -y libc++-dev xxd && \
  wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/bin/yq && \
  chmod +x /usr/bin/yq

USER vscode

RUN curl -L https://raw.githubusercontent.com/noir-lang/noirup/main/install | bash
RUN $HOME/.nargo/bin/noirup
