# Configure the Application Load Balancer (ALB)
# (its listener, and the TARGET GROUP)
resource "aws_lb" "ecs_alb" {
    name               = "${var.name_keyword}-alb"
    internal           = false
    load_balancer_type = "application"
    security_groups    = [aws_security_group.ecs_instances_sg.id]
    subnets            = [var.public_subnet_az1_id, var.public_subnet_az2_id]

    tags = {
        Name = "${var.name_keyword}-alb"
    }
}


resource "aws_lb_target_group" "ecs_tg" {
    name        = "${var.name_keyword}-tg"
    port        = 80
    protocol    = "HTTP"
    target_type = "ip"
    vpc_id      = var.vpc_id

    health_check {
        enabled             = true
        path                = "/"
        port                = 80
        matcher             = 200
        interval            = 10
        timeout             = 5
        healthy_threshold   = 2
        unhealthy_threshold = 3
    }
}

resource "aws_lb_listener" "ecs_alb_listener" {
    load_balancer_arn = aws_lb.ecs_alb.arn
    port              = 80
    protocol          = "HTTP"

    default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.ecs_tg.arn
    }
}

output "alb_url" {
  value = aws_lb.ecs_alb.dns_name
}