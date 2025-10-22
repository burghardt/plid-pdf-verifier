#!/bin/sh
exec pdfsig -nssdir /var/lib/plid-nss "/pwd/$@"
