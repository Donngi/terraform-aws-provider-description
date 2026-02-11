/**
 * # aws_pinpoint_sms_channel
 *
 * Terraform Resource: aws_pinpoint_sms_channel
 * Provider Version: 6.28.0
 *
 * ## Overview
 *
 * Manages the SMS channel configuration for an Amazon Pinpoint application. The SMS channel
 * enables your application to send text messages (SMS) to customers' mobile devices. Amazon
 * Pinpoint supports SMS messaging to over 200 countries and regions.
 *
 * ## Key Concepts
 *
 * ### SMS Channel
 * The SMS channel represents the status and settings for SMS messaging within a Pinpoint
 * application. When enabled, it allows you to send both promotional and transactional
 * messages to your audience.
 *
 * ### Message Types
 * - **Promotional Messages**: Marketing messages, bulk communications
 * - **Transactional Messages**: Critical messages like OTPs, notifications, alerts
 *
 * ### Rate Limits
 * AWS provides separate rate limits for promotional and transactional messages:
 * - `promotional_messages_per_second`: Maximum sending rate for promotional content
 * - `transactional_messages_per_second`: Maximum sending rate for transactional content
 *
 * ### Sender Identification
 * - **Sender ID**: An alphanumeric identifier shown to recipients (supported in certain countries)
 * - **Short Code**: A dedicated short number for high-volume messaging (requires registration)
 *
 * ## Important Notes
 *
 * 1. **SMS Sandbox**: New accounts start in an SMS sandbox with limited monthly spending and
 *    recipient restrictions. Contact AWS Support to move to production.
 *
 * 2. **Regional Support**: Sender IDs and short codes availability varies by country. Some
 *    regions require pre-registration.
 *
 * 3. **Account-Level Impact**: SMS channel settings affect other AWS services that send SMS
 *    messages, such as Amazon SNS.
 *
 * 4. **Dedicated Numbers**: For dedicated origination numbers or specific sender IDs, you may
 *    need to contact AWS Support.
 *
 * 5. **End of Support Notice**: Amazon Pinpoint will end support on October 30, 2026, but
 *    SMS-related APIs will continue to be supported through AWS End User Messaging.
 *
 * ## Use Cases
 *
 * - Marketing campaigns and promotional messaging
 * - Transactional notifications (order confirmations, delivery updates)
 * - One-time passwords (OTP) and multi-factor authentication
 * - Customer engagement and retention campaigns
 * - Two-way SMS communication (requires dedicated short/long code)
 *
 * ## Related AWS Services
 *
 * - **Amazon Pinpoint**: Parent service for customer engagement
 * - **AWS End User Messaging SMS**: New service for SMS capabilities
 * - **Amazon SNS**: Also uses SMS channel settings from the same account
 *
 * ## Terraform Meta-Arguments Support
 *
 * - `depends_on`: Supported
 * - `count`: Supported
 * - `for_each`: Supported
 * - `provider`: Supported
 * - `lifecycle`: Supported
 *
 * ## References
 *
 * - AWS Documentation: https://docs.aws.amazon.com/pinpoint/latest/userguide/channels-sms.html
 * - API Reference: https://docs.aws.amazon.com/pinpoint/latest/apireference/apps-application-id-channels-sms.html
 * - Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/pinpoint_sms_channel
 */

# ============================================================================
# Basic Configuration
# ============================================================================

resource "aws_pinpoint_sms_channel" "basic" {
  # Required: The Pinpoint application ID to enable SMS channel for
  # The application must be created before enabling the SMS channel
  application_id = aws_pinpoint_app.example.application_id
}

# ============================================================================
# Complete Configuration with All Options
# ============================================================================

resource "aws_pinpoint_sms_channel" "complete" {
  # Required: Pinpoint application identifier
  # Links this SMS channel to a specific Pinpoint application
  # Type: string
  # Must be a valid Pinpoint application ID
  application_id = aws_pinpoint_app.example.application_id

  # Optional: Enable or disable the SMS channel
  # Type: bool
  # Default: true
  # When false, the SMS channel is disabled but configuration is retained
  enabled = true

  # Optional: Alphanumeric sender identifier
  # Type: string
  # Displayed to recipients as the sender name (if supported in recipient's country)
  # Requirements:
  # - Alphanumeric characters only
  # - Not supported in all countries (e.g., not supported in USA)
  # - May require pre-registration in some countries
  # - Maximum 11 characters
  # Example: "MyCompany"
  sender_id = "MyBrand"

  # Optional: Dedicated short code for SMS messaging
  # Type: string
  # A short numeric code (typically 5-6 digits) for high-volume messaging
  # Requirements:
  # - Must be obtained through AWS Support
  # - Requires approval and can take several weeks
  # - Used for high-throughput messaging
  # - More expensive but provides better deliverability
  # Example: "12345"
  short_code = "123456"

  # Optional: AWS Region for resource management
  # Type: string
  # Default: Provider region
  # Specifies where this SMS channel resource will be managed
  # Note: This is the management region, not necessarily where messages are sent from
  region = "us-east-1"

  # Computed: Maximum promotional messages per second
  # Type: number (read-only)
  # This value is computed by AWS based on account limits and configuration
  # Use for monitoring and planning campaign send rates
  # promotional_messages_per_second = <computed>

  # Computed: Maximum transactional messages per second
  # Type: number (read-only)
  # This value is computed by AWS based on account limits and configuration
  # Transactional messages typically have higher rate limits than promotional
  # transactional_messages_per_second = <computed>
}

# ============================================================================
# Disabled SMS Channel
# ============================================================================

resource "aws_pinpoint_sms_channel" "disabled" {
  application_id = aws_pinpoint_app.example.application_id

  # Disable the SMS channel while preserving configuration
  # Useful for temporary suspension or cost control
  enabled = false
}

# ============================================================================
# SMS Channel with Sender ID (for supported regions)
# ============================================================================

resource "aws_pinpoint_sms_channel" "with_sender_id" {
  application_id = aws_pinpoint_app.example.application_id
  enabled        = true

  # Sender ID for countries that support it
  # Check AWS documentation for country-specific support
  # Common supported countries: UK, India, Singapore (with pre-registration)
  sender_id = "ACME_INC"
}

# ============================================================================
# SMS Channel with Short Code (high-volume messaging)
# ============================================================================

resource "aws_pinpoint_sms_channel" "with_short_code" {
  application_id = aws_pinpoint_app.example.application_id
  enabled        = true

  # Dedicated short code obtained from AWS Support
  # Provides higher throughput and better deliverability
  # Required for two-way SMS in most cases
  short_code = "567890"
}

# ============================================================================
# SMS Channel with Lifecycle Management
# ============================================================================

resource "aws_pinpoint_sms_channel" "with_lifecycle" {
  application_id = aws_pinpoint_app.example.application_id
  enabled        = true
  sender_id      = "MyApp"

  lifecycle {
    # Prevent accidental deletion of SMS channel
    prevent_destroy = true

    # Ignore changes to enabled status if modified outside Terraform
    ignore_changes = [enabled]
  }
}

# ============================================================================
# Multi-Region SMS Channel Configuration
# ============================================================================

resource "aws_pinpoint_sms_channel" "multi_region" {
  application_id = aws_pinpoint_app.regional.application_id
  enabled        = true

  # Explicit region specification
  # Useful for multi-region Pinpoint deployments
  region = var.aws_region

  # Use region-specific sender ID if applicable
  sender_id = lookup(var.sender_ids_by_region, var.aws_region, null)
}

# ============================================================================
# Conditional SMS Channel (using count)
# ============================================================================

resource "aws_pinpoint_sms_channel" "conditional" {
  count = var.enable_sms_channel ? 1 : 0

  application_id = aws_pinpoint_app.example.application_id
  enabled        = true
  sender_id      = var.sms_sender_id
}

# ============================================================================
# Multiple SMS Channels for Different Applications (using for_each)
# ============================================================================

resource "aws_pinpoint_sms_channel" "multiple" {
  for_each = var.pinpoint_applications

  application_id = aws_pinpoint_app.apps[each.key].application_id
  enabled        = each.value.sms_enabled
  sender_id      = each.value.sender_id
  short_code     = each.value.short_code
}

# ============================================================================
# Output Values
# ============================================================================

output "sms_channel_id" {
  description = "The ID of the SMS channel (same as application_id)"
  value       = aws_pinpoint_sms_channel.complete.id
}

output "promotional_rate_limit" {
  description = "Maximum promotional messages per second"
  value       = aws_pinpoint_sms_channel.complete.promotional_messages_per_second
}

output "transactional_rate_limit" {
  description = "Maximum transactional messages per second"
  value       = aws_pinpoint_sms_channel.complete.transactional_messages_per_second
}

# ============================================================================
# Supporting Resources
# ============================================================================

# Pinpoint application (required for SMS channel)
resource "aws_pinpoint_app" "example" {
  name = "example-app"

  # Optional: Campaign hook configuration
  # campaign_hook {
  #   lambda_function_name = aws_lambda_function.pinpoint_processor.arn
  #   mode                 = "FILTER"
  # }

  # Optional: Application limits
  # limits {
  #   daily               = 100000
  #   maximum_duration    = 600
  #   messages_per_second = 1000
  #   total               = 1000000
  # }

  tags = {
    Name        = "example-pinpoint-app"
    Environment = "production"
  }
}

# ============================================================================
# Variable Definitions (for reference)
# ============================================================================

variable "aws_region" {
  description = "AWS region for Pinpoint resources"
  type        = string
  default     = "us-east-1"
}

variable "enable_sms_channel" {
  description = "Whether to enable SMS channel"
  type        = bool
  default     = true
}

variable "sms_sender_id" {
  description = "Sender ID for SMS messages"
  type        = string
  default     = null
}

variable "sender_ids_by_region" {
  description = "Map of sender IDs by region"
  type        = map(string)
  default = {
    "eu-west-1"  = "EUSender"
    "ap-south-1" = "INSender"
    "eu-west-2"  = "UKSender"
  }
}

variable "pinpoint_applications" {
  description = "Map of Pinpoint applications with SMS configuration"
  type = map(object({
    sms_enabled = bool
    sender_id   = string
    short_code  = string
  }))
  default = {
    "app1" = {
      sms_enabled = true
      sender_id   = "App1Brand"
      short_code  = null
    }
    "app2" = {
      sms_enabled = true
      sender_id   = "App2Brand"
      short_code  = "123456"
    }
  }
}

# ============================================================================
# Additional Notes
# ============================================================================

# Attribute Reference:
# - id: The ID of the SMS channel (same as application_id)
# - promotional_messages_per_second: Max promotional message rate (computed)
# - transactional_messages_per_second: Max transactional message rate (computed)
# - region: AWS region for resource management
#
# Import:
# SMS channels can be imported using the application_id:
# $ terraform import aws_pinpoint_sms_channel.example app-12345678
#
# Common Error Messages:
# - "Invalid sender ID": Sender ID not supported in target country or invalid format
# - "Short code not found": Short code not registered or not available in region
# - "SMS channel already enabled": Channel already exists for the application
# - "Application not found": The specified application_id doesn't exist
#
# Best Practices:
# 1. Enable SMS channel only when needed to control costs
# 2. Use sender IDs in supported countries for better brand recognition
# 3. Request short codes well in advance (can take weeks for approval)
# 4. Monitor rate limits using computed attributes
# 5. Use lifecycle rules to prevent accidental deletion
# 6. Test in SMS sandbox before requesting production access
# 7. Consider regional variations in SMS support and pricing
# 8. Use transactional message type for time-sensitive communications
# 9. Implement proper error handling for SMS delivery failures
# 10. Set up CloudWatch alarms for spending and delivery metrics
#
# Cost Considerations:
# - SMS pricing varies by destination country
# - Short codes have monthly fees plus per-message charges
# - Sender IDs may require registration fees in some countries
# - Promotional messages are typically cheaper than transactional
# - Two-way SMS requires dedicated short/long codes (additional cost)
#
# Security Considerations:
# - Use IAM policies to control who can modify SMS channel settings
# - Enable CloudTrail logging for SMS channel configuration changes
# - Implement spending limits to prevent unexpected costs
# - Validate recipient phone numbers before sending
# - Use encryption for sensitive message content
# - Comply with local telecommunications regulations and opt-out requirements
