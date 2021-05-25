#!/bin/bash

mkdir -p ${project_directory}
mkdir -p ${project_directory}/fortknox_db

# Create ansible vars
tee '${project_directory}/playbooks/vars/main.yml'<< EOM
ansible_python_interpreter: /usr/bin/python2
mysql_datadir: {{ project_directory }}/fortknox_db
mysql_root_password: {{ admin_password_decrypt.decrypted_data.plaintext | b64decode }}
mysql_databases:
  - name: fortknox
    encoding: utf8
    collation: utf8_general_ci
mysql_users:
  - name: fortknox
    host: "%"
    password: {{ db_password_decrypt.decrypted_data.plaintext | b64decode }}
    priv: "fortknox.*:ALL"
EOM

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
tee '${project_directory}/fortknox-ansible-state.sh' << EOM
#!/bin/bash
# Install git pre-requisties
sudo yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum -y install https://rpms.remirepo.net/enterprise/remi-release-7.rpm
sudo yum -y install yum-utils
sudo yum-config-manager --enable remi-safe
# Update package list
yum check-update
yum install -y tmux git rh-python38
# Install the oci collection
pip3 install --upgrade pip ansible oci PyMySQL
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
/usr/local/bin/ansible-playbook fortknox_oci.yml --extra-vars 'admin_password_cipher=${admin_password_cipher} manager_password_cipher=${manager_password_cipher} oci_kms_endpoint=${oci_kms_endpoint} oci_kms_keyid=${oci_kms_keyid} oci_storage_namespace=${oci_storage_namespace} oci_storage_bucketname=${oci_storage_bucketname} oci_region=${oci_region} oci_root_compartment=${oci_root_compartment} bucket_user_key_cipher=${bucket_user_key_cipher} bucket_user_id=${bucket_user_id} web_port=${web_port} project_directory=${project_directory}'
EOM

# Start / Enable cloudoffice-ansible-state
chmod +x /opt/cloudoffice-ansible-state.sh
systemctl daemon-reload
systemctl start cloudoffice-ansible-state.timer
systemctl start cloudoffice-ansible-state.service
systemctl enable cloudoffice-ansible-state.timer
systemctl enable cloudoffice-ansible-state.service

EOM

# Start / Enable fortknox-ansible-state
chmod +x '${project_directory}/fortknox-ansible-state.sh'
systemctl daemon-reload
systemctl start fortknox-ansible-state.timer
systemctl start fortknox-ansible-state.service
systemctl enable fortknox-ansible-state.timer
systemctl enable fortknox-ansible-state.service
