# AWS VPC Notes

## What is a VPC?

A Virtual Private Cloud (VPC) is a private network inside AWS where your resources run.

---

## Subnets

### Public Subnet

* Has access to the internet
* Used for:

  * Load Balancer
  * Public-facing services

### Private Subnet

* No direct internet access
* Used for:

  * Application services (ECS)
  * Databases (RDS)

---

## Internet Gateway (IGW)

Allows communication between VPC and the internet.

Used by public subnets.

---

## Route Tables

Define how traffic flows inside the VPC.

Example:

* 0.0.0.0/0 → IGW → internet access

---

## Security Groups

Act as virtual firewalls.

Example:

* Allow port 80 → HTTP
* Allow port 443 → HTTPS
* Allow port 8000 → API

---

## NAT Gateway (Basic Idea)

Allows private subnet resources to access the internet (for updates) without being publicly exposed.

---

## Project Architecture (Planned)

Internet
↓
Application Load Balancer (Public Subnet)
↓
ECS Service (Private Subnet)
↓
Database (Private Subnet)

---

## Key Idea

Public = exposed to internet
Private = protected

Only the load balancer should be public.

User (Internet)
      ↓
Public Subnet (ALB)
      ↓
Private Subnet (ECS App)
      ↓
Private Subnet (PostgreSQL)