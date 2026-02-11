################################################################################
# CloudWatch RUM App Monitor
# https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/rum_app_monitor
################################################################################

# CloudWatch RUM (Real User Monitoring) app monitor collects and analyzes
# client-side performance data from actual user sessions of web applications.
# It provides insights into page load times, client-side errors, user behavior,
# and helps identify and debug client-side performance issues.
#
# Key features:
# - Collects real user monitoring data from web applications
# - Tracks page load times, JavaScript errors, and HTTP errors
# - Integrates with X-Ray for distributed tracing
# - Stores telemetry data for 30 days (can extend with CloudWatch Logs)
# - Provides session sampling to control costs
# - Supports custom events for application-specific monitoring
#
# Common use cases:
# - Monitor web application performance from end-user perspective
# - Identify and debug client-side JavaScript errors
# - Track user session behavior and page navigation patterns
# - Analyze geographic distribution of performance issues
# - Integrate with Application Signals for full-stack observability

resource "aws_rum_app_monitor" "example" {
  # ============================================================================
  # Required Arguments
  # ============================================================================

  # Name of the app monitor
  # - Must be unique within your AWS account
  # - Used as identifier in CloudWatch console
  # - Appears in the RUM dashboard
  # Reference: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch-RUM-get-started-create-app-monitor.html
  name = "example-app-monitor"

  # Top-level internet domain for your application
  # - Use either 'domain' (single domain) or 'domain_list' (multiple domains)
  # - Domain must be valid and accessible
  # - Used to validate telemetry data origin
  # - Example: "example.com" or "localhost" for development
  # Note: Exactly one of 'domain' or 'domain_list' must be specified
  # Reference: https://docs.aws.amazon.com/cloudwatchrum/latest/APIReference/API_AppMonitor.html
  domain = "example.com"

  # ============================================================================
  # Optional Arguments - Data Collection Configuration
  # ============================================================================

  # Enable CloudWatch Logs for extended telemetry storage
  # - RUM keeps data for 30 days by default
  # - Set to true to send copy to CloudWatch Logs for longer retention
  # - Incurs additional CloudWatch Logs charges
  # - Useful for compliance or long-term analysis
  # Default: false
  # Reference: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch-RUM.html
  cw_log_enabled = false

  # ============================================================================
  # Optional Arguments - App Monitor Configuration
  # ============================================================================

  # Configuration data for the app monitor
  # Contains settings for telemetry collection, sampling, and authorization
  app_monitor_configuration {
    # Allow RUM web client to set cookies
    # - Enables tracking of unique users and session sequences
    # - Sets two cookies: session cookie and user cookie
    # - Cookies stored in top-level domain of current page
    # - Required for accurate user and session metrics
    # Default: false
    # Reference: https://docs.aws.amazon.com/cloudwatchrum/latest/APIReference/API_CreateAppMonitor.html
    allow_cookies = true

    # Enable AWS X-Ray tracing integration
    # - Adds X-Ray trace header to allowed HTTP requests
    # - Records X-Ray segments for distributed tracing
    # - Enables correlation between client and server-side traces
    # - Requires additional X-Ray configuration
    # Default: false
    # Reference: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch-RUM-get-started-create-app-monitor.html
    enable_xray = false

    # Guest IAM role ARN for data authorization
    # - ARN of IAM role attached to Cognito identity pool
    # - Authorizes sending of telemetry data to RUM
    # - Required for web client authentication
    # - Must have permissions to call RUM PutRumEvents API
    # Reference: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch-RUM-get-started-create-app-monitor.html
    # guest_role_arn = "arn:aws:iam::123456789012:role/RUM-GuestRole"

    # Amazon Cognito identity pool ID
    # - Used to authorize data transmission to RUM
    # - Works with guest_role_arn for authentication
    # - Required for web client to send telemetry
    # Reference: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch-RUM-get-started-create-app-monitor.html
    # identity_pool_id = "us-east-1:12345678-1234-1234-1234-123456789012"

    # Session sample rate
    # - Percentage of user sessions to collect (0.0 to 1.0)
    # - Higher percentage = more data but higher costs
    # - 0.1 = 10% of sessions monitored
    # - Balance between data coverage and cost
    # Default: 0.1
    # Reference: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch-RUM-get-started-create-app-monitor.html
    session_sample_rate = 0.1

    # Types of telemetry data to collect
    # - Valid values: "errors", "performance", "http"
    # - "errors": JavaScript errors and exceptions
    # - "performance": Page load times and web vitals
    # - "http": HTTP request/response data
    # - Can specify one, two, or all three types
    # Reference: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch-RUM-get-started-create-app-monitor.html
    telemetries = ["errors", "performance", "http"]

    # URLs to exclude from RUM data collection
    # - List of URL patterns to ignore
    # - Useful for excluding admin pages or sensitive areas
    # - Supports wildcard patterns
    # - Example: ["/admin/*", "/internal/*"]
    # Reference: https://docs.aws.amazon.com/cloudwatchrum/latest/APIReference/API_CreateAppMonitor.html
    # excluded_pages = ["/admin/*"]

    # URLs to include in RUM data collection
    # - If specified, only these pages are monitored
    # - Useful for focusing on specific application sections
    # - Supports wildcard patterns
    # - Example: ["/checkout/*", "/product/*"]
    # Note: Cannot use both included_pages and excluded_pages
    # Reference: https://docs.aws.amazon.com/cloudwatchrum/latest/APIReference/API_CreateAppMonitor.html
    # included_pages = ["/checkout/*"]

    # Pages to display with favorite icon in console
    # - List of URLs shown as favorites in CloudWatch RUM dashboard
    # - Provides quick access to important pages
    # - Example: ["/home", "/checkout"]
    # Reference: https://docs.aws.amazon.com/cloudwatchrum/latest/APIReference/API_CreateAppMonitor.html
    # favorite_pages = ["/home"]
  }

  # ============================================================================
  # Optional Arguments - Custom Events
  # ============================================================================

  # Allow web client to define and send custom events
  # - Enables application-specific monitoring events
  # - Custom events can track business metrics or user actions
  # - Examples: button clicks, form submissions, custom workflows
  custom_events {
    # Status of custom events
    # - Valid values: "ENABLED", "DISABLED"
    # - ENABLED: Web client can send custom events
    # - DISABLED: Custom events are blocked
    # Default: "DISABLED"
    # Reference: https://docs.aws.amazon.com/cloudwatchrum/latest/APIReference/API_CreateAppMonitor.html
    status = "DISABLED"
  }

  # ============================================================================
  # Optional Arguments - Resource Management
  # ============================================================================

  # AWS region for this resource
  # - Overrides provider-level region setting
  # - CloudWatch RUM is available in multiple regions
  # - Choose region close to your users for better performance
  # Default: Provider region
  # Reference: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch-RUM.html
  # region = "us-east-1"

  # Tags to assign to the app monitor
  # - Key-value pairs for resource organization
  # - Useful for cost allocation and resource management
  # - Inherited by related resources (e.g., CloudWatch Logs)
  # - Merges with provider default_tags if configured
  # Reference: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch-RUM-get-started-create-app-monitor.html
  tags = {
    Environment = "production"
    Application = "web-frontend"
    ManagedBy   = "terraform"
  }

  # ============================================================================
  # Computed Attributes (Read-only)
  # ============================================================================

  # The following attributes are computed by AWS and exported:
  #
  # - arn: Amazon Resource Name of the app monitor
  #   Example: "arn:aws:rum:us-east-1:123456789012:appmonitor/example-app-monitor"
  #
  # - id: CloudWatch RUM name (same as 'name')
  #   Used as resource identifier
  #
  # - app_monitor_id: Unique ID of the app monitor
  #   Required in JavaScript/HTML code snippet for client integration
  #   Example: "12345678-1234-1234-1234-123456789012"
  #
  # - cw_log_group: Name of CloudWatch Logs group
  #   Only populated if cw_log_enabled = true
  #   Example: "aws/rum/example-app-monitor"
  #
  # - tags_all: All tags including provider default_tags
  #   Complete map of tags assigned to the resource
  #
  # Reference: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/rum_app_monitor#attribute-reference
}

################################################################################
# Alternative Configuration Examples
################################################################################

# Example: Multiple domains configuration
# Use domain_list instead of domain for multi-domain applications
#
# resource "aws_rum_app_monitor" "multi_domain" {
#   name        = "multi-domain-monitor"
#   domain_list = ["example.com", "app.example.com", "api.example.com"]
#
#   app_monitor_configuration {
#     allow_cookies       = true
#     session_sample_rate = 0.2
#     telemetries         = ["errors", "performance"]
#   }
# }

# Example: Development environment with localhost
# Minimal configuration for local development
#
# resource "aws_rum_app_monitor" "development" {
#   name   = "dev-app-monitor"
#   domain = "localhost"
#
#   app_monitor_configuration {
#     session_sample_rate = 1.0  # Monitor all sessions in dev
#     telemetries         = ["errors", "performance", "http"]
#   }
# }

# Example: Production with X-Ray tracing and CloudWatch Logs
# Full observability configuration
#
# resource "aws_rum_app_monitor" "production" {
#   name            = "prod-app-monitor"
#   domain          = "production.example.com"
#   cw_log_enabled  = true
#
#   app_monitor_configuration {
#     allow_cookies       = true
#     enable_xray         = true
#     session_sample_rate = 0.1
#     telemetries         = ["errors", "performance", "http"]
#     guest_role_arn      = aws_iam_role.rum_guest.arn
#     identity_pool_id    = aws_cognito_identity_pool.rum.id
#     excluded_pages      = ["/admin/*", "/internal/*"]
#     favorite_pages      = ["/home", "/checkout", "/product"]
#   }
#
#   custom_events {
#     status = "ENABLED"
#   }
#
#   tags = {
#     Environment = "production"
#     Team        = "platform"
#     CostCenter  = "engineering"
#   }
# }

################################################################################
# Best Practices and Recommendations
################################################################################

# 1. Session Sampling Strategy
#    - Start with low sample rate (0.1 or 10%) to control costs
#    - Increase sampling for critical applications or during troubleshooting
#    - Use 1.0 (100%) in development/staging environments
#
# 2. Telemetry Types Selection
#    - Always include "errors" for error tracking
#    - Add "performance" for page load and web vitals monitoring
#    - Include "http" for API request/response analysis
#    - Consider data volume and cost when selecting types
#
# 3. Cookie Configuration
#    - Enable allow_cookies for accurate user and session tracking
#    - Consider privacy regulations (GDPR, CCPA) in your region
#    - Implement cookie consent mechanisms in your application
#
# 4. X-Ray Integration
#    - Enable enable_xray for full distributed tracing
#    - Ensure backend services also use X-Ray for end-to-end visibility
#    - Configure X-Ray sampling rules to control tracing costs
#
# 5. CloudWatch Logs Retention
#    - Enable cw_log_enabled for audit and compliance requirements
#    - Set appropriate retention policies on the log group
#    - Use CloudWatch Logs Insights for custom queries
#
# 6. Page Filtering
#    - Use excluded_pages to avoid monitoring admin or internal pages
#    - Use included_pages to focus monitoring on critical user flows
#    - Don't use both excluded_pages and included_pages simultaneously
#
# 7. Custom Events
#    - Enable custom events for business-specific metrics
#    - Track user actions like form submissions, button clicks
#    - Correlate technical performance with business outcomes
#
# 8. IAM and Authentication
#    - Create dedicated IAM role with minimal permissions for guest_role_arn
#    - Use separate Cognito identity pool for RUM authentication
#    - Follow principle of least privilege for security
#
# 9. Cost Optimization
#    - Monitor RUM usage in CloudWatch billing dashboard
#    - Adjust session_sample_rate based on traffic volume
#    - Consider excluding high-traffic, low-value pages
#    - Review telemetries selection regularly
#
# 10. Monitoring and Alerting
#     - Set up CloudWatch alarms for error rate thresholds
#     - Monitor Apdex scores for user satisfaction tracking
#     - Create dashboards combining RUM with backend metrics
#     - Use Application Signals for unified observability

################################################################################
# Integration Examples
################################################################################

# Example: Complete RUM setup with IAM and Cognito
# Note: This shows the full integration pattern
#
# # Cognito Identity Pool for RUM authentication
# resource "aws_cognito_identity_pool" "rum" {
#   identity_pool_name               = "rum-identity-pool"
#   allow_unauthenticated_identities = true
# }
#
# # IAM Role for unauthenticated (guest) access
# resource "aws_iam_role" "rum_guest" {
#   name = "rum-guest-role"
#
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [{
#       Effect = "Allow"
#       Principal = {
#         Federated = "cognito-identity.amazonaws.com"
#       }
#       Action = "sts:AssumeRoleWithWebIdentity"
#       Condition = {
#         StringEquals = {
#           "cognito-identity.amazonaws.com:aud" = aws_cognito_identity_pool.rum.id
#         }
#         "ForAnyValue:StringLike" = {
#           "cognito-identity.amazonaws.com:amr" = "unauthenticated"
#         }
#       }
#     }]
#   })
# }
#
# # IAM Policy for RUM data submission
# resource "aws_iam_role_policy" "rum_guest_policy" {
#   name = "rum-guest-policy"
#   role = aws_iam_role.rum_guest.id
#
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [{
#       Effect = "Allow"
#       Action = [
#         "rum:PutRumEvents"
#       ]
#       Resource = aws_rum_app_monitor.production.arn
#     }]
#   })
# }
#
# # Attach role to Cognito Identity Pool
# resource "aws_cognito_identity_pool_roles_attachment" "rum" {
#   identity_pool_id = aws_cognito_identity_pool.rum.id
#
#   roles = {
#     unauthenticated = aws_iam_role.rum_guest.arn
#   }
# }
#
# # CloudWatch Log Group for extended retention
# resource "aws_cloudwatch_log_group" "rum" {
#   name              = "/aws/rum/${aws_rum_app_monitor.production.name}"
#   retention_in_days = 90
#
#   tags = {
#     Application = "web-frontend"
#     ManagedBy   = "terraform"
#   }
# }

################################################################################
# Outputs
################################################################################

# Output the app monitor ID for use in client-side code snippet
# This ID is required in the JavaScript/HTML integration code
output "app_monitor_id" {
  description = "Unique ID of the RUM app monitor for client integration"
  value       = aws_rum_app_monitor.example.app_monitor_id
}

# Output the ARN for IAM policies and cross-region references
output "app_monitor_arn" {
  description = "ARN of the RUM app monitor"
  value       = aws_rum_app_monitor.example.arn
}

# Output the CloudWatch Logs group name if enabled
output "cw_log_group" {
  description = "CloudWatch Logs group name for extended RUM data retention"
  value       = aws_rum_app_monitor.example.cw_log_group
}

################################################################################
# Additional Resources and References
################################################################################

# Official Documentation:
# - AWS CloudWatch RUM Overview:
#   https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch-RUM.html
# - Creating App Monitor:
#   https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch-RUM-get-started-create-app-monitor.html
# - API Reference:
#   https://docs.aws.amazon.com/cloudwatchrum/latest/APIReference/API_CreateAppMonitor.html
# - Terraform Provider Documentation:
#   https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/rum_app_monitor
#
# Related Services:
# - AWS X-Ray: Distributed tracing integration
# - Amazon CloudWatch Logs: Extended telemetry storage
# - Amazon Cognito: Identity pool for authentication
# - Application Signals: Unified observability platform
#
# Open Source RUM Clients:
# - Web Client: https://github.com/aws-observability/aws-rum-web
# - Android Client: https://github.com/aws-observability/aws-rum-android
# - iOS Client: https://github.com/aws-observability/aws-rum-ios
#
# Pricing Information:
# - CloudWatch RUM Pricing:
#   https://aws.amazon.com/cloudwatch/pricing/
