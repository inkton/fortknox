# Copyright (c) 2019-2021 Inkton and/or its affiliates. All rights reserved.

#---  Principle

variable "tenancy_ocid" {
  default = "ocid1.tenancy.oc1..aaaaaaaavfhzpaqzmwlnk3idf6a2prm7iyq5ydqfoaedsqgvdoz5324uzutq"
}

variable "region" {
  default = "ap-sydney-1"
}

variable "compartment_ocid" {
  default = ""
}

variable "user_ocid" {
  default = "ocid1.user.oc1..aaaaaaaavuyodmmtb7hkjf5byzzsrjup3rfsrxhc4lcn2pdituccsahdhv5a"
}

variable "fingerprint" {
  default = ""
} 

variable "private_key_path" {
  default = ""
}

variable "public_ssh_key" {
  default = ""
}

#---  App

variable "app_tag" {
  default = "FortKnox"
}

variable "app_group" {
  default = "Inkton"
}

variable "inkton_username" {
  default = "john"
}

variable "inkton_product" {
  default = "fortknox"
}

variable "inkton_product_variant" {
  default = "starter"
}

variable "inkton_deployment_id" {
  default = "888"
}

#---  Network

variable "network_cidrs" {
  type = map(string)

  default = {
    VCN-CIDR                = "10.1.0.0/16"
    SUBNET-REGIONAL-CIDR    = "10.1.21.0/24"
    ALL-CIDR                = "0.0.0.0/0"
  }
}

variable "allow_support_access" {
  default = true
}

#---  OCI Vault/Key Management/KMS

variable "use_encryption_from_oci_vault" {
  default = false
}

variable "create_new_encryption_key" {
  default = true
}

#---  Compute

variable "generate_public_ssh_key" {
  default = true
}

variable "instance_ocpus" {
  default = 1
}

variable "instance_shape_config_memory_in_gbs" {
  default = 16
}

variable "image_operating_system" {
  default = "Oracle Linux"
}

variable "image_operating_system_version" {
  default = "7.9"
}

variable "instance_visibility" {
  default = "Public"
}

variable "is_pv_encryption_in_transit_enabled" {
  default = false
}

variable "instance_shape" {
  default = "VM.Standard.E2.1.Micro"
}
