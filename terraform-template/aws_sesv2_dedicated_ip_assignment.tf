################################################################################
# AWS SESv2 Dedicated IP Assignment
################################################################################
# Terraform resource for managing an AWS SESv2 (Simple Email V2) Dedicated IP Assignment.
#
# This resource is used with "Standard" dedicated IP addresses. This includes addresses
# requested and relinquished manually via an AWS support case, or Bring Your Own IP (BYOIP)
# addresses. Once no longer assigned, this resource returns the IP to the
# `ses-default-dedicated-pool`, managed by AWS.
#
# Related Documentation:
# - AWS SESv2 Dedicated IP Management: https://docs.aws.amazon.com/ses/latest/dg/dedicated-ip-case.html
# - Bring Your Own IP (BYOIP): https://docs.aws.amazon.com/ses/latest/dg/dedicated-ip-byo.html
# - Managing IP Pools: https://docs.aws.amazon.com/ses/latest/dg/managing-ip-pools.html
# - Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sesv2_dedicated_ip_assignment
#
# Provider Version: 6.28.0
################################################################################

resource "aws_sesv2_dedicated_ip_assignment" "example" {
  ##############################################################################
  # Required Arguments
  ##############################################################################

  # The dedicated IP address to assign to the pool.
  # This should be a valid IPv4 address that you have provisioned through AWS
  # Support or brought via BYOIP (Bring Your Own IP).
  #
  # Type: string
  # Required: Yes
  # Example: "192.0.2.1"
  ip = "0.0.0.0" # TODO: Replace with your dedicated IP address

  # The name of the dedicated IP pool to which you want to assign the dedicated IP.
  # The pool must already exist before you can assign IPs to it. Create pools using
  # the aws_sesv2_dedicated_ip_pool resource.
  #
  # Type: string
  # Required: Yes
  # Note: When this assignment is destroyed, the IP is returned to ses-default-dedicated-pool
  destination_pool_name = "my-pool" # TODO: Replace with your pool name

  ##############################################################################
  # Optional Arguments
  ##############################################################################

  # The AWS region where this dedicated IP assignment will be managed.
  # If not specified, defaults to the region set in the provider configuration.
  #
  # Type: string
  # Required: No
  # Default: Provider's configured region
  # Example: "us-east-1", "eu-west-1", "ap-northeast-1"
  # region = "us-east-1"

  ##############################################################################
  # Computed Attributes (Read-Only)
  ##############################################################################
  # The following attributes are exported but cannot be set:
  #
  # - id (string): A comma-separated string made up of `ip` and `destination_pool_name`
  #                Format: "<ip>,<destination_pool_name>"
  #                Example: "192.0.2.1,my-pool"
  ##############################################################################
}

################################################################################
# Common Use Cases and Examples
################################################################################

# Example 1: Basic dedicated IP assignment
# Assigns a standard dedicated IP to a custom pool
resource "aws_sesv2_dedicated_ip_assignment" "basic" {
  ip                    = "192.0.2.1"
  destination_pool_name = "production-pool"
}

# Example 2: Dedicated IP assignment with explicit region
# Useful when managing SES resources across multiple regions
resource "aws_sesv2_dedicated_ip_assignment" "multi_region" {
  ip                    = "192.0.2.2"
  destination_pool_name = "eu-production-pool"
  region                = "eu-west-1"
}

# Example 3: Complete setup with pool creation
# Creates a dedicated IP pool and assigns an IP to it
resource "aws_sesv2_dedicated_ip_pool" "example" {
  pool_name = "example-pool"

  tags = {
    Environment = "production"
    ManagedBy   = "Terraform"
  }
}

resource "aws_sesv2_dedicated_ip_assignment" "with_pool" {
  ip                    = "192.0.2.3"
  destination_pool_name = aws_sesv2_dedicated_ip_pool.example.pool_name
}

################################################################################
# Important Notes and Best Practices
################################################################################
# 1. IP Acquisition:
#    - Dedicated IPs must be requested through AWS Support or brought via BYOIP
#    - You cannot create new IPs directly through Terraform
#    - IPs must be provisioned in your account before assignment
#
# 2. Pool Management:
#    - The destination pool must exist before assignment
#    - Use aws_sesv2_dedicated_ip_pool to create custom pools
#    - When unassigned, IPs return to ses-default-dedicated-pool
#
# 3. Regional Considerations:
#    - Dedicated IPs are region-specific
#    - Ensure the IP and pool are in the same region
#    - Use the region parameter for cross-region management
#
# 4. Lifecycle:
#    - Destroying this resource unassigns the IP but doesn't delete it
#    - The IP returns to the default pool managed by AWS
#    - To fully release an IP, contact AWS Support
#
# 5. Pricing:
#    - Dedicated IPs incur additional costs
#    - Costs apply even when IPs are unassigned
#    - Review AWS SES pricing for dedicated IP costs
#
# 6. Warming Up:
#    - New dedicated IPs need to be warmed up gradually
#    - Start with low volumes and increase over time
#    - This prevents deliverability issues
#
# 7. Use Cases:
#    - Isolate sending reputation by application or customer
#    - Meet specific deliverability requirements
#    - Maintain dedicated sender reputation
#    - Required for some compliance scenarios
################################################################################

################################################################################
# Troubleshooting
################################################################################
# Common Issues:
#
# 1. IP Not Found:
#    - Verify the IP is provisioned in your AWS account
#    - Check if the IP is in the correct region
#    - Ensure proper format (IPv4: x.x.x.x)
#
# 2. Pool Not Found:
#    - Confirm the destination pool exists
#    - Verify pool name spelling and case sensitivity
#    - Check pool is in the same region as the IP
#
# 3. Permission Errors:
#    - Ensure IAM permissions include ses:PutDedicatedIpInPool
#    - Verify ses:DeleteDedicatedIpPool permission for cleanup
#    - Check region-specific permissions
#
# 4. Assignment Conflicts:
#    - An IP can only be assigned to one pool at a time
#    - Verify the IP isn't already assigned elsewhere
#    - Check for duplicate assignments in your configuration
################################################################################

################################################################################
# References and Additional Resources
################################################################################
# AWS Documentation:
# - SESv2 API Reference: https://docs.aws.amazon.com/ses/latest/APIReference-V2/
# - Dedicated IP Management: https://docs.aws.amazon.com/ses/latest/dg/dedicated-ip.html
# - IP Warming: https://docs.aws.amazon.com/ses/latest/dg/dedicated-ip-warming.html
# - Managing IP Pools: https://docs.aws.amazon.com/ses/latest/dg/managing-ip-pools.html
#
# Terraform Documentation:
# - AWS Provider: https://registry.terraform.io/providers/hashicorp/aws/latest/docs
# - This Resource: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sesv2_dedicated_ip_assignment
# - Related Resource (Pool): https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sesv2_dedicated_ip_pool
################################################################################
