################################################################################
# aws_redshift_resource_policy
################################################################################
# Creates a new Amazon Redshift Resource Policy.
#
# Resource Policy enables you to control access to Redshift resources by defining
# permissions that specify who can access the resource and what actions they can perform.
# This is particularly useful for managing cross-account access and integrations.
#
# AWS Documentation:
# - https://docs.aws.amazon.com/redshift/latest/mgmt/redshift-iam-access-control-identity-based.html
# - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/redshift_resource_policy
################################################################################

resource "aws_redshift_resource_policy" "example" {
  ################################################################################
  # Required Arguments
  ################################################################################

  # (Required) The Amazon Resource Name (ARN) of the account to create or update
  # a resource policy for.
  #
  # Type: string
  #
  # Typical values:
  # - Redshift cluster namespace ARN: "arn:aws:redshift:us-east-1:123456789012:namespace:xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  # - Use cluster_namespace_arn attribute from aws_redshift_cluster resource
  #
  # Notes:
  # - This ARN identifies the Redshift namespace for which the policy applies
  # - The policy controls access to the namespace and its resources
  # - Must be a valid Redshift namespace ARN
  resource_arn = "arn:aws:redshift:us-east-1:123456789012:namespace:xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

  # (Required) The content of the resource policy being updated.
  #
  # Type: string (JSON-encoded IAM policy document)
  #
  # Best practices:
  # - Use jsonencode() function for better readability and syntax validation
  # - Define standard IAM policy elements: Version, Statement, Effect, Principal, Action, Resource
  # - Limit permissions to least privilege principle
  # - Use specific ARNs in Resource rather than wildcards when possible
  #
  # Common Actions:
  # - redshift:CreateInboundIntegration - Allow cross-account data sharing integrations
  # - redshift:AuthorizeDataShare - Allow data share authorization
  # - redshift:DescribeDataShares - Allow viewing data shares
  #
  # Example: Allow cross-account access for Redshift integrations
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowInboundIntegration"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::123456789012:root"
        }
        Action = [
          "redshift:CreateInboundIntegration"
        ]
        Resource = "arn:aws:redshift:us-east-1:123456789012:namespace:xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
      }
    ]
  })

  ################################################################################
  # Optional Arguments
  ################################################################################

  # (Optional) Region where this resource will be managed.
  #
  # Type: string
  # Default: Region set in the provider configuration
  #
  # Typical values:
  # - "us-east-1", "us-west-2", "eu-west-1", "ap-northeast-1"
  #
  # Notes:
  # - Usually omitted to use the provider's default region
  # - Useful when managing resources across multiple regions
  # - Must match the region of the resource_arn
  # region = "us-east-1"
}

################################################################################
# Attributes Reference
################################################################################
# In addition to all arguments above, the following attributes are exported:
#
# - id - The Amazon Resource Name (ARN) of the account to create or update
#   a resource policy for (same as resource_arn).
#   Example: "arn:aws:redshift:us-east-1:123456789012:namespace:xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
#
# Access via: aws_redshift_resource_policy.example.id
################################################################################

################################################################################
# Example: Complete Redshift Resource Policy for Cross-Account Data Sharing
################################################################################
/*
resource "aws_redshift_cluster" "producer" {
  cluster_identifier = "producer-cluster"
  database_name      = "mydb"
  master_username    = "admin"
  master_password    = "MustBe8Characters"
  node_type          = "dc2.large"
  cluster_type       = "single-node"
  skip_final_snapshot = true
}

resource "aws_redshift_resource_policy" "data_sharing" {
  resource_arn = aws_redshift_cluster.producer.cluster_namespace_arn

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowDataShareFromConsumerAccount"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::987654321098:root"  # Consumer account
        }
        Action = [
          "redshift:CreateInboundIntegration"
        ]
        Resource = aws_redshift_cluster.producer.cluster_namespace_arn
      },
      {
        Sid    = "AllowDataShareAuthorization"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::987654321098:root"
        }
        Action = [
          "redshift:AuthorizeDataShare"
        ]
        Resource = aws_redshift_cluster.producer.cluster_namespace_arn
        Condition = {
          StringEquals = {
            "redshift:ConsumerIdentifier" = "987654321098"
          }
        }
      }
    ]
  })
}
*/

################################################################################
# Example: Multi-Account Access Policy
################################################################################
/*
resource "aws_redshift_resource_policy" "multi_account" {
  resource_arn = aws_redshift_cluster.example.cluster_namespace_arn

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowMultipleAccounts"
        Effect = "Allow"
        Principal = {
          AWS = [
            "arn:aws:iam::111111111111:root",
            "arn:aws:iam::222222222222:root",
            "arn:aws:iam::333333333333:root"
          ]
        }
        Action = [
          "redshift:CreateInboundIntegration",
          "redshift:DescribeInboundIntegrations"
        ]
        Resource = aws_redshift_cluster.example.cluster_namespace_arn
      }
    ]
  })
}
*/

################################################################################
# Example: Organization-Wide Access
################################################################################
/*
resource "aws_redshift_resource_policy" "organization" {
  resource_arn = aws_redshift_cluster.example.cluster_namespace_arn

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowOrganizationAccess"
        Effect = "Allow"
        Principal = "*"
        Action = [
          "redshift:CreateInboundIntegration"
        ]
        Resource = aws_redshift_cluster.example.cluster_namespace_arn
        Condition = {
          StringEquals = {
            "aws:PrincipalOrgID" = "o-xxxxxxxxxx"
          }
        }
      }
    ]
  })
}
*/

################################################################################
# Common Use Cases & Best Practices
################################################################################

# Use Case 1: Cross-Account Data Sharing
# - Enable data sharing between Redshift clusters in different AWS accounts
# - Use CreateInboundIntegration action for allowing consumer accounts
# - Specify consumer account ARNs in Principal element

# Use Case 2: Service-to-Service Integration
# - Allow AWS services to access Redshift namespaces
# - Use appropriate service principals (e.g., redshift.amazonaws.com)
# - Limit actions to specific service requirements

# Use Case 3: Organization-Wide Policies
# - Use aws:PrincipalOrgID condition for organization-wide access
# - Simplifies management across multiple accounts
# - Reduces need for individual account ARNs

# Best Practices:
# 1. Principle of Least Privilege
#    - Grant only necessary permissions
#    - Use specific actions instead of wildcards
#    - Limit resource access to specific ARNs
#
# 2. Use Conditions
#    - Add condition keys for fine-grained control
#    - Validate consumer identifiers
#    - Restrict by IP, VPC, or organization
#
# 3. Policy Versioning
#    - Always use Version "2012-10-17" for latest features
#    - Document policy changes with Sid (Statement ID)
#    - Use descriptive statement IDs for clarity
#
# 4. Security Considerations
#    - Avoid using Principal "*" without conditions
#    - Regularly review and audit policies
#    - Use AWS Organizations for centralized control
#    - Enable CloudTrail for policy change tracking
#
# 5. Testing
#    - Test policies in non-production environments first
#    - Validate cross-account access before applying
#    - Use IAM policy simulator when possible

################################################################################
# Import
################################################################################
# Existing Redshift resource policies can be imported using the resource ARN.
#
# Example:
# terraform import aws_redshift_resource_policy.example arn:aws:redshift:us-east-1:123456789012:namespace:xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
#
# Notes:
# - The ARN must match an existing Redshift namespace
# - Policy content will be imported as-is from AWS
# - Verify imported policy matches expected configuration

################################################################################
# Additional Notes
################################################################################

# Limitations:
# - Resource policies only apply to Redshift namespaces
# - Cannot be applied to individual clusters or databases
# - Policy size limit is 20 KB (AWS limit)
# - Maximum of 10 statements per policy recommended for readability

# Related Resources:
# - aws_redshift_cluster - Creates a Redshift cluster with namespace
# - aws_redshift_data_share_authorization - Manages data share authorizations
# - aws_redshift_data_share_consumer_association - Associates consumer with data share

# Monitoring:
# - CloudTrail events: CreateResourcePolicy, PutResourcePolicy, DeleteResourcePolicy
# - CloudWatch metrics: N/A (policy changes are audit events only)
# - AWS Config: Track policy configuration changes

# Cost Considerations:
# - No additional cost for resource policies
# - Costs apply to underlying Redshift resources only
# - Data transfer charges may apply for cross-region/cross-account access
