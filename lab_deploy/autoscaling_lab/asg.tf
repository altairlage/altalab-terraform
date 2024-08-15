resource "aws_launch_template" "asg_lab_lt" {
    name_prefix             = var.name_keyword
    image_id                = data.aws_ami.amazon-linux-2.id
    instance_type           = "t2.micro"
    key_name                = aws_key_pair.asg_key.key_name
    user_data               = filebase64("${path.module}/user_data/userdata.sh")
    vpc_security_group_ids  = [aws_security_group.asg_sg.id]

    iam_instance_profile {
        name = aws_iam_role.asg_nodes_role.name
    }
}

resource "aws_autoscaling_group" "asg_lab_asg" {
    # availability_zones = ["us-east-1a"]
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



resource "aws_instance" "az1_instances" {
    count = 2

    ami             = data.aws_ami.amazon-linux-2.id
    instance_type   = "t2.micro"
    key_name        = aws_key_pair.asg_key.key_name
    
    vpc_security_group_ids  = [aws_security_group.managed_nodes_sg.id]
    subnet_id               = var.middleware_subnet_az1_id
    iam_instance_profile    = "${aws_iam_instance_profile.asg_nodes_instance_profile.name}"

    tags = {
        Name = "${var.name_keyword}-az1-${count.index}"
    }
}

resource "aws_instance" "az2_instances" {
    count = 2

    ami             = data.aws_ami.amazon-linux-2.id
    instance_type   = "t2.micro"
    key_name        = aws_key_pair.asg_key.key_name
    
    vpc_security_group_ids  = [aws_security_group.managed_nodes_sg.id]
    subnet_id               = var.middleware_subnet_az2_id
    iam_instance_profile    = "${aws_iam_instance_profile.asg_nodes_instance_profile.name}"
    
    tags = {
        Name = "${var.name_keyword}-az2-${count.index}"
    }
}