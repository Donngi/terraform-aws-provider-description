################################################################################
# AWS Route53 CIDR Location
################################################################################
# Description: Route53 CIDR location resource for geoproximity routing
# Purpose: This resource allows you to create CIDR locations within a CIDR collection,
#          which can be used for geoproximity routing in Route53.
# Use Case: Define custom geographic locations based on IP ranges for more precise
#           traffic routing decisions in Route53 geoproximity routing policies.
#
# AWS Documentation: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/routing-policy-geo.html
# Terraform Documentation: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_cidr_location
################################################################################

resource "aws_route53_cidr_location" "example" {
  ################################################################################
  # Required Arguments
  ################################################################################

  # cidr_blocks - (Required) CIDR blocks for the location
  # Type: set(string)
  # Description: List of CIDR blocks that define the IP ranges for this location.
  #              These CIDR blocks are used by Route53 to identify traffic originating
  #              from this custom location for geoproximity routing purposes.
  # Example: ["200.5.3.0/24", "200.6.3.0/24"]
  # Constraints:
  #   - Must be valid CIDR notation
  #   - CIDR blocks cannot overlap with other locations in the same collection
  cidr_blocks = ["200.5.3.0/24", "200.6.3.0/24"]

  # cidr_collection_id - (Required) The ID of the CIDR collection to update
  # Type: string
  # Description: The unique identifier of the CIDR collection that this location
  #              belongs to. Typically references an aws_route53_cidr_collection resource.
  # Example: aws_route53_cidr_collection.example.id
  # Note: CIDR collections group multiple CIDR locations together for organizational
  #       purposes and are referenced in Route53 geoproximity routing policies.
  cidr_collection_id = aws_route53_cidr_collection.example.id

  # name - (Required) Name for the CIDR location
  # Type: string
  # Description: A descriptive name for this CIDR location that helps identify
  #              the geographic or network region it represents.
  # Example: "office", "data-center-tokyo", "customer-network-east"
  # Constraints:
  #   - Must be unique within the CIDR collection
  #   - Length: 1-128 characters
  #   - Allowed characters: alphanumeric, hyphens, and underscores
  name = "office"

  ################################################################################
  # Computed Attributes (Read-Only)
  ################################################################################

  # id - (Deprecated) The ID of the CIDR collection concatenated with the name
  #      of the CIDR location
  # Type: string
  # Note: This attribute is deprecated. Use cidr_collection_id and name instead
  #       for resource identification.
}

################################################################################
# Additional Information
################################################################################

# Prerequisites:
# - An aws_route53_cidr_collection resource must exist before creating locations
# - Appropriate IAM permissions for Route53 CIDR management

# Related Resources:
# - aws_route53_cidr_collection: Parent collection for CIDR locations
# - aws_route53_record: Route53 records that can use geoproximity routing
# - aws_route53_traffic_policy: Traffic policies for advanced routing

# Common Patterns:
# 1. Corporate Network Routing:
#    - Define CIDR locations for office networks
#    - Route traffic differently based on source IP
#
# 2. Multi-Region Data Centers:
#    - Create locations for each data center's IP ranges
#    - Optimize routing based on network proximity
#
# 3. Customer Segments:
#    - Define locations for different customer network ranges
#    - Provide customized routing per customer segment

# Example: Complete setup with collection and location
# resource "aws_route53_cidr_collection" "example" {
#   name = "collection-1"
# }
#
# resource "aws_route53_cidr_location" "example" {
#   cidr_collection_id = aws_route53_cidr_collection.example.id
#   name               = "office"
#   cidr_blocks        = ["200.5.3.0/24", "200.6.3.0/24"]
# }

# Important Notes:
# - CIDR blocks cannot overlap within the same collection
# - Changes to cidr_blocks or name may require resource replacement
# - Maximum of 1000 locations per CIDR collection
# - CIDR locations are used with geoproximity routing policies only
# - Updates to CIDR blocks may take time to propagate across Route53 edge locations

# Cost Considerations:
# - No additional charge for CIDR locations themselves
# - Standard Route53 query charges apply for geoproximity routing
# - Charges apply per hosted zone using the CIDR collection

# Security Best Practices:
# - Use specific CIDR blocks rather than large ranges when possible
# - Regularly audit CIDR locations for accuracy
# - Implement least-privilege IAM policies for Route53 management
# - Monitor Route53 query logs to verify correct routing behavior

# Troubleshooting:
# - If traffic isn't routing correctly, verify CIDR blocks don't overlap
# - Check that the CIDR collection is properly referenced in routing policies
# - Allow time for DNS propagation after making changes
# - Use Route53 query logging to debug routing decisions
