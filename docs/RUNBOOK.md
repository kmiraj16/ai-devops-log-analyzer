# 📖 Operational Runbook: AI DevOps Log Analyzer

This document serves as the primary technical reference for maintaining system reliability, performing smoke tests, and executing emergency rollbacks.

---

## 1. Post-Deployment Verification (Smoke Tests)
*Note: Perform these checks within 5 minutes of any production deployment.*

| Test Case | Step | Expected Result |
| :--- | :--- | :--- |
| **Edge Connectivity** | Hit `ALB_DNS/health` | Status: `200`, `{"database": "connected"}` |
| **Data Persistence** | POST/GET log trace | `201 Created` with unique ID |
| **AI Inference** | POST to `/analyze` | Received JSON Root Cause Analysis |

---

## 2. Emergency Rollback Procedure
**Trigger:** If Smoke Tests fail or 5XX error rates exceed 5% post-release.

1. **Rollback ECS Service:** Identify the last stable Task Definition revision in the AWS Console.
2. **Execute Reversion:** ```bash
   aws ecs update-service --cluster ai-log-analyzer-cluster --service analyzer-service --task-definition ai-log-analyzer:<STABLE_REVISION>
   ```
3. **Verify:** Re-run Smoke Tests against the stable revision.

---

## 3. Standard Operating Procedures (SOPs)

### Scenario: Database Connection Timeout
* **Fix:** Check if the **ECS Security Group** is explicitly allowed on Port `5432` in the **RDS Security Group** ingress rules.
* **Fix:** Verify DB credentials in **AWS Secrets Manager** have not been rotated.

### Scenario: ECS Task Churn (Start/Stop Loop)
* **Fix:** Execute `aws ecs describe-tasks` to check the "Stopped Reason." Verify `init_db.py` is not crashing during container instantiation.

---

## 4. Escalation Path
If the rollback fails to stabilize the environment:
1. **Infrastructure Lead:** Notify via Slack/PagerDuty.
2. **Data Integrity:** Verify the last **RDS Snapshot** for Point-in-Time Recovery (PITR).