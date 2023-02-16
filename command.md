# connect test tenant
````
connect-AzAccount -tenantId 8e898b91-9590-4c30-9d66-c7aefa229c04 -Subscription 2bd351ba-6fe3-48ea-84a4-acaa8d98c306
az login --tenant 8e898b91-9590-4c30-9d66-c7aefa229c04
````

# initialisation
````
git init my-foundation-kit 
cd .\my-foundation-kit\     
collie foundation new my-foundation-dev
````

# first module
````
collie kit new "lz-az-module"
collie kit apply "lz-az-module" --foundation my-foundation-dev --platform msdnpoc
````


collie kit tree 
collie foundation docs my-foundation-dev
collie compliance tree

 collie kit new bootstrap


https://www.meshcloud.io/de/blog/mastering-landing-zones-in-azure/




curl -sSLo ./terraform-docs.tar.gz https://terraform-docs.io/dl/v0.16.0/terraform-docs-v0.16.0-$(uname)-amd64.tar.gz
tar -xzf terraform-docs.tar.gz


curl -sf -L https://raw.githubusercontent.com/meshcloud/collie-cli/main/install.sh | sudo bash

sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update
sudo apt install terraform
terraform

