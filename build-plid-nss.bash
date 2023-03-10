#!/usr/bin/env bash
set -x
set -euo pipefail

CA_URL='http://repo.e-dowod.gov.pl/certs'
CA_NAME='PLID_Root_CA.cer'
CA_HASH='5a545dc780b8400900b2c1400e871c43f0e0f3ad33ca31c508a9e9b1ab731095'
NSSDB_PATH="$1"

mkdir "${NSSDB_PATH}"
certutil -N --empty-password -d "${NSSDB_PATH}"

wget "${CA_URL}/${CA_NAME}"
echo "${CA_HASH} ${CA_NAME}" > "${CA_NAME}.sha256sum"
sha256sum -c PLID_Root_CA.cer.sha256sum

openssl x509 -noout -text -inform der -in ${CA_NAME}
certutil -A -n "$(basename ${CA_NAME})" -t ',C,' -d "${NSSDB_PATH}" \
    -i ${CA_NAME}

wget "${CA_URL}/certyfikaty_pl.ID.txt"
while IFS= read -r CER; do
    wget "${CA_URL}/$CER"
    openssl x509 -noout -text -inform der -in "$CER"
    certutil -A -n "$(basename "$CER")" -t ',,' -d "${NSSDB_PATH}" -i "$CER"
done < certyfikaty_pl.ID.txt

certutil -L -d "${NSSDB_PATH}"
