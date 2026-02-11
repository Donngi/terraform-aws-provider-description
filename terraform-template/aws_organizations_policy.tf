################################################################################
# AWS Organizations Policy
################################################################################
# Provides a resource to manage an AWS Organizations policy.
#
# AWS Organizations supports multiple policy types for centralized governance:
#
# Authorization Policies (Permissions Guardrails):
# - SERVICE_CONTROL_POLICY (SCP): Controls maximum permissions for IAM principals
# - RESOURCE_CONTROL_POLICY (RCP): Controls maximum permissions for resources
#
# Management Policies (Configuration & Compliance):
# - DECLARATIVE_POLICY_EC2: Enforces desired EC2/VPC configurations at scale
# - TAG_POLICY: Standardizes tags across resources
# - BACKUP_POLICY: Manages backup plans centrally
# - AISERVICES_OPT_OUT_POLICY: Controls AWS AI services data collection
# - BEDROCK_POLICY: Enforces Amazon Bedrock Guardrails
# - CHATBOT_POLICY: Controls chat application access
# - INSPECTOR_POLICY: Manages Amazon Inspector across accounts
# - SECURITYHUB_POLICY: Addresses security coverage gaps
# - S3_POLICY: Manages S3 resource configurations
# - UPGRADE_ROLLOUT_POLICY: Manages automatic upgrades across resources
#
# Policy Characteristics:
# - Authorization policies: Max 5 policies/attachment, 5120 chars, affects member accounts only
# - Management policies: Max 10 policies/attachment, 10000 chars, can affect management account
# - Policies are inherited hierarchically: Organization Root → OUs → Accounts
# - Effective policy is the aggregation of inherited + directly attached policies
#
# References:
# - https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies.html
# - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/organizations_policy

resource "aws_organizations_policy" "example" {
  #-----------------------------------------------------------------------------
  # Required Arguments
  #-----------------------------------------------------------------------------

  # (Required) The friendly name to assign to the policy.
  # - Must be unique within your organization for the given policy type
  # - Can contain alphanumeric characters, hyphens, and underscores
  # - Used for identification in AWS Organizations console and API operations
  name = "example-scp-policy"

  # (Required) The policy content in JSON format.
  # The required structure varies by policy type:
  #
  # SERVICE_CONTROL_POLICY (SCP):
  # - JSON text specifying permissions that admins in attached accounts can delegate
  # - Defines maximum available permissions (does not grant permissions)
  # - Syntax: https://docs.aws.amazon.com/organizations/latest/userguide/orgs_reference_scp-syntax.html
  #
  # RESOURCE_CONTROL_POLICY (RCP):
  # - JSON text defining maximum permissions for resources in member accounts
  # - Controls which identities can access resources
  # - Syntax: https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_rcps_syntax.html
  #
  # DECLARATIVE_POLICY_EC2:
  # - JSON object declaring desired EC2/VPC configurations
  # - Enforced at service level (VPC Block Public Access, Serial Console, AMI settings, etc.)
  # - Syntax: https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_declarative_syntax.html
  #
  # TAG_POLICY:
  # - JSON text defining standardized tags and their allowed values
  # - Example: https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_example-tag-policies.html
  #
  # BACKUP_POLICY:
  # - JSON text defining backup plans and rules
  # - Syntax: https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_backup_syntax.html
  #
  # AISERVICES_OPT_OUT_POLICY:
  # - JSON text controlling AWS AI services data collection
  # - Syntax: https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_ai-opt-out_syntax.html
  #
  # BEDROCK_POLICY:
  # - JSON text enforcing Amazon Bedrock Guardrails
  # - Syntax: https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_bedrock_syntax.html
  #
  # CHATBOT_POLICY:
  # - JSON text controlling chat application access to organization accounts
  # - Syntax: https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_chatbot_syntax.html
  #
  # INSPECTOR_POLICY:
  # - JSON text for central Amazon Inspector management
  # - Syntax: https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_inspector_syntax.html
  #
  # SECURITYHUB_POLICY:
  # - JSON text addressing security coverage gaps
  # - Syntax: https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_security_hub_syntax.html
  #
  # S3_POLICY:
  # - JSON text managing S3 resource configurations
  # - Syntax: https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_s3_syntax.html
  #
  # UPGRADE_ROLLOUT_POLICY:
  # - JSON text managing staggered automatic upgrades
  # - Syntax: https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_upgrade_syntax.html
  #
  # Best Practice: Use data.aws_iam_policy_document for SCPs/RCPs to ensure valid JSON
  content = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "*"
        Resource = "*"
      }
    ]
  })

  #-----------------------------------------------------------------------------
  # Optional Arguments
  #-----------------------------------------------------------------------------

  # (Optional) A description to assign to the policy.
  # - Helps document the policy's purpose and scope
  # - Visible in AWS Organizations console and API responses
  # - Maximum length: 512 characters
  description = "Example service control policy for demonstration purposes"

  # (Optional) The type of policy to create.
  # Valid values:
  # - AISERVICES_OPT_OUT_POLICY: Control AI services data collection
  # - BACKUP_POLICY: Central backup plan management
  # - BEDROCK_POLICY: Enforce Amazon Bedrock Guardrails
  # - CHATBOT_POLICY: Control chat application access
  # - DECLARATIVE_POLICY_EC2: Enforce EC2/VPC configurations
  # - INSPECTOR_POLICY: Central Amazon Inspector management
  # - RESOURCE_CONTROL_POLICY: Maximum resource permissions (RCP)
  # - S3_POLICY: Manage S3 resource configurations
  # - SECURITYHUB_POLICY: Address security coverage gaps
  # - SERVICE_CONTROL_POLICY: Maximum IAM permissions (SCP, default)
  # - TAG_POLICY: Standardize resource tags
  # - UPGRADE_ROLLOUT_POLICY: Manage automatic upgrades
  #
  # Default: SERVICE_CONTROL_POLICY
  #
  # Important Notes:
  # - Policy type must be enabled in the organization root before creating policies
  # - Cannot be changed after policy creation (requires policy replacement)
  # - Each policy type has different size limits and attachment quotas
  type = "SERVICE_CONTROL_POLICY"

  # (Optional) If set to true, destroy will NOT delete the policy.
  # - The resource is only removed from Terraform state
  # - Useful when policies must be preserved to meet AWS minimum requirements
  # - Some organizations require at least 1 attached policy (e.g., for compliance)
  #
  # Use Cases:
  # - Preserving critical governance policies during infrastructure cleanup
  # - Transitioning policy management from Terraform to another system
  # - Meeting regulatory requirements for persistent policy attachment
  #
  # Default: false (policy is deleted on destroy)
  skip_destroy = false

  # (Optional) Key-value map of resource tags.
  # - Tags are propagated to the policy resource
  # - Can be used for cost allocation, access control, and organization
  # - Maximum 50 tags per resource
  # - Tag keys and values are case-sensitive
  #
  # If configured with a provider default_tags configuration block, tags with
  # matching keys will overwrite those defined at the provider level.
  #
  # Best Practices:
  # - Use consistent tagging strategy across all policies
  # - Include tags for: Environment, Owner, CostCenter, Compliance
  # - Tag policies can enforce tag standardization across the organization
  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
    PolicyType  = "scp"
    Purpose     = "example-governance"
  }

  # tags_all - Computed attribute (not configurable)
  # A map of tags assigned to the resource, including those inherited from the
  # provider default_tags configuration block.
}

################################################################################
# Computed Attributes (Available after creation)
################################################################################
# These attributes are exported and can be referenced in other resources:
#
# - id: The unique identifier (ID) of the policy
#   Example: p-12345678
#   Usage: aws_organizations_policy.example.id
#
# - arn: Amazon Resource Name (ARN) of the policy
#   Format: arn:aws:organizations::123456789012:policy/o-exampleorgid/service_control_policy/p-exampleid
#   Usage: aws_organizations_policy.example.arn
#
# - tags_all: Map of all tags including provider default_tags
#   Usage: aws_organizations_policy.example.tags_all

################################################################################
# Common Use Cases & Examples
################################################################################

# Example 1: Service Control Policy (SCP) with IAM Policy Document
# Use data source to build valid SCP JSON
data "aws_iam_policy_document" "deny_root_account" {
  statement {
    effect = "Deny"
    actions = [
      "s3:DeleteBucket",
      "s3:DeleteBucketPolicy",
    ]
    resources = ["*"]

    condition {
      test     = "StringLike"
      variable = "aws:PrincipalArn"
      values   = ["arn:aws:iam::*:root"]
    }
  }
}

resource "aws_organizations_policy" "deny_root_account" {
  name        = "deny-root-account-s3-delete"
  description = "Prevent root account from deleting S3 buckets"
  type        = "SERVICE_CONTROL_POLICY"
  content     = data.aws_iam_policy_document.deny_root_account.json

  tags = {
    SecurityControl = "preventive"
    Severity        = "high"
  }
}

# Example 2: Tag Policy for standardization
resource "aws_organizations_policy" "tag_policy" {
  name        = "require-cost-center-tag"
  description = "Enforce CostCenter tag on all resources"
  type        = "TAG_POLICY"

  content = jsonencode({
    tags = {
      CostCenter = {
        tag_key = {
          "@@assign" = "CostCenter"
        }
        tag_value = {
          "@@assign" = ["Engineering", "Marketing", "Sales", "Operations"]
        }
        enforced_for = {
          "@@assign" = ["ec2:instance", "s3:bucket"]
        }
      }
    }
  })

  tags = {
    PolicyCategory = "compliance"
  }
}

# Example 3: Backup Policy for automated backups
resource "aws_organizations_policy" "backup_policy" {
  name        = "daily-backup-policy"
  description = "Daily backup plan for production resources"
  type        = "BACKUP_POLICY"

  content = jsonencode({
    plans = {
      DailyBackup = {
        regions = {
          "@@assign" = ["us-east-1", "us-west-2"]
        }
        rules = {
          DailyBackupRule = {
            schedule_expression = {
              "@@assign" = "cron(0 5 ? * * *)"
            }
            start_backup_window_minutes = {
              "@@assign" = "480"
            }
            target_backup_vault_name = {
              "@@assign" = "Default"
            }
            lifecycle = {
              delete_after_days = {
                "@@assign" = "30"
              }
            }
          }
        }
      }
    }
  })

  tags = {
    BackupFrequency = "daily"
    RetentionDays   = "30"
  }
}

# Example 4: AI Services Opt-Out Policy
resource "aws_organizations_policy" "ai_opt_out" {
  name        = "ai-services-opt-out"
  description = "Opt out of AWS AI services data collection"
  type        = "AISERVICES_OPT_OUT_POLICY"

  content = jsonencode({
    services = {
      "@@operators_allowed_for_child_policies" = ["@@none"]
      default = {
        "@@assign" = "optOut"
      }
    }
  })

  tags = {
    DataPrivacy = "strict"
  }
}

# Example 5: Resource Control Policy (RCP)
resource "aws_organizations_policy" "rcp_example" {
  name        = "prevent-external-s3-access"
  description = "Prevent external principals from accessing S3 buckets"
  type        = "RESOURCE_CONTROL_POLICY"

  content = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Deny"
        Action   = "s3:*"
        Resource = "*"
        Condition = {
          StringNotEquals = {
            "aws:PrincipalOrgID" = "o-exampleorgid"
          }
        }
      }
    ]
  })

  tags = {
    SecurityControl = "data-perimeter"
  }
}

# Example 6: Declarative Policy for EC2
resource "aws_organizations_policy" "declarative_ec2" {
  name        = "enforce-imdsv2"
  description = "Enforce IMDSv2 for all EC2 instances"
  type        = "DECLARATIVE_POLICY_EC2"

  content = jsonencode({
    type = "declarative"
    policies = {
      instance_metadata_defaults = {
        http_tokens = {
          "@@assign" = "required"
        }
        http_put_response_hop_limit = {
          "@@assign" = 1
        }
      }
    }
  })

  tags = {
    SecurityStandard = "IMDSv2"
  }
}

################################################################################
# Important Considerations
################################################################################
# 1. Policy Type Enablement:
#    - Policy types must be enabled in the organization root before creating policies
#    - Use aws_organizations_policy_type resource or console to enable types
#    - Enabling policy types requires management account permissions
#
# 2. Testing & Validation:
#    - STRONGLY RECOMMENDED: Test policies in non-production OUs first
#    - Use AWS IAM Access Analyzer to validate policy syntax
#    - For SCPs/RCPs: Test with a single account before broad attachment
#    - Monitor CloudTrail for policy-related denials
#
# 3. Policy Attachment:
#    - Creating a policy does NOT automatically attach it
#    - Use aws_organizations_policy_attachment to attach to roots/OUs/accounts
#    - Authorization policies: Max 5 attachments per entity
#    - Management policies: Max 10 attachments per entity
#
# 4. Policy Inheritance:
#    - Policies are inherited hierarchically (Root → OU → Account)
#    - Effective policy = inherited policies + directly attached policies
#    - SCPs are cumulative AND (all must allow)
#    - Management policies can use operators for inheritance control
#
# 5. Size Limits:
#    - Authorization policies (SCP, RCP): 5,120 characters
#    - Management policies: 10,000 characters
#    - Use policy optimization techniques to stay within limits
#    - Remove unnecessary whitespace in JSON
#
# 6. Deletion Protection:
#    - Some policies may be protected from deletion due to attachment requirements
#    - Use skip_destroy = true to preserve critical policies
#    - Cannot delete a policy that is attached (detach first)
#
# 7. Management Account:
#    - SCPs and RCPs do NOT affect the management account
#    - Management policies CAN affect the management account
#    - Be careful with declarative policies applied to management account
#
# 8. Service-Specific Considerations:
#    - SCPs: Don't restrict service-linked roles or AWS managed keys
#    - RCPs: Only work with specific AWS services (S3, KMS, SQS, Secrets Manager, etc.)
#    - Declarative policies: Currently support EC2/VPC services only
#    - Tag policies: Require tag policy enforcement in AWS Config
#
# 9. Monitoring & Auditing:
#    - Use CloudTrail to track policy creation, updates, and deletions
#    - Monitor IAM Access Analyzer for external access findings before RCPs
#    - Use account status reports for declarative policy compliance
#
# 10. Data Perimeter Strategy:
#     - Combine SCPs and RCPs for comprehensive data perimeter
#     - SCPs control identity-based permissions
#     - RCPs control resource-based permissions
#     - Together they enforce identity, resource, and network perimeters
