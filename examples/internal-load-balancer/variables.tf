# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# These variables are expected to be passed in by the operator
# ---------------------------------------------------------------------------------------------------------------------

variable "project" {
  description = "The project ID to create the resources in."
  default     = "dev-sandbox-228703"
}

variable "region" {
  description = "The region to create the resources in."
  default     = "europe-north1"
}

variable "zone" {
  description = "The availability zone to create the sample compute instances in. Must within the region specified in 'var.region'"
  default     = "europe-north1-a"
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These variables have defaults, but may be overridden by the operator.
# ---------------------------------------------------------------------------------------------------------------------

variable "name" {
  description = "Name for the load balancer forwarding rule and prefix for supporting resources."
  default     = "ilb-example"
}

variable "custom_labels" {
  description = "A map of custom labels to apply to the resources. The key is the label name and the value is the label value."
  type        = "map"

  default = {
    test-case = "internal-load-balancer"
  }
}
