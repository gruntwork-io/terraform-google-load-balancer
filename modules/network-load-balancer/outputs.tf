# ------------------------------------------------------------------------------
# LOAD BALANCER OUTPUTS
# ------------------------------------------------------------------------------

output "forwarding_rule" {
  description = "Self link of the forwarding rule (Load Balancer)"
  value       = google_compute_forwarding_rule.default.self_link
}

output "load_balancer_ip_address" {
  description = "IP address of the Load Balancer"
  value       = google_compute_forwarding_rule.default.ip_address
}

output "target_pool" {
  description = "Self link of the target pool"
  value       = google_compute_target_pool.default.self_link
}
