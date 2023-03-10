#!/usr/bin/env bash
set -x
set -euo pipefail

pdfsig -nssdir /var/lib/plid-nss "/pwd/$1"
