FROM plugins/base:linux-amd64

LABEL maintainer="namcxn" \
  org.label-schema.name="helm GCP push" \
  org.label-schema.vendor="namcxn" \
  org.label-schema.schema-version="1.0"

ENV HELM_VERSION=v3.16.3

ENV XDG_CONFIG_DIR=/opt
ENV XDG_DATA_HOME=/opt
ENV XDG_CACHE_HOME=/opt

RUN apk add curl tar bash --no-cache
RUN set -ex \
    && curl -sSL https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz | tar xz \
    && mv linux-amd64/helm /usr/local/bin/helm \
    && rm -rf linux-amd64 

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

