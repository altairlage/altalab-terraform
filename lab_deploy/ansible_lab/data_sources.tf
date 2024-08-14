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
