################################################################################
# AWS Network ACL Association
################################################################################
# Resource: aws_network_acl_association
# Provider Version: 6.28.0
# Last Updated: 2026-01-31
#
# Overview:
# Provides a network ACL association resource which allows you to associate your
# network ACL with any subnet(s). This resource manages the relationship between
# a network access control list (Network ACL) and a subnet within a VPC.
#
# Important Notes:
# - Each subnet in a VPC must be associated with exactly one network ACL at a time
# - When you associate a subnet with a new network ACL, the previous association
#   is automatically removed
# - Do NOT use the same subnet ID in both a network ACL resource (aws_network_acl)
#   with subnet_ids attribute and this association resource - it will cause
#   conflicts and overwrite associations
# - Network ACLs are stateless and evaluated in order by rule number
# - If a subnet is not explicitly associated with a custom network ACL, it is
#   automatically associated with the VPC's default network ACL
#
# Use Cases:
# - Associate custom network ACLs with specific subnets for granular traffic control
# - Implement subnet-level security policies separate from security groups
# - Apply different network ACL rules to different tiers (public, private, database)
# - Migrate subnets between different network ACLs as architecture evolves
#
# AWS Documentation:
# - Network ACLs: https://docs.aws.amazon.com/vpc/latest/userguide/vpc-network-acls.html
# - Managing Associations: https://docs.aws.amazon.com/vpc/latest/userguide/network-acl-associations.html
# - API Reference: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_NetworkAclAssociation.html
#
# Terraform Registry:
# https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/network_acl_association
################################################################################

resource "aws_network_acl_association" "example" {
  ################################################################################
  # Required Arguments
  ################################################################################

  # network_acl_id - (Required) The ID of the network ACL
  # Type: string
  #
  # The identifier of the network ACL to associate with the subnet. This network
  # ACL will control all inbound and outbound traffic at the subnet level.
  # Network ACLs provide an additional layer of security beyond security groups.
  #
  # Important Considerations:
  # - Must be a valid network ACL ID in the same VPC as the subnet
  # - The network ACL can be a custom ACL or the default VPC ACL
  # - Changing this value will update the subnet's association to the new ACL
  # - The same network ACL can be associated with multiple subnets
  #
  # Best Practices:
  # - Use custom network ACLs for subnets with specific security requirements
  # - Keep network ACL rules well-documented and organized by rule number
  # - Leave gaps between rule numbers (e.g., 100, 200, 300) for easier insertion
  # - Review ACL rules regularly to ensure they align with security policies
  #
  # Examples:
  # - aws_network_acl.custom.id
  # - "acl-0123456789abcdef0"
  # - data.aws_network_acl.selected.id
  network_acl_id = aws_network_acl.main.id

  # subnet_id - (Required) The ID of the associated subnet
  # Type: string
  #
  # The identifier of the subnet to associate with the network ACL. Each subnet
  # can only be associated with one network ACL at a time. When you create this
  # association, any previous association for this subnet is automatically removed.
  #
  # Important Considerations:
  # - Must be a valid subnet ID in the same VPC as the network ACL
  # - The subnet will be disassociated from its current ACL automatically
  # - If this resource is destroyed, the subnet reverts to the default VPC ACL
  # - Cannot associate the same subnet in multiple association resources
  #
  # Network ACL vs Security Group:
  # - Network ACLs operate at the subnet level (all resources in subnet)
  # - Network ACLs are stateless (return traffic must be explicitly allowed)
  # - Network ACLs process rules in order by rule number
  # - Network ACLs support both allow and deny rules
  #
  # Best Practices:
  # - Use descriptive subnet names/tags to identify subnet purpose
  # - Document which subnets should have custom ACLs vs default
  # - Consider subnet tiers: public, private, database, management
  # - Align ACL associations with your network segmentation strategy
  #
  # Examples:
  # - aws_subnet.public.id
  # - "subnet-0123456789abcdef0"
  # - data.aws_subnet.selected.id
  subnet_id = aws_subnet.main.id

  ################################################################################
  # Optional Arguments
  ################################################################################

  # region - (Optional) Region where this resource will be managed
  # Type: string
  # Default: Provider's configured region
  # Computed: true
  #
  # The AWS region where this network ACL association will be managed. This is
  # typically inherited from the provider configuration and rarely needs to be
  # set explicitly.
  #
  # Important Considerations:
  # - The network ACL and subnet must be in the same region
  # - Defaults to the region configured in the AWS provider
  # - This is a management setting, not a cross-region association
  # - Regional endpoints: https://docs.aws.amazon.com/general/latest/gr/rande.html
  #
  # When to Set Explicitly:
  # - When using multiple AWS provider aliases with different regions
  # - When you need to ensure resources are in a specific region
  # - For multi-region deployments with explicit region management
  #
  # Best Practices:
  # - Usually rely on provider configuration rather than explicit setting
  # - Use consistent region naming (use region codes like us-east-1)
  # - Document regional dependencies in your infrastructure
  #
  # Examples:
  # - "us-east-1"
  # - "eu-west-1"
  # - "ap-northeast-1"
  # region = "us-east-1"

  ################################################################################
  # Computed Attributes (Read-Only)
  ################################################################################

  # id - The ID of the network ACL association
  # Type: string
  # Computed: true
  #
  # The unique identifier for this network ACL association. This is automatically
  # generated by AWS when the association is created. Format: aclassoc-xxxxxxxxx
  #
  # Usage:
  # - Reference: aws_network_acl_association.example.id
  # - Used for tracking and identifying specific associations
  # - Can be used in other resources or data sources that need the association ID

  ################################################################################
  # Lifecycle Management
  ################################################################################

  # lifecycle {
  #   # Prevent accidental deletion of critical network ACL associations
  #   prevent_destroy = true
  #
  #   # Create new association before destroying old one during updates
  #   create_before_destroy = true
  #
  #   # Ignore changes to specific attributes if managed externally
  #   ignore_changes = [
  #     # Uncomment if network_acl_id is managed outside Terraform
  #     # network_acl_id,
  #   ]
  # }

  ################################################################################
  # Common Patterns & Examples
  ################################################################################

  # Pattern 1: Associate multiple subnets with a custom network ACL
  # Instead of using this resource multiple times, consider using aws_network_acl
  # resource with subnet_ids attribute, or use count/for_each:
  #
  # resource "aws_network_acl_association" "private_subnets" {
  #   for_each = toset(var.private_subnet_ids)
  #
  #   network_acl_id = aws_network_acl.private.id
  #   subnet_id      = each.value
  # }

  # Pattern 2: Data tier subnet with restrictive network ACL
  # resource "aws_network_acl_association" "database" {
  #   network_acl_id = aws_network_acl.database.id
  #   subnet_id      = aws_subnet.database.id
  # }

  # Pattern 3: DMZ subnet with specific ingress/egress rules
  # resource "aws_network_acl_association" "dmz" {
  #   network_acl_id = aws_network_acl.dmz.id
  #   subnet_id      = aws_subnet.dmz.id
  # }

  ################################################################################
  # Related Resources
  ################################################################################

  # - aws_network_acl: Define custom network ACL with rules
  # - aws_network_acl_rule: Add individual rules to network ACLs
  # - aws_subnet: Create subnets within a VPC
  # - aws_vpc: Create Virtual Private Cloud
  # - aws_security_group: Instance-level security (works with network ACLs)
  # - aws_default_network_acl: Manage the default network ACL for a VPC

  ################################################################################
  # Security Considerations
  ################################################################################

  # Network ACL Design:
  # - Network ACLs are stateless - you must allow both inbound and outbound traffic
  # - Rules are evaluated in order from lowest to highest number
  # - First matching rule is applied (allow or deny)
  # - Default rule at the end denies all traffic not matched by other rules
  #
  # Monitoring:
  # - Enable VPC Flow Logs to monitor traffic allowed/denied by network ACLs
  # - Review CloudWatch metrics for network ACL activity
  # - Set up CloudWatch alarms for unusual traffic patterns
  #
  # Compliance:
  # - Document network ACL associations as part of network architecture
  # - Ensure ACL rules meet organizational security policies
  # - Regular audits of ACL rules and associations
  # - Use AWS Config to track ACL association changes
  #
  # Defense in Depth:
  # - Use network ACLs in combination with security groups
  # - Network ACLs provide subnet-level control
  # - Security groups provide instance-level control
  # - Both layers create stronger security posture

  ################################################################################
  # Cost Optimization
  ################################################################################

  # - Network ACL associations have no additional cost
  # - Network ACLs themselves are free
  # - Cost considerations are primarily in VPC Flow Logs if enabled for monitoring
  # - No performance impact from network ACL associations

  ################################################################################
  # Troubleshooting
  ################################################################################

  # Common Issues:
  #
  # 1. Conflict with aws_network_acl subnet_ids:
  #    Error: "associations conflict"
  #    Solution: Use either aws_network_acl.subnet_ids OR aws_network_acl_association,
  #              never both for the same subnet
  #
  # 2. Connectivity issues after association:
  #    Problem: Traffic not flowing as expected
  #    Solution: Verify network ACL rules allow both inbound and outbound traffic
  #              Remember: Network ACLs are stateless
  #
  # 3. Subnet still using default ACL:
  #    Problem: Association not taking effect
  #    Solution: Verify network_acl_id and subnet_id are in the same VPC
  #              Check AWS console to confirm association state
  #
  # 4. Cannot delete association:
  #    Problem: Dependency or resource in use
  #    Solution: Check if there are running instances in the subnet
  #              Ensure no other resources depend on this association

  ################################################################################
  # Tags
  ################################################################################

  # Note: Network ACL associations do not support tags directly
  # Tags should be applied to the aws_network_acl and aws_subnet resources instead
}
