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

# Template for dynamic iptables configuration based on consul key-values
template {
  source = "/etc/consul-template/iptables-rules.ctmpl"
  destination = "/usr/local/bin/iptables-rules.sh"
  command = "/usr/local/bin/iptables-rules.sh"
}
