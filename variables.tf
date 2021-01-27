variable "cluster_config_file" {
  type        = string
  description = "Cluster config file for Kubernetes cluster."
}

variable "release_namespace" {
  type        = string
  description = "Name of the existing namespace where Pact Broker will be deployed."
  default     = "default"
}

variable "entitlement_key" {
  type        = string
  description = "The entitlement key used to access the CP4I images in the container registry. Visit https://myibm.ibm.com/products-services/containerlibrary to get the key"
  default     = ""
}

variable "cluster_type_code" {
  type        = string
  description = "The cluster_type of the cluster"
  default     = "ocp4"
}
