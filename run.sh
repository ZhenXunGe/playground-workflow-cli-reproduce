#!/bin/bash

IMAGEDIR="./images"
PARAMSDIR="./params"
OUTPUTDIR="./output"

# use zkwasm cli to generate proof
ZKWASM_CLI=./zkWasm/target/release/zkwasm-cli
SCHEME="--scheme shplonk"

set -e
set -x

test_continuation_cli() {
    rm -rf $PARAMSDIR/*.data $PARAMSDIR/*.config $OUTPUTDIR
    $ZKWASM_CLI --params $PARAMSDIR image setup $SCHEME
    $ZKWASM_CLI --params $PARAMSDIR image dry-run --wasm $IMAGEDIR/image.wasm --public 2:i64 --private 1:i64 --ctxin 50:i64 --output ./output
    CUDA_VISIBLE_DEVICES=0 $ZKWASM_CLI --params $PARAMSDIR image prove --public 2:i64 --private 1:i64 --ctxin 50:i64 --padding 3 --wasm $IMAGEDIR/image.wasm --output $OUTPUTDIR
    $ZKWASM_CLI --params $PARAMSDIR image verify --output $OUTPUTDIR
}


#x=50
#while [ $x -gt 0 ]; do
#    test_phantom_cli
    test_continuation_cli
#    x=$(($x-1))
#done


# use continuation-batcher to generate aggr proof
BATCHCONFIGDIR="./continuation-batcher"


BATCH_INFO_INIT=$BATCHCONFIGDIR/sample/cont-init.json
BATCH_INFO_RECT=$BATCHCONFIGDIR/sample/cont-rec.json
BATCH_INFO_FINAL=$BATCHCONFIGDIR/sample/cont-final.json

BATCHER_CLI=$BATCHCONFIGDIR/target/release/circuit-batcher

# Make sure the name field in fibonacci.loadinfo.json is changed to single to fit the above batch configure
CUDA_VISIBLE_DEVICES=0 RUST_BACKTRACE=1 $BATCHER_CLI --params $PARAMSDIR --output $OUTPUTDIR batch -k 23  -s shplonk --challenge keccak --info $OUTPUTDIR/image.loadinfo.json --name image_aggr --commits $BATCH_INFO_INIT $BATCH_INFO_RECT $BATCH_INFO_FINAL --cont 6

$BATCHER_CLI --params $PARAMSDIR --output $OUTPUTDIR verify --challenge keccak --info $OUTPUTDIR/image_aggr.final.loadinfo.json
