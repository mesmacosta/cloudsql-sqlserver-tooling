#!/usr/bin/env bash
root_dir=$(pwd)
cd infrastructure/terraform

project=$(gcloud config get-value project)

test_machine_ip=$(curl https://diagnostic.opendns.com/myip)

if [ -z "$project" ]; then
    echo "GCloud project must be set! Run: gcloud config set project [MY_PROJECT]"
    exit 2
fi

# Create TF environment file
cat > .tfvars << EOF
project_id="$project"
test_machine_ip="$test_machine_ip"
EOF

echo -e "\033[1;42m [STEP 1] Enable required APIs \033[0m"

gcloud services enable datacatalog.googleapis.com sqladmin.googleapis.com --project $project

echo -e "\033[1;42m [STEP 2] Create Cloud SQL - SQLServer environment \033[0m"
# download utility tootls directly into ~/
curl http://stedolan.github.io/jq/download/linux64/jq -o ~/jq
# give it executable permissions
chmod a+x ~/jq

# Initialise the configuration
terraform init -input=false

# Plan and deploy
terraform plan -input=false -out=tfplan -var-file=".tfvars" > /dev/null 2>&1
terraform apply tfplan

public_ip_address=$(cat terraform.tfstate | jq '.outputs.public_ip_address.value')
username=$(cat terraform.tfstate | jq '.outputs.username.value')
password=$(cat terraform.tfstate | jq '.outputs.password.value')
database=$(cat terraform.tfstate | jq '.outputs.db_name.value')

# Remove quotes
public_ip_address=${public_ip_address//\"/}
username=${username//\"/}
password=${password//\"/}
database=${database//\"/}

export public_ip_address=$public_ip_address
export username=$username
export password=$password
export database=$database

if [ -z "$public_ip_address" ]; then
    echo "Cloud SQL instance creation failed"
    exit 3
fi

echo $public_ip_address $username $password

echo -e "\033[1;42m [STEP 3] POPULATE DATABASE \033[0m"

# Generate Metadata
docker run --rm --tty \
mesmacosta/sqlserver-metadata-generator:stable  \
--sqlserver-host=$public_ip_address \
--sqlserver-user=$username \
--sqlserver-pass=$password \
--sqlserver-database=$database \
--number-schemas=5 \
--number-tables=5

cd $root_dir
echo -e "\033[1;42m COMPLETED \033[0m"
