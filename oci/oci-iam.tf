resource "oci_identity_dynamic_group" "fk_id_dynamic_group" {
  compartment_id          = data.oci_identity_compartment.fk_root_compartment.id
  name                    = "${var.fk_prefix}"
  description             = "Identity Dynamic Group for Compute Instance in Compartment"
  matching_rule           = "All {instance.compartment.id = '${oci_identity_compartment.fk_compartment.id}'}"
}

resource "oci_identity_policy" "fk_id_instance_policy" {
  compartment_id          = data.oci_identity_compartment.fk_root_compartment.id
  name                    = "${var.fk_prefix}-instance-policy"
  description             = "Identity Policy for instance to use object storage encryption"
  statements              = ["Allow dynamic-group ${oci_identity_dynamic_group.fk_id_dynamic_group.name} to use secret-family in compartment id ${oci_identity_compartment.fk_compartment.id} where target.vault.id='${data.oci_kms_vault.fk_vault.id}'","Allow dynamic-group ${oci_identity_dynamic_group.fk_id_dynamic_group.name} to use vaults in compartment id ${oci_identity_compartment.fk_compartment.id} where target.vault.id='${data.oci_kms_vault.fk_vault.id}'","Allow dynamic-group ${oci_identity_dynamic_group.fk_id_dynamic_group.name} to use keys in compartment id ${oci_identity_compartment.fk_compartment.id} where target.vault.id='${data.oci_kms_vault.fk_vault.id}'","Allow dynamic-group ${oci_identity_dynamic_group.fk_id_dynamic_group.name} to manage object-family in compartment id ${oci_identity_compartment.fk_compartment.id} where target.bucket.name='${var.fk_prefix}'","Allow dynamic-group ${oci_identity_dynamic_group.fk_id_dynamic_group.name} to read virtual-network-family in compartment id ${oci_identity_compartment.fk_compartment.id}"]
}

resource "oci_identity_policy" "fk_id_disk_policy" {
  compartment_id          = data.oci_identity_compartment.fk_root_compartment.id
  name                    = "${var.fk_prefix}-id-disk-policy"
  description             = "Identity Policy for disk encryption"
  statements              = ["Allow service blockstorage to use keys in compartment id ${oci_identity_compartment.fk_compartment.id} where target.vault.id='${data.oci_kms_vault.fk_disk_vault.id}'"]
}

resource "oci_identity_policy" "fk_id_storageobject_policy" {
  compartment_id          = data.oci_identity_compartment.fk_root_compartment.id
  name                    = "${var.fk_prefix}-id-storageobject-policy"
  description             = "Identity Policy for objectstorage service"
  statements              = ["Allow service objectstorage-${var.oci_region} to use keys in compartment id ${oci_identity_compartment.fk_compartment.id} where target.vault.id='${data.oci_kms_vault.fk_vault.id}'","Allow service objectstorage-${var.oci_region} to manage object-family in compartment id ${oci_identity_compartment.fk_compartment.id}"]
}

resource "oci_identity_group" "fk_bucket_group" {
  compartment_id          = data.oci_identity_compartment.fk_root_compartment.id
  description             = "OCI bucket group"
  name                    = "${var.fk_prefix}-bucket-group"
}

resource "oci_identity_user" "fk_bucket_user" {
  compartment_id          = data.oci_identity_compartment.fk_root_compartment.id
  description             = "OCI bucket user"
  name                    = "${var.fk_prefix}-bucket-user"
}

resource "oci_identity_user_group_membership" "fk_bucket_group_membership" {
  group_id                = oci_identity_group.fk_bucket_group.id
  user_id                 = oci_identity_user.fk_bucket_user.id
}

resource "oci_identity_customer_secret_key" "fk_bucket_user_key" {
  display_name            = "${var.fk_prefix}"
  user_id                 = oci_identity_user.fk_bucket_user.id
}

resource "oci_identity_policy" "fk_id_bucket_policy" {
  compartment_id          = data.oci_identity_compartment.fk_root_compartment.id
  name                    = "${var.fk_prefix}-bucket-policy"
  description             = "Identity Policy for instance bucket user to use object storage encryption for data bucket"
  statements              = ["Allow group ${oci_identity_group.fk_bucket_group.name} to manage object-family in compartment id ${oci_identity_compartment.fk_compartment.id} where target.bucket.name='${var.fk_prefix}-data'"]
}
