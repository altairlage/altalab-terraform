resource "aws_lb_target_group" "semaphore_control_tg" {
    name     = "${var.resource_keyword}-semaphore-control-tg"
    port     = 80
    protocol = "HTTP"
    vpc_id   = aws_vpc.vpc.id
}

resource "aws_lb_target_group_attachment" "semaphore_control_tg_attach" {
    target_group_arn = aws_lb_target_group.semaphore_control_tg.arn
    target_id        = aws_instance.control_node_instance.id
    port             = 3000
}

resource "aws_lb" "semaphore_control_lb" {
    name               = "${var.resource_keyword}-semaphore-control-lb"
    internal           = false
    load_balancer_type = "application"
    security_groups    = [aws_security_group.control_node_sg.id]
    subnets            = [aws_subnet.public_subnet_az1.id, aws_subnet.public_subnet_az2.id]
}

resource "aws_lb_listener" "semaphore_control_lb_listener" {
    load_balancer_arn = aws_lb.semaphore_control_lb.arn
    port              = "80"
    protocol          = "HTTP"

    default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.semaphore_control_tg.arn
    }
}

