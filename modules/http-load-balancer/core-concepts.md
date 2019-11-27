# HTTP(S) Load Balancer Core Concepts

## What is Cloud Load Balancing?

[Cloud Load Balancing](https://cloud.google.com/load-balancing/) is a fully distributed, software-defined, managed service for all your traffic. It is not an instance or device based solution, so you won’t be locked into physical load balancing infrastructure or face the HA, scale and management challenges inherent in instance based LBs. Cloud Load Balancing features include:  

* **HTTP(S) Load Balancing:** HTTP(S) load balancing can balance HTTP and HTTPS traffic across multiple backend instances, across multiple regions.
* **Network TCP/UDP Load Balancing:** load balance external traffic.
* **Internal TCP/UDP Load Balancing:** load balance internal traffic.
* **Seamless Autoscaling:** Autoscaling helps your applications gracefully handle increases in traffic and reduces cost when the need for resources is lower.
* **Cloud CDN Integration:** Enabling [Cloud CDN](https://cloud.google.com/cdn/) for HTTP(S) Load Balancing for optimizing application delivery for your users.
* **Stackdriver Logging:** Stackdriver Logging for load balancing logs all the load balancing requests sent to your load balancer.

You can learn more about Cloud Load Balancing in [the official documentation](https://cloud.google.com/load-balancing/docs/).

## HTTP(S) Load Balancer Terminology

GCP uses non-standard vocabulary for load balancing concepts. In case you're unfamiliar with load balancing on GCP, here's a short guide:

- **[Global forwarding rules](https://cloud.google.com/load-balancing/docs/https/global-forwarding-rules)** route traffic by IP address, port, and protocol to a load balancing configuration consisting of a target proxy, URL map, and one or more backend services.
- **[Target proxies](https://cloud.google.com/load-balancing/docs/target-proxies)** terminate HTTP(S) connections from clients. One or more global forwarding rules direct traffic to the target proxy, and the target proxy consults the URL map to determine how to route traffic to backends. 
- **[URL maps](https://cloud.google.com/load-balancing/docs/https/url-map)** define matching patterns for URL-based routing of requests to the appropriate backend services. A default service is defined to handle any requests that do not match a specified host rule or path matching rule.
- **Backends** are resources to which a GCP load balancer distributes traffic. These include [backend services](https://cloud.google.com/load-balancing/docs/backend-service), such as [instance groups](https://cloud.google.com/compute/docs/instance-groups/) or [backend buckets](https://cloud.google.com/load-balancing/docs/backend-bucket).  

## How Do You Configure a Custom Domain?

You can optionally configure a custom domain with input variables `create_dns_entries` and `custom_domain_names`. 

This will create an A records for each domain provided in `custom_domain_names` pointing to the Load Balancer's public IP address. Note that you will also have to provide a managed zone name with `dns_managed_zone_name` variable.

## How Do You Configure SSL?

You can enable SSL with the input variable `enable_ssl`.

To use HTTPS or SSL load balancing, you must associate at least one SSL certificate with the load balancer's target proxy using the `ssl_certificates` input variable. You can configure the target proxy with up to ten SSL certificates.

For HTTP(S) Proxy Load Balancing, *Google encrypts traffic between the load balancer and backend instances.* SSL certificate resources *are not required* on individual VM instances.

### Using Self-managed SSL certificates

To use self-managed SSL certificates, you must have an existing [SSL certificate resource](https://cloud.google.com/compute/docs/reference/v1/sslCertificates). You can pass the certificate self links using the `ssl_certificates` input variable. 

## How Do You Configure Access Logging and Monitoring?

**NOTE:** This is part of Alpha release of GCP HTTP(S) Load Balancing Logging. For full details, see the [official documentation](https://cloud.google.com/load-balancing/docs/https/https-logging-monitoring).

### Access logs with a Google Cloud Storage Bucket backend

If you intend to use the load balancer for serving a static site using a [Google Cloud Storage](https://cloud.google.com/storage/) bucket backend, you can optionally configure [access logging](https://cloud.google.com/storage/docs/access-logs) for your bucket. 

### How to view logs

Each HTTP(S) request is logged temporarily via [Stackdriver Logging](https://cloud.google.com/logging/docs/). During the Alpha testing phase, logging is automatic and does not need to be enabled. To view logs, go to the [Logs Viewer](https://console.cloud.google.com/logs). 

### What is logged

HTTP(S) Load Balancing log entries contain information useful for monitoring and debugging your HTTP(S) traffic. Log entries contain the following types of information:

- General information shown in most GCP logs, such as severity, project ID, project number, timestamp, and so on.
- [HttpRequest](https://cloud.google.com/logging/docs/reference/v2/rest/v2/LogEntry#HttpRequest) log fields. However, `HttpRequest.protocol` and `HttpRequest.latency` are not populated for HTTP(S) Load Balancing Stackdriver logs.
- a `statusDetails` field inside the `structPayload`. This field holds a string that explains why the load balancer returned the HTTP status that it did.

### Monitoring

HTTP(S) Load Balancing exports monitoring data to [Stackdriver](https://cloud.google.com/monitoring/docs/).

Monitoring metrics can be used for the following purposes:

- Evaluate a load balancer's configuration, usage, and performance
- Troubleshoot problems
- Improve resource utilization and user experience

In addition to the predefined dashboards in Stackdriver, you can create custom dashboards, set up alerts, and query the metrics through the [Stackdriver monitoring API](https://cloud.google.com/monitoring/api/).

