# playground-workflow-cli-reproduce
This repo is the reproduce env to use zkWasm and continuation-batcher cli to reproduce issues in playground
Main branch is a success workflow for a simple image
For each issue it should be a seperate branch with different version of zkwasm/batcher so we can track the issues

## How to use it
1. Check setupEnv.sh and modify the submodule zkWasm and continuation-batcher version to the version you want to reproduce issues
2. `bash setupEnv.sh`
3. put the issue image into images folder
4. adjust the cli command in "run.sh" for zkwasm and continuation-batcher command with your issue inputs. (like those --public, --private inputs, etc)
5. `bash run.sh`

## Issue
This image is from explorer server MD5 F4A9101BD7C033F3E57EFB0F9F68C4D8, which always fail at the aggr rec 1 proof with error like:
Proof failed: Panic running proof: assertion failed: `(left == right)`
  left: `0x000000000039c3f57d9df2a79cc4c224f06202c08852beb95310cc42bd1cf265`,
 right: `0x0000000000e50fa5b4af5790136a437688dac65f56094801af145156b21784bb`.
