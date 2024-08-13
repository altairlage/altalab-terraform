resource "aws_key_pair" "ansible_key" {
    key_name   = "${var.resource_keyword}-key"
    # public_key = file("${path.module}/ansible-lab.pub")
    public_key = file("./ssh_key/ansible-lab.pub")
}