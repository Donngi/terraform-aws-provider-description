################################################################################
# AWS Shield Protection Health Check Association
################################################################################
# Creates an association between a Route53 Health Check and a Shield Advanced
# protected resource. This association uses the health of your applications to
# improve responsiveness and accuracy in attack detection and mitigation.
#
# Key Features:
# - Enhances DDoS attack detection accuracy for Shield Advanced protected resources
# - Enables faster mitigation response when health checks report unhealthy status
# - Required for Shield Response Team (SRT) proactive engagement support
# - Improves web request flood detection for application layer resources
# - Provides better network/transport layer event detection for network resources
#
# Benefits:
# - Network Layer Resources (NLB, EIP, Global Accelerator):
#   * Faster mitigations with lower thresholds when unhealthy
#   * Enhanced accuracy of network-layer event detection
# - Application Layer Resources (CloudFront, ALB):
#   * Improved web request flood detection accuracy
#   * Smaller deviations needed to trigger alerts
#   * Faster event reporting when health check is unhealthy
#
# Prerequisites:
# - AWS Shield Advanced subscription (required)
# - Shield Advanced protection created for the resource
# - Route53 health check configured and reporting healthy
# - Health check must be relevant to the protected resource's health
#
# Important Notes:
# - Health check must report healthy when first associated
# - The health check should accurately reflect the resource's actual health
# - Not supported for Route 53 hosted zones
# - The association is specific to one protection and one health check
#
# Supported Protected Resources:
# - CloudFront distributions
# - Application Load Balancers
# - Network Load Balancers
# - Elastic IP addresses
# - AWS Global Accelerator standard accelerators
#
# Reference:
# - Blog Post: https://aws.amazon.com/about-aws/whats-new/2020/02/aws-shield-advanced-now-supports-health-based-detection/
# - Documentation: https://docs.aws.amazon.com/waf/latest/developerguide/ddos-advanced-health-checks.html
# - Terraform: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/shield_protection_health_check_association
################################################################################

resource "aws_shield_protection_health_check_association" "example" {
  ################################################################################
  # Required Arguments
  ################################################################################

  # The ARN (Amazon Resource Name) of the Route53 Health Check resource
  # which will be associated to the protected resource.
  #
  # Requirements:
  # - Must be a valid Route53 Health Check ARN
  # - Health check must be reporting healthy when association is created
  # - Health check should be relevant to the protected resource's health
  # - Health check must remain available for Shield Advanced to use
  #
  # Common Health Check Types:
  # - HTTP/HTTPS health checks for application layer resources
  # - CloudWatch alarm-based health checks for metric monitoring
  # - Calculated health checks combining multiple health checks
  #
  # Best Practices:
  # - Use specific endpoints that represent your application's health
  # - Configure appropriate failure thresholds and request intervals
  # - Monitor health check status in CloudWatch
  # - Ensure health check can access the protected resource
  #
  # Example ARN format:
  # arn:aws:route53:::healthcheck/12345678-1234-1234-1234-123456789012
  health_check_arn = aws_route53_health_check.example.arn

  # The ID of the Shield Advanced protected resource.
  #
  # Requirements:
  # - Must be a valid Shield Advanced protection ID
  # - The protection must already exist before creating the association
  # - Each protection can have multiple health check associations
  #
  # Usage Notes:
  # - This is the unique identifier returned when creating a Shield protection
  # - Not the same as the resource ARN or resource ID
  # - Can be obtained from aws_shield_protection resource
  #
  # Example: "12345678-abcd-1234-5678-123456789012"
  shield_protection_id = aws_shield_protection.example.id

  ################################################################################
  # Attributes Reference
  ################################################################################
  # The following attributes are exported:
  #
  # id - The unique identifier (ID) for the association object that is created.
  #      This ID can be used to manage or reference the association.
  ################################################################################
}

################################################################################
# Example: Complete Shield Advanced Setup with Health Check Association
################################################################################

# Get current AWS account and region information
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}

# Example 1: EIP with Shield Protection and Health Check Association
resource "aws_eip" "example" {
  domain = "vpc"
  tags = {
    Name        = "shield-protected-eip"
    Environment = "production"
  }
}

resource "aws_shield_protection" "example" {
  name = "example-eip-protection"
  # EIP resource ARN format
  resource_arn = "arn:${data.aws_partition.current.partition}:ec2:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:eip-allocation/${aws_eip.example.id}"

  tags = {
    Name        = "example-protection"
    Environment = "production"
  }
}

# Route53 Health Check for the EIP
resource "aws_route53_health_check" "example" {
  ip_address        = aws_eip.example.public_ip
  port              = 80
  type              = "HTTP"
  resource_path     = "/ready"
  failure_threshold = "3"
  request_interval  = "30"

  tags = {
    Name        = "shield-eip-health-check"
    Environment = "production"
  }
}

# Associate the health check with the Shield protection
resource "aws_shield_protection_health_check_association" "example" {
  health_check_arn     = aws_route53_health_check.example.arn
  shield_protection_id = aws_shield_protection.example.id
}

################################################################################
# Example 2: CloudFront Distribution with Health Check Association
################################################################################

# Note: CloudFront distributions require health checks that monitor the origin
resource "aws_cloudfront_distribution" "example" {
  enabled = true
  # ... CloudFront configuration ...
}

resource "aws_shield_protection" "cloudfront" {
  name         = "cloudfront-protection"
  resource_arn = aws_cloudfront_distribution.example.arn

  tags = {
    Name        = "cloudfront-shield-protection"
    Environment = "production"
  }
}

# CloudWatch alarm-based health check for CloudFront
resource "aws_cloudwatch_metric_alarm" "cloudfront_health" {
  alarm_name          = "cloudfront-health-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "5xxErrorRate"
  namespace           = "AWS/CloudFront"
  period              = "60"
  statistic           = "Average"
  threshold           = "5"

  dimensions = {
    DistributionId = aws_cloudfront_distribution.example.id
  }
}

resource "aws_route53_health_check" "cloudfront" {
  type                            = "CLOUDWATCH_METRIC"
  cloudwatch_alarm_name           = aws_cloudwatch_metric_alarm.cloudfront_health.alarm_name
  cloudwatch_alarm_region         = data.aws_region.current.name
  insufficient_data_health_status = "Healthy"

  tags = {
    Name        = "cloudfront-health-check"
    Environment = "production"
  }
}

resource "aws_shield_protection_health_check_association" "cloudfront" {
  health_check_arn     = aws_route53_health_check.cloudfront.arn
  shield_protection_id = aws_shield_protection.cloudfront.id
}

################################################################################
# Example 3: Application Load Balancer with Health Check Association
################################################################################

resource "aws_lb" "example" {
  name               = "example-alb"
  load_balancer_type = "application"
  # ... ALB configuration ...
}

resource "aws_shield_protection" "alb" {
  name         = "alb-protection"
  resource_arn = aws_lb.example.arn

  tags = {
    Name        = "alb-shield-protection"
    Environment = "production"
  }
}

# Health check using ALB target health metrics
resource "aws_cloudwatch_metric_alarm" "alb_health" {
  alarm_name          = "alb-target-health-alarm"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "HealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = "60"
  statistic           = "Average"
  threshold           = "1"

  dimensions = {
    LoadBalancer = aws_lb.example.arn_suffix
  }
}

resource "aws_route53_health_check" "alb" {
  type                            = "CLOUDWATCH_METRIC"
  cloudwatch_alarm_name           = aws_cloudwatch_metric_alarm.alb_health.alarm_name
  cloudwatch_alarm_region         = data.aws_region.current.name
  insufficient_data_health_status = "Healthy"

  tags = {
    Name        = "alb-health-check"
    Environment = "production"
  }
}

resource "aws_shield_protection_health_check_association" "alb" {
  health_check_arn     = aws_route53_health_check.alb.arn
  shield_protection_id = aws_shield_protection.alb.id
}

################################################################################
# Common CloudWatch Metrics for Health Checks
################################################################################
# Application Layer Resources:
# - CloudFront: 5xxErrorRate, 4xxErrorRate, Requests
# - ALB: HealthyHostCount, UnHealthyHostCount, TargetResponseTime
# - NLB: HealthyHostCount, UnHealthyHostCount
#
# Network Layer Resources:
# - EIP: Custom application-level HTTP/HTTPS checks
# - Global Accelerator: HealthCheckStatus
#
# Best Practices:
# - Set appropriate thresholds that indicate actual problems
# - Use multiple evaluation periods to avoid false positives
# - Monitor the health check status itself
# - Test health checks before associating with Shield Advanced
# - Document what each health check is monitoring
################################################################################

################################################################################
# Cost Considerations
################################################################################
# Costs:
# - AWS Shield Advanced subscription: $3,000/month base fee
# - Shield Advanced data transfer: $0.01-$0.02 per GB (beyond subscription)
# - Route53 Health Checks: $0.50/month per health check
# - CloudWatch alarms: $0.10/month per alarm
#
# The association itself does not incur additional charges beyond the
# health check and Shield Advanced subscription costs.
################################################################################

################################################################################
# Security and Compliance
################################################################################
# Security Best Practices:
# - Use IAM policies to control who can create/modify associations
# - Enable CloudTrail logging for Shield Advanced API calls
# - Monitor health check status changes in CloudWatch
# - Set up SNS notifications for health check failures
# - Regularly review and test health check configurations
#
# Required IAM Permissions:
# - shield:AssociateHealthCheck (to create the association)
# - shield:DescribeProtection (to view the association)
# - shield:DisassociateHealthCheck (to remove the association)
# - route53:GetHealthCheck (to verify health check status)
#
# Compliance:
# - Supports compliance requirements for DDoS protection
# - Helps meet availability and resilience requirements
# - Can be part of SOC 2, PCI DSS, and HIPAA compliance strategies
################################################################################

################################################################################
# Troubleshooting
################################################################################
# Common Issues:
#
# 1. "Health check is not healthy" error:
#    - Verify the health check is reporting healthy in Route53
#    - Check CloudWatch metrics for the health check
#    - Ensure the monitored resource is actually healthy
#
# 2. "Protection not found" error:
#    - Verify the shield_protection_id exists
#    - Ensure Shield Advanced subscription is active
#    - Check the protection hasn't been deleted
#
# 3. "Invalid health check ARN" error:
#    - Verify the health check ARN format is correct
#    - Ensure the health check exists in the same account
#    - Check for typos in the ARN
#
# 4. Association not improving detection:
#    - Verify the health check is relevant to the resource
#    - Check that the health check is actually monitoring the right metrics
#    - Review Shield Advanced event logs
#
# Monitoring:
# - Use CloudWatch to monitor health check status
# - Set up SNS notifications for health check state changes
# - Review Shield Advanced detection events
# - Monitor CloudTrail for association changes
################################################################################

################################################################################
# Additional Resources
################################################################################
# AWS Documentation:
# - Shield Advanced Health Checks: https://docs.aws.amazon.com/waf/latest/developerguide/ddos-advanced-health-checks.html
# - Route53 Health Checks: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/health-checks-types.html
# - Shield Advanced API: https://docs.aws.amazon.com/waf/latest/DDOSAPIReference/API_AssociateHealthCheck.html
#
# Related Terraform Resources:
# - aws_shield_protection: Create Shield Advanced protections
# - aws_route53_health_check: Create Route53 health checks
# - aws_cloudwatch_metric_alarm: Create CloudWatch alarms for health checks
# - aws_shield_protection_group: Group multiple protections
################################################################################
