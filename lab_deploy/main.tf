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
            "wg:purpose:product" = lower(local.lab_keyword)
            "wg:automation:expiry" = "never"
        }
    }
}

# 
# Comment/Uncomment the modules you want to deploy
# 

module "basic_networking" {
    source                          = "./basic_networking"
    
    name_keyword                    = local.lab_keyword
    region                          = var.region
    vpc_cidr_block                  = var.vpc_cidr_block

    public_subnet_az1_cidr_block    = var.public_subnet_az1_cidr_block
    public_subnet_az2_cidr_block    = var.public_subnet_az2_cidr_block
    
    middleware_subnet_az1_cidr_block = var.middleware_subnet_az1_cidr_block
    middleware_subnet_az2_cidr_block = var.middleware_subnet_az2_cidr_block

    db_subnet_az1_cidr_block         = var.db_subnet_az1_cidr_block
    db_subnet_az2_cidr_block         = var.db_subnet_az2_cidr_block

    cicd_subnet_az1_cidr_block       = var.cicd_subnet_az1_cidr_block
}

# module "ansible_lab" {
#     source                      = "./ansible_lab"
#     name_keyword                = "${local.lab_keyword}-ansible"

#     vpc_id                      = module.basic_networking.vpc_id
#     cicd_subnet_az1_id          = module.basic_networking.cicd_subnet_az1_id
#     middleware_subnet_az1_id    = module.basic_networking.middleware_subnet_az1_id
#     middleware_subnet_az2_id    = module.basic_networking.middleware_subnet_az2_id
#     public_subnet_az1_id        = module.basic_networking.public_subnet_az1_id
#     public_subnet_az2_id        = module.basic_networking.public_subnet_az2_id
# }

module "autoscaling_lab" {
    source                      = "./autoscaling_lab"
    name_keyword                = "${local.lab_keyword}-asg"
    
    vpc_id                      = module.basic_networking.vpc_id
    middleware_subnet_az1_id    = module.basic_networking.middleware_subnet_az1_id
    middleware_subnet_az2_id    = module.basic_networking.middleware_subnet_az2_id
    public_subnet_az1_id        = module.basic_networking.public_subnet_az1_id
    public_subnet_az2_id        = module.basic_networking.public_subnet_az2_id
}
