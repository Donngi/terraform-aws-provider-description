################################################################################
# AWS Redshift Endpoint Authorization
################################################################################
# Creates a new Amazon Redshift endpoint authorization.
#
# This resource allows you to grant access to a Redshift cluster to another
# AWS account, enabling cross-account VPC endpoint connections.
#
# Official Documentation:
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/redshift_endpoint_authorization
# https://docs.aws.amazon.com/redshift/latest/mgmt/managing-cluster-cross-vpc.html
################################################################################

resource "aws_redshift_endpoint_authorization" "example" {
  ################################################################################
  # Required Arguments
  ################################################################################

  # (Required) The Amazon Web Services account ID to grant access to.
  #
  # This is the AWS account ID that will be authorized to create Redshift-managed
  # VPC endpoints to connect to the cluster.
  #
  # Example: "012345678910"
  account = "012345678910"

  # (Required) The cluster identifier of the cluster to grant access to.
  #
  # This is the identifier of the Redshift cluster that you want to share with
  # another AWS account.
  #
  # Example: "my-redshift-cluster"
  cluster_identifier = "my-redshift-cluster"

  ################################################################################
  # Optional Arguments
  ################################################################################

  # (Optional) The virtual private cloud (VPC) identifiers to grant access to.
  #
  # If none are specified, all VPCs in the shared account are allowed access.
  # Use this to restrict access to specific VPCs in the grantee account.
  #
  # Type: set(string)
  # Default: null (all VPCs allowed)
  #
  # Example:
  # vpc_ids = ["vpc-12345678", "vpc-87654321"]
  vpc_ids = null

  # (Optional) Indicates whether to force the revoke action.
  #
  # If true, the Redshift-managed VPC endpoints associated with the endpoint
  # authorization are also deleted when the authorization is revoked.
  #
  # Type: bool
  # Default: false
  #
  # Example: true
  force_delete = false

  # (Optional) Region where this resource will be managed.
  #
  # Defaults to the Region set in the provider configuration.
  # Specifying this allows you to manage resources in a region different from
  # the provider default.
  #
  # Type: string
  # Default: Provider region
  #
  # Example: "us-west-2"
  # region = "us-west-2"

  ################################################################################
  # Computed Attributes (Read-Only)
  ################################################################################
  # These attributes are computed by AWS and cannot be set directly:
  #
  # - id                  : The identifier of the Redshift Endpoint Authorization,
  #                         format: "account:cluster_identifier"
  #                         Example: "012345678910:my-redshift-cluster"
  #
  # - allowed_all_vpcs    : Indicates whether all VPCs in the grantee account
  #                         are allowed access to the cluster
  #                         Type: bool
  #
  # - endpoint_count      : The number of Redshift-managed VPC endpoints created
  #                         for the authorization
  #                         Type: number
  #
  # - grantee             : The Amazon Web Services account ID of the grantee of
  #                         the cluster
  #                         Type: string
  #
  # - grantor             : The Amazon Web Services account ID of the cluster owner
  #                         Type: string
  ################################################################################
}

################################################################################
# Additional Examples
################################################################################

# Example 1: Grant access to specific VPCs only
# resource "aws_redshift_endpoint_authorization" "specific_vpcs" {
#   account            = "012345678910"
#   cluster_identifier = aws_redshift_cluster.main.cluster_identifier
#   vpc_ids            = ["vpc-12345678", "vpc-87654321"]
# }

# Example 2: Grant access with force delete enabled
# resource "aws_redshift_endpoint_authorization" "force_delete" {
#   account            = "012345678910"
#   cluster_identifier = aws_redshift_cluster.main.cluster_identifier
#   force_delete       = true
# }

# Example 3: Grant access to all VPCs in grantee account
# resource "aws_redshift_endpoint_authorization" "all_vpcs" {
#   account            = "012345678910"
#   cluster_identifier = aws_redshift_cluster.main.cluster_identifier
#   # vpc_ids is omitted, allowing all VPCs
# }

# Example 4: Cross-region endpoint authorization
# resource "aws_redshift_endpoint_authorization" "cross_region" {
#   account            = "012345678910"
#   cluster_identifier = aws_redshift_cluster.main.cluster_identifier
#   region             = "eu-west-1"
# }

################################################################################
# Important Notes
################################################################################
# 1. Cross-Account Access: This resource enables cross-account access to your
#    Redshift cluster. Ensure you trust the account you're granting access to.
#
# 2. VPC Restrictions: If vpc_ids is not specified, all VPCs in the grantee
#    account are allowed. For better security, explicitly specify the VPCs.
#
# 3. Force Delete: Setting force_delete to true will delete all associated
#    VPC endpoints when revoking authorization. Use with caution.
#
# 4. Endpoint Management: The grantee account can create Redshift-managed VPC
#    endpoints using aws_redshift_endpoint_access resource.
#
# 5. IAM Permissions: The cluster owner account needs appropriate IAM permissions
#    to manage endpoint authorizations.
#
# 6. Pricing: There may be data transfer charges for cross-account access.
#    Review AWS pricing documentation.
#
# 7. Resource Identifier: The resource ID is in the format "account:cluster_identifier"
#    and can be used for imports: terraform import aws_redshift_endpoint_authorization.example 012345678910:my-cluster
#
# 8. Dependencies: Ensure the Redshift cluster exists before creating the
#    endpoint authorization.
################################################################################

################################################################################
# Related Resources
################################################################################
# - aws_redshift_cluster              : The Redshift cluster to grant access to
# - aws_redshift_endpoint_access      : Create VPC endpoint access (grantee side)
# - aws_vpc                           : VPC configuration for endpoint access
################################################################################
