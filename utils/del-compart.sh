set -x
OCI_TENANCY_OCID=ocid1.tenancy.oc1..aaaaaaaavfhzpaqzmwlnk3idf6a2prm7iyq5ydqfoaedsqgvdoz5324uzutq
OCI_CMPT_ID=ocid1.compartment.oc1..aaaaaaaa4ybsj6yp657pvq6sg5wbicazfjupjmd7t2ntzn3sfm6qd4xg37jq
OCI_CMPT_NAME=nextcloud-compartment

OCID_CMPT_STACK=$(oci resource-manager stack create-from-compartment  --compartment-id ${OCI_TENANCY_OCID} --config-source-compartment-id ${OCI_CMPT_ID} \
    --config-source-region PHX --terraform-version "0.13.x"\
    --display-name "Stack_${OCI_CMPT_NAME}" --description 'Stack From Compartment ${OCI_CMPT_NAME}' --wait-for-state SUCCEEDED --query "data.resources[0].identifier" --raw-output)
echo $OCID_CMPT_STACK

oci resource-manager job create-destroy-job  --execution-plan-strategy 'AUTO_APPROVED'  --stack-id ${OCID_CMPT_STACK} --wait-for-state SUCCEEDED
# twice since it fails sometimes and running it twice is idempotent
oci resource-manager job create-destroy-job  --execution-plan-strategy 'AUTO_APPROVED'  --stack-id ${OCID_CMPT_STACK} --wait-for-state SUCCEEDED
#delete the terraform stack only if you no longer need it...keep it incase you want to recreate all resources!!    
oci resource-manager stack delete --stack-id ${OCID_CMPT_STACK} --force --wait-for-state DELETED

#delete the empty compartment
oci iam compartment delete -c ${OCI_CMPT_ID} --force --wait-for-state SUCCEEDED
