data "oci_kms_vaults" "fk_kms" {
  compartment_id = oci_identity_compartment.fk_compartment.id
}

#locals {
#  existing_fortknox_vault = [for vault in data.oci_kms_vaults.fk_kms.vaults : vault if vault.display_name == "fortknox-vault"][0]
#}

data "oci_kms_vault" "fk_vault" {
  vault_id = var.vault_id != null ? var.vault_id : oci_kms_vault.fk_kms_disk_vault[0].id
}

resource "oci_kms_vault" "fk_kms_storage_vault" {
  count = var.vault_id == null ? 1 : 0
  compartment_id          = oci_identity_compartment.fk_compartment.id
  display_name            = "${var.fk_prefix}-vault"
  vault_type              = "DEFAULT"
}

resource "oci_kms_key" "fk_kms_storage_key" {
  compartment_id          = oci_identity_compartment.fk_compartment.id
  display_name            = "${var.fk_prefix}"
  management_endpoint     = data.oci_kms_vault.fk_vault.management_endpoint
  #management_endpoint = oci_kms_vault.oda_fk_kms_storage_vault[0].management_endpoint

  key_shape {
    algorithm               = "AES"
    length                  = 32
  }
  protection_mode         = "SOFTWARE"
}

resource "oci_kms_encrypted_data" "fk_kms_fk_admin_secret" {
  crypto_endpoint         = data.oci_kms_vault.fk_vault.crypto_endpoint
  key_id                  = oci_kms_key.fk_kms_storage_key.id
  plaintext               = base64encode(var.admin_password)
}

resource "oci_kms_encrypted_data" "fk_kms_fk_db_secret" {
  crypto_endpoint         = data.oci_kms_vault.fk_vault.crypto_endpoint
  key_id                  = oci_kms_key.fk_kms_storage_key.id
  plaintext               = base64encode(var.db_password)
}

resource "oci_kms_encrypted_data" "fk_kms_fk_oo_secret" {
  crypto_endpoint         = data.oci_kms_vault.fk_vault.crypto_endpoint
  key_id                  = oci_kms_key.fk_kms_storage_key.id
  plaintext               = base64encode(var.oo_password)
}

resource "oci_kms_encrypted_data" "fk_kms_bucket_user_key_secret" {
  crypto_endpoint         = data.oci_kms_vault.fk_vault.crypto_endpoint
  key_id                  = oci_kms_key.fk_kms_storage_key.id
  plaintext               = base64encode(oci_identity_customer_secret_key.fk_bucket_user_key.key)
}

#locals {
#  existing_fortknox_disk_vault = [for vault in data.oci_kms_vaults.fk_kms.vaults : vault if vault.display_name == "fortknox-disk-vault"][0]
#}

data "oci_kms_vault" "fk_disk_vault" {
  vault_id = var.disk_vault_id != null ? var.disk_vault_id : oci_kms_vault.fk_kms_disk_vault[0].id
}

resource "oci_kms_vault" "fk_kms_disk_vault" {
  count = var.disk_vault_id == null ? 1 : 0
  compartment_id          = oci_identity_compartment.fk_compartment.id
  display_name            = "${var.fk_prefix}-disk-vault"
  vault_type              = "DEFAULT"
}

resource "oci_kms_key" "fk_kms_disk_key" {
  compartment_id          = oci_identity_compartment.fk_compartment.id
  display_name            = "${var.fk_prefix}_disk_key"
  management_endpoint     = data.oci_kms_vault.fk_disk_vault.management_endpoint

  key_shape {
    algorithm               = "AES"
    length                  = 32
  }
  protection_mode         = "SOFTWARE"
}
