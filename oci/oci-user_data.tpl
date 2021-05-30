#!/bin/bash

# Create systemd service unit file
tee /etc/systemd/system/fortknox-ansible-state.service << EOM
[Unit]
Description=fortknox-ansible-state
After=network.target

[Service]
ExecStart=${project_directory}/fortknox-ansible-state.sh
Type=simple
Restart=on-failure
RestartSec=30

[Install]
WantedBy=multi-user.target
EOM

# Create systemd timer unit file
tee /etc/systemd/system/fortknox-ansible-state.timer << EOM
[Unit]
Description=Starts Fortknox Ansible state playbook 1min after boot

[Timer]
OnBootSec=1min
Unit=fortknox-ansible-state.service

[Install]
WantedBy=multi-user.target
EOM

# Create fortknox-ansible-state script
mkdir -p ${project_directory}
tee '${project_directory}/fortknox-ansible-state.sh' << EOM
#!/bin/bash
yum check-update
# Install pre-requisties
<<<<<<< HEAD
yum -y install yum-utils tmux git rh-python38 policycoreutils-python-utils
=======
yum -y install yum-utils tmux git rh-python38
>>>>>>> 509d36dc03f60a01464faa37b218d99dd4a61fc2
yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum -y install https://rpms.remirepo.net/enterprise/remi-release-7.rpm
yum-config-manager --enable remi-safe
# Install the oci collection and pre-req
pip3 install --upgrade pip ansible oci
/usr/local/bin/ansible-galaxy collection install oracle.oci
# Clone and change to directory
/usr/bin/git clone ${project_url} ${project_directory}/repo 
# Change to directory
cd ${project_directory}/repo 
# Ensure up-to-date
/usr/bin/git pull
# Change to playbooks directory
cd playbooks/
# Execute playbook
/usr/local/bin/ansible-playbook fortknox_oci.yml --extra-vars 'user_name=${user_name} app_tag=${app_tag} admin_password_cipher=${admin_password_cipher} manager_password_cipher=${manager_password_cipher} oci_kms_endpoint=${oci_kms_endpoint} oci_kms_keyid=${oci_kms_keyid} oci_storage_namespace=${oci_storage_namespace} oci_storage_bucketname=${oci_storage_bucketname} oci_region=${oci_region} oci_root_compartment=${oci_root_compartment} bucket_user_key_cipher=${bucket_user_key_cipher} bucket_user_id=${bucket_user_id} web_port=${web_port} project_directory=${project_directory}'
EOM

# Start / Enable fortknox-ansible-state
chmod +x '${project_directory}/fortknox-ansible-state.sh'
systemctl daemon-reload
systemctl start fortknox-ansible-state.timer
systemctl start fortknox-ansible-state.service
systemctl enable fortknox-ansible-state.timer
systemctl enable fortknox-ansible-state.service