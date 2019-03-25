#!/usr/bin/with-contenv bashio
# ==============================================================================
# Community Hass.io Add-ons: ZeroTier One
# Sets the auth token for the local JSON API
# ==============================================================================
declare token
if bashio::config.has_value 'api_auth_token'; then
    token=$(bashio::config 'api_auth_token')
    echo "${token}" > /data/authtoken.secret
fi
