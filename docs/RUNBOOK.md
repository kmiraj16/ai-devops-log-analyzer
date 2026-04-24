# 📖 Operational Runbook: AI DevOps Log Analyzer

This document serves as the primary technical reference for maintaining system reliability, performing smoke tests, and executing emergency rollbacks.

---

## 1. Post-Deployment Verification (Smoke Tests)
After every deployment, perform these checks to ensure the environment is stable:

| Test Case | Action | Expected Result |
| :--- | :--- | :--- |
| **Edge Connectivity** | `curl -i https://<ALB_DNS>/health` | `200 OK` with `{"database": "connected"}` |
| **AI Pipeline** | POST raw log to `/analyze` | `201 Created` with a root_cause JSON |
| **Persistence** | GET `/results/{id}` | Log data is correctly retrieved from RDS |

---

## 2. Emergency Rollback Procedure
If a deployment triggers a `5XX Error` spike or fails smoke tests:

1. **Identify Stable Revision:** Navigate to **ECS Console** > **Task Definitions** and find the previous stable revision number.
2. **Execute Rollback:** ```bash
   aws ecs update-service --cluster ai-log-analyzer-cluster --service analyzer-service --task-definition ai-log-analyzer:<STABLE_REVISION_NUMBER>
   ```
3. **Align IaC:** Revert the Terraform code to match the rolled-back version to prevent configuration drift.

---

## 3. Standard Operating Procedures (SOPs)

### Scenario: Database Connection Timeout
* **Fix:** Check if the **ECS Security Group** is explicitly allowed on Port `5432` in the **RDS Security Group** ingress rules.

### Scenario: ECS Task Churn (Start/Stop Loop)
* **Fix:** Check CloudWatch Logs for `InitializationError`. Verify that the `init_db.py` script is not crashing due to missing environment variables.