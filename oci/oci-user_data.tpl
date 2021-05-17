#!/bin/bash
# Create systemd service unit file
tee /etc/systemd/system/fortknox-ansible-state.service << EOM
[Unit]
Description=fortknox-ansible-state
After=network.target

[Service]
ExecStart=/opt/fortknox-ansible-state.sh
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
tee /opt/fortknox-ansible-state.sh << EOM
#!/bin/bash
# Update package list
apt-get update
# Install pip3 and git
DEBIAN_FRONTEND=noninteractive apt-get -y install python3-pip git
# Pip update pip
pip3 install --upgrade pip
# Install ansible and oci libraries
pip3 install --upgrade ansible oci
# And the collection
ansible-galaxy collection install oracle.oci
# Make the project directory
mkdir -p /opt/git/fortknox
# Clone the project into project directory
#git clone ${project_url} /opt/git/fortknox
# Change to directory
#cd /opt/git/fortknox
# Ensure up-to-date
#git pull
# Change to playbooks directory
cd playbooks/
# Execute playbook
ansible-playbook fortknox_oci.yml --extra-vars 'docker_network=${docker_network} docker_gw=${docker_gw} docker_nextcloud=${docker_nextcloud} docker_db=${docker_db} docker_webproxy=${docker_webproxy} docker_onlyoffice=${docker_onlyoffice} admin_password_cipher=${admin_password_cipher} db_password_cipher=${db_password_cipher} oo_password_cipher=${oo_password_cipher} oci_kms_endpoint=${oci_kms_endpoint} oci_kms_keyid=${oci_kms_keyid} oci_storage_namespace=${oci_storage_namespace} oci_storage_bucketname=${oci_storage_bucketname} oci_region=${oci_region} oci_root_compartment=${oci_root_compartment} bucket_user_key_cipher=${bucket_user_key_cipher} bucket_user_id=${bucket_user_id} web_port=${web_port} oo_port=${oo_port} project_directory=${project_directory}' >> /var/log/fortknox.log
EOM

# Start / Enable fortknox-ansible-state
chmod +x /opt/fortknox-ansible-state.sh
systemctl daemon-reload
systemctl start fortknox-ansible-state.timer
systemctl start fortknox-ansible-state.service
systemctl enable fortknox-ansible-state.timer
systemctl enable fortknox-ansible-state.service
