#!/bin/bash
git submodule init
git submodule update --recursive

cd zkWasm
# Checkout branch/tag/commitHash here for the version
git checkout 35650d5e0eabb8ccba1908a27fcd27e0c0c0115a
git submodule init
git submodule update --recursive
cargo build --release --features continuation,perf,profile
cd -

cd continuation-batcher
git checkout 904a0c1b03027b6cf256d9ccd44d8eb5abbac69a
cargo build --features perf --release
cd -

