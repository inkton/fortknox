#!/bin/bash

#mkdir -p ${project_directory}

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
# Update package list
yum check-update
# Install pip3 and git
# sudo yum install -y python34-setuptools git
# sudo easy_install-3.4 pip
# Pip update pip
pip3 install --upgrade pip
# Install ansible and oci libraries
pip3 install --upgrade ansible oci
# And the collection
ansible-galaxy collection install oracle.oci
# Change to directory
cd ${project_directory}
# Execute playbook
#ansible-playbook fortknox_oci.yml --extra-vars 'docker_network=${docker_network} docker_gw=${docker_gw} docker_nextcloud=${docker_nextcloud} docker_db=${docker_db} docker_webproxy=${docker_webproxy} docker_onlyoffice=${docker_onlyoffice} admin_password_cipher=${admin_password_cipher} db_password_cipher=${db_password_cipher} oo_password_cipher=${oo_password_cipher} oci_kms_endpoint=${oci_kms_endpoint} oci_kms_keyid=${oci_kms_keyid} oci_storage_namespace=${oci_storage_namespace} oci_storage_bucketname=${oci_storage_bucketname} oci_region=${oci_region} oci_root_compartment=${oci_root_compartment} bucket_user_key_cipher=${bucket_user_key_cipher} bucket_user_id=${bucket_user_id} web_port=${web_port} oo_port=${oo_port} project_directory=${project_directory}' >> /var/log/fortknox.log
ansible-playbook fortknox_oci.yml >> /var/log/fortknox.log
EOM

# Start / Enable fortknox-ansible-state
chmod +x '${project_directory}/fortknox-ansible-state.sh'
systemctl daemon-reload
systemctl start fortknox-ansible-state.timer
systemctl start fortknox-ansible-state.service
systemctl enable fortknox-ansible-state.timer
systemctl enable fortknox-ansible-state.service
