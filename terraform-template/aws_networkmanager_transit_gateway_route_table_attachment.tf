################################################################################
# AWS Network Manager Transit Gateway Route Table Attachment
################################################################################
# Resource: aws_networkmanager_transit_gateway_route_table_attachment
# Provider Version: 6.28.0
#
# Description:
#   Manages a Network Manager transit gateway route table attachment for AWS Cloud WAN.
#   This resource attaches a transit gateway route table to an AWS Cloud WAN core network,
#   enabling traffic routing between VPCs and VPNs through the core network.
#
# Prerequisites:
#   - An existing AWS Cloud WAN core network
#   - A transit gateway peering connection
#   - A transit gateway route table
#
# Use Cases:
#   - Connecting transit gateway route tables to Cloud WAN core networks
#   - Enabling advanced routing between VPCs and VPNs through Cloud WAN
#   - Implementing multi-region network architectures with Cloud WAN
#   - Applying routing policies for traffic management
#
# AWS Documentation:
#   - Transit Gateway Route Table Attachments: https://docs.aws.amazon.com/network-manager/latest/cloudwan/cloudwan-tgw-attachment.html
#   - Create Attachment: https://docs.aws.amazon.com/network-manager/latest/cloudwan/cloudwan-tgw-attachment-add.html
#   - API Reference: https://docs.aws.amazon.com/networkmanager/latest/APIReference/API_CreateTransitGatewayRouteTableAttachment.html
#
# Terraform Documentation:
#   https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/networkmanager_transit_gateway_route_table_attachment
#
# Important Notes:
#   - Changing routing_policy_label will force resource recreation
#   - The transit gateway must already have a peering connection to the core network
#   - Attachment state transitions through various states (CREATING, AVAILABLE, etc.)
#   - Tags support provider default_tags configuration block
################################################################################

resource "aws_networkmanager_transit_gateway_route_table_attachment" "example" {
  ################################################################################
  # Required Arguments
  ################################################################################

  # peering_id - (Required) ID of the peer for the attachment
  # Type: string
  # Forces recreation: No
  # Description: The ID of the transit gateway peering connection that links
  #              the transit gateway to the Cloud WAN core network. This peering
  #              must be established before creating the route table attachment.
  # Example: "peering-01234567890abcdef"
  # Related resource: aws_networkmanager_transit_gateway_peering
  peering_id = "peering-01234567890abcdef"

  # transit_gateway_route_table_arn - (Required) ARN of the transit gateway route table
  # Type: string
  # Forces recreation: No
  # Description: The Amazon Resource Name (ARN) of the transit gateway route table
  #              to attach to the core network. This route table determines how
  #              traffic is routed between attached VPCs and VPNs.
  # Format: "arn:aws:ec2:region:account-id:transit-gateway-route-table/tgw-rtb-id"
  # Example: "arn:aws:ec2:us-east-1:123456789012:transit-gateway-route-table/tgw-rtb-01234567890abcdef"
  # Related resource: aws_ec2_transit_gateway_route_table
  transit_gateway_route_table_arn = "arn:aws:ec2:us-east-1:123456789012:transit-gateway-route-table/tgw-rtb-01234567890abcdef"

  ################################################################################
  # Optional Arguments
  ################################################################################

  # routing_policy_label - (Optional) Routing policy label for traffic routing decisions
  # Type: string
  # Default: null
  # Forces recreation: Yes (WARNING: changing this value recreates the resource)
  # Description: A routing policy label used by the Cloud WAN to apply specific
  #              routing decisions to traffic through this attachment. This label
  #              corresponds to routing policies defined in the core network policy.
  # Constraints:
  #   - Maximum length: 256 characters
  # Use cases:
  #   - Implementing traffic segmentation based on routing policies
  #   - Directing traffic to specific segments or edge locations
  #   - Applying conditional routing rules
  # Example: "production-routing" or "dev-routing"
  # routing_policy_label = "production-routing"

  # tags - (Optional) Key-value tags for the attachment
  # Type: map(string)
  # Default: {}
  # Description: A map of tags to assign to the transit gateway route table attachment.
  #              Tags can be used for organization, cost allocation, and access control.
  # Provider integration: Supports default_tags configuration block at provider level.
  #                       Tags defined here will merge with provider default_tags.
  # Best practices:
  #   - Use consistent tagging strategy across resources
  #   - Include cost center, environment, and owner tags
  #   - Consider using tags for automated resource management
  # Example:
  # tags = {
  #   Name        = "tgw-rtb-attachment-prod"
  #   Environment = "production"
  #   ManagedBy   = "terraform"
  #   CostCenter  = "networking"
  #   Purpose     = "core-network-integration"
  # }

  ################################################################################
  # Nested Blocks
  ################################################################################

  # timeouts - (Optional) Resource operation timeouts
  # Description: Customizable timeout settings for create and delete operations.
  #              Useful for large or complex attachments that may take longer to provision.
  # timeouts {
  #   # create - (Optional) Timeout for create operations
  #   # Type: string (duration format: "60m", "1h", etc.)
  #   # Default: Terraform's default timeout
  #   # Description: Maximum time to wait for attachment creation to complete.
  #   #              The attachment goes through states: CREATING -> AVAILABLE
  #   # Recommended: "30m" to "60m" for typical deployments
  #   # create = "30m"
  #
  #   # delete - (Optional) Timeout for delete operations
  #   # Type: string (duration format: "60m", "1h", etc.)
  #   # Default: Terraform's default timeout
  #   # Description: Maximum time to wait for attachment deletion to complete.
  #   #              The attachment goes through states: DELETING -> DELETED
  #   # Recommended: "30m" to "60m" for typical deployments
  #   # delete = "30m"
  # }
}

################################################################################
# Computed Attributes (Read-Only)
################################################################################
# These attributes are automatically set by AWS and available after creation:
#
# arn - (string) Attachment ARN
#   Format: "arn:aws:networkmanager::account-id:attachment/attachment-id"
#   Use: For IAM policies, cross-account access, and resource references
#   Access: aws_networkmanager_transit_gateway_route_table_attachment.example.arn
#
# attachment_policy_rule_number - (number) Policy rule number
#   Description: The rule number of the attachment policy that was applied
#   Use: For tracking which policy rule matched this attachment
#   Access: aws_networkmanager_transit_gateway_route_table_attachment.example.attachment_policy_rule_number
#
# attachment_type - (string) Type of attachment
#   Value: "TRANSIT_GATEWAY_ROUTE_TABLE"
#   Description: Identifies this as a transit gateway route table attachment
#   Access: aws_networkmanager_transit_gateway_route_table_attachment.example.attachment_type
#
# core_network_arn - (string) ARN of the core network
#   Format: "arn:aws:networkmanager::account-id:core-network/core-network-id"
#   Description: The Cloud WAN core network this attachment belongs to
#   Access: aws_networkmanager_transit_gateway_route_table_attachment.example.core_network_arn
#
# core_network_id - (string) ID of the core network
#   Description: The unique identifier of the Cloud WAN core network
#   Use: For referencing the core network in other resources or outputs
#   Access: aws_networkmanager_transit_gateway_route_table_attachment.example.core_network_id
#
# edge_location - (string) Edge location for the peer
#   Format: AWS region code (e.g., "us-east-1", "eu-west-1")
#   Description: The AWS region where this attachment is located
#   Access: aws_networkmanager_transit_gateway_route_table_attachment.example.edge_location
#
# id - (string) ID of the attachment
#   Description: Unique identifier for the attachment
#   Use: For resource references, data source lookups, and import operations
#   Access: aws_networkmanager_transit_gateway_route_table_attachment.example.id
#
# owner_account_id - (string) ID of the attachment account owner
#   Format: 12-digit AWS account ID
#   Description: The AWS account that owns this attachment
#   Use: For cross-account attachment scenarios
#   Access: aws_networkmanager_transit_gateway_route_table_attachment.example.owner_account_id
#
# resource_arn - (string) Attachment resource ARN
#   Format: ARN of the transit gateway route table being attached
#   Description: The ARN of the underlying transit gateway route table resource
#   Access: aws_networkmanager_transit_gateway_route_table_attachment.example.resource_arn
#
# segment_name - (string) Name of the segment attachment
#   Description: The name of the core network segment this attachment is associated with
#   Use: For identifying which segment this attachment routes traffic to
#   Access: aws_networkmanager_transit_gateway_route_table_attachment.example.segment_name
#
# state - (string) State of the attachment
#   Possible values:
#     - CREATING: Attachment is being created
#     - AVAILABLE: Attachment is ready and operational
#     - UPDATING: Attachment is being updated
#     - DELETING: Attachment is being deleted
#     - DELETED: Attachment has been deleted
#     - FAILED: Attachment operation failed
#     - PENDING_NETWORK_UPDATE: Waiting for network policy update
#     - PENDING_ATTACHMENT_ACCEPTANCE: Waiting for cross-account acceptance
#     - REJECTED: Cross-account attachment was rejected
#   Use: For monitoring attachment lifecycle and automation workflows
#   Access: aws_networkmanager_transit_gateway_route_table_attachment.example.state
#
# tags_all - (map of string) Map of all tags assigned to the resource
#   Description: Includes both tags explicitly set on this resource and tags
#                inherited from the provider's default_tags configuration block
#   Use: For viewing complete tag set including provider defaults
#   Access: aws_networkmanager_transit_gateway_route_table_attachment.example.tags_all
################################################################################

################################################################################
# Example Outputs
################################################################################
# output "attachment_id" {
#   description = "The ID of the transit gateway route table attachment"
#   value       = aws_networkmanager_transit_gateway_route_table_attachment.example.id
# }
#
# output "attachment_arn" {
#   description = "The ARN of the transit gateway route table attachment"
#   value       = aws_networkmanager_transit_gateway_route_table_attachment.example.arn
# }
#
# output "attachment_state" {
#   description = "The current state of the attachment"
#   value       = aws_networkmanager_transit_gateway_route_table_attachment.example.state
# }
#
# output "core_network_id" {
#   description = "The ID of the core network"
#   value       = aws_networkmanager_transit_gateway_route_table_attachment.example.core_network_id
# }
#
# output "segment_name" {
#   description = "The name of the core network segment"
#   value       = aws_networkmanager_transit_gateway_route_table_attachment.example.segment_name
# }
#
# output "edge_location" {
#   description = "The edge location (AWS region) of the attachment"
#   value       = aws_networkmanager_transit_gateway_route_table_attachment.example.edge_location
# }
################################################################################

################################################################################
# Example: Complete Cloud WAN Transit Gateway Integration
################################################################################
# This example demonstrates a complete setup with all related resources
#
# # Core Network
# resource "aws_networkmanager_core_network" "example" {
#   global_network_id = aws_networkmanager_global_network.example.id
#   policy_document   = jsonencode({
#     version = "2021.12"
#     core-network-configuration = {
#       vpn-ecmp-support = true
#       asn-ranges       = ["64512-65534"]
#       edge-locations   = [
#         {
#           location = "us-east-1"
#           asn      = 64512
#         }
#       ]
#     }
#     segments = [
#       {
#         name                          = "production"
#         require-attachment-acceptance = false
#         edge-locations               = ["us-east-1"]
#       }
#     ]
#     attachment-policies = [
#       {
#         rule-number     = 100
#         condition-logic = "or"
#         conditions = [
#           {
#             type     = "tag-value"
#             operator = "equals"
#             key      = "Environment"
#             value    = "production"
#           }
#         ]
#         action = {
#           association-method = "constant"
#           segment           = "production"
#         }
#       }
#     ]
#   })
#
#   tags = {
#     Name = "core-network-example"
#   }
# }
#
# # Transit Gateway Peering
# resource "aws_networkmanager_transit_gateway_peering" "example" {
#   core_network_id     = aws_networkmanager_core_network.example.id
#   transit_gateway_arn = aws_ec2_transit_gateway.example.arn
#
#   tags = {
#     Name = "tgw-peering-example"
#   }
# }
#
# # Transit Gateway Route Table
# resource "aws_ec2_transit_gateway_route_table" "example" {
#   transit_gateway_id = aws_ec2_transit_gateway.example.id
#
#   tags = {
#     Name = "tgw-rtb-example"
#   }
# }
#
# # Transit Gateway Route Table Attachment (this resource)
# resource "aws_networkmanager_transit_gateway_route_table_attachment" "example" {
#   peering_id                      = aws_networkmanager_transit_gateway_peering.example.id
#   transit_gateway_route_table_arn = aws_ec2_transit_gateway_route_table.example.arn
#   routing_policy_label            = "production-routing"
#
#   tags = {
#     Name        = "tgw-rtb-attachment-prod"
#     Environment = "production"
#     ManagedBy   = "terraform"
#   }
#
#   timeouts {
#     create = "30m"
#     delete = "30m"
#   }
# }
################################################################################

################################################################################
# Import Example
################################################################################
# Existing transit gateway route table attachments can be imported using the attachment ID:
#
# terraform import aws_networkmanager_transit_gateway_route_table_attachment.example attachment-01234567890abcdef
#
# To find the attachment ID:
#   - AWS Console: Network Manager → Attachments → Select attachment
#   - AWS CLI: aws networkmanager list-attachments --core-network-id <core-network-id>
################################################################################

################################################################################
# Common Patterns and Best Practices
################################################################################
#
# 1. Multi-Region Cloud WAN with Transit Gateway Integration:
#    - Create core network with multiple edge locations
#    - Establish transit gateway peering in each region
#    - Attach region-specific route tables to core network segments
#    - Use routing policy labels for traffic steering
#
# 2. Segmented Network Architecture:
#    - Define segments in core network policy (production, development, shared-services)
#    - Create separate transit gateway route tables per segment
#    - Use attachment policies to automatically assign attachments to segments
#    - Apply routing policy labels for fine-grained control
#
# 3. Cross-Account Attachments:
#    - Share core network with other AWS accounts using RAM
#    - Create transit gateway peering from shared account
#    - Create route table attachment from shared account
#    - Monitor attachment state for acceptance workflow
#
# 4. High Availability Design:
#    - Deploy transit gateways in multiple availability zones
#    - Create route table attachments in multiple edge locations
#    - Configure appropriate routing policies for failover
#    - Monitor attachment state for health checks
#
# 5. Tagging Strategy:
#    - Tag attachments with environment, cost center, and owner
#    - Use consistent naming conventions across all attachments
#    - Implement tag-based policies for automation
#    - Leverage provider default_tags for organization-wide standards
#
# 6. State Monitoring:
#    - Monitor attachment state transitions for operational awareness
#    - Set up CloudWatch alarms for attachment failures
#    - Implement retry logic for transient failures
#    - Use longer timeouts for complex network configurations
#
# 7. Policy-Based Routing:
#    - Define clear routing policies in core network policy
#    - Use routing_policy_label to implement traffic steering
#    - Document policy label meanings and intended behavior
#    - Test routing changes in non-production environments first
#
# 8. Cost Optimization:
#    - Review attachment data transfer costs
#    - Optimize segment design to minimize cross-region traffic
#    - Use routing policies to control expensive data paths
#    - Monitor CloudWatch metrics for usage patterns
################################################################################
