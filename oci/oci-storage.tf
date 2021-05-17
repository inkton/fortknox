data "oci_objectstorage_namespace" "fk_bucket_namespace" {
  compartment_id          = oci_identity_compartment.fk_compartment.id
}

resource "oci_objectstorage_bucket" "fk_bucket" {
  compartment_id          = oci_identity_compartment.fk_compartment.id
  name                    = "${var.fk_prefix}"
  namespace               = data.oci_objectstorage_namespace.fk_bucket_namespace.namespace
  kms_key_id              = oci_kms_key.fk_kms_storage_key.id
  access_type             = "NoPublicAccess"
  storage_tier            = "Standard"
  versioning              = "Disabled"
}

resource "oci_objectstorage_bucket" "fk_bucket_data" {
  compartment_id          = oci_identity_compartment.fk_compartment.id
  name                    = "${var.fk_prefix}-data"
  namespace               = data.oci_objectstorage_namespace.fk_bucket_namespace.namespace
  kms_key_id              = oci_kms_key.fk_kms_storage_key.id
  access_type             = "NoPublicAccess"
  storage_tier            = "Standard"
  versioning              = "Disabled"
}
