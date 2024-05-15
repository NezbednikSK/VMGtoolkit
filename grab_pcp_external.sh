#!/bin/sh
cd "$(dirname "$0")"
export "NEWIP=$(./grab_pcp.sh | jq -M --raw-output --arg "port" "$1" ".Object | sort_by(.RequiredInternalPort) | .[] | select(.RequiredInternalPort | tostring | startswith(\$port)) | .ExternalIPAddress | split(\":\") | last" | tail -n1)"
if ! [ "$NEWIP" = "0.0.0.0" ]; then
	echo "$NEWIP"
else
	exit 1
fi
