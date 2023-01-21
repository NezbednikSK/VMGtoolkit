#!/bin/sh
# SPDX-License-Identifier: GPL-3.0-or-later

jq --raw-output ".Object[] | .ExternalIPAddress" pcp_data.json | head -n $1 | sed "s.:.\\n.g" | tail -n 1
