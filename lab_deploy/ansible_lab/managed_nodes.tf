resource "aws_instance" "az1_instances" {
    count = 2

    ami             = data.aws_ami.ubuntu_ami.id
    instance_type   = "t2.micro"
    key_name        = aws_key_pair.ansible_key.key_name
    
    vpc_security_group_ids  = [aws_security_group.managed_nodes_sg.id]
    subnet_id               = data.aws_subnet.middleware_subnet_az1.id
    iam_instance_profile = "${aws_iam_instance_profile.ansible_nodes_instance_profile.name}"

    tags = {
        Name = "${var.resource_keyword}-az1-managed-node-${count.index}"
    }
}

resource "aws_instance" "az2_instances" {
    count = 2

    ami             = data.aws_ami.ubuntu_ami.id
    instance_type   = "t2.micro"
    key_name        = aws_key_pair.ansible_key.key_name
    
    vpc_security_group_ids  = [aws_security_group.managed_nodes_sg.id]
    subnet_id               = data.aws_subnet.middleware_subnet_az2.id
    iam_instance_profile = "${aws_iam_instance_profile.ansible_nodes_instance_profile.name}"
    
    tags = {
        Name = "${var.resource_keyword}-az2-managed-node-${count.index}"
    }
}