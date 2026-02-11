################################################################################
# Lightsail Database
################################################################################
# Lightsail managed databases provide easy, low-maintenance relational database
# instances running MySQL or PostgreSQL. They include automated backups, point-in-time
# restore, monitoring, and maintenance. Choose between standard and high availability
# plans, with the latter providing standby databases in separate Availability Zones
# for failover support.
#
# Reference:
# - https://docs.aws.amazon.com/lightsail/latest/userguide/amazon-lightsail-databases.html
# - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lightsail_database

resource "aws_lightsail_database" "this" {
  ################################################################################
  # Required Arguments
  ################################################################################

  # The name to use for your Lightsail database resource.
  # Must be unique within each AWS Region in your Lightsail account.
  # Example: "my-database", "app-db-prod"
  relational_database_name = "example-database"

  # Blueprint ID for your database - defines the major engine version.
  # MySQL options: "mysql_5_7", "mysql_8_0" (5.7 support ends June 30, 2024)
  # PostgreSQL options: "postgres_11", "postgres_12", "postgres_13", "postgres_14",
  #                     "postgres_15", "postgres_16" (11 and 12 support ends Feb 28, 2025)
  # Get available blueprints: aws lightsail get-relational-database-blueprints
  blueprint_id = "mysql_8_0"

  # Bundle ID for your database - defines performance specifications.
  # Options: "micro_1_0", "small_1_0", "medium_1_0", "large_1_0",
  #          "xlarge_1_0", "2xlarge_1_0"
  # Each bundle comes with specific vCPU, RAM, storage, and data transfer allocations.
  # Data import limits: micro (10GB), small (20GB), medium (85GB),
  #                     large/xlarge/2xlarge (156GB each)
  # Get available bundles: aws lightsail get-relational-database-bundles
  # For high availability plans, use bundle IDs with "_ha" suffix.
  bundle_id = "micro_1_0"

  # Name of the master database created with the database instance.
  # Constraints vary by engine:
  # - MySQL: 1-64 alphanumeric characters
  # - PostgreSQL: 1-63 alphanumeric characters, must begin with letter
  master_database_name = "exampledb"

  # Master user name for your database.
  # Constraints vary by engine:
  # - MySQL: 1-16 characters, cannot be "admin" or reserved words
  # - PostgreSQL: 1-63 characters, must begin with letter, cannot be "postgres" or reserved words
  master_username = "exampleuser"

  # Password for the master user. (Sensitive)
  # Must include any printable ASCII character except "/", """, or "@".
  # Constraints vary by engine:
  # - MySQL: 8-128 characters
  # - PostgreSQL: 8-128 characters
  # Best practice: Use AWS Secrets Manager or environment variables instead of hardcoding.
  master_password = "examplepassword123" # TODO: Replace with secure password

  ################################################################################
  # Optional Arguments
  ################################################################################

  # Availability Zone in which to create your database.
  # Use the case-sensitive format (e.g., "us-east-2a").
  # If not specified, Lightsail selects an AZ automatically.
  # For high availability plans, a standby database is automatically created
  # in a different AZ.
  availability_zone = "us-east-1a"

  # Whether to apply changes immediately.
  # When false (default), applies changes during the preferred maintenance window.
  # Some changes may cause an outage regardless of this setting.
  # Type: bool
  # Default: false
  # apply_immediately = true

  # Whether to enable automated backup retention.
  # When false, disables automated backup retention and deletes all automated backups.
  # Consider creating a manual snapshot before disabling.
  # Type: bool
  # Default: true
  # backup_retention_enabled = true

  # Daily time range during which automated backups are created.
  # Must be in the hh24:mi-hh24:mi format (e.g., "16:00-16:30").
  # Specified in Coordinated Universal Time (UTC).
  # Must be at least 30 minutes.
  # Example: "16:00-16:30"
  # preferred_backup_window = "16:00-16:30"

  # Weekly time range during which system maintenance can occur.
  # Must be in the ddd:hh24:mi-ddd:hh24:mi format (e.g., "Tue:17:00-Tue:17:30").
  # Specified in Coordinated Universal Time (UTC).
  # Must be at least 30 minutes.
  # Example: "Tue:17:00-Tue:17:30"
  # preferred_maintenance_window = "Tue:17:00-Tue:17:30"

  # Whether the database is accessible to resources outside of your Lightsail account.
  # - true: Database is available to resources outside your Lightsail account (public mode)
  # - false (default): Database is available only to Lightsail resources in the same region (private mode)
  # By default, databases are in private mode for security.
  # Type: bool
  # Default: false
  # publicly_accessible = false

  # Name of the database snapshot created if skip_final_snapshot is false.
  # Required unless skip_final_snapshot = true.
  # Must be unique within your account in the region.
  # Example: "my-database-final-snapshot"
  # final_snapshot_name = "example-final-snapshot"

  # Whether a final database snapshot is created before deletion.
  # - true: No database snapshot is created before deletion
  # - false (default): A database snapshot is created before deletion
  # If false, you must specify final_snapshot_name.
  # Type: bool
  # Default: false
  # skip_final_snapshot = false

  # AWS Region where this resource will be managed.
  # Defaults to the region set in the provider configuration.
  # Note: Lightsail is only supported in limited regions.
  # Available regions: us-east-1, us-east-2, us-west-2, eu-central-1, eu-west-1,
  #                    eu-west-2, eu-west-3, ap-southeast-1, ap-southeast-2,
  #                    ap-northeast-1, ap-south-1, ca-central-1
  # region = "us-east-1"

  # Map of tags to assign to the resource.
  # To create a key-only tag, use an empty string as the value.
  # If configured with a provider default_tags configuration block, tags with
  # matching keys will overwrite those defined at the provider level.
  # tags = {
  #   Environment = "production"
  #   Project     = "example"
  # }
}

################################################################################
# Computed Attributes (Exported)
################################################################################
# These attributes are available after the resource is created:
#
# - arn                         : ARN of the database (matches id)
# - ca_certificate_identifier   : Certificate associated with the database
# - cpu_count                   : Number of vCPUs for the database
# - created_at                  : Date and time when the database was created
# - disk_size                   : Size of the disk for the database (in GB)
# - engine                      : Database software (e.g., MySQL)
# - engine_version              : Database engine version (e.g., 5.7.23)
# - id                          : ARN of the database (matches arn)
# - master_endpoint_address     : Master endpoint FQDN for the database
# - master_endpoint_port        : Master endpoint network port for the database
# - ram_size                    : Amount of RAM in GB for the database
# - secondary_availability_zone : Secondary AZ of a high availability database (for failover support)
# - support_code                : Support code for contacting AWS support
# - tags_all                    : Map of tags including provider default_tags

################################################################################
# Usage Examples
################################################################################

# Example 1: Basic MySQL Database
# resource "aws_lightsail_database" "mysql_basic" {
#   relational_database_name = "mysql-database"
#   availability_zone        = "us-east-1a"
#   master_database_name     = "myappdb"
#   master_password          = var.db_password # Use variable for sensitive data
#   master_username          = "admin"
#   blueprint_id             = "mysql_8_0"
#   bundle_id                = "micro_1_0"
# }

# Example 2: PostgreSQL with Custom Backup and Maintenance Windows
# resource "aws_lightsail_database" "postgres_custom" {
#   relational_database_name     = "postgres-database"
#   availability_zone            = "us-east-1a"
#   master_database_name         = "appdb"
#   master_password              = var.db_password
#   master_username              = "dbadmin"
#   blueprint_id                 = "postgres_16"
#   bundle_id                    = "small_1_0"
#   preferred_backup_window      = "03:00-03:30"
#   preferred_maintenance_window = "Mon:04:00-Mon:04:30"
#
#   tags = {
#     Environment = "production"
#     Backup      = "enabled"
#   }
# }

# Example 3: High Availability Database with Final Snapshot
# resource "aws_lightsail_database" "ha_with_snapshot" {
#   relational_database_name     = "ha-database"
#   availability_zone            = "us-east-1a" # Primary AZ
#   master_database_name         = "proddb"
#   master_password              = var.db_password
#   master_username              = "prodadmin"
#   blueprint_id                 = "postgres_16"
#   bundle_id                    = "medium_ha_1_0" # High availability bundle
#   backup_retention_enabled     = true
#   preferred_backup_window      = "02:00-02:30"
#   preferred_maintenance_window = "Sun:03:00-Sun:03:30"
#   final_snapshot_name          = "ha-database-final-snapshot-${formatdate("YYYY-MM-DD-hhmm", timestamp())}"
#
#   tags = {
#     Environment     = "production"
#     HighAvailability = "true"
#   }
# }

# Example 4: Publicly Accessible Database with Immediate Apply
# resource "aws_lightsail_database" "public_db" {
#   relational_database_name = "public-database"
#   availability_zone        = "us-west-2a"
#   master_database_name     = "webapp"
#   master_password          = var.db_password
#   master_username          = "webadmin"
#   blueprint_id             = "mysql_8_0"
#   bundle_id                = "small_1_0"
#   publicly_accessible      = true
#   apply_immediately        = true
#
#   tags = {
#     Environment = "development"
#     Access      = "public"
#   }
# }

################################################################################
# Best Practices
################################################################################
# 1. Security:
#    - Never hardcode master_password; use variables, Secrets Manager, or env vars
#    - Keep publicly_accessible = false unless absolutely necessary
#    - Use security groups to restrict access to database instances
#    - Enable backup_retention_enabled for data protection
#
# 2. High Availability:
#    - Use high availability bundles (bundle_id with "_ha" suffix) for production
#    - High availability plans provide standby databases in separate AZs
#    - Automatic failover to standby database in case of primary failure
#
# 3. Backups:
#    - Always create final snapshots (skip_final_snapshot = false) before deletion
#    - Schedule backups during low-traffic periods with preferred_backup_window
#    - Maintain manual snapshots for long-term retention beyond automated backups
#
# 4. Maintenance:
#    - Schedule maintenance windows during low-traffic periods
#    - Test major version upgrades on snapshots before applying to production
#    - Use apply_immediately = false for production to avoid unexpected outages
#
# 5. Scaling:
#    - Choose appropriate bundle_id based on expected workload
#    - Consider data import limits when selecting initial bundle size
#    - To scale up, create a snapshot and restore to a larger bundle
#    - Monitor cpu_count, ram_size, and disk_size to determine scaling needs
#
# 6. Cost Optimization:
#    - Start with smaller bundles (micro_1_0) for development/testing
#    - Use standard plans for non-critical workloads
#    - Delete unused databases to avoid ongoing charges
#    - Consider emergency restore for point-in-time recovery instead of multiple snapshots
#
# 7. Regional Considerations:
#    - Lightsail databases are only available in limited regions
#    - Verify region availability before deployment
#    - Keep databases in the same region as application instances for low latency
#
# 8. Monitoring:
#    - Use Lightsail console metrics to monitor database performance
#    - Check support_code when contacting AWS support for faster resolution
#    - Monitor backup status and retention settings regularly

################################################################################
# Common Pitfalls
################################################################################
# 1. Using deprecated database versions (MySQL 5.7, PostgreSQL 11/12)
# 2. Hardcoding sensitive credentials in Terraform code
# 3. Not creating final snapshots before deletion (data loss)
# 4. Using apply_immediately = true in production (unexpected outages)
# 5. Not considering data import limits when choosing bundle size
# 6. Enabling publicly_accessible without proper security measures
# 7. Not scheduling backups and maintenance during low-traffic periods
# 8. Forgetting to upgrade databases before end-of-support dates

################################################################################
# Additional Resources
################################################################################
# - Lightsail Database Documentation:
#   https://docs.aws.amazon.com/lightsail/latest/userguide/amazon-lightsail-databases.html
# - Choosing Database Engine:
#   https://docs.aws.amazon.com/lightsail/latest/userguide/amazon-lightsail-choosing-a-database.html
# - Database FAQ:
#   https://docs.aws.amazon.com/lightsail/latest/userguide/amazon-lightsail-faq-databases.html
# - Creating Database:
#   https://docs.aws.amazon.com/lightsail/latest/userguide/amazon-lightsail-creating-a-database.html
# - Major Version Upgrade:
#   https://docs.aws.amazon.com/lightsail/latest/userguide/amazon-lightsail-upgrade-database-major-version.html
# - Terraform AWS Provider Documentation:
#   https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lightsail_database
