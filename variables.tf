variable "cluster_config_file" {
  type        = string
  description = "Cluster config file for Kubernetes cluster."
}

variable "release_namespace" {
  type        = string
  description = "Name of the existing namespace where Pact Broker will be deployed."
  default     = "default"
}
