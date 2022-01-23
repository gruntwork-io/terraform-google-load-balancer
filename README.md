### Sunset notice

We believe there is an opportunity to create a truly outstanding developer experience for deploying to the cloud, however developing this vision requires that we temporarily limit our focus to just one cloud. Gruntwork has hundreds of customers currently using AWS, so we have temporarily suspended our maintenance efforts on this repo. Once we have implemented and validated our vision for the developer experience on the cloud, we look forward to picking this up. In the meantime, you are welcome to use this code in accordance with the open source license, however we will not be responding to GitHub Issues or Pull Requests.

If you wish to be the maintainer for this project, we are open to considering that. Please contact us at support@gruntwork.io

---

<!--
:type: service
:name: Google Cloud Load Balancer
:description: Deploy Google's Cloud Load Balancer, with support for HTTP/HTTPS, internal and network load balancers.
:icon: /_docs/cloud-load-balancer-icon.png
:category: load-balancing
:cloud: gcp
:tags: loadbalancer, http, https, network
:license: open-source
:built-with: terraform
-->

# Cloud Load Balancer Modules

[![GitHub tag (latest SemVer)](https://img.shields.io/github/tag/gruntwork-io/terraform-google-load-balancer.svg?label=latest)](https://github.com/gruntwork-io/terraform-google-load-balancer/releases/latest)
![Terraform Version](https://img.shields.io/badge/tf-%3E%3D1.0.x-blue.svg)

This repo contains modules to perform load balancing on [Google Cloud Platform (GCP)](https://cloud.google.com/) using [Google Cloud Load Balancing](https://cloud.google.com/load-balancing/).

## Cloud Load Balancer Architecture

![Cloud Load Balancer Architecture](https://github.com/gruntwork-io/terraform-google-load-balancer/blob/master/_docs/cloud-load-balancer.png "Cloud Load Balancer Architecture")

## Features

- Load balance HTTP and HTTPS traffic across multiple backend instances, across multiple regions with HTTP(S) Load Balancing.
- Load balance internal TCP/UDP traffic with Internal Load Balancing
- Load balance external TCP/UDP traffic with Network Load Balancing

## Learn

This repo is a part of [the Gruntwork Infrastructure as Code Library](https://gruntwork.io/infrastructure-as-code-library/), a collection of reusable, battle-tested, production ready infrastructure code. If you’ve never used the Infrastructure as Code Library before, make sure to read [How to use the Gruntwork Infrastructure as Code Library](https://gruntwork.io/guides/foundations/how-to-use-gruntwork-infrastructure-as-code-library/)!

### Core concepts

- [What is Cloud Load Balancing](https://github.com/gruntwork-io/terraform-google-load-balancer/blob/master/modules/http-load-balancer/core-concepts.md#what-is-cloud-load-balancing)
- [HTTP(S) Load Balancer Terminology](https://github.com/gruntwork-io/terraform-google-load-balancer/tree/master/modules/http-load-balancer/core-concepts.md#https-load-balancer-terminology)
- [Internal Load Balancer Terminology](https://github.com/gruntwork-io/terraform-google-load-balancer/tree/master/modules/internal-load-balancer/core-concepts.md#internal-load-balancer-terminology)
- [Network Load Balancer Terminology](https://github.com/gruntwork-io/terraform-google-load-balancer/tree/master/modules/network-load-balancer/core-concepts.md#network-load-balancer-terminology)
- [Cloud Load Balancing Documentation](https://cloud.google.com/load-balancing/)

### Repo organisation

This repo has the following folder structure:

- [root](https://github.com/gruntwork-io/terraform-google-load-balancer/tree/master): The root folder contains an example of how to deploy a HTTP Load Balancer with multiple backends. See [http-multi-backend example documentation](https://github.com/gruntwork-io/terraform-google-load-balancer/blob/master/examples/http-multi-backend) for the documentation.

- [modules](https://github.com/gruntwork-io/terraform-google-load-balancer/blob/master/modules): This folder contains the main implementation code for this Module.

  The primary modules are:

  - [http-load-balancer](https://github.com/gruntwork-io/terraform-google-load-balancer/blob/master/modules/http-load-balancer) is used to create an [HTTP(S) External Load Balancer](https://cloud.google.com/load-balancing/docs/https/).
  - [internal-load-balancer](https://github.com/gruntwork-io/terraform-google-load-balancer/blob/master/modules/internal-load-balancer) is used to create an [Internal TCP/UDP Load Balancer](https://cloud.google.com/load-balancing/docs/internal/).
  - [network-load-balancer](https://github.com/gruntwork-io/terraform-google-load-balancer/blob/master/modules/network-load-balancer) is used to create an [External TCP/UDP Load Balancer](https://cloud.google.com/load-balancing/docs/network/).

- [examples](https://github.com/gruntwork-io/terraform-google-load-balancer/blob/master/examples): This folder contains examples of how to use the submodules.

- [test](https://github.com/gruntwork-io/terraform-google-load-balancer/blob/master/test): Automated tests for the submodules and examples.

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
