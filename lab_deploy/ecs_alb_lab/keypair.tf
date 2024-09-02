resource "aws_key_pair" "asg_key" {
    key_name   = "${var.name_keyword}-key"
    public_key = file("${path.module}/ssh_key/ecs-lab.pub")
}
