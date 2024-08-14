resource "aws_key_pair" "ansible_key" {
    key_name   = "${var.name_keyword}-key"
    public_key = file("${path.module}/ssh_key/ansible-lab.pub")
    # public_key = file("./ssh_key/ansible-lab.pub")
}