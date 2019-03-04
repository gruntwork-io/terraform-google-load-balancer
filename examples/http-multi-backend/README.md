# HTTP(S) Load Balancer Example

This folder contains an example of how to use the [HTTP(S) Load Balancer Module](/modules/http-load-balancer) to create a [HTTP(S) Cloud Load Balancer](https://cloud.google.com/load-balancing/docs/https/) with 

* HTTP listener
* Backend Cloud Storage Bucket with sample files
* Backend Service for an instance group with a single compute instance
* Optionally also
  * HTTPS listener with Self-Signed SSL Certificate
  * A custom domain with Cloud DNS records

## How do you run this example?

To run this example, you need to:

1. Install [Terraform](https://www.terraform.io/).
2. Open up `variables.tf` and set secrets at the top of the file as environment variables and fill in any other variables in
   the file that don't have defaults. 
3. `terraform init`.
4. `terraform plan`.
5. If the plan looks good, run `terraform apply`.

When the templates are applied, Terraform will output the IP address of the load balancer. If you specified custom domain name, you can connect using that.

Note that it will take up to 10 minutes for the changes to propagate, so the load balancer and the backends might not be accessible until that.

