ARG BUILD_FROM=ghcr.io/hassio-addons/base:12.2.3
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Setup base
# hadolint ignore=DL3003
RUN \
    apk add --no-cache --virtual .build-dependencies \
        build-base=0.5-r3 \
        cargo=1.60.0-r2 \
        git=2.36.2-r0 \
        linux-headers=5.16.7-r1 \
        openssl-dev=1.1.1q-r0 \
        pkgconf=1.8.0-r1 \
    \
    && apk add --no-cache \
        libgcc=11.2.1_git20220219-r2 \
        libstdc++=11.2.1_git20220219-r2 \
    \
    && git clone --branch "1.10.1" --depth=1 \
        "https://github.com/zerotier/ZeroTierOne.git" /tmp/zerotier \
    \
    && cd /tmp/zerotier \
    && CARGO_NET_GIT_FETCH_WITH_CLI=true make \
    && make install \
    \
    && apk del --no-cache --purge .build-dependencies \
    && rm -f -r \
        /root/.cargo \
        /tmp/*

# Copy root filesystem
COPY rootfs /

# Build arguments
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_DESCRIPTION
ARG BUILD_NAME
ARG BUILD_REF
ARG BUILD_REPOSITORY
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="${BUILD_NAME}" \
    io.hass.description="${BUILD_DESCRIPTION}" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Franck Nijhof <frenck@addons.community>" \
    org.opencontainers.image.title="${BUILD_NAME}" \
    org.opencontainers.image.description="${BUILD_DESCRIPTION}" \
    org.opencontainers.image.vendor="Home Assistant Community Add-ons" \
    org.opencontainers.image.authors="Franck Nijhof <frenck@addons.community>" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.url="https://addons.community" \
    org.opencontainers.image.source="https://github.com/${BUILD_REPOSITORY}" \
    org.opencontainers.image.documentation="https://github.com/${BUILD_REPOSITORY}/blob/main/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}
