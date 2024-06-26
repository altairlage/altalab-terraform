data "aws_ami" "ubuntu_ami" {
    most_recent = true

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }

    # owners = ["099720109477"] # Canonical
    owners = ["amazon"]
}

data "aws_subnet" "public_subnet" {
  filter {
    name   = "tag:Name"
    values = ["${local.product_keyword}-public-az2"]
  }
}

data "aws_key_pair" "lab_key_pair" {
  key_name           = "${local.product_keyword}"
  include_public_key = true
}
