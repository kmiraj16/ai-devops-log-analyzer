# AI DevOps Log Analyzer 🚀

[![AWS](https://img.shields.io/badge/AWS-Cloud-FF9900?logo=amazonaws)](https://aws.amazon.com/)
[![Terraform](https://img.shields.io/badge/Terraform-IaC-7B42BC?logo=terraform)](https://www.terraform.io/)
[![FastAPI](https://img.shields.io/badge/FastAPI-Backend-009688?logo=fastapi)](https://fastapi.tiangolo.com/)
[![Docker](https://img.shields.io/badge/Docker-Container-2496ED?logo=docker)](https://www.docker.com/)
[![GitHub Actions](https://img.shields.io/badge/GitHub_Actions-CI/CD-2088FF?logo=github-actions)](https://github.com/features/actions)

An enterprise-grade observability platform designed to reduce **Mean Time to Detection (MTTD)**. This system ingests distributed logs, utilizes an **AI-driven root cause engine** for analysis, and automates schema orchestration within a hardened AWS environment.

---

## 🏗️ System Architecture & Engineering Blueprint

```mermaid
flowchart TB
    %% Top Tier: Control & Security
    User["fa:fa-user-gear API Consumer / SRE"]

    subgraph CONTROL ["&nbsp; ⚙️ AUTOMATION & SECURITY CONTROL PLANE &nbsp;"]
        direction LR
        Git["fa:fa-github Source"] --> Workflows[["fa:fa-gears GitHub Actions"]]
        Workflows --> OIDC["fa:fa-shield-halved IAM OIDC"]
        Workflows --> TF{{"fa:fa-cloud Terraform Cloud"}}
    end

    %% Middle Tier: AWS Infrastructure
    subgraph AWS ["&nbsp; ☁️ AWS PRODUCTION VPC (REGION: US-EAST-1) &nbsp;"]
        direction TB
        
        subgraph PUBLIC ["&nbsp; 🌐 PUBLIC TIER (DMZ) &nbsp;"]
            ALB["fa:fa-network-wired Application Load Balancer"]
        end

        subgraph PRIVATE ["&nbsp; 🔐 PRIVATE COMPUTE & DATA TIER &nbsp;"]
            direction TB
            ECS["fa:fa-server ECS Fargate Service"]
            RDS[("fa:fa-database RDS PostgreSQL")]
            AI_Engine{{"fa:fa-brain AI Analyzer Engine"}}
            
            ECS <--> AI_Engine
            ECS -->|Idempotent Boot| RDS
        end
    end

    %% Side Tier: Telemetry
    subgraph TELEMETRY ["&nbsp; 📊 OBSERVABILITY STACK &nbsp;"]
        CW["fa:fa-eye CloudWatch Logs"]
        Alarms{{"fa:fa-bell Health Alarms"}}
        CW --- Alarms
    end

    %% Connectivity logic
    User -->|HTTPS/TLS 1.3| ALB
    ALB -->|Target Group Routing| ECS
    TF -.->|Infrastructure as Code| AWS
    ECS -.->|FluentBit Telemetry| CW
    Alarms -.->|SNS / PagerDuty| User

    %% Style Definitions
    classDef blue fill:#ffffff,stroke:#2088FF,stroke-width:2px,color:#1D2126,font-weight:bold;
    classDef orange fill:#ffffff,stroke:#FF9900,stroke-width:2px,color:#232F3E,font-weight:bold;
    classDef teal fill:#ffffff,stroke:#00A191,stroke-width:2px,color:#333,font-weight:bold;
    classDef gray fill:#f8f9fa,stroke:#9ea5ad,stroke-width:1px,stroke-dasharray: 5 5;
    
    class CONTROL,Workflows,Git,TF blue;
    class AWS,ALB,ECS,RDS,OIDC orange;
    class TELEMETRY,CW,AI_Engine,Alarms teal;
    class PUBLIC,PRIVATE gray;
```

---

## ⚙️ Core Engineering Capabilities

### 🛡️ Zero-Trust CI/CD & Security
* **OIDC Identity Federation:** Eliminated the use of long-lived AWS IAM Access Keys. GitHub Actions authenticates via **OpenID Connect (OIDC)** short-lived tokens, adhering to the principle of least privilege.
* **Multi-Tier Network Isolation:** Engineered a hardened VPC with **Public (DMZ)** and **Private** tiers. The Application (ECS) and Database (RDS) reside in non-routable subnets, protected by cross-linked Security Groups.

### 🤖 AI-Powered Reliability
* **Automated Root Cause Analysis:** Log streams are processed by an AI engine to categorize severity and provide immediate remediation runbooks, significantly reducing **Mean Time to Repair (MTTR)**.
* **Idempotent Schema Orchestration:** The FastAPI application manages its own PostgreSQL lifecycle. Upon container instantiation, it executes schema migrations (`IF NOT EXISTS`), enabling "Cattle, not Pets" infrastructure.

### 🛠️ Immutable Infrastructure (IaC)
* **Stateful Governance:** 100% of the AWS environment is codified via **Terraform**. Infrastructure state is maintained in a remote backend with atomic locking to prevent configuration drift.

---

## 📡 Operational Proof (SRE Artifacts)

<details>
<summary><b>1. CI/CD & Security Integrity</b></summary>
<br>
<i>Proof of the passwordless OIDC handshake and successful pipeline execution.</i>
<br><br>
<img src="docs/screenshots/workflows-success.png" alt="CI/CD Success" width="800">
</details>

<details>
<summary><b>2. Cloud Infrastructure Provisioning</b></summary>
<br>
<i>Terraform output validating the creation of the VPC, ALB, and ECS Fargate clusters.</i>
<br><br>
<img src="docs/screenshots/terraform/terraform-apply-week9.png" alt="Terraform Apply" width="800">
</details>

<details>
<summary><b>3. AI Endpoint & Database Connectivity</b></summary>
<br>
<i>Live API responses showing successful deep health checks and log analysis storage.</i>
<br><br>
<img src="docs/screenshots/local/app-health.png" alt="Health Check" width="800">
<img src="docs/screenshots/db/schema-proof.png" alt="Database Schema" width="800">
</details>

---

## 📖 SRE Runbook (Extract)
**Scenario: Database Connection Failure**
1. Check **CloudWatch Alarm** `RDSConnectionThreshold`.
2. Verify ECS Task environment variables for `DB_HOST` via the GitHub Actions log.
3. Validate Security Group ingress rules (ensure Port 5432 is open between App-Tier and Data-Tier).