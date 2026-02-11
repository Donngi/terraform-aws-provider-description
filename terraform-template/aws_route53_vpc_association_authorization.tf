################################################################################
# aws_route53_vpc_association_authorization
################################################################################
# Version: 6.28.0
# Summary: Authorizes a VPC in a different account to be associated with a local Route53 Hosted Zone.
#
# Description:
# This resource authorizes a Virtual Private Cloud (VPC) in a different AWS account
# to be associated with a private Route53 hosted zone. This is required for cross-account
# VPC associations with private hosted zones.
#
# Use Case:
# - Enabling DNS resolution for resources in a VPC from a different AWS account
# - Multi-account architectures where a central account manages Route53 hosted zones
# - Allowing subsidiary accounts to associate their VPCs with centrally managed zones
#
# Key Features:
# - Cross-account VPC association authorization
# - Region-specific VPC authorization
# - Works in conjunction with aws_route53_zone_association
#
# Best Practices:
# - Use provider aliases to manage resources in different AWS accounts
# - Delete the authorization after the association is established to prevent future reassociations
# - Ensure both VPCs have DNS hostnames and DNS support enabled
# - Each VPC requires a separate authorization request
#
# Important Notes:
# - The hosted zone must be a private hosted zone
# - Both accounts must be in the same AWS partition
# - Authorization must be created before the actual association
# - The VPC owner account must then call AssociateVPCWithHostedZone API
#
# Documentation:
# - Terraform: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_vpc_association_authorization
# - AWS API: https://docs.aws.amazon.com/Route53/latest/APIReference/API_CreateVPCAssociationAuthorization.html
# - AWS Guide: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/hosted-zone-private-associate-vpcs-different-accounts.html
################################################################################

resource "aws_route53_vpc_association_authorization" "example" {
  #=============================================================================
  # Required Arguments
  #=============================================================================

  # zone_id: (Required) The ID of the private hosted zone that you want to
  # authorize associating a VPC with.
  # - This must be a private hosted zone ID
  # - Format: Z1234567890ABC
  # - The hosted zone must exist before creating this authorization
  zone_id = "Z1234567890ABC" # Replace with your hosted zone ID

  # vpc_id: (Required) The VPC to authorize for association with the private
  # hosted zone.
  # - This is the VPC from the OTHER account that will be associated
  # - Format: vpc-xxxxxxxxxxxxxxxxx
  # - The VPC must exist in the target account
  vpc_id = "vpc-12345678" # Replace with the VPC ID from the other account

  #=============================================================================
  # Optional Arguments
  #=============================================================================

  # vpc_region: (Optional) The VPC's region.
  # - Defaults to the region of the AWS provider
  # - Specify this if the VPC is in a different region than the provider default
  # - Example: "us-east-1", "eu-west-1", "ap-northeast-1"
  # vpc_region = "us-west-2"

  #=============================================================================
  # Computed Attributes (Read-Only)
  #=============================================================================
  # - id: The calculated unique identifier for the association
  #       Format: zone_id:vpc_id
  #       Example: "Z1234567890ABC:vpc-12345678"

  #=============================================================================
  # Timeouts Configuration
  #=============================================================================
  # timeouts {
  #   # create: (Optional) How long to wait for authorization creation
  #   # Default: No timeout
  #   # create = "10m"
  #
  #   # delete: (Optional) How long to wait for authorization deletion
  #   # Default: No timeout
  #   # delete = "10m"
  #
  #   # read: (Optional) How long to wait for authorization read
  #   # Default: No timeout
  #   # read = "10m"
  # }
}

################################################################################
# Example: Complete Cross-Account VPC Association
################################################################################
# This example demonstrates the complete flow for authorizing and associating
# a VPC from a different account with a private hosted zone.

# Provider for the account that owns the hosted zone (Account A)
provider "aws" {
  alias = "account_a"
  # Configure with Account A credentials
}

# Provider for the account that owns the VPC (Account B)
provider "aws" {
  alias = "account_b"
  # Configure with Account B credentials
}

# VPC in Account A (where the hosted zone is)
resource "aws_vpc" "account_a_vpc" {
  provider = aws.account_a

  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "Account A VPC"
  }
}

# Private hosted zone in Account A
resource "aws_route53_zone" "main" {
  provider = aws.account_a

  name = "example.internal"

  vpc {
    vpc_id = aws_vpc.account_a_vpc.id
  }

  # Prevent the deletion of associated VPCs after initial creation
  lifecycle {
    ignore_changes = [vpc]
  }

  tags = {
    Name        = "Main Private Zone"
    Environment = "production"
  }
}

# VPC in Account B (to be associated)
resource "aws_vpc" "account_b_vpc" {
  provider = aws.account_b

  cidr_block           = "10.1.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "Account B VPC"
  }
}

# Step 1: Account A authorizes Account B's VPC
resource "aws_route53_vpc_association_authorization" "cross_account" {
  provider = aws.account_a

  vpc_id  = aws_vpc.account_b_vpc.id
  zone_id = aws_route53_zone.main.id

  # Optionally specify the VPC region if different from provider default
  # vpc_region = "us-west-2"
}

# Step 2: Account B associates its VPC with the hosted zone
resource "aws_route53_zone_association" "cross_account" {
  provider = aws.account_b

  vpc_id  = aws_route53_vpc_association_authorization.cross_account.vpc_id
  zone_id = aws_route53_vpc_association_authorization.cross_account.zone_id
}

################################################################################
# Example: Multiple VPC Authorizations
################################################################################
# Authorize multiple VPCs from different accounts or regions

resource "aws_route53_vpc_association_authorization" "vpc_1" {
  provider = aws.account_a

  vpc_id  = "vpc-11111111"
  zone_id = aws_route53_zone.main.id
}

resource "aws_route53_vpc_association_authorization" "vpc_2" {
  provider = aws.account_a

  vpc_id     = "vpc-22222222"
  zone_id    = aws_route53_zone.main.id
  vpc_region = "eu-west-1" # VPC in a different region
}

################################################################################
# Example: With Custom Timeouts
################################################################################

resource "aws_route53_vpc_association_authorization" "with_timeouts" {
  vpc_id  = aws_vpc.account_b_vpc.id
  zone_id = aws_route53_zone.main.id

  timeouts {
    create = "15m"
    delete = "15m"
  }
}

################################################################################
# Outputs
################################################################################

output "authorization_id" {
  description = "The unique identifier for the VPC association authorization"
  value       = aws_route53_vpc_association_authorization.example.id
}

output "authorized_vpc_id" {
  description = "The VPC ID that has been authorized"
  value       = aws_route53_vpc_association_authorization.example.vpc_id
}

output "zone_id" {
  description = "The hosted zone ID for the authorization"
  value       = aws_route53_vpc_association_authorization.example.zone_id
}

output "vpc_region" {
  description = "The region of the authorized VPC"
  value       = aws_route53_vpc_association_authorization.example.vpc_region
}

################################################################################
# Import Examples
################################################################################
# Import an existing VPC association authorization using the format:
# zone_id:vpc_id
#
# terraform import aws_route53_vpc_association_authorization.example Z1234567890ABC:vpc-12345678

################################################################################
# Common Issues and Troubleshooting
################################################################################
# 1. Error: "InvalidVPCId"
#    - Ensure the VPC ID is correct and exists in the target account
#    - Verify the VPC has DNS support and DNS hostnames enabled
#
# 2. Error: "NoSuchHostedZone"
#    - Confirm the hosted zone ID is correct
#    - Ensure the hosted zone is a private hosted zone
#
# 3. Error: "InvalidParameter"
#    - Check that both resources are in the same AWS partition
#    - Verify the vpc_region parameter if specified
#
# 4. Authorization exists but association fails
#    - Ensure the second account (VPC owner) has proper IAM permissions
#    - Verify aws_route53_zone_association is created in the VPC owner account
#
# 5. DNS resolution not working after association
#    - Confirm both VPCs have enable_dns_hostnames and enable_dns_support set to true
#    - Check VPC security groups and NACLs are not blocking DNS traffic (port 53)
#    - Verify Route53 records exist in the hosted zone

################################################################################
# IAM Permissions Required
################################################################################
# For the hosted zone owner account (Account A):
# - route53:CreateVPCAssociationAuthorization
# - route53:DeleteVPCAssociationAuthorization
# - route53:ListVPCAssociationAuthorizations
# - ec2:DescribeVpcs
#
# For the VPC owner account (Account B):
# - route53:AssociateVPCWithHostedZone
# - route53:DisassociateVPCFromHostedZone
# - ec2:DescribeVpcs

################################################################################
# Related Resources
################################################################################
# - aws_route53_zone: Creates a Route53 hosted zone
# - aws_route53_zone_association: Associates a VPC with a Route53 hosted zone
# - aws_vpc: Creates a VPC
# - aws_route53_record: Creates DNS records in a hosted zone

################################################################################
# Additional Notes
################################################################################
# - After the association is established, consider deleting the authorization
#   to prevent future reassociations
# - ListHostedZonesByVPC and GetHostedZone APIs only consider associations
#   created through AssociateVPCWithHostedZone API
# - Maximum number of authorizations per hosted zone is subject to AWS quotas
# - The authorization does not expire automatically
# - Cross-region VPC associations are supported within the same partition
