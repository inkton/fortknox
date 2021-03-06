output "fk_output" {

  value = [
    for app_tag, app in var.apps:
      <<OUTPUT

        #############
        ## OUTPUTS ##
        #############

        ## SSH ##  

        ssh oci@${oci_core_instance.fk_instance[app_tag].public_ip}

        ## WebUI ##
        https://${oci_core_instance.fk_instance[app_tag].public_ip}:${var.web_port}/

        ## Update / Ansible Rerun Instructions ##
        ssh opc@${oci_core_instance.fk_instance[app_tag].public_ip}

        # If updating containers, remove the old containers - this brings down the service until ansible is re-applied.
        #sudo docker rm -f cloudoffice_database cloudoffice_nextcloud cloudoffice_webproxy cloudoffice_onlyoffice

        # Re-apply Ansible playbook with custom variables
        sudo systemctl start fortknox-ansible-state.service

        ## Destroying the Deployment ##
        # If destroying a project, delete all bucket objects before running terraform destroy, e.g:
        oci os object bulk-delete-versions -bn ${oci_objectstorage_bucket.fk_bucket.name} -ns ${data.oci_objectstorage_namespace.fk_bucket_namespace.namespace}
        oci os object bulk-delete-versions -bn ${oci_objectstorage_bucket.fk_bucket.name}-data -ns ${data.oci_objectstorage_namespace.fk_bucket_namespace.namespace}
        OUTPUT
  ]
}
