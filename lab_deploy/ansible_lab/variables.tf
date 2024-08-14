variable "vpc_id" {
    type    = string
}

variable "cicd_subnet_az1_id" {
    type    = string
}

variable "middleware_subnet_az1_id" {
    type    = string
}

variable "middleware_subnet_az2_id" {
    type    = string
}

variable "public_subnet_az1_id" {
    type    = string
}

variable "public_subnet_az2_id" {
    type    = string
}

variable "name_keyword" {
    description = "defines the identifier/name keyword for resource naming"
    type        = string
    default     = "altalab-ansible"
}