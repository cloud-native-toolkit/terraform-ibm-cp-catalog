provider "helm" {
  version = ">= 1.1.1"
  kubernetes {
    config_path = var.cluster_config_file
  }
}

locals {
  repo  = "https://redhat-developer.github.io/redhat-helm-charts/"
  chart = "ibm-operator-catalog-enablement"
}

resource "helm_release" "ibm_operator_catalog" {
  name              = "ibm-operator-catalog-enablement"
  repository        = local.repo
  chart             = local.chart
  namespace         = var.release_namespace
  timeout           = 1200
  dependency_update = true
  force_update      = true
  replace           = true

  disable_openapi_validation = true

  set {
    name  = "license"
    value = "true"
  }
}
