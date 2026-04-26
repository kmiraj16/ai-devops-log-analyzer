# 📖 Operational Runbook: AI DevOps Log Analyzer

This document serves as the primary technical reference for maintaining system reliability, performing smoke tests, and executing emergency rollbacks for the AI DevOps Log Analyzer stack.

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
2. **Execute Reversion:** `aws ecs update-service --cluster ai-log-analyzer-cluster --service analyzer-service --task-definition ai-log-analyzer:<STABLE_REVISION>`
3. **Verify:** Re-run Smoke Tests against the stable revision.

---

## 3. Standard Operating Procedures (SOPs)

### Scenario: Database Connection Timeout
* **Fix:** Check if the **ECS Security Group** is explicitly allowed on Port `5432` in the **RDS Security Group** ingress rules.
* **Fix:** Verify DB credentials in **AWS Secrets Manager** have not been rotated.

### Scenario: ECS Task Churn (Start/Stop Loop)
* **Fix:** Execute `aws ecs describe-tasks` to check the "Stopped Reason." Verify `init_db.py` is not crashing during container instantiation.

---

## 4. Alarm Response Matrix
*Action items for when specific CloudWatch Alarms trigger an SNS email alert.*

| Alarm Name | Priority | Immediate Action |
| :--- | :--- | :--- |
| **High-CPU-Alert** | **Medium** | Check `ALB Traffic` widget. If requests are normal, investigate FastAPI code for inefficient loops. If traffic is high, increase task count. |
| **Critical-DB-Connection** | **High** | Run `Operational Logs` query on Dashboard. Look for `Too many connections` errors. Restart ECS service to clear stalled sessions. |
| **ALB-Backend-Failure** | **Critical** | **Immediate Rollback.** This means the containers are unhealthy or crashing. Check "Stopped Reason" in ECS Console. |

---

## 5. Chaos Testing & Verification (Validation Log)
*Documentation of failure scenarios practiced to ensure observability works.*

### Scenario: Total Backend Failure (Simulated)
* **Method:** Manually set ECS Desired Task Count to `0`.
* **Observation:** Dashboard `RequestCount` dropped to zero; `ALB-Backend-Failure` alarm transitioned to **In Alarm** state within 2 minutes.
* **Verification:** Received automated SNS Email Alert.
* **Recovery:** Restored task count to `1`; verified `200 OK` logs reappeared in the dashboard widget.

---

## 6. Escalation Path
If the rollback fails to stabilize the environment:
1. **Infrastructure Lead:** Notify via internal messaging/on-call rotation.
2. **Data Integrity:** Verify the last **RDS Snapshot** for Point-in-Time Recovery (PITR).

---

## 7. Observability Troubleshooting (Known AWS Quirks)
*Documentation of edge cases discovered during routine chaos testing.*

### Issue: `ALB-Backend-Failure` Alarm stays Green during total outage
* **Symptom:** ECS tasks scale to `0`, the application returns `503 Service Unavailable`, but the CloudWatch Alarm does not trigger.
* **Root Cause:** The alarm monitors `Target_5XX_Count` (FastAPI crashing). If no containers exist, the Application Load Balancer itself throws an `ELB_5XX` error. Because the target never received traffic, the target error metric stays at zero.
* **Resolution:** To properly test the target alarm, the container must be running, but its internal dependencies (e.g., Database connection) must be severed via Security Groups to force a genuine `500 Internal Server Error` from the application code.

### Issue: SNS Alerts not sending after Terraform Re-apply
* **Symptom:** CloudWatch Alarm enters the Red (ALARM) state, but no email is received. The email subscription status shows as "Confirmed."
* **Root Cause:** If the infrastructure is destroyed and recreated via Terraform, AWS generates a new underlying ID for the SNS Topic. The CloudWatch Alarm may still be pointing to the "ghost" ID of the deleted topic.
* **Resolution:** 1. Open the Alarm in CloudWatch.
  2. Go to Actions -> Edit.
  3. Remove the old notification target (it will likely say "Deleted" next to the ID).
  4. Add a new notification pointing to the newly recreated SNS Topic.
  5. Verify the SNS Subscription ID does not say "Deleted"; if it does, recreate the email subscription and click the new confirmation link.