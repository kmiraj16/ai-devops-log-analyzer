# AWS IAM Notes

## Core Concepts

### Region
A geographic area where AWS has data centers.

### Availability Zone
An isolated location inside a region.

### IAM User
A person or account identity used to log in and access AWS.

### IAM Role
A temporary permission identity assumed by AWS services or users.

### IAM Policy
A JSON document that defines permissions.

## Project Context

For this project:
- I use an IAM user for console and CLI access
- ECS tasks later will use IAM roles
- Policies define what services can be accessed

## Key Idea

Users are for people.
Roles are for AWS services and temporary access.
Policies define permissions.