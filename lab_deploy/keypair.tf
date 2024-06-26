resource "aws_key_pair" "ansible_key" {
    key_name   = "${local.product_keyword}"
    # public_key = file("${path.module}/ansible-lab.pub")
    public_key = file("./ssh_key/ansible-lab.pub")
}