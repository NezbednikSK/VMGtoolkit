#!/bin/sh
cd "$(dirname "$0")"
./grab_pcp.sh | jq -M --raw-output --arg "port" "$1" ".Object[] | select(.RequiredInternalPort | tostring | startswith(\$port)) | .ExternalIPAddress" | sed "s.:.\\n.g" | tail -n 1
