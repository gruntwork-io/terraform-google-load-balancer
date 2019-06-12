# ---------------------------------------------------------------------------------------------------------------------
# LAUNCH AN INTERNAL LOAD BALANCER WITH REGIONAL INSTANCE GROUP
#
# This is an example of how to use the internal-load-balancer module to deploy an Internal TCP/UDP load balancer
# sending traffic to an instance group.
#
# As the internal load balancer is not accessible from the public internet, we'll create a "proxy" server in the
# public subnet that can relay the calls to the load balancer.
# ---------------------------------------------------------------------------------------------------------------------

terraform {
  # The modules used in this example have been updated with 0.12 syntax, which means the example is no longer
  # compatible with any versions below 0.12.
  required_version = ">= 0.12"
}

# ------------------------------------------------------------------------------
# CONFIGURE OUR GCP CONNECTION
# ------------------------------------------------------------------------------

provider "google" {
  version = "~> 2.7.0"
  region  = var.region
  project = var.project
}

provider "google-beta" {
  version = "~> 2.7.0"
  region  = var.region
  project = var.project
}

# ------------------------------------------------------------------------------
# CREATE THE INTERNAL TCP LOAD BALANCER
# ------------------------------------------------------------------------------

module "lb" {
  # When using these modules in your own templates, you will need to use a Git URL with a ref attribute that pins you
  # to a specific version of the modules, such as the following example:
  # source = "github.com/gruntwork-io/terraform-google-load-balancer.git//modules/internal-load-balancer?ref=v0.2.0"
  source = "../../modules/internal-load-balancer"

  name    = var.name
  region  = var.region
  project = var.project

  backends = [
    {
      description = "Instance group for internal-load-balancer test"
      group       = google_compute_instance_group.api.self_link
    },
  ]

  # This setting will enable internal DNS for the load balancer
  service_label = var.name

  network    = module.vpc_network.network
  subnetwork = module.vpc_network.public_subnetwork

  health_check_port = 5000
  http_health_check = false
  target_tags       = [var.name]
  source_tags       = [var.name]
  ports             = ["5000"]

  custom_labels = var.custom_labels
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE A NETWORK TO DEPLOY THE RESOURCES TO
# ---------------------------------------------------------------------------------------------------------------------

module "vpc_network" {
  source = "github.com/gruntwork-io/terraform-google-network.git//modules/vpc-network?ref=v0.2.0"

  name_prefix = var.name
  project     = var.project
  region      = var.region

  cidr_block           = "10.1.0.0/16"
  secondary_cidr_block = "10.2.0.0/16"
}

# ------------------------------------------------------------------------------
# CREATE THE INSTANCE GROUP WITH A SINGLE INSTANCE
# ------------------------------------------------------------------------------

resource "google_compute_instance_group" "api" {
  project   = var.project
  name      = "${var.name}-instance-group"
  zone      = var.zone
  instances = [google_compute_instance.api.self_link]

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_instance" "api" {
  project      = var.project
  name         = "${var.name}-api-instance"
  machine_type = "f1-micro"
  zone         = var.zone

  # We're tagging the instance with the tag specified in the firewall rule
  tags = [
    var.name,
    module.vpc_network.private,
  ]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  # Make sure we have the api flask application running
  metadata_startup_script = file("${path.module}/../shared/startup_script.sh")

  # Launch the instance in the public subnetwork
  # For details, see https://github.com/gruntwork-io/terraform-google-network/tree/master/modules/vpc-network#access-tier
  network_interface {
    network    = module.vpc_network.network
    subnetwork = module.vpc_network.public_subnetwork
  }
}

# ------------------------------------------------------------------------------
# CREATE THE PROXY INSTANCE
# ------------------------------------------------------------------------------

resource "google_compute_instance" "proxy" {
  project      = var.project
  name         = "${var.name}-proxy-instance"
  machine_type = "f1-micro"
  zone         = var.zone

  # We're tagging the instance with the tag specified in the firewall rule
  tags = [
    var.name,
    module.vpc_network.public,
  ]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  # Make sure we have the proxy flask application running
  metadata_startup_script = data.template_file.proxy_startup_script.rendered

  # Launch the instance in the public subnetwork
  # For details, see https://github.com/gruntwork-io/terraform-google-network/tree/master/modules/vpc-network#access-tier
  network_interface {
    network    = module.vpc_network.network
    subnetwork = module.vpc_network.public_subnetwork

    access_config {
      // Ephemeral IP
    }
  }
}

data "template_file" "proxy_startup_script" {
  template = file("${path.module}/startup_script.sh")

  # Pass in the internal DNS name and private IP address of the LB
  vars = {
    ilb_address = module.lb.load_balancer_domain_name
    ilb_ip      = module.lb.load_balancer_ip_address
  }
}

