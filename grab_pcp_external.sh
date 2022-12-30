#!/bin/sh
# SPDX-License-Identifier: GPL-3.0-or-later

./grab_pcp.sh 2>/dev/null | jq --raw-output -M ".Object[$1].ExternalIPAddress" | sed "s.:.\\n.g" | tail -n 1
