# ==============================================================================
# Resource: aws_ses_domain_mail_from
# ==============================================================================
# Provides an SES domain MAIL FROM resource.
#
# NOTE: For the MAIL FROM domain to be fully usable, this resource should be
# paired with the aws_ses_domain_identity resource. To validate the MAIL FROM
# domain, a DNS MX record is required. To pass SPF checks, a DNS TXT record may
# also be required. See the Amazon SES MAIL FROM documentation for more
# information: https://docs.aws.amazon.com/ses/latest/dg/mail-from.html
#
# Provider Version: 6.28.0
# Documentation: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/ses_domain_mail_from
# ==============================================================================

resource "aws_ses_domain_mail_from" "example" {
  # ==============================================================================
  # Required Arguments
  # ==============================================================================

  # domain - (Required) string
  # Verified domain name or email identity to generate DKIM tokens for.
  # This should reference an existing aws_ses_domain_identity or
  # aws_ses_email_identity resource.
  domain = aws_ses_domain_identity.example.domain

  # mail_from_domain - (Required) string
  # Subdomain (of above domain) which is to be used as MAIL FROM address.
  # This is required for DMARC validation.
  # Common practice is to use a subdomain like "bounce.example.com" or
  # "mail.example.com" where example.com is your verified domain.
  mail_from_domain = "bounce.example.com"

  # ==============================================================================
  # Optional Arguments
  # ==============================================================================

  # behavior_on_mx_failure - (Optional) string
  # The action that you want Amazon SES to take if it cannot successfully read
  # the required MX record when you send an email.
  # Valid values:
  #   - "UseDefaultValue" (default): Use amazonses.com as the MAIL FROM domain
  #   - "RejectMessage": Return a MailFromDomainNotVerified error and drop the message
  # Default: "UseDefaultValue"
  # See: https://docs.aws.amazon.com/ses/latest/APIReference/API_SetIdentityMailFromDomain.html
  # behavior_on_mx_failure = "UseDefaultValue"

  # region - (Optional) string (computed)
  # Region where this resource will be managed.
  # Defaults to the Region set in the provider configuration.
  # See: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  # ==============================================================================
  # Computed Attributes (Read-Only)
  # ==============================================================================
  # These attributes are computed by AWS and available after creation:
  #
  # id - The domain name
  # region - The AWS region (if not explicitly set)
  # ==============================================================================
}

# ==============================================================================
# Complete Example: Domain Identity MAIL FROM Setup
# ==============================================================================
# This example demonstrates a complete setup including domain identity,
# MAIL FROM configuration, and required DNS records.
# ==============================================================================

# Example SES Domain Identity
resource "aws_ses_domain_identity" "example" {
  domain = "example.com"
}

# MAIL FROM Domain Configuration
resource "aws_ses_domain_mail_from" "example_complete" {
  domain           = aws_ses_domain_identity.example.domain
  mail_from_domain = "bounce.${aws_ses_domain_identity.example.domain}"

  behavior_on_mx_failure = "UseDefaultValue"
}

# Route53 MX Record (Required for MAIL FROM validation)
# Note: Change the region to match where your SES domain identity is created
resource "aws_route53_record" "example_ses_domain_mail_from_mx" {
  zone_id = aws_route53_zone.example.id
  name    = aws_ses_domain_mail_from.example_complete.mail_from_domain
  type    = "MX"
  ttl     = "600"
  records = ["10 feedback-smtp.us-east-1.amazonses.com"]
}

# Route53 TXT Record for SPF (Recommended)
resource "aws_route53_record" "example_ses_domain_mail_from_txt" {
  zone_id = aws_route53_zone.example.id
  name    = aws_ses_domain_mail_from.example_complete.mail_from_domain
  type    = "TXT"
  ttl     = "600"
  records = ["v=spf1 include:amazonses.com ~all"]
}

# ==============================================================================
# Example: Email Identity MAIL FROM
# ==============================================================================
# This example shows how to configure MAIL FROM for an email identity
# instead of a domain identity.
# ==============================================================================

# Example SES Email Identity
resource "aws_ses_email_identity" "example" {
  email = "user@example.com"
}

resource "aws_ses_domain_mail_from" "email_identity_example" {
  domain           = aws_ses_email_identity.example.email
  mail_from_domain = "mail.example.com"
}

# ==============================================================================
# Important Notes
# ==============================================================================
# 1. DNS Requirements:
#    - MX record is required for the MAIL FROM domain to work
#    - TXT record (SPF) is recommended to pass SPF checks
#
# 2. Region Consideration:
#    - The MX record must point to the SES SMTP endpoint in the same region
#      where your SES domain identity is created
#    - Common SES SMTP endpoints:
#      * us-east-1: feedback-smtp.us-east-1.amazonses.com
#      * us-west-2: feedback-smtp.us-west-2.amazonses.com
#      * eu-west-1: feedback-smtp.eu-west-1.amazonses.com
#
# 3. Best Practices:
#    - Use a subdomain for the MAIL FROM domain (e.g., bounce.example.com)
#    - Set behavior_on_mx_failure to "RejectMessage" for production to ensure
#      proper DNS configuration
#    - Always configure SPF records to improve email deliverability
#
# 4. DMARC Compliance:
#    - The mail_from_domain is required for DMARC validation
#    - Ensure your DMARC policy is properly configured for the parent domain
# ==============================================================================
