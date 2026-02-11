# ============================================================================
# AWS CodeArtifact Repository Permissions Policy Resource
# ============================================================================
# Generated: 2026-01-19
# Provider Version: hashicorp/aws 6.28.0
#
# Note: This template was generated based on the AWS Provider schema at the time
# of creation. Always refer to the official Terraform documentation for the most
# up-to-date information:
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_repository_permissions_policy
# ============================================================================

resource "aws_codeartifact_repository_permissions_policy" "example" {
  # ============================================================================
  # Required Arguments
  # ============================================================================

  # domain - (Required) The name of the domain on which to set the resource policy.
  # The domain must already exist in your AWS account.
  # Type: string
  # AWS Docs: https://docs.aws.amazon.com/codeartifact/latest/ug/repo-policies.html
  domain = "example-domain"

  # repository - (Required) The name of the repository to set the resource policy on.
  # The repository must already exist within the specified domain.
  # Type: string
  # AWS Docs: https://docs.aws.amazon.com/codeartifact/latest/ug/repo-policies.html
  repository = "example-repository"

  # policy_document - (Required) A JSON policy string to be set as the access control
  # resource policy on the provided repository. This policy specifies which AWS principals
  # can perform which actions on the repository.
  #
  # Important notes:
  # - The policy is evaluated only for operations against the repository it's attached to
  # - Because the resource is implied, you can set the Resource to "*" in the policy
  # - The codeartifact:ReadFromRepository action can only be used on a repository resource
  # - You cannot specify a package ARN to allow read access to a subset of packages
  # - When calling put-repository-permissions-policy, the existing resource policy is
  #   ignored when evaluating permissions (prevents lock-out)
  # - For cross-account access, a domain policy must also grant at least
  #   codeartifact:GetAuthorizationToken permission
  #
  # Common actions to grant:
  # - codeartifact:ReadFromRepository - Download packages from the repository
  # - codeartifact:PublishPackageVersion - Publish new package versions
  # - codeartifact:DescribePackageVersion - Get package version details
  # - codeartifact:DescribeRepository - Get repository details
  # - codeartifact:GetPackageVersionReadme - Read package README files
  # - codeartifact:GetRepositoryEndpoint - Get repository endpoint URL
  # - codeartifact:ListPackages - List packages in the repository
  # - codeartifact:ListPackageVersions - List versions of a package
  # - codeartifact:ListPackageVersionAssets - List package version assets
  # - codeartifact:ListPackageVersionDependencies - List package dependencies
  #
  # Type: string (valid JSON)
  # AWS Docs: https://docs.aws.amazon.com/codeartifact/latest/ug/repo-policies.html
  # API Reference: https://docs.aws.amazon.com/codeartifact/latest/APIReference/API_PutRepositoryPermissionsPolicy.html
  policy_document = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::123456789012:root"
        }
        Action = [
          "codeartifact:DescribePackageVersion",
          "codeartifact:DescribeRepository",
          "codeartifact:GetPackageVersionReadme",
          "codeartifact:GetRepositoryEndpoint",
          "codeartifact:ListPackages",
          "codeartifact:ListPackageVersions",
          "codeartifact:ListPackageVersionAssets",
          "codeartifact:ListPackageVersionDependencies",
          "codeartifact:ReadFromRepository"
        ]
        Resource = "*"
      }
    ]
  })

  # ============================================================================
  # Optional Arguments
  # ============================================================================

  # domain_owner - (Optional) The account number of the AWS account that owns the domain.
  # If not specified, the account ID of the caller is used.
  # Type: string
  # Computed: true (will be set to the caller's account ID if not specified)
  domain_owner = "111122223333"

  # policy_revision - (Optional) The current revision of the resource policy to be set.
  # This revision is used for optimistic locking, which prevents others from overwriting
  # your changes to the repository's resource policy. The revision ID is returned when
  # you get or set a policy. Pass this value to ensure you're updating a known version
  # of the policy and not accidentally overwriting a newer version set by another writer.
  #
  # Type: string
  # Computed: true (the service will return the current revision)
  # Example value: "MQlyyTQRASRU3HB58gBtSDHXG7Q3hvxxxxxxx="
  policy_revision = null

  # region - (Optional) Region where this resource will be managed.
  # Defaults to the region set in the provider configuration.
  #
  # This is a special meta-argument that allows you to override the region for this
  # specific resource, which is useful for multi-region deployments.
  #
  # Type: string
  # Computed: true (defaults to provider region if not specified)
  # AWS Docs: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # Provider Docs: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#aws-configuration-reference
  region = null

  # id - (Optional) Terraform resource identifier. This is typically auto-generated
  # and should not be set manually. However, it can be imported when bringing existing
  # infrastructure under Terraform management.
  # Type: string
  # Computed: true
  # Note: Use terraform import to manage existing resources
  # id = null  # Typically not set manually

  # ============================================================================
  # Computed Attributes (Read-Only)
  # ============================================================================
  # These attributes are computed by AWS and cannot be set in the configuration.
  # They are available for reference after the resource is created.
  #
  # - resource_arn (string) - The ARN of the resource associated with the resource policy.
  #   Example: "arn:aws:codeartifact:us-east-1:111122223333:repository/my-domain/my-repo"
  #   This can be referenced as: aws_codeartifact_repository_permissions_policy.example.resource_arn
  # ============================================================================
}

# ============================================================================
# Example: Grant Read Access to a Specific IAM User
# ============================================================================
# resource "aws_codeartifact_repository_permissions_policy" "read_only_user" {
#   domain     = aws_codeartifact_domain.example.domain
#   repository = aws_codeartifact_repository.example.repository
#
#   policy_document = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Principal = {
#           AWS = "arn:aws:iam::123456789012:user/bob"
#         }
#         Action = [
#           "codeartifact:ReadFromRepository"
#         ]
#         Resource = "*"
#       }
#     ]
#   })
# }

# ============================================================================
# Example: Grant Write Access to All Packages in Repository
# ============================================================================
# resource "aws_codeartifact_repository_permissions_policy" "write_all_packages" {
#   domain     = aws_codeartifact_domain.example.domain
#   repository = aws_codeartifact_repository.example.repository
#
#   policy_document = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Principal = {
#           AWS = "arn:aws:iam::123456789012:root"
#         }
#         Action = [
#           "codeartifact:PublishPackageVersion"
#         ]
#         Resource = "arn:aws:codeartifact:us-east-1:111122223333:package/${aws_codeartifact_domain.example.domain}/${aws_codeartifact_repository.example.repository}/*"
#       }
#     ]
#   })
# }

# ============================================================================
# Example: Grant Write Access to Specific NPM Package with Scope
# ============================================================================
# resource "aws_codeartifact_repository_permissions_policy" "write_specific_package" {
#   domain     = aws_codeartifact_domain.example.domain
#   repository = aws_codeartifact_repository.example.repository
#
#   policy_document = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Principal = {
#           AWS = "arn:aws:iam::123456789012:root"
#         }
#         Action = [
#           "codeartifact:PublishPackageVersion"
#         ]
#         Resource = "arn:aws:codeartifact:us-east-1:111122223333:package/${aws_codeartifact_domain.example.domain}/${aws_codeartifact_repository.example.repository}/npm/parity/ui"
#       }
#     ]
#   })
# }

# ============================================================================
# Usage with data source for dynamic policy generation
# ============================================================================
# data "aws_iam_policy_document" "repository_policy" {
#   statement {
#     effect = "Allow"
#     principals {
#       type        = "*"
#       identifiers = ["*"]
#     }
#     actions = [
#       "codeartifact:ReadFromRepository"
#     ]
#     resources = ["*"]
#   }
# }
#
# resource "aws_codeartifact_repository_permissions_policy" "example" {
#   domain          = aws_codeartifact_domain.example.domain
#   repository      = aws_codeartifact_repository.example.repository
#   policy_document = data.aws_iam_policy_document.repository_policy.json
# }

# ============================================================================
# Important Notes
# ============================================================================
# 1. Policy Evaluation:
#    - Both domain and repository policies are evaluated for repository operations
#    - An explicit deny in any policy overrides allows in other policies
#    - An explicit allow in one policy is sufficient (no implicit deny from omission)
#
# 2. Cross-Account Access Requirements:
#    - Repository policy must grant permissions to the principal
#    - Domain policy must grant at least codeartifact:GetAuthorizationToken
#    - Principal's identity-based policy must allow the actions
#
# 3. Lock-Out Prevention:
#    - When calling PutRepositoryPermissionsPolicy, the existing resource policy
#      is ignored to prevent domain owners from locking themselves out
#    - You cannot grant another account permission to update the policy via a
#      resource policy
#
# 4. Package Format Specific Requirements:
#    - For Maven: Add codeartifact:PutPackageMetadata with PublishPackageVersion
#    - For NuGet: Add codeartifact:ReadFromRepository with PublishPackageVersion
#
# 5. Package ARN Format:
#    arn:aws:codeartifact:REGION:ACCOUNT:package/DOMAIN/REPO/FORMAT/NAMESPACE/NAME
#    - For npm packages without scope, NAMESPACE is empty: .../npm//react
#    - For npm packages with scope: .../npm/parity/ui
#
# AWS Documentation:
# - Repository Policies: https://docs.aws.amazon.com/codeartifact/latest/ug/repo-policies.html
# - Domain Policies: https://docs.aws.amazon.com/codeartifact/latest/ug/domain-policies.html
# - API Reference: https://docs.aws.amazon.com/codeartifact/latest/APIReference/API_PutRepositoryPermissionsPolicy.html
# ============================================================================
