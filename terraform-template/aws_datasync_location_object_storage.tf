# ==============================================================================
# Terraform Resource Template: aws_datasync_location_object_storage
# ==============================================================================
# Generated: 2026-01-19
# Provider Version: hashicorp/aws 6.28.0
#
# Description:
#   Manages an Object Storage Location within AWS DataSync.
#   DataSync can use this location as a source or destination for transferring
#   data. Transfers can be made with or without a DataSync agent.
#
# Important Notes:
#   - The DataSync Agents must be available before creating this resource
#   - This template includes all input-capable properties as of generation date
#   - Always refer to the latest official documentation for the most current specifications
#   - Properties marked as "computed only" (arn, uri) are excluded from this template
#
# Official Documentation:
#   - Resource: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/datasync_location_object_storage
#   - API: https://docs.aws.amazon.com/datasync/latest/userguide/API_CreateLocationObjectStorage.html
#   - User Guide: https://docs.aws.amazon.com/datasync/latest/userguide/create-object-location.html
# ==============================================================================

resource "aws_datasync_location_object_storage" "example" {
  # --------------------------------------------------------------------------
  # Required Properties
  # --------------------------------------------------------------------------

  # (Required) The bucket on the self-managed object storage server that is used to read data from.
  # - Type: String
  # - Constraints: 3-63 characters, alphanumeric and special characters allowed
  # - Example: "my-object-storage-bucket"
  # - AWS API Reference: https://docs.aws.amazon.com/datasync/latest/userguide/API_CreateLocationObjectStorage.html#DataSync-CreateLocationObjectStorage-request-BucketName
  bucket_name = "my-bucket"

  # (Required) The name of the self-managed object storage server.
  # - This value is the IP address or Domain Name Service (DNS) name of the object storage server
  # - An agent uses this hostname to mount the object storage server in a network
  # - Type: String
  # - Constraints: Maximum 255 characters, valid hostname or IP address (IPv4 or IPv6)
  # - Example: "object-storage.example.com" or "192.168.1.100"
  # - AWS API Reference: https://docs.aws.amazon.com/datasync/latest/userguide/API_CreateLocationObjectStorage.html#DataSync-CreateLocationObjectStorage-request-ServerHostname
  server_hostname = "object-storage.example.com"

  # --------------------------------------------------------------------------
  # Optional Properties
  # --------------------------------------------------------------------------

  # (Optional) The access key is used if credentials are required to access the self-managed object storage server.
  # - If your object storage requires a user name and password to authenticate, use access_key and secret_key
  # - Type: String
  # - Constraints: 0-200 characters
  # - Example: "AKIAIOSFODNN7EXAMPLE"
  # - Note: Consider using AWS Secrets Manager for secure credential management
  # - AWS API Reference: https://docs.aws.amazon.com/datasync/latest/userguide/API_CreateLocationObjectStorage.html#DataSync-CreateLocationObjectStorage-request-AccessKey
  access_key = "your-access-key"

  # (Optional) A list of DataSync Agent ARNs with which this location will be associated.
  # - For agentless cross-cloud transfers, this parameter does not need to be specified
  # - Type: List of Strings
  # - Constraints: 1-8 items, each maximum 128 characters
  # - Format: arn:aws:datasync:region:account-id:agent/agent-id
  # - Important: Cannot be modified after creation - configure correctly when first creating the location
  # - AWS API Reference: https://docs.aws.amazon.com/datasync/latest/userguide/API_CreateLocationObjectStorage.html#DataSync-CreateLocationObjectStorage-request-AgentArns
  agent_arns = [
    "arn:aws:datasync:us-east-1:123456789012:agent/agent-0123456789abcdef0"
  ]

  # (Optional) The ID of the DataSync Location.
  # - This is primarily used for importing existing resources
  # - Type: String (Computed)
  # - Note: Terraform will compute this value automatically; only set when importing
  # - Generally should not be set manually unless importing an existing resource
  id = null

  # (Optional) Region where this resource will be managed.
  # - Defaults to the Region set in the provider configuration
  # - Type: String (Computed)
  # - Example: "us-east-1", "eu-west-1", "ap-southeast-1"
  # - AWS Reference: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  # (Optional) The secret key is used if credentials are required to access the self-managed object storage server.
  # - If your object storage requires a user name and password to authenticate, use access_key and secret_key
  # - Type: String (Sensitive)
  # - Constraints: 0-200 characters
  # - Note: Consider using AWS Secrets Manager for secure credential management
  # - If provided without CmkSecretConfig or CustomSecretConfig, DataSync stores it in Secrets Manager
  # - AWS API Reference: https://docs.aws.amazon.com/datasync/latest/userguide/API_CreateLocationObjectStorage.html#DataSync-CreateLocationObjectStorage-request-SecretKey
  secret_key = "your-secret-key"

  # (Optional) Specifies a certificate to authenticate with an object storage system that uses a private or self-signed CA.
  # - You must specify a Base64-encoded .pem string
  # - The certificate can be up to 32768 bytes (before Base64 encoding)
  # - Certificate chain might include: object storage system's certificate, intermediate certificates, and root CA certificate
  # - Example command to create certificate chain: cat object_server_certificate.pem intermediate_certificate.pem ca_root_certificate.pem > object_storage_certificates.pem
  # - Type: String (Base64-encoded)
  # - Requires: server_protocol = "HTTPS"
  # - AWS API Reference: https://docs.aws.amazon.com/datasync/latest/userguide/API_CreateLocationObjectStorage.html#DataSync-CreateLocationObjectStorage-request-ServerCertificate
  server_certificate = filebase64("path/to/certificate.pem")

  # (Optional) The port that your self-managed object storage server accepts inbound network traffic on.
  # - The server port is set by default to TCP 80 (HTTP) or TCP 443 (HTTPS)
  # - You can specify a custom port if your self-managed object storage server requires one
  # - Type: Number
  # - Valid Range: 1-65536
  # - Default: 80 for HTTP, 443 for HTTPS
  # - AWS API Reference: https://docs.aws.amazon.com/datasync/latest/userguide/API_CreateLocationObjectStorage.html#DataSync-CreateLocationObjectStorage-request-ServerPort
  server_port = 443

  # (Optional) The protocol that the object storage server uses to communicate.
  # - Valid values: "HTTP" or "HTTPS"
  # - Default: "HTTPS"
  # - Type: String
  # - Note: Use HTTPS for secure communication and when using server_certificate
  # - AWS API Reference: https://docs.aws.amazon.com/datasync/latest/userguide/API_CreateLocationObjectStorage.html#DataSync-CreateLocationObjectStorage-request-ServerProtocol
  server_protocol = "HTTPS"

  # (Optional) A subdirectory in the object storage bucket.
  # - This subdirectory is used to read data from or write data to the object storage server
  # - If the subdirectory isn't specified, it will default to "/"
  # - Type: String
  # - Constraints: Maximum 4096 characters
  # - Pattern: Alphanumeric, hyphens, underscores, plus signs, periods, parentheses, dollar signs, and spaces
  # - If this is a source location, DataSync only copies objects with this prefix
  # - If this is a destination location, DataSync writes all objects with this prefix
  # - AWS API Reference: https://docs.aws.amazon.com/datasync/latest/userguide/API_CreateLocationObjectStorage.html#DataSync-CreateLocationObjectStorage-request-Subdirectory
  subdirectory = "/data/exports"

  # (Optional) Key-value pairs of resource tags to assign to the DataSync Location.
  # - Type: Map of Strings
  # - Constraints: Maximum 50 tags, each key up to 128 characters, each value up to 256 characters
  # - If configured with a provider default_tags configuration block, tags with matching keys will overwrite those defined at the provider-level
  # - AWS API Reference: https://docs.aws.amazon.com/datasync/latest/userguide/API_CreateLocationObjectStorage.html#DataSync-CreateLocationObjectStorage-request-Tags
  tags = {
    Name        = "My Object Storage Location"
    Environment = "Production"
    ManagedBy   = "Terraform"
  }

  # (Optional) A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block.
  # - Type: Map of Strings (Computed)
  # - This is automatically managed by Terraform when using provider-level default_tags
  # - Do not set manually; Terraform computes this value
  # - Only use when you need to override provider-level default_tags
  tags_all = null
}

# ==============================================================================
# Computed Attributes (Read-Only)
# ==============================================================================
# These attributes are computed by AWS and cannot be set in the configuration.
# Access them using: aws_datasync_location_object_storage.example.<attribute_name>
#
# - arn: Amazon Resource Name (ARN) of the DataSync Location
#   Format: arn:aws:datasync:region:account-id:location/loc-*
#
# - uri: The URL of the Object Storage location that was described
#   Example: object-storage://server-hostname/bucket-name/subdirectory
#
# - tags_all: Map of tags assigned to the resource, including provider default_tags
# ==============================================================================

# ==============================================================================
# Usage Examples
# ==============================================================================

# Example 1: Basic Object Storage Location (Minimal Configuration)
# resource "aws_datasync_location_object_storage" "basic" {
#   server_hostname = "192.168.1.100"
#   bucket_name     = "my-bucket"
#   agent_arns      = [aws_datasync_agent.example.arn]
# }

# Example 2: Object Storage with Authentication
# resource "aws_datasync_location_object_storage" "authenticated" {
#   server_hostname = "object-storage.example.com"
#   bucket_name     = "secure-bucket"
#   agent_arns      = [aws_datasync_agent.example.arn]
#   access_key      = var.object_storage_access_key
#   secret_key      = var.object_storage_secret_key
#   server_protocol = "HTTPS"
#   server_port     = 443
#
#   tags = {
#     Name = "Authenticated Object Storage"
#   }
# }

# Example 3: Object Storage with Custom Certificate
# resource "aws_datasync_location_object_storage" "with_certificate" {
#   server_hostname    = "private-storage.internal"
#   bucket_name        = "private-bucket"
#   agent_arns         = [aws_datasync_agent.example.arn]
#   server_protocol    = "HTTPS"
#   server_certificate = filebase64("${path.module}/certificates/storage-ca.pem")
#   subdirectory       = "/backups/daily"
#
#   tags = {
#     Name = "Private Object Storage with Custom CA"
#   }
# }

# Example 4: Agentless Cross-Cloud Transfer
# resource "aws_datasync_location_object_storage" "agentless" {
#   server_hostname = "cloud-storage.example.com"
#   bucket_name     = "cross-cloud-bucket"
#   access_key      = var.cloud_storage_access_key
#   secret_key      = var.cloud_storage_secret_key
#   server_protocol = "HTTPS"
#   server_port     = 443
#   subdirectory    = "/sync/data"
#
#   # Note: agent_arns is not specified for agentless transfers
#
#   tags = {
#     Name     = "Agentless Cloud Storage"
#     Transfer = "Cross-Cloud"
#   }
# }
# ==============================================================================
