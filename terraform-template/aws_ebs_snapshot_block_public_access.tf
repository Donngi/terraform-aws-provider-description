################################################################################
# Resource: aws_ebs_snapshot_block_public_access
# Provider Version: 6.28.0
# Last Updated: 2026-01-28
################################################################################
# Description:
# Provides a resource to manage the state of the "Block public access for snapshots"
# setting at the region level for Amazon EBS snapshots. This feature prevents
# unauthorized public access to EBS snapshots by blocking public sharing.
#
# Important Notes:
# - This is a Regional and account-level setting
# - Removing this Terraform resource disables blocking
# - Does not prevent private snapshot sharing
# - Does not affect EBS-backed AMI public sharing
# - Snapshots already publicly shared remain available when changing modes
# - Not supported with local snapshots on AWS Outposts
# - Enabling this feature does not incur any additional costs
#
# AWS Documentation:
# https://docs.aws.amazon.com/ebs/latest/userguide/block-public-access-snapshots.html
#
# Terraform Documentation:
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ebs_snapshot_block_public_access
################################################################################

resource "aws_ebs_snapshot_block_public_access" "example" {
  ################################################################################
  # Required Arguments
  ################################################################################

  # state - (Required) The mode in which to enable "Block public access for snapshots"
  # for the region.
  #
  # Valid values:
  # - "block-all-sharing": Prevents all public sharing of snapshots. Makes all
  #   publicly shared snapshots private and inaccessible to the public. However,
  #   it does not change the permissions for existing publicly shared snapshots.
  # - "block-new-sharing": Prevents only new public sharing requests. Snapshots
  #   that are already publicly shared remain accessible to the public.
  # - "unblocked": Disables block public access for snapshots, allowing public
  #   sharing.
  #
  # Considerations:
  # - In "block all sharing" mode, existing publicly shared snapshots become no
  #   longer publicly visible and accessible, but their permissions are not changed
  # - In "block new sharing" mode, users can no longer request new public sharing,
  #   but existing publicly shared snapshots remain available
  # - Switching from "block all sharing" to "block new sharing" makes previously
  #   public snapshots publicly available again
  #
  # Type: string
  # Required: Yes
  # AWS API: State parameter in EnableSnapshotBlockPublicAccess
  state = "block-all-sharing"

  ################################################################################
  # Optional Arguments
  ################################################################################

  # region - (Optional) Region where this resource will be managed.
  #
  # Details:
  # - Defaults to the Region set in the provider configuration
  # - Use this to manage block public access settings in a specific region
  # - Each region requires a separate resource instance for region-specific settings
  # - Supported in all regions except Asia Pacific (Thailand), Mexico (Central),
  #   and Asia Pacific (Taipei)
  #
  # Type: string
  # Required: No
  # Default: Provider region
  # AWS API: Region parameter in EnableSnapshotBlockPublicAccess
  # region = "us-east-1"

  ################################################################################
  # Attribute Reference
  ################################################################################
  # No additional attributes are exported beyond the arguments.
}

################################################################################
# Example Configurations
################################################################################

# Example 1: Block all public sharing of EBS snapshots in default region
resource "aws_ebs_snapshot_block_public_access" "block_all" {
  state = "block-all-sharing"
}

# Example 2: Block only new public sharing requests
resource "aws_ebs_snapshot_block_public_access" "block_new" {
  state = "block-new-sharing"
}

# Example 3: Block public access in a specific region
resource "aws_ebs_snapshot_block_public_access" "us_west_2" {
  state  = "block-all-sharing"
  region = "us-west-2"
}

# Example 4: Explicitly allow public sharing (unblock)
resource "aws_ebs_snapshot_block_public_access" "allow_sharing" {
  state = "unblocked"
}

# Example 5: Multi-region deployment
resource "aws_ebs_snapshot_block_public_access" "us_east_1" {
  state  = "block-all-sharing"
  region = "us-east-1"
}

resource "aws_ebs_snapshot_block_public_access" "eu_west_1" {
  state  = "block-all-sharing"
  region = "eu-west-1"
}

resource "aws_ebs_snapshot_block_public_access" "ap_southeast_1" {
  state  = "block-all-sharing"
  region = "ap-southeast-1"
}

################################################################################
# IAM Permissions Required
################################################################################
# The following IAM permissions are required to manage this resource:
#
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Action": [
#         "ec2:EnableSnapshotBlockPublicAccess",
#         "ec2:DisableSnapshotBlockPublicAccess",
#         "ec2:GetSnapshotBlockPublicAccessState"
#       ],
#       "Resource": "*"
#     }
#   ]
# }

################################################################################
# Import
################################################################################
# This resource can be imported using the region name.
#
# Example:
# terraform import aws_ebs_snapshot_block_public_access.example us-east-1
#
# Note: If no region is specified in the configuration, import using the
# provider's default region.

################################################################################
# Best Practices
################################################################################
# 1. Security:
#    - Use "block-all-sharing" for maximum security in production environments
#    - Apply this setting across all regions used in your organization
#    - Combine with AWS Control Tower control CT.EC2.PV.7 for organization-wide enforcement
#
# 2. Compliance:
#    - Enable this feature to meet compliance requirements for data privacy
#    - Use AWS Config rule "ebs-snapshot-block-public-access" to monitor compliance
#    - Document exceptions if "unblocked" mode is required for specific use cases
#
# 3. Migration Strategy:
#    - Start with "block-new-sharing" to prevent new public shares while auditing existing ones
#    - Migrate to "block-all-sharing" after addressing legitimate public snapshots
#    - Use AWS Config to identify and remediate any publicly shared snapshots
#
# 4. Monitoring:
#    - Monitor the setting using CloudWatch Events or AWS Config
#    - Set up alerts for changes to the block public access setting
#    - Regularly audit snapshot sharing permissions
#
# 5. Multi-Account Strategy:
#    - Use AWS Organizations Service Control Policies (SCPs) for organization-wide enforcement
#    - Apply declarative policies at the organizational unit level
#    - Ensure consistent settings across all accounts and regions

################################################################################
# Common Issues and Troubleshooting
################################################################################
# Issue 1: Resource deletion doesn't prevent public sharing
# Solution: Removing this Terraform resource disables blocking. To maintain
#           blocking, keep the resource with state = "block-all-sharing"
#
# Issue 2: Existing public snapshots still accessible
# Solution: In "block-all-sharing" mode, existing public snapshots become
#           inaccessible but permissions aren't changed. Use AWS CLI or Console
#           to modify individual snapshot permissions if needed.
#
# Issue 3: Cannot enable in certain regions
# Solution: This feature is not available in Asia Pacific (Thailand),
#           Mexico (Central), and Asia Pacific (Taipei) regions
#
# Issue 4: AMIs still publicly accessible
# Solution: This resource only affects EBS snapshot sharing, not EBS-backed
#           AMIs. Use separate controls for AMI public sharing.

################################################################################
# Related Resources
################################################################################
# - aws_ebs_snapshot: Manages individual EBS snapshots
# - aws_ebs_snapshot_copy: Copies EBS snapshots across regions
# - aws_ami: Manages Amazon Machine Images
# - aws_organizations_policy: For organization-wide declarative policies

################################################################################
# Terraform Configuration
################################################################################
# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 6.28.0"
#     }
#   }
# }
