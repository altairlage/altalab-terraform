data "aws_caller_identity" "current" {}

# Create ECS Task Definition/Template
resource "aws_ecs_task_definition" "ecs_task_definition" {
    family             = "${var.name_keyword}-ecs"
    network_mode       = "awsvpc"
    execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
    cpu                = 1024 # equivale a 1 vCPU - QUANTIDADE DE CPU A SER ALOCADA PARA A ECS 
    
    runtime_platform {
        operating_system_family = "LINUX"
        cpu_architecture        = "X86_64"
    }
    
    container_definitions = jsonencode([{
        name      = "${var.name_keyword}-container"
        image     = "strm/helloworld-http" # image URL of the application image
        # image     = "amazon/amazon-ecs-sample"
        cpu       = 1024                    # equivale a 1 vCPU - QUANTIDADE DE CPU A SER ALOCADA PARA A ECS 
        memory    = 256                     # 256 MiB = 0.25 GiB
        essencial = true                    # a execução do container é essencial para a tarefa
        portMappings = [{
            containerPort = 80
            hostPort      = 80
            protocol      = "tcp"
        }]
    }])
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "${var.name_keyword}-TaskExecutionRole"
  assume_role_policy = data.aws_iam_policy_document.task_assume_role_policy.json

}

data "aws_iam_policy_document" "task_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}