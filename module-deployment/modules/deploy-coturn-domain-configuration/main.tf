terraform {
  required_version = ">= 0.14"
  required_providers {
    consul = {
      source = "hashicorp/consul"
      version = "~> 2.12.0"
    }
  }
}

resource "consul_keys" "turn_domain" {

  key {
    path   = "service/coturn/turn-domain"
    value  = var.coturn_domain
    delete = true
  }
}
