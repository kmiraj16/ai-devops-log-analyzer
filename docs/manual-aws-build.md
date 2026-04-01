# Manual AWS Infrastructure Setup (Week 5)

This document captures the exact AWS console steps used to manually create the infrastructure for the AI DevOps Log Analyzer project.

---

## 1. Create VPC

1. Navigate to AWS Console → VPC
2. Click "Create VPC"
3. Select "VPC only"
4. Enter:

   * Name: ai-log-analyzer-vpc
   * IPv4 CIDR: 10.0.0.0/16
5. Click "Create VPC"

---

## 2. Create Internet Gateway

1. Navigate to VPC → Internet Gateways
2. Click "Create internet gateway"
3. Name: ai-log-analyzer-igw
4. Click "Create"
5. Select the IGW → Actions → Attach to VPC
6. Choose: ai-log-analyzer-vpc

---

## 3. Create Public Subnets

### Public Subnet A

1. Go to VPC → Subnets → Create subnet
2. Enter:

   * Name: public-subnet-a
   * VPC: ai-log-analyzer-vpc
   * AZ: us-east-1a
   * CIDR: 10.0.1.0/24
3. Create subnet

### Public Subnet B

1. Create another subnet:

   * Name: public-subnet-b
   * AZ: us-east-1b
   * CIDR: 10.0.2.0/24

### Enable Public IP

1. Select each public subnet
2. Actions → Edit subnet settings
3. Enable "Auto-assign public IPv4"

---

## 4. Create Route Table for Public Subnets

1. Go to VPC → Route Tables → Create
2. Name: public-rt
3. Add route:

   * Destination: 0.0.0.0/0
   * Target: Internet Gateway
4. Associate with:

   * public-subnet-a
   * public-subnet-b

---

## 5. Create Private App Subnets

### Subnet A

* Name: private-app-subnet-a
* CIDR: 10.0.11.0/24
* AZ: same as public-subnet-a

### Subnet B

* Name: private-app-subnet-b
* CIDR: 10.0.12.0/24
* AZ: same as public-subnet-b

Ensure public IP auto-assign is disabled.

---

## 6. Create Private DB Subnets

### Subnet A

* Name: private-db-subnet-a
* CIDR: 10.0.21.0/24

### Subnet B

* Name: private-db-subnet-b
* CIDR: 10.0.22.0/24

---

## 7. Create Security Groups

### ALB Security Group

* Name: alb-sg
* Inbound:

  * HTTP (80) from 0.0.0.0/0

### ECS Security Group

* Name: ecs-sg
* Inbound:

  * TCP 8000 from alb-sg

### RDS Security Group

* Name: rds-sg
* Inbound:

  * PostgreSQL 5432 from ecs-sg

---

## 8. Create ECR Repository

1. Navigate to ECR
2. Click "Create repository"
3. Name: ai-log-analyzer
4. Visibility: Private

---

## 9. Push Docker Image to ECR

1. Authenticate Docker:
   aws ecr get-login-password --region <region> | docker login ...

2. Build image:
   docker build -f docker/Dockerfile -t ai-log-analyzer .

3. Tag image:
   docker tag ai-log-analyzer:latest <repo-uri>:latest

4. Push image:
   docker push <repo-uri>:latest

---

## Outcome

* VPC with public and private subnet layers created
* Security groups configured for layered access (ALB → ECS → RDS)
* Docker image stored in Amazon ECR

This completes the manual AWS infrastructure setup for Week 5.
