#!/bin/sh
set -e

##
# Entrypoint script preferences
##
# Required ENV
readonly required_env_names="\
LEGO_ADMIN_EMAIL \
LEGO_DNS_PROVIDER \
LEGO_ACCEPT_TOS \
"

##
# Start container service
##
echo "[I] Initializing service..." && true 1>&2

##
# Prepare service ENV
##
# Check required ENV.
for required_env_name in $required_env_names; do
    if [ -z "$(eval echo "\$$required_env_name")" ]; then
        echo "[F] ENV value '$required_env_name' is not set!" >&2
        exit 1
    fi
done

##
# Run service
##
echo "[I] Service initialization complete!" && true 1>&2
echo "[I] Starting..." && true 1>&2
exec "$@"