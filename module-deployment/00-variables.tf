# SPDX-FileCopyrightText: 2022 Wilfred Nicoll <xyzroller@rollyourown.xyz>
# SPDX-License-Identifier: GPL-3.0-or-later

# Input Variables
#################

variable "host_id" {
  description = "Mandatory: The host_id on which to deploy the module."
  type        = string
}

variable "image_version" {
  description = "Version of the images to deploy - Leave blank for 'terraform destroy'"
  type        = string
}

variable "listening_port" {
  description = "TURN listener port for UDP and TCP."
  type = number
  default = 3478
}

variable "tls_listening_port" {
  description = "TURN listener port for TLS and DTLS."
  type = number
  default = 5349
}

variable "min_port" {
  description = "Lower bound of the coturn TURN server UDP relay endpoints."
  type = number
  default = 50000
}

variable "max_port" {
  description = "Upper bound of the coturn TURN server UDP relay endpoints."
  type = number
  default = 51000
}


# Local variables
#################

# Configuration file paths
locals {
  module_configuration = "${abspath(path.root)}/../configuration/configuration.yml"
  host_configuration   = join("", ["${abspath(path.root)}/../../ryo-host/configuration/configuration_", var.host_id, ".yml" ])
}

# Basic module variables
locals {
  module_id                = yamldecode(file(local.module_configuration))["module_id"]
  coturn_ip_addr_host_part = yamldecode(file(local.module_configuration))["coturn_ip_addr_host_part"]
}

# LXD variables
locals {
  lxd_host_public_ipv6          = yamldecode(file(local.host_configuration))["host_public_ipv6"]
  lxd_host_control_ipv4_address = yamldecode(file(local.host_configuration))["host_control_ip"]
  lxd_host_network_part         = yamldecode(file(local.host_configuration))["lxd_host_network_part"]
  lxd_host_public_ipv6_address  = yamldecode(file(local.host_configuration))["host_public_ipv6_address"]
  lxd_host_public_ipv6_prefix   = yamldecode(file(local.host_configuration))["host_public_ipv6_prefix"]
  lxd_host_private_ipv6_prefix  = yamldecode(file(local.host_configuration))["lxd_host_private_ipv6_prefix"]
  lxd_host_network_ipv6_subnet  = yamldecode(file(local.host_configuration))["lxd_host_network_ipv6_subnet"]
}

# Calculated variables
locals {
  lxd_host_ipv6_prefix = ( local.lxd_host_public_ipv6 == true ? local.lxd_host_public_ipv6_prefix : local.lxd_host_private_ipv6_prefix )
}

# Consul variables
locals {
  consul_ip_address  = join("", [ local.lxd_host_ipv6_prefix, "::", local.lxd_host_network_ipv6_subnet, ":1" ])
}
