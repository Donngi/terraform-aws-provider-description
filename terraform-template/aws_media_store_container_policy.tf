################################################################################
# AWS MediaStore Container Policy
################################################################################
# WARNING: This resource is DEPRECATED and will be removed in a future version.
# AWS has announced the discontinuation of AWS Elemental MediaStore,
# effective November 13, 2025.
#
# Migration recommendations:
# - Simple live streaming workflows: Migrate to Amazon S3
# - Advanced use cases (packaging, DRM, cross-region redundancy):
#   Use AWS Elemental MediaPackage
#
# Provides a MediaStore Container Policy resource.
# This resource defines access policies for MediaStore containers using IAM policy documents.
#
# Provider Version: 6.28.0
# Resource Version: 0
################################################################################

resource "aws_media_store_container_policy" "example" {
  ################################################################################
  # Required Arguments
  ################################################################################

  # The name of the MediaStore container to attach the policy to
  # Type: string
  # Required: Yes
  # Example: "example-container"
  # Note: Must reference an existing aws_media_store_container resource
  container_name = aws_media_store_container.example.name

  # The contents of the IAM policy document
  # Type: string (JSON formatted)
  # Required: Yes
  # Note: It's recommended to use jsonencode() or aws_iam_policy_document data source
  #       to generate the policy JSON. This helps maintain consistency and avoids
  #       formatting issues inherent to JSON.
  # Example: Use data.aws_iam_policy_document.example.json
  policy = data.aws_iam_policy_document.example.json

  ################################################################################
  # Optional Arguments
  ################################################################################

  # Region where this resource will be managed
  # Type: string
  # Required: No
  # Computed: Yes
  # Default: Defaults to the Region set in the provider configuration
  # Reference: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # Uncomment to override the provider region:
  # region = "us-east-1"

  ################################################################################
  # Computed/Read-Only Attributes
  ################################################################################

  # id - (Computed) The unique identifier for the policy (format: container_name)
}

################################################################################
# Example Usage with IAM Policy Document
################################################################################

# Get current AWS region
data "aws_region" "current" {}

# Get current AWS account ID
data "aws_caller_identity" "current" {}

# Create a MediaStore container
resource "aws_media_store_container" "example" {
  name = "example"
}

# Define the IAM policy document using data source (recommended approach)
data "aws_iam_policy_document" "example" {
  statement {
    sid    = "MediaStoreFullAccess"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }

    actions = ["mediastore:*"]
    resources = [
      "arn:aws:mediastore:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:container/${aws_media_store_container.example.name}/*"
    ]

    # Require secure transport (HTTPS only)
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["true"]
    }
  }
}

# Apply the policy to the container
resource "aws_media_store_container_policy" "example" {
  container_name = aws_media_store_container.example.name
  policy         = data.aws_iam_policy_document.example.json
}

################################################################################
# Alternative Example: Using jsonencode()
################################################################################

# resource "aws_media_store_container_policy" "alternative" {
#   container_name = aws_media_store_container.example.name
#
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Sid    = "MediaStoreFullAccess"
#         Effect = "Allow"
#         Principal = {
#           AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
#         }
#         Action   = ["mediastore:*"]
#         Resource = "arn:aws:mediastore:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:container/${aws_media_store_container.example.name}/*"
#         Condition = {
#           Bool = {
#             "aws:SecureTransport" = "true"
#           }
#         }
#       }
#     ]
#   })
# }

################################################################################
# Common MediaStore Actions for Policies
################################################################################
#
# - mediastore:GetObject          - Retrieve objects from the container
# - mediastore:PutObject          - Upload objects to the container
# - mediastore:DeleteObject       - Delete objects from the container
# - mediastore:ListItems          - List objects in the container
# - mediastore:DescribeObject     - Get metadata about an object
# - mediastore:GetContainerPolicy - Read the container's access policy
# - mediastore:PutContainerPolicy - Update the container's access policy
# - mediastore:*                  - All MediaStore actions (use cautiously)
#
################################################################################

################################################################################
# Important Notes
################################################################################
#
# 1. DEPRECATION WARNING:
#    - AWS Elemental MediaStore will be discontinued on November 13, 2025
#    - Start planning migration to alternative solutions immediately
#
# 2. Policy Best Practices:
#    - Always use aws_iam_policy_document data source or jsonencode()
#    - Avoid hardcoding JSON strings to prevent formatting issues
#    - Implement least privilege access principles
#    - Use condition blocks to enforce security requirements (e.g., SecureTransport)
#
# 3. Resource ARN Format:
#    - Container: arn:aws:mediastore:REGION:ACCOUNT_ID:container/CONTAINER_NAME
#    - Objects: arn:aws:mediastore:REGION:ACCOUNT_ID:container/CONTAINER_NAME/*
#
# 4. Dependencies:
#    - Requires an existing aws_media_store_container resource
#    - Policy changes take effect immediately
#
# 5. Cross-Region Considerations:
#    - The region argument allows managing the policy in a specific region
#    - Ensure the region matches the MediaStore container's region
#
# 6. Terraform Import:
#    - Import using the container name:
#      terraform import aws_media_store_container_policy.example example-container
#
################################################################################
