resource "aws_instance" "control_node_instance" {
    ami             = data.aws_ami.ubuntu_ami.id
    instance_type   = "t2.micro"
    key_name        = aws_key_pair.ansible_key.key_name
    associate_public_ip_address = true
    
    vpc_security_group_ids  = [aws_security_group.control_node_sg.id]
    subnet_id               = aws_subnet.cicd_subnet_az1.id
    
    tags = {
        Name = "ansible-lab-control-node"
    }

    user_data = file("./scripts/setup_control_node.sh")
}
