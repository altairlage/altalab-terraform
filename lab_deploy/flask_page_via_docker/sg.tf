resource "aws_security_group" "asg_sg" {
    name        = "${var.name_keyword}-sg"
    description = "Allows SSH and HTTP"
    vpc_id      = var.vpc_id

    ingress {
        description = "HTTP to EC2"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "HTTPS to EC2"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${var.name_keyword}-sg"
    }
}
