#!/bin/sh
# SPDX-License-Identifier: GPL-3.0-or-later

cd "$(dirname "$0")"
./grab_pcp.sh 2>/dev/null >./pcp_data.json
