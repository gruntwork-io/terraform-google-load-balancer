# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# These variables are expected to be passed in by the operator
# ---------------------------------------------------------------------------------------------------------------------

variable "project" {
  description = "The project ID to create the resources in."
  type        = string
}

variable "region" {
  description = "All resources will be launched in this region."
  type        = string
}

variable "name" {
  description = "Name for the load balancer forwarding rule and prefix for supporting resources."
  type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL MODULE PARAMETERS
# These variables have defaults, but may be overridden by the operator.
# ---------------------------------------------------------------------------------------------------------------------

variable "network" {
  description = "Self link of the VPC network in which to deploy the resources."
  type        = string
  default     = "default"
}

variable "protocol" {
  description = "The protocol for the backend and frontend forwarding rule. TCP or UDP."
  type        = string
  default     = "TCP"
}

variable "ip_address" {
  description = "IP address of the load balancer. If empty, an IP address will be automatically assigned."
  type        = string
  default     = null
}

variable "port_range" {
  description = "Only packets addressed to ports in the specified range will be forwarded to target. If empty, all packets will be forwarded."
  type        = string
  default     = null
}

variable "enable_health_check" {
  description = "Flag to indicate if health check is enabled. If set to true, a firewall rule allowing health check probes is also created."
  type        = bool
  default     = false
}

variable "health_check_port" {
  description = "The TCP port number for the HTTP health check request."
  type        = number
  default     = 80
}

variable "health_check_healthy_threshold" {
  description = "A so-far unhealthy instance will be marked healthy after this many consecutive successes. The default value is 2."
  type        = number
  default     = 2
}

variable "health_check_unhealthy_threshold" {
  description = "A so-far healthy instance will be marked unhealthy after this many consecutive failures. The default value is 2."
  type        = number
  default     = 2
}

variable "health_check_interval" {
  description = "How often (in seconds) to send a health check. Default is 5."
  type        = number
  default     = 5
}

variable "health_check_timeout" {
  description = "How long (in seconds) to wait before claiming failure. The default value is 5 seconds. It is invalid for 'health_check_timeout' to have greater value than 'health_check_interval'"
  type        = number
  default     = 5
}

variable "health_check_path" {
  description = "The request path of the HTTP health check request. The default value is '/'."
  type        = string
  default     = "/"
}

variable "firewall_target_tags" {
  description = "List of target tags for the health check firewall rule."
  type        = list(string)
  default     = []
}

variable "network_project" {
  description = "The name of the GCP Project where the network is located. Useful when using networks shared between projects. If empty, var.project will be used."
  type        = string
  default     = null
}

variable "session_affinity" {
  description = "The session affinity for the backends, e.g.: NONE, CLIENT_IP. Default is `NONE`."
  type        = string
  default     = "NONE"
}

variable "instances" {
  description = "List of self links to instances in the pool. Note that the instances need not exist at the time of target pool creation."
  type        = list(string)
  default     = []
}

variable "custom_labels" {
  description = "A map of custom labels to apply to the resources. The key is the label name and the value is the label value."
  type        = map(string)
  default     = {}
}

