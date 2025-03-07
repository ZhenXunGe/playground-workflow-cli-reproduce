## Backgournd

This is a image from our client which image is https://explorer.zkwasmhub.com/image/C5199A94F124235B544DF4D9809C8392
We find its dry run will take about 30 to 45 seconds (because each proof Guest Statics will be different)

This branch is to reproduce the long dry run time.

It is based on task: https://explorer.zkwasmhub.com/task/67ca121b986f484ddbaa957d

## How to use 
Image and inputs included in this branch, so you only need to run the following commands from the `playground-workflow-cli-reproduce` directory.

1. In a different terminal, from the `playground-workflow-cli-reproduce` directory, start the mongo db process on the default port (leave this running on its own terminal - note that we increase the ulimit because the dryrun sends many requests to the db which causes many files to be open at once):
    ```
    mkdir -p db
    ulimit -n 64000
    mongod --dbpath db
    ```
2. Return to your main terminal and restore the mongo db data by extracting mongo `zkwasm-mongo-merkle_slow_dryrun_C5199A.tar.gz` (It is put on our dev server under /home/yymone/yyu/temp folder) and running the restore command:
    ```
    cd data
    tar xvf zkwasm-mongo-merkle_slow_dryrun_C5199A.tar.gz
    mongorestore --db zkwasm-mongo-merkle --collection="DATAHASH_0000000000000000000000000000000000000000000000000000000000000000" 
    cd -
    ```
    Then run mongosh to go to mongo cli to rename the collections for cli:
    ```
    mongosh

    use zkwasm-mongo-merkle

    db.MERKLEDATA_c5199a94f124235b544df4d9809c839200000000000000000000000000000000.renameCollection("MERKLEDATA_0000000000000000000000000000000000000000000000000000000000000000")

    db.DATAHASH_c5199a94f124235b544df4d9809c839200000000000000000000000000000000.renameCollection("DATAHASH_0000000000000000000000000000000000000000000000000000000000000000")

    exit
    ```
    
3. Run
    ```
    bash setupEnv.sh
    ```
    under repo root folder. 
    It will do some further thing to copy our own zkwasm cli patch (this is for passing inputs via text file - note that this is specifically for zkwasm commit `branch=explorer-integration-3.0#35650d5e0eabb8ccba1908a27fcd27e0c0c0115a`): This is because the private inputs are too big and cannot be specify in command inputs. Thus we change cli to read it from file.
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
4. Run (note: this runs setup, dryrun only, other later process had been comment out):
    ```
    bash run.sh 2>&1 | tee stdout.txt
    ```
