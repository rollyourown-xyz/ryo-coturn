terraform {
  required_version = ">= 0.15"
  required_providers {
    consul = {
      source = "hashicorp/consul"
      version = "~> 2.12.0"
    }
  }
}

resource "consul_keys" "ip_addr_host_part" {

  key {
    path   = "service/coturn/ip-addr-host-part"
    value  = var.coturn_ip_addr_host_part
    delete = true
  }
}

resource "consul_keys" "listening_port" {

  key {
    path   = "service/coturn/listening-port"
    value  = var.coturn_listening_port
    delete = true
  }
}

resource "consul_keys" "tls_listening_port" {

  key {
    path   = "service/coturn/tls-listening-port"
    value  = var.coturn_tls_listening_port
    delete = true
  }
}

resource "consul_keys" "min_port" {

  key {
    path   = "service/coturn/min-port"
    value  = var.coturn_min_port
    delete = true
  }
}

resource "consul_keys" "max_port" {

  key {
    path   = "service/coturn/max-port"
    value  = var.coturn_max_port
    delete = true
  }
}

