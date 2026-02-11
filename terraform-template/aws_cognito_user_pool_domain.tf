################################################################################
# AWS Cognito User Pool Domain - Annotated Template
################################################################################
# Generated: 2026-01-19
# Provider Version: 6.28.0
#
# Note: This template is generated based on the AWS Provider schema at the time
# of creation. Always refer to the official Terraform AWS Provider documentation
# for the latest specifications and best practices.
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool_domain
################################################################################

resource "aws_cognito_user_pool_domain" "example" {
  # ============================================================================
  # Required Arguments
  # ============================================================================

  # (Required) For custom domains, this is the fully-qualified domain name,
  # such as auth.example.com. For Amazon Cognito prefix domains, this is the
  # prefix alone, such as auth.
  #
  # - Custom domain: Use a fully-qualified domain name that you own (e.g., "auth.example.com")
  # - Prefix domain: Use a unique prefix (e.g., "my-app") which will result in
  #   a domain like "my-app.auth.us-east-1.amazoncognito.com"
  #
  # Reference:
  # - Custom domains: https://docs.aws.amazon.com/cognito/latest/developerguide/cognito-user-pools-add-custom-domain.html
  # - Prefix domains: https://docs.aws.amazon.com/cognito/latest/developerguide/cognito-user-pools-assign-domain-prefix.html
  domain = "example-domain"

  # (Required) The user pool ID.
  # This must be the ID of an existing Cognito User Pool.
  user_pool_id = aws_cognito_user_pool.example.id

  # ============================================================================
  # Optional Arguments
  # ============================================================================

  # (Optional) The ARN of an ISSUED ACM certificate in us-east-1 for a custom domain.
  #
  # Important notes:
  # - Required when using a custom domain (fully-qualified domain name)
  # - The certificate MUST be in the US East (N. Virginia) region (us-east-1)
  # - The certificate MUST be in ISSUED status
  # - Not used for Amazon Cognito prefix domains
  # - Amazon Cognito uses this certificate to configure the CloudFront distribution
  #   that serves your managed login pages
  #
  # Example: "arn:aws:acm:us-east-1:123456789012:certificate/12345678-1234-1234-1234-123456789012"
  #
  # Reference: https://docs.aws.amazon.com/cognito/latest/developerguide/cognito-user-pools-add-custom-domain.html
  certificate_arn = null

  # (Optional) A version number that indicates the state of managed login for your domain.
  #
  # Valid values:
  # - 1: Hosted UI (classic) - The original hosted UI experience
  # - 2: Managed login - The newer managed login with the branding designer
  #
  # Notes:
  # - Managed login (version 2) requires the user pool to be configured for any
  #   feature plan other than Lite
  # - Changes to this value take effect within one to five minutes
  # - If not specified, defaults to the current managed login version
  #
  # Reference: https://docs.aws.amazon.com/cognito-user-identity-pools/latest/APIReference/API_CreateUserPoolDomain.html
  managed_login_version = null

  # (Optional) Region where this resource will be managed.
  #
  # - Defaults to the region set in the provider configuration
  # - Use this to explicitly specify a different region for this resource
  #
  # Reference: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  # (Optional) Terraform resource ID.
  #
  # - Can be used to explicitly set the resource identifier
  # - If not set, Terraform will auto-generate an ID
  # - Generally recommended to leave this unset and let Terraform manage it
  id = null
}

################################################################################
# Computed Attributes (Read-only, available after creation)
################################################################################
# The following attributes are computed by AWS and available after the resource
# is created. They cannot be set directly but can be referenced in other resources.
#
# - aws_account_id: The AWS account ID for the user pool owner
#
# - cloudfront_distribution: The Amazon CloudFront endpoint (e.g.,
#   "dpp0gtxikpq3y.cloudfront.net") that you use as the target of the alias
#   that you set up with your Domain Name Service (DNS) provider
#   Used for: Creating Route 53 alias records for custom domains
#
# - cloudfront_distribution_arn: The URL of the CloudFront distribution.
#   This is required to generate the ALIAS aws_route53_record
#
# - cloudfront_distribution_zone_id: The Route 53 hosted zone ID of the
#   CloudFront distribution (typically "Z2FDTNDATAQYW2")
#   Used for: Creating Route 53 alias records
#
# - s3_bucket: The S3 bucket where the static files for this domain are stored
#
# - version: The app version
################################################################################

################################################################################
# Example Usage - Amazon Cognito Prefix Domain
################################################################################
# resource "aws_cognito_user_pool_domain" "prefix_domain" {
#   domain       = "my-app-domain"
#   user_pool_id = aws_cognito_user_pool.example.id
# }
#
# resource "aws_cognito_user_pool" "example" {
#   name = "example-pool"
# }

################################################################################
# Example Usage - Custom Domain with Route 53
################################################################################
# resource "aws_cognito_user_pool_domain" "custom_domain" {
#   domain          = "auth.example.com"
#   certificate_arn = aws_acm_certificate.cert.arn
#   user_pool_id    = aws_cognito_user_pool.example.id
# }
#
# resource "aws_cognito_user_pool" "example" {
#   name = "example-pool"
# }
#
# # ACM Certificate must be in us-east-1
# resource "aws_acm_certificate" "cert" {
#   provider          = aws.us-east-1
#   domain_name       = "auth.example.com"
#   validation_method = "DNS"
# }
#
# # DNS validation for ACM certificate
# resource "aws_route53_record" "cert_validation" {
#   for_each = {
#     for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
#       name   = dvo.resource_record_name
#       record = dvo.resource_record_value
#       type   = dvo.resource_record_type
#     }
#   }
#
#   zone_id = data.aws_route53_zone.example.zone_id
#   name    = each.value.name
#   type    = each.value.type
#   records = [each.value.record]
#   ttl     = 60
# }
#
# # Route 53 alias record pointing to CloudFront distribution
# resource "aws_route53_record" "auth_cognito_a" {
#   name    = aws_cognito_user_pool_domain.custom_domain.domain
#   type    = "A"
#   zone_id = data.aws_route53_zone.example.zone_id
#
#   alias {
#     evaluate_target_health = false
#     name                   = aws_cognito_user_pool_domain.custom_domain.cloudfront_distribution
#     zone_id                = aws_cognito_user_pool_domain.custom_domain.cloudfront_distribution_zone_id
#   }
# }
#
# data "aws_route53_zone" "example" {
#   name = "example.com"
# }

################################################################################
# Additional References
################################################################################
# - Configuring a user pool domain:
#   https://docs.aws.amazon.com/cognito/latest/developerguide/cognito-user-pools-assign-domain.html
#
# - Using custom domains:
#   https://docs.aws.amazon.com/cognito/latest/developerguide/cognito-user-pools-add-custom-domain.html
#
# - Using prefix domains:
#   https://docs.aws.amazon.com/cognito/latest/developerguide/cognito-user-pools-assign-domain-prefix.html
#
# - CreateUserPoolDomain API:
#   https://docs.aws.amazon.com/cognito-user-identity-pools/latest/APIReference/API_CreateUserPoolDomain.html
#
# - UpdateUserPoolDomain API:
#   https://docs.aws.amazon.com/cognito-user-identity-pools/latest/APIReference/API_UpdateUserPoolDomain.html
################################################################################
