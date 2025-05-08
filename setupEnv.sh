#!/bin/bash
git submodule init
git submodule update --recursive

cd zkWasm || exit 1
# Checkout branch/tag/commitHash here for the version
git checkout 48fc8adc2f045a09e8b919361f8b399ccae25dc4
git submodule init
git submodule update --recursive
cargo build --release --features continuation,perf,profile
cd - || exit 1

cd continuation-batcher || exit 1
git checkout 00945b9329051b3da504c3ce2f6c5470fe48d239
cargo build --features perf --release
cd - || exit 1

