# ============================================================
# AWS Lake Formation Identity Center Configuration
# ============================================================
# Description:
#   Manages an AWS Lake Formation Identity Center Configuration.
#   This resource integrates Lake Formation with IAM Identity Center
#   (formerly AWS SSO) to enable centralized access management for
#   data lake resources.
#
# Provider Version: 6.28.0
# Resource: aws_lakeformation_identity_center_configuration
# Documentation: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lakeformation_identity_center_configuration
# ============================================================

resource "aws_lakeformation_identity_center_configuration" "example" {
  # ============================================================
  # Required Arguments
  # ============================================================

  # instance_arn - (Required)
  # Type: string
  # Description: ARN of the IAM Identity Center Instance to associate.
  #
  # This is the ARN of your Identity Center instance that will be
  # integrated with Lake Formation. You can retrieve this from the
  # aws_ssoadmin_instances data source.
  #
  # Example: arn:aws:sso:::instance/ssoins-1234567890abcdef
  instance_arn = "arn:aws:sso:::instance/ssoins-1234567890abcdef"


  # ============================================================
  # Optional Arguments
  # ============================================================

  # catalog_id - (Optional, Computed)
  # Type: string
  # Description: Identifier for the Data Catalog. By default, the account ID.
  #
  # The AWS account ID that contains the catalog. If not specified,
  # defaults to the current AWS account ID.
  #
  # Default: Current AWS Account ID
  # Example: "123456789012"
  # catalog_id = "123456789012"

  # region - (Optional, Computed)
  # Type: string
  # Description: Region where this resource will be managed.
  #
  # Specifies the AWS region where the Lake Formation Identity Center
  # configuration will be created. Defaults to the region set in the
  # provider configuration.
  #
  # Reference: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # Default: Provider region
  # Example: "us-east-1"
  # region = "us-east-1"


  # ============================================================
  # Computed Attributes (Read-Only)
  # ============================================================
  # The following attributes are exported and can be referenced:
  #
  # application_arn - ARN of the Lake Formation application integrated
  #                   with IAM Identity Center.
  #                   Example: arn:aws:lakeformation:us-east-1:123456789012:application/app-id
  #
  # resource_share - ARN of the Resource Access Manager (RAM) resource share.
  #                  This is automatically created when integrating Lake Formation
  #                  with Identity Center to enable cross-account sharing.
  #                  Example: arn:aws:ram:us-east-1:123456789012:resource-share/share-id
}


# ============================================================
# Usage Example with SSO Admin Instances Data Source
# ============================================================
# Typical pattern to retrieve the Identity Center instance ARN:
#
# data "aws_ssoadmin_instances" "example" {}
#
# resource "aws_lakeformation_identity_center_configuration" "example" {
#   instance_arn = data.aws_ssoadmin_instances.example.arns[0]
# }


# ============================================================
# Important Notes
# ============================================================
# 1. Prerequisites:
#    - IAM Identity Center must be enabled in your AWS organization
#    - The account must have permissions to access Identity Center
#    - Lake Formation must be configured in the target region
#
# 2. Integration Impact:
#    - Creates a Resource Access Manager (RAM) resource share
#    - Enables Identity Center users/groups to access Lake Formation
#    - Centralizes access management through Identity Center
#
# 3. Regional Considerations:
#    - Identity Center is global, but Lake Formation is regional
#    - You may need separate configurations per region
#    - Ensure the region parameter matches your Lake Formation setup
#
# 4. Access Management:
#    - After configuration, use aws_lakeformation_permissions to grant
#      specific data lake permissions to Identity Center principals
#    - Identity Center users/groups can be referenced by their ARNs
#
# 5. Resource Deletion:
#    - Deleting this resource removes the Identity Center integration
#    - Existing Lake Formation permissions for Identity Center principals
#      may need to be cleaned up separately
