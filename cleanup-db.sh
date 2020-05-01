#!/usr/bin/env bash
root_dir=$(pwd)
cd infrastructure/terraform

public_ip_address=$(cat terraform.tfstate | jq '.outputs.public_ip_address.value')
username=$(cat terraform.tfstate | jq '.outputs.username.value')
password=$(cat terraform.tfstate | jq '.outputs.password.value')
database=$(cat terraform.tfstate | jq '.outputs.db_name.value')

# Remove quotes
public_ip_address=${public_ip_address//\"/}
username=${username//\"/}
password=${password//\"/}
database=${database//\"/}

docker run --rm --tty -v \
"$PWD":/data mesmacosta/sqlserver-db-cleaner:stable \
--sqlserver-host $public_ip_address \
--sqlserver-user $username \
--sqlserver-pass $password \
--sqlserver-database $database

cd $root_dir