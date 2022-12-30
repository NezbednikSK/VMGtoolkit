#!/bin/sh
# SPDX-License-Identifier: GPL-3.0-or-later

# parameters:
#  1. device IP address (e. g. http://192.168.100.1)
#  2. hex-encoded AES-256 key (length: 64)

# dependencies: openssl, curl, jq, xxd, mktemp
# mktemp from busybox will work

export "RSA_TEMP=$(mktemp)"
curl -s "$1/getRSAPublickKey" | jq --raw-output -M .RSAPublicKey > "$RSA_TEMP"

echo -n "$2" | xxd -r -p | openssl enc -a -A | openssl rsautl -inkey "$RSA_TEMP" -pubin -encrypt | openssl enc -a -A
echo

rm "$RSA_TEMP"
