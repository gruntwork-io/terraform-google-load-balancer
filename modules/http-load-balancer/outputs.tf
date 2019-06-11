# ------------------------------------------------------------------------------
# LOAD BALANCER OUTPUTS
# ------------------------------------------------------------------------------

output "load_balancer_ip_address" {
  description = "IP address of the Cloud Load Balancer"
  value       = google_compute_global_address.default.address
}

