#!/bin/bash
git submodule init
git submodule update --recursive

cd zkWasm
# Checkout branch/tag/commitHash here for the version
# This is for current playground main branch version which is explorer-integration-2.0 branch, hash: 99e781280716837836177efddbf07306e1d41592
git checkout 99e781280716837836177efddbf07306e1d41592
git submodule init
git submodule update --recursive
cargo build --release --features continuation,perf,profile
cd -

cd continuation-batcher
# This is for batcher tag="on-prove-pairing-2.0"
git checkout tags/on-prove-pairing-2.0
cargo build --features perf --release
cd -

