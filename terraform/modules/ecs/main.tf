resource "aws_security_group" "task_security" {
  name        = "ecs_sg"
  description = "ECS task security group"

  ingress {
    from_port       = var.container_port 
    to_port         = var.container_port 
    protocol        = "tcp"
    security_groups = [var.alb_sg] 
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = var.vpc_id

  tags = {
    Name = "ecs_sg"
  }
}


resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "ecs-task-role"
  }
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "ecs_task_role" {
  name = "ecs-task-role"
    
    assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "ecs-task-role"
  }
}

data "aws_caller_identity" "current" {}

resource "aws_iam_role_policy" "ecs_task_role_policy" {
  role       = aws_iam_role.ecs_task_role.name
  
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = [
        "dynamodb:GetItem",
        "dynamodb:PutItem"
      ],
      Resource = "arn:aws:dynamodb:eu-west-2:${data.aws_caller_identity.current.account_id}:table/${var.table_name}"
    }]
  })
}



resource "aws_ecs_cluster" "main" {
  name = "url-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name = "url-cluster"
  }
}

resource "aws_ecs_service" "url_service" {
  name             = "url142-service"
  cluster          = aws_ecs_cluster.main.id
  task_definition  = aws_ecs_task_definition.ecs_task_definition.arn
  desired_count    = 2
  launch_type      = "FARGATE"
  platform_version = "LATEST"

  deployment_controller {
    type = "CODE_DEPLOY"
  }  
  
  network_configuration {
    subnets          = var.private_subnets
    security_groups  = [aws_security_group.task_security.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.alb_target_arn 
    container_name   = var.service_name
    container_port   = var.container_port
  }

  lifecycle {
    ignore_changes = [
    task_definition,
    load_balancer,
  ]
}

  tags = {
    Name = "url-service"
  }
}

resource "aws_ecs_task_definition" "ecs_task_definition" {
  family                   = "ecs-task-service"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name      = var.service_name
      image     = "${var.ecr_registry}/${var.ecr_repo}:${var.imagetag}"
      essential = true

      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs_cw.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = var.service_name
        }
      }

      environment = [
        {
          name  = "TABLE_NAME"
          value = var.table_name 
        },
        {
          name  = "AWS_REGION"
          value = var.aws_region
        }
      ]
    }
  ])

  tags = {
    Name = "urlecs-task-service"
  }
}


resource "aws_cloudwatch_log_group" "ecs_cw" {
  name = "ECSCloudWatch"
  retention_in_days = 3

  tags = {
    Environment = "production"
    Application = "ECS"
  }
}

resource "aws_dynamodb_table" "url" {
  name         = var.table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "TableHashKey"

attribute {
  name = "TableHashKey"
  type = "S"
  }
}

