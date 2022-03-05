#!/bin/sh
# SPDX-FileCopyrightText: 2022 Wilfred Nicoll <xyzroller@rollyourown.xyz>
# SPDX-License-Identifier: GPL-3.0-or-later


# Make configure-ingress-proxy.sh executable
chmod 775 /usr/local/bin/configure-ingress-proxy.sh

# Execute configure-ingress-proxy.sh
/usr/local/bin/configure-ingress-proxy.sh

# Wait 60s for certbot certificates to be obtained
sleep 60

# Restart coturn
/usr/local/bin/restart-coturn.sh
