# ------------------------------------------------------------------------------
# LOAD BALANCER OUTPUTS
# ------------------------------------------------------------------------------

output "load_balancer_ip_address" {
  description = "Internal IP address of the load balancer"
  value       = module.lb.load_balancer_ip_address
}
