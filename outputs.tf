output "inkton_username" {
  value = var.inkton_username
}
output "inkton_product" {
  value = var.inkton_product
}
output "inkton_product_variant" {
  value = var.inkton_product_variant
}
output "inkton_deployment_id" {
  value = var.inkton_deployment_id
}
output "region_to_deploy" {
  value = local.region_to_deploy
}
output "inkton_compartment_name" {
  value = oci_identity_compartment.app_instance_compartment.name
} 
output "inkton_compartment_ocid" {
  value = oci_identity_compartment.app_instance_compartment.id
}
