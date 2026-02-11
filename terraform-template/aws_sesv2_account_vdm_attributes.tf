################################################################################
# AWS SESv2 Account VDM Attributes
################################################################################
# Terraform resource for managing Amazon SES (Simple Email Service) v2 Account
# Virtual Deliverability Manager (VDM) attributes at the account level.
#
# VDM provides two main features:
# 1. Dashboard (Engagement Metrics): Tracks email engagement metrics like opens,
#    clicks, and complaints to help monitor email performance
# 2. Guardian (Optimized Shared Delivery): Uses ML to optimize email delivery
#    through Amazon's shared IP pools for better deliverability
#
# Use Cases:
# - Enable engagement tracking to monitor email campaign performance
# - Optimize deliverability for emails sent through shared IP pools
# - Meet compliance requirements for email analytics
# - Improve sender reputation through delivery optimization
#
# Provider Version: 6.28.0
# Terraform Documentation: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sesv2_account_vdm_attributes
# AWS API Documentation: https://docs.aws.amazon.com/ses/latest/APIReference-V2/API_VdmAttributes.html
################################################################################

resource "aws_sesv2_account_vdm_attributes" "example" {
  ################################################################################
  # Required Arguments
  ################################################################################

  # (Required) Specifies the status of your VDM configuration
  # Valid values: "ENABLED", "DISABLED"
  #
  # When ENABLED:
  # - Activates VDM features for the entire SES account
  # - Allows engagement metrics collection and optimized delivery
  # - Settings can be further customized via dashboard_attributes and guardian_attributes
  #
  # When DISABLED:
  # - Turns off all VDM features
  # - No engagement metrics will be collected
  # - Optimized shared delivery will not be used
  #
  # Important: This is an account-level setting that affects all email sending
  # operations unless overridden at the configuration set level
  vdm_enabled = "ENABLED"

  ################################################################################
  # Optional Arguments
  ################################################################################

  # (Optional) AWS Region where this resource will be managed
  # Type: string
  # Computed: true (if not specified, uses provider's default region)
  #
  # Use this when you need to manage VDM settings in a specific region different
  # from your provider's default region. VDM settings are region-specific.
  #
  # Example scenarios:
  # - Multi-region SES setup with different VDM configs per region
  # - Centralizing VDM management in a specific region
  # region = "us-east-1"

  ################################################################################
  # Dashboard Attributes Block
  ################################################################################
  # (Optional) Configures settings for VDM Dashboard features
  # Max items: 1
  # Nesting mode: list
  #
  # The Dashboard provides engagement metrics to help you understand how
  # recipients interact with your emails (opens, clicks, bounces, complaints).
  # This data is available in the SES console and via CloudWatch metrics.
  dashboard_attributes {
    # (Optional) Specifies the status of engagement metrics collection
    # Valid values: "ENABLED", "DISABLED"
    #
    # When ENABLED:
    # - Collects metrics on email opens, clicks, bounces, and complaints
    # - Data is available in SES console dashboard
    # - Metrics can be viewed in CloudWatch
    # - Helps measure email campaign effectiveness
    #
    # When DISABLED:
    # - No engagement metrics are collected
    # - Dashboard features are not available
    #
    # Note: This does not affect event destination configurations (SNS, Kinesis, etc.)
    # Those continue to work independently of VDM settings.
    engagement_metrics = "ENABLED"
  }

  ################################################################################
  # Guardian Attributes Block
  ################################################################################
  # (Optional) Configures settings for VDM Guardian features
  # Max items: 1
  # Nesting mode: list
  #
  # Guardian uses machine learning to optimize email delivery through Amazon's
  # shared IP pools, improving deliverability and sender reputation.
  guardian_attributes {
    # (Optional) Specifies the status of optimized shared delivery
    # Valid values: "ENABLED", "DISABLED"
    #
    # When ENABLED:
    # - Uses ML algorithms to optimize email sending through shared IP pools
    # - Automatically adjusts sending patterns based on recipient engagement
    # - Helps maintain good sender reputation
    # - Improves overall deliverability rates
    #
    # When DISABLED:
    # - Standard shared IP pool delivery is used
    # - No ML-based optimization is applied
    #
    # Best Practice: Enable this for better deliverability when using shared IPs.
    # Not applicable if you're using dedicated IPs.
    optimized_shared_delivery = "ENABLED"
  }

  ################################################################################
  # Computed Attributes (Read-Only)
  ################################################################################
  # These attributes are automatically set by AWS and cannot be configured:
  #
  # id - The AWS region where VDM settings are configured (e.g., "us-east-1")
  #      Can also be imported using this region identifier
  ################################################################################
}

################################################################################
# Import Example
################################################################################
# VDM attributes can be imported using the AWS region:
# terraform import aws_sesv2_account_vdm_attributes.example us-east-1

################################################################################
# Additional Configuration Examples
################################################################################

# Example 1: Minimal configuration with VDM disabled
resource "aws_sesv2_account_vdm_attributes" "minimal" {
  vdm_enabled = "DISABLED"
}

# Example 2: Enable only engagement metrics (Dashboard)
resource "aws_sesv2_account_vdm_attributes" "dashboard_only" {
  vdm_enabled = "ENABLED"

  dashboard_attributes {
    engagement_metrics = "ENABLED"
  }

  # Explicitly disable Guardian features
  guardian_attributes {
    optimized_shared_delivery = "DISABLED"
  }
}

# Example 3: Enable only optimized delivery (Guardian)
resource "aws_sesv2_account_vdm_attributes" "guardian_only" {
  vdm_enabled = "ENABLED"

  dashboard_attributes {
    engagement_metrics = "DISABLED"
  }

  guardian_attributes {
    optimized_shared_delivery = "ENABLED"
  }
}

# Example 4: Multi-region VDM configuration
resource "aws_sesv2_account_vdm_attributes" "us_east" {
  region      = "us-east-1"
  vdm_enabled = "ENABLED"

  dashboard_attributes {
    engagement_metrics = "ENABLED"
  }

  guardian_attributes {
    optimized_shared_delivery = "ENABLED"
  }
}

resource "aws_sesv2_account_vdm_attributes" "eu_west" {
  region      = "eu-west-1"
  vdm_enabled = "ENABLED"

  dashboard_attributes {
    engagement_metrics = "ENABLED"
  }

  guardian_attributes {
    optimized_shared_delivery = "ENABLED"
  }
}

################################################################################
# Best Practices & Important Notes
################################################################################
# 1. Account-Level vs Configuration Set-Level:
#    - This resource manages account-level VDM settings
#    - Individual configuration sets can override these settings using
#      aws_sesv2_configuration_set_vdm_options resource
#
# 2. Engagement Metrics vs Event Destinations:
#    - Engagement metrics (VDM Dashboard) are separate from event destinations
#    - You can have both enabled simultaneously
#    - Event destinations (SNS, Kinesis, CloudWatch Logs) continue to work
#      independently of VDM settings
#
# 3. Optimized Shared Delivery:
#    - Only applies when using Amazon SES shared IP pools
#    - Not relevant if you're using dedicated IP addresses
#    - Helps improve deliverability through ML-based optimization
#
# 4. Region Considerations:
#    - VDM settings are region-specific
#    - If you send emails from multiple regions, configure VDM in each region
#    - Use the 'region' parameter to manage VDM settings in different regions
#
# 5. Rate Limits:
#    - PutAccountVdmAttributes API can only be called once per second
#    - Terraform will handle this automatically, but be aware during imports/updates
#
# 6. Monitoring:
#    - When engagement_metrics is enabled, data appears in:
#      - SES Console Dashboard
#      - CloudWatch Metrics under AWS/SES namespace
#    - Set up CloudWatch alarms for important metrics (bounce rate, complaint rate)
#
# 7. Cost Considerations:
#    - VDM features are included at no additional cost
#    - Standard SES pricing applies for email sending
#    - CloudWatch metrics may incur standard CloudWatch costs
#
# 8. Data Privacy:
#    - Engagement metrics track recipient interactions
#    - Ensure compliance with privacy regulations (GDPR, CCPA, etc.)
#    - Document data collection in your privacy policy
################################################################################
