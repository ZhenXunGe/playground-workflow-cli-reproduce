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
