#!/bin/sh
# SPDX-License-Identifier: GPL-3.0-or-later

# parameters:
#  1. hex-encoded AES-256 key (length: 64)
#  2. .json file (optional; stdin works aswell)

# dependencies: jq

if [ $# -gt 1 ]; then
  export "CONTENT=$(jq --raw-output -M .content "$2")"
  export "IV=$(jq --raw-output -M .iv "$2")"
else
  export "INPUT=$(cat)"
  export "CONTENT=$(echo -n "$INPUT" | jq --raw-output -M .content)"
  export "IV=$(echo -n "$INPUT" | jq --raw-output -M .iv)"
fi

./router_decode.sh "$1" "$CONTENT" "$IV"
