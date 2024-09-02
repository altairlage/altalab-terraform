variable "vpc_id" {
    type    = string
}

variable "public_subnet_az1_id" {
    type    = string
}

variable "public_subnet_az2_id" {
    type    = string
}

variable "middleware_subnet_az1_id" {
    type    = string
}

variable "middleware_subnet_az2_id" {
    type    = string
}

variable "ecs_instances_ami" {
    description = "Defines the ECS optimized AMI ID to be used on the ECS cluster EC2 instances"
    type    = string
    default = "ami-01b6044ed56f5838f"
}

variable "name_keyword" {
    description = "Defines the identifier/name keyword for resource naming"
    type        = string
    default     = "altalab-ecs"
}