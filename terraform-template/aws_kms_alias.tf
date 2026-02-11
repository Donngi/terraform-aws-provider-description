# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# aws_kms_alias - KMS Key Alias
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Provides an alias for a KMS customer master key. AWS Console enforces
# 1-to-1 mapping between aliases & keys, but API (hence Terraform too)
# allows you to create as many aliases as the account limits allow you.
#
# Documentation:
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias
# https://docs.aws.amazon.com/kms/latest/developerguide/programming-aliases.html
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

resource "aws_kms_alias" "example" {
  # ──────────────────────────────────────────────────────────────
  # Name Configuration
  # ──────────────────────────────────────────────────────────────
  # The display name of the alias. The name must start with the word
  # "alias" followed by a forward slash (alias/)
  #
  # Conflicts with: name_prefix
  # Format: alias/<alias-name>
  # Example: alias/my-key-alias, alias/production-data
  # ──────────────────────────────────────────────────────────────
  name = "alias/my-key-alias"

  # ──────────────────────────────────────────────────────────────
  # Name Prefix (Alternative)
  # ──────────────────────────────────────────────────────────────
  # Creates an unique alias beginning with the specified prefix.
  # The name must start with the word "alias" followed by a forward
  # slash (alias/). Conflicts with name.
  #
  # Conflicts with: name
  # Format: alias/<prefix>
  # Example: alias/app-, alias/prod-
  # Note: Terraform will append a random suffix to ensure uniqueness
  # ──────────────────────────────────────────────────────────────
  # name_prefix = "alias/my-key-"

  # ──────────────────────────────────────────────────────────────
  # Target Key ID (Required)
  # ──────────────────────────────────────────────────────────────
  # Identifier for the key for which the alias is for, can be either
  # an ARN or key_id.
  #
  # Required: Yes
  # Format: Key ID (UUID) or Key ARN
  # Example:
  #   - Key ID: 1234abcd-12ab-34cd-56ef-1234567890ab
  #   - Key ARN: arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012
  # Reference: aws_kms_key.example.key_id or aws_kms_key.example.arn
  # ──────────────────────────────────────────────────────────────
  target_key_id = aws_kms_key.example.key_id

  # ──────────────────────────────────────────────────────────────
  # Region Configuration
  # ──────────────────────────────────────────────────────────────
  # Region where this resource will be managed. Defaults to the Region
  # set in the provider configuration.
  #
  # Optional: Yes
  # Example: us-east-1, us-west-2, eu-west-1
  # ──────────────────────────────────────────────────────────────
  # region = "us-east-1"
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Outputs
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

output "kms_alias_arn" {
  description = "The Amazon Resource Name (ARN) of the key alias"
  value       = aws_kms_alias.example.arn
}

output "kms_alias_target_key_arn" {
  description = "The Amazon Resource Name (ARN) of the target key identifier"
  value       = aws_kms_alias.example.target_key_arn
}

output "kms_alias_name" {
  description = "The display name of the alias"
  value       = aws_kms_alias.example.name
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Usage Examples
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Example 1: Basic KMS Key with Alias
# ──────────────────────────────────────────────────────────────
# resource "aws_kms_key" "example" {
#   description             = "Example KMS key"
#   deletion_window_in_days = 10
# }
#
# resource "aws_kms_alias" "example" {
#   name          = "alias/my-key-alias"
#   target_key_id = aws_kms_key.example.key_id
# }

# Example 2: Using Name Prefix for Auto-generated Unique Names
# ──────────────────────────────────────────────────────────────
# resource "aws_kms_key" "app" {
#   description = "Application encryption key"
# }
#
# resource "aws_kms_alias" "app" {
#   name_prefix   = "alias/app-"
#   target_key_id = aws_kms_key.app.key_id
# }

# Example 3: Multiple Aliases for Single Key
# ──────────────────────────────────────────────────────────────
# Note: API allows multiple aliases per key (though Console shows 1-to-1)
#
# resource "aws_kms_key" "multi" {
#   description = "Key with multiple aliases"
# }
#
# resource "aws_kms_alias" "primary" {
#   name          = "alias/primary-key"
#   target_key_id = aws_kms_key.multi.key_id
# }
#
# resource "aws_kms_alias" "secondary" {
#   name          = "alias/backup-key"
#   target_key_id = aws_kms_key.multi.key_id
# }

# Example 4: Environment-Specific Aliases
# ──────────────────────────────────────────────────────────────
# resource "aws_kms_key" "production" {
#   description             = "Production data encryption key"
#   deletion_window_in_days = 30
#   enable_key_rotation     = true
#
#   tags = {
#     Environment = "Production"
#     Purpose     = "Data Encryption"
#   }
# }
#
# resource "aws_kms_alias" "production" {
#   name          = "alias/production-data"
#   target_key_id = aws_kms_key.production.key_id
# }

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Important Notes
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# 1. ALIAS NAMING REQUIREMENTS
#    - Must start with "alias/" prefix
#    - Cannot be "alias/aws/" (reserved for AWS managed keys)
#    - Can only contain alphanumeric characters, forward slashes (/),
#      underscores (_), and hyphens (-)
#    - Maximum length: 256 characters

# 2. NAME VS NAME_PREFIX
#    - Use 'name' for explicit, static alias names
#    - Use 'name_prefix' for automatically generated unique names
#    - These two arguments are mutually exclusive

# 3. MULTIPLE ALIASES
#    - While AWS Console enforces 1-to-1 mapping, the API (and Terraform)
#      allows multiple aliases per key
#    - Maximum aliases per key: Check AWS account limits
#    - Default limit: 50,000 aliases per account per region

# 4. TARGET KEY REQUIREMENTS
#    - Can reference key by key_id or full ARN
#    - Key must exist before creating the alias
#    - Key can be in different regions (cross-region aliases not supported)

# 5. UPDATING ALIASES
#    - Changing 'name' or 'name_prefix' forces replacement (destroys and recreates)
#    - Changing 'target_key_id' updates the alias in-place
#    - This allows key rotation without changing application code

# 6. DELETION BEHAVIOR
#    - Deleting an alias does NOT delete the underlying KMS key
#    - Alias is removed immediately upon deletion
#    - Cannot delete AWS managed aliases (alias/aws/*)

# 7. IAM PERMISSIONS
#    Required permissions:
#    - kms:CreateAlias (create)
#    - kms:UpdateAlias (update target_key_id)
#    - kms:DeleteAlias (delete)
#    - kms:ListAliases (read)
#    - kms:DescribeKey (verify target key)

# 8. IMPORTED RESOURCES
#    - Can import existing aliases using: terraform import aws_kms_alias.example alias/my-key-alias
#    - Import ID format: alias/<alias-name>

# 9. BEST PRACTICES
#    - Use descriptive alias names that indicate purpose
#    - Consider environment-specific prefixes (alias/prod-, alias/dev-)
#    - Enable key rotation on the underlying KMS key
#    - Document alias to key mappings in your infrastructure
#    - Use aliases in application code instead of key IDs for flexibility

# 10. COMMON USE CASES
#     - Application-specific encryption keys (alias/app-name)
#     - Environment separation (alias/prod-db, alias/dev-db)
#     - Service-specific keys (alias/s3-encryption, alias/rds-encryption)
#     - Key rotation strategies (update target_key_id without code changes)

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Related Resources
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# - aws_kms_key: Create and manage KMS customer master keys
# - aws_kms_grant: Manage KMS grants for delegated key permissions
# - aws_kms_key_policy: Manage KMS key policies
# - aws_kms_external_key: Manage KMS keys with external key material
# - aws_kms_replica_key: Create KMS multi-region replica keys
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
