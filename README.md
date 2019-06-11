[![Maintained by Gruntwork.io](https://img.shields.io/badge/maintained%20by-gruntwork.io-%235849a6.svg)](https://gruntwork.io/?ref=repo_google_load_balancer)
[![GitHub tag (latest SemVer)](https://img.shields.io/github/tag/gruntwork-io/terraform-google-load-balancer.svg?label=latest)](https://github.com/gruntwork-io/terraform-google-load-balancer/releases/latest)
![Terraform Version](https://img.shields.io/badge/tf-%3E%3D0.12.0-blue.svg)
# Cloud Load Balancer Modules

<!-- NOTE: We use absolute linking here instead of relative linking, because the terraform registry does not support
           relative linking correctly.
-->

This repo contains modules to perform load balancing on [Google Cloud Platform (GCP)](https://cloud.google.com/) using [Google Cloud Load Balancing](https://cloud.google.com/load-balancing/).

## Quickstart

If you want to quickly spin up a HTTP Load Balancer with multiple backends, you can run the example that is in the root of this repo. Check out the [http-multi-backend example documentation](https://github.com/gruntwork-io/terraform-google-load-balancer/blob/master/examples/http-multi-backend) for instructions.

## What's in this repo

This repo has the following folder structure:

* [root](https://github.com/gruntwork-io/terraform-google-load-balancer/tree/master): The root folder contains an example of how to deploy a HTTP Load Balancer with multiple backends. See [http-multi-backend example documentation](https://github.com/gruntwork-io/terraform-google-load-balancer/blob/master/examples/http-multi-backend) for the documentation.

* [modules](https://github.com/gruntwork-io/terraform-google-load-balancer/blob/master/modules): This folder contains the main implementation code for this Module.

  The primary modules are:

    * [http-load-balancer](https://github.com/gruntwork-io/terraform-google-load-balancer/blob/master/modules/http-load-balancer) is used to create an [HTTP(S) External Load Balancer](https://cloud.google.com/load-balancing/docs/https/) using [global forwarding rules](https://cloud.google.com/load-balancing/docs/https/global-forwarding-rules).
    * [internal-load-balancer](https://github.com/gruntwork-io/terraform-google-load-balancer/blob/master/modules/internal-load-balancer) is used to create an [Internal TCP/UDP Load Balancer](https://cloud.google.com/load-balancing/docs/internal/) using [internal forwarding rules](https://cloud.google.com/load-balancing/docs/internal/#forwarding_rule).
                                                                                                                                           
* [examples](https://github.com/gruntwork-io/terraform-google-load-balancer/blob/master/examples): This folder contains examples of how to use the submodules.

* [test](https://github.com/gruntwork-io/terraform-google-load-balancer/blob/master/test): Automated tests for the submodules and examples.



## What is Cloud Load Balancing?

[Cloud Load Balancing](https://cloud.google.com/load-balancing/) is a fully distributed, software-defined, managed service for all your traffic. It is not an instance or device based solution, so you won’t be locked into physical load balancing infrastructure or face the HA, scale and management challenges inherent in instance based LBs. Cloud Load Balancing features include:  

* **HTTP(S) Load Balancing:** HTTP(S) load balancing can balance HTTP and HTTPS traffic across multiple backend instances, across multiple regions.
* **Network TCP/UDP Load Balancing:** load balance external traffic.
* **Internal TCP/UDP Load Balancing:** load balance internal traffic.
* **Seamless Autoscaling:** Autoscaling helps your applications gracefully handle increases in traffic and reduces cost when the need for resources is lower.
* **Cloud CDN Integration:** Enabling [Cloud CDN](https://cloud.google.com/cdn/) for HTTP(S) Load Balancing for optimizing application delivery for your users.
* **Stackdriver Logging:** Stackdriver Logging for load balancing logs all the load balancing requests sent to your load balancer.

You can learn more about Cloud Load Balancing in [the official documentation](https://cloud.google.com/load-balancing/docs/).

## Who maintains this Module?

This Module and its Submodules are maintained by [Gruntwork](http://www.gruntwork.io/). Read the [Gruntwork Philosophy](https://github.com/gruntwork-io/terraform-google-load-balancer/blob/master/GRUNTWORK_PHILOSOPHY.md) document to learn more about how Gruntwork builds production grade infrastructure code. If you are looking for help or
commercial support, send an email to
[support@gruntwork.io](mailto:support@gruntwork.io?Subject=Google%20LB%20Module).

Gruntwork can help with:

* Setup, customization, and support for this Module.
* Modules and submodules for other types of infrastructure, such as VPCs, Docker clusters, databases, and continuous
  integration.
* Modules and Submodules that meet compliance requirements, such as HIPAA.
* Consulting & Training on GCP, AWS, Terraform, and DevOps.


## How do I contribute to this Module?

Contributions are very welcome! Check out the [Contribution Guidelines](https://github.com/gruntwork-io/terraform-google-load-balancer/blob/master/CONTRIBUTING.md) for instructions.


## How is this Module versioned?

This Module follows the principles of [Semantic Versioning](http://semver.org/). You can find each new release, along
with the changelog, in the [Releases Page](https://github.com/gruntwork-io/terraform-google-load-balancer/releases).

During initial development, the major version will be 0 (e.g., `0.x.y`), which indicates the code does not yet have a
stable API. Once we hit `1.0.0`, we will make every effort to maintain a backwards compatible API and use the MAJOR,
MINOR, and PATCH versions on each release to indicate any incompatibilities.


## License

Please see [LICENSE.txt](https://github.com/gruntwork-io/terraform-google-load-balancer/blob/master/LICENSE.txt) for details on how the code in this repo is licensed.
