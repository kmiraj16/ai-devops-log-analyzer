# AI DevOps Log Analyzer

## Project Overview

AI DevOps Log Analyzer is a backend service designed to analyze infrastructure and application logs and suggest possible root causes.

The goal of this project is to simulate a real DevOps tool that engineers can use to quickly identify operational issues in production systems.

This project will evolve step-by-step through the roadmap:

* Local backend service
* Containerized application
* Cloud deployment using AWS
* Infrastructure as Code using Terraform
* Monitoring and observability

---

## Architecture

Current architecture (Week 1):

User → FastAPI Service → Log Analysis Engine

Future architecture (planned):

User
↓
Application Load Balancer
↓
Containerized API (Docker / ECS)
↓
Log Analysis Service
↓
Database / Storage (future phase)

---

## Tech Stack

### Backend

* Python
* FastAPI

### DevOps / Infrastructure

* Docker (Week 2)
* Terraform (Later Phase)
* AWS ECS / Fargate (Later Phase)

### Tools

* Git
* GitHub
* Linux CLI

---

## API Contract

### GET /health

Returns service health status.

Response:
{"status": "ok"}

---

### POST /analyze

Analyzes a log message and returns possible root cause.

Request:
{
"log": "database timeout"
}

Response:
{
"root_cause": "Service timeout",
"suggestion": "Check network connectivity or service availability"
}

---
## Data Persistence

The application stores analysis results in PostgreSQL.

### Workflow

1. User submits log via UI or API
2. FastAPI analyzes the log
3. Result is stored in PostgreSQL
4. Data can be retrieved using:

GET /results/{id}

### Example

GET /results/1


## Local Development Setup

### 1. Create Virtual Environment

python3 -m venv .venv

### 2. Activate Virtual Environment

Mac / Linux:
source .venv/bin/activate

Windows:
.venv\Scripts\activate

### 3. Install Dependencies

pip install -r app/requirements.txt

### 4. Run the Application

uvicorn app.main:app --reload

### 5. Test the API

http://127.0.0.1:8000/docs

http://127.0.0.1:8000/health

---

## Phase A Goals

Phase A focuses on building a working backend service and preparing it for containerization.

Completed tasks:

* Linux environment setup
* Git repository initialized
* FastAPI service created
* Health check endpoint implemented
* Log analysis endpoint implemented

Endpoints currently available:

GET /health
POST /analyze

---

## Development Plan

### Week 0

* Development environment setup
* AWS account guardrails
* Git repository initialization

### Week 1

* Linux command practice
* FastAPI service
* Health endpoint
* Log analysis endpoint

### Week 2

* HTTP and API understanding
* Basic UI development
* Docker containerization
* Docker Compose workflow

### Future Weeks

* Infrastructure as Code using Terraform
* AWS deployment (ECS / Fargate)
* CI/CD pipeline
* Monitoring and observability

---

## Deployment Plan

### Local Development

Run the API locally using:

uvicorn app.main:app --reload

Open the API documentation:

http://127.0.0.1:8000/docs

---

### Future Deployment

* Docker container builds
* Container registry
* AWS ECS deployment
* Automated infrastructure provisioning
