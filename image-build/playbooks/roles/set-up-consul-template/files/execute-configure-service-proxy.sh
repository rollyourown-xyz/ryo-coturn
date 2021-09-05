#!/bin/sh

# Make configure-service-proxy.sh executable
chmod 775 /usr/local/bin/configure-service-proxy.sh

# Execute configure-service-proxy.sh
/usr/local/bin/configure-service-proxy.sh

# Wait 60s for certbot certificates to be obtained
sleep 60

# Restart coturn
/usr/local/bin/restart-coturn.sh
