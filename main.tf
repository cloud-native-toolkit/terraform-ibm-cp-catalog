provider "helm" {
  version = ">= 2.0.2"
  kubernetes {
    config_path = var.cluster_config_file
  }
}

locals {
  repo         = "https://redhat-developer.github.io/redhat-helm-charts/"
  chart        = "ibm-operator-catalog-enablement"
  secret_name  = "ibm-entitlement-key"
  catalog_name = "ibm-operator-catalog"
  catalog_namespace = "openshift-marketplace"
}

resource null_resource ibm_operator_catalog {
  triggers = {
    KUBECONFIG=var.cluster_config_file
    name = local.chart
    chart = local.chart
    repo = local.repo
  }

  provisioner "local-exec" {
    command = "${path.module}/scripts/generate-catalog-yaml.sh ${self.triggers.name} ${self.triggers.chart} ${self.triggers.repo} | kubectl apply -f -"

    environment = {
      KUBECONFIG = self.triggers.KUBECONFIG
    }
  }

  provisioner "local-exec" {
    when = destroy
    command = "${path.module}/scripts/generate-catalog-yaml.sh ${self.triggers.name} ${self.triggers.chart} ${self.triggers.repo} | kubectl delete -f -"

    environment = {
      KUBECONFIG = self.triggers.KUBECONFIG
    }
  }
}

resource "null_resource" "create_entitlement_secret" {
  count = var.entitlement_key != "" ? 1 : 0

  triggers = {
    KUBECONFIG = var.cluster_config_file
    namespace  = var.release_namespace
    name       = local.secret_name
  }

  provisioner "local-exec" {
    command = "${path.module}/scripts/create-pull-secret.sh ${self.triggers.namespace} ${self.triggers.name}"

    environment = {
      KUBECONFIG      = self.triggers.KUBECONFIG
      ENTITLEMENT_KEY = var.entitlement_key
    }
  }

  provisioner "local-exec" {
    when    = destroy
    command = "${path.module}/scripts/destroy-pull-secret.sh ${self.triggers.namespace} ${self.triggers.name}"

    environment = {
      KUBECONFIG      = self.triggers.KUBECONFIG
    }
  }
}

resource "null_resource" "setup_global_pull_secret" {
  count = var.entitlement_key != "" ? 1 : 0
  depends_on = [null_resource.create_entitlement_secret]

  provisioner "local-exec" {
    command = "${path.module}/scripts/add-to-global-pull-secret.sh ${var.cluster_type_code} ${var.release_namespace} ${local.secret_name}"

    environment = {
      KUBECONFIG      = var.cluster_config_file
    }
  }
}
