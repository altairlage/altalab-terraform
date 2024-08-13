terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~>5.0"
        }
    }
}

provider "aws" {
    region = var.region
    default_tags {
        tags = {
            "wg:info:taggingversion" = "2.0.0"
            "wg:purpose:environment" = var.environment
            "wg:purpose:serviceid" = "altalab"
            "wg:purpose:product" = lower(local.product_keyword)
            "wg:automation:expiry" = "never"
        }
    }
}

module "ansible_lab" {
  source                        = "./ansible_lab"
  cicd_subnet_az1_name          = "${local.product_keyword}-cicd-az1"
  middleware_subnet_az1_name    = "${local.product_keyword}-middleware-az1"
  middleware_subnet_az2_name    = "${local.product_keyword}-middleware-az2"
}
