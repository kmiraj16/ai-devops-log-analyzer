# ==========================================
# SNS TOPIC & SUBSCRIPTION
# ==========================================

resource "aws_sns_topic" "sre_alerts" {
  name = "${var.project_name}-alerts-topic" 
}

resource "aws_sns_topic_subscription" "sre_email_sub" {
  topic_arn = aws_sns_topic.sre_alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

# ==========================================
# CLOUDWATCH ALARM: ALB 5XX ERRORS
# ==========================================

resource "aws_cloudwatch_metric_alarm" "alb_backend_failure" {
  alarm_name          = "${var.project_name}-Backend-Failure-Alert"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "HTTPCode_Target_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Sum"
  threshold           = 1
  alarm_description   = "Triggers when the FastAPI backend throws 5XX errors."
  treat_missing_data  = "notBreaching"

  dimensions = {
    LoadBalancer = aws_lb.main.arn_suffix
  }

  alarm_actions = [aws_sns_topic.sre_alerts.arn]
  ok_actions    = [aws_sns_topic.sre_alerts.arn]
}

# ==========================================
# CLOUDWATCH DASHBOARD
# ==========================================

resource "aws_cloudwatch_dashboard" "main_dashboard" {
  dashboard_name = "${var.project_name}-vitals-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric",
        x      = 0,
        y      = 0,
        width  = 19,
        height = 8,
        properties = {
          metrics = [
            [ "AWS/ECS", "MemoryUtilization", "ServiceName", "${var.project_name}-service", "ClusterName", "${var.project_name}-cluster", { "stat": "Average" } ],
            [ ".", "CPUUtilization", ".", ".", ".", ".", { "stat": "Average" } ]
          ],
          view    = "timeSeries",
          stacked = false,
          region  = "us-east-1",
          period  = 60,
          title   = "ECS Resource Saturation"
        }
      },
      {
        type   = "metric",
        x      = 0,
        y      = 8,
        width  = 20,
        height = 7,
        properties = {
          metrics = [
            [ "AWS/ApplicationELB", "RequestCount", "TargetGroup", aws_lb_target_group.app.arn_suffix, "LoadBalancer", aws_lb.main.arn_suffix ],
            [ ".", "HTTPCode_Target_4XX_Count", ".", ".", ".", "." ],
            [ ".", "HTTPCode_Target_2XX_Count", ".", ".", ".", "." ],
            [ ".", "TargetResponseTime", ".", ".", ".", ".", { "stat": "Average" } ]
          ],
          view    = "timeSeries",
          stacked = false,
          region  = "us-east-1",
          stat    = "Sum",
          period  = 60,
          title   = "ALB Traffic & Performance"
        }
      },
      {
        type   = "log",
        x      = 0,
        y      = 15,
        width  = 24,
        height = 6,
        properties = {
          query = "SOURCE \"/ecs/${var.project_name}\" | fields @timestamp, @message | filter @message like /analyze/ or @message like /200/ | sort @timestamp desc | limit 20",
          queryLanguage = "CWLI",
          region = "us-east-1",
          title  = "Operational Logs",
          view   = "table"
        }
      }
    ]
  })
}