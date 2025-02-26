# playground-workflow-cli-reproduce
This repo is the reproduce env to use zkWasm and continuation-batcher cli to reproduce issues in playground
Main branch is a success workflow for a simple image
For each issue it should be a seperate branch with different version of zkwasm/batcher so we can track the issues

## How to use it
1. `bash setupEnv.sh`
2. `bash run.sh`

## Issue
This is when we test image with context.
The image.wasm is generated from images/context.rs

It looks like the wasm_write_context() will trigger the error

The run.sh will fail with info:
`thread 'main' panicked at /home/yymone/.cargo/git/checkouts/halo2ecc-s-703ac241a66bc1e8/164b836/src/circuit/base_chip.rs:488:9:
assertion failed: a.0.val == N::one()`