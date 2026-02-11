################################################################################
# AWS RDS Global Cluster
################################################################################
# Manages an RDS Global Cluster, which is an Aurora global database spread
# across multiple regions. The global database contains a single primary
# cluster with read-write capability, and a read-only secondary cluster that
# receives data from the primary cluster through high-speed replication
# performed by the Aurora storage subsystem.
#
# More information:
# https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/aurora-global-database.html
#
# Terraform AWS Provider Documentation:
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_global_cluster
################################################################################

resource "aws_rds_global_cluster" "example" {
  ################################################################################
  # Required Arguments
  ################################################################################

  # Global cluster identifier
  # Forces new resource
  # Type: string
  # Example: "global-test"
  global_cluster_identifier = "global-test"

  ################################################################################
  # Optional Arguments
  ################################################################################

  # Name for an automatically created database on cluster creation
  # Forces new resource
  # Terraform will only perform drift detection if a configuration value is provided
  # Type: string
  # Example: "example_db"
  database_name = null

  # If the Global Cluster should have deletion protection enabled
  # The database can't be deleted when this value is set to true
  # Default: false
  # Type: bool
  deletion_protection = null

  # Name of the database engine to be used for this DB cluster
  # Forces new resource
  # Terraform will only perform drift detection if a configuration value is provided
  # Valid values: aurora, aurora-mysql, aurora-postgresql
  # Default: aurora
  # Conflicts with: source_db_cluster_identifier
  # Type: string
  # Example: "aurora-mysql"
  engine = null

  # The life cycle type for this DB instance
  # This setting applies only to Aurora PostgreSQL-based global databases
  # Valid values: open-source-rds-extended-support, open-source-rds-extended-support-disabled
  # Default: open-source-rds-extended-support
  # Type: string
  # Reference: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/extended-support.html
  engine_lifecycle_support = null

  # Engine version of the Aurora global database
  # The engine, engine_version, and instance_class (on the aws_rds_cluster_instance)
  # must together support global databases
  # By upgrading the engine version, Terraform will upgrade cluster members
  # NOTE: To avoid an inconsistent final plan error while upgrading, use the
  # lifecycle ignore_changes for engine_version meta argument on the associated
  # aws_rds_cluster resource
  # Type: string
  # Example: "5.7.mysql_aurora.2.07.5"
  # Reference: https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/aurora-global-database.html
  engine_version = null

  # Enable to remove DB Cluster members from Global Cluster on destroy
  # Required with: source_db_cluster_identifier
  # Type: bool
  force_destroy = null

  # Region where this resource will be managed
  # Defaults to the Region set in the provider configuration
  # Type: string
  # Example: "us-east-1"
  # Reference: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  # Amazon Resource Name (ARN) to use as the primary DB Cluster of the Global
  # Cluster on creation
  # Terraform cannot perform drift detection of this value
  # NOTE: After initial creation, this argument can be removed and replaced with
  # engine and engine_version. This allows upgrading the engine version of the
  # Global Cluster
  # Type: string
  # Example: "arn:aws:rds:us-east-1:123456789012:cluster:my-cluster"
  source_db_cluster_identifier = null

  # Specifies whether the DB cluster is encrypted
  # Forces new resource
  # Default: false unless source_db_cluster_identifier is specified and encrypted
  # Terraform will only perform drift detection if a configuration value is provided
  # Type: bool
  storage_encrypted = null

  # A map of tags to assign to the DB cluster
  # If configured with a provider default_tags configuration block present,
  # tags with matching keys will overwrite those defined at the provider-level
  # Type: map(string)
  # Example: { Environment = "production", Team = "database" }
  tags = {}

  ################################################################################
  # Blocks
  ################################################################################

  # Timeouts configuration
  # Type: object
  timeouts {
    # Create timeout
    # Type: string
    # Example: "30m"
    create = null

    # Update timeout
    # Type: string
    # Example: "30m"
    update = null

    # Delete timeout
    # Type: string
    # Example: "30m"
    delete = null
  }
}

################################################################################
# Outputs
################################################################################

output "rds_global_cluster_arn" {
  description = "RDS Global Cluster Amazon Resource Name (ARN)"
  value       = aws_rds_global_cluster.example.arn
}

output "rds_global_cluster_endpoint" {
  description = "Writer endpoint for the new global database cluster. This endpoint always points to the writer DB instance in the current primary cluster"
  value       = aws_rds_global_cluster.example.endpoint
}

output "rds_global_cluster_global_cluster_members" {
  description = "Set of objects containing Global Cluster members. Contains db_cluster_arn (ARN of member DB Cluster) and is_writer (whether the member is the primary DB Cluster)"
  value       = aws_rds_global_cluster.example.global_cluster_members
}

output "rds_global_cluster_global_cluster_resource_id" {
  description = "AWS Region-unique, immutable identifier for the global database cluster. This identifier is found in AWS CloudTrail log entries whenever the AWS KMS key for the DB cluster is accessed"
  value       = aws_rds_global_cluster.example.global_cluster_resource_id
}

output "rds_global_cluster_id" {
  description = "RDS Global Cluster identifier"
  value       = aws_rds_global_cluster.example.id
}

output "rds_global_cluster_engine_version_actual" {
  description = "The actual engine version of the Global Cluster"
  value       = aws_rds_global_cluster.example.engine_version_actual
}

output "rds_global_cluster_tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_rds_global_cluster.example.tags_all
}

################################################################################
# Example Usage Notes
################################################################################
#
# 1. New MySQL Global Cluster:
#    - Set engine = "aurora"
#    - Set engine_version = "5.6.mysql_aurora.1.22.2"
#    - Create primary aws_rds_cluster with global_cluster_identifier
#    - Create secondary aws_rds_cluster in different region/provider
#
# 2. New PostgreSQL Global Cluster:
#    - Set engine = "aurora-postgresql"
#    - Set engine_version = "11.9"
#    - Follow same pattern as MySQL example
#
# 3. New Global Cluster From Existing DB Cluster:
#    - Use source_db_cluster_identifier with existing cluster ARN
#    - Set force_destroy = true
#    - Add lifecycle ignore_changes for global_cluster_identifier on source cluster
#
# 4. Upgrading Engine Versions:
#    - Update engine_version in global cluster
#    - Set allow_major_version_upgrade = true on primary cluster
#    - Set apply_immediately = true on primary cluster
#    - Add lifecycle ignore_changes for engine_version on cluster
#
# Important Notes:
# - When both source_db_cluster_identifier and engine/engine_version are set,
#   all engine related values will be ignored during creation
# - The global cluster will inherit the engine and engine_version values from
#   the source cluster
# - After the first apply, any differences between the inherited and configured
#   values will trigger an in-place update
################################################################################
