resource "aws_instance" "control_node_instance" {
    ami             = data.aws_ami.ubuntu_ami.id
    instance_type   = "t2.micro"
    key_name        = data.aws_key_pair.lab_key_pair.key_name
    associate_public_ip_address = true
    
    vpc_security_group_ids  = [aws_security_group.control_node_sg.id]
    subnet_id               = data.aws_subnet.public_subnet.id
    
    tags = {
        Name = "ansible-lab-control-node"
    }
}
