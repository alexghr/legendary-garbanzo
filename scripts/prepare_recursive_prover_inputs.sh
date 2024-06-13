#!/usr/bin/env bash

# this script creates Prover.toml from the proof, public inputs and bytecode of recursive_is_valid

set -e

if [ -z "$1" ]; then
    echo "Usage: $0 <verifier.toml>"
    exit 1
fi

verifier=$(realpath "$1")

# all paths are relative to the script
cd "$(dirname "$0")"
# a temp dir for files that we need
tmp="$(mktemp -d)"
echo $tmp
# the current backend - assumes it's bb or it follows bb's API
backend="$HOME/.nargo/backends/$(cat $HOME/.nargo/backends/.selected_backend)/backend_binary"

# prep the VK
jq -r .bytecode ../target/rec_client_side.json | base64 -d > "$tmp/bytecode"
$backend write_vk -v -b "$tmp/bytecode" -o "$tmp/vk"
$backend vk_as_fields -v -k "$tmp/vk" -o "$tmp/vk_fields"

# prep the proof
# first copy public inputs to start of proof
yq -oy '.[]' $verifier | xxd -r -ps > "$tmp/proof"
# then decode the hex-encoded proof to binary and append it
xxd -ps -r "../proofs/rec_client_side.proof" - >> "$tmp/proof"
$backend proof_as_fields -v -k "$tmp/vk" -p "$tmp/proof" -o "$tmp/proof_fields"

cat > ../crates/rec_server_side/Prover.toml <<EOF
key_hash = $(jq .[0] $tmp/vk_fields)
verification_key = $(jq .[1:] "$tmp/vk_fields")
public_inputs = $(jq -c .[0:1] "$tmp/proof_fields")
proof = $(jq .[1:] "$tmp/proof_fields")
EOF

rm -rf $tmp
