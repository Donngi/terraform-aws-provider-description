################################################################################
# KMS Replica Key
################################################################################
# Manages a KMS multi-Region replica key that replicates a primary key from
# another AWS Region. Multi-Region keys enable interoperability between keys
# in different Regions, allowing data encrypted in one Region to be decrypted
# in another Region without re-encrypting or making cross-Region calls.
#
# Use Cases:
# - Disaster recovery: Decrypt data in a failover Region without re-encryption
# - Global data management: Access encrypted data across multiple Regions
# - Distributed signing applications: Generate identical signatures in multiple Regions
# - Active-active applications: Support workloads spanning multiple Regions
#
# Important Security Considerations:
# - Multi-Region keys involve moving key material across Region boundaries
# - Requires careful access control policy management across all Regions
# - Auditing is more complex, requiring CloudTrail event reconciliation across Regions
# - Data residency compliance may be impacted - evaluate regulatory requirements
# - Each replica key has its own independent key policy (not shared with primary)
# - Replica keys are fully functional and can be used even if primary is disabled
#
# Best Practices:
# - Use multi-Region keys only when necessary for compliance, disaster recovery, or backup
# - Implement consistent key policies across all related multi-Region keys
# - Use kms:MultiRegion and kms:ReplicaRegion condition keys to control replication
# - Monitor CloudTrail logs in all Regions where replica keys exist
# - Document which Regions contain replica keys for your primary keys
# - Consider data residency requirements before creating replica keys
#
# AWS Provider Version: 6.28.0
# Related Resources: aws_kms_key (primary multi-Region key)
# Documentation: https://docs.aws.amazon.com/kms/latest/developerguide/multi-region-keys-overview.html

resource "aws_kms_replica_key" "example" {
  # (Required) The ARN of the multi-Region primary key to replicate
  # The primary key must be in a different AWS Region of the same AWS Partition
  # You can create only one replica of a given primary key in each AWS Region
  # Example: "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
  primary_key_arn = aws_kms_key.primary.arn

  # (Optional) Region where this replica key will be managed
  # Defaults to the Region set in the provider configuration
  # Must be different from the primary key's Region
  # region = "us-west-2"

  # (Optional) A description of the KMS replica key
  # Helps identify the purpose and relationship to the primary key
  description = "Multi-Region replica key for disaster recovery"

  # (Optional) Specifies whether the replica key is enabled
  # Disabled KMS keys cannot be used in cryptographic operations
  # Default: true
  # Note: Replica keys can be enabled/disabled independently of their primary key
  enabled = true

  # (Optional) The waiting period before AWS KMS deletes the key after deletion request
  # Must be between 7 and 30 days, inclusive
  # Default: 30 days
  # Note: This is an independent property - can differ from primary key's setting
  deletion_window_in_days = 30

  # (Optional) The key policy to attach to the replica key
  # If not specified, AWS KMS attaches the default key policy
  # Important: Each replica key has its own independent key policy (not shared)
  # The policy must allow the calling principal to make subsequent PutKeyPolicy requests
  # Recommendation: Keep key policies consistent across all related multi-Region keys
  # policy = jsonencode({
  #   Version = "2012-10-17"
  #   Statement = [
  #     {
  #       Sid    = "Enable IAM User Permissions"
  #       Effect = "Allow"
  #       Principal = {
  #         AWS = "arn:aws:iam::123456789012:root"
  #       }
  #       Action   = "kms:*"
  #       Resource = "*"
  #     },
  #     {
  #       Sid    = "Allow use of the key for encryption/decryption"
  #       Effect = "Allow"
  #       Principal = {
  #         AWS = "arn:aws:iam::123456789012:role/MyApplicationRole"
  #       }
  #       Action = [
  #         "kms:Decrypt",
  #         "kms:DescribeKey",
  #         "kms:Encrypt",
  #         "kms:GenerateDataKey*",
  #         "kms:ReEncrypt*"
  #       ]
  #       Resource = "*"
  #     }
  #   ]
  # })

  # (Optional) A flag to bypass the key policy lockout safety check
  # Setting this to true increases the risk that the key becomes unmanageable
  # Do not set this value to true indiscriminately
  # Default: false
  # Use case: When you intentionally want to create a key policy without granting yourself admin access
  bypass_policy_lockout_safety_check = false

  # (Optional) A map of tags to assign to the replica key
  # Tags are independent properties - not shared with primary or other replica keys
  # If configured with provider default_tags, matching keys will overwrite provider-level tags
  tags = {
    Name        = "example-kms-replica-key"
    Environment = "production"
    Region      = "replica"
    ManagedBy   = "terraform"
    # Consider adding tags to identify the relationship with the primary key
    PrimaryKeyRegion = "us-east-1"
    ReplicaRegion    = "us-west-2"
  }
}

################################################################################
# Outputs
################################################################################

output "kms_replica_key_arn" {
  description = "The Amazon Resource Name (ARN) of the replica key. Related multi-Region keys differ only in the Region value."
  value       = aws_kms_replica_key.example.arn
}

output "kms_replica_key_id" {
  description = "The key ID of the replica key. Related multi-Region keys have the same key ID."
  value       = aws_kms_replica_key.example.key_id
}

output "kms_replica_key_rotation_enabled" {
  description = "A Boolean value that specifies whether key rotation is enabled. This is a shared property of multi-Region keys."
  value       = aws_kms_replica_key.example.key_rotation_enabled
}

output "kms_replica_key_spec" {
  description = "The type of key material in the KMS key. This is a shared property of multi-Region keys."
  value       = aws_kms_replica_key.example.key_spec
}

output "kms_replica_key_usage" {
  description = "The cryptographic operations for which you can use the KMS key. This is a shared property of multi-Region keys."
  value       = aws_kms_replica_key.example.key_usage
}

output "kms_replica_key_tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from provider default_tags configuration block."
  value       = aws_kms_replica_key.example.tags_all
}

################################################################################
# Example: Multi-Region Key Setup (Primary Key)
################################################################################
# This example shows how to create a multi-Region primary key that can be
# replicated. You would create this in your primary Region.

# Example for AWS Provider v6+
resource "aws_kms_key" "primary" {
  # Specify the Region where the primary key should be created
  region = "us-east-1"

  description             = "Multi-Region primary key"
  deletion_window_in_days = 30

  # (Required) Must be set to true to create a multi-Region key
  multi_region = true

  # Enable automatic key rotation (shared property across all replica keys)
  enable_key_rotation = true

  tags = {
    Name        = "example-kms-primary-key"
    Environment = "production"
    Region      = "primary"
    ManagedBy   = "terraform"
  }
}

################################################################################
# Additional Notes
################################################################################
#
# Shared Properties (synchronized across all related multi-Region keys):
# - key_id: All related multi-Region keys have the same key ID
# - key_material: Same cryptographic key material across all keys
# - key_material_origin: AWS_KMS or EXTERNAL (for imported key material)
# - key_spec: Key type (SYMMETRIC_DEFAULT, RSA_2048, etc.)
# - key_usage: Cryptographic operations (ENCRYPT_DECRYPT, SIGN_VERIFY)
# - automatic_key_rotation: Rotation setting is shared
#
# Independent Properties (can differ across related multi-Region keys):
# - description: Each key can have its own description
# - enabled: Keys can be enabled/disabled independently
# - deletion_window_in_days: Deletion window can vary
# - policy: Each key has its own key policy (must manage separately)
# - tags: Tags are independent and not shared
# - aliases: Aliases are Region-specific
#
# Cross-Region Replication Process:
# - AWS KMS uses cryptographically signed messages and ephemeral ECDH keys
# - Key material is encrypted during transit between Regions
# - Replication creates a fully functional independent KMS key in the new Region
# - CloudTrail logs ReplicateKey in primary Region and CreateKey in replica Region
#
# Access Control Considerations:
# - kms:ReplicateKey permission required in primary key's key policy
# - kms:CreateKey permission required in IAM policy for replica Region
# - Use kms:ReplicaRegion condition key to limit where keys can be replicated
# - Use kms:MultiRegion condition key to control multi-Region key creation
# - IAM policies apply to all Regions by default (use aws:RequestedRegion to limit)
#
# Cost Considerations:
# - Each multi-Region key (primary + replicas) is priced separately
# - Standard KMS pricing applies per key per Region
# - Cross-Region replication is a one-time operation (no ongoing data transfer costs)
#
# Limitations:
# - Cannot create more than one replica of a primary key in each AWS Region
# - Cannot convert single-Region keys to multi-Region keys
# - Primary key must be in a different Region within the same AWS Partition
# - Multi-Region keys with EXTERNAL origin require manual import of key material to each replica
#
# Security Recommendations:
# - Regularly audit key policies across all Regions for consistency
# - Monitor CloudTrail logs in all Regions where replica keys exist
# - Use SCPs (Service Control Policies) to restrict multi-Region key creation if not needed
# - Implement least-privilege access using condition keys
# - Document your multi-Region key architecture and Region dependencies
# - Consider data residency and compliance requirements before replication
