#!/bin/bash

IMAGEDIR="./images"
PARAMSDIR="./params"
OUTPUTDIR="./output"

# use zkwasm cli to generate proof
ZKWASM_CLI=./zkWasm/target/release/zkwasm-cli
SCHEME="--scheme shplonk"

# example task: https://explorer.zkwasmhub.com/task/67ca121b986f484ddbaa957d
PUBLIC="10398975671558754644:i64,10577359050165925779:i64,17228164759120845098:i64,2382427754991859856:i64"
PRIVATE="data/private.txt"

set -e
set -x

test_continuation_cli() {
    rm -rf $PARAMSDIR/*.data $PARAMSDIR/*.config $OUTPUTDIR;
    time $ZKWASM_CLI --params $PARAMSDIR image setup $SCHEME;
    echo "Before dry run time: $(date +'%Y-%m-%d %H:%M:%S')"
    time $ZKWASM_CLI --params $PARAMSDIR image dry-run --wasm $IMAGEDIR/image.wasm \
        --public $PUBLIC \
        --private_file $PRIVATE \
        --output $OUTPUTDIR;
    echo "After dry run time: $(date +'%Y-%m-%d %H:%M:%S')"
    #time CUDA_VISIBLE_DEVICES=0 $ZKWASM_CLI --params $PARAMSDIR image prove \
        #--public $PUBLIC \
        #--private_file $PRIVATE \
        #--ctxin_file $CONTEXT \
        #--padding 3 --wasm $IMAGEDIR/image.wasm --output $OUTPUTDIR;
    #time $ZKWASM_CLI --params $PARAMSDIR image verify --output $OUTPUTDIR;
}


#x=50
#while [ $x -gt 0 ]; do
#    test_phantom_cli
    test_continuation_cli
#    x=$(($x-1))
#done


# use continuation-batcher to generate aggr proof
#BATCHCONFIGDIR="./continuation-batcher"


#BATCH_INFO_INIT=$BATCHCONFIGDIR/sample/cont-init.json
#BATCH_INFO_RECT=$BATCHCONFIGDIR/sample/cont-rec.json
#BATCH_INFO_FINAL=$BATCHCONFIGDIR/sample/cont-final.json

#BATCHER_CLI=$BATCHCONFIGDIR/target/release/circuit-batcher

# Make sure the name field in fibonacci.loadinfo.json is changed to single to fit the above batch configure
#CUDA_VISIBLE_DEVICES=0 RUST_BACKTRACE=1 $BATCHER_CLI --params $PARAMSDIR --output $OUTPUTDIR batch -k 22  -s shplonk --challenge keccak --info $OUTPUTDIR/image.loadinfo.json --name image_aggr --commits $BATCH_INFO_INIT $BATCH_INFO_RECT $BATCH_INFO_FINAL --cont 6

#$BATCHER_CLI --params $PARAMSDIR --output $OUTPUTDIR verify --challenge keccak --info $OUTPUTDIR/image_aggr.final.loadinfo.json
