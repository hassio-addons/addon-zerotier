ARG BUILD_FROM=hassioaddons/base:4.0.3
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Setup base
# hadolint ignore=DL3003
RUN \
    apk add --no-cache --virtual .build-dependencies \
        build-base=0.5-r1 \
        linux-headers=4.19.36-r0 \
        git=2.22.0-r0 \
    \
    && apk add --no-cache \
        libgcc=8.3.0-r0 \
        libstdc++=8.3.0-r0 \
    \
    && git clone --branch "1.2.12" --depth=1 \
        "https://github.com/zerotier/ZeroTierOne.git" /tmp/zerotier \
    \
    && cd /tmp/zerotier \
    && make \
    && make install \
    \
    && rm -f -r /tmp/* \
    && apk del --purge .build-dependencies

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
    org.label-schema.description="Radically simplify your network with a virtual networking layer that works the same everywhere" \
    org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.name="ZeroTier One" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.url="https://community.home-assistant.io/?u=frenck" \
    org.label-schema.usage="https://github.com/hassio-addons/addon-zerotier/tree/master/README.md" \
    org.label-schema.vcs-ref=${BUILD_REF} \
    org.label-schema.vcs-url="https://github.com/hassio-addons/addon-zerotier" \
    org.label-schema.vendor="Community Hass.io Add-ons"
