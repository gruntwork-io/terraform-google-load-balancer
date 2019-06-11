# ------------------------------------------------------------------------------
# LOAD BALANCER OUTPUTS
# ------------------------------------------------------------------------------

output "load_balancer_ip_address" {
  description = "Internal IP address of the load balancer"
  value       = module.lb.load_balancer_ip_address
}

output "load_balancer_domain_name" {
  description = "Internal domain name of the load balancer"
  value       = module.lb.load_balancer_domain_name
}

output "proxy_public_ip_address" {
  description = "Public IP address of the proxy instance"
  value       = google_compute_instance.proxy.network_interface[0].access_config[0].nat_ip
}

