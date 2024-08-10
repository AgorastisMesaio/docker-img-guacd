#!/usr/bin/env bash
#
# entrypoint.sh for Guacd
#

# Variables
export CONFIG_ROOT=/config
CONFIG_ROOT_MOUNT_CHECK=$(mount | grep ${CONFIG_ROOT})

# Run the arguments from CMD in the Dockerfile
# In our case we are starting nginx by default
exec "$@"
