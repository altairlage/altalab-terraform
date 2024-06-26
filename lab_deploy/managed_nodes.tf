resource "aws_instance" "az1_instances" {
    count = 2

    ami             = data.aws_ami.ubuntu_ami.id
    instance_type   = "t2.micro"
    key_name        = aws_key_pair.ansible_key.key_name
    
    vpc_security_group_ids  = [aws_security_group.managed_nodes_sg.id]
    subnet_id               = aws_subnet.middleware_subnet_az1.id
    tags = {
        Name = "az1-ansible-lab${count.index}"
    }
}

resource "aws_instance" "az2_instances" {
    count = 2

    ami             = data.aws_ami.ubuntu_ami.id
    instance_type   = "t2.micro"
    key_name        = aws_key_pair.ansible_key.key_name
    
    vpc_security_group_ids  = [aws_security_group.managed_nodes_sg.id]
    subnet_id               = aws_subnet.middleware_subnet_az2.id
    tags = {
        Name = "az2-ansible-lab${count.index}"
    }
}