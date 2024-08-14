resource "aws_lb_target_group" "semaphore_control_tg" {
    name     = "${var.name_keyword}-semaphore-tg"
    port     = 80
    protocol = "HTTP"
    vpc_id   = var.vpc_id
}

resource "aws_lb_target_group_attachment" "semaphore_control_tg_attach" {
    target_group_arn = aws_lb_target_group.semaphore_control_tg.arn
    target_id        = aws_instance.control_node_instance.id
    port             = 3000
}

resource "aws_lb" "semaphore_control_lb" {
    name               = "${var.name_keyword}-semaphore-lb"
    internal           = false
    load_balancer_type = "application"
    security_groups    = [aws_security_group.control_node_sg.id]
    subnets            = [var.public_subnet_az1_id, var.public_subnet_az2_id]
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

