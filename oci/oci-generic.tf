provider "oci" {
}

variable "oci_config_profile" {
  type                     = string
  description              = "The oci configuration file, generated by 'oci setup config'" 
}

variable "oci_root_compartment" {
  type                     = string
  description              = "The tenancy OCID a.k.a. root compartment, see README for CLI command to retrieve it."
}

variable "oci_region" {
  type                     = string
  description              = "Region to deploy services in."
}

variable "oci_imageid" {
  type                     = string
  description              = "An OCID of an image, the playbook is compatible with Ubuntu 18.04+ minimal"
}

variable "oci_adnumber" {
  type                     = number
  description              = "The OCI Availability Domain, only certain AD numbers are free_tier, like Ashburn's 2"
}

variable "oci_instance_shape" {
  type                     = string
  description              = "The size of the compute instance, only certain sizes are free_tier"
}

variable "ssh_key" {
  type                     = string
  description              = "Public SSH key for SSH to compute instance, user is ubuntu"
}

variable "vcn_cidr" {
  type                     = string
  description              = "Subnet (in CIDR notation) for the OCI network, change if would overlap existing resources"
}

variable "mgmt_cidr" {
  type                     = string
  description              = "Subnet (in CIDR notation) granted access to Pihole WebUI and SSH running on the compute instance. Also granted DNS access if dns_novpn = 1"
}

variable "fk_prefix" {
  type                     = string
  description              = "A friendly prefix (like 'pihole') affixed to many resources, like the bucket name."
}

variable "user_name" {
  type                     = string
  description              = "The username"
}

variable "apps" {
  type                     = map
  description              = "The apps"
}

variable "admin_password" {
  type                     = string
  description              = "Admin password"
}

variable "manager_password" {
  type                     = string
  description              = "Manager password"
}

variable "project_url" {
  type                     = string
  description              = "URL of the git project"
}

variable "project_directory" {
  type                     = string
  description              = "Location to install/run project"
  default                  = "/opt/fortknox"
}

variable "web_port" {
  type                     = string
  description              = "Port to run web proxy"
  default                  = "443"
}

variable "kms_vault_id" {
  type                     = string
  description              = "The id of the app vault"
}

variable "kms_key_id" {
  type                     = string
  description              = "The key for the app vault"
}

variable "kms_disk_vault_id" {
  type                     = string
  description              = "The id of the app vault"
}

variable "kms_disk_key_id" {
  type                     = string
  description              = "The key for the app vault"
}
