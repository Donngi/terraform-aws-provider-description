# =============================================================================
# AWS Service Discovery Private DNS Namespace
# =============================================================================
# Provider Version: 6.28.0
# Resource: aws_service_discovery_private_dns_namespace
# Purpose: Creates a private DNS namespace for AWS Cloud Map service discovery
#          within a VPC
#
# AWS Cloud Map is a service discovery solution that allows applications to
# discover instances using API calls or DNS queries. A private DNS namespace
# creates a Route 53 private hosted zone that is only accessible within the
# specified VPC.
#
# Related Documentation:
# - Terraform: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/service_discovery_private_dns_namespace
# - AWS API: https://docs.aws.amazon.com/cloud-map/latest/api/API_CreatePrivateDnsNamespace.html
# - AWS Guide: https://docs.aws.amazon.com/cloud-map/latest/dg/creating-namespaces.html
# =============================================================================

# -----------------------------------------------------------------------------
# Resource Definition
# -----------------------------------------------------------------------------
resource "aws_service_discovery_private_dns_namespace" "example" {
  # ---------------------------------------------------------------------------
  # Required Arguments
  # ---------------------------------------------------------------------------

  # name - (Required, string)
  # The name of the namespace. This becomes the DNS namespace name within your VPC.
  # Must be a valid DNS name (e.g., "example.local", "services.internal")
  # Maximum length: 253 characters
  #
  # Example values:
  # - "services.local"
  # - "microservices.internal"
  # - "app.example.local"
  name = "services.example.local"

  # vpc - (Required, string)
  # The ID of the VPC that you want to associate the namespace with.
  # The namespace will only be discoverable within this VPC.
  # Cloud Map will create a Route 53 private hosted zone associated with this VPC.
  #
  # Important: You must have a VPC already created before creating the namespace.
  # The VPC ID typically looks like "vpc-xxxxxxxxxxxxxxxxx"
  #
  # Example: vpc = aws_vpc.main.id
  vpc = "vpc-0123456789abcdef0"

  # ---------------------------------------------------------------------------
  # Optional Arguments
  # ---------------------------------------------------------------------------

  # description - (Optional, string)
  # A description for the namespace. Helps identify the purpose of the namespace.
  # Maximum length: 1024 characters
  #
  # Best Practice: Include information about what services will use this namespace
  description = "Private DNS namespace for microservices discovery"

  # region - (Optional, string)
  # The AWS region where this resource will be managed.
  # If not specified, defaults to the region set in the provider configuration.
  #
  # Note: Namespaces are region-specific. If you need multi-region service
  # discovery, you must create a namespace in each region.
  #
  # Uncomment to override provider region:
  # region = "us-west-2"

  # tags - (Optional, map of strings)
  # A map of tags to assign to the namespace.
  # Tags are useful for cost allocation, resource organization, and access control.
  #
  # If configured with a provider default_tags configuration block, tags with
  # matching keys will overwrite those defined at the provider-level.
  #
  # Best Practices:
  # - Use consistent tagging strategy across resources
  # - Include environment, owner, and cost center tags
  # - Consider using tags for automation and lifecycle management
  tags = {
    Name        = "example-service-discovery-namespace"
    Environment = "production"
    ManagedBy   = "terraform"
    Purpose     = "microservices-discovery"
  }
}

# -----------------------------------------------------------------------------
# Outputs
# -----------------------------------------------------------------------------
# These attributes are available after the resource is created

# Output: id
# Description: The ID of the namespace (same as the namespace ID)
# Usage: Can be referenced in service discovery service resources
output "namespace_id" {
  description = "The ID of the private DNS namespace"
  value       = aws_service_discovery_private_dns_namespace.example.id
}

# Output: arn
# Description: The ARN (Amazon Resource Name) that Route 53 assigns to the namespace
# Usage: Used for IAM policies, cross-account resource sharing, and API operations
# Format: arn:aws:servicediscovery:region:account-id:namespace/ns-xxxxxxxxxx
output "namespace_arn" {
  description = "The ARN of the private DNS namespace"
  value       = aws_service_discovery_private_dns_namespace.example.arn
}

# Output: hosted_zone
# Description: The ID of the Route 53 private hosted zone that was automatically created
# Usage: Can be used to create additional Route 53 records or for troubleshooting DNS
# Note: This hosted zone is managed by Cloud Map and should not be modified directly
output "hosted_zone_id" {
  description = "The Route 53 hosted zone ID created for this namespace"
  value       = aws_service_discovery_private_dns_namespace.example.hosted_zone
}

# Output: tags_all
# Description: A map of all tags assigned to the resource, including provider default_tags
# Usage: Useful for auditing and ensuring tag compliance
output "namespace_tags_all" {
  description = "All tags assigned to the namespace including provider defaults"
  value       = aws_service_discovery_private_dns_namespace.example.tags_all
}

# =============================================================================
# Usage Notes
# =============================================================================
#
# 1. Prerequisites:
#    - An existing VPC must be created before this namespace
#    - Ensure DNS hostnames and DNS resolution are enabled in the VPC
#
# 2. Service Discovery Workflow:
#    a. Create a namespace (this resource)
#    b. Create services within the namespace (aws_service_discovery_service)
#    c. Register service instances (aws_service_discovery_instance)
#    d. Applications can discover instances via DNS queries or API calls
#
# 3. DNS Resolution:
#    - Services registered in this namespace will be resolvable as:
#      <service-name>.<namespace-name>
#    - Example: If namespace is "services.local" and service is "api",
#      instances can be discovered at "api.services.local"
#
# 4. Integration Points:
#    - Amazon ECS Service Connect
#    - Amazon ECS Service Discovery
#    - AWS App Mesh
#    - Custom applications using AWS SDK or DNS queries
#
# 5. DNS TTL Considerations:
#    - DNS records created by Cloud Map have a default TTL
#    - TTL is configured at the service level, not the namespace level
#    - Consider health check frequency when setting TTLs
#
# 6. Multi-VPC Scenarios:
#    - A private namespace can only be associated with one VPC initially
#    - You can associate the Route 53 hosted zone with additional VPCs
#    - For multi-VPC discovery, use VPC peering or Transit Gateway
#
# 7. Cost Considerations:
#    - Charged for the private hosted zone (Route 53 pricing)
#    - Charged for service discovery API calls
#    - No additional charge for the namespace itself
#
# 8. Regional Availability:
#    - AWS Cloud Map is available in most AWS regions
#    - Namespaces are region-specific resources
#    - For multi-region applications, create a namespace in each region
#
# 9. Deletion Considerations:
#    - All services must be deleted before deleting the namespace
#    - The associated Route 53 hosted zone will be automatically deleted
#    - DNS resolution will stop working once the namespace is deleted
#
# 10. Best Practices:
#     - Use descriptive namespace names that indicate environment/purpose
#     - Keep namespace names consistent across environments
#     - Use tags to organize namespaces by team, application, or cost center
#     - Document the naming convention for services within the namespace
#     - Monitor DNS query patterns and API usage for optimization
#
# =============================================================================
# Common Patterns
# =============================================================================
#
# Pattern 1: Complete Service Discovery Setup
# --------------------------------------------
# resource "aws_vpc" "main" {
#   cidr_block           = "10.0.0.0/16"
#   enable_dns_hostnames = true
#   enable_dns_support   = true
# }
#
# resource "aws_service_discovery_private_dns_namespace" "main" {
#   name        = "services.local"
#   description = "Private namespace for internal services"
#   vpc         = aws_vpc.main.id
# }
#
# resource "aws_service_discovery_service" "api" {
#   name = "api"
#
#   dns_config {
#     namespace_id = aws_service_discovery_private_dns_namespace.main.id
#
#     dns_records {
#       ttl  = 10
#       type = "A"
#     }
#   }
#
#   health_check_custom_config {
#     failure_threshold = 1
#   }
# }
#
# Pattern 2: ECS Service Connect Integration
# -------------------------------------------
# resource "aws_ecs_service" "app" {
#   name            = "app-service"
#   cluster         = aws_ecs_cluster.main.id
#   task_definition = aws_ecs_task_definition.app.arn
#
#   service_connect_configuration {
#     enabled   = true
#     namespace = aws_service_discovery_private_dns_namespace.main.arn
#
#     service {
#       port_name      = "http"
#       discovery_name = "app"
#
#       client_alias {
#         port     = 8080
#         dns_name = "app"
#       }
#     }
#   }
# }
#
# Pattern 3: Multi-Environment Namespaces
# ----------------------------------------
# locals {
#   environments = ["dev", "staging", "production"]
# }
#
# resource "aws_service_discovery_private_dns_namespace" "env" {
#   for_each = toset(local.environments)
#
#   name        = "${each.key}.services.local"
#   description = "Private namespace for ${each.key} environment"
#   vpc         = aws_vpc.env[each.key].id
#
#   tags = {
#     Environment = each.key
#     ManagedBy   = "terraform"
#   }
# }
#
# =============================================================================
# Troubleshooting
# =============================================================================
#
# Issue: DNS resolution not working
# Solution:
# - Verify VPC has DNS hostnames and DNS support enabled
# - Check security groups allow traffic on port 53
# - Ensure services and instances are properly registered
# - Verify the application is querying the correct DNS name
#
# Issue: Cannot delete namespace
# Solution:
# - Delete all services within the namespace first
# - Wait for services to be fully deleted (can take several minutes)
# - Check for any remaining instances registered to services
#
# Issue: Cross-VPC discovery not working
# Solution:
# - Associate the Route 53 hosted zone with additional VPCs
# - Use VPC peering or Transit Gateway for network connectivity
# - Update security groups to allow traffic between VPCs
#
# =============================================================================
