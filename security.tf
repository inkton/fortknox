#---  User & Group

resource "oci_identity_user" "user_admin" {
    compartment_id = var.tenancy_ocid
    description = "Admin for ${var.app_tag}"
    name = var.app_tag
    #email = allow_support_access ? 
 
    depends_on = [
        oci_identity_compartment.app_instance_compartment,
    ]
}

resource "oci_identity_user_capabilities_management" "user_admin-capabilities-management" {
    user_id                      = oci_identity_user.user_admin.id
    can_use_api_keys             = "true"
    can_use_auth_tokens          = "true"
    can_use_console_password     = "true"
    can_use_customer_secret_keys = "true"
    can_use_smtp_credentials     = "false"
}

resource "oci_identity_group" "user_group" {
    compartment_id = var.tenancy_ocid
    description = "Usergroup for ${var.app_group}"
    name = var.app_group

    depends_on = [
        oci_identity_compartment.app_instance_compartment,
    ]
}

resource "oci_identity_user_group_membership" "group_membership" {
    compartment_id = data.oci_identity_compartment.app_instance_compartment.id
    user_id        = oci_identity_user.user_admin.id
    group_id       = oci_identity_group.user_group.id

    depends_on = [
        oci_identity_user.user_admin, 
        oci_identity_group.user_group
    ]
}

resource "oci_identity_policy" "app_instance_compartment_policy" {
    name           = var.app_tag
    description    = "Compartment ${oci_identity_compartment.app_instance_compartment.name} Policy"
    compartment_id = oci_identity_compartment.app_instance_compartment.id

    statements = [
        "ALLOW GROUP ${oci_identity_group.user_group.name} to manage all-resources IN compartment ${oci_identity_compartment.app_instance_compartment.name}",
        "ALLOW GROUP Administrators to manage all-resources IN compartment ${oci_identity_compartment.app_instance_compartment.name}",
    ]

    depends_on = [
        oci_identity_user_group_membership.group_membership,
    ]
}

