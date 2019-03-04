# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# These variables are expected to be passed in by the operator
# ---------------------------------------------------------------------------------------------------------------------

variable "project" {
  description = "The project ID to create the resources in."
}

variable "region" {
  description = "The region to create the resources in."
}

variable "name" {
  description = "Name for the load balancer forwarding rule and prefix for supporting resources."
}

variable "url_map" {
  description = "The url_map resource to use."
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL MODULE PARAMETERS
# These variables have defaults, but may be overridden by the operator.
# ---------------------------------------------------------------------------------------------------------------------
variable "enable_ssl" {
  description = "Set to true to enable ssl. If set to 'true', you will also have to provide 'var.ssl_certificates'."
  default     = false
}

variable "ssl_certificates" {
  type        = "list"
  description = "List of SSL cert self links. Required if 'enable_ssl' is 'true' and 'use_managed_certificates'  ."
  default     = []
}

variable "use_managed_certificates" {
  description = "Use Google-managed SSL certificates. See https://cloud.google.com/load-balancing/docs/ssl-certificates#create-lb-managed-certs"
  default     = false
}

variable "enable_http" {
  description = "Set to true to enable plain http. Note that disabling http does not force SSL and/or redirect HTTP traffic. See https://issuetracker.google.com/issues/35904733"
  default     = true
}

variable "create_dns_entries" {
  description = "If set to true, create a DNS A Recordr in Cloud DNS for each domain specified in 'custom_domain_names'."
  default     = false
}

variable "custom_domain_names" {
  description = "List of custom domain names."
  type        = "list"
  default     = []
}

variable "dns_managed_zone_name" {
  description = "The name of the Cloud DNS Managed Zone in which to create the DNS A Records specified in 'var.custom_domain_names'. Only used if 'var.create_dns_entries' is true."
  default     = "replace-me"
}

variable "dns_record_ttl" {
  description = "The time-to-live for the site A records (seconds)"
  default     = 300
}

variable "custom_labels" {
  description = "A map of custom labels to apply to the resources. The key is the label name and the value is the label value."
  type        = "map"
  default     = {}
}
