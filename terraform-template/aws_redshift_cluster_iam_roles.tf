################################################################################
# AWS Redshift Cluster IAM Roles
################################################################################
# Provides a Redshift Cluster IAM Roles resource for managing IAM role associations
# with Amazon Redshift clusters. This resource allows you to attach IAM roles to
# existing Redshift clusters, enabling the cluster to access AWS services on your behalf.
#
# Use Cases:
# - Attach IAM roles to Redshift clusters for accessing S3, Glue, and other AWS services
# - Manage COPY and UNLOAD operations that require access to S3 buckets
# - Configure default IAM role for the cluster
# - Support federated query and data lake access scenarios
#
# Important Notes:
# - Maximum of 10 IAM roles can be associated with a cluster at any time
# - A cluster's default IAM role can be managed by both this resource and aws_redshift_cluster
#   Do NOT configure different values in both places to avoid conflicts
# - Requires iam:PassRole permission to associate IAM roles with the cluster
# - IAM roles must have appropriate trust relationships with Redshift service
#
# References:
# - AWS Documentation: https://docs.aws.amazon.com/redshift/latest/mgmt/copy-unload-iam-role-associating-with-clusters.html
# - Terraform Provider: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/redshift_cluster_iam_roles

resource "aws_redshift_cluster_iam_roles" "example" {
  ################################################################################
  # Required Arguments
  ################################################################################

  # cluster_identifier - (Required) The name of the Redshift Cluster to associate IAM roles with
  # Must be an existing Redshift cluster identifier
  # Type: string
  cluster_identifier = "my-redshift-cluster"

  ################################################################################
  # Optional Arguments
  ################################################################################

  # iam_role_arns - (Optional) A list of IAM Role ARNs to associate with the cluster
  # Maximum of 10 IAM roles can be associated with the cluster at any time
  # These roles can be used by the cluster to access AWS services like S3, Glue, etc.
  # Type: set of strings
  # Default: computed (existing roles will be preserved if not specified)
  iam_role_arns = [
    "arn:aws:iam::123456789012:role/RedshiftS3AccessRole",
    "arn:aws:iam::123456789012:role/RedshiftGlueAccessRole"
  ]

  # default_iam_role_arn - (Optional) The Amazon Resource Name (ARN) for the IAM role
  # that was set as default for the cluster
  # This is the role used by default for COPY and UNLOAD operations when no role is specified
  # Must be one of the roles specified in iam_role_arns
  # Type: string
  # Default: computed (existing default will be preserved if not specified)
  # WARNING: Do not configure this if already set in aws_redshift_cluster resource
  # default_iam_role_arn = "arn:aws:iam::123456789012:role/RedshiftS3AccessRole"

  # region - (Optional) AWS region where this resource will be managed
  # Type: string
  # Default: The region set in the provider configuration
  # Reference: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  ################################################################################
  # Timeouts Configuration
  ################################################################################
  # Configure custom timeouts for cluster IAM role operations
  # These operations can take time depending on cluster size and current workload

  timeouts {
    # create - (Optional) Maximum time to wait for IAM roles to be associated
    # Default: 10m
    # create = "15m"

    # update - (Optional) Maximum time to wait for IAM roles to be updated
    # Default: 10m
    # update = "15m"

    # delete - (Optional) Maximum time to wait for IAM roles to be disassociated
    # Default: 10m
    # delete = "15m"
  }

  ################################################################################
  # Computed Attributes (Available after apply)
  ################################################################################
  # id - The Redshift Cluster ID
}

################################################################################
# Example: Complete Configuration with Dependencies
################################################################################

# Example IAM role for Redshift S3 access
resource "aws_iam_role" "redshift_s3_access" {
  name = "redshift-s3-access-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "redshift.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach S3 read-only access policy
resource "aws_iam_role_policy_attachment" "redshift_s3_readonly" {
  role       = aws_iam_role.redshift_s3_access.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

# Example Redshift cluster (managed separately)
resource "aws_redshift_cluster" "example" {
  cluster_identifier = "my-redshift-cluster"
  database_name      = "mydb"
  master_username    = "admin"
  master_password    = "MustBe8CharactersLong!"
  node_type          = "dc2.large"
  cluster_type       = "single-node"

  # Note: Do NOT set default_iam_role_arn here if using aws_redshift_cluster_iam_roles
  skip_final_snapshot = true
}

# Attach IAM roles to the Redshift cluster
resource "aws_redshift_cluster_iam_roles" "complete_example" {
  cluster_identifier = aws_redshift_cluster.example.cluster_identifier

  iam_role_arns = [
    aws_iam_role.redshift_s3_access.arn
  ]

  default_iam_role_arn = aws_iam_role.redshift_s3_access.arn

  # Ensure IAM role and cluster exist before associating
  depends_on = [
    aws_iam_role_policy_attachment.redshift_s3_readonly,
    aws_redshift_cluster.example
  ]
}

################################################################################
# Example: Managing Multiple IAM Roles
################################################################################

resource "aws_iam_role" "redshift_glue_access" {
  name = "redshift-glue-access-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "redshift.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "redshift_glue_service" {
  role       = aws_iam_role.redshift_glue_access.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

# Attach multiple IAM roles to the cluster
resource "aws_redshift_cluster_iam_roles" "multi_role_example" {
  cluster_identifier = aws_redshift_cluster.example.cluster_identifier

  iam_role_arns = [
    aws_iam_role.redshift_s3_access.arn,
    aws_iam_role.redshift_glue_access.arn
  ]

  # Set the S3 access role as default for COPY/UNLOAD operations
  default_iam_role_arn = aws_iam_role.redshift_s3_access.arn

  depends_on = [
    aws_iam_role_policy_attachment.redshift_s3_readonly,
    aws_iam_role_policy_attachment.redshift_glue_service
  ]
}

################################################################################
# Example: Restricting IAM Role Access to Specific Database Users
################################################################################

# Example IAM role with restricted access via trust relationship
resource "aws_iam_role" "redshift_restricted_access" {
  name = "redshift-restricted-access-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "redshift.amazonaws.com"
        }
        Action = "sts:AssumeRole"
        Condition = {
          StringEquals = {
            # Restrict to specific database users using ExternalId
            "sts:ExternalId" = [
              "arn:aws:redshift:us-east-1:123456789012:dbuser:my-redshift-cluster/dataanalyst",
              "arn:aws:redshift:us-east-1:123456789012:dbuser:my-redshift-cluster/etluser"
            ]
          }
        }
      }
    ]
  })
}

################################################################################
# Output Values
################################################################################

output "cluster_iam_roles_id" {
  description = "The Redshift Cluster ID with associated IAM roles"
  value       = aws_redshift_cluster_iam_roles.example.id
}

output "cluster_iam_role_arns" {
  description = "List of IAM Role ARNs associated with the Redshift cluster"
  value       = aws_redshift_cluster_iam_roles.example.iam_role_arns
}

output "cluster_default_iam_role_arn" {
  description = "The default IAM Role ARN for the Redshift cluster"
  value       = aws_redshift_cluster_iam_roles.example.default_iam_role_arn
}

################################################################################
# Common Pitfalls and Best Practices
################################################################################
# 1. Default IAM Role Conflict:
#    - Do NOT set default_iam_role_arn in both aws_redshift_cluster and
#      aws_redshift_cluster_iam_roles resources
#    - Choose one resource to manage the default IAM role
#
# 2. IAM Role Limit:
#    - Maximum of 10 IAM roles can be associated with a cluster
#    - Plan your role design to stay within this limit
#
# 3. Trust Relationships:
#    - IAM roles must have a trust relationship with redshift.amazonaws.com
#    - Verify trust policy before associating roles
#
# 4. iam:PassRole Permission:
#    - User/role creating this resource must have iam:PassRole permission
#    - Required to associate IAM roles with the Redshift cluster
#
# 5. Role Removal:
#    - Removing roles from iam_role_arns will disassociate them from the cluster
#    - Ensure no active queries are using the role before removal
#
# 6. Regional Considerations:
#    - IAM roles are global, but Redshift clusters are regional
#    - Ensure roles have permissions for resources in the correct region
#
# 7. Monitoring:
#    - Use describe-clusters CLI command to check role association status
#    - Roles show status: in-sync (active), adding, or removing
#
# 8. Security:
#    - Restrict IAM role access to specific database users when needed
#    - Use ExternalId condition in trust policy for fine-grained control
#    - Follow principle of least privilege when granting permissions
