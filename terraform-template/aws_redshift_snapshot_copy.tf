################################################################################
# AWS Redshift Snapshot Copy
################################################################################
# Terraform resource for managing automated cross-region snapshot copies for
# Amazon Redshift clusters. This resource configures automatic copying of
# snapshots from a source Redshift cluster to a destination AWS region for
# disaster recovery and data redundancy purposes.
#
# Use Cases:
# - Cross-region disaster recovery for Redshift clusters
# - Multi-region data availability and redundancy
# - Compliance requirements for geo-distributed backups
# - Business continuity planning
#
# Key Features:
# - Automated snapshot copying to destination region
# - Configurable retention periods for both automated and manual snapshots
# - Support for KMS-encrypted snapshot copying via snapshot copy grants
# - Region-specific resource management
#
# Related Resources:
# - aws_redshift_cluster: Source Redshift cluster to copy snapshots from
# - aws_redshift_snapshot_copy_grant: For copying KMS-encrypted snapshots
# - aws_kms_key: KMS key for encrypting snapshots in destination region
#
# References:
# - AWS Documentation: https://docs.aws.amazon.com/redshift/latest/mgmt/working-with-snapshots.html#cross-region-snapshot-copy
# - Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/redshift_snapshot_copy
################################################################################

resource "aws_redshift_snapshot_copy" "example" {
  ################################################################################
  # Required Arguments
  ################################################################################

  # cluster_identifier - (Required) Identifier of the source Redshift cluster
  # Type: string
  #
  # The unique identifier of the source Redshift cluster whose snapshots will be
  # automatically copied to the destination region. This must be an existing
  # cluster identifier.
  #
  # Example values:
  # - "my-redshift-cluster"
  # - "production-cluster"
  # - "analytics-cluster-001"
  #
  # Note: Cross-region snapshot copy must be enabled on the cluster
  cluster_identifier = "my-redshift-cluster"

  # destination_region - (Required) AWS Region to copy snapshots to
  # Type: string
  #
  # The destination AWS region where snapshots will be automatically copied.
  # Must be a different region from where the source cluster is located.
  #
  # Example values:
  # - "us-east-1"
  # - "eu-west-1"
  # - "ap-southeast-2"
  #
  # Important: The destination region must support Amazon Redshift
  destination_region = "us-east-1"

  ################################################################################
  # Optional Arguments
  ################################################################################

  # region - (Optional) Region where this resource will be managed
  # Type: string
  # Default: Provider region configuration
  #
  # Specifies the AWS region where this snapshot copy configuration resource
  # will be managed. Defaults to the region set in the provider configuration.
  # This should typically match the source cluster's region.
  #
  # Example values:
  # - "us-west-2"
  # - "eu-central-1"
  #
  # Reference: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-west-2"

  # manual_snapshot_retention_period - (Optional) Retention period for manual snapshots
  # Type: number
  # Default: Computed by AWS
  #
  # Number of days to retain newly copied manual snapshots in the destination
  # region after they are copied from the source region. If set to -1, the
  # manual snapshot is retained indefinitely.
  #
  # Valid range:
  # - -1 (infinite retention)
  # - 1 to 3653 days (approximately 10 years)
  #
  # Example values:
  # - 7 (retain for 1 week)
  # - 30 (retain for 1 month)
  # - 90 (retain for 3 months)
  # - -1 (retain indefinitely)
  #
  # Note: This applies only to manual snapshots, not automated snapshots
  # manual_snapshot_retention_period = 30

  # retention_period - (Optional) Retention period for automated snapshots
  # Type: number
  # Default: Computed by AWS (typically matches source cluster retention)
  #
  # Number of days to retain automated snapshots in the destination region
  # after they are copied from the source region.
  #
  # Valid range: 1 to 35 days
  #
  # Example values:
  # - 1 (retain for 1 day)
  # - 7 (retain for 1 week)
  # - 14 (retain for 2 weeks)
  # - 35 (maximum retention - 5 weeks)
  #
  # Important: The retention period in the destination region can be different
  # from the source cluster's retention period
  # retention_period = 7

  # snapshot_copy_grant_name - (Optional) Name of the snapshot copy grant
  # Type: string
  # Default: None
  #
  # Name of the snapshot copy grant to use when snapshots of an AWS KMS-encrypted
  # cluster are copied to the destination region. Required only when copying
  # encrypted snapshots.
  #
  # Example values:
  # - "my-snapshot-copy-grant"
  # - "prod-redshift-copy-grant"
  # - "dr-backup-grant"
  #
  # Prerequisites:
  # - Must create aws_redshift_snapshot_copy_grant in the destination region
  # - Grant must have permissions to use the KMS key in destination region
  # - Source cluster must be encrypted with KMS
  #
  # Note: Not required if the source cluster is not encrypted
  # snapshot_copy_grant_name = "my-snapshot-copy-grant"

  ################################################################################
  # Computed Attributes (Read-Only)
  ################################################################################

  # id - Identifier of the source cluster
  # Type: string
  # Computed: true
  #
  # The unique identifier for this snapshot copy configuration, which matches
  # the cluster_identifier value.
}

################################################################################
# Example: Basic Snapshot Copy Configuration
################################################################################

# resource "aws_redshift_snapshot_copy" "basic" {
#   cluster_identifier = aws_redshift_cluster.source.id
#   destination_region = "us-east-1"
# }

################################################################################
# Example: Snapshot Copy with Custom Retention
################################################################################

# resource "aws_redshift_snapshot_copy" "with_retention" {
#   cluster_identifier                = aws_redshift_cluster.source.id
#   destination_region                = "eu-west-1"
#   retention_period                  = 7
#   manual_snapshot_retention_period  = 30
# }

################################################################################
# Example: Encrypted Snapshot Copy with Copy Grant
################################################################################

# # Source cluster (encrypted)
# resource "aws_redshift_cluster" "encrypted_source" {
#   cluster_identifier = "encrypted-cluster"
#   database_name      = "mydb"
#   master_username    = "admin"
#   master_password    = "MyPassword123!"
#   node_type          = "dc2.large"
#   cluster_type       = "single-node"
#   encrypted          = true
#   kms_key_id         = aws_kms_key.source.arn
# }
#
# # KMS key in destination region
# resource "aws_kms_key" "destination" {
#   provider    = aws.destination
#   description = "KMS key for Redshift snapshots in destination region"
# }
#
# # Snapshot copy grant in destination region
# resource "aws_redshift_snapshot_copy_grant" "example" {
#   provider             = aws.destination
#   snapshot_copy_grant_name = "my-copy-grant"
#   kms_key_id           = aws_kms_key.destination.arn
# }
#
# # Snapshot copy configuration
# resource "aws_redshift_snapshot_copy" "encrypted" {
#   cluster_identifier        = aws_redshift_cluster.encrypted_source.id
#   destination_region        = "us-east-1"
#   snapshot_copy_grant_name  = aws_redshift_snapshot_copy_grant.example.snapshot_copy_grant_name
#   retention_period          = 7
# }

################################################################################
# Example: Multi-Region Setup with Aliases
################################################################################

# # Configure providers for source and destination regions
# provider "aws" {
#   alias  = "us_west_2"
#   region = "us-west-2"
# }
#
# provider "aws" {
#   alias  = "us_east_1"
#   region = "us-east-1"
# }
#
# # Source cluster in us-west-2
# resource "aws_redshift_cluster" "source" {
#   provider           = aws.us_west_2
#   cluster_identifier = "source-cluster"
#   database_name      = "analytics"
#   master_username    = "admin"
#   master_password    = "SecurePassword123!"
#   node_type          = "dc2.large"
#   cluster_type       = "single-node"
# }
#
# # Snapshot copy to us-east-1
# resource "aws_redshift_snapshot_copy" "cross_region" {
#   provider           = aws.us_west_2
#   cluster_identifier = aws_redshift_cluster.source.id
#   destination_region = "us-east-1"
#   retention_period   = 14
# }

################################################################################
# Important Notes
################################################################################

# 1. Cross-Region Snapshot Copy Requirements:
#    - Source and destination regions must both support Amazon Redshift
#    - Cannot copy snapshots to the same region as source cluster
#    - Cross-region data transfer charges apply
#
# 2. Encryption Considerations:
#    - For encrypted clusters, must create snapshot copy grant in destination
#    - Destination region KMS key must be accessible
#    - Snapshot copy grant must be created before enabling snapshot copy
#
# 3. Retention Periods:
#    - Automated snapshot retention: 1-35 days
#    - Manual snapshot retention: -1 (infinite) or 1-3653 days
#    - Retention in destination can differ from source
#
# 4. Cost Implications:
#    - Standard snapshot storage charges apply in destination region
#    - Cross-region data transfer charges for snapshot copying
#    - KMS encryption charges if using encrypted snapshots
#
# 5. Limitations:
#    - Can only configure one destination region per cluster
#    - Cannot modify destination region; must delete and recreate
#    - Snapshot copy must be disabled before deleting cluster
#
# 6. Deletion Behavior:
#    - Destroying this resource disables cross-region snapshot copying
#    - Existing snapshots in destination region are not deleted
#    - Must manually delete snapshots if desired
#
# 7. Best Practices:
#    - Test restore from copied snapshots regularly
#    - Set appropriate retention periods based on RPO requirements
#    - Monitor cross-region data transfer costs
#    - Use snapshot copy grants for encrypted clusters
#    - Consider lifecycle policies for snapshot management
