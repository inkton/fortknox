data "oci_identity_tenancy" "tenant_details" {
  tenancy_id = var.tenancy_ocid
  provider = oci.current_region
}

# Check for resource limits
## Check available compute shape
#data "oci_limits_services" "compute_services" {
#  compartment_id = var.tenancy_ocid
#
#  filter {
#    name   = "name"
#    values = ["compute"]
#  }
#}

data "oci_identity_availability_domains" "ads" {
    compartment_id = var.tenancy_ocid
}

#data "oci_limits_limit_definitions" "compute_limit_definitions" {
#  compartment_id = var.tenancy_ocid
#  service_name   = data.oci_limits_services.compute_services.services.0.name
#
#  filter {
#    name   = "description"
#    values = [local.compute_shape_description]
#  }
#}

#data "oci_limits_resource_availability" "compute_resource_availability" {
#  compartment_id      = var.tenancy_ocid
#  limit_name          = data.oci_limits_limit_definitions.compute_limit_definitions.limit_definitions[0].name
#  service_name        = data.oci_limits_services.compute_services.services.0.name
#  availability_domain = data.oci_identity_availability_domains.ADs.availability_domains[count.index].name
#
#  count = length(data.oci_identity_availability_domains.ADs.availability_domains)
#}

#resource "random_shuffle" "compute_ad" {
#  input        = local.compute_available_limit_ad_list
#  result_count = length(local.compute_available_limit_ad_list)
#}

#locals {
#  compute_multiplier_nodes_ocpus  = local.is_flexible_instance_shape ? var.instance_ocpus : 1
#  compute_available_limit_ad_list = [for limit in data.oci_limits_resource_availability.compute_resource_availability : limit.availability_domain if(limit.available - local.compute_multiplier_nodes_ocpus) >= 0]
#  compute_available_limit_check = length(local.compute_available_limit_ad_list) == 0 ? (
#  file("ERROR: No limits available for the chosen compute shape and number of nodes or OCPUs")) : 0
#}

data "oci_identity_regions" "home_region" {
  filter {
    name   = "key"
    values = [data.oci_identity_tenancy.tenant_details.home_region_key]
  }

  provider = oci.current_region
}

# Available Services
#data "oci_core_services" "all_services" {
#  filter {
#    name   = "name"
#    values = ["All .* Services In Oracle Services Network"]
#    regex  = true
#  }
#}

# Gets a list of supported images based on the shape, operating_system and operating_system_version provided

data "oci_core_images" "compute_images" {
  compartment_id           = var.tenancy_ocid
  operating_system         = var.image_operating_system
  operating_system_version = var.image_operating_system_version
  shape                    = var.instance_shape
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

locals {
  common_tags = {
    company = "inkton"
    product = var.inkton_product
    product-variant = var.inkton_product_variant
  }
}