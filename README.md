# plid-pdf-verifier
plid-pdf-verifier - PDF signature verifier for digital certificates issued
by the Government of the Republic of Poland as a Docker container image

[pl.ID](https://plid.obywatel.gov.pl/) is a Polish government PKI project for
publicly available digital signing tools and certificates. A free basic
e-signature that can be verified with this tool is provided by the
[Polish national identity card](https://en.wikipedia.org/wiki/Polish_identity_card)
(pol. dowód osobisty) issued after February 2019.

This repository contains independently developed tooling for creating
[NSS database](https://firefox-source-docs.mozilla.org/security/nss/index.html)
from data available at `repo.e-dowod.gov.pl` and performing verification with
`pdfsig` on PDF files for signature and certificate chain validation.

## Usage

    docker run --rm -it -v "$PWD:/pwd" ghcr.io/burghardt/plid-pdf-verifier signed.pdf

### Sample output

    Digital Signature Info of: /pwd/signed.pdf
    Signature #1:
      - Signer Certificate Common Name: KRZYSZTOF BURGHARDT
      - Signer full Distinguished Name: C=PL,SN=BURGHARDT,givenName=KRZYSZTOF,<REDACTED>
      - Signing Time: Mar 10 2023 <REDACTED>
      - Signing Hash Algorithm: SHA-384
      - Signature Type: ETSI.CAdES.detached
      - Signed Ranges: [0 - <REDACTED>], [<REDACTED> - <REDACTED>]
      - Total document signed
      - Signature Validation: Signature is Valid.
      - Certificate Validation: Certificate is Trusted.

The most important lines (besides the signer details) are `Signature is Valid`
and `Certificate is Trusted`.

## Certificate chain

The root certificate is available at
http://repo.e-dowod.gov.pl/certs/PLID_Root_CA.cer and decodes as:

    $ openssl x509 -noout -text -inform der -in PLID_Root_CA.cer
    Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number:
            2e:96:f5:99:0b:4d:0b:93:e0:e6:c1:3c:82:71:cd:4b
        Signature Algorithm: ecdsa-with-SHA512
        Issuer: CN = pl.ID Root CA, serialNumber = 2019, C = PL
        Validity
            Not Before: Feb 15 11:38:03 2019 GMT
            Not After : Feb 16 11:38:03 2044 GMT
        Subject: CN = pl.ID Root CA, serialNumber = 2019, C = PL
        Subject Public Key Info:
            Public Key Algorithm: id-ecPublicKey
                Public-Key: (384 bit)
                pub:
                    04:12:64:a8:61:b8:e5:70:19:89:df:9a:e0:bd:b5:
                    c7:5c:80:95:cc:4b:d0:ea:e1:f4:0c:78:c6:07:27:
                    15:70:cd:17:b6:e6:d7:c3:9b:ae:74:08:ee:f4:d8:
                    7d:bb:5d:fc:51:64:cf:d0:72:01:cf:27:f9:8f:bb:
                    1e:20:c3:fb:4f:f0:5f:31:e8:57:1a:6e:8c:f4:04:
                    00:73:e8:d3:a3:ce:27:4c:ce:91:97:3e:86:0b:bd:
                    53:8e:fd:23:7b:08:ba
                ASN1 OID: secp384r1
                NIST CURVE: P-384
        X509v3 extensions:
            X509v3 Basic Constraints: critical
                CA:TRUE
            X509v3 Authority Key Identifier:
                keyid:55:D1:52:32:BC:EF:CA:EC:FE:33:B0:18:E7:37:EE:E3:B8:2F:AB:47

            X509v3 Subject Key Identifier:
                55:D1:52:32:BC:EF:CA:EC:FE:33:B0:18:E7:37:EE:E3:B8:2F:AB:47
            X509v3 Key Usage: critical
                Certificate Sign, CRL Sign
    Signature Algorithm: ecdsa-with-SHA512
         30:65:02:31:00:c1:55:78:df:a5:7d:ca:01:10:21:02:2e:b0:
         34:9b:75:67:55:f8:ae:be:9a:2c:1f:e5:63:60:bd:6f:22:4e:
         44:69:ed:ba:91:a1:2e:97:3a:f2:fc:69:60:4f:ff:4d:28:02:
         30:2c:c6:9d:be:71:3d:59:a4:1d:25:75:75:1b:64:53:cc:6a:
         d3:b3:dd:52:a5:e5:35:4a:bd:fd:92:de:8c:30:22:7e:eb:70:
         31:bb:2a:ef:b1:58:6f:6f:f7:d4:c2:23:1f

The [certyfikaty_pl.ID.txt](http://repo.e-dowod.gov.pl/certs/certyfikaty_pl.ID.txt)
file lists all other (intermediate) certificates required to build the chain.
