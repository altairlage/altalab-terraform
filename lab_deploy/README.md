# Ansible lab

Deploys a complete Ansible lab, including:
 - Networking (VPC, public, private, and cicd subnets, IGW, Route tables, etc.).
 - The Ansible control node.
 - The managed nodes.

# Deploy commands

## Init
terraform init -backend-config=./env/us-west-2.tfbackend

## Plan
terraform plan -var-file=./env/us-west-2.tfvars

## Apply
terraform apply -var-file=./env/us-west-2.tfvars

## Destroy
terraform destroy -var-file=./env/us-west-2.tfvars