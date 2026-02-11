# ============================================================
# AWS SESv2 Email Identity Feedback Attributes
# ============================================================
# Terraform resource for managing an AWS SESv2 (Simple Email V2)
# Email Identity Feedback Attributes.
#
# This resource configures feedback forwarding settings for SES email identities,
# allowing you to control whether bounce and complaint notifications are
# forwarded to the email address associated with the identity.
#
# Provider Version: 6.28.0
# Resource Version: 0
# Documentation: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sesv2_email_identity_feedback_attributes
# ============================================================

resource "aws_sesv2_email_identity_feedback_attributes" "example" {
  # ============================================================
  # Required Arguments
  # ============================================================

  # email_identity - (Required) The email identity.
  # Type: string
  #
  # The email address or domain for which you want to configure feedback
  # attributes. This should match an existing SES email identity.
  #
  # Examples:
  # - "example.com" (domain identity)
  # - "user@example.com" (email address identity)
  email_identity = aws_sesv2_email_identity.example.email_identity

  # ============================================================
  # Optional Arguments
  # ============================================================

  # email_forwarding_enabled - (Optional) Sets the feedback forwarding configuration for the identity.
  # Type: bool
  # Default: (computed by AWS, typically true)
  #
  # When enabled, Amazon SES forwards bounce and complaint notifications to the
  # email address associated with the identity. This is useful for monitoring
  # email deliverability issues.
  #
  # Setting this to false means bounce and complaint notifications will only be
  # published to SNS topics (if configured) or available through the SES API,
  # but will not be emailed to the identity owner.
  #
  # Examples:
  # - true  (forward notifications to identity email)
  # - false (do not forward, rely on SNS or API)
  email_forwarding_enabled = true

  # region - (Optional) Region where this resource will be managed.
  # Type: string
  # Default: (computed from provider configuration)
  #
  # Specifies the AWS region where this resource will be created.
  # If not specified, it defaults to the region set in the provider configuration.
  #
  # Reference: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  #
  # Examples:
  # - "us-east-1"
  # - "us-west-2"
  # - "eu-west-1"
  # region = "us-east-1"

  # ============================================================
  # Computed Attributes (Read-Only)
  # ============================================================

  # id - (Computed) The resource identifier.
  # Type: string
  #
  # Automatically generated identifier for this resource, typically matching
  # the email_identity value.
}

# ============================================================
# Example: Basic Usage
# ============================================================
# This example shows how to configure feedback attributes for a domain identity.

# First, create an email identity
resource "aws_sesv2_email_identity" "example" {
  email_identity = "example.com"
}

# Then configure feedback attributes for that identity
resource "aws_sesv2_email_identity_feedback_attributes" "example_basic" {
  email_identity           = aws_sesv2_email_identity.example.email_identity
  email_forwarding_enabled = true
}

# ============================================================
# Example: Disable Email Forwarding
# ============================================================
# If you want to disable email forwarding and rely on SNS notifications or API,
# set email_forwarding_enabled to false.

resource "aws_sesv2_email_identity" "no_forwarding" {
  email_identity = "noreply@example.com"
}

resource "aws_sesv2_email_identity_feedback_attributes" "no_forwarding" {
  email_identity           = aws_sesv2_email_identity.no_forwarding.email_identity
  email_forwarding_enabled = false
}

# ============================================================
# Example: With Specific Region
# ============================================================
# Explicitly specify the region for this resource.

resource "aws_sesv2_email_identity" "regional" {
  email_identity = "regional@example.com"
}

resource "aws_sesv2_email_identity_feedback_attributes" "regional" {
  email_identity           = aws_sesv2_email_identity.regional.email_identity
  email_forwarding_enabled = true
  region                   = "us-west-2"
}

# ============================================================
# Best Practices
# ============================================================
#
# 1. Email Forwarding:
#    - Enable email forwarding for production environments to ensure you receive
#      immediate notifications about bounces and complaints
#    - Consider disabling for test environments to reduce noise
#
# 2. SNS Integration:
#    - For programmatic processing of feedback, configure SNS topics using
#      aws_sesv2_configuration_set with event destinations
#    - You can disable email forwarding if you have robust SNS-based monitoring
#
# 3. Compliance:
#    - Monitor bounce and complaint rates to maintain good sender reputation
#    - AWS may suspend your SES sending if bounce/complaint rates are too high
#
# 4. Identity Management:
#    - Always create the email identity before configuring feedback attributes
#    - Use depends_on if needed to ensure proper resource creation order
#
# 5. Testing:
#    - Use SES mailbox simulator addresses for testing:
#      - success@simulator.amazonses.com (successful delivery)
#      - bounce@simulator.amazonses.com (hard bounce)
#      - complaint@simulator.amazonses.com (complaint)
#
# ============================================================
# Related Resources
# ============================================================
#
# - aws_sesv2_email_identity: Create and manage SES email identities
# - aws_sesv2_configuration_set: Configure settings for SES sending
# - aws_sesv2_email_identity_mail_from_attributes: Configure MAIL FROM domain
# - aws_ses_domain_identity: SES v1 domain identity (legacy)
# - aws_ses_identity_notification_topic: Configure SNS topics for feedback
#
# ============================================================
# Important Notes
# ============================================================
#
# 1. This resource requires an existing email identity (domain or email address)
#    to be configured first using aws_sesv2_email_identity
#
# 2. Email forwarding is separate from SNS notifications - you can have both,
#    one, or neither depending on your monitoring needs
#
# 3. When email forwarding is enabled, notifications are sent to:
#    - The "Return-Path" address if configured
#    - The "From" address if no Return-Path is set
#
# 4. Feedback attributes apply to all emails sent using this identity
#
# 5. Changes to feedback attributes take effect immediately
#
# ============================================================
