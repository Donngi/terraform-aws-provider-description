################################################################################
# Resource: aws_route53_delegation_set
# Provider Version: 6.28.0
# Last Updated: 2026-02-03
################################################################################
#
# Overview:
# Route 53 Delegation Set allows you to create a reusable set of name servers
# that can be used across multiple hosted zones. This is particularly useful
# when you manage multiple domains and want to maintain consistency in name
# server assignments.
#
# Common Use Cases:
# - Creating consistent name server assignments across multiple domains
# - Simplifying DNS management for multiple zones
# - Enabling easier domain migration with fixed name servers
#
# Important Notes:
# - Delegation sets are reusable across multiple hosted zones
# - Once created, the name servers in a delegation set cannot be changed
# - The reference_name is for your own reference and doesn't affect functionality
#
# AWS Documentation:
# https://docs.aws.amazon.com/Route53/latest/APIReference/API-actions-by-function.html#actions-by-function-reusable-delegation-sets
# Terraform Registry:
# https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/route53_delegation_set
################################################################################

resource "aws_route53_delegation_set" "example" {
  ##############################################################################
  # Required Arguments
  ##############################################################################
  # None - All arguments are optional

  ##############################################################################
  # Optional Arguments
  ##############################################################################

  # reference_name (Optional)
  # Type: string
  # Description: A reference name used in Caller Reference to help identify
  #              this delegation set amongst others. This is for your own
  #              reference and doesn't affect the delegation set's functionality.
  # Example: "primary-dns-set", "production-zones", "DynDNS"
  # Default: None
  # Constraints:
  #   - Must be a valid string
  #   - Used only for identification purposes
  reference_name = "DynDNS"

  ##############################################################################
  # Computed Attributes (Read-Only)
  ##############################################################################
  # These attributes are automatically set by AWS and cannot be configured:
  #
  # id (string)
  #   Description: The delegation set ID
  #   Example: "N1PA6795SAMPLE"
  #
  # arn (string)
  #   Description: The Amazon Resource Name (ARN) of the Delegation Set
  #   Example: "arn:aws:route53:::delegationset/N1PA6795SAMPLE"
  #
  # name_servers (list of strings)
  #   Description: A list of authoritative name servers for the delegation set
  #                (effectively a list of NS records that can be used across
  #                multiple hosted zones)
  #   Example: [
  #     "ns-1234.awsdns-12.org",
  #     "ns-5678.awsdns-56.com",
  #     "ns-9012.awsdns-90.net",
  #     "ns-3456.awsdns-34.co.uk"
  #   ]

  ##############################################################################
  # Example Usage with Multiple Zones
  ##############################################################################
  # resource "aws_route53_delegation_set" "main" {
  #   reference_name = "multi-domain-dns"
  # }
  #
  # resource "aws_route53_zone" "primary" {
  #   name              = "example.com"
  #   delegation_set_id = aws_route53_delegation_set.main.id
  # }
  #
  # resource "aws_route53_zone" "secondary" {
  #   name              = "example.org"
  #   delegation_set_id = aws_route53_delegation_set.main.id
  # }
  #
  # # Output the name servers to configure at your domain registrar
  # output "name_servers" {
  #   value       = aws_route53_delegation_set.main.name_servers
  #   description = "Name servers to configure at your domain registrar"
  # }

  ##############################################################################
  # Additional Configuration Examples
  ##############################################################################

  # Example 1: Simple delegation set for development environment
  # reference_name = "dev-environment"

  # Example 2: Delegation set for production with descriptive name
  # reference_name = "prod-multi-domain-2024"

  # Example 3: Delegation set for specific project
  # reference_name = "project-alpha-dns"

  ##############################################################################
  # Best Practices
  ##############################################################################
  # 1. Use descriptive reference_name values to easily identify delegation sets
  # 2. Plan delegation set usage before creating multiple hosted zones
  # 3. Document which zones are using which delegation sets
  # 4. Consider using delegation sets when managing multiple related domains
  # 5. Remember that delegation sets cannot be deleted if they're in use
  # 6. Store the name_servers output for configuring domain registrars

  ##############################################################################
  # Cost Considerations
  ##############################################################################
  # - Delegation sets themselves don't incur additional costs
  # - Standard Route 53 hosted zone charges apply to zones using the delegation set
  # - Each hosted zone using a delegation set is billed separately
  # - There's no limit to the number of zones that can use a delegation set

  ##############################################################################
  # Security Considerations
  ##############################################################################
  # - Delegation sets don't have their own IAM permissions
  # - Access control is managed through Route 53 hosted zone permissions
  # - Name servers in a delegation set are public by design
  # - Consider using AWS Organizations SCPs for cross-account delegation set usage

  ##############################################################################
  # Tags
  ##############################################################################
  # Note: aws_route53_delegation_set does not support tags in version 6.28.0
  # Tags should be applied to the hosted zones that use this delegation set instead
}

################################################################################
# Output Examples
################################################################################

# Output the delegation set ID for use in hosted zones
output "delegation_set_id" {
  description = "The ID of the Route 53 delegation set"
  value       = aws_route53_delegation_set.example.id
}

# Output the name servers for domain registrar configuration
output "delegation_set_name_servers" {
  description = "Name servers to configure at your domain registrar for all zones using this delegation set"
  value       = aws_route53_delegation_set.example.name_servers
}

# Output the ARN for use in IAM policies or other AWS integrations
output "delegation_set_arn" {
  description = "The ARN of the Route 53 delegation set"
  value       = aws_route53_delegation_set.example.arn
}

################################################################################
# Related Resources
################################################################################
# - aws_route53_zone: Hosted zones that can use this delegation set
# - aws_route53_record: DNS records within zones using this delegation set
# - aws_route53_zone_association: VPC associations for private hosted zones
#
# Note: Delegation sets can only be used with public hosted zones, not private zones
################################################################################
