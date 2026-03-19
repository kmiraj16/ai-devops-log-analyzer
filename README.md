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

Backend

* Python
* FastAPI

DevOps / Infrastructure

* Docker (Week 2)
* Terraform (Later Phase)
* AWS ECS / Fargate (Later Phase)

Tools

* Git
* GitHub
* Linux CLI

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

Week 0

* Development environment setup
* AWS account guardrails
* Git repository initialization

Week 1

* Linux command practice
* FastAPI service
* Health endpoint
* Log analysis endpoint

Week 2

* Docker containerization
* Dockerfile creation
* Running the service inside containers

Future Weeks

* Infrastructure as Code using Terraform
* AWS deployment (ECS / Fargate)
* CI/CD pipeline
* Monitoring and observability

---

## Deployment Plan

Local Development

Run the API locally using:

pip install fastapi uvicorn

Start the server:

uvicorn app.main:app --reload

Open the API documentation:

http://127.0.0.1:8000/docs

Future deployment will include:

* Docker container builds
* Container registry
* AWS ECS deployment
* Automated infrastructure provisioning

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
