#!/usr/bin/with-contenv bashio
# ==============================================================================
# Community Hass.io Add-ons: ZeroTier One
# Generates an identiy in case it does not exists yet
# ==============================================================================
readonly private='/ssl/zerotier/identity.secret'
readonly public='/ssl/zerotier/identity.public'
declare node

# Generate identity if it does not exist
if ! bashio::fs.file_exists "${private}" \
    || ! bashio::fs.file_exists "${public}";
then
    bashio::log.info "Generating identity files..."

    if bashio::fs.file_exists "${private}"; then
        rm -f "${private}" \
            || bashio::exit.nok "Failed to delete old private identify file"
    fi

    if bashio::fs.file_exists "${public}"; then
        rm -f "${public}" \
            || bashio::exit.nok "Failed to delete old private identify file"
    fi

    if ! bashio::fs.directory_exists '/ssl/zerotier'; then
        mkdir /ssl/zerotier \
            || bashio::exit.nok "Failed to create identity folder"
    fi

    zerotier-idtool generate "${private}" "${public}"
fi

ln -s "${private}" /var/lib/zerotier-one/identity.secret
ln -s "${public}" /var/lib/zerotier-one/identity.public

node=$(cut -d ':' -f1 < "${private}")
bashio::log.info "ZeroTier node address: ${node}"
