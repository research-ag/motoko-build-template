#!/bin/bash

MOC_ARGS="" ## place args like compacting-gc, incremental-gc here
OUT=out/out_$(uname -s)_$(uname -m).wasm
moc src/main.mo -o $OUT -c -no-check-ir --release --public-metadata candid:service --public-metadata candid:args $(mops sources) ${MOC_ARGS}
ic-wasm $OUT -o $OUT shrink
if [ -f did/service.did ]; then
    echo "Adding service.did to metadata section."
    ic-wasm $OUT -o $OUT metadata candid:service -f did/service.did -v public
else
    echo "service.did not found. Skipping metadata update."
fi
if [ "$compress" == "yes" ] || [ "$compress" == "y" ]; then
  gzip -nf $OUT
  sha256sum $OUT.gz
else
  sha256sum $OUT
fi
