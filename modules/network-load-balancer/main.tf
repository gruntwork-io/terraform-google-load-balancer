# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DEPLOY A NETWORK LOAD BALANCER
# This module deploys a GCP Regional Network Load Balancer
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

terraform {
  # This module is now only being tested with Terraform 0.13.x. However, to make upgrading easier, we are setting
  # 0.12.26 as the minimum version, as that version added support for required_providers with source URLs, making it
  # forwards compatible with 0.13.x code.
  required_version = ">= 0.12.26"
}

# ------------------------------------------------------------------------------
# CREATE FORWARDING RULE
# ------------------------------------------------------------------------------

resource "google_compute_forwarding_rule" "default" {
  provider              = google-beta
  project               = var.project
  name                  = var.name
  target                = google_compute_target_pool.default.self_link
  load_balancing_scheme = "EXTERNAL"
  port_range            = var.port_range
  ip_address            = var.ip_address
  ip_protocol           = var.protocol

  labels = var.custom_labels
}

# ------------------------------------------------------------------------------
# CREATE TARGET POOL
# ------------------------------------------------------------------------------

resource "google_compute_target_pool" "default" {
  provider         = google-beta
  project          = var.project
  name             = "${var.name}-tp"
  region           = var.region
  session_affinity = var.session_affinity

  instances = var.instances

  health_checks = google_compute_http_health_check.default.*.name
}

# ------------------------------------------------------------------------------
# CREATE HEALTH CHECK
# ------------------------------------------------------------------------------

resource "google_compute_http_health_check" "default" {
  count = var.enable_health_check ? 1 : 0

  provider            = google-beta
  project             = var.project
  name                = "${var.name}-hc"
  request_path        = var.health_check_path
  port                = var.health_check_port
  check_interval_sec  = var.health_check_interval
  healthy_threshold   = var.health_check_healthy_threshold
  unhealthy_threshold = var.health_check_unhealthy_threshold
  timeout_sec         = var.health_check_timeout
}

# ------------------------------------------------------------------------------
# CREATE FIREWALL FOR THE HEALTH CHECKS
# ------------------------------------------------------------------------------

# Health check firewall allows ingress tcp traffic from the health check IP addresses
resource "google_compute_firewall" "health_check" {
  count = var.enable_health_check ? 1 : 0

  provider = google-beta
  project  = var.network_project == null ? var.project : var.network_project
  name     = "${var.name}-hc-fw"
  network  = var.network

  allow {
    protocol = "tcp"
    ports    = [var.health_check_port]
  }

  # These IP ranges are required for health checks
  source_ranges = ["209.85.152.0/22", "209.85.204.0/22", "35.191.0.0/16"]

  # Target tags define the instances to which the rule applies
  target_tags = var.firewall_target_tags
}
