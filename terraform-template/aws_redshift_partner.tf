################################################################################
# AWS Redshift Partner Integration
################################################################################
# Creates a new Amazon Redshift Partner Integration.
# This resource allows you to authorize a partner to send data to your Redshift cluster.
#
# Provider Version: 6.28.0
# Resource Documentation: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/redshift_partner
################################################################################

resource "aws_redshift_partner" "example" {
  ################################################################################
  # Required Arguments
  ################################################################################

  # (Required) The Amazon Web Services account ID that owns the cluster.
  # This is typically your AWS account ID.
  # Example: "012345678910"
  account_id = "012345678910"

  # (Required) The cluster identifier of the cluster that receives data from the partner.
  # This should reference an existing Redshift cluster.
  # Example: "my-redshift-cluster"
  cluster_identifier = "my-redshift-cluster"

  # (Required) The name of the database that receives data from the partner.
  # This database must exist in the specified Redshift cluster.
  # Example: "my_database"
  database_name = "my_database"

  # (Required) The name of the partner that is authorized to send data.
  # This is the partner integration name provided by AWS or the partner.
  # Example: "example_partner"
  partner_name = "example_partner"

  ################################################################################
  # Optional Arguments
  ################################################################################

  # (Optional) Region where this resource will be managed.
  # Defaults to the Region set in the provider configuration.
  # Example: "us-east-1"
  # region = "us-east-1"

  ################################################################################
  # Read-Only Attributes (Available after creation)
  ################################################################################
  # These attributes are computed by AWS and available after the resource is created:
  #
  # id - The identifier of the Redshift partner, format:
  #      account_id:cluster_identifier:database_name:partner_name
  #
  # status - The partner integration status
  #
  # status_message - The status message provided by the partner
  ################################################################################
}

################################################################################
# Example Usage with Dependencies
################################################################################

# Example showing integration with an existing Redshift cluster
# resource "aws_redshift_partner" "with_cluster_reference" {
#   cluster_identifier = aws_redshift_cluster.example.id
#   account_id         = "012345678910"
#   database_name      = aws_redshift_cluster.example.database_name
#   partner_name       = "example_partner"
# }

################################################################################
# Output Examples
################################################################################

# output "partner_id" {
#   description = "The ID of the Redshift partner integration"
#   value       = aws_redshift_partner.example.id
# }

# output "partner_status" {
#   description = "The status of the partner integration"
#   value       = aws_redshift_partner.example.status
# }

# output "partner_status_message" {
#   description = "The status message from the partner"
#   value       = aws_redshift_partner.example.status_message
# }

################################################################################
# Important Notes
################################################################################
# 1. The cluster_identifier, database_name, and account_id must match an
#    existing Redshift cluster configuration
#
# 2. The partner_name must be a valid partner integration name recognized by AWS
#
# 3. This resource creates a partner integration that allows the specified
#    partner to access data in your Redshift cluster
#
# 4. Ensure proper IAM permissions are in place for the partner integration
#
# 5. The ID format is: account_id:cluster_identifier:database_name:partner_name
#    separated by colons (:)
################################################################################
