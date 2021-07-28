output "name" {
  description = "The name of the catalog that was installed"
  value       = local.catalog_name
  depends_on  = [
    null_resource.ibm_operator_catalog,
    null_resource.create_entitlement_secret,
    null_resource.setup_global_pull_secret
  ]
}
