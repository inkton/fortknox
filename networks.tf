#---  VCN

resource "oci_core_virtual_network" "app_instance_vcn" {
  cidr_block     = lookup(var.network_cidrs, "VCN-CIDR")
  compartment_id = oci_identity_compartment.app_instance_compartment.id

  display_name   = "${var.app_tag} VCN"
  dns_label      = "${var.inkton_product}"
  freeform_tags  = local.common_tags

  depends_on = [
    oci_identity_policy.app_instance_compartment_policy
  ]
}

#---  Internet Gateway

resource "oci_core_internet_gateway" "app_instance_internet_gateway" {
  compartment_id = oci_identity_compartment.app_instance_compartment.id
  display_name   = "${var.app_tag} Internet"
  vcn_id         = oci_core_virtual_network.app_instance_vcn.id
  freeform_tags  = local.common_tags

  depends_on = [
    oci_core_virtual_network.app_instance_vcn
  ]
}

resource "oci_core_route_table" "app_instance_route_table" {
  compartment_id = oci_identity_compartment.app_instance_compartment.id
  vcn_id         = oci_core_virtual_network.app_instance_vcn.id
  display_name   = "${var.app_tag} Route Table"
  freeform_tags  = local.common_tags

  dynamic "route_rules" {
    destination       = lookup(var.network_cidrs, "ALL-CIDR")
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.app_instance_internet_gateway.id
  }

#  depends_on = [
#    oci_core_internet_gateway.app_instance_internet_gateway, 
#  ]
}

#---  Security List

resource "oci_core_security_list" "app_instance_security_list" {
  compartment_id = oci_identity_compartment.app_instance_compartment.id
  vcn_id         = oci_core_virtual_network.app_instance_vcn.id
  display_name   = "${var.app_tag} VCN Security-List"
  freeform_tags  = local.common_tags

  egress_security_rules {
    protocol    = local.tcp_protocol_number
    destination = lookup(var.network_cidrs, "ALL-CIDR")
  }

  ingress_security_rules {
    protocol = local.tcp_protocol_number
    source   = lookup(var.network_cidrs, "ALL-CIDR")

    tcp_options {
      max = local.ssh_port_number
      min = local.ssh_port_number
    }
  }

  ingress_security_rules {
    protocol = local.tcp_protocol_number
    source   = lookup(var.network_cidrs, "ALL-CIDR")

    tcp_options {
      max = local.https_port_number
      min = local.https_port_number
    }
  }

  depends_on = [
    oci_core_virtual_network.app_instance_vcn
  ]  
}

locals {
  https_port_number         = "443"
  ssh_port_number           = "22"
  tcp_protocol_number       = "6"
  all_protocols             = "all"
}

#---  Subnet

resource "oci_core_subnet" "app_instance_subnet_public" {
  cidr_block                 = lookup(var.network_cidrs, "SUBNET-REGIONAL-CIDR")
  display_name               = "${var.app_tag} Public Internet"
  dns_label                  = "${var.inkton_product}public"
  compartment_id             = oci_identity_compartment.app_instance_compartment.id
  vcn_id                     = oci_core_virtual_network.app_instance_vcn.id
  route_table_id             = oci_core_route_table.app_instance_route_table.id
  security_list_ids          = [oci_core_security_list.app_instance_security_list.id]
  dhcp_options_id            = oci_core_virtual_network.app_instance_vcn.default_dhcp_options_id
  prohibit_public_ip_on_vnic = (var.instance_visibility == "Private") ? true : false
  freeform_tags              = local.common_tags

  depends_on = [
    oci_core_route_table.app_instance_route_table
  ]
}
