# HTTP(S) Load Balancer Module

[![Maintained by Gruntwork.io](https://img.shields.io/badge/maintained%20by-gruntwork.io-%235849a6.svg)](https://gruntwork.io/?ref=repo_google_load_balancer)
[![GitHub tag (latest SemVer)](https://img.shields.io/github/tag/gruntwork-io/terraform-google-load-balancer.svg?label=latest)](https://github.com/gruntwork-io/terraform-google-load-balancer/releases/latest)
![Terraform Version](https://img.shields.io/badge/tf-%3E%3D0.12.0-blue.svg)

This Terraform Module creates an [HTTP(S) Cloud Load Balancer](https://cloud.google.com/load-balancing/docs/https/) using [global forwarding rules](https://cloud.google.com/load-balancing/docs/https/global-forwarding-rules).

HTTP(S) load balancing can balance HTTP and HTTPS traffic across multiple backend instances, across multiple regions. Your entire app is available via a single global IP address, resulting in a simplified DNS setup. HTTP(S) load balancing is scalable, fault-tolerant, requires no pre-warming, and enables content-based load balancing. 

## Learn

This repo is a part of [the Gruntwork Infrastructure as Code Library](https://gruntwork.io/infrastructure-as-code-library/), a collection of reusable, battle-tested, production ready infrastructure code. If you’ve never used the Infrastructure as Code Library before, make sure to read [How to use the Gruntwork Infrastructure as Code Library](https://gruntwork.io/guides/foundations/how-to-use-gruntwork-infrastructure-as-code-library/)!

### Core concepts

- [What is Cloud Load Balancing](https://github.com/gruntwork-io/terraform-google-load-balancer/blob/master/modules/http-load-balancer/core-concepts.md#what-is-cloud-load-balancing)
- [HTTP(S) Load Balancer Terminology](https://github.com/gruntwork-io/terraform-google-load-balancer/tree/master/modules/http-load-balancer/core-concepts.md#https-load-balancer-terminology)
- [Cloud Load Balancing Documentation](https://cloud.google.com/load-balancing/)

### Repo organisation

This repo has the following folder structure:

* [root](https://github.com/gruntwork-io/terraform-google-load-balancer/tree/master): The root folder contains an example of how to deploy a HTTP Load Balancer with multiple backends. See [http-multi-backend example documentation](https://github.com/gruntwork-io/terraform-google-load-balancer/blob/master/examples/http-multi-backend) for the documentation.

* [modules](https://github.com/gruntwork-io/terraform-google-load-balancer/blob/master/modules): This folder contains the main implementation code for this Module.

  The primary modules are:

    * [http-load-balancer](https://github.com/gruntwork-io/terraform-google-load-balancer/blob/master/modules/http-load-balancer) is used to create an [HTTP(S) External Load Balancer](https://cloud.google.com/load-balancing/docs/https/).
    * [internal-load-balancer](https://github.com/gruntwork-io/terraform-google-load-balancer/blob/master/modules/internal-load-balancer) is used to create an [Internal TCP/UDP Load Balancer](https://cloud.google.com/load-balancing/docs/internal/).
    * [network-load-balancer](https://github.com/gruntwork-io/terraform-google-load-balancer/blob/master/modules/network-load-balancer) is used to create an [External TCP/UDP Load Balancer](https://cloud.google.com/load-balancing/docs/network/).
                                                                                                                                           
* [examples](https://github.com/gruntwork-io/terraform-google-load-balancer/blob/master/examples): This folder contains examples of how to use the submodules.

* [test](https://github.com/gruntwork-io/terraform-google-load-balancer/blob/master/test): Automated tests for the submodules and examples.

## Deploy

If you want to try this repo out for experimenting and learning, check out the following resources:

- [examples folder](https://github.com/gruntwork-io/terraform-google-load-balancer/blob/master/examples): The `examples` folder contains sample code optimized for learning, experimenting, and testing.

## Manage

### Day-to-day operations

- [How to configure a custom domain](https://github.com/gruntwork-io/terraform-google-load-balancer/tree/master/modules/http-load-balancer/core-concepts.md#how-do-you-configure-a-custom-domain)
- [How to configure SSL](https://github.com/gruntwork-io/terraform-google-load-balancer/tree/master/modules/http-load-balancer/core-concepts.md#how-do-you-configure-ssl)
- [How to configure access logging and monitoring](https://github.com/gruntwork-io/terraform-google-load-balancer/tree/master/modules/http-load-balancer/core-concepts.md#how-do-you-configure-access-logging-and-monitoring)

## Support

If you need help with this repo or anything else related to infrastructure or DevOps, Gruntwork offers [Commercial Support](https://gruntwork.io/support/) via Slack, email, and phone/video. If you’re already a Gruntwork customer, hop on Slack and ask away! If not, [subscribe now](https://www.gruntwork.io/pricing/). If you’re not sure, feel free to email us at [support@gruntwork.io](mailto:support@gruntwork.io).

## Contributions

Contributions to this repo are very welcome and appreciated! If you find a bug or want to add a new feature or even contribute an entirely new module, we are very happy to accept pull requests, provide feedback, and run your changes through our automated test suite.

Please see [Contributing to the Gruntwork Infrastructure as Code Library](https://gruntwork.io/guides/foundations/how-to-use-gruntwork-infrastructure-as-code-library/#contributing-to-the-gruntwork-infrastructure-as-code-library) for instructions.

## License

Please see [LICENSE](https://github.com/gruntwork-io/terraform-google-load-balancer/blob/master/LICENSE.txt) for details on how the code in this repo is licensed.

Copyright &copy; 2019 Gruntwork, Inc.
