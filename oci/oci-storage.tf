data "oci_objectstorage_namespace" "fk_bucket_namespace" {
  compartment_id          = oci_identity_compartment.fk_compartment.id

  depends_on              = [oci_identity_compartment.fk_compartment]
}

resource "oci_objectstorage_bucket" "fk_bucket" {
  compartment_id          = oci_identity_compartment.fk_compartment.id
  name                    = "${var.fk_prefix}"
  namespace               = data.oci_objectstorage_namespace.fk_bucket_namespace.namespace
  #kms_key_id              = var.kms_key_id != "" ? var.kms_key_id : oci_kms_key.fk_kms_key[0].id
  #kms_key_id              = var.kms_key_id
  #access_type             = "NoPublicAccess"
  storage_tier            = "Standard"
  versioning              = "Disabled"

  depends_on              = [oci_identity_policy.fk_id_bucket_policy, data.oci_objectstorage_namespace.fk_bucket_namespace, data.oci_kms_key.fk_key]
}

resource "oci_objectstorage_bucket" "fk_bucket_data" {
  compartment_id          = oci_identity_compartment.fk_compartment.id
  name                    = "${var.fk_prefix}-data"
  namespace               = data.oci_objectstorage_namespace.fk_bucket_namespace.namespace
  #kms_key_id              = var.kms_key_id != "" ? var.kms_key_id : oci_kms_key.fk_kms_key[0].id
  #kms_key_id              = var.kms_key_id
  #access_type             = "NoPublicAccess"
  storage_tier            = "Standard"
  versioning              = "Disabled"

  depends_on              = [oci_identity_policy.fk_id_bucket_policy, data.oci_objectstorage_namespace.fk_bucket_namespace, data.oci_kms_key.fk_key]
}
