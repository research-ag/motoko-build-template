#!/bin/bash

MOC_GC_FLAGS="" ## place any additional flags like compacting-gc, incremental-gc here
MOC_FLAGS="$MOC_GC_FLAGS -no-check-ir --release --public-metadata candid:service --public-metadata candid:args"
CANISTER_ALIAS="main2"
MAIN_FILE="src/main2.mo"
DID_FILE="did/service.did"

OUT=out/${CANISTER_ALIAS}_$(uname -s)_$(uname -m).wasm
mops-cli build --lock --name ${CANISTER_ALIAS} ${MAIN_FILE} -- $MOC_FLAGS
cp target/${CANISTER_ALIAS}/${CANISTER_ALIAS}.wasm $OUT
ic-wasm $OUT -o $OUT shrink
if [ -f $DID_FILE ]; then
    echo "Adding service did to metadata section."
    ic-wasm $OUT -o $OUT metadata candid:service -f ${DID_FILE} -v public
else
    echo "service did not found. Skipping metadata update."
fi
if [ "$compress" == "yes" ] || [ "$compress" == "y" ]; then
  gzip -nf $OUT
  sha256sum $OUT.gz
else
  sha256sum $OUT
fi
