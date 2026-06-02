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
[Key Features](#key-features) • [Architecture Diagram](#architecture-diagram) • [App Walkthrough](#app-walkthrough) • [Code Deploy](#Code-Deploy) 


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

<img width="911" height="752" alt="image" src="https://github.com/user-attachments/assets/51ddc869-972d-415d-8c23-3891fb34c948" />

---

## App Walkthrough 

https://github.com/user-attachments/assets/21c7dc07-9485-4422-b825-c5c921bfb4c6

---

## Code Deploy

<img width="1030" height="731" alt="image" src="https://github.com/user-attachments/assets/a80047e4-5043-42bf-b6a4-76ce8b3776ee" />

<img width="1604" height="561" alt="image" src="https://github.com/user-attachments/assets/953a0199-38a3-44fb-aefe-5465f7468559" />

---
