# Create an Auto Scaling Group (ASG)
# (and associate it with the lauch template created previously)
resource "aws_autoscaling_group" "ecs_asg" {
    name = "${var.name_keyword}-asg"
    vpc_zone_identifier = [
        var.middleware_subnet_az1_id,
        var.middleware_subnet_az2_id
    ]
    desired_capacity = 2
    max_size         = 2
    min_size         = 2

    launch_template {
        id      = aws_launch_template.ec2_lt.id
        version = "$Latest"
    }
    
    tag {
        key = "AmazonECSManaged"
        value = true
        propagate_at_launch = true
    }
}