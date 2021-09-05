# Input variable definitions

variable "coturn_domain" {
  description = "Domain (e.g. coturn.example.com) for the coturn TURN server."
  type = string
}

variable "coturn_domain_admin_email" {
  description = "Admin email address for the certificate request for the coturn server domain."
  type = string
}
