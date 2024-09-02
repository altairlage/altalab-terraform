data "aws_ami" "ecs_ami" {
    most_recent = true
    owners      = ["amazon"]

    filter {
        name   = "name"
        values = ["al2023-ami-ecs-hvm-*-x86_64"]
    }
}


# Configuring an EC2 launch template
resource "aws_launch_template" "ec2_lt" {
    name_prefix = "${var.name_keyword}-lt"
    image_id = data.aws_ami.ecs_ami.image_id
    instance_type = "t2.medium"

    key_name               = aws_key_pair.asg_key.key_name
    vpc_security_group_ids = [aws_security_group.ecs_instances_sg.id]
    
    iam_instance_profile {
        # name = "ecsInstanceRole" # tf now says it is invalid
        name = aws_iam_instance_profile.ecs_instance_profile.name
    }

    tag_specifications {
        resource_type = "instance"
        tags = {
            Name = "esc_instance"
        }
    }

    user_data = filebase64("${path.module}/ecs.sh")
}


resource "aws_iam_role" "asg_nodes_role" {
    name               = "${var.name_keyword}-instance-role"
    assume_role_policy = data.aws_iam_policy_document.ec2_instance_role_policy.json
}


resource "aws_iam_role_policy_attachment" "asg_nodes_role_policy_attach" {
    role       = aws_iam_role.asg_nodes_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}


resource "aws_iam_instance_profile" "ecs_instance_profile" {
    name = "${var.name_keyword}-profile"
    role = aws_iam_role.asg_nodes_role.id
}


data "aws_iam_policy_document" "ec2_instance_role_policy" {
    statement {
        actions = ["sts:AssumeRole"]
        effect  = "Allow"

        principals {
            type        = "Service"
            identifiers = [
                "ec2.amazonaws.com",
                "ecs.amazonaws.com"
            ]
        }
    }
}





# resource "aws_iam_role" "asg_nodes_role" {
#     name = "${var.name_keyword}-instance-role"

#     assume_role_policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Action": "sts:AssumeRole",
#       "Principal": {
#         "Service": "ec2.amazonaws.com"
#        },
#        "Effect": "Allow",
#        "Sid": ""
#     }
#   ]
# }
# EOF

#     inline_policy {
#         name = "ec2_policy"
        
#         policy = jsonencode({
#             Version = "2012-10-17"
#             Statement = [
#                 {
#                     Action = [
#                         "logs:CreateLogStream",
#                         "logs:PutLogEvents",
#                         "logs:DescribeLogGroups",
#                         "logs:DescribeLogStreams"
#                     ]
#                     Effect   = "Allow"
#                     Resource = "*"
#                 },
#             ]
#         })
#     }
    
#     tags = {
#         tag-key = "tag-value"
#     }
# }


data "aws_iam_policy" "ssm_policy" {
    arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}


resource "aws_iam_role_policy_attachment" "ssm-role-policy-attach" {
    role       = "${aws_iam_role.asg_nodes_role.name}"
    policy_arn = "${data.aws_iam_policy.ssm_policy.arn}"
}

# data "aws_iam_policy" "ecs_policy" {
#     arn = "arn:aws:iam::aws:policy/aws-service-role/AmazonECSServiceRolePolicy"
# }

# resource "aws_iam_role_policy_attachment" "ecs-role-policy-attach" {
#     role       = "${aws_iam_role.asg_nodes_role.name}"
#     policy_arn = "${data.aws_iam_policy.ecs_policy.arn}"
# }