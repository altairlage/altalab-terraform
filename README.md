# altalab

Lab developed to test and perform knowledge share for my team. It shows several Terraform deployments in AWS. The intent is to exercise the most common deployments using Terraform.

This project contains several modules. Each module represents a lab, which deploys resources specific infrastructure or services setup.

## basic_networking

This module deploys a basic AWS infrastructure, a VPC with some subnets, the CICD subnet to run some CICD services, a 3 tier subnet schema (public, middleware, and DB subnets), and the basic requirements to allow connectivity. 


## ansible_lab

Deploys a complete Ansible lab, including:
- 5 EC2 instances:
    - The Ansible control node in CICD subnet.
        - Setups Ansible and runs Semaphore service (with MySQL) via docker-compose.
    - 4 managed nodes in middleware subnet.
        - 2 in each AZ.
- A load balancer to expose the Semaphore service for remote configuration;


## autoscaling_lab

This module is a lab to test an autoscaling group with load balancing. It deploys:
- The Auto scaling group.
- The launch template with full configuration of the EC2 servers.
    - Contains also the automatic setup of a Flask (Python) application that presents the EC2 instance info.
- The load balancer attached to the ASG to register the EC2 instances in the Target Group.


## flask_page_via_docker

This module deploys the same setup as the autoscaling_lab, but runs the Flask app via Docker.


# Enable and disable modules

Comment/Uncomment the modules invocation in the main.tf file to enable or disable the desired modules.


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

