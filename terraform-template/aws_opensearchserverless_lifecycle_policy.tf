################################################################################
# AWS OpenSearch Serverless Lifecycle Policy
################################################################################
#
# Terraform resource for managing an AWS OpenSearch Serverless Lifecycle Policy.
# Lifecycle policies define data retention and deletion rules for time series
# collections in OpenSearch Serverless.
#
# AWS Documentation:
# https://docs.aws.amazon.com/opensearch-service/latest/developerguide/serverless-lifecycle.html
#
# Terraform Documentation:
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/opensearchserverless_lifecycle_policy
#
# Provider Version: 6.28.0
# Generated: 2025-02-03
#
################################################################################

resource "aws_opensearchserverless_lifecycle_policy" "example" {
  ################################################################################
  # Required Arguments
  ################################################################################

  # Name of the lifecycle policy
  # - Must be 3-32 characters long
  # - Must match pattern: [a-z][a-z0-9-]+
  # - Must be unique within your AWS account and region
  name = "example-lifecycle-policy"

  # Type of lifecycle policy
  # - Currently only "retention" is supported
  # - Defines how long data is retained before deletion
  type = "retention"

  # JSON policy document defining retention rules
  # - Contains an array of "Rules" that specify retention periods
  # - Each rule can target specific index patterns
  # - Retention period: 24 hours to 3650 days (10 years) or indefinite
  #
  # Rule Structure:
  # - ResourceType: Must be "index"
  # - Resource: Array of index patterns (supports wildcards)
  # - MinIndexRetention: Minimum retention period (e.g., "81d", "24h")
  # - NoMinIndexRetention: Set to true for indefinite retention
  #
  # Policy Precedence:
  # - More specific resource patterns take precedence over general patterns
  # - Example: "index/sales/orders*" overrides "index/sales/*"
  policy = jsonencode({
    "Rules" : [
      {
        # Retain inventory data for 81 days
        "ResourceType" : "index",
        "Resource" : [
          "index/autoparts-inventory/*"
        ],
        "MinIndexRetention" : "81d"
      },
      {
        # Retain sales orders indefinitely
        "ResourceType" : "index",
        "Resource" : [
          "index/sales/orders*"
        ],
        "NoMinIndexRetention" : true
      },
      {
        # Retain logs for 30 days
        "ResourceType" : "index",
        "Resource" : [
          "index/logs/*"
        ],
        "MinIndexRetention" : "30d"
      },
      {
        # Retain metrics for 7 days (minimum: 24 hours)
        "ResourceType" : "index",
        "Resource" : [
          "index/metrics/*"
        ],
        "MinIndexRetention" : "7d"
      }
    ]
  })

  ################################################################################
  # Optional Arguments
  ################################################################################

  # Description of the lifecycle policy
  # - Provides context about the policy's purpose
  # - Maximum 1000 characters
  description = "Lifecycle policy for managing data retention in OpenSearch Serverless collections"

  # AWS Region where the policy will be managed
  # - Defaults to the provider's configured region
  # - Lifecycle policies are region-specific
  # region = "us-east-1"

  ################################################################################
  # Tags
  ################################################################################

  # Note: OpenSearch Serverless lifecycle policies do not support tags
  # Tags must be applied at the collection level instead
}

################################################################################
# Outputs
################################################################################

output "lifecycle_policy_name" {
  description = "Name of the lifecycle policy"
  value       = aws_opensearchserverless_lifecycle_policy.example.name
}

output "lifecycle_policy_version" {
  description = "Version of the lifecycle policy"
  value       = aws_opensearchserverless_lifecycle_policy.example.policy_version
}

output "lifecycle_policy_type" {
  description = "Type of the lifecycle policy"
  value       = aws_opensearchserverless_lifecycle_policy.example.type
}

################################################################################
# Usage Notes
################################################################################
#
# 1. PREREQUISITES
#    - An OpenSearch Serverless time series collection must exist
#    - Lifecycle policies only apply to time series collections (not search or vector)
#
# 2. IAM PERMISSIONS REQUIRED
#    - aoss:CreateLifecyclePolicy
#    - aoss:UpdateLifecyclePolicy
#    - aoss:BatchGetLifecyclePolicy
#    - aoss:ListLifecyclePolicies
#    - aoss:DeleteLifecyclePolicy
#
# 3. RETENTION PERIOD FORMATS
#    - Hours: "24h", "48h" (minimum 24 hours)
#    - Days: "1d", "7d", "30d", "81d", "365d" (maximum 3650 days)
#    - Indefinite: Use "NoMinIndexRetention": true
#
# 4. POLICY PRECEDENCE RULES
#    - When multiple rules match the same index, the most specific pattern wins
#    - Example: "index/app/prod/*" > "index/app/*" > "index/*"
#
# 5. DATA DELETION
#    - OpenSearch Serverless deletes data automatically on a best-effort basis
#    - Documents are retained for AT LEAST the specified retention period
#    - Actual deletion may occur slightly after the retention period expires
#
# 6. POLICY UPDATES
#    - Updates to the policy increment the policy_version
#    - Changes apply to new data immediately
#    - Existing data follows the new rules from the update time forward
#
# 7. COLLECTION ASSOCIATION
#    - Lifecycle policies apply automatically to matching indexes in collections
#    - No explicit association is needed
#    - Policies match indexes based on the Resource patterns in rules
#
# 8. COST CONSIDERATIONS
#    - Longer retention periods increase storage costs
#    - Review retention requirements regularly
#    - Use appropriate retention periods based on compliance needs
#
# 9. MONITORING
#    - Monitor policy effectiveness using CloudWatch metrics
#    - Track index sizes and document counts
#    - Set up alarms for unexpected storage growth
#
# 10. BEST PRACTICES
#     - Use specific index patterns to avoid unintended matches
#     - Document the business rationale for each retention period
#     - Align retention periods with compliance requirements
#     - Test policies in non-production environments first
#     - Use separate policies for different data sensitivity levels
#
################################################################################
# Example: Policy for Multiple Use Cases
################################################################################
#
# resource "aws_opensearchserverless_lifecycle_policy" "multi_tier" {
#   name        = "multi-tier-retention"
#   type        = "retention"
#   description = "Tiered retention policy for different data types"
#
#   policy = jsonencode({
#     "Rules" : [
#       {
#         # Critical business data - 7 years retention (regulatory compliance)
#         "ResourceType" : "index",
#         "Resource" : [
#           "index/transactions/*",
#           "index/audit/*"
#         ],
#         "MinIndexRetention" : "2555d" # ~7 years
#       },
#       {
#         # Application logs - 90 days retention
#         "ResourceType" : "index",
#         "Resource" : [
#           "index/logs/application/*"
#         ],
#         "MinIndexRetention" : "90d"
#       },
#       {
#         # Debug logs - 7 days retention
#         "ResourceType" : "index",
#         "Resource" : [
#           "index/logs/debug/*"
#         ],
#         "MinIndexRetention" : "7d"
#       },
#       {
#         # Temporary test data - minimum retention (24 hours)
#         "ResourceType" : "index",
#         "Resource" : [
#           "index/test/*"
#         ],
#         "MinIndexRetention" : "24h"
#       },
#       {
#         # Archive data - indefinite retention
#         "ResourceType" : "index",
#         "Resource" : [
#           "index/archive/*"
#         ],
#         "NoMinIndexRetention" : true
#       }
#     ]
#   })
# }
#
################################################################################
# Example: Policy with Regional Configuration
################################################################################
#
# resource "aws_opensearchserverless_lifecycle_policy" "regional" {
#   name        = "regional-lifecycle-policy"
#   type        = "retention"
#   description = "Lifecycle policy for us-west-2 region"
#   region      = "us-west-2"
#
#   policy = jsonencode({
#     "Rules" : [
#       {
#         "ResourceType" : "index",
#         "Resource" : [
#           "index/west-coast-logs/*"
#         ],
#         "MinIndexRetention" : "30d"
#       }
#     ]
#   })
# }
#
################################################################################
# Example: Compliance-Focused Policy
################################################################################
#
# resource "aws_opensearchserverless_lifecycle_policy" "compliance" {
#   name        = "compliance-retention"
#   type        = "retention"
#   description = "Data retention policy aligned with compliance requirements"
#
#   policy = jsonencode({
#     "Rules" : [
#       {
#         # Financial records - 7 years (SOX, FINRA compliance)
#         "ResourceType" : "index",
#         "Resource" : [
#           "index/financial/transactions/*",
#           "index/financial/statements/*"
#         ],
#         "MinIndexRetention" : "2555d"
#       },
#       {
#         # Healthcare records - 6 years (HIPAA compliance)
#         "ResourceType" : "index",
#         "Resource" : [
#           "index/healthcare/patient-records/*"
#         ],
#         "MinIndexRetention" : "2190d"
#       },
#       {
#         # Security logs - 1 year (PCI DSS compliance)
#         "ResourceType" : "index",
#         "Resource" : [
#           "index/security/access-logs/*",
#           "index/security/audit-trail/*"
#         ],
#         "MinIndexRetention" : "365d"
#       },
#       {
#         # GDPR compliant - short retention for personal data
#         "ResourceType" : "index",
#         "Resource" : [
#           "index/user/personal-data/*"
#         ],
#         "MinIndexRetention" : "90d"
#       }
#     ]
#   })
# }
#
################################################################################
# Example: Environment-Specific Policies
################################################################################
#
# # Production environment - longer retention
# resource "aws_opensearchserverless_lifecycle_policy" "production" {
#   name        = "prod-lifecycle-policy"
#   type        = "retention"
#   description = "Production data retention policy"
#
#   policy = jsonencode({
#     "Rules" : [
#       {
#         "ResourceType" : "index",
#         "Resource" : [
#           "index/prod/*"
#         ],
#         "MinIndexRetention" : "365d"
#       }
#     ]
#   })
# }
#
# # Development environment - shorter retention
# resource "aws_opensearchserverless_lifecycle_policy" "development" {
#   name        = "dev-lifecycle-policy"
#   type        = "retention"
#   description = "Development data retention policy"
#
#   policy = jsonencode({
#     "Rules" : [
#       {
#         "ResourceType" : "index",
#         "Resource" : [
#           "index/dev/*"
#         ],
#         "MinIndexRetention" : "7d"
#       }
#     ]
#   })
# }
#
# # Staging environment - moderate retention
# resource "aws_opensearchserverless_lifecycle_policy" "staging" {
#   name        = "staging-lifecycle-policy"
#   type        = "retention"
#   description = "Staging data retention policy"
#
#   policy = jsonencode({
#     "Rules" : [
#       {
#         "ResourceType" : "index",
#         "Resource" : [
#           "index/staging/*"
#         ],
#         "MinIndexRetention" : "30d"
#       }
#     ]
#   })
# }
#
################################################################################
# Troubleshooting and Common Issues
################################################################################
#
# 1. Policy Not Applied
#    Problem: Lifecycle policy doesn't seem to affect indexes
#    Solutions:
#    - Verify the collection type is "TIMESERIES" (lifecycle policies only work with time series)
#    - Check that the Resource patterns match your index names exactly
#    - Ensure the collection and indexes exist before applying the policy
#    - Use aws opensearchserverless list-lifecycle-policies to verify policy exists
#
# 2. Data Not Deleting
#    Problem: Data persists beyond the retention period
#    Solutions:
#    - Deletion is best-effort and may be delayed
#    - Check that the retention period is calculated from index creation time
#    - Verify the policy is active using BatchGetLifecyclePolicy API
#    - Allow additional time for background deletion processes
#
# 3. Pattern Matching Issues
#    Problem: Policy applies to wrong indexes or doesn't match expected indexes
#    Solutions:
#    - Test patterns using more specific rules first
#    - Remember that wildcards only match within a path segment
#    - Use "index/collection-name/prefix*" not "index/collection-name/*prefix"
#    - Check for typos in collection and index names
#
# 4. Policy Update Not Taking Effect
#    Problem: Changes to policy don't seem to apply
#    Solutions:
#    - Verify policy_version incremented after update
#    - Wait a few minutes for policy propagation
#    - New rules only affect data indexed after the update
#    - Consider creating a new policy with a different name if issues persist
#
# 5. Permission Errors
#    Problem: Unable to create or update policy
#    Solutions:
#    - Verify IAM permissions include aoss:CreateLifecyclePolicy
#    - Check that the principal has permissions for the target region
#    - Ensure service quotas are not exceeded
#    - Review CloudTrail logs for detailed error messages
#
# 6. Conflicting Policies
#    Problem: Multiple policies seem to conflict
#    Solutions:
#    - Only one policy can match each index
#    - More specific patterns override less specific ones
#    - Use unique Resource patterns for each policy
#    - Review all policies using ListLifecyclePolicies to identify conflicts
#
# 7. Region Availability
#    Problem: Service not available in region
#    Solutions:
#    - OpenSearch Serverless is not available in all regions
#    - Check AWS documentation for supported regions
#    - Consider using a different region if necessary
#    - Verify region parameter matches collection region
#
################################################################################
