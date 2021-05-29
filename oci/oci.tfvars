## COMMON ##
user_name = "joe"
apps = {
    webcontent = {
        "name": "Web Content",
        "description": "The website content",
    },
}

admin_password = "SydA@lak1971"
manager_password = "SydM@lak1971"
ssh_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDlSU8N7yy5GXnNlXg38yZd4dNYItF4rGmGyEJE0H6Z1E7SJt3dmGrTrz+b/EYc5Ambl2rpX+1/mbYAxREd/ZZ0fzlpMARXJNpvivxOOV1yjccOUXc/eKAcVGexybl0GwCqTaBl6/i+HhRDVY1tw7oGUchbbvZRssWNRh/zozIC19x8Ms86X0WpU/FZMcYDaPTeFd4b4xFWecVcfjApnQxVPD3zNTtr0pSDDxVs07ziGMq8JuFwIG+S099KEB1cVwuXNYS7gMLstqfmORaudiVgrFWPv4CqZFg6PKEVKwSKK7xXAqhABLBAvBH7AW7qw9Xaus92e2QJfKDH7ucRuMJz"
mgmt_cidr = "0.0.0.0/0"

oci_config_profile = "/Users/thedon/.oci/config"
oci_root_compartment = "ocid1.tenancy.oc1..aaaaaaaavfhzpaqzmwlnk3idf6a2prm7iyq5ydqfoaedsqgvdoz5324uzutq"

# OCI's managed Oracle Autonomous Linux image, might need to be changed in the future as images are updated periodically
# See https://docs.oracle.com/en-us/iaas/images/autonomous-linux-7x/
# Find Oracle-Autonomous-Linux-7.9, click it then use the OCID of the image in your region
oci_imageid = "ocid1.image.oc1.ap-sydney-1.aaaaaaaaoxuuhaxtr45y5cygxzftlt3xtugbq7rpnz3bhaoyk7qq7tvan75a"

## FREE TIER USERS ##
# Oracle configured your account for two free virtual machines in a specific cloud REGION + AD (Availability Domain), terraform needs to know these.
# See which REGION + AD oracle assigned to your account with the following two commands (without the #):

# OCI_TENANCY_OCID=$(oci iam compartment list --all --compartment-id-in-subtree true --access-level ACCESSIBLE --include-root --raw-output --query "data[?contains(\"id\",'tenancy')].id | [0]")
# oci limits value list --compartment-id $OCI_TENANCY_OCID --service-name compute --query "data [?contains(\"name\",'standard-e2-micro-core-count')]" --all

# Example output - look at each "value" and find the 2 (thats the two free virtual machines)
# The AD number is the last digit in "availability-domain" - 2 in this example (note - some regions only have one AD)
#  {
#    "availability-domain": "oaKW:US-ASHBURN-AD-1",
#    "name": "standard-e2-micro-core-count",
#    "scope-type": "AD",
#    "value": 0
#  },
#  {
#    "availability-domain": "oaKW:US-ASHBURN-AD-2",
#    "name": "standard-e2-micro-core-count",
#    "scope-type": "AD",
#    "value": 2
#  }

oci_region = "ap-sydney-1"
oci_adnumber = 1
oci_instance_shape = "VM.Standard.E2.1.Micro"

## VERY UNCOMMON - Change if git project is cloned or deploying into an existing OCI environment where IP/Port schema might overlap ##
vcn_cidr = "10.10.12.0/24"
fk_prefix = "fortknox"
project_url = "https://github.com/inkton/fortknox"
web_port = "443"

kms_vault_id = "ocid1.vault.oc1.ap-sydney-1.cjqjswloaaffe.abzxsljr3k4n225h7pfhphbkqr44r7ghbjhbesqxm3kw242vqpfi3zwhbqfq"
#kms_key_id = ""
kms_key_id = "ocid1.key.oc1.ap-sydney-1.cjqjswloaaffe.abzxsljrraqoor5dcvvbykb3bsq4yjignhfjkpss2kodqrpsye66ktp6jdwq"

kms_disk_vault_id = "ocid1.vault.oc1.ap-sydney-1.cjqjsqxoaaffe.abzxsljrdlka36r3wcbhjwu3moqizuohv24mggyfsrtgws7huam4j5rc6mvq"
#kms_disk_key_id = ""
kms_disk_key_id = "ocid1.key.oc1.ap-sydney-1.cjqjsqxoaaffe.abzxsljrrlcapy42ktmz3i6wxsswa5iwmi2lrpshzygn32bc45zdzyc5frca"
