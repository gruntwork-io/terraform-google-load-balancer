# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# These variables are expected to be passed in by the operator
# ---------------------------------------------------------------------------------------------------------------------

variable "project" {
  description = "The project ID to create the resources in."
}

variable "region" {
  description = "All resources will be launched in this region."
}

variable "name" {
  description = "Name for the load balancer forwarding rule and prefix for supporting resources."
}

variable "ports" {
  description = "List of ports (or port ranges) to forward to backend services. Max is 5."
  type        = "list"
}

variable "health_check_port" {
  description = "Port to perform health checks on."
}

variable "backends" {
  description = "List of backends, should be a map of key-value pairs for each backend, mush have the 'group' key."
  type        = "list"

  # Example
  # backends = [
  #   {
  #     description = "Sample Instance Group for Internal LB",
  #     group       = "The fully-qualified URL of an Instance Group"
  #   }   
  # ]
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL MODULE PARAMETERS
# These variables have defaults, but may be overridden by the operator.
# ---------------------------------------------------------------------------------------------------------------------

variable "network" {
  description = "Self link of the VPC network in which to deploy the resources."
  default     = "default"
}

variable "subnetwork" {
  description = "Self link of the VPC subnetwork in which to deploy the resources."
  default     = ""
}

variable "protocol" {
  description = "The protocol for the backend and frontend forwarding rule. TCP or UDP."
  default     = "TCP"
}

variable "ip_address" {
  description = "IP address of the load balancer. If empty, an IP address will be automatically assigned."
  default     = ""
}

variable "service_label" {
  description = "An optional prefix to the service name for this Forwarding Rule. If specified, will be the first label of the fully qualified service name."
  default     = ""
}

variable "network_project" {
  description = "The name of the GCP Project where the network is located. Useful when using networks shared between projects. If empty, var.project will be used."
  default     = ""
}

variable "http_health_check" {
  description = "Set to true if health check is type http, otherwise health check is tcp."
  default     = false
}

variable "session_affinity" {
  description = "The session affinity for the backends, e.g.: NONE, CLIENT_IP. Default is `NONE`."
  default     = "NONE"
}

variable "source_tags" {
  description = "List of source tags for traffic between the internal load balancer."
  type        = "list"
  default     = []
}

variable "target_tags" {
  description = "List of target tags for traffic between the internal load balancer."
  type        = "list"
  default     = []
}

variable "custom_labels" {
  description = "A map of custom labels to apply to the resources. The key is the label name and the value is the label value."
  type        = "map"
  default     = {}
}
