################################################################################
# AWS Organizations Resource Policy
################################################################################
# Terraform Resource: aws_organizations_resource_policy
# Provider Version: 6.28.0
# Resource Documentation: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_resource_policy
#
# Description:
# Provides a resource to manage a resource-based delegation policy that can be
# used to delegate policy management for AWS Organizations to specified member
# accounts to perform policy actions that are by default available only to the
# management account.
#
# Important Notes:
# - Only one resource-based delegation policy can exist per organization
# - This resource manages delegation at the organization level
# - Delegated administrators can perform specific Organizations actions without
#   using the management account
# - The management account should only be used for tasks that require it
# - Security features like SCPs do not restrict users/roles in management account
#
# Common Use Cases:
# 1. Delegate policy management to security/compliance teams
# 2. Enable member accounts to manage specific policy types
# 3. Implement least-privilege access for Organizations administration
# 4. Separate concerns between management and operational accounts
#
# Prerequisites:
# - AWS Organizations must be enabled
# - Must be created from the organization's management account
# - Requires organizations:PutResourcePolicy permission
#
# Best Practices:
# - Use the management account only for essential tasks
# - Store AWS resources in member accounts, not management account
# - Apply principle of least privilege when delegating permissions
# - Document which member accounts have delegated permissions
# - Regularly review and audit delegated permissions
# - Test delegation policies in non-production environments first
#
# AWS Documentation:
# - Overview: https://docs.aws.amazon.com/organizations/latest/userguide/orgs_delegate_policies.html
# - Policy Examples: https://docs.aws.amazon.com/organizations/latest/userguide/security_iam_resource-based-policy-examples.html
# - Create Policy: https://docs.aws.amazon.com/organizations/latest/userguide/orgs-policy-delegate.html
#
# Related Resources:
# - aws_organizations_organization: The parent organization
# - aws_organizations_account: Member accounts that receive delegation
# - aws_organizations_policy: Service control policies (SCPs)
# - aws_iam_role: Roles used by delegated administrators
################################################################################

resource "aws_organizations_resource_policy" "example" {
  ################################################################################
  # Required Arguments
  ################################################################################

  # content - (Required) The policy document content in JSON format
  # Type: string (JSON document)
  #
  # The text must be correctly formatted JSON that complies with the syntax for
  # resource-based policies. The policy document defines which principals
  # (member accounts) are allowed to perform which Organizations actions.
  #
  # Policy Structure:
  # - Version: Policy language version (typically "2012-10-17")
  # - Statement: Array of policy statements
  #   - Sid: Statement identifier (optional but recommended)
  #   - Effect: "Allow" or "Deny"
  #   - Principal: AWS account(s) receiving permissions
  #   - Action: Organizations actions to delegate
  #   - Resource: Resources the actions apply to (typically "*")
  #
  # Common Delegated Actions:
  # Read Operations:
  # - organizations:DescribeOrganization
  # - organizations:DescribeOrganizationalUnit
  # - organizations:DescribeAccount
  # - organizations:DescribePolicy
  # - organizations:DescribeEffectivePolicy
  # - organizations:ListRoots
  # - organizations:ListOrganizationalUnitsForParent
  # - organizations:ListParents
  # - organizations:ListChildren
  # - organizations:ListAccounts
  # - organizations:ListAccountsForParent
  # - organizations:ListPolicies
  # - organizations:ListPoliciesForTarget
  # - organizations:ListTargetsForPolicy
  # - organizations:ListTagsForResource
  #
  # Policy Management:
  # - organizations:AttachPolicy
  # - organizations:CreatePolicy
  # - organizations:DeletePolicy
  # - organizations:DetachPolicy
  # - organizations:UpdatePolicy
  # - organizations:TagResource
  # - organizations:UntagResource
  #
  # Examples:
  # Basic read-only delegation:
  content = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "DelegateReadOnlyAccess"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::123456789012:root"
        }
        Action = [
          "organizations:DescribeOrganization",
          "organizations:DescribeOrganizationalUnit",
          "organizations:DescribeAccount",
          "organizations:DescribePolicy",
          "organizations:ListRoots",
          "organizations:ListOrganizationalUnitsForParent",
          "organizations:ListAccounts",
          "organizations:ListPolicies"
        ]
        Resource = "*"
      }
    ]
  })

  # Example: Delegating backup policy management
  # content = jsonencode({
  #   Version = "2012-10-17"
  #   Statement = [
  #     {
  #       Sid    = "DelegateBackupPolicyManagement"
  #       Effect = "Allow"
  #       Principal = {
  #         AWS = "arn:aws:iam::123456789012:root"
  #       }
  #       Action = [
  #         "organizations:DescribeOrganization",
  #         "organizations:DescribePolicy",
  #         "organizations:DescribeEffectivePolicy",
  #         "organizations:ListRoots",
  #         "organizations:ListOrganizationalUnitsForParent",
  #         "organizations:ListAccounts",
  #         "organizations:ListPolicies",
  #         "organizations:ListPoliciesForTarget",
  #         "organizations:AttachPolicy",
  #         "organizations:DetachPolicy",
  #         "organizations:CreatePolicy",
  #         "organizations:UpdatePolicy",
  #         "organizations:DeletePolicy"
  #       ]
  #       Resource = "*"
  #       Condition = {
  #         StringEquals = {
  #           "organizations:PolicyType" = "BACKUP_POLICY"
  #         }
  #       }
  #     }
  #   ]
  # })

  # Example: Delegating SCP management for specific OU
  # content = jsonencode({
  #   Version = "2012-10-17"
  #   Statement = [
  #     {
  #       Sid    = "DelegateSCPManagementForOU"
  #       Effect = "Allow"
  #       Principal = {
  #         AWS = "arn:aws:iam::123456789012:root"
  #       }
  #       Action = [
  #         "organizations:DescribeOrganization",
  #         "organizations:DescribePolicy",
  #         "organizations:ListPolicies",
  #         "organizations:AttachPolicy",
  #         "organizations:DetachPolicy"
  #       ]
  #       Resource = [
  #         "arn:aws:organizations::123456789012:policy/*/service_control_policy/*",
  #         "arn:aws:organizations::123456789012:ou/o-exampleorgid/ou-examplerootid123-exampleouid123"
  #       ]
  #       Condition = {
  #         StringEquals = {
  #           "organizations:PolicyType" = "SERVICE_CONTROL_POLICY"
  #         }
  #       }
  #     }
  #   ]
  # })

  # Example: Full policy management delegation with conditions
  # content = jsonencode({
  #   Version = "2012-10-17"
  #   Statement = [
  #     {
  #       Sid    = "DelegateFullPolicyManagement"
  #       Effect = "Allow"
  #       Principal = {
  #         AWS = [
  #           "arn:aws:iam::123456789012:root",
  #           "arn:aws:iam::234567890123:root"
  #         ]
  #       }
  #       Action = [
  #         "organizations:DescribeOrganization",
  #         "organizations:DescribeOrganizationalUnit",
  #         "organizations:DescribeAccount",
  #         "organizations:DescribePolicy",
  #         "organizations:DescribeEffectivePolicy",
  #         "organizations:ListRoots",
  #         "organizations:ListOrganizationalUnitsForParent",
  #         "organizations:ListParents",
  #         "organizations:ListChildren",
  #         "organizations:ListAccounts",
  #         "organizations:ListAccountsForParent",
  #         "organizations:ListPolicies",
  #         "organizations:ListPoliciesForTarget",
  #         "organizations:ListTargetsForPolicy",
  #         "organizations:ListTagsForResource",
  #         "organizations:AttachPolicy",
  #         "organizations:CreatePolicy",
  #         "organizations:DeletePolicy",
  #         "organizations:DetachPolicy",
  #         "organizations:UpdatePolicy",
  #         "organizations:TagResource",
  #         "organizations:UntagResource"
  #       ]
  #       Resource = "*"
  #     }
  #   ]
  # })

  ################################################################################
  # Optional Arguments
  ################################################################################

  # tags - (Optional) Key-value map of resource tags
  # Type: map(string)
  # Default: {}
  #
  # Tags to apply to the resource policy. These tags help with:
  # - Resource organization and categorization
  # - Cost allocation and tracking
  # - Access control via tag-based IAM policies
  # - Compliance and governance reporting
  #
  # If configured with a provider default_tags configuration block, tags with
  # matching keys will overwrite those defined at the provider-level.
  #
  # Best Practices:
  # - Use consistent tagging strategy across all resources
  # - Include environment, owner, and purpose tags
  # - Tag for cost tracking and allocation
  # - Use automation-friendly tag values
  #
  # Common Tags:
  tags = {
    Name        = "organizations-delegation-policy"
    Environment = "production"
    ManagedBy   = "terraform"
    Purpose     = "delegate-organizations-management"
    Owner       = "security-team"
    CostCenter  = "governance"
  }

  # Example: Minimal tags
  # tags = {
  #   Name      = "org-delegation-policy"
  #   ManagedBy = "terraform"
  # }

  # Example: Comprehensive tags
  # tags = {
  #   Name             = "organizations-resource-policy"
  #   Environment      = "production"
  #   ManagedBy        = "terraform"
  #   Owner            = "cloud-governance-team"
  #   CostCenter       = "it-security"
  #   Purpose          = "delegate-policy-management"
  #   Compliance       = "required"
  #   DataClass        = "internal"
  #   ReviewDate       = "2024-12-31"
  #   DelegatedAccount = "123456789012"
  # }
}

################################################################################
# Computed Attributes Reference
################################################################################

# The following attributes are exported and can be referenced in other resources:
#
# arn - Amazon Resource Name (ARN) of the resource policy
# Example: "arn:aws:organizations::123456789012:resourcepolicy/o-exampleorgid/rp-examplepolicyid"
# Usage: aws_organizations_resource_policy.example.arn
#
# id - The unique identifier (ID) of the resource policy
# Example: "rp-examplepolicyid"
# Usage: aws_organizations_resource_policy.example.id
#
# tags_all - Map of tags assigned to the resource, including those inherited
# from the provider default_tags configuration block
# Type: map(string)
# Usage: aws_organizations_resource_policy.example.tags_all

################################################################################
# Import
################################################################################

# AWS Organizations Resource Policy can be imported using the policy ID
# terraform import aws_organizations_resource_policy.example rp-examplepolicyid

################################################################################
# Example Output Values
################################################################################

output "organizations_resource_policy_id" {
  description = "The ID of the Organizations resource policy"
  value       = aws_organizations_resource_policy.example.id
}

output "organizations_resource_policy_arn" {
  description = "The ARN of the Organizations resource policy"
  value       = aws_organizations_resource_policy.example.arn
}

output "organizations_resource_policy_tags" {
  description = "All tags applied to the resource policy"
  value       = aws_organizations_resource_policy.example.tags_all
}

################################################################################
# Additional Examples
################################################################################

# Example 1: Delegate read-only access for auditing
# resource "aws_organizations_resource_policy" "audit_delegation" {
#   content = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Sid    = "AuditReadOnlyDelegation"
#         Effect = "Allow"
#         Principal = {
#           AWS = "arn:aws:iam::AUDIT_ACCOUNT_ID:root"
#         }
#         Action = [
#           "organizations:Describe*",
#           "organizations:List*"
#         ]
#         Resource = "*"
#       }
#     ]
#   })
#
#   tags = {
#     Name      = "audit-delegation-policy"
#     Purpose   = "audit-access"
#     ManagedBy = "terraform"
#   }
# }

# Example 2: Delegate tag policy management
# resource "aws_organizations_resource_policy" "tag_policy_delegation" {
#   content = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Sid    = "DelegateTagPolicyManagement"
#         Effect = "Allow"
#         Principal = {
#           AWS = "arn:aws:iam::TAG_ADMIN_ACCOUNT_ID:root"
#         }
#         Action = [
#           "organizations:DescribeOrganization",
#           "organizations:DescribePolicy",
#           "organizations:ListPolicies",
#           "organizations:AttachPolicy",
#           "organizations:DetachPolicy",
#           "organizations:CreatePolicy",
#           "organizations:UpdatePolicy",
#           "organizations:DeletePolicy"
#         ]
#         Resource = "*"
#         Condition = {
#           StringEquals = {
#             "organizations:PolicyType" = "TAG_POLICY"
#           }
#         }
#       }
#     ]
#   })
#
#   tags = {
#     Name      = "tag-policy-delegation"
#     Purpose   = "tag-governance"
#     ManagedBy = "terraform"
#   }
# }

# Example 3: Multi-account delegation with different permissions
# resource "aws_organizations_resource_policy" "multi_account_delegation" {
#   content = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Sid    = "SecurityTeamFullAccess"
#         Effect = "Allow"
#         Principal = {
#           AWS = "arn:aws:iam::SECURITY_ACCOUNT_ID:root"
#         }
#         Action = "organizations:*"
#         Resource = "*"
#       },
#       {
#         Sid    = "ComplianceTeamReadOnly"
#         Effect = "Allow"
#         Principal = {
#           AWS = "arn:aws:iam::COMPLIANCE_ACCOUNT_ID:root"
#         }
#         Action = [
#           "organizations:Describe*",
#           "organizations:List*"
#         ]
#         Resource = "*"
#       },
#       {
#         Sid    = "BackupTeamBackupPolicyOnly"
#         Effect = "Allow"
#         Principal = {
#           AWS = "arn:aws:iam::BACKUP_ACCOUNT_ID:root"
#         }
#         Action = [
#           "organizations:AttachPolicy",
#           "organizations:DetachPolicy",
#           "organizations:CreatePolicy",
#           "organizations:UpdatePolicy"
#         ]
#         Resource = "*"
#         Condition = {
#           StringEquals = {
#             "organizations:PolicyType" = "BACKUP_POLICY"
#           }
#         }
#       }
#     ]
#   })
#
#   tags = {
#     Name      = "multi-account-delegation"
#     Purpose   = "distributed-administration"
#     ManagedBy = "terraform"
#   }
# }

################################################################################
# Notes and Considerations
################################################################################

# Limitations:
# - Only one resource-based delegation policy can exist per organization
# - Must be created from the management account
# - Cannot delegate all Organizations actions (some remain management-account-only)
# - Changes to the policy require replacement of the resource
#
# Security Considerations:
# - Delegated accounts gain significant control over organization
# - Test policies thoroughly before applying in production
# - Use condition keys to limit delegation scope
# - Monitor delegated account activities with CloudTrail
# - Implement MFA and strong authentication for delegated accounts
# - Regular audit of delegated permissions
#
# Cost Implications:
# - No direct cost for the resource policy itself
# - Consider costs of resources created by delegated administrators
# - Use tags for cost allocation tracking
#
# Operational Considerations:
# - Document delegation relationships clearly
# - Implement change management for policy updates
# - Test delegation in non-production first
# - Have rollback procedures ready
# - Coordinate with delegated account administrators
# - Monitor for privilege escalation attempts
#
# Integration with Other Services:
# - AWS CloudTrail: Log all Organizations API calls
# - AWS IAM: Manage roles and permissions in delegated accounts
# - AWS Config: Monitor compliance of delegation policies
# - AWS Security Hub: Aggregate security findings
# - AWS Control Tower: May conflict with custom delegation policies
#
# Troubleshooting:
# - If delegation not working, verify IAM permissions in delegated account
# - Check CloudTrail for access denied errors
# - Ensure policy syntax is valid JSON
# - Verify principal ARNs are correct
# - Test with minimal permissions first, then expand
# - Review condition keys if access unexpectedly denied
