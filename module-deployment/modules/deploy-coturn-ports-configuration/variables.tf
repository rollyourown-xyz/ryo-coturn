# SPDX-FileCopyrightText: 2022 Wilfred Nicoll <xyzroller@rollyourown.xyz>
# SPDX-License-Identifier: GPL-3.0-or-later

# Input variable definitions

variable "coturn_ip_addr_host_part" {
  description = "Host part of the IP address of the coturn container."
  type = number
}

variable "coturn_listening_port" {
  description = "TURN listener port for UDP and TCP."
  type = number
  default = 3478
}

variable "coturn_tls_listening_port" {
  description = "TURN listener port for TLS and DTLS."
  type = number
  default = 5349
}

variable "coturn_min_port" {
  description = "Lower bound of the coturn TURN server UDP relay endpoints."
  type = number
  default = 50000
}

variable "coturn_max_port" {
  description = "Upper bound of the coturn TURN server UDP relay endpoints."
  type = number
  default = 51000
}
