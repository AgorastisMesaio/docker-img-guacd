# Dockerfile for Guacd image
#
# This Dockerfile sets up a standard Guacd container that you can use
# inside your docker compose projects or standalone.
#
FROM guacamole/guacd:1.5.5

# Add a custom health check
# In this example, we'll check if port 4822 (default guacd port) is open and listening
# --interval=30s: Docker will run the health check every 30 seconds.
# --timeout=10s: Docker will wait 10 seconds for the health check to succeed.
# --start-period=5s: Docker will wait 5 seconds before performing the first health check. This gives the container some time to start up.
# --retries=3: Docker will retry the health check 3 times before considering the container as unhealthy.
# CMD nc -z localhost 4822 || exit 1: This command checks if port 4822 is open on localhost. If it fails, the container is considered unhealthy.
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD nc -z localhost 4822 || exit 1
