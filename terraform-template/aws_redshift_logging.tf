# ============================================================
# AWS Redshift Logging
# ============================================================
# Terraform resource for managing an AWS Redshift Logging configuration.
#
# This resource enables and configures audit logging for Amazon Redshift clusters.
# Logs can be exported to either Amazon S3 or Amazon CloudWatch Logs, capturing
# connection logs, user logs, and user activity logs for security and compliance monitoring.
#
# Provider Version: 6.28.0
# Resource Documentation: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/redshift_logging
# AWS Documentation: https://docs.aws.amazon.com/redshift/latest/mgmt/db-auditing.html
# ============================================================

# ============================================================
# Basic CloudWatch Configuration Example
# ============================================================
resource "aws_redshift_logging" "cloudwatch_example" {
  # ----------------------------------------------------------
  # Required Arguments
  # ----------------------------------------------------------

  # Identifier of the source Redshift cluster
  # Must be an existing cluster in the same region
  # Example: "my-redshift-cluster"
  cluster_identifier = aws_redshift_cluster.example.id

  # ----------------------------------------------------------
  # Optional Arguments - CloudWatch Configuration
  # ----------------------------------------------------------

  # Log destination type
  # Valid values: "s3" or "cloudwatch"
  # Default: None (must be specified)
  log_destination_type = "cloudwatch"

  # Collection of exported log types
  # Required when log_destination_type is "cloudwatch"
  # Valid values: "connectionlog", "useractivitylog", "userlog"
  # - connectionlog: Connection attempts and disconnects
  # - useractivitylog: All SQL statements executed by users
  # - userlog: User creation, deletion, and authentication attempts
  log_exports = ["connectionlog", "userlog"]

  # ----------------------------------------------------------
  # Optional Arguments - General
  # ----------------------------------------------------------

  # AWS region where this resource will be managed
  # Defaults to the provider region if not specified
  # Example: "us-east-1"
  # region = "us-east-1"
}

# ============================================================
# S3 Destination Configuration Example
# ============================================================
resource "aws_redshift_logging" "s3_example" {
  # ----------------------------------------------------------
  # Required Arguments
  # ----------------------------------------------------------

  # Identifier of the source Redshift cluster
  cluster_identifier = aws_redshift_cluster.example.id

  # ----------------------------------------------------------
  # Optional Arguments - S3 Configuration
  # ----------------------------------------------------------

  # Log destination type
  log_destination_type = "s3"

  # Name of an existing S3 bucket for log storage
  # Required when log_destination_type is "s3"
  # Must be in the same region as the cluster
  # The cluster must have read bucket and put object permissions
  # Bucket policy example: https://docs.aws.amazon.com/redshift/latest/mgmt/db-auditing.html#db-auditing-enable-logging
  bucket_name = aws_s3_bucket.example.id

  # Prefix applied to the log file names
  # Optional: Helps organize logs within the S3 bucket
  # Example: "redshift-logs/" or "logs/production/"
  s3_key_prefix = "redshift-logs/"

  # ----------------------------------------------------------
  # Optional Arguments - General
  # ----------------------------------------------------------

  # AWS region where this resource will be managed
  # region = "us-east-1"
}

# ============================================================
# Outputs
# ============================================================

# Output the cluster identifier
output "redshift_logging_cluster_id" {
  description = "The identifier of the Redshift cluster with logging enabled"
  value       = aws_redshift_logging.cloudwatch_example.cluster_identifier
}

# ============================================================
# Important Notes
# ============================================================
#
# 1. Log Destination Types:
#    - CloudWatch: Real-time log monitoring with CloudWatch Logs Insights
#    - S3: Long-term storage and archival with cost optimization
#
# 2. CloudWatch Requirements:
#    - Must specify log_exports when using cloudwatch destination
#    - Logs are stored in CloudWatch log groups
#    - Additional CloudWatch costs apply
#
# 3. S3 Requirements:
#    - bucket_name is required when using s3 destination
#    - Bucket must be in the same region as the cluster
#    - Cluster IAM role must have s3:PutObject and s3:GetBucketAcl permissions
#    - Bucket policy must grant appropriate permissions to Redshift service
#
# 4. Log Types:
#    - connectionlog: Records authentication attempts, connections, and disconnections
#    - userlog: Records information about changes to database user definitions
#    - useractivitylog: Records each query before it's executed on the database
#
# 5. Performance Considerations:
#    - Logging may have minimal impact on cluster performance
#    - useractivitylog can generate significant log volume for high-activity clusters
#    - Consider using S3 for long-term storage to manage CloudWatch costs
#
# 6. Security Best Practices:
#    - Enable encryption for S3 buckets storing logs
#    - Implement bucket policies to restrict access to logs
#    - Use CloudWatch for real-time alerting on suspicious activities
#    - Regularly review and analyze logs for compliance
#
# 7. Deprecated Attribute:
#    - "id" attribute is deprecated, use "cluster_identifier" instead
#
# 8. Region Management:
#    - The region parameter allows explicit region specification
#    - Defaults to provider configuration region if not set
#    - Useful for multi-region deployments
#
# ============================================================
