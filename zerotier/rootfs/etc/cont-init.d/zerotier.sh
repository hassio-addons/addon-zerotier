#!/usr/bin/with-contenv bashio
# ==============================================================================
# Community Hass.io Add-ons: ZeroTier One
# Generates an identiy in case it does not exists yet
# ==============================================================================
readonly private='/ssl/zerotier/identity.secret'
readonly public='/ssl/zerotier/identity.public'
declare network
declare node
declare token

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

# Sets the auth token for the local JSON API
if bashio::config.has_value 'api_auth_token'; then
    token=$(bashio::config 'api_auth_token')
    echo "${token}" > /data/authtoken.secret
fi

# Ensure network folder exists
mkdir -p "/var/lib/zerotier-one/networks.d" \
    || bashio::exit.nok "Could not create networks folder"

# Install user configured/requested packages
if bashio::config.has_value 'networks'; then
    while read -r network; do
        bashio::log.info "Configuring network: ${network}"

        # Get network ID from secrets, if it is a secret
        if bashio::is_secret "${network}"; then
            network=$(bashio::secret "${network}")
        fi

        # Ensure the file exists. An empty file will cause automatic join.
        touch "/data/network.${network}.conf"
        ln -s \
            "/data/network.${network}.conf" \
            "/var/lib/zerotier-one/networks.d/${network}.conf" \
                || bashio::exit.nok "Could not create network file"
    done <<< "$(bashio::config 'networks')"

fi
