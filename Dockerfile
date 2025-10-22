FROM alpine:3.22.2 AS builder
RUN apk add --no-cache \
        bash \
        wget \
        openssl \
        nss-tools
COPY build-plid-nss.bash /usr/local/bin/build-plid-nss.bash
RUN bash /usr/local/bin/build-plid-nss.bash ./plid-nss

FROM alpine:3.22.2 AS verifier
RUN apk add --no-cache \
        poppler-utils
COPY --from=builder ./plid-nss /var/lib/plid-nss
COPY plid-verifier.sh /usr/bin/plid-verifier.sh
RUN chmod +x /usr/bin/plid-verifier.sh
ENTRYPOINT ["/usr/bin/plid-verifier.sh"]
