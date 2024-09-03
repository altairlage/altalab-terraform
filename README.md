# altalab
Lab developed to test and perform knowledge share for my team. It shows several Terraform deployments in AWS. The intent is to exercise the most common deployments using Terraform.

This project contains several modules. Each module represents a lab, which deploys resources specific infrastructure or services setup. 
\
&nbsp;
\
&nbsp;


## basic_networking
This module deploys a basic AWS infrastructure, a VPC with some subnets, the CICD subnet to run some CICD services, a 3 tier subnet schema (public, middleware, and DB subnets), and the basic requirements to allow connectivity. 

### Architecture
https://lucid.app/lucidchart/740b7a07-ecc3-4aa5-9e78-50ac4efa7627/view


\
&nbsp;
\
&nbsp;


## ansible_lab
Deploys a complete Ansible lab, including:
- 5 EC2 instances:
    - The Ansible control node in CICD subnet.
        - Setups Ansible and runs Semaphore service (with MySQL) via docker-compose.
    - 4 managed nodes in middleware subnet.
        - 2 in each AZ.
- A load balancer to expose the Semaphore service for remote configuration;
\
&nbsp;
\
&nbsp;


## autoscaling_lab
This module is a lab to test an autoscaling group with load balancing. It deploys:
- The Auto scaling group.
- The launch template with full configuration of the EC2 servers.
    - Contains also the automatic setup of a Flask (Python) application that presents the EC2 instance info.
- The load balancer attached to the ASG to register the EC2 instances in the Target Group.
\
&nbsp;
\
&nbsp;


## flask_page_via_docker
This module deploys the same setup as the autoscaling_lab, but runs the Flask app via Docker.
\
&nbsp;
\
&nbsp;


# Enable and disable modules
Comment/Uncomment the modules invocation in the main.tf file to enable or disable the desired modules.
\
&nbsp;
\
&nbsp;


## ecs_alb_lab
This module deploys an ECS cluster, ECS service, and it requirements (ALB, Task definition, Capacity Provider, etc.).
References:
- https://spacelift.io/blog/terraform-ecs
- https://medium.com/@ramonriserio/como-implantar-uma-aplica%C3%A7%C3%A3o-usando-aws-ecs-e-terraform-tutorial-b40417fb106a
- https://github.com/ramonriserio/Amazon-ECS/blob/version-3/task-definition.tf

The architecture of this lab is:
![ECS VPC1](/doc_resources/ecs_vpc1.png "ECS VPC1")

ECS Service configuration:
![ECS Sevice](/doc_resources/ecs1.webp "ECS Service")

\
&nbsp;
Some resulting resources:
![ECS Load balancer](/doc_resources/ecs_lb_alb.png "ECS Load balancer")

![ECS Cluster infra](/doc_resources/ecs_lb_infra.png "ECS Cluster infra")

![ECS Cluster service](/doc_resources/ecs_lb_servie.png "ECS Cluster service")

![ECS tasks](/doc_resources/ecs_lb_tasks.png "ECS tasks")

![ECS Load balancer target group](/doc_resources/ecs_lb_tg.png "ECS Load balancer target group")

\
&nbsp;
### Tests

To test this lab, deploy it with multiple EC2 instances and ECS tasks. To make sure the tasks are responding, make a HTTP request to the load balancer URL. Each request should return a different IP.
![Test tasks](/doc_resources/ecs_lb_request1.png "Test tasks")
![Test tasks](/doc_resources/ecs_lb_request2.png "Test tasks")

\
&nbsp;
\
&nbsp;


# Deploy commands
The deployment was developed in Terraform.
To run the deployment, you need to:

- Install terraform
    - In the host you're running the deployment
- Have a session created with AWS and have its credentials stored in your ~/.aws/credentials file. 

### Init
terraform init -backend-config=./env/us-west-2.tfbackend

### Plan
terraform plan -var-file=./env/us-west-2.tfvars

### Apply
terraform apply -var-file=./env/us-west-2.tfvars --auto-approve

### Destroy
terraform destroy -var-file=./env/us-west-2.tfvars --auto-approve
\
&nbsp;
\
&nbsp;


# TO-DO

1. Create private hosted zone to access the services in CICD subnet via ELB.
    1. Requires configuration in VPC
    1. Create the A record for each service
    1. Maybe CNAME records too?
1. Create SSM role to allow ssh connection in all the servers - done
\
&nbsp;
\
&nbsp;

# Lab ideas
1. ~~Create an ECS cluster deployment~~
1. ~~Create an ECS Service deployment with sample application.~~
1. Another ECS lab - https://nexgeneerz.io/aws-computing-with-ecs-ec2-terraform/
1. Deploy ECS cluster backed by Fargate with sample applicaiton.
    1. https://www.chakray.com/creating-fargate-ecs-task-aws-using-terraform/
    1. https://www.architect.io/blog/2021-03-30/create-and-manage-an-aws-ecs-cluster-with-terraform/
    1. https://nexgeneerz.io/how-to-setup-amazon-ecs-fargate-terraform/
1. Create an API Gateway -> Lambda -> DDB deployment.
    1. https://developer.hashicorp.com/terraform/tutorials/aws/lambda-api-gateway
1. Create an host a Flask app
    1. https://flask.palletsprojects.com/en/3.0.x/quickstart/
1. Create a Terraform deployment for the wordpress challenge.
1. Deploy an EKS cluster
1. Deploy a service in EKS with sample application.
1. Deploy some OSS Jenkins controllers via EKS cluster.
1. Deploy a Consul cluster and register ECS services.
    1. https://developer.hashicorp.com/consul/docs/intro
1. Importing Existing Infrastructure Into Terraform
    1. https://spacelift.io/blog/importing-exisiting-infrastructure-into-terraform
    1. https://medium.com/@DiggerHQ/you-can-now-import-your-existing-infrastructure-into-terraform-now-what-7d7bfe4d9334
    1. https://developer.hashicorp.com/terraform/cli/commands/import
