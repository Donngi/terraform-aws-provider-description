################################################################################
# AWS SESv2 Email Identity
# https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/sesv2_email_identity
#
# Terraform resource for managing an AWS SESv2 (Simple Email V2) Email Identity.
# This resource allows you to verify email addresses or domains for sending emails
# through Amazon SES. It supports both Email Address Identity and Domain Identity,
# with optional DKIM configuration (Easy DKIM or Bring Your Own DKIM).
################################################################################

resource "aws_sesv2_email_identity" "example" {
  ################################################################################
  # Required Arguments
  ################################################################################

  # (Required) The email address or domain to verify
  # - For email identity: "user@example.com"
  # - For domain identity: "example.com"
  # Type: string
  email_identity = "example.com"

  ################################################################################
  # Optional Arguments
  ################################################################################

  # (Optional) Region where this resource will be managed
  # Defaults to the Region set in the provider configuration
  # See: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # Type: string
  # region = "us-east-1"

  # (Optional) The configuration set to use by default when sending from this identity
  # Note: Any configuration set defined in the email sending request takes precedence
  # Type: string
  # configuration_set_name = aws_sesv2_configuration_set.example.configuration_set_name

  # (Optional) Key-value mapping of resource tags
  # If configured with a provider default_tags configuration block, tags with
  # matching keys will overwrite those defined at the provider-level
  # Type: map(string)
  # tags = {
  #   Environment = "production"
  #   Application = "email-service"
  # }

  ################################################################################
  # DKIM Signing Attributes Block (Optional, max_items: 1)
  ################################################################################
  # The configuration of the DKIM authentication settings for an email domain identity
  # Supports both Easy DKIM (AWS-managed) and Bring Your Own DKIM (BYODKIM)

  # dkim_signing_attributes {
  #   ################################################################################
  #   # Bring Your Own DKIM (BYODKIM) - Optional
  #   ################################################################################
  #
  #   # (Optional, Sensitive) A private key used to generate a DKIM signature
  #   # - Must use 1024 or 2048-bit RSA encryption
  #   # - Must be encoded using base64 encoding
  #   # - Remove the first and last lines ('-----BEGIN PRIVATE KEY-----' and '-----END PRIVATE KEY-----')
  #   # - Remove all line breaks from the generated private key
  #   # - Result should be a string of characters with no spaces or line breaks
  #   # Type: string (sensitive)
  #   # domain_signing_private_key = "MIIJKAIBAAKCAgEA2Se7p8zvnI4yh+Gh9j2rG5e2aRXjg03Y8saiupLnadPH9xvM..."
  #
  #   # (Optional) A string used to identify a public key in the DNS configuration
  #   # Type: string
  #   # domain_signing_selector = "example"
  #
  #   ################################################################################
  #   # Easy DKIM - Optional
  #   ################################################################################
  #
  #   # (Optional) The key length of the future DKIM key pair to be generated
  #   # - Can be changed at most once per day
  #   # - Valid values: RSA_1024_BIT, RSA_2048_BIT
  #   # Type: string
  #   # next_signing_key_length = "RSA_2048_BIT"
  #
  #   ################################################################################
  #   # Computed Attributes (Read-only)
  #   ################################################################################
  #   # - current_signing_key_length: [Easy DKIM] The key length of the DKIM key pair in use
  #   # - last_key_generation_timestamp: [Easy DKIM] Last time a key pair was generated
  #   # - signing_attributes_origin: Indicates how DKIM was configured
  #   #   * AWS_SES: Easy DKIM
  #   #   * EXTERNAL: Bring Your Own DKIM (BYODKIM)
  #   # - status: Whether Amazon SES has located the DKIM records in DNS
  #   #   See: https://docs.aws.amazon.com/ses/latest/APIReference-V2/API_DkimAttributes.html#SES-Type-DkimAttributes-Status
  #   # - tokens: CNAME records for Easy DKIM or selector for BYODKIM
  # }
}

################################################################################
# Computed Attributes (Outputs)
################################################################################
# These attributes are computed after the resource is created and can be
# referenced using: aws_sesv2_email_identity.example.<attribute_name>

# arn - ARN of the Email Identity
# Type: string
# Example: aws_sesv2_email_identity.example.arn

# identity_type - The email identity type
# Type: string
# Valid values: EMAIL_ADDRESS, DOMAIN
# Example: aws_sesv2_email_identity.example.identity_type

# verification_status - The verification status of the identity
# Type: string
# Valid values: PENDING, SUCCESS, FAILED, TEMPORARY_FAILURE, NOT_STARTED
# Example: aws_sesv2_email_identity.example.verification_status

# verified_for_sending_status - Specifies whether the identity is verified
# Type: bool
# Example: aws_sesv2_email_identity.example.verified_for_sending_status

# tags_all - Map of tags assigned to the resource, including provider default_tags
# Type: map(string)
# Example: aws_sesv2_email_identity.example.tags_all

# dkim_signing_attributes - List of DKIM configuration objects (max 1 element)
# Example: aws_sesv2_email_identity.example.dkim_signing_attributes[0].status

################################################################################
# Example Usage Scenarios
################################################################################

# Example 1: Email Address Identity
# ----------------------------------
# resource "aws_sesv2_email_identity" "email" {
#   email_identity = "testing@example.com"
# }

# Example 2: Domain Identity
# ----------------------------------
# resource "aws_sesv2_email_identity" "domain" {
#   email_identity = "example.com"
# }

# Example 3: Domain Identity with Configuration Set
# --------------------------------------------------
# resource "aws_sesv2_configuration_set" "example" {
#   configuration_set_name = "example"
# }
#
# resource "aws_sesv2_email_identity" "domain_with_config" {
#   email_identity         = "example.com"
#   configuration_set_name = aws_sesv2_configuration_set.example.configuration_set_name
# }

# Example 4: Domain Identity with BYODKIM
# ----------------------------------------
# resource "aws_sesv2_email_identity" "byodkim" {
#   email_identity = "example.com"
#
#   dkim_signing_attributes {
#     domain_signing_private_key = "MIIJKAIBAAKCAgEA2Se7p8zvnI4yh+Gh9j2rG5e2aRXjg03Y8saiupLnadPH9xvM..."
#     domain_signing_selector    = "example"
#   }
# }

# Example 5: Domain Identity with Easy DKIM (RSA 2048-bit)
# ---------------------------------------------------------
# resource "aws_sesv2_email_identity" "easy_dkim" {
#   email_identity = "example.com"
#
#   dkim_signing_attributes {
#     next_signing_key_length = "RSA_2048_BIT"
#   }
# }

################################################################################
# Important Notes
################################################################################
# 1. Email Address vs Domain Identity:
#    - Email Address: Verifies a specific email address (e.g., "user@example.com")
#    - Domain: Verifies an entire domain (e.g., "example.com")
#
# 2. DKIM Configuration:
#    - Easy DKIM: AWS manages the DKIM keys automatically
#    - BYODKIM: You provide your own private key and selector
#    - Cannot use both Easy DKIM and BYODKIM simultaneously
#
# 3. Verification Process:
#    - Email addresses: Click verification link sent to the email
#    - Domains: Add DNS records (TXT or CNAME) to domain configuration
#    - Check verification_status attribute to monitor progress
#
# 4. DKIM Private Key Format (BYODKIM):
#    - Remove header lines (-----BEGIN PRIVATE KEY----- and -----END PRIVATE KEY-----)
#    - Remove all line breaks
#    - Result should be continuous string of characters
#
# 5. Region Management:
#    - Email identities are region-specific
#    - Use the region argument to specify a different region
#    - Defaults to provider's configured region
#
# 6. Configuration Sets:
#    - Optional but recommended for tracking and organizing email sending
#    - Per-request configuration sets override the default
#
# 7. Tags:
#    - Supports standard AWS tagging
#    - Inherits provider-level default_tags
#    - Resource-level tags override provider-level tags
#
# 8. Key Length Changes (Easy DKIM):
#    - next_signing_key_length can be changed at most once per day
#    - Use RSA_2048_BIT for enhanced security (recommended)
