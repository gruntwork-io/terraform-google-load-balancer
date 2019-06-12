# Network Load Balancer Module

<!-- NOTE: We use absolute linking here instead of relative linking, because the terraform registry does not support
           relative linking correctly.
-->

This Terraform Module creates a [Network Load Balancer](https://cloud.google.com/load-balancing/docs/network/) using [forwarding rules](https://cloud.google.com/load-balancing/docs/network/#forwarding_rules) and [target pools](https://cloud.google.com/load-balancing/docs/network/#target_pools).

Google Cloud Platform (GCP) Network Load Balancing distributes traffic among VM instances in the same region in a VPC network. 

## Quick Start

* See the [network-load-balancer example](https://github.com/gruntwork-io/terraform-google-load-balancer/tree/master/examples/network-load-balancer) for working sample code.
* Check out [variables.tf](https://github.com/gruntwork-io/terraform-google-load-balancer/blob/master/modules/network-load-balancer/variables.tf) for all parameters you can set for this module.

## Network Load Balancer Terminology

GCP uses non-standard vocabulary for load balancing concepts. In case you're unfamiliar with load balancing on GCP, here's a short guide:

- **[Target pools](https://cloud.google.com/load-balancing/docs/network/#target_pools)** A Target Pool resource defines a group of instances that should receive incoming traffic from forwarding rules. Target pools can only be used with forwarding rules that handle TCP and UDP traffic.
- **[Forwarding rules](https://cloud.google.com/load-balancing/docs/network/#forwarding_rules)**  Forwarding rules work in conjunction with target pools and target instances to support load balancing and protocol forwarding features.
- **[Health checks](https://cloud.google.com/load-balancing/docs/network/#health_checking)** ensure that Compute Engine forwards new connections only to instances that are up and ready to receive them. Compute Engine sends health check requests to each instance at the specified frequency.
