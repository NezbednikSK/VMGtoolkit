#!/bin/sh
# SPDX-License-Identifier: GPL-3.0-or-later

# the sourced file should include the DEVICE_URL (e.g. http://192.168.100.1), the USERNAME and the PASSWORD
. "../VMGtoolkit_secrets.sh"

export "DO_LOGIN=1"
if [ -f saved_login.sh ]; then
    . "./saved_login.sh"
    export "COOKIES=$(mktemp)"
    echo "$_COOKIES" | openssl enc -d -a -A > "$COOKIES"

    export "CODE=$(curl -s -o /dev/null -w "%{http_code}" --cookie "$COOKIES" "$DEVICE_URL/cgi-bin/UserLoginCheck")"

    if [ "$CODE" = "200" ]; then
        export "DO_LOGIN=0"
    fi
fi

if [ "$DO_LOGIN" = "1" ]; then
    export "AESKEY=$(openssl rand -hex 32)"
    export "IV=$(openssl rand -hex 16)"

    export "COOKIES=$(mktemp)"
    export "SESSIONKEY=$(./router_login.sh "$DEVICE_URL" "$USERNAME" "$PASSWORD" "$AESKEY" "$IV" 2> "$COOKIES")"

    echo "export \"AESKEY=$AESKEY\"" > saved_login.sh
    echo "export \"IV=$IV\"" >> saved_login.sh
    echo "export \"SESSIONKEY=$SESSIONKEY\"" >> saved_login.sh
    echo "export \"_COOKIES=$(openssl enc -e -a -A -in "$COOKIES")\"" >> saved_login.sh
fi

curl -s --cookie "$COOKIES" "$DEVICE_URL/cgi-bin/DAL?oid=nat_pcp" | ./router_decode_json.sh "$AESKEY"

rm "$COOKIES"
