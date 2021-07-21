# Deploy Coturn for rollyourown.xyz projects
############################################

resource "lxd_container" "coturn" {

  remote     = var.host_id
  name       = join("-", [ var.host_id, local.module_id, "coturn" ])
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
      "ipv4.address" = join(".", [ local.lxd_host_network_part, "20" ])
    }
  }
  
  ## Add proxy devices for the module

  ### UDP Port 3478
  device {
    name = "proxy0"
    type = "proxy"

    properties = {
      listen  = join("", [ "udp:", local.lxd_host_public_ipv4_address, ":3478" ] )
      connect = join("", [ "udp:", local.lxd_host_network_part, ".20", ":3478" ] )
      nat     = "yes"
    }
  }

  ### TCP Port 3478
  device {
    name = "proxy1"
    type = "proxy"

    properties = {
      listen  = join("", [ "tcp:", local.lxd_host_public_ipv4_address, ":3478" ] )
      connect = join("", [ "tcp:", local.lxd_host_network_part, ".20", ":3478" ] )
      nat     = "yes"
    }
  }

  ### UDP Port 5349
  device {
    name = "proxy2"
    type = "proxy"

    properties = {
      listen  = join("", [ "udp:", local.lxd_host_public_ipv4_address, ":5349" ] )
      connect = join("", [ "udp:", local.lxd_host_network_part, ".20", ":5349" ] )
      nat     = "yes"
    }
  }

  ### TCP Port 5349
  device {
    name = "proxy3"
    type = "proxy"

    properties = {
      listen  = join("", [ "tcp:", local.lxd_host_public_ipv4_address, ":5349" ] )
      connect = join("", [ "tcp:", local.lxd_host_network_part, ".20", ":5349" ] )
      nat     = "yes"
    }
  }

  ### UDP Ports 50000-51000
  device {
    name = "proxy4"
    type = "proxy"

    properties = {
      listen  = join("", [ "udp:", local.lxd_host_public_ipv4_address, ":50000-51000" ] )
      connect = join("", [ "udp:", local.lxd_host_network_part, ".20", ":50000-51000" ] )
      nat     = "yes"
    }
  }

  ### Mount container directory for non-concatenated letsencrypt certificates (used by other containers)
  device {
    name = "non-concat-certs"
    type = "disk"
    
    properties = {
      source   = "/var/containers/ryo-service-proxy/tls/non-concatenated"
      path     = "/etc/turn/tls"
      readonly = "true"
      shift    = "true"
    }
  }
}

