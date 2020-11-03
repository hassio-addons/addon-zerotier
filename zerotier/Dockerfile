ARG BUILD_FROM=hassioaddons/base:8.0.5
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# We need to copy in the patches need during build
COPY rootfs/patches /patches

# Setup base
# hadolint ignore=DL3003
RUN \
    apk add --no-cache --virtual .build-dependencies \
        build-base=0.5-r2 \
        linux-headers=5.4.5-r1 \
        git=2.26.2-r0 \
    \
    && apk add --no-cache \
        libgcc=9.3.0-r2 \
        libstdc++=9.3.0-r2 \
    \
    && git clone --branch "1.4.6" --depth=1 \
        "https://github.com/zerotier/ZeroTierOne.git" /tmp/zerotier \
    \
    && cd /tmp/zerotier \
    && patch -p1 < /patches/ZeroTierOne/gcc9-compat.patch \
    && make \
    && make install \
    \
    && apk del --no-cache --purge .build-dependencies \
    && rm -f -r /tmp/*

# Copy root filesystem
COPY rootfs /

# Build arguments
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_REF
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="ZeroTier One" \
    io.hass.description="Radically simplify your network with a virtual networking layer that works the same everywhere" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Franck Nijhof <frenck@addons.community>" \
    org.opencontainers.image.title="ZeroTier One" \
    org.opencontainers.image.description="Radically simplify your network with a virtual networking layer that works the same everywhere" \
    org.opencontainers.image.vendor="Home Assistant Community Add-ons" \
    org.opencontainers.image.authors="Franck Nijhof <frenck@addons.community>" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.url="https://addons.community" \
    org.opencontainers.image.source="https://github.com/hassio-addons/addon-zerotier" \
    org.opencontainers.image.documentation="https://github.com/hassio-addons/addon-zerotier/blob/master/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}
