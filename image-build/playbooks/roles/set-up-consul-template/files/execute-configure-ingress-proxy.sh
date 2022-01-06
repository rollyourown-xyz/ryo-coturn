#!/bin/sh

# Make configure-ingress-proxy.sh executable
chmod 775 /usr/local/bin/configure-ingress-proxy.sh

# Execute configure-ingress-proxy.sh
/usr/local/bin/configure-ingress-proxy.sh

# Wait 60s for certbot certificates to be obtained
sleep 60

# Restart coturn
/usr/local/bin/restart-coturn.sh
