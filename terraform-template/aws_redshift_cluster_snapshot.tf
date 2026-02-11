################################################################################
# AWS Redshift Cluster Snapshot
################################################################################
# Creates a manual snapshot of an Amazon Redshift cluster. Snapshots are
# point-in-time backups stored internally in Amazon S3 using encrypted SSL.
# Manual snapshots are retained indefinitely by default until explicitly deleted.
#
# Use Cases:
# - Create manual backups before major changes or maintenance
# - Establish restore points for compliance or disaster recovery
# - Capture cluster state for testing or development environments
# - Maintain long-term backups beyond automated snapshot retention
#
# Important Notes:
# - Manual snapshots incur storage charges until deleted
# - Snapshots are incremental and track changes since the last snapshot
# - Restored clusters can begin queries immediately while data loads in background
# - For RA3 node types, automated snapshots cannot be disabled (1-35 days required)
# - Manual snapshots can be copied across regions for disaster recovery
#
# AWS Documentation:
# https://docs.aws.amazon.com/redshift/latest/mgmt/working-with-snapshots.html
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/redshift_cluster_snapshot

resource "aws_redshift_cluster_snapshot" "example" {
  ################################################################################
  # Required Arguments
  ################################################################################

  # (Required, Forces new resource) The cluster identifier for which you want
  # a snapshot. This is the identifier of the source Redshift cluster.
  # Must reference an existing Redshift cluster in the same region.
  #
  # Example: "my-redshift-cluster"
  cluster_identifier = "example-cluster"

  # (Required, Forces new resource) A unique identifier for the snapshot that
  # you are requesting. This identifier must be unique for all snapshots within
  # the AWS account. Cannot be changed after creation.
  #
  # Naming Guidelines:
  # - Must be lowercase
  # - Can contain alphanumeric characters and hyphens
  # - First character must be a letter
  # - Cannot end with a hyphen or contain two consecutive hyphens
  #
  # Best Practice: Include date/time or purpose in the name
  # Example: "production-backup-2024-01-15" or "pre-migration-snapshot"
  snapshot_identifier = "example-snapshot"

  ################################################################################
  # Optional Arguments
  ################################################################################

  # (Optional) The number of days that a manual snapshot is retained.
  # If not specified or set to -1, the manual snapshot is retained indefinitely.
  #
  # Valid values:
  # - -1: Retain indefinitely (default)
  # - 1 to 3653: Number of days to retain (1 day to ~10 years)
  #
  # Important Considerations:
  # - Snapshots accrue storage charges; evaluate retention needs carefully
  # - Can be modified after snapshot creation
  # - Automated snapshots have separate retention settings (1-35 days)
  # - Delete unneeded snapshots to manage storage costs
  #
  # Common Retention Periods:
  # - Development/Testing: 7-30 days
  # - Production backups: 30-90 days
  # - Compliance archives: 365+ days or indefinite
  # - Pre-migration snapshots: Indefinite until verified
  #
  # Example: Retain for 90 days
  # manual_snapshot_retention_period = 90
  #
  # Example: Retain indefinitely
  # manual_snapshot_retention_period = -1

  # (Optional) Region where this resource will be managed. Defaults to the
  # region set in the provider configuration.
  #
  # Use Cases:
  # - Explicitly specify region for multi-region deployments
  # - Override provider default region for specific resources
  # - Create cross-region snapshot copies
  #
  # Note: The source cluster must be in the same region. For cross-region
  # snapshots, use the snapshot copy feature after creation.
  #
  # Example: "us-west-2"
  # region = "us-east-1"

  # (Optional) A map of tags to assign to the snapshot resource.
  # Tags help organize resources, track costs, and implement access control.
  #
  # Best Practices:
  # - Tag snapshots with cluster information, environment, and purpose
  # - Include cost center or project tags for billing allocation
  # - Add creation metadata (date, created-by, etc.)
  # - Use consistent tagging strategy across all resources
  #
  # If configured with a provider default_tags configuration block, tags
  # with matching keys will overwrite those defined at the provider level.
  #
  # Example:
  # tags = {
  #   Name        = "production-backup-snapshot"
  #   Environment = "production"
  #   Cluster     = "analytics-cluster"
  #   Purpose     = "monthly-backup"
  #   CreatedBy   = "terraform"
  #   CreatedDate = "2024-01-15"
  #   Retention   = "90-days"
  #   CostCenter  = "analytics-team"
  # }
}

################################################################################
# Computed Attributes (Available after creation)
################################################################################
# These attributes are set by AWS and can be referenced in other resources:
#
# - arn: Amazon Resource Name (ARN) of the snapshot
#   Format: arn:aws:redshift:region:account-id:snapshot:cluster-name/snapshot-name
#   Use for: IAM policies, cross-account sharing, CloudWatch alarms
#
# - id: The snapshot identifier (same as snapshot_identifier)
#   Use for: Resource references, data source lookups
#
# - kms_key_id: The KMS key ID used to encrypt data in the source cluster
#   Use for: Audit encryption compliance, cross-account snapshot sharing
#   Note: Inherited from source cluster's encryption settings
#
# - owner_account: AWS account that created the snapshot
#   Use for: Cross-account snapshot sharing scenarios
#   Note: For manual snapshots, this is the account that created/copied it
#
# - tags_all: Complete map of tags including provider default_tags
#   Use for: Viewing all applied tags including inherited ones

################################################################################
# Example: Reference snapshot attributes
################################################################################
# output "snapshot_arn" {
#   description = "ARN of the Redshift cluster snapshot"
#   value       = aws_redshift_cluster_snapshot.example.arn
# }
#
# output "snapshot_kms_key" {
#   description = "KMS key used for snapshot encryption"
#   value       = aws_redshift_cluster_snapshot.example.kms_key_id
# }

################################################################################
# Common Patterns and Use Cases
################################################################################

# Pattern 1: Pre-Migration Snapshot with Indefinite Retention
# resource "aws_redshift_cluster_snapshot" "pre_migration" {
#   cluster_identifier               = aws_redshift_cluster.production.id
#   snapshot_identifier              = "pre-migration-snapshot-${formatdate("YYYY-MM-DD", timestamp())}"
#   manual_snapshot_retention_period = -1  # Retain indefinitely
#
#   tags = {
#     Purpose     = "pre-migration-backup"
#     Environment = "production"
#     Critical    = "true"
#   }
# }

# Pattern 2: Scheduled Manual Backup with 30-Day Retention
# resource "aws_redshift_cluster_snapshot" "monthly_backup" {
#   cluster_identifier               = aws_redshift_cluster.analytics.id
#   snapshot_identifier              = "monthly-backup-${formatdate("YYYY-MM", timestamp())}"
#   manual_snapshot_retention_period = 30
#
#   tags = {
#     Purpose      = "monthly-compliance-backup"
#     Environment  = "production"
#     RetentionDays = "30"
#   }
# }

# Pattern 3: Development Snapshot with Short Retention
# resource "aws_redshift_cluster_snapshot" "dev_snapshot" {
#   cluster_identifier               = aws_redshift_cluster.development.id
#   snapshot_identifier              = "dev-snapshot-${formatdate("YYYY-MM-DD-hhmm", timestamp())}"
#   manual_snapshot_retention_period = 7  # 7 days for dev environments
#
#   tags = {
#     Environment = "development"
#     Purpose     = "testing-backup"
#   }
# }

################################################################################
# Related Resources and Considerations
################################################################################

# Cluster Dependency:
# resource "aws_redshift_cluster" "source" {
#   cluster_identifier = "source-cluster"
#   node_type         = "dc2.large"
#   number_of_nodes   = 2
#   # ... other cluster configuration
# }
#
# resource "aws_redshift_cluster_snapshot" "backup" {
#   cluster_identifier  = aws_redshift_cluster.source.id
#   snapshot_identifier = "cluster-backup"
# }

# Restore from Snapshot:
# resource "aws_redshift_cluster" "restored" {
#   cluster_identifier  = "restored-cluster"
#   snapshot_identifier = aws_redshift_cluster_snapshot.example.id
#   node_type          = "dc2.large"
#   # Cluster will be restored from the snapshot
# }

# Cross-Region Snapshot Copy (requires additional configuration):
# - Configure snapshot copy on the source cluster
# - Use aws_redshift_snapshot_copy_grant for encryption in destination region
# - Set retention period for copied snapshots

################################################################################
# Cost Management
################################################################################
# - Snapshot storage charges apply based on actual data size
# - Incremental snapshots only store changed data
# - Evaluate retention periods to balance compliance needs with costs
# - Delete manual snapshots when no longer needed
# - Monitor snapshot storage using CloudWatch metrics
# - Consider snapshot lifecycle policies for cost optimization
#
# Cost Factors:
# 1. Total snapshot size (incremental over time)
# 2. Retention period duration
# 3. Number of manual snapshots maintained
# 4. Cross-region snapshot copy storage (if configured)

################################################################################
# Security Considerations
################################################################################
# - Snapshots inherit encryption settings from source cluster
# - KMS encryption keys must remain available for snapshot restore
# - Use IAM policies to control snapshot access and operations
# - Enable MFA delete for critical production snapshots
# - Audit snapshot operations using CloudTrail
# - Implement tags for resource-based access control
# - Consider cross-account snapshot sharing for backup isolation

################################################################################
# Operational Best Practices
################################################################################
# 1. Naming Convention: Use consistent, descriptive snapshot names
#    Include: cluster name, date, purpose, environment
#
# 2. Tagging Strategy: Tag all snapshots with metadata
#    Required tags: Environment, Purpose, CreatedBy, CostCenter
#
# 3. Retention Planning:
#    - Define retention policies based on compliance requirements
#    - Document retention periods in tags
#    - Automate cleanup of expired snapshots
#
# 4. Testing: Regularly test snapshot restore procedures
#    - Verify restored cluster functionality
#    - Measure restore time objectives (RTO)
#    - Document restore procedures
#
# 5. Monitoring:
#    - Set up CloudWatch alarms for snapshot failures
#    - Track snapshot storage growth
#    - Monitor snapshot age and retention compliance
#
# 6. Disaster Recovery:
#    - Configure cross-region snapshot copies for critical clusters
#    - Maintain recent snapshots in multiple regions
#    - Document recovery procedures and runbooks

################################################################################
# Limitations and Constraints
################################################################################
# - Snapshot identifier must be unique within AWS account
# - Cannot modify cluster_identifier or snapshot_identifier after creation
# - Manual snapshot quota: Check AWS service quotas for your account/region
# - Default quota is typically 20 manual snapshots per cluster
# - Minimum retention period: 1 day (or -1 for indefinite)
# - Maximum retention period: 3653 days (~10 years)
# - Snapshot operations cannot be performed on a deleting cluster
# - Cannot force-delete snapshots if they're being used for restore operations
