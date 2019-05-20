# Interanal Load Balancer Example

<!-- NOTE: We use absolute linking here instead of relative linking, because the terraform registry does not support
           relative linking correctly.
-->

This folder shows an example of how to use the [Internal Load Balancer Module](https://github.com/gruntwork-io/terraform-google-load-balancer/tree/master/modules/internal-load-balancer) to create an [Internal TCP/UDP Load Balancer](https://cloud.google.com/load-balancing/docs/internal/) with 

* Instance Group to route the requests to
* Compute instance with public IP address to proxy requests to the load balancer,

## How do you run this example?

To run this example, you need to:

1. Install [Terraform](https://www.terraform.io/).
1. Open up `variables.tf` and fill in variables that don't have defaults. 
1. `terraform init`.
1. `terraform plan`.
1. If the plan looks good, run `terraform apply`.

When the templates are applied, Terraform will output the public IP address of the Proxy Compute Instance. 

