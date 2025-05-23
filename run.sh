#!/bin/bash

IMAGEDIR="./images"
PARAMSDIR="./params"
OUTPUTDIR="./output"
ZKWASM_CLI=./zkWasm/target/release/zkwasm-cli

set -e
set -x

rm -rf $PARAMSDIR/*.data $PARAMSDIR/*.config $OUTPUTDIR || exit 1
$ZKWASM_CLI --params $PARAMSDIR image setup --wasm $IMAGEDIR/B015626BE37658AFCAAFA33F8566D5FC.wasm --scheme shplonk --host standard
