# ---------------------------------------------------------------------------------------------------------------------
# LAUNCH A NETWORK LOAD BALANCER
# ---------------------------------------------------------------------------------------------------------------------

terraform {
  # This module is now only being tested with Terraform 1.0.x. However, to make upgrading easier, we are setting
  # 0.12.26 as the minimum version, as that version added support for required_providers with source URLs, making it
  # forwards compatible with 1.0.x code.
  required_version = ">= 0.12.26"

  required_providers {
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 3.43.0"
    }
  }
}

# ------------------------------------------------------------------------------
# CONFIGURE OUR GCP CONNECTION
# ------------------------------------------------------------------------------

provider "google-beta" {
  region  = var.region
  project = var.project
}

# ------------------------------------------------------------------------------
# CREATE THE INTERNAL TCP LOAD BALANCER
# ------------------------------------------------------------------------------

module "lb" {
  # When using these modules in your own templates, you will need to use a Git URL with a ref attribute that pins you
  # to a specific version of the modules, such as the following example:
  # source = "github.com/gruntwork-io/terraform-google-load-balancer.git//modules/network-load-balancer?ref=v0.2.0"
  source = "../../modules/network-load-balancer"

  name    = var.name
  region  = var.region
  project = var.project

  enable_health_check = true
  health_check_port   = "5000"
  health_check_path   = "/api"

  firewall_target_tags = [var.name]

  instances = [google_compute_instance.api.self_link]

  custom_labels = var.custom_labels
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE A COMPUTE INSTANCE TO ROUTE TRAFFIC TO
# ---------------------------------------------------------------------------------------------------------------------

resource "google_compute_instance" "api" {
  project      = var.project
  name         = "${var.name}-api-instance"
  machine_type = "f1-micro"
  zone         = var.zone

  # We're tagging the instance with the tag specified in the firewall rule
  tags = [
    var.name,
  ]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  # Make sure we have the api flask application running
  metadata_startup_script = file("${path.module}/../shared/startup_script.sh")

  network_interface {
    network = "default"

    # Assign public ip
    access_config {}
  }


}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE A FIREWALL RULE TO ALLOW TRAFFIC FROM ALL ADDRESSES
# ---------------------------------------------------------------------------------------------------------------------

resource "google_compute_firewall" "firewall" {
  project = var.project
  name    = "${var.name}-fw"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["5000"]
  }

  # These IP ranges are required for health checks
  source_ranges = ["0.0.0.0/0"]

  # Target tags define the instances to which the rule applies
  target_tags = [var.name]
}
