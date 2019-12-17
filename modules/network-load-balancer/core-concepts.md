# Network Load Balancer Core Concepts

## What is Cloud Load Balancing?

[Cloud Load Balancing](https://cloud.google.com/load-balancing/) is a fully distributed, software-defined, managed service for all your traffic. It is not an instance or device based solution, so you won’t be locked into physical load balancing infrastructure or face the HA, scale and management challenges inherent in instance based LBs. Cloud Load Balancing features include:  

* **HTTP(S) Load Balancing:** HTTP(S) load balancing can balance HTTP and HTTPS traffic across multiple backend instances, across multiple regions.
* **Network TCP/UDP Load Balancing:** load balance external traffic.
* **Internal TCP/UDP Load Balancing:** load balance internal traffic.
* **Seamless Autoscaling:** Autoscaling helps your applications gracefully handle increases in traffic and reduces cost when the need for resources is lower.
* **Cloud CDN Integration:** Enabling [Cloud CDN](https://cloud.google.com/cdn/) for HTTP(S) Load Balancing for optimizing application delivery for your users.
* **Stackdriver Logging:** Stackdriver Logging for load balancing logs all the load balancing requests sent to your load balancer.

You can learn more about Cloud Load Balancing in [the official documentation](https://cloud.google.com/load-balancing/docs/).

## Network Load Balancer Terminology

GCP uses non-standard vocabulary for load balancing concepts. In case you're unfamiliar with load balancing on GCP, here's a short guide:

- **[Target pools](https://cloud.google.com/load-balancing/docs/network/#target_pools)** A Target Pool resource defines a group of instances that should receive incoming traffic from forwarding rules. Target pools can only be used with forwarding rules that handle TCP and UDP traffic.
- **[Forwarding rules](https://cloud.google.com/load-balancing/docs/network/#forwarding_rules)**  Forwarding rules work in conjunction with target pools and target instances to support load balancing and protocol forwarding features.
- **[Health checks](https://cloud.google.com/load-balancing/docs/network/#health_checking)** ensure that Compute Engine forwards new connections only to instances that are up and ready to receive them. Compute Engine sends health check requests to each instance at the specified frequency.
