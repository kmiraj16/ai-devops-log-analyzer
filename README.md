# AI DevOps Log Analyzer

## Project Overview

AI DevOps Log Analyzer is a cloud-native backend service designed to analyze infrastructure and application logs and suggest possible root causes.

The goal of this project is to build a production-style system that helps engineers quickly identify operational issues in distributed environments.

This project evolves step-by-step through a real-world engineering roadmap:

* Local backend service
* Containerized application (Docker)
* Cloud deployment on AWS (ECS Fargate)
* Infrastructure as Code using Terraform
* Monitoring and observability using CloudWatch

---

## Architecture Diagram

This diagram represents the target AWS architecture for the AI DevOps Log Analyzer system.

![Architecture](diagrams/architecture.png)

---

## 🚀 AWS Deployment Proof

### Application Running (via ALB)

![Health Check](docs/screenshots/local/app-health.png)

### API Documentation (FastAPI Swagger)

![Swagger](docs/screenshots/local/app-docs.png)

---

## 🔥 End-to-End Data Flow (RDS-Backed)

### Analyze Endpoint (Write to Database)

![Analyze Success](docs/screenshots/local/analyze-success.png)

### Results Endpoint (Read from Database)

![Results Success](docs/screenshots/local/results-success.png)

---

## ECS & Load Balancing

### ECS Service Running

![ECS](docs/screenshots/aws/ecs-service.png)

### ECS Task (Private Subnet)

![Task](docs/screenshots/aws/ecs-task.png)

### Application Load Balancer

![ALB](docs/screenshots/aws/alb-overview.png)

### Target Group Health

![Target Group](docs/screenshots/aws/target-group.png)

---

## Database (RDS - Private)

### RDS Instance

![RDS](docs/screenshots/db/rds-db.png)

### Schema Verification

![Schema](docs/screenshots/db/schema-proof.png)

---

## Network Architecture

### Subnets

![Subnets](docs/screenshots/aws/subnets.png)

### Security Groups

![Security Groups](docs/screenshots/aws/security-groups.png)

---

## 🏗️ Terraform Infrastructure (Week 8)

The AWS networking layer is provisioned using Terraform to ensure reproducibility and infrastructure as code practices.

### Resources Created

* VPC (`10.0.0.0/16`)
* Public subnets (2)
* Private application subnets (2)
* Private database subnets (2)
* Internet Gateway
* Public route table
* Security groups for ALB, ECS, and RDS

### Structure

```
terraform/
├── main.tf
├── variables.tf
├── outputs.tf
├── provider.tf
├── terraform.tfvars
```

### Commands Used

```bash
terraform init
terraform validate
terraform plan
terraform apply
```

### Outcome

* Successfully provisioned AWS networking using Terraform
* Infrastructure is reproducible and version-controlled
* Ready for ECS, ALB, and RDS provisioning via Terraform (next phase)

### Screenshots

* `docs/screenshots/terraform/terraform-apply-success.png`
* `docs/screenshots/terraform/terraform-vpc-subnets.png`
* `docs/screenshots/terraform/terraform-security-groups.png`

---

## Architecture Overview

* Traffic enters through an **Application Load Balancer** in public subnets
* The application runs on **ECS Fargate** in private subnets
* Data is stored in **Amazon RDS PostgreSQL** in private database subnets
* The service integrates with an **external AI API** for log analysis
* **CloudWatch** is used for logging, monitoring, and alerts
* **GitHub Actions + Amazon ECR** enable CI/CD and container deployment

---

## Tech Stack

### Backend

* Python
* FastAPI

### DevOps / Infrastructure

* Docker (containerization)
* AWS ECS Fargate (container orchestration)
* Amazon RDS PostgreSQL (data persistence)
* Application Load Balancer (traffic routing)
* CloudWatch (logging and monitoring)
* Terraform (infrastructure as code)
* GitHub Actions (CI/CD pipeline)
* Amazon ECR (container registry)

### Tools

* Git
* GitHub
* Linux CLI

---

## API Contract

### GET /health

Returns service health status.

```json
{"status": "ok"}
```

---

### POST /analyze

Analyzes a log message and stores the result in PostgreSQL.

```json
{
  "log": "database timeout"
}
```

---

### GET /results/{id}

Retrieves stored analysis result from PostgreSQL.

---

## Data Persistence

The application stores analysis results in **Amazon RDS PostgreSQL**.

### Workflow

1. Client sends log via API
2. FastAPI processes and analyzes the log
3. Result is stored in RDS
4. Data is retrieved via `/results/{id}`

### Verification

* POST `/analyze` successfully inserts records into RDS
* GET `/results/{id}` retrieves stored records
* `public.analyses` table confirmed via schema check

---

## Local Development Setup

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r app/requirements.txt
uvicorn app.main:app --reload
```

Access:

* http://127.0.0.1:8000/docs
* http://127.0.0.1:8000/health

---

## Project Goal

This project demonstrates real-world cloud engineering and DevOps practices:

* Designing scalable AWS architectures
* Deploying containerized applications on ECS
* Implementing persistent storage using RDS
* Debugging real cloud networking and connectivity issues
* Building production-style backend systems

---

## Key Learnings

* ECS ↔ RDS connectivity requires correct VPC + security group configuration
* Container image updates require task definition revisions
* Schema initialization is required for fresh databases
* End-to-end testing is critical to validate real system behavior
* Infrastructure can be fully reproduced using Terraform

---

## Next Steps

* Terraform ECS + ALB + RDS (Week 9)
* CI/CD pipeline with GitHub Actions
* CloudWatch monitoring and alerting
