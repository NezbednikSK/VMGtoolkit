#!/bin/sh
# SPDX-License-Identifier: GPL-3.0-or-later

# parameters:
#  1. device IP address (e.g. http://192.168.100.1)
#  2. account name
#  3. account password
#  4. hex-encoded AES-256 key (length: 64)
#  5. hex-encoded IV (length: 32)

# dependencies: openssl, curl, jq, mktemp
# mktemp from busybox will work

export "RSAKEY=$(./router_key.sh "$1" "$4")"

export "LOGIN_CONTENT={\"Input_Account\": \"$2\", \"Input_Passwd\": \"$(echo -n "$3" | openssl enc -a -A)\", \"RememberPassword\": 0, \"SHA512_password\": false}"

export "LOGIN_REQUEST=$(./router_encode.sh "$4" "$5" "$LOGIN_CONTENT" "$RSAKEY")"

export "COOKIE_TEMP=$(mktemp)"
export "RESPONSE_TEMP=$(mktemp)"
curl -s -o"$RESPONSE_TEMP" --cookie-jar "$COOKIE_TEMP" -H "Content-Type: application/json" --data-raw "$LOGIN_REQUEST" "$1/UserLogin"

./router_decode_json.sh "$4" "$RESPONSE_TEMP" | jq --raw-output -M .sessionkey

cat "$COOKIE_TEMP" >&2
rm "$RESPONSE_TEMP" "$COOKIE_TEMP"
