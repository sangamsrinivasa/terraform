provider "aws" {
  region = "us-east-1"
}

resource "aws_ecs_cluster" "ecs_dev" {
  name = "ecs-dev-cluster"
}

# iam_role
resource "aws_iam_role" "dev_ecs_task_execution_role" {
  name = "dev_ecs_task_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.dev_ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


resource "aws_ecs_task_definition" "dev_ecs_task_def" {
  family                   = "dev-task-family"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  execution_role_arn = aws_iam_role.dev_ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = var.cont_name
      image     = var.image
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])
}


# security_group.tf
resource "aws_security_group" "ecs_service" {
  name        = "dev_ecs_service_sg"
  description = "Allow traffic to ECS service"
  vpc_id      = aws_vpc.nam_dev.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ecs_service.tf
resource "aws_ecs_service" "example" {
  name            = "dev-ecs-service"
  cluster         = aws_ecs_cluster.ecs_dev.id
  task_definition = aws_ecs_task_definition.dev_ecs_task_def.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = aws_subnet.dev_subnet.id
    security_groups  = [aws_security_group.ecs_service.id]
    assign_public_ip = true
  }
}

