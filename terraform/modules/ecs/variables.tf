variable "service_name" {
  type    = string
  default = "url_sv"
}

variable "table_name" {
  type = string
  default = "urltable"  
}

variable "aws_region" {
  type    = string
  default = "eu-west-1"
}

#Get from VPC 
variable "vpc_id" {
  description = "The id of the VPC"
  type        = string
}
#Get from ALB
variable "alb_sg" {
  description = "The security group ID of the ALB to allow ingress to ECS tasks"
  type        = string
}

variable "task_cpu" {
  type    = number
  default = 256
}

variable "task_memory" {
  type    = number
  default = 512
}

#Get from ALB | blue target group 
variable "alb_target_arn" {
  description = "The ARN of the ALB target group for ECS service"
  type        = string
}

variable "ecr_registry" {
  description = "ECR registry URI"
  type        = string
  default     = "913513914993.dkr.ecr.eu-west-1.amazonaws.com"
}

variable "ecr_repo" {
  description = "ECR repository name"
  type        = string
  default     = "url-project"
}

variable "imagetag" {
  description = "Docker image tag"
  type        = string
  default     = "latest"
}
variable "container_port" {
  type    = number
  default = 8080
}

#Get from VPC
variable "private_subnets" {
  description = "List of private subnet IDs where ECS tasks will be launched"
  type        = list(string)
}
