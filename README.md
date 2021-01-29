# Cloud Pak for Integration module

Installs the Cloud Pak for Integration operator catalog and sets up the necessary entitlements. This module is provided
more as a pre-requisite for the other modules that install operators/services that are provided by the Cloud Pak for 
Integration (e.g. App Connect, Api Connect, Event Streams) and not necessarily to be installed of stand-alone.
However, it is perfectly acceptable to install this module pre-emptively in a cluster before identifying which specific 
services you want to include.

## Software dependencies

The module depends on the following software components:

### Command-line tools

- terraform - v12
- kubectl

### Terraform providers

- Helm provider >= 2.0.2 (provided by Terraform)

## Module dependencies

This module makes use of the output from other modules:

- Cluster - github.com/ibm-garage-cloud/terraform-ibm-container-platform.git
- Namespace - github.com/ibm-garage-clout/terraform-cluster-namespace.git

## Example usage

```hcl-terraform
module "cp4i" {
  source = "github.com/ibm-garage-cloud/terraform-ibm-cp4i?ref=v1.0.0"

  cluster_config_file = module.dev_cluster.config_file_path
  release_namespace   = module.dev_namespace.name
}
```

