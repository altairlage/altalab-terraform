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


data "aws_iam_policy" "ssm_policy" {
    arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

data "aws_subnet" "cicd_subnet_az1" {
  filter {
    name   = "tag:Name"
    values = [var.cicd_subnet_az1_name]
  }
}

data "aws_subnet" "middleware_subnet_az1" {
  filter {
    name   = "tag:Name"
    values = [var.middleware_subnet_az1_name]
  }
}

data "aws_subnet" "middleware_subnet_az2" {
  filter {
    name   = "tag:Name"
    values = [var.middleware_subnet_az2_name]
  }
}