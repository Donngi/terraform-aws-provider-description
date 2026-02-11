# ================================================================================
# AWS S3 Bucket Policy - Terraform Configuration Template
# ================================================================================
# Purpose:
#   Attaches a policy to an S3 bucket resource to control access permissions.
#   Supports both S3 general purpose buckets and S3 directory buckets.
#
# Provider Version: 6.28.0
# Resource: aws_s3_bucket_policy
# Documentation: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy
#
# Key Features:
#   - Define access policies using JSON-formatted IAM policy language
#   - Support for cross-account access permissions
#   - Integration with aws_iam_policy_document data source
#   - Apply policies to both general purpose and directory buckets
#
# Common Use Cases:
#   - Grant cross-account access to S3 buckets
#   - Allow CloudFront OAI (Origin Access Identity) to access bucket objects
#   - Enforce encryption requirements for object uploads
#   - Grant read-only public access to specific objects
#   - Restrict access based on IP addresses or VPC endpoints
#   - Manage access for AWS services (CloudTrail, S3 Storage Lens, etc.)
#
# Important Notes:
#   - Bucket policies are limited to 20 KB in size
#   - Policies apply to all objects owned by the bucket owner
#   - Use aws_iam_policy_document data source for policy generation
#   - Bucket policies cannot prevent deletions by S3 Lifecycle rules
#   - Default Object Ownership is "Bucket owner enforced" (disabling ACLs)
#
# Related Resources:
#   - aws_s3_bucket: Create the S3 bucket
#   - aws_iam_policy_document: Generate IAM policy JSON
#   - aws_s3_bucket_public_access_block: Manage public access settings
#
# Best Practices:
#   - Use least privilege principle when defining permissions
#   - Leverage aws_iam_policy_document for maintainable policy definitions
#   - Test policies thoroughly before applying to production buckets
#   - Consider using S3 Access Points for complex access patterns
#   - Enable S3 Versioning and Object Lock for data integrity
#   - Implement server-side encryption for sensitive data
# ================================================================================

# Example S3 Bucket Resource (dependency)
resource "aws_s3_bucket" "example" {
  bucket = "my-tf-test-bucket-unique-name" # Must be globally unique

  tags = {
    Name        = "Example Bucket"
    Environment = "Development"
    ManagedBy   = "Terraform"
  }
}

# Example IAM Policy Document for Bucket Policy
data "aws_iam_policy_document" "allow_access_from_another_account" {
  # Statement 1: Allow cross-account read access
  statement {
    sid    = "AllowCrossAccountRead"
    effect = "Allow"

    # Define who can perform the actions
    principals {
      type = "AWS"
      identifiers = [
        "123456789012" # Replace with the actual AWS account ID
      ]
    }

    # Define allowed actions
    actions = [
      "s3:GetObject",    # Read objects
      "s3:ListBucket",   # List bucket contents
    ]

    # Define which resources the actions apply to
    resources = [
      aws_s3_bucket.example.arn,        # Bucket itself (for ListBucket)
      "${aws_s3_bucket.example.arn}/*", # All objects in the bucket
    ]
  }

  # Statement 2: Example - Enforce encryption for uploads
  # Uncomment to require server-side encryption for all uploads
  # statement {
  #   sid    = "DenyUnencryptedObjectUploads"
  #   effect = "Deny"
  #
  #   principals {
  #     type        = "*"
  #     identifiers = ["*"]
  #   }
  #
  #   actions = [
  #     "s3:PutObject",
  #   ]
  #
  #   resources = [
  #     "${aws_s3_bucket.example.arn}/*",
  #   ]
  #
  #   condition {
  #     test     = "StringNotEquals"
  #     variable = "s3:x-amz-server-side-encryption"
  #     values   = ["AES256", "aws:kms"]
  #   }
  # }

  # Statement 3: Example - Restrict access by IP address
  # Uncomment to allow access only from specific IP ranges
  # statement {
  #   sid    = "AllowFromSpecificIPOnly"
  #   effect = "Allow"
  #
  #   principals {
  #     type        = "*"
  #     identifiers = ["*"]
  #   }
  #
  #   actions = [
  #     "s3:GetObject",
  #   ]
  #
  #   resources = [
  #     "${aws_s3_bucket.example.arn}/*",
  #   ]
  #
  #   condition {
  #     test     = "IpAddress"
  #     variable = "aws:SourceIp"
  #     values = [
  #       "192.0.2.0/24",   # Replace with your IP range
  #       "203.0.113.0/24", # Replace with your IP range
  #     ]
  #   }
  # }
}

# ================================================================================
# Main Resource: AWS S3 Bucket Policy
# ================================================================================

resource "aws_s3_bucket_policy" "example" {
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  # Required Arguments
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  # bucket - (Required) Name of the bucket to which to apply the policy
  # Type: string
  # The S3 bucket name or ARN. Must reference an existing bucket.
  bucket = aws_s3_bucket.example.id

  # policy - (Required) Text of the policy
  # Type: string (JSON)
  # Although this is a bucket policy, the aws_iam_policy_document data source
  # may be used as long as it specifies a principal. Bucket policies are limited
  # to 20 KB in size.
  #
  # Policy Structure:
  # - Version: IAM policy language version (usually "2012-10-17")
  # - Statement: Array of policy statements with Effect, Principal, Action, Resource
  # - Condition: Optional conditions for when the policy applies
  #
  # Common Actions:
  # - s3:GetObject: Read objects
  # - s3:PutObject: Write objects
  # - s3:DeleteObject: Delete objects
  # - s3:ListBucket: List bucket contents
  # - s3:GetBucketLocation: Get bucket region
  # - s3:GetObjectVersion: Read object versions
  #
  # Principal Types:
  # - AWS: AWS account ID or IAM role/user ARN
  # - Service: AWS service (e.g., "cloudfront.amazonaws.com")
  # - Federated: Web identity or SAML provider
  # - CanonicalUser: S3 canonical user ID
  # - "*": All users (public access)
  policy = data.aws_iam_policy_document.allow_access_from_another_account.json

  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  # Optional Arguments
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  # region - (Optional) Region where this resource will be managed
  # Type: string (computed)
  # Defaults to the region set in the provider configuration. Useful for
  # managing buckets in specific regions or for multi-region deployments.
  # Example: "us-east-1", "eu-west-1", "ap-northeast-1"
  # region = "us-east-1"

  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  # Resource Dependencies
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  # Implicit dependencies:
  # - aws_s3_bucket.example: Must exist before policy can be attached
  # - data.aws_iam_policy_document: Must be evaluated before policy creation
}

# ================================================================================
# Additional Examples
# ================================================================================

# Example 1: CloudFront OAI Access Policy
# Uncomment to allow CloudFront Origin Access Identity to access bucket
#
# resource "aws_cloudfront_origin_access_identity" "oai" {
#   comment = "OAI for ${aws_s3_bucket.example.id}"
# }
#
# data "aws_iam_policy_document" "cloudfront_oai_access" {
#   statement {
#     sid    = "AllowCloudFrontOAIAccess"
#     effect = "Allow"
#
#     principals {
#       type        = "AWS"
#       identifiers = [aws_cloudfront_origin_access_identity.oai.iam_arn]
#     }
#
#     actions = [
#       "s3:GetObject",
#     ]
#
#     resources = [
#       "${aws_s3_bucket.example.arn}/*",
#     ]
#   }
# }
#
# resource "aws_s3_bucket_policy" "cloudfront" {
#   bucket = aws_s3_bucket.example.id
#   policy = data.aws_iam_policy_document.cloudfront_oai_access.json
# }

# Example 2: Public Read Access Policy
# WARNING: Only use for public content like static websites
#
# data "aws_iam_policy_document" "public_read" {
#   statement {
#     sid    = "PublicReadGetObject"
#     effect = "Allow"
#
#     principals {
#       type        = "*"
#       identifiers = ["*"]
#     }
#
#     actions = [
#       "s3:GetObject",
#     ]
#
#     resources = [
#       "${aws_s3_bucket.example.arn}/*",
#     ]
#   }
# }
#
# resource "aws_s3_bucket_policy" "public_read" {
#   bucket = aws_s3_bucket.example.id
#   policy = data.aws_iam_policy_document.public_read.json
# }

# Example 3: Enforce SSL/TLS for all requests
#
# data "aws_iam_policy_document" "enforce_ssl" {
#   statement {
#     sid    = "DenyInsecureTransport"
#     effect = "Deny"
#
#     principals {
#       type        = "*"
#       identifiers = ["*"]
#     }
#
#     actions = [
#       "s3:*",
#     ]
#
#     resources = [
#       aws_s3_bucket.example.arn,
#       "${aws_s3_bucket.example.arn}/*",
#     ]
#
#     condition {
#       test     = "Bool"
#       variable = "aws:SecureTransport"
#       values   = ["false"]
#     }
#   }
# }
#
# resource "aws_s3_bucket_policy" "enforce_ssl" {
#   bucket = aws_s3_bucket.example.id
#   policy = data.aws_iam_policy_document.enforce_ssl.json
# }

# Example 4: VPC Endpoint Access Policy
# Restrict access to requests from specific VPC endpoints
#
# data "aws_iam_policy_document" "vpc_endpoint_access" {
#   statement {
#     sid    = "AllowVPCEndpointAccess"
#     effect = "Deny"
#
#     principals {
#       type        = "*"
#       identifiers = ["*"]
#     }
#
#     actions = [
#       "s3:*",
#     ]
#
#     resources = [
#       aws_s3_bucket.example.arn,
#       "${aws_s3_bucket.example.arn}/*",
#     ]
#
#     condition {
#       test     = "StringNotEquals"
#       variable = "aws:SourceVpce"
#       values   = ["vpce-1234567890abcdef0"] # Replace with your VPC endpoint ID
#     }
#   }
# }
#
# resource "aws_s3_bucket_policy" "vpc_endpoint" {
#   bucket = aws_s3_bucket.example.id
#   policy = data.aws_iam_policy_document.vpc_endpoint_access.json
# }

# Example 5: Require MFA for object deletion
#
# data "aws_iam_policy_document" "require_mfa_delete" {
#   statement {
#     sid    = "RequireMFADelete"
#     effect = "Deny"
#
#     principals {
#       type        = "*"
#       identifiers = ["*"]
#     }
#
#     actions = [
#       "s3:DeleteObject",
#       "s3:DeleteObjectVersion",
#     ]
#
#     resources = [
#       "${aws_s3_bucket.example.arn}/*",
#     ]
#
#     condition {
#       test     = "BoolIfExists"
#       variable = "aws:MultiFactorAuthPresent"
#       values   = ["false"]
#     }
#   }
# }
#
# resource "aws_s3_bucket_policy" "mfa_delete" {
#   bucket = aws_s3_bucket.example.id
#   policy = data.aws_iam_policy_document.require_mfa_delete.json
# }

# ================================================================================
# Outputs
# ================================================================================

output "bucket_policy_id" {
  description = "The bucket name to which the policy applies"
  value       = aws_s3_bucket_policy.example.id
}

output "bucket_name" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.example.id
}

output "bucket_arn" {
  description = "The ARN of the S3 bucket"
  value       = aws_s3_bucket.example.arn
}

# ================================================================================
# Attributes Reference
# ================================================================================
# In addition to the arguments above, the following attributes are exported:
#
# - id: The bucket name (same as the bucket argument)
# - bucket: The name of the bucket
# - policy: The text of the policy (as applied)
# - region: The region where the bucket policy is managed
#
# ================================================================================
# Import
# ================================================================================
# S3 bucket policies can be imported using the bucket name:
#
# terraform import aws_s3_bucket_policy.example my-tf-test-bucket-unique-name
#
# ================================================================================
