# playground-workflow-cli-reproduce
This repo is the reproduce env to use zkWasm and continuation-batcher cli to reproduce issues in playground
Main branch is a success workflow for a simple image
For each issue it should be a seperate branch with different version of zkwasm/batcher so we can track the issues

## How to use it
1. Check setupEnv.sh and modify the submodule zkWasm and continuation-batcher version to the version you want to reproduce issues
2. `bash setupEnv.sh`
3. put the issue image into images folder with name image.wasm
4. adjust the cli command in "run.sh" for zkwasm and continuation-batcher command with your issue inputs. (like those --public, --private inputs, etc)
5. `bash run.sh`

## Usage for ZKWAS-404 ("Dry run takes long time" issue)
Image and inputs included in this branch, so you only need to run the following commands:

1. Start mongo db process on the default port (leave this running on its own terminal):
    ```
    mongod --dbpath db
    ```
2. In a different terminal restore mongo data. Extract mongo `zkwasm-mongo-merkle.tar.gz` and run restore command:
    ```
    cd data
    tar xvf zkwasm-mongo-merkle.tar.gz
    mongorestore --db zkwasm-mongo-merkle ./zkwasm-mongo-merkle
    cd -
    ```
2. Download submodules:
    ```
    bash setupEnv.sh
    ```
3. Copy zkwasm patch (this is for passing inputs via a file - note that this is specifically for zkwasm commit `3fac796e9d8c01556bbf473418b16e5181ff2c04`):
    - copy file:
        ```
        cp ./data/app_builder.rs zkWasm/crates/cli/src/app_builder.rs
        ```
    - Recompile zkwasm with updated cli:
        ```
        cd zkWasm
        cargo build --release --features continuation,perf,profile
        cd -
        ```
4. Run:
    ```
    bash run.sh
    ```
