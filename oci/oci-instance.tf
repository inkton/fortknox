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
    docker_webproxy = var.docker_webproxy
    user_name = var.user_name
    admin_password_cipher = oci_kms_encrypted_data.fk_kms_fk_admin_secret.ciphertext
    manager_password_cipher = oci_kms_encrypted_data.fk_kms_fk_manager_secret.ciphertext 
    bucket_user_key_cipher = oci_kms_encrypted_data.fk_kms_bucket_user_key_secret.ciphertext
    bucket_user_id = oci_identity_customer_secret_key.fk_bucket_user_key.id
    oci_kms_endpoint = data.oci_kms_vault.fk_disk_vault.crypto_endpoint
    oci_kms_keyid = data.oci_kms_key.fk_key.id
    oci_storage_namespace = data.oci_objectstorage_namespace.fk_bucket_namespace.namespace
    oci_storage_bucketname = "${var.fk_prefix}"
    oci_region = var.oci_region
    oci_root_compartment = var.oci_root_compartment
    web_port = var.web_port
    project_directory = var.project_directory
  }
}

resource "oci_core_instance" "fk_instance" {

  for_each = var.apps

  compartment_id          = oci_identity_compartment.fk_compartment.id
  availability_domain     = data.oci_identity_availability_domain.fk_availability_domain.name
  display_name            = "${var.fk_prefix}-${each.key}"
  shape                   = var.oci_instance_shape  
  availability_config {
    recovery_action         = "RESTORE_INSTANCE"
  }
  create_vnic_details {
    display_name            = "${var.fk_prefix}-${each.key}"
    subnet_id               = oci_core_subnet.fk_subnet.id
  }
  source_details {
    source_id               = data.oci_core_image.fk_image.id
    source_type             = "image"
    #kms_key_id              = data.oci_kms_key.fk_key.id    
    #kms_key_id              = var.kms_key_id
  }
  metadata = {
    ssh_authorized_keys       = var.ssh_key
    user_data                 = base64encode(data.template_file.fk_user_data.rendered)
  }
  depends_on                = [oci_core_subnet.fk_subnet, oci_objectstorage_bucket.fk_bucket]
} 
