#!/bin/sh
# SPDX-License-Identifier: GPL-3.0-or-later

# parameters:
#  1. hex-encoded AES-256 key (length: 64)
#  2. content parameter from response
#      feel free to pass it directly from the JSON;
#      the first sed takes care of the escaping slashes
#  3. iv parameter from response

# dependencies: openssl, xxd, sed, cut
# sed, cut from busybox will work

echo "$2" | sed "s.\\\\..g" | openssl enc -d -a -A | openssl aes-256-cbc -d -K "$1" -iv "$(echo "$3" | openssl enc -d -a -A | xxd -c 0 -p | cut -b 1-32)"
echo
