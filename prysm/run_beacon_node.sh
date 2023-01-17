#!/bin/env bash

set -exu -o pipefail

source /shared/shared.env

: "${EXECUTION_NODE_URL:-}"
: "${PROCESS_NAME:-beacon-node}"
: "${TRACING_ENDPOINT:-}"
: "${VERBOSITY:-info}"
: "${P2P_PRIV_KEY:-}"
: "${P2P_TCP_PORT:-13000}"

EXTERNAL_IP=$(ip addr show eth0 | grep inet | awk '{ print $2 }' | cut -d '/' -f1)

beacon-node \
    --accept-terms-of-use \
    --verbosity="$VERBOSITY" \
    --datadir /chaindata \
    --force-clear-db \
    --interop-eth1data-votes \
    --interop-genesis-state /shared/genesis.ssz \
    --interop-genesis-time ${GENESIS} \
    --interop-num-validators 4 \
    --execution-endpoint="$EXECUTION_NODE_URL" \
    --jwt-secret=/shared/jwtsecret \
    --chain-config-file=/shared/chain-config.yml \
    --contract-deployment-block 0 \
    --rpc-host 0.0.0.0 \
    --rpc-port 4000 \
    --grpc-gateway-host 0.0.0.0 \
    --grpc-gateway-port 3500 \
    --enable-debug-rpc-endpoints \
    --p2p-local-ip 0.0.0.0 \
    --p2p-host-ip "$EXTERNAL_IP" \
    --p2p-tcp-port $P2P_TCP_PORT \
    --p2p-priv-key="$P2P_PRIV_KEY"\
    --subscribe-all-subnets \
    --enable-tracing \
    --tracing-endpoint "$TRACING_ENDPOINT" \
    --tracing-process-name "$PROCESS_NAME" \
    $@
