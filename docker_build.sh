#!/usr/bin/env sh

set -e
docker build -t contract-builder:latest -f docker/builder.Dockerfile .
docker run --name contract-builder contract-builder:latest
docker cp contract-builder:/build .
docker rm contract-builder

cp build/starter.* ./starter/  || true

echo "WASM hash: $(sha256sum starter/starter.wasm)"