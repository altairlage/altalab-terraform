variable "name_keyword" {
    description = "defines the identifier/name keyword for resource naming"
    type        = string

}

variable "region" {
    description = "define the AWS region to be used"
    type        = string
    
    validation {
        condition     = can(regex("^([a-z0-9-'])+$", var.region))
        error_message = "Please use a valid AWS region (eg. us-west-1)."
    }
}

variable "vpc_cidr_block" {
    description = "define the cidr block for vpc"
    type        = string
    validation {
        condition     = can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}(\\/([0-9]|[1-2][0-9]|3[0-2]))?$", var.vpc_cidr_block))
        error_message = "Must be in valid vpc cidr block format ranging from '16 -28'."
    }
}


variable "public_subnet_az1_cidr_block" {
    type    = string
}

variable "public_subnet_az2_cidr_block" {
    type    = string
}

variable "middleware_subnet_az1_cidr_block" {
    type    = string
}

variable "middleware_subnet_az2_cidr_block" {
    type    = string
}

variable "db_subnet_az1_cidr_block" {
    type    = string
}

variable "db_subnet_az2_cidr_block" {
    type    = string
}

variable "cicd_subnet_az1_cidr_block" {
    type    = string
}
