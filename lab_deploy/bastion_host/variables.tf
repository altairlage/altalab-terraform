variable "region" {
    description = "define the AWS region to be used"
    type        = string
    validation {
        condition     = can(regex("^([a-z0-9-'])+$", var.region))
        error_message = "Please use a valid AWS region (eg. us-west-1)."
    }
}

locals {
    product_keyword = "ansible-lab"
}
