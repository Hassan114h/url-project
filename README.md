<div align="center">
  <h1 style="font-size: 3.5em;">URL Shortener on ECS Fargate</h1>

  <p>
    <a href="#"><img src="https://img.shields.io/badge/Cloud-AWS-FF9900?logo=amazon-aws" alt="AWS | ECS Fargate"></a>
    <a href="#"><img src="https://img.shields.io/badge/IaC-Terraform-623CE4?logo=terraform" alt="Terraform"></a>
    <a href="#"><img src="https://img.shields.io/badge/Container-Docker-2496ED?logo=docker" alt="Docker"></a>
    <a href="#"><img src="https://img.shields.io/badge/CI/CD-GitHub_Actions-2088FF?logo=github-actions" alt="CI/CD"></a>
  </p>
</div>

## Navigation
[Key Features](#key-features) • [Architecture Diagram](#architecture-diagram) • [How To Use It](#how-to-use-it) • [App Walkthrough](#app-walkthrough)

---

This project provides a fully functional, production-ready deployment of a **containerised URL Shortener application** on **AWS ECS Fargate**, following best practices for Docker containerisation and Terraform IaC, ensuring scalability, security, and infrastructure automation.

## Key features:

- **Dockerfile**
  Multi-stage build using a minimal base image that runs as a non-root user, reducing image size and improving container security.

- **Terraform backend with S3**
  Centralised remote state storage with versioning enabled for rollback support and encryption for secure state management.

- **VPC configuration**
  Public subnets (one per AZ) for ALB ingress  
  Private subnets (one per AZ) for ECS workloads  
  VPC endpoints for secure private connectivity to AWS services

- **Security Groups**
  Least-privilege inbound/outbound rules controlling traffic between the ALB and ECS tasks

- **Application Load Balancer (ALB) with AWS WAF**
  Secure HTTPS ingress with managed firewall protection

  - Attached **AWSManagedRulesCommonRuleSet**
  - Configured ALB health checks ensuring only healthy ECS tasks receive traffic

- **Blue/Green deployments with CodeDeploy**
  Zero-downtime ECS service deployments with:

  - automatic rollback on failed health checks
  - controlled traffic shifting between task sets

- **ECR repository**
  Stores and versions Docker container images used by ECS tasks

- **Route 53 hosted zone & ACM**
  DNS routing via alias records pointing to the ALB  
  TLS certificate provisioning using AWS Certificate Manager

- **OIDC integration with GitHub Actions**
  Secure keyless authentication from GitHub Actions into AWS (no long-lived credentials stored)

- **Automated CI/CD pipelines**

---

## Architecture Diagram

![ezgif-6af6409b582662](https://github.com/user-attachments/assets/bc696495-0af9-44da-a6cd-cb2a7eeba3f9)

---

## How To Use It

### Prerequisites

- OIDC role configured in AWS
- S3 bucket for Terraform remote state

### Steps

```bash
git clone https://github.com/hassan114h/url-shortener-ecs-fargate
cd url-shortener-ecs-fargate
