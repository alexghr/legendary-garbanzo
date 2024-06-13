FROM mcr.microsoft.com/devcontainers/base:bookworm

USER vscode

RUN curl -L https://raw.githubusercontent.com/noir-lang/noirup/main/install | bash
RUN $HOME/.nargo/bin/noirup
