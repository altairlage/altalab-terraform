resource "aws_iam_role" "ansible_nodes_role" {
    name = "${var.name_keyword}-nodes-role"

    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
       },
       "Effect": "Allow",
       "Sid": ""
    }
  ]
}
EOF

    inline_policy {
        name = "ec2_policy"
        
        policy = jsonencode({
            Version = "2012-10-17"
            Statement = [
                {
                    Action = [
                        "logs:CreateLogStream",
                        "logs:PutLogEvents",
                        "logs:DescribeLogGroups",
                        "logs:DescribeLogStreams"
                    ]
                    Effect   = "Allow"
                    Resource = "*"
                },
            ]
        })
    }
    
    tags = {
        tag-key = "tag-value"
    }
}


resource "aws_iam_role_policy_attachment" "ssm-role-policy-attach" {
    role       = "${aws_iam_role.ansible_nodes_role.name}"
    policy_arn = "${data.aws_iam_policy.ssm_policy.arn}"
}

resource "aws_iam_instance_profile" "ansible_nodes_instance_profile" {
  name = "ansible_nodes_instance_profile"
  role = "${aws_iam_role.ansible_nodes_role.name}"
}
