################################################################################
# AWS IAM Roles Anywhere Trust Anchor
################################################################################
# Terraform resource for managing a Roles Anywhere Trust Anchor.
# IAM Roles Anywhere enables workloads running outside of AWS to obtain temporary
# AWS credentials by authenticating with X.509 certificates. The Trust Anchor
# establishes the root of trust for these certificates.
#
# Use Cases:
# - Enable on-premises servers to authenticate with AWS using X.509 certificates
# - Allow third-party applications to obtain temporary AWS credentials
# - Implement certificate-based authentication for hybrid cloud environments
# - Support workloads that cannot use traditional AWS credentials
#
# Limitations:
# - Must use either AWS ACM PCA or upload your own certificate bundle
# - Certificate validation and rotation must be managed separately
# - Trust Anchor cannot be modified once created (must recreate)
#
# Required IAM Permissions:
# - rolesanywhere:CreateTrustAnchor
# - rolesanywhere:TagResource (if using tags)
# - acm-pca:GetCertificateAuthorityCertificate (if using ACM PCA)
# - acm-pca:DescribeCertificateAuthority (if using ACM PCA)
#
# Terraform AWS Provider Documentation:
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rolesanywhere_trust_anchor
#
# AWS Documentation:
# https://docs.aws.amazon.com/rolesanywhere/latest/userguide/trust-anchors.html
################################################################################

resource "aws_rolesanywhere_trust_anchor" "this" {
  # REQUIRED: The name of the Trust Anchor
  # - Must be unique within the account
  # - Used for identification and management
  # - Should be descriptive of the trust source or use case
  name = "example-trust-anchor"

  # OPTIONAL: Whether or not the Trust Anchor should be enabled
  # - Default: true
  # - Set to false to temporarily disable without deleting
  # - Disabled Trust Anchors will reject all authentication attempts
  # enabled = true

  # REQUIRED: The source of trust configuration
  # - Defines where the trust anchor gets its certificate authority
  # - Must specify exactly one source type and corresponding source data
  source {
    # REQUIRED: The type of the source of trust
    # - Must be either "AWS_ACM_PCA" or "CERTIFICATE_BUNDLE"
    # - AWS_ACM_PCA: Use AWS Certificate Manager Private Certificate Authority
    # - CERTIFICATE_BUNDLE: Use an external certificate (uploaded directly)
    source_type = "AWS_ACM_PCA"

    # REQUIRED: The data denoting the source of trust
    source_data {
      # OPTION 1: Use AWS ACM Private Certificate Authority
      # - Required when source_type is "AWS_ACM_PCA"
      # - The ACM PCA must be in an ACTIVE state
      # - The PCA must have a root or subordinate CA certificate installed
      acm_pca_arn = "arn:aws:acm-pca:us-east-1:123456789012:certificate-authority/12345678-1234-1234-1234-123456789012"

      # OPTION 2: Use an external certificate bundle
      # - Required when source_type is "CERTIFICATE_BUNDLE"
      # - Must be a PEM-encoded X.509 certificate
      # - Can be a root CA or intermediate CA certificate
      # - Maximum size: 1MB
      # x509_certificate_data = "-----BEGIN CERTIFICATE-----\n...\n-----END CERTIFICATE-----"
    }
  }

  # OPTIONAL: A map of tags to assign to the resource
  # - Maximum 50 tags per resource
  # - Keys and values are case-sensitive
  # - If configured with a provider default_tags configuration block,
  #   tags with matching keys will overwrite those defined at the provider level
  tags = {
    Name        = "example-trust-anchor"
    Environment = "production"
    ManagedBy   = "terraform"
  }

  ################################################################################
  # Additional Configuration Notes
  ################################################################################
  #
  # Source Type Selection:
  # - AWS_ACM_PCA (Recommended):
  #   * Fully managed by AWS
  #   * Automatic certificate rotation
  #   * Integrated with AWS services
  #   * Requires ACM PCA setup and ongoing costs
  #
  # - CERTIFICATE_BUNDLE:
  #   * Use your own PKI infrastructure
  #   * Full control over certificate lifecycle
  #   * Must manage rotation manually
  #   * No additional AWS service costs
  #
  # Dependencies:
  # - When using ACM PCA, ensure the PCA is fully configured with:
  #   1. Certificate Authority created
  #   2. Root/subordinate certificate installed
  #   3. PCA in ACTIVE state
  # - Use depends_on to ensure proper resource ordering
  #
  # Security Considerations:
  # - Trust Anchors establish root of trust - protect them carefully
  # - Regularly review and rotate certificates
  # - Monitor usage through CloudTrail logs
  # - Consider using separate Trust Anchors for different environments
  # - Implement least privilege for IAM roles used with Trust Anchors
  #
  ################################################################################
}

################################################################################
# Example: Trust Anchor with AWS ACM PCA
################################################################################
#
# resource "aws_acmpca_certificate_authority" "example" {
#   permanent_deletion_time_in_days = 7
#   type                            = "ROOT"
#
#   certificate_authority_configuration {
#     key_algorithm     = "RSA_4096"
#     signing_algorithm = "SHA512WITHRSA"
#
#     subject {
#       common_name = "example.com"
#     }
#   }
# }
#
# data "aws_partition" "current" {}
#
# resource "aws_acmpca_certificate" "example" {
#   certificate_authority_arn   = aws_acmpca_certificate_authority.example.arn
#   certificate_signing_request = aws_acmpca_certificate_authority.example.certificate_signing_request
#   signing_algorithm           = "SHA512WITHRSA"
#
#   template_arn = "arn:${data.aws_partition.current.partition}:acm-pca:::template/RootCACertificate/V1"
#
#   validity {
#     type  = "YEARS"
#     value = 1
#   }
# }
#
# resource "aws_acmpca_certificate_authority_certificate" "example" {
#   certificate_authority_arn = aws_acmpca_certificate_authority.example.arn
#   certificate               = aws_acmpca_certificate.example.certificate
#   certificate_chain         = aws_acmpca_certificate.example.certificate_chain
# }
#
# resource "aws_rolesanywhere_trust_anchor" "example" {
#   name = "example-trust-anchor"
#
#   source {
#     source_type = "AWS_ACM_PCA"
#
#     source_data {
#       acm_pca_arn = aws_acmpca_certificate_authority.example.arn
#     }
#   }
#
#   # Wait for the ACMPCA to be ready before setting up the trust anchor
#   depends_on = [aws_acmpca_certificate_authority_certificate.example]
# }
#
################################################################################

################################################################################
# Example: Trust Anchor with Certificate Bundle
################################################################################
#
# resource "aws_rolesanywhere_trust_anchor" "certificate_bundle" {
#   name    = "external-ca-trust-anchor"
#   enabled = true
#
#   source {
#     source_type = "CERTIFICATE_BUNDLE"
#
#     source_data {
#       x509_certificate_data = file("${path.module}/certificates/root-ca.pem")
#     }
#   }
#
#   tags = {
#     Name        = "external-ca-trust-anchor"
#     Environment = "production"
#     CertSource  = "external-pki"
#   }
# }
#
################################################################################

################################################################################
# Outputs
################################################################################

# output "trust_anchor_id" {
#   description = "The Trust Anchor ID"
#   value       = aws_rolesanywhere_trust_anchor.this.id
# }
#
# output "trust_anchor_arn" {
#   description = "Amazon Resource Name (ARN) of the Trust Anchor"
#   value       = aws_rolesanywhere_trust_anchor.this.arn
# }
#
# output "trust_anchor_tags_all" {
#   description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
#   value       = aws_rolesanywhere_trust_anchor.this.tags_all
# }
