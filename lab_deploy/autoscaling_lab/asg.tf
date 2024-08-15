resource "aws_launch_template" "asg_lab_lt" {
    name_prefix             = var.name_keyword
    image_id                = data.aws_ami.amazon-linux-2.id
    instance_type           = "t2.micro"
    key_name                = aws_key_pair.asg_key.key_name
    user_data               = filebase64("${path.module}/user_data/userdata.sh")
    vpc_security_group_ids  = [aws_security_group.asg_sg.id]

    iam_instance_profile {
        arn = aws_iam_instance_profile.asg_nodes_instance_profile.arn
    }

    tag_specifications {
        resource_type = "instance"
        tags          = { Name = "ec2-info-web-server" }
    }
}

resource "aws_autoscaling_group" "asg_lab_asg" {
    # availability_zones = ["us-east-1a"]
    name                = "${var.name_keyword}-asg"
    desired_capacity    = 1
    max_size            = 1
    min_size            = 1

    vpc_zone_identifier = [var.middleware_subnet_az1_id, var.middleware_subnet_az2_id]

    launch_template {
        id      = aws_launch_template.asg_lab_lt.id
        version = "$Latest"
    }

    lifecycle { 
        ignore_changes = [desired_capacity]
    }
}
