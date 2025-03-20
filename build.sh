#!/bin/bash
pushd "$(dirname "$0")"
for script in ./build-scripts/*.sh;
do
  "$script"
done
popd
