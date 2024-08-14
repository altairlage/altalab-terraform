# ansible-semaphore lab

Lab developed to test and perform knowledge share for my team.

This project deploys a basic AWS infrastructure, a VPC with some subnets and the basic requirements to allow connectivity for the instances, and 5 EC2 instances:

Deploys a complete Ansible lab, including:
- Networking (VPC, public, private, and cicd subnets, IGW, Route tables, etc.).
    - The basic requirements to allow connectivity for the instances
- 5 EC2 instances:
    - The Ansible control node in public subnet (just to allow remote management).
    - 4 managed nodes.
        - 2 in each AZ.


# Deploy commands

The deployment was developed in Terraform.
To run the deployment, you need to:

- Install terraform
    - In the host you're running the deployment
- Have a session created with AWS and have its credentials stored in your ~/.aws/credentials file. 

## Init
terraform init -backend-config=./env/us-west-2.tfbackend

## Plan
terraform plan -var-file=./env/us-west-2.tfvars

## Apply
terraform apply -var-file=./env/us-west-2.tfvars --auto-approve

## Destroy
terraform destroy -var-file=./env/us-west-2.tfvars --auto-approve


# TO-DO

1. Change the CICD subnet to private - done
1. Create ALBs to allow traffic to the services in CICD subnet - done
    1. Create access logs on ALBs
1. Create private hosted zone to access the services in CICD subnet via ELB.
    1. Requires configuration in VPC
    1. Create the A record for each service
    1. Maybe CNAME records too?
1. Create SSM role to allow ssh connection in all the servers - done

# Lab ideas

1. Create a ASG lab.
  1. Create an ec2 with a web server for instance.
  1. Create an AMI from the instance.
  1. Create the Lauch template.
  1. Create the ASG.
    1. Create ASG Dynamic scaling policies.
    1. Create scheduled scaling actions.
1. Create a Terraform deployment for the wordpress challenge.

