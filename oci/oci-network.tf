resource "oci_core_vcn" "fk_vcn" {
  compartment_id               = oci_identity_compartment.fk_compartment.id
  cidr_block                   = var.vcn_cidr
  display_name                 = "${var.fk_prefix}"
  dns_label                    = var.fk_prefix
}

resource "oci_core_internet_gateway" "fk_internet_gateway" {
  compartment_id               = oci_identity_compartment.fk_compartment.id
  vcn_id                       = oci_core_vcn.fk_vcn.id
  display_name                 = "${var.fk_prefix}-internet"
  enabled                      = "true"
}

resource "oci_core_subnet" "fk_subnet" {
  compartment_id               = oci_identity_compartment.fk_compartment.id
  vcn_id                       = oci_core_vcn.fk_vcn.id
  cidr_block                   = var.vcn_cidr
  display_name                 = "${var.fk_prefix}"
}

resource "oci_core_default_route_table" "fk_route_table" {
  manage_default_resource_id   = oci_core_vcn.fk_vcn.default_route_table_id
  route_rules {
    network_entity_id            = oci_core_internet_gateway.fk_internet_gateway.id
    destination                  = "0.0.0.0/0"
    destination_type             = "CIDR_BLOCK"
  }
}

resource "oci_core_route_table_attachment" "fk_route_table_attach" {
  subnet_id                    = oci_core_subnet.fk_subnet.id
  route_table_id               = oci_core_vcn.fk_vcn.default_route_table_id
}

resource "oci_core_network_security_group" "fk_network_security_group" {
  compartment_id               = oci_identity_compartment.fk_compartment.id
  vcn_id                       = oci_core_vcn.fk_vcn.id
  display_name                 = "${var.fk_prefix}"
}

resource "oci_core_default_security_list" "fk_security_list" {
  manage_default_resource_id   = oci_core_vcn.fk_vcn.default_security_list_id
  display_name                 = "${var.fk_prefix}"
  egress_security_rules {
    protocol                     = "all"
    destination                  = "0.0.0.0/0"
  }
  ingress_security_rules {
    protocol                     = 6
    source                       = var.mgmt_cidr
    tcp_options {
      max                          = "22"
      min                          = "22"
    }
  }
  ingress_security_rules {
    protocol                     = 6
    source                       = var.mgmt_cidr
    tcp_options {
      max                          = var.web_port
      min                          = var.web_port
    }
  }
  ingress_security_rules {
    protocol                     = 6
    source                       = var.mgmt_cidr
    tcp_options {
      max                          = var.oo_port
      min                          = var.oo_port
    }
  }
  ingress_security_rules {
    protocol                     = 6
    source                       = "${oci_core_instance.fk_instance.public_ip}/32"
    tcp_options {
      max                          = var.web_port
      min                          = var.web_port
    }
  }
  ingress_security_rules {
    protocol                     = 6
    source                       = "${oci_core_instance.fk_instance.public_ip}/32"
    tcp_options {
      max                          = var.oo_port
      min                          = var.oo_port
    }
  }
}
