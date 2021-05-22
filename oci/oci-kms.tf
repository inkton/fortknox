data "oci_kms_vaults" "fk_kms" {
  compartment_id = oci_identity_compartment.fk_compartment.id
}

data "oci_kms_vault" "fk_vault" {
  vault_id = var.kms_vault_id != "" ? var.kms_vault_id : oci_kms_vault.fk_kms_vault[0].id
}

resource "oci_kms_vault" "fk_kms_vault" {
  count = var.kms_vault_id == "" ? 1 : 0
  compartment_id          = oci_identity_compartment.fk_compartment.id
  display_name            = "${var.fk_prefix}"
  vault_type              = "DEFAULT"
}

data "oci_kms_key" "fk_key" {
  key_id = var.kms_key_id != "" ? var.kms_key_id : oci_kms_key.fk_kms_key[0].id
  management_endpoint = data.oci_kms_vault.fk_vault.management_endpoint  
}

resource "oci_kms_key" "fk_kms_key" {
  count = var.kms_key_id == "" ? 1 : 0
  compartment_id          = oci_identity_compartment.fk_compartment.id
  display_name            = "${var.fk_prefix}"
  management_endpoint     = data.oci_kms_vault.fk_vault.management_endpoint

  key_shape {
    algorithm               = "AES"
    length                  = 32
  }
  protection_mode         = "SOFTWARE"
}

resource "oci_kms_encrypted_data" "fk_kms_fk_admin_secret" {
  crypto_endpoint         = data.oci_kms_vault.fk_vault.crypto_endpoint
  key_id                  = data.oci_kms_key.fk_key.id
  plaintext               = base64encode(var.admin_password)

  depends_on              = [data.oci_kms_vault.fk_vault, data.oci_kms_key.fk_key]
}

resource "oci_kms_encrypted_data" "fk_kms_fk_db_secret" {
  crypto_endpoint         = data.oci_kms_vault.fk_vault.crypto_endpoint
  key_id                  = data.oci_kms_key.fk_key.id
  plaintext               = base64encode(var.db_password)

  depends_on              = [data.oci_kms_vault.fk_vault, data.oci_kms_key.fk_key]
}

resource "oci_kms_encrypted_data" "fk_kms_fk_oo_secret" {
  crypto_endpoint         = data.oci_kms_vault.fk_vault.crypto_endpoint
  key_id                  = data.oci_kms_key.fk_key.id
  plaintext               = base64encode(var.oo_password)

  depends_on              = [data.oci_kms_vault.fk_vault, data.oci_kms_key.fk_key]
}

resource "oci_kms_encrypted_data" "fk_kms_bucket_user_key_secret" {
  crypto_endpoint         = data.oci_kms_vault.fk_vault.crypto_endpoint
  key_id                  = data.oci_kms_key.fk_key.id
  plaintext               = base64encode(oci_identity_customer_secret_key.fk_bucket_user_key.key)

  depends_on              = [data.oci_kms_vault.fk_vault, data.oci_kms_key.fk_key]
}

data "oci_kms_vault" "fk_disk_vault" {
  vault_id = var.kms_disk_vault_id != "" ? var.kms_disk_vault_id : oci_kms_vault.fk_kms_disk_vault[0].id
}

resource "oci_kms_vault" "fk_kms_disk_vault" {
  count = var.kms_disk_vault_id == "" ? 1 : 0
  compartment_id          = oci_identity_compartment.fk_compartment.id
  display_name            = "${var.fk_prefix}-disk"
  vault_type              = "DEFAULT"

  depends_on              = [oci_identity_compartment.fk_compartment]
}

data "oci_kms_key" "fk_disk_key" {
  key_id = var.kms_disk_key_id != "" ? var.kms_disk_key_id : oci_kms_key.fk_kms_disk_key[0].id
  management_endpoint = data.oci_kms_vault.fk_disk_vault.management_endpoint  

  depends_on              = [data.oci_kms_vault.fk_disk_vault, oci_kms_key.fk_kms_disk_key]
}

resource "oci_kms_key" "fk_kms_disk_key" {
  count = var.kms_disk_key_id == "" ? 1 : 0
  compartment_id          = oci_identity_compartment.fk_compartment.id
  display_name            = "${var.fk_prefix}-disk-key"
  management_endpoint     = data.oci_kms_vault.fk_disk_vault.management_endpoint

  key_shape {
    algorithm               = "AES"
    length                  = 32
  }
  protection_mode         = "SOFTWARE"

  depends_on              = [oci_identity_compartment.fk_compartment, data.oci_kms_vault.fk_disk_vault]
}
