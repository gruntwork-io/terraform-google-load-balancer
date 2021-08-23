# ---------------------------------------------------------------------------------------------------------------------
# LAUNCH A LOAD BALANCER WITH INSTANCE GROUP AND STORAGE BUCKET BACKEND
#
# This is an example of how to use the http-load-balancer module to deploy a HTTP load balancer
# with multiple backends and optionally ssl and custom domain.
# ---------------------------------------------------------------------------------------------------------------------

terraform {
  # This module is now only being tested with Terraform 1.0.x. However, to make upgrading easier, we are setting
  # 0.12.26 as the minimum version, as that version added support for required_providers with source URLs, making it
  # forwards compatible with 1.0.x code.
  required_version = ">= 0.12.26"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.43.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 3.43.0"
    }
  }
}

# ------------------------------------------------------------------------------
# CONFIGURE OUR GCP CONNECTION
# ------------------------------------------------------------------------------

provider "google" {
  region  = var.region
  project = var.project
}

provider "google-beta" {
  region  = var.region
  project = var.project
}

# ------------------------------------------------------------------------------
# CREATE THE LOAD BALANCER
# ------------------------------------------------------------------------------

module "lb" {
  source                = "./modules/http-load-balancer"
  name                  = var.name
  project               = var.project
  url_map               = google_compute_url_map.urlmap.self_link
  dns_managed_zone_name = var.dns_managed_zone_name
  custom_domain_names   = [var.custom_domain_name]
  create_dns_entries    = var.create_dns_entry
  dns_record_ttl        = var.dns_record_ttl
  enable_http           = var.enable_http
  enable_ssl            = var.enable_ssl
  ssl_certificates      = google_compute_ssl_certificate.certificate.*.self_link

  custom_labels = var.custom_labels
}

# ------------------------------------------------------------------------------
# CREATE THE URL MAP TO MAP PATHS TO BACKENDS
# ------------------------------------------------------------------------------

resource "google_compute_url_map" "urlmap" {
  project = var.project

  name        = "${var.name}-url-map"
  description = "URL map for ${var.name}"

  default_service = google_compute_backend_bucket.static.self_link

  host_rule {
    hosts        = ["*"]
    path_matcher = "all"
  }

  path_matcher {
    name            = "all"
    default_service = google_compute_backend_bucket.static.self_link

    path_rule {
      paths   = ["/api", "/api/*"]
      service = google_compute_backend_service.api.self_link
    }
  }
}

# ------------------------------------------------------------------------------
# CREATE THE BACKEND SERVICE CONFIGURATION FOR THE INSTANCE GROUP
# ------------------------------------------------------------------------------

resource "google_compute_backend_service" "api" {
  project = var.project

  name        = "${var.name}-api"
  description = "API Backend for ${var.name}"
  port_name   = "http"
  protocol    = "HTTP"
  timeout_sec = 10
  enable_cdn  = false

  backend {
    group = google_compute_instance_group.api.self_link
  }

  health_checks = [google_compute_health_check.default.self_link]

  depends_on = [google_compute_instance_group.api]
}

# ------------------------------------------------------------------------------
# CONFIGURE HEALTH CHECK FOR THE API BACKEND
# ------------------------------------------------------------------------------

resource "google_compute_health_check" "default" {
  project = var.project
  name    = "${var.name}-hc"

  http_health_check {
    port         = 5000
    request_path = "/api"
  }

  check_interval_sec = 5
  timeout_sec        = 5
}

# ------------------------------------------------------------------------------
# CREATE THE STORAGE BUCKET FOR THE STATIC CONTENT
# ------------------------------------------------------------------------------

resource "google_storage_bucket" "static" {
  project = var.project

  name          = "${var.name}-bucket"
  location      = var.static_content_bucket_location
  storage_class = "MULTI_REGIONAL"

  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }

  # For the example, we want to clean up all resources. In production, you should set this to false to prevent
  # accidental loss of data
  force_destroy = true

  labels = var.custom_labels
}

# ------------------------------------------------------------------------------
# CREATE THE BACKEND FOR THE STORAGE BUCKET
# ------------------------------------------------------------------------------

resource "google_compute_backend_bucket" "static" {
  project = var.project

  name        = "${var.name}-backend-bucket"
  bucket_name = google_storage_bucket.static.name
}

# ------------------------------------------------------------------------------
# UPLOAD SAMPLE CONTENT WITH PUBLIC READ ACCESS
# ------------------------------------------------------------------------------

resource "google_storage_default_object_acl" "website_acl" {
  bucket      = google_storage_bucket.static.name
  role_entity = ["READER:allUsers"]
}

resource "google_storage_bucket_object" "index" {
  name    = "index.html"
  content = "Hello, World!"
  bucket  = google_storage_bucket.static.name

  # We have to depend on the ACL because otherwise the ACL could get created after the object
  depends_on = [google_storage_default_object_acl.website_acl]
}

resource "google_storage_bucket_object" "not_found" {
  name    = "404.html"
  content = "Uh oh"
  bucket  = google_storage_bucket.static.name

  # We have to depend on the ACL because otherwise the ACL could get created after the object
  depends_on = [google_storage_default_object_acl.website_acl]
}

# ------------------------------------------------------------------------------
# IF SSL IS ENABLED, CREATE A SELF-SIGNED CERTIFICATE
# ------------------------------------------------------------------------------

resource "tls_self_signed_cert" "cert" {
  # Only create if SSL is enabled
  count = var.enable_ssl ? 1 : 0

  key_algorithm   = "RSA"
  private_key_pem = join("", tls_private_key.private_key.*.private_key_pem)

  subject {
    common_name  = var.custom_domain_name
    organization = "Examples, Inc"
  }

  validity_period_hours = 12

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

resource "tls_private_key" "private_key" {
  count       = var.enable_ssl ? 1 : 0
  algorithm   = "RSA"
  ecdsa_curve = "P256"
}

# ------------------------------------------------------------------------------
# CREATE A CORRESPONDING GOOGLE CERTIFICATE THAT WE CAN ATTACH TO THE LOAD BALANCER
# ------------------------------------------------------------------------------

resource "google_compute_ssl_certificate" "certificate" {
  project = var.project

  count = var.enable_ssl ? 1 : 0

  name_prefix = var.name
  description = "SSL Certificate"
  private_key = join("", tls_private_key.private_key.*.private_key_pem)
  certificate = join("", tls_self_signed_cert.cert.*.cert_pem)

  lifecycle {
    create_before_destroy = true
  }
}

# ------------------------------------------------------------------------------
# CREATE THE INSTANCE GROUP WITH A SINGLE INSTANCE AND THE BACKEND SERVICE CONFIGURATION
#
# We use the instance group only to highlight the ability to specify multiple types
# of backends for the load balancer
# ------------------------------------------------------------------------------

resource "google_compute_instance_group" "api" {
  project   = var.project
  name      = "${var.name}-instance-group"
  zone      = var.zone
  instances = [google_compute_instance.api.self_link]

  lifecycle {
    create_before_destroy = true
  }

  named_port {
    name = "http"
    port = 5000
  }
}

resource "google_compute_instance" "api" {
  project      = var.project
  name         = "${var.name}-instance"
  machine_type = "f1-micro"
  zone         = var.zone

  # We're tagging the instance with the tag specified in the firewall rule
  tags = ["private-app"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  # Make sure we have the flask application running
  metadata_startup_script = file("${path.module}/examples/shared/startup_script.sh")

  # Launch the instance in the default subnetwork
  network_interface {
    subnetwork = "default"

    # This gives the instance a public IP address for internet connectivity. Normally, you would have a Cloud NAT,
    # but for the sake of simplicity, we're assigning a public IP to get internet connectivity
    # to be able to run startup scripts
    access_config {
    }
  }
}

# ------------------------------------------------------------------------------
# CREATE A FIREWALL TO ALLOW ACCESS FROM THE LB TO THE INSTANCE
# ------------------------------------------------------------------------------

resource "google_compute_firewall" "firewall" {
  project = var.project
  name    = "${var.name}-fw"
  network = "default"

  # Allow load balancer access to the API instances
  # https://cloud.google.com/load-balancing/docs/https/#firewall_rules
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]

  target_tags = ["private-app"]
  source_tags = ["private-app"]

  allow {
    protocol = "tcp"
    ports    = ["5000"]
  }
}
