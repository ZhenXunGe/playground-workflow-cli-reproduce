#!/bin/bash
git submodule init
git submodule update --recursive

cd zkWasm
git fetch
# Checkout branch/tag/commitHash here for the version
git checkout 35650d5e0eabb8ccba1908a27fcd27e0c0c0115a
git submodule init
git submodule update --recursive
cargo build --release --features continuation,perf,profile
cd -

cd continuation-batcher
git fetch
git checkout tags/playground-enable-autosubmit-1.0 # Can either use tags/stable-shuffle-1.0, these 2 version in fact are using same dependency
cargo build --features perf --release
cd -

# Copy our own loading file zkwasm cli and rebuild zkwasm
cp ./data/app_builder.rs zkWasm/crates/cli/src/app_builder.rs
cd zkWasm
cargo build --release --features continuation,perf,profile
cd -
