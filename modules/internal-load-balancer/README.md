# Internal Load Balancer Module

<!-- NOTE: We use absolute linking here instead of relative linking, because the terraform registry does not support
           relative linking correctly.
-->

This Terraform Module creates an [Internal TCP/UDP Load Balancer](https://cloud.google.com/load-balancing/docs/internal/) using [internal forwarding rules](https://cloud.google.com/load-balancing/docs/internal/#forwarding_rule).

Google Cloud Platform (GCP) Internal TCP/UDP Load Balancing distributes traffic among VM instances in the same region in a VPC network using a private, internal (RFC 1918) IP address. 

## Quick Start

* See the [internal-load-balancer example](https://github.com/gruntwork-io/terraform-google-load-balancer/tree/master/examples/internal-load-balancer) for working sample code.
* Check out [variables.tf](https://github.com/gruntwork-io/terraform-google-load-balancer/blob/master/modules/internal-load-balancer/variables.tf) for all parameters you can set for this module.

## How do you configure this module

This module allows you to configure a number of parameters. For a list of all available variables and their descriptions, see [variables.tf](https://github.com/gruntwork-io/terraform-google-load-balancer/blob/master/modules/internal-load-balancer/variables.tf).

## Internal TCP/UDP Load Balancer Terminology

GCP uses non-standard vocabulary for load balancing concepts. In case you're unfamiliar with load balancing on GCP, here's a short guide:

- **[Internal IP address](https://cloud.google.com/load-balancing/docs/internal/#load_balancing_ip_address)** is the address for the load balancer. The internal IP address must be in the same subnet as the internal forwarding rule. The subnet must be in the same region as the backend service.
- **[Internal forwarding rules](https://cloud.google.com/load-balancing/docs/https/global-forwarding-rules)**  in combination with the internal IP address is the frontend of the load balancer. It defines the protocol and port(s) that the load balancer accepts, and it directs traffic to a regional internal backend service.
- **[Regional internal backend service](https://cloud.google.com/load-balancing/docs/internal/#backend_service)** defines the protocol used to communicate with the backends (instance groups), and it specifies a health check. Backends can be unmanaged instance groups, managed zonal instance groups, or managed regional instance groups. 
- **[Health check](https://cloud.google.com/load-balancing/docs/internal/#health-checking)** defines the parameters under which GCP considers the backends it manages to be eligible to receive traffic. Only healthy VMs in the backend instance groups will receive traffic sent from client VMs to the IP address of the load balancer.

## Internal TCP/UDP Load Balancing monitoring

Internal TCP/UDP Load Balancing exports monitoring data to [Stackdriver](https://cloud.google.com/monitoring/docs/). 

## Internal TCP/UDP Load Balancing and DNS Names

A DNS address record (A record) is used to map a DNS name to an IP address. When you configure an internal TCP/UDP load balancer, you can optionally designate a service label for GCP to create a Compute Engine internal DNS name for the load balancer. This internal DNS name is constructed from your project ID, internal forwarding rule name, and a service label you choose. 

See [DNS record format](https://cloud.google.com/load-balancing/docs/internal/dns-names#a_record_format) for details about the format of the DNS name that GCP creates for your load balancer. 
