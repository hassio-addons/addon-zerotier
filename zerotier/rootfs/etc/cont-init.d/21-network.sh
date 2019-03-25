#!/usr/bin/with-contenv bashio
# ==============================================================================
# Community Hass.io Add-ons: ZeroTier One
# Creates ZeroTier One configuration in case it is non-existing
# ==============================================================================
readonly network=$(bashio::config 'network_id')

# Ensure network folder exists
mkdir -p "/var/lib/zerotier-one/networks.d" \
    || bashio::exit.nok "Could not create networks folder"

# Ensure the file exists. An empty file will cause automatic join.
touch "/data/network.${network}.conf"
ln -s \
    "/data/network.${network}.conf" \
    "/var/lib/zerotier-one/networks.d/${network}.conf" \
        || bashio::exit.nok "Could not create network file"
