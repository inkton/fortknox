data "oci_identity_compartment" "fk_root_compartment" {
  id                      = var.oci_root_compartment
}

resource "oci_identity_compartment" "fk_compartment" {
  compartment_id          = data.oci_identity_compartment.fk_root_compartment.id
  description             = "${var.fk_prefix}"
  name                    = "${var.fk_prefix}"
}

/*
resource "random_string" "fk_random" {
  length                            = 5
  upper                             = false
  special                           = false
}
*/