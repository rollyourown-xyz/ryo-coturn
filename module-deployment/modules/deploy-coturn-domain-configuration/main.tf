# SPDX-FileCopyrightText: 2022 Wilfred Nicoll <xyzroller@rollyourown.xyz>
# SPDX-License-Identifier: GPL-3.0-or-later

terraform {
  required_version = ">= 0.15"
  required_providers {
    consul = {
      source = "hashicorp/consul"
      version = "~> 2.12.0"
    }
  }
}

resource "consul_keys" "coturn_domain" {

  key {
    path   = "service/coturn/coturn-domain"
    value  = var.coturn_domain
    delete = true
  }
}

resource "consul_keys" "coturn_domain_admin_email" {

  key {
    path   = "service/coturn/coturn-domain-admin-email"
    value  = var.coturn_domain_admin_email
    delete = true
  }
}
