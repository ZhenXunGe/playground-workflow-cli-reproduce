#!/bin/bash
git submodule init
git submodule update --recursive

cd zkWasm
# Checkout branch/tag/commitHash here for the version
git checkout 3fac796e9d8c01556bbf473418b16e5181ff2c04
git submodule init
git submodule update --recursive
cargo build --release --features continuation,perf,profile
cd -

cd continuation-batcher
git checkout c058e85cd401981f6ddf94d7378281b0ba7a2327
cargo build --features perf --release
cd -

