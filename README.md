# playground-workflow-cli-reproduce
This repo is the reproduce env to use zkWasm and continuation-batcher cli to reproduce issues in playground
Main branch is a success workflow for a simple image
For each issue it should be a seperate branch with different version of zkwasm/batcher so we can track the issues

For this branch, the purpose is to reproduce the dry run need more than 3 minutes when the proof is about 30M instructions.

## Usage for ZKWAS-404 ("Dry run takes long time" issue)
Image and inputs included in this branch, so you only need to run the following commands from the `playground-workflow-cli-reproduce` directory.

1. In a different terminal, from the `playground-workflow-cli-reproduce` directory, start the mongo db process on the default port (leave this running on its own terminal - note that we increase the ulimit because the dryrun sends many requests to the db which causes many files to be open at once):
    ```
    mkdir -p db
    ulimit -n 64000
    mongod --dbpath db
    ```
2. Return to your main terminal and restore the mongo db data by extracting mongo `zkwasm-mongo-merkle.tar.gz` and running the restore command:
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
3. Copy zkwasm patch (this is for passing inputs via text file - note that this is specifically for zkwasm commit `3fac796e9d8c01556bbf473418b16e5181ff2c04`): This is because the private inputs are too big and cannot be specify in command inputs. Thus we change cli to read it from file.
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
5. Run (note: this runs setup, dryrun, prove, verify and continuation-batcher, so if you're only interested in dryrun you should comment out the extra commands):
    ```
    bash run.sh | tee stdout.txt
    ```
