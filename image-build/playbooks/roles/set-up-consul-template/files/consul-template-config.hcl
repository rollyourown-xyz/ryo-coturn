# SPDX-FileCopyrightText: 2022 Wilfred Nicoll <xyzroller@rollyourown.xyz>
# SPDX-License-Identifier: GPL-3.0-or-later

consul {
  address = "127.0.0.1:8500"
  
  auth {
    enabled = false
  }
  
  retry {
    enabled  = true
    attempts = 0
    backoff = "250ms"
    max_backoff = "1m"
  }
}

# Template for dynamic coturn configuration based on consul key-values
template {
  source = "/etc/consul-template/turnserver.conf.ctmpl"
  destination = "/etc/turnserver.conf"
  command = "/usr/local/bin/restart-coturn.sh"
}

# Template for dynamic nftables configuration based on consul key-values
template {
  source = "/etc/consul-template/nftables.ctmpl"
  destination = "/etc/nftables.conf"
  command = "/usr/local/bin/reload-nftables.sh"
}

# Template for provisioning ryo-ingress-proxy for coturn
template {
  source = "/etc/consul-template/configure-ingress-proxy.sh.ctmpl"
  destination = "/usr/local/bin/configure-ingress-proxy.sh"
  command = "/usr/local/bin/execute-configure-ingress-proxy.sh"
}
