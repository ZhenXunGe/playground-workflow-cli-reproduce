#!/bin/bash
git submodule init
git submodule update --recursive

cd zkWasm || exit 1
# Checkout branch/tag/commitHash here for the version
git checkout 48fc8adc2f045a09e8b919361f8b399ccae25dc4
git submodule init
git submodule update --recursive

# For some reason I couldn't drop in replace with `ZhenXunGe/zkWasm`, so in this is a hack fix of cli issue
# which prevents `--wasm` from being used.
sed -i '/let command = if cfg!(not(feature = "uniform-circuit")) {/,/};/c\
    let command = command.arg(WasmImageArg::builder());
' crates/cli/src/app_builder.rs || exit 1

cargo build --release --features continuation,perf,profile
cd - || exit 1

cd continuation-batcher || exit 1
git checkout 00945b9329051b3da504c3ce2f6c5470fe48d239
cargo build --features perf --release
cd - || exit 1

