/**
 * # aws_redshift_hsm_configuration
 *
 * Resource: aws_redshift_hsm_configuration
 * Provider Version: 6.28.0
 *
 * ## Description
 * Creates an HSM configuration that contains the information required by an Amazon Redshift cluster to store and use database encryption keys in a Hardware Security Module (HSM).
 *
 * ## Features
 * - Hardware Security Module (HSM) configuration for Redshift clusters
 * - Secure storage of database encryption keys
 * - HSM partition and authentication management
 * - Tagging support for resource organization
 * - All arguments force new resource creation
 *
 * ## Important Notes
 * - All required arguments force new resource creation when modified
 * - The hsm_partition_password is marked as sensitive
 * - Public certificate is required for HSM connection
 * - Register the HSM configuration public key in your HSM
 *
 * ## Documentation
 * https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/redshift_hsm_configuration
 */

resource "aws_redshift_hsm_configuration" "example" {
  # ================================
  # Required Arguments
  # ================================

  # (Required, Forces new resource) A text description of the HSM configuration to be created.
  # Type: string
  # Update behavior: Forces new resource
  # Example: "Production HSM configuration for Redshift cluster"
  description = "example"

  # (Required, Forces new resource) The identifier to be assigned to the new Amazon Redshift HSM configuration.
  # Type: string
  # Update behavior: Forces new resource
  # Example: "prod-redshift-hsm-config"
  hsm_configuration_identifier = "example"

  # (Required, Forces new resource) The IP address that the Amazon Redshift cluster must use to access the HSM.
  # Type: string
  # Update behavior: Forces new resource
  # Example: "10.0.1.100"
  hsm_ip_address = "10.0.0.1"

  # (Required, Forces new resource) The name of the partition in the HSM where the Amazon Redshift clusters will store their database encryption keys.
  # Type: string
  # Update behavior: Forces new resource
  # Example: "redshift-partition"
  hsm_partition_name = "aws"

  # (Required, Forces new resource, Sensitive) The password required to access the HSM partition.
  # Type: string
  # Update behavior: Forces new resource
  # Security: This value is marked as sensitive and will not be displayed in logs
  # Example: Use variables or secrets management for production
  hsm_partition_password = "example" # TODO: Replace with secure variable reference

  # (Required, Forces new resource) The HSMs public certificate file.
  # Type: string
  # Update behavior: Forces new resource
  # Note: When using Cloud HSM, the file name is server.pem
  # Example: file("${path.module}/certs/server.pem")
  hsm_server_public_certificate = "example"

  # ================================
  # Optional Arguments
  # ================================

  # (Optional) Region where this resource will be managed.
  # Type: string
  # Default: Inherits from provider configuration
  # Computed: true
  # Example: "us-east-1"
  # region = "us-east-1"

  # (Optional) A map of tags to assign to the resource.
  # Type: map(string)
  # Note: Tags with matching keys will overwrite those defined at the provider default_tags configuration block
  # Example:
  # tags = {
  #   Environment = "production"
  #   Application = "redshift"
  #   ManagedBy   = "terraform"
  # }
  tags = {}

  # ================================
  # Computed Attributes (Read-only)
  # ================================
  # These attributes are set by AWS and cannot be configured:
  #
  # - arn (string)
  #   Amazon Resource Name (ARN) of the HSM configuration
  #   Example: "arn:aws:redshift:us-east-1:123456789012:hsmconfiguration:example"
  #
  # - id (string)
  #   The HSM configuration identifier
  #   Same as hsm_configuration_identifier
  #
  # - hsm_configuration_public_key (string)
  #   The public key that the Amazon Redshift cluster will use to connect to the HSM
  #   Important: You must register this public key in the HSM after creation
  #
  # - tags_all (map(string))
  #   A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block
}

# ================================
# Example Usage Patterns
# ================================

# Example 1: Production HSM Configuration with Cloud HSM
# resource "aws_redshift_hsm_configuration" "production" {
#   description                   = "Production Redshift HSM configuration"
#   hsm_configuration_identifier  = "prod-redshift-hsm"
#   hsm_ip_address                = "10.0.1.100"
#   hsm_partition_name            = "redshift-prod"
#   hsm_partition_password        = var.hsm_partition_password
#   hsm_server_public_certificate = file("${path.module}/certs/server.pem")
#
#   tags = {
#     Environment = "production"
#     Application = "redshift"
#     ManagedBy   = "terraform"
#   }
# }

# Example 2: Development HSM Configuration
# resource "aws_redshift_hsm_configuration" "development" {
#   description                   = "Development Redshift HSM configuration"
#   hsm_configuration_identifier  = "dev-redshift-hsm"
#   hsm_ip_address                = "10.0.2.100"
#   hsm_partition_name            = "redshift-dev"
#   hsm_partition_password        = var.hsm_partition_password_dev
#   hsm_server_public_certificate = file("${path.module}/certs/dev-server.pem")
#   region                        = "us-west-2"
#
#   tags = {
#     Environment = "development"
#     Application = "redshift"
#     ManagedBy   = "terraform"
#   }
# }

# ================================
# Outputs Example
# ================================

# output "hsm_configuration_arn" {
#   description = "The ARN of the HSM configuration"
#   value       = aws_redshift_hsm_configuration.example.arn
# }
#
# output "hsm_configuration_id" {
#   description = "The ID of the HSM configuration"
#   value       = aws_redshift_hsm_configuration.example.id
# }
#
# output "hsm_configuration_public_key" {
#   description = "The public key to register in the HSM"
#   value       = aws_redshift_hsm_configuration.example.hsm_configuration_public_key
#   sensitive   = true
# }
