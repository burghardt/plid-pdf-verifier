FROM ubuntu:22.04 AS builder
RUN apt-get update && \
    apt-get -y --no-install-recommends install \
        wget \
        openssl \
        libnss3-tools && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
COPY build-plid-nss.bash /usr/local/bin/build-plid-nss.bash
RUN /usr/local/bin/build-plid-nss.bash ./plid-nss

FROM ubuntu:22.04 AS verifier
RUN apt-get update && \
    apt-get -y --no-install-recommends install \
        poppler-utils && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder ./plid-nss /var/lib/plid-nss
COPY plid-verifier.bash /usr/bin/plid-verifier.bash
RUN chmod +x /usr/bin/plid-verifier.bash
ENTRYPOINT ["/usr/bin/plid-verifier.bash"]
