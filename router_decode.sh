#!/bin/sh
# SPDX-License-Identifier: GPL-3.0-or-later

# parameters:
#  1. hex-encoded AES-256 key (length: 64)
#  2. content parameter from response
#  3. iv parameter from response

# dependencies: openssl, xxd, jq

echo "$2" | openssl enc -d -a -A | openssl enc -aes-256-cbc -d -K "$1" -iv "$(jq --null-input --raw-output -M --arg s "$(echo "$3" | openssl enc -d -a -A | xxd -c 0 -p)" '$s[0:32]')"
echo
