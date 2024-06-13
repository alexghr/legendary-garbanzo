
VERSION 0.8

noir:
  FROM debian:bookworm

  RUN apt update && apt install -y libc++-dev curl git jq xxd && \
    curl -Lo /usr/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 && \
    chmod +x /usr/bin/yq
  RUN curl -L https://raw.githubusercontent.com/noir-lang/noirup/main/install | bash
  ENV PATH=$HOME/.nargo/bin:$PATH
  RUN $HOME/.nargo/bin/noirup

src:
  FROM +noir
  WORKDIR /workspace
  COPY . .

build:
  FROM +src
  RUN nargo compile --silence-warnings

rec-client-side:
  ARG scenario=valid
  FROM +build
  RUN nargo prove --package rec_client_side --prover-name Prover.$scenario.toml --verifier-name Verifier.$scenario.toml
  RUN nargo verify --package rec_client_side --verifier-name Verifier.$scenario.toml
  
valid-rec-server-side:
  FROM +rec-client-side --scenario=valid
  RUN ./scripts/prepare_recursive_prover_inputs.sh ./crates/rec_client_side/Verifier.valid.toml
  RUN nargo prove --silence-warnings --package rec_server_side --prover-name Prover.toml --verifier-name Verifier.toml
  RUN nargo verify --silence-warnings --package rec_server_side --verifier-name Verifier.toml

invalid-rec-server-side:
  FROM +rec-client-side --scenario=invalid
  RUN ./scripts/prepare_recursive_prover_inputs.sh ./crates/rec_client_side/Verifier.invalid.toml
  RUN nargo prove --silence-warnings --package rec_server_side --prover-name Prover.toml --verifier-name Verifier.toml
  RUN nargo verify --silence-warnings --package rec_server_side --verifier-name Verifier.toml

faked-rec-server-side:
  FROM +rec-client-side --scenario=invalid
  RUN ./scripts/prepare_recursive_prover_inputs.sh ./crates/rec_client_side/Verifier.invalid.toml
  RUN sed -i 's/public_inputs.*/public_inputs = ["0x0000000000000000000000000000000000000000000000000000000000000000"]/' crates/rec_server_side/Prover.toml
  RUN nargo prove --silence-warnings --package rec_server_side --prover-name Prover.toml --verifier-name Verifier.toml
  RUN nargo verify --silence-warnings --package rec_server_side --verifier-name Verifier.toml
