## Changing Container Images in Distributed Loki Helm Chart
This document outlines how to change the container images used for different components within a distributed Loki setup deployed using a Helm chart. This assumes you have a values.yaml file to configure your Loki deployment.

### Understanding Image Configuration in values.yaml
The values.yaml file for the Loki Helm chart allows you to customize various aspects of your deployment, including the container images used for each component.

The general structure for specifying an image is as follows:

<component_name>:
```
  image:
  
    registry: <registry_hostname>  #  Docker registry
    
    repository: <image_name>       #  Name of the Docker image
    
    tag: <image_tag>               #  Specific version or tag of the image
```

Where <component_name> refers to the different Loki services, like:

gateway , loki , compactor , queryFrontend , distributor , ingester , querier , memcachedChunks , memcachedFrontend , memcachedIndexQueries , indexGateway

### How to Change Container Images
1.**Identify the Component**
Determine which Loki component's image you want to change (e.g., the Loki core itself, the gateway, or a Memcached instance).

2.**Locate the Image Configuration**
Open your values.yaml file and find the section corresponding to the component you identified.


3.**Modify Image Details**

`registry `: If the image is hosted on a private or custom Docker registry, specify it here .

`repository `: The name of the Docker image (e.g., grafana/loki, nginxinc/nginx-unprivileged, memcached).

`tag `: The version or tag of the Docker image (e.g., 2.9.2, 1.20.2-alpine, latest, a commit hash).


*Example*: Changing the Loki Core Image

To change the container image for the main Loki components, update the loki: section:
```
 image:   
    
    registry: my-private-registry.example.com  # Example private registry
    
    repository: internal/loki
    
    tag: v2.10.0
```
Applying the Changes

After modifying your values.yaml, apply your  Loki Helm release for the changes.


### Important Considerations
*Image Availability*: Ensure that the image is accessible from your Kubernetes cluster. For private registries, configure appropriate image pull secrets.

*Compatibility*: Make sure the new image version is compatible with your existing Loki setup. Major version changes may require additional configuration changes.

*Testing*: After applying changes, test your Loki instance to ensure it functions correctly. Check logs and run queries.

*Helm Chart Documentation*: Refer to the official Helm chart documentation for Loki for additional customization options.

By following these steps, you can effectively manage and change the container images used for your distributed Loki deployment with Helm.
