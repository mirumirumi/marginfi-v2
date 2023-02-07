#!/usr/bin/env bash

PROGRAM_ID=
NEW_PROFILE_NAME=

RPC_ENDPOINT=https://devnet.genesysgo.net/
KEYPAIR_PATH=~/.config/solana/id.json

[ -z "$PROGRAM_ID" ] && echo "PROGRAM_ID must be specified. Exiting." && exit 1
[ -z "$NEW_PROFILE_NAME" ] && echo "NEW_PROFILE_NAME must be specified. Exiting." && exit 1

cargo run --bin mfi profile create \
    --cluster devnet \
    --name "$NEW_PROFILE_NAME" \
    --keypair-path "$KEYPAIR_PATH" \
    --rpc-url "$RPC_ENDPOINT" \
    --program-id "$PROGRAM_ID"

cargo run --bin mfi profile set "$NEW_PROFILE_NAME"

cargo run --bin mfi --features=admin,devnet group create "$@"

# Add USDC bank
cargo run --bin mfi --features=admin,devnet group add-bank \
    --mint F9jRT1xL7PCRepBuey5cQG5vWHFSbnvdWxJWKqtzMDsd \
    --asset-weight-init 0.85 \
    --asset-weight-maint 0.9 \
    --liability-weight-maint 1.1 \
    --liability-weight-init 1.15 \
    --max-capacity 1000000000000000 \
    --pyth-oracle 5SSkXsEKQepHHAewytPVwdej4epN1nxgLVM84L4KXgy7 \
    --optimal-utilization-rate 0.9 \
    --plateau-interest-rate 1 \
    --max-interest-rate 10 \
    --insurance-fee-fixed-apr 0.01 \
    --insurance-ir-fee 0.1 \
    --protocol-fixed-fee-apr 0.01 \
    --protocol-ir-fee 0.1 \
    "$@"

# Add SOL bank
cargo run --bin mfi --features=admin,devnet group add-bank \
    --mint 4Bn9Wn1sgaD5KfMRZjxwKFcrUy6NKdyqLPtzddazYc4x \
    --asset-weight-init 0.75 \
    --asset-weight-maint 0.8 \
    --liability-weight-maint 1.2 \
    --liability-weight-init 1.25 \
    --max-capacity 1000000000000000 \
    --pyth-oracle J83w4HKfqxwcq3BEMMkPFSppX3gqekLyLJBexebFVkix \
    --optimal-utilization-rate 0.8 \
    --plateau-interest-rate 1 \
    --max-interest-rate 20 \
    --insurance-fee-fixed-apr 0.01 \
    --insurance-ir-fee 0.1 \
    --protocol-fixed-fee-apr 0.01 \
    --protocol-ir-fee 0.1 \
    "$@"
