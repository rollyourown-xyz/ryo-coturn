# SPDX-FileCopyrightText: 2022 Wilfred Nicoll <xyzroller@rollyourown.xyz>
# SPDX-License-Identifier: GPL-3.0-or-later

# Deploy Coturn for rollyourown.xyz projects
############################################

### Deploy consul KVs for coturn ports configuration

module "deploy-coturn-ports-configuration" {
  source = "./modules/deploy-coturn-ports-configuration"

  coturn_ip_addr_host_part  = local.coturn_ip_addr_host_part
  coturn_listening_port     = var.listening_port
  coturn_tls_listening_port = var.tls_listening_port
  coturn_min_port           = var.min_port
  coturn_max_port           = var.max_port
}


### Depoy coturn container
resource "lxd_container" "coturn" {

  remote     = var.host_id
  name       = "coturn"
  image      = join("-", [ local.module_id, "coturn", var.image_version ])
  profiles   = ["default"]
  
  config = { 
    "security.privileged": "false"
    "user.user-data" = file("cloud-init/cloud-init-basic.yml")
  }
  
  ## Provide eth0 interface with static IP address
  device {
    name = "eth0"
    type = "nic"

    properties = {
      name           = "eth0"
      network        = var.host_id
      "ipv4.address" = join(".", [ local.lxd_host_network_part, local.coturn_ip_addr_host_part ])
    }
  }
  
  ## Add proxy devices for the module

  ### UDP TURN listener port
  device {
    name = "proxy0"
    type = "proxy"

    properties = {
      listen  = join("", [ "udp:", local.lxd_host_control_ipv4_address, ":", var.listening_port ] )
      connect = join("", [ "udp:", local.lxd_host_network_part, ".", local.coturn_ip_addr_host_part, ":", var.listening_port ] )
      nat     = "yes"
    }
  }

  ### TCP TURN listener port
  device {
    name = "proxy1"
    type = "proxy"

    properties = {
      listen  = join("", [ "tcp:", local.lxd_host_control_ipv4_address, ":", var.listening_port ] )
      connect = join("", [ "tcp:", local.lxd_host_network_part, ".", local.coturn_ip_addr_host_part, ":", var.listening_port ] )
      nat     = "yes"
    }
  }

  ### DTLS TURN listener port
  device {
    name = "proxy2"
    type = "proxy"

    properties = {
      listen  = join("", [ "udp:", local.lxd_host_control_ipv4_address, ":", var.tls_listening_port ] )
      connect = join("", [ "udp:", local.lxd_host_network_part, ".", local.coturn_ip_addr_host_part, ":", var.tls_listening_port ] )
      nat     = "yes"
    }
  }

  ### TLS TURN listener port
  device {
    name = "proxy3"
    type = "proxy"

    properties = {
      listen  = join("", [ "tcp:", local.lxd_host_control_ipv4_address, ":", var.tls_listening_port ] )
      connect = join("", [ "tcp:", local.lxd_host_network_part, ".", local.coturn_ip_addr_host_part, ":", var.tls_listening_port ] )
      nat     = "yes"
    }
  }

  ### UDP Relay Ports
  device {
    name = "proxy4"
    type = "proxy"

    properties = {
      listen  = join("", [ "udp:", local.lxd_host_control_ipv4_address, ":", var.min_port, "-", var.max_port ] )
      connect = join("", [ "udp:", local.lxd_host_network_part, ".", local.coturn_ip_addr_host_part, ":", var.min_port, "-", var.max_port ] )
      nat     = "yes"
    }
  }

  ### Mount container directory for non-concatenated letsencrypt certificates from ryo-ingress-proxy
  device {
    name = "non-concat-certs"
    type = "disk"
    
    properties = {
      source   = "/var/containers/ryo-ingress-proxy/ingress-proxy/tls/non-concatenated"
      path     = "/etc/turn/tls"
      readonly = "true"
      shift    = "true"
    }
  }
}
