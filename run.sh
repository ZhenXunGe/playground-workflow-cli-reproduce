#!/bin/bash

IMAGEDIR="./images"
PARAMSDIR="./params"
OUTPUTDIR="./output"

# use zkwasm cli to generate proof
ZKWASM_CLI=./zkWasm/target/release/zkwasm-cli

set -e
set -x

rm -rf $PARAMSDIR/*.data $PARAMSDIR/*.config $OUTPUTDIR

test_continuation_cli() {
    $ZKWASM_CLI --params $PARAMSDIR image setup --host standard
    $ZKWASM_CLI --params $PARAMSDIR image dry-run --wasm $IMAGEDIR/image.wasm --public 4164164773963033102:i64,10324589875679153781:i64,14862395446985487215:i64,5454683332844662963:i64 --private 123:i64,0:i64,0:i64,2:i64,0:i64,1:i64 --output ./output
    CUDA_VISIBLE_DEVICES=0 $ZKWASM_CLI --params $PARAMSDIR image prove --public 4164164773963033102:i64,10324589875679153781:i64,14862395446985487215:i64,5454683332844662963:i64 --private 123:i64,0:i64,0:i64,2:i64,0:i64,1:i64 --padding 3 --wasm $IMAGEDIR/image.wasm --output $OUTPUTDIR
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
CUDA_VISIBLE_DEVICES=0 RUST_BACKTRACE=1 $BATCHER_CLI --params $PARAMSDIR --output $OUTPUTDIR batch -k 22  -s shplonk --challenge keccak --info $OUTPUTDIR/image.loadinfo.json --name image_aggr --commits $BATCH_INFO_INIT $BATCH_INFO_RECT $BATCH_INFO_FINAL --cont 6

$BATCHER_CLI --params $PARAMSDIR --output $OUTPUTDIR verify --challenge keccak --info $OUTPUTDIR/image_aggr.final.loadinfo.json