# ============================================================
# AWS Shield Application Layer Automatic Response
# ============================================================
# Terraform resource for managing an AWS Shield Application Layer Automatic
# Response for automatic DDoS mitigation.
#
# Provider Version: 6.28.0
# Resource Documentation: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/shield_application_layer_automatic_response
# AWS Service: AWS Shield Advanced
#
# IMPORTANT NOTES:
# - Requires AWS Shield Advanced subscription
# - Currently supports CloudFront Distributions and Application Load Balancers only
# - Automatic response actions help mitigate Layer 7 DDoS attacks
# - The action can be either COUNT (monitor) or BLOCK (block malicious requests)
#
# REQUIRED AWS PERMISSIONS:
# - shield:EnableApplicationLayerAutomaticResponse (Create)
# - shield:DescribeApplicationLayerAutomaticResponse (Read)
# - shield:UpdateApplicationLayerAutomaticResponse (Update)
# - shield:DisableApplicationLayerAutomaticResponse (Delete)
# - shield:ListResourcesInProtectionGroup
# - cloudfront:GetDistribution (if protecting CloudFront)
# - elasticloadbalancing:DescribeLoadBalancers (if protecting ALB)
# ============================================================

# Example: CloudFront Distribution Protection
resource "aws_shield_application_layer_automatic_response" "cloudfront_example" {
  # ------------------------------------------------------------
  # Required Arguments
  # ------------------------------------------------------------

  # ARN of the resource to protect
  # Type: string (required)
  # Supported resources:
  # - CloudFront Distribution ARN: arn:aws:cloudfront::{account-id}:distribution/{distribution-id}
  # - Application Load Balancer ARN: arn:aws:elasticloadbalancing:{region}:{account-id}:loadbalancer/app/{name}/{id}
  # Note: The resource must already have Shield Advanced protection enabled
  resource_arn = "arn:aws:cloudfront::123456789012:distribution/E1ABCDEFGHIJK"

  # Automatic response action
  # Type: string (required)
  # Valid values:
  # - "COUNT" - Monitor and count malicious requests without blocking (recommended for testing)
  # - "BLOCK" - Block malicious requests (for production use after validation)
  # Best Practice: Start with COUNT to validate detection accuracy before switching to BLOCK
  action = "COUNT"

  # ------------------------------------------------------------
  # Optional Blocks
  # ------------------------------------------------------------

  # Timeouts for resource operations
  # All timeout values are strings that can be parsed as duration
  # Format: Numbers with unit suffixes (e.g., "30s", "5m", "2h")
  # Valid units: "s" (seconds), "m" (minutes), "h" (hours)
  timeouts {
    # Timeout for create operation
    # Default: No timeout (waits indefinitely)
    create = "30m"

    # Timeout for update operation
    # Default: No timeout (waits indefinitely)
    update = "30m"

    # Timeout for delete operation
    # Default: No timeout (waits indefinitely)
    # Note: Only applicable if changes are saved to state before destroy
    delete = "30m"
  }
}

# ------------------------------------------------------------
# Additional Examples
# ------------------------------------------------------------

# Example: Application Load Balancer Protection with BLOCK action
resource "aws_shield_application_layer_automatic_response" "alb_example" {
  resource_arn = "arn:aws:elasticloadbalancing:us-east-1:123456789012:loadbalancer/app/my-alb/1234567890abcdef"
  action       = "BLOCK"
}

# Example: Using data sources to construct CloudFront ARN dynamically
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}

variable "distribution_id" {
  type        = string
  description = "The CloudFront Distribution ID on which to enable Application Layer Automatic Response"
}

resource "aws_shield_application_layer_automatic_response" "dynamic_cloudfront" {
  # Dynamically construct CloudFront distribution ARN
  resource_arn = "arn:${data.aws_partition.current.partition}:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/${var.distribution_id}"
  action       = "COUNT"
}

# ------------------------------------------------------------
# Outputs
# ------------------------------------------------------------

# The resource ID (deprecated, same as resource_arn)
output "cloudfront_automatic_response_id" {
  description = "The ID of the Shield Application Layer Automatic Response (deprecated, use resource_arn)"
  value       = aws_shield_application_layer_automatic_response.cloudfront_example.id
}

# The protected resource ARN
output "cloudfront_protected_resource_arn" {
  description = "The ARN of the resource protected by automatic response"
  value       = aws_shield_application_layer_automatic_response.cloudfront_example.resource_arn
}

# The configured action
output "cloudfront_action" {
  description = "The automatic response action (COUNT or BLOCK)"
  value       = aws_shield_application_layer_automatic_response.cloudfront_example.action
}

# ============================================================
# Migration Notes
# ============================================================
# The 'id' attribute is deprecated. Use 'resource_arn' instead for identifying
# the protected resource.
#
# Before (deprecated):
# output "id" {
#   value = aws_shield_application_layer_automatic_response.example.id
# }
#
# After (recommended):
# output "resource_arn" {
#   value = aws_shield_application_layer_automatic_response.example.resource_arn
# }
# ============================================================

# ============================================================
# Best Practices & Recommendations
# ============================================================
# 1. Prerequisites:
#    - Ensure Shield Advanced subscription is active
#    - Enable Shield Advanced protection on the resource first
#    - Configure health-based detection before enabling automatic response
#
# 2. Action Selection:
#    - Start with "COUNT" action to monitor detection accuracy
#    - Analyze CloudWatch metrics and Shield event logs
#    - Switch to "BLOCK" only after validating low false positive rate
#
# 3. Monitoring:
#    - Monitor CloudWatch metrics: DDoSDetected, DDoSAttackBitsPerSecond, etc.
#    - Set up SNS alerts for Shield events
#    - Review Shield event logs regularly in CloudWatch Logs
#
# 4. Testing:
#    - Test automatic response behavior in non-production environments first
#    - Validate that legitimate traffic is not blocked
#    - Plan rollback procedures if false positives occur
#
# 5. Supported Resources:
#    - Only CloudFront Distributions and ALBs are currently supported
#    - Ensure the resource is in a supported region (if ALB)
#    - CloudFront distributions are global (no region required in ARN)
#
# 6. Cost Considerations:
#    - Shield Advanced is a subscription service with monthly fees
#    - Additional costs may apply for protected resources
#    - Review AWS Shield Advanced pricing before implementation
# ============================================================
