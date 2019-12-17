# Internal Load Balancer Core Concepts

## What is Cloud Load Balancing?

[Cloud Load Balancing](https://cloud.google.com/load-balancing/) is a fully distributed, software-defined, managed service for all your traffic. It is not an instance or device based solution, so you won’t be locked into physical load balancing infrastructure or face the HA, scale and management challenges inherent in instance based LBs. Cloud Load Balancing features include:  

* **HTTP(S) Load Balancing:** HTTP(S) load balancing can balance HTTP and HTTPS traffic across multiple backend instances, across multiple regions.
* **Network TCP/UDP Load Balancing:** load balance external traffic.
* **Internal TCP/UDP Load Balancing:** load balance internal traffic.
* **Seamless Autoscaling:** Autoscaling helps your applications gracefully handle increases in traffic and reduces cost when the need for resources is lower.
* **Cloud CDN Integration:** Enabling [Cloud CDN](https://cloud.google.com/cdn/) for HTTP(S) Load Balancing for optimizing application delivery for your users.
* **Stackdriver Logging:** Stackdriver Logging for load balancing logs all the load balancing requests sent to your load balancer.

You can learn more about Cloud Load Balancing in [the official documentation](https://cloud.google.com/load-balancing/docs/).

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
