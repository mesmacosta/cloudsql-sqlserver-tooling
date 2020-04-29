#!/usr/bin/env bash
root_dir=$(pwd)
cd infrastructure/terraform

instance_id=$(cat terraform.tfstate | jq '.outputs.instance_id.value')
project_id=$(cat terraform.tfstate | jq '.outputs.project_id.value')

# Remove quotes
instance_id=${instance_id//\"/}
project_id=${project_id//\"/}

# 1 option - Delete using gcloud
gcloud sql instances delete $instance_id --quiet

# 2 option - Delete using terraform
# terraform destroy

# Clean up TF state files if they exist.
rm terraform.tfstate > /dev/null 2>&1
rm terraform.tfstate.backup > /dev/null 2>&1
rm tfplan > /dev/null 2>&1
rm .tfvars > /dev/null 2>&1

echo -e "\033[1;42m Cloud SQL Instance deleted \033[0m"

cd $root_dir
echo -e "\033[1;42m COMPLETED \033[0m"