#!/bin/sh
# SPDX-License-Identifier: GPL-3.0-or-later

# parameters:
#  1. device IP address (e. g. http://192.168.100.1)
#  2. session key
#  3. cookie file (optional; stdin works aswell)

# dependencies: curl

if [ $# -lt 3 ]; then
  export "COOKIES=$(mktemp)"
  cat > "$COOKIES"
else
  export "COOKIES=$3"
fi

curl -s -o /dev/null -w "%{http_code}" -X POST --cookie "$COOKIES" -H "CSRFToken: $2" "$1/cgi-bin/UserLogout"
echo

if [ $# -lt 3 ]; then
  rm "$COOKIES"
fi
