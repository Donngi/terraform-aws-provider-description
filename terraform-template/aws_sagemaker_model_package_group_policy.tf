################################################################################
# AWS SageMaker Model Package Group Policy
# https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/sagemaker_model_package_group_policy
################################################################################
# Purpose:
#   - Provides a SageMaker Model Package Group Policy resource
#   - Adds a resource policy to control access to a model package group
#   - Manages cross-account access and sharing of model packages
#
# Key Features:
#   - Resource-based access control for model package groups
#   - Supports AWS Resource Access Manager (RAM) integration
#   - Enables cross-account model registry sharing
#   - JSON policy document for fine-grained permissions
#
# Use Cases:
#   - Share model packages across AWS accounts
#   - Grant specific IAM principals access to model groups
#   - Implement least-privilege access to ML models
#   - Enable model registry discoverability
#
# Related Resources:
#   - aws_sagemaker_model_package_group
#   - aws_iam_policy_document
#   - aws_caller_identity (data source)
################################################################################

resource "aws_sagemaker_model_package_group_policy" "this" {
  ################################################################################
  # Required Arguments
  ################################################################################

  # The name of the model package group
  # - Must reference an existing SageMaker model package group
  # - Length: 1-63 characters
  # - Pattern: alphanumeric with hyphens, must start with alphanumeric
  # - Used to identify which model group receives the policy
  # Reference: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_PutModelPackageGroupPolicy.html#sagemaker-PutModelPackageGroupPolicy-request-ModelPackageGroupName
  model_package_group_name = "example-model-group"

  # The resource policy for the model package group
  # - Must be a valid JSON policy document
  # - Length: 1-20480 characters
  # - Defines who can access the model package group and what actions they can perform
  # - Typically created using aws_iam_policy_document data source
  # - Supports standard IAM policy elements: Principal, Action, Resource, Effect
  # Common actions: sagemaker:DescribeModelPackage, sagemaker:ListModelPackages
  # Reference: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_PutModelPackageGroupPolicy.html#sagemaker-PutModelPackageGroupPolicy-request-ResourcePolicy
  resource_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AddPermModelPackageGroup"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::123456789012:root"
        }
        Action = [
          "sagemaker:DescribeModelPackage",
          "sagemaker:ListModelPackages"
        ]
        Resource = "arn:aws:sagemaker:us-east-1:123456789012:model-package-group/example-model-group"
      }
    ]
  })

  ################################################################################
  # Optional Arguments
  ################################################################################

  # Region where this resource will be managed
  # - Defaults to the region set in the provider configuration
  # - Useful for multi-region deployments
  # - Must match the region where the model package group exists
  # Reference: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  ################################################################################
  # Computed Attributes (Read-only)
  ################################################################################
  # id = The name of the Model Package Group
  # - Format: model_package_group_name
  # - Can be used for resource references and data source lookups
  ################################################################################

  ################################################################################
  # Lifecycle Management
  ################################################################################
  # lifecycle {
  #   # Prevent accidental deletion of critical model access policies
  #   prevent_destroy = true
  #
  #   # Ignore changes to policy if managed externally
  #   ignore_changes = [resource_policy]
  #
  #   # Create new policy before destroying old one to prevent access interruption
  #   create_before_destroy = true
  # }
}

################################################################################
# Example: Basic Cross-Account Access Policy
################################################################################
# data "aws_caller_identity" "current" {}
#
# data "aws_iam_policy_document" "example" {
#   statement {
#     sid = "AddPermModelPackageGroup"
#     actions = [
#       "sagemaker:DescribeModelPackage",
#       "sagemaker:ListModelPackages"
#     ]
#     resources = [aws_sagemaker_model_package_group.example.arn]
#     principals {
#       type        = "AWS"
#       identifiers = [data.aws_caller_identity.current.account_id]
#     }
#   }
# }
#
# resource "aws_sagemaker_model_package_group" "example" {
#   model_package_group_name = "example"
# }
#
# resource "aws_sagemaker_model_package_group_policy" "example" {
#   model_package_group_name = aws_sagemaker_model_package_group.example.model_package_group_name
#   resource_policy          = jsonencode(jsondecode(data.aws_iam_policy_document.example.json))
# }

################################################################################
# Example: Multi-Account Sharing with Resource Access Manager
################################################################################
# data "aws_iam_policy_document" "ram_sharing" {
#   statement {
#     sid = "AllowRAMSharing"
#     actions = [
#       "sagemaker:DescribeModelPackageGroup",
#       "sagemaker:DescribeModelPackage",
#       "sagemaker:ListModelPackages",
#       "sagemaker:GetModelPackageGroupPolicy"
#     ]
#     resources = [aws_sagemaker_model_package_group.shared.arn]
#     principals {
#       type = "AWS"
#       identifiers = [
#         "arn:aws:iam::111111111111:root",
#         "arn:aws:iam::222222222222:root"
#       ]
#     }
#   }
# }
#
# resource "aws_sagemaker_model_package_group_policy" "ram_sharing" {
#   model_package_group_name = aws_sagemaker_model_package_group.shared.model_package_group_name
#   resource_policy          = data.aws_iam_policy_document.ram_sharing.json
# }

################################################################################
# Example: Organization-Wide Access
################################################################################
# data "aws_organizations_organization" "current" {}
#
# data "aws_iam_policy_document" "org_access" {
#   statement {
#     sid = "AllowOrganizationAccess"
#     actions = [
#       "sagemaker:DescribeModelPackage",
#       "sagemaker:ListModelPackages"
#     ]
#     resources = [aws_sagemaker_model_package_group.org.arn]
#     principals {
#       type        = "AWS"
#       identifiers = ["*"]
#     }
#     condition {
#       test     = "StringEquals"
#       variable = "aws:PrincipalOrgID"
#       values   = [data.aws_organizations_organization.current.id]
#     }
#   }
# }
#
# resource "aws_sagemaker_model_package_group_policy" "org_access" {
#   model_package_group_name = aws_sagemaker_model_package_group.org.model_package_group_name
#   resource_policy          = data.aws_iam_policy_document.org_access.json
# }

################################################################################
# Important Notes:
################################################################################
# 1. The resource policy is applied at the model package group level, not individual packages
# 2. Cross-account access requires both resource policy and IAM permissions in target account
# 3. Use aws_iam_policy_document data source for policy construction best practices
# 4. jsonencode(jsondecode()) pattern normalizes JSON formatting
# 5. For AWS RAM integration, consider promoting permissions for discoverability
# 6. Policy changes may require time to propagate across accounts
# 7. Maximum policy size is 20,480 characters
# 8. Model package group must exist before applying policy
# 9. Consider using lifecycle policies to prevent accidental deletion
# 10. Test cross-account access after policy application
#
# Security Best Practices:
# - Use specific AWS account IDs instead of wildcards when possible
# - Implement least-privilege access principles
# - Regularly audit and review access policies
# - Use condition keys to further restrict access (e.g., source IP, MFA)
# - Consider using AWS Organizations for organization-wide policies
# - Document the purpose of each policy statement
# - Monitor CloudTrail logs for policy usage and access patterns
#
# Related AWS Documentation:
# - Model Registry: https://docs.aws.amazon.com/sagemaker/latest/dg/model-registry.html
# - Resource Policies: https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_identity-vs-resource.html
# - RAM Sharing: https://docs.aws.amazon.com/sagemaker/latest/dg/model-registry-ram.html
# - API Reference: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_PutModelPackageGroupPolicy.html
################################################################################
