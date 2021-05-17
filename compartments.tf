# create the compartment in the Home region
resource oci_identity_compartment "app_instance_compartment" {
  provider = oci.home_region
  compartment_id = var.tenancy_ocid
  name           = var.app_tag
  description    = "The FortKnox Compartment"
  freeform_tags  = local.common_tags
  enable_delete  = true
}
