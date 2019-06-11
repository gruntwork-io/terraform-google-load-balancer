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

output "load_balancer_domain_name" {
  description = "The internal fully qualified service name for this Load Balancer"
  value       = google_compute_forwarding_rule.default.service_name
}

output "load_balancer_firewall" {
  description = "Self link of the load balancer firewall rule."
  value       = google_compute_firewall.load_balancer.self_link
}

output "health_check_firewall" {
  description = "Self link of the health check firewall rule."
  value       = google_compute_firewall.health_check.self_link
}

output "backend_service" {
  description = "Self link of the regional backend service."
  value       = google_compute_region_backend_service.default.self_link
}

