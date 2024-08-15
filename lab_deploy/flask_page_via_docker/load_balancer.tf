https://aws.amazon.com/tutorials/serve-a-flask-app/
https://medium.com/preprintblog/how-to-deploy-python-flask-project-to-aws-ec2-2c38501d9c85

gcloud https://realpython.com/python-web-applications/

Flask https://flask.palletsprojects.com/en/3.0.x/quickstart/

https://www.geeksforgeeks.org/how-to-run-a-flask-application/
https://flask.palletsprojects.com/en/2.3.x/tutorial/deploy/

https://stackoverflow.com/questions/51025893/flask-at-first-run-do-not-use-the-development-server-in-a-production-environmen

https://stackoverflow.com/questions/36465899/how-to-run-flask-server-in-the-background

https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/7/html/system_administrators_guide/chap-managing_services_with_systemd#sect-Managing_Services_with_systemd-Introduction-Features


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

