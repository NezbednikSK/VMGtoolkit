#!/bin/sh
# SPDX-License-Identifier: GPL-3.0-or-later

# parameters:
#  1. hex-encoded AES-256 key (length: 64)
#  2. hex-encoded IV (length: 32)
#  3. body
#  4. key (optional)

# dependencies: openssl, xxd

echo -n "{\"content\": \"$(echo -n "$3" | openssl enc -aes-256-cbc -a -A -K "$1" -iv "$2")\", \"iv\": \"$(echo -n "$2" | xxd -r -p | openssl enc -a -A)\""
if [ $# -gt 3 ]; then
  echo ",\"key\": \"$4\"}"
else
  echo "}"
fi
