################################################################################
# AWS Redshift HSM Client Certificate
################################################################################
# Creates an HSM client certificate that an Amazon Redshift cluster will use to
# connect to the client's HSM in order to store and retrieve the keys used to
# encrypt the cluster databases.
#
# Official Documentation:
# https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/redshift_hsm_client_certificate
#
# AWS Documentation:
# https://docs.aws.amazon.com/redshift/latest/mgmt/working-with-db-encryption.html

resource "aws_redshift_hsm_client_certificate" "example" {
  ################################################################################
  # Required Arguments
  ################################################################################

  # (Required, Forces new resource) The identifier of the HSM client certificate.
  # This is a unique identifier for the certificate that will be used by Redshift
  # clusters to authenticate with the Hardware Security Module (HSM).
  hsm_client_certificate_identifier = "example-hsm-cert"

  ################################################################################
  # Optional Arguments
  ################################################################################

  # (Optional) Region where this resource will be managed.
  # Defaults to the Region set in the provider configuration.
  # Uncomment to specify a different region from the default provider region.
  # region = "us-east-1"

  # (Optional) A map of tags to assign to the resource.
  # If configured with a provider default_tags configuration block present,
  # tags with matching keys will overwrite those defined at the provider-level.
  tags = {
    Name        = "example-hsm-client-certificate"
    Environment = "production"
    ManagedBy   = "terraform"
  }

  ################################################################################
  # Computed Attributes (Read-only, exported after creation)
  ################################################################################
  # The following attributes are exported but cannot be set:
  #
  # - arn: Amazon Resource Name (ARN) of the HSM Client Certificate
  # - hsm_client_certificate_public_key: The public key that the Amazon Redshift
  #   cluster will use to connect to the HSM. You must register this public key
  #   in the HSM after the certificate is created.
  # - tags_all: A map of tags assigned to the resource, including those inherited
  #   from the provider default_tags configuration block
}

################################################################################
# Usage Example with Redshift Cluster
################################################################################
# Note: This is an example showing how to use the HSM client certificate with
# a Redshift cluster. Uncomment and modify as needed.
#
# resource "aws_redshift_cluster" "example" {
#   cluster_identifier = "example-cluster"
#   database_name      = "mydb"
#   master_username    = "admin"
#   master_password    = "MyPassword123!"  # Use AWS Secrets Manager in production
#   node_type          = "dc2.large"
#   cluster_type       = "single-node"
#
#   # Enable encryption and reference the HSM client certificate
#   encrypted                      = true
#   hsm_client_certificate_identifier = aws_redshift_hsm_client_certificate.example.hsm_client_certificate_identifier
#   hsm_configuration_identifier   = aws_redshift_hsm_configuration.example.hsm_configuration_identifier
#
#   tags = {
#     Name = "example-cluster"
#   }
# }

################################################################################
# Output Examples
################################################################################

output "hsm_client_certificate_arn" {
  description = "The ARN of the HSM client certificate"
  value       = aws_redshift_hsm_client_certificate.example.arn
}

output "hsm_client_certificate_public_key" {
  description = "The public key of the HSM client certificate that must be registered in the HSM"
  value       = aws_redshift_hsm_client_certificate.example.hsm_client_certificate_public_key
  sensitive   = true
}

output "hsm_client_certificate_identifier" {
  description = "The identifier of the HSM client certificate"
  value       = aws_redshift_hsm_client_certificate.example.hsm_client_certificate_identifier
}
