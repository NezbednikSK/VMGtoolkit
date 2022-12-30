#!/bin/sh
# SPDX-License-Identifier: GPL-3.0-or-later

# the sourced file should include the DEVICE_URL (e.g. http://192.168.100.1), the USERNAME and the PASSWORD
. "../VMGtoolkit_secrets.sh"

export "AESKEY=$(openssl rand -hex 32)"
export "IV=$(openssl rand -hex 16)"

echo "logging in to $DEVICE_URL as $USERNAME" >&2
echo "aes key: $AESKEY" >&2
echo "iv: $IV" >&2

export "COOKIES=$(mktemp)"
export "SESSIONKEY=$(./router_login.sh "$DEVICE_URL" "$USERNAME" "$PASSWORD" "$AESKEY" "$IV" 2> "$COOKIES")"

echo "session key: $SESSIONKEY" >&2
echo "---- cookies file ----" >&2
cat "$COOKIES" >&2
echo "---- cookies file ----" >&2

curl -s --cookie "$COOKIES" "$DEVICE_URL/cgi-bin/DAL?oid=nat_pcp" | ./router_decode_json.sh "$AESKEY"

echo "logging out" >&2
echo -n "response code: " >&2
./router_logout.sh "$DEVICE_URL" "$SESSIONKEY" "$COOKIES" >&2
rm "$COOKIES"
