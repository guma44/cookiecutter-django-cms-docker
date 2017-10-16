#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset


echo "listing available backups"
echo "-------------------------"
ls -lt /backups | awk '{print $6, $7, $8, $9}'
