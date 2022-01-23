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
  wait {
    min = "2s"
    max = "10s"
  }
}

# Template for dynamic iptables configuration based on consul key-values
template {
  source = "/etc/consul-template/iptables-rules.ctmpl"
  destination = "/usr/local/bin/iptables-rules.sh"
  command = "/usr/local/bin/iptables-rules.sh"
  wait {
    min = "2s"
    max = "10s"
  }
}

# Template for provisioning ryo-ingress-proxy for coturn
template {
  source = "/etc/consul-template/configure-ingress-proxy.sh.ctmpl"
  destination = "/usr/local/bin/configure-ingress-proxy.sh"
  command = "/usr/local/bin/execute-configure-ingress-proxy.sh"
  wait {
    min = "2s"
    max = "10s"
  }
}
