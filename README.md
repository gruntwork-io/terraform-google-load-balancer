[![Maintained by Gruntwork.io](https://img.shields.io/badge/maintained%20by-gruntwork.io-%235849a6.svg)](https://gruntwork.io/?ref=repo_google_load_balancer)

# Cloud Load Balancer Modules

This repo contains modules to perform load balancing on [Google Cloud Platform (GCP)](https://cloud.google.com/) using [Google Cloud Load Balancing](https://cloud.google.com/load-balancing/).

## Code included in this Module

* [http-load-balancer](/modules/http-load-balancer): Deploy an [HTTP Load Balancer](https://cloud.google.com/load-balancing/docs/https/).


## What is Cloud Load Balancer?

[Cloud Load Balancing](https://cloud.google.com/load-balancing/) is a fully distributed, software-defined, managed service for all your traffic. It is not an instance or device based solution, so you won’t be locked into physical load balancing infrastructure or face the HA, scale and management challenges inherent in instance based LBs. Cloud Load Balancing features include:  

* **HTTP(S) Load Balancing:** HTTP(S) load balancing can balance HTTP and HTTPS traffic across multiple backend instances, across multiple regions.
* **Seamless Autoscaling:** Autoscaling helps your applications gracefully handle increases in traffic and reduces cost when the need for resources is lower.
* **Cloud CDN Integration:** Enabling [Cloud CDN](https://cloud.google.com/cdn/) for HTTP(S) Load Balancing for optimizing application delivery for your users.
* **Stackdriver Logging:** Stackdriver Logging for load balancing logs all the load balancing requests sent to your load balancer.

You can learn more about Cloud Load Balancing in [the official documentation](https://cloud.google.com/load-balancing/docs/).

## Who maintains this Module?

This Module and its Submodules are maintained by [Gruntwork](http://www.gruntwork.io/). Read the [Gruntwork Philosophy](/GRUNTWORK_PHILOSOPHY.md) document to learn more about how Gruntwork builds production grade infrastructure code. If you are looking for help or
commercial support, send an email to
[support@gruntwork.io](mailto:support@gruntwork.io?Subject=Google%20LB%20Module).

Gruntwork can help with:

* Setup, customization, and support for this Module.
* Modules and submodules for other types of infrastructure, such as VPCs, Docker clusters, databases, and continuous
  integration.
* Modules and Submodules that meet compliance requirements, such as HIPAA.
* Consulting & Training on GCP, AWS, Terraform, and DevOps.


## How do I contribute to this Module?

Contributions are very welcome! Check out the [Contribution Guidelines](/CONTRIBUTING.md) for instructions.


## How is this Module versioned?

This Module follows the principles of [Semantic Versioning](http://semver.org/). You can find each new release, along
with the changelog, in the [Releases Page](../../releases).

During initial development, the major version will be 0 (e.g., `0.x.y`), which indicates the code does not yet have a
stable API. Once we hit `1.0.0`, we will make every effort to maintain a backwards compatible API and use the MAJOR,
MINOR, and PATCH versions on each release to indicate any incompatibilities.


## License

Please see [LICENSE.txt](/LICENSE.txt) for details on how the code in this repo is licensed.
