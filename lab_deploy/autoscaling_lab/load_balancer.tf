resource "aws_lb" "asg_lb" {
    name               = "${var.name_keyword}-lb"
    internal           = false
    load_balancer_type = "application"
    security_groups    = [aws_security_group.asg_sg.id]
    subnets            = [var.public_subnet_az1_id, var.public_subnet_az2_id]
}

resource "aws_lb_listener" "asg_lb_listener" {
  load_balancer_arn = aws_lb.asg_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.asg_tg.arn
  }
}

resource "aws_lb_target_group" "asg_tg" {
    name     = "${var.name_keyword}-tg"
    port     = 80
    protocol = "HTTP"
    vpc_id   = var.vpc_id
}

resource "aws_autoscaling_attachment" "asg_lab_asg_attach" {
    autoscaling_group_name  = aws_autoscaling_group.asg_lab_asg.id
    lb_target_group_arn     = aws_lb_target_group.asg_tg.arn
}

output "alb_url" {
  value = aws_lb.asg_lb.dns_name
}

# resource "aws_lb_target_group_attachment" "asg_tg_attach" {
#     target_group_arn = aws_lb_target_group.asg_tg.arn
#     target_id        = aws_instance.control_node_instance.id
#     port             = 3000
# }



# resource "aws_lb_listener" "asg_lb_listener" {
#     load_balancer_arn = aws_lb.asg_lb.arn
#     port              = "80"
#     protocol          = "HTTP"

#     default_action {
#         type             = "forward"
#         target_group_arn = aws_lb_target_group.asg_tg.arn
#     }
# }

