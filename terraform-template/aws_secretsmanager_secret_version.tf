################################################################################
# AWS Secrets Manager Secret Version
################################################################################
# Manages a version of an AWS Secrets Manager secret including its secret value.
# To manage secret metadata, see aws_secretsmanager_secret resource.
#
# Provider Version: 6.28.0
# Resource Documentation: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version
#
# IMPORTANT NOTES:
# - If the AWSCURRENT staging label is present on this version during resource
#   deletion, that label cannot be removed and will be skipped to prevent errors.
#   The secret version will remain active even after Terraform resource deletion
#   unless the secret itself is deleted.
# - Move the AWSCURRENT staging label before or after deleting this resource
#   to fully trigger version deprecation if necessary.
# - Write-Only arguments (secret_string_wo) are supported in Terraform 1.11.0+
################################################################################

resource "aws_secretsmanager_secret_version" "example" {
  ################################################################################
  # Required Arguments
  ################################################################################

  # (Required) secret_id - string
  # Specifies the secret to which you want to add a new version.
  # You can specify either the ARN or the friendly name of the secret.
  # The secret must already exist.
  #
  # Example:
  #   secret_id = aws_secretsmanager_secret.example.id
  #   secret_id = "arn:aws:secretsmanager:us-east-1:123456789012:secret:MySecret-AbCdEf"
  secret_id = aws_secretsmanager_secret.example.id

  ################################################################################
  # Secret Content (One of these is required)
  ################################################################################

  # (Optional) secret_string - string (sensitive)
  # Specifies text data that you want to encrypt and store in this version.
  # This is required if secret_binary or secret_string_wo is not set.
  #
  # For simple string values:
  #   secret_string = "example-string-to-protect"
  #
  # For key-value pairs (recommended for structured data):
  #   secret_string = jsonencode({
  #     key1 = "value1"
  #     key2 = "value2"
  #   })
  #
  # Note: This attribute is sensitive and will be masked in Terraform output.
  secret_string = "example-string-to-protect"

  # (Optional) secret_string_wo - string (sensitive, write-only)
  # Write-Only version of secret_string. Available in Terraform 1.11.0+
  # This is required if secret_binary or secret_string is not set.
  #
  # Example:
  #   secret_string_wo = "example-string-to-protect"
  #
  # Note: This is a write-only argument and will not be stored in state.
  # secret_string_wo = null

  # (Optional) secret_string_wo_version - number
  # Used together with secret_string_wo to trigger an update.
  # Increment this value when an update to secret_string_wo is required.
  #
  # Example:
  #   secret_string_wo_version = 1
  # secret_string_wo_version = null

  # (Optional) secret_binary - string (sensitive)
  # Specifies binary data that you want to encrypt and store in this version.
  # This is required if secret_string or secret_string_wo is not set.
  # Needs to be encoded to base64.
  #
  # Example:
  #   secret_binary = base64encode(file("path/to/binary/file"))
  # secret_binary = null

  ################################################################################
  # Optional Arguments
  ################################################################################

  # (Optional) version_stages - set(string)
  # Computed: true
  # Specifies a list of staging labels that are attached to this version.
  # A staging label must be unique to a single version of the secret.
  # If you specify a staging label that's already associated with a different
  # version of the same secret, that label is automatically removed from the
  # other version and attached to this version.
  #
  # If not specified, AWS Secrets Manager automatically moves the AWSCURRENT
  # staging label to this new version on creation.
  #
  # IMPORTANT: If version_stages is configured, you must include the AWSCURRENT
  # staging label if this secret version is the only version or if the label is
  # currently present on this secret version, otherwise Terraform will show a
  # perpetual difference.
  #
  # Example:
  #   version_stages = ["AWSCURRENT"]
  #   version_stages = ["AWSCURRENT", "PRODUCTION"]
  # version_stages = null

  # (Optional) region - string
  # Computed: true
  # Region where this resource will be managed.
  # Defaults to the Region set in the provider configuration.
  #
  # Example:
  #   region = "us-east-1"
  # region = null

  ################################################################################
  # Computed Attributes (Read-Only)
  ################################################################################

  # arn - string
  # The ARN of the secret.
  # Example: "arn:aws:secretsmanager:us-east-1:123456789012:secret:MySecret-AbCdEf"

  # id - string
  # A pipe delimited combination of secret ID and version ID.
  # Example: "arn:aws:secretsmanager:us-east-1:123456789012:secret:MySecret-AbCdEf|12345678-1234-1234-1234-123456789012"

  # version_id - string
  # The unique identifier of the version of the secret.
  # Example: "12345678-1234-1234-1234-123456789012"

  # has_secret_string_wo - bool
  # Indicates whether the secret_string_wo argument is set.
  # Computed value, automatically determined by Terraform.

  ################################################################################
  # Usage Examples
  ################################################################################

  # Example 1: Simple String Value
  # resource "aws_secretsmanager_secret_version" "simple" {
  #   secret_id     = aws_secretsmanager_secret.example.id
  #   secret_string = "example-string-to-protect"
  # }

  # Example 2: Key-Value Pairs (JSON)
  # variable "database_credentials" {
  #   default = {
  #     username = "admin"
  #     password = "super-secret-password"
  #   }
  #   type      = map(string)
  #   sensitive = true
  # }
  #
  # resource "aws_secretsmanager_secret_version" "db_creds" {
  #   secret_id     = aws_secretsmanager_secret.database.id
  #   secret_string = jsonencode(var.database_credentials)
  # }

  # Example 3: Using Write-Only Arguments (Terraform 1.11.0+)
  # resource "aws_secretsmanager_secret_version" "write_only" {
  #   secret_id                = aws_secretsmanager_secret.example.id
  #   secret_string_wo         = "example-string-to-protect"
  #   secret_string_wo_version = 1  # Increment when updating secret
  # }

  # Example 4: Binary Data
  # resource "aws_secretsmanager_secret_version" "binary" {
  #   secret_id     = aws_secretsmanager_secret.certificate.id
  #   secret_binary = base64encode(file("${path.module}/certificate.pem"))
  # }

  # Example 5: Custom Version Stages
  # resource "aws_secretsmanager_secret_version" "staged" {
  #   secret_id      = aws_secretsmanager_secret.example.id
  #   secret_string  = jsonencode({ key = "value" })
  #   version_stages = ["AWSCURRENT", "PRODUCTION"]
  # }

  ################################################################################
  # Data Source Usage
  ################################################################################

  # To retrieve this secret version in another configuration:
  # data "aws_secretsmanager_secret_version" "current" {
  #   secret_id = aws_secretsmanager_secret.example.id
  # }
  #
  # # Access the secret value:
  # output "secret_value" {
  #   value     = data.aws_secretsmanager_secret_version.current.secret_string
  #   sensitive = true
  # }
  #
  # # For JSON secrets, decode the value:
  # locals {
  #   db_creds = jsondecode(data.aws_secretsmanager_secret_version.current.secret_string)
  # }
  #
  # output "db_username" {
  #   value     = local.db_creds["username"]
  #   sensitive = true
  # }

  ################################################################################
  # Best Practices
  ################################################################################

  # 1. Secret Rotation:
  #    - Use aws_secretsmanager_secret_rotation to automate secret rotation
  #    - Ensure applications can handle secret rotation gracefully
  #
  # 2. Version Management:
  #    - Use version_stages to manage multiple versions (e.g., current vs. pending)
  #    - Be careful when deleting versions with AWSCURRENT label
  #
  # 3. Security:
  #    - Always mark outputs containing secrets as sensitive = true
  #    - Use IAM policies to restrict access to secrets
  #    - Enable CloudTrail logging for secret access audit
  #
  # 4. JSON Secrets:
  #    - Use jsonencode() for structured data (recommended)
  #    - Use jsondecode() when reading JSON secrets
  #    - Validate JSON structure before encoding
  #
  # 5. Write-Only Arguments (Terraform 1.11.0+):
  #    - Use secret_string_wo for better security (not stored in state)
  #    - Increment secret_string_wo_version to trigger updates
  #    - Requires Terraform 1.11.0 or later
  #
  # 6. Cross-Region Replication:
  #    - Use aws_secretsmanager_secret_replica for multi-region availability
  #    - Ensure secret versions are replicated appropriately
  #
  # 7. Cost Optimization:
  #    - Clean up old secret versions that are no longer needed
  #    - Use version_stages to identify active versions
  #    - Monitor secret storage costs in AWS Cost Explorer

  ################################################################################
  # Related Resources
  ################################################################################

  # - aws_secretsmanager_secret: Manages secret metadata
  # - aws_secretsmanager_secret_rotation: Manages automatic secret rotation
  # - aws_secretsmanager_secret_policy: Manages resource-based policies
  # - aws_secretsmanager_secret_replica: Manages cross-region secret replication
  # - aws_iam_policy: Create policies to control access to secrets
}

################################################################################
# Companion Secret Resource Example
################################################################################

# You need to create the secret first before creating a version
resource "aws_secretsmanager_secret" "example" {
  name        = "example-secret"
  description = "Example secret for demonstration"

  # Optional: Enable recovery window (7-30 days, or 0 for immediate deletion)
  recovery_window_in_days = 7

  # Optional: Tags for resource organization
  tags = {
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}

################################################################################
# Output Examples
################################################################################

# Output the secret ARN (safe to expose)
output "secret_arn" {
  description = "The ARN of the secret"
  value       = aws_secretsmanager_secret_version.example.arn
}

# Output the version ID (safe to expose)
output "secret_version_id" {
  description = "The unique identifier of the secret version"
  value       = aws_secretsmanager_secret_version.example.version_id
}

# Output the secret value (MUST be marked as sensitive)
# output "secret_value" {
#   description = "The secret string value"
#   value       = aws_secretsmanager_secret_version.example.secret_string
#   sensitive   = true
# }
