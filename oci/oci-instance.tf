data "oci_core_image" "fk_image" {
  image_id                = var.oci_imageid
}

data "oci_identity_availability_domain" "fk_availability_domain" {
  compartment_id          = oci_identity_compartment.fk_compartment.id
  ad_number               = var.oci_adnumber
}

data "template_file" "fk_user_data" {
  template                = file("oci-user_data.tpl")
  vars                    = {
    project_url = var.project_url
    docker_network = var.docker_network
    docker_gw = var.docker_gw
    docker_nextcloud = var.docker_nextcloud
    docker_db = var.docker_db
    docker_webproxy = var.docker_webproxy
    docker_onlyoffice = var.docker_onlyoffice
    admin_password_cipher = oci_kms_encrypted_data.fk_kms_fk_admin_secret.ciphertext
    db_password_cipher = oci_kms_encrypted_data.fk_kms_fk_db_secret.ciphertext
    oo_password_cipher = oci_kms_encrypted_data.fk_kms_fk_oo_secret.ciphertext
    bucket_user_key_cipher = oci_kms_encrypted_data.fk_kms_bucket_user_key_secret.ciphertext
    bucket_user_id = oci_identity_customer_secret_key.fk_bucket_user_key.id
    #oci_kms_endpoint = oci_kms_vault.fk_kms_storage_vault[0].crypto_endpoint
    oci_kms_endpoint = "https://cjqjswloaaffe_crypto.kms.ap_sydney_1.oraclecloud.com"
    oci_kms_keyid = oci_kms_key.fk_kms_storage_key.id
    oci_storage_namespace = data.oci_objectstorage_namespace.fk_bucket_namespace.namespace
    oci_storage_bucketname = "${var.fk_prefix}"
    oci_region = var.oci_region
    oci_root_compartment = var.oci_root_compartment
    web_port = var.web_port
    oo_port = var.oo_port
    project_directory = var.project_directory
  }
}

resource "oci_core_instance" "fk_instance" {
  compartment_id          = oci_identity_compartment.fk_compartment.id
  availability_domain     = data.oci_identity_availability_domain.fk_availability_domain.name
  display_name            = "${var.fk_prefix}"
  shape                   = var.oci_instance_shape
  availability_config {
    recovery_action         = "RESTORE_INSTANCE"
  }
  create_vnic_details {
    display_name            = "${var.fk_prefix}_nic"
    subnet_id               = oci_core_subnet.fk_subnet.id
  }
  source_details {
    source_id               = data.oci_core_image.fk_image.id
    source_type             = "image"
    kms_key_id              = oci_kms_key.fk_kms_disk_key.id
  }
  metadata = {
    ssh_authorized_keys       = var.ssh_key
    user_data                 = base64encode(data.template_file.fk_user_data.rendered)
  }
  depends_on                = [oci_identity_policy.fk_id_instance_policy,oci_identity_policy.fk_id_bucket_policy,oci_identity_policy.fk_id_disk_policy]
} 
