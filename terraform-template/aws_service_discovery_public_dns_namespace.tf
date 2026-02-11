################################################################################
# AWS Service Discovery Public DNS Namespace
################################################################################
# Service: AWS Cloud Map
# Resource: aws_service_discovery_public_dns_namespace
# Provider Version: 6.28.0
#
# Overview:
# Creates a public DNS namespace in AWS Cloud Map (formerly Service Discovery).
# A public DNS namespace is visible on the internet and enables service discovery
# using public DNS queries or AWS Cloud Map API calls. When you create a public
# DNS namespace, AWS Cloud Map automatically creates a corresponding Amazon
# Route 53 public hosted zone.
#
# Use Cases:
# - Service discovery for publicly accessible microservices
# - DNS-based service registry for internet-facing applications
# - Integration with Amazon ECS, EKS, or EC2 instances
# - API-based service discovery with DNS fallback
#
# Important Notes:
# - Requires a registered domain name (you must own the domain)
# - Creates a Route 53 public hosted zone automatically
# - Supports both DNS queries and API-based service discovery
# - Public DNS namespaces are discoverable from the internet
# - Cannot be used within VPCs only (use private DNS namespace for that)
#
# Reference:
# https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/service_discovery_public_dns_namespace
# https://docs.aws.amazon.com/cloud-map/latest/dg/creating-namespaces.html
################################################################################

resource "aws_service_discovery_public_dns_namespace" "example" {
  #-----------------------------------------------------------------------------
  # Required Arguments
  #-----------------------------------------------------------------------------

  # The name of the namespace (must be a valid domain name you own)
  # This becomes the DNS namespace where services will be registered
  # Example: If name is "example.com" and you create a service named "api",
  # instances will be discoverable at "api.example.com"
  #
  # Constraints:
  # - Must be a valid domain name
  # - Must be a domain you own or control
  # - Cannot be changed after creation (forces replacement)
  # - Should follow DNS naming conventions
  #
  # Examples:
  # - "example.com"
  # - "services.example.com"
  # - "prod.myapp.com"
  name = "example.com"

  #-----------------------------------------------------------------------------
  # Optional Arguments
  #-----------------------------------------------------------------------------

  # Description of the namespace
  # Helps identify the purpose of this namespace
  #
  # Best Practices:
  # - Include environment information (prod, dev, staging)
  # - Mention the application or service group
  # - Keep it concise but descriptive
  description = "Public DNS namespace for production services"

  # Region where this resource will be managed
  # Defaults to the region set in the provider configuration
  #
  # Use Cases:
  # - Multi-region deployments with region-specific namespaces
  # - Explicit region specification for clarity
  #
  # Note: Typically omitted and defaults to provider configuration
  # region = "us-east-1"

  # Tags to assign to the namespace
  # Used for resource organization, cost allocation, and access control
  #
  # Best Practices:
  # - Include Environment, Application, Team tags
  # - Use consistent tagging strategy across resources
  # - Tags are merged with provider default_tags
  tags = {
    Name        = "example-public-namespace"
    Environment = "production"
    ManagedBy   = "terraform"
    Application = "microservices"
  }

  #-----------------------------------------------------------------------------
  # Exported Attributes (Available after creation)
  #-----------------------------------------------------------------------------
  # These attributes can be referenced in other resources using:
  # aws_service_discovery_public_dns_namespace.example.<attribute>
  #
  # - id          : The ID of the namespace (used for API operations)
  # - arn         : The ARN that Route 53 assigns to the namespace
  # - hosted_zone : The ID of the Route 53 hosted zone created for this namespace
  # - tags_all    : All tags including provider default_tags
  #-----------------------------------------------------------------------------
}

################################################################################
# Example: Complete Public DNS Namespace Setup with Service
################################################################################
# This example shows a complete setup with a public namespace and a service

# resource "aws_service_discovery_public_dns_namespace" "main" {
#   name        = "mycompany.com"
#   description = "Main public namespace for customer-facing services"
#
#   tags = {
#     Name        = "mycompany-public-namespace"
#     Environment = "production"
#     Team        = "platform"
#   }
# }

# resource "aws_service_discovery_service" "api" {
#   name = "api"
#
#   dns_config {
#     namespace_id = aws_service_discovery_public_dns_namespace.main.id
#
#     dns_records {
#       ttl  = 60
#       type = "A"
#     }
#
#     routing_policy = "MULTIVALUE"
#   }
#
#   health_check_custom_config {
#     failure_threshold = 1
#   }
#
#   tags = {
#     Name = "api-service"
#   }
# }

################################################################################
# Example: Output Values
################################################################################
# Common outputs for referencing namespace information

# output "namespace_id" {
#   description = "The ID of the Service Discovery public DNS namespace"
#   value       = aws_service_discovery_public_dns_namespace.example.id
# }
#
# output "namespace_arn" {
#   description = "The ARN of the Service Discovery public DNS namespace"
#   value       = aws_service_discovery_public_dns_namespace.example.arn
# }
#
# output "hosted_zone_id" {
#   description = "The Route 53 hosted zone ID created for this namespace"
#   value       = aws_service_discovery_public_dns_namespace.example.hosted_zone
# }
#
# output "namespace_name" {
#   description = "The name of the public DNS namespace"
#   value       = aws_service_discovery_public_dns_namespace.example.name
# }

################################################################################
# Additional Configuration Examples
################################################################################

# Example 1: Development Environment Namespace
# ------------------------------------------------------------------------------
# resource "aws_service_discovery_public_dns_namespace" "dev" {
#   name        = "dev.myapp.com"
#   description = "Development environment namespace"
#
#   tags = {
#     Name        = "myapp-dev-namespace"
#     Environment = "development"
#     Team        = "engineering"
#   }
# }

# Example 2: Multi-Region Setup
# ------------------------------------------------------------------------------
# resource "aws_service_discovery_public_dns_namespace" "us_east" {
#   name        = "us-east.services.example.com"
#   description = "US East region services namespace"
#   region      = "us-east-1"
#
#   tags = {
#     Name   = "us-east-namespace"
#     Region = "us-east-1"
#   }
# }

# Example 3: Namespace with Service Discovery Integration
# ------------------------------------------------------------------------------
# This example shows ECS integration with Service Discovery

# resource "aws_service_discovery_public_dns_namespace" "ecs" {
#   name        = "ecs.example.com"
#   description = "Namespace for ECS services"
#
#   tags = {
#     Name    = "ecs-namespace"
#     Service = "ECS"
#   }
# }
#
# resource "aws_service_discovery_service" "web" {
#   name = "web"
#
#   dns_config {
#     namespace_id = aws_service_discovery_public_dns_namespace.ecs.id
#
#     dns_records {
#       ttl  = 10
#       type = "A"
#     }
#
#     routing_policy = "MULTIVALUE"
#   }
#
#   health_check_custom_config {
#     failure_threshold = 1
#   }
# }
#
# resource "aws_ecs_service" "web" {
#   name            = "web"
#   cluster         = aws_ecs_cluster.main.id
#   task_definition = aws_ecs_task_definition.web.arn
#   desired_count   = 3
#
#   service_registries {
#     registry_arn = aws_service_discovery_service.web.arn
#   }
# }

################################################################################
# Best Practices and Considerations
################################################################################
#
# 1. Naming Strategy:
#    - Use descriptive domain names that reflect the service group
#    - Consider environment-specific subdomains (dev.*, prod.*)
#    - Align with your organization's DNS structure
#
# 2. Domain Ownership:
#    - Ensure you own or control the domain name used
#    - The domain must be registered (Route 53 or external registrar)
#    - Route 53 will create a public hosted zone automatically
#
# 3. Security Considerations:
#    - Public DNS namespaces are discoverable from the internet
#    - Use private DNS namespaces for internal-only services
#    - Implement proper network security controls (security groups, NACLs)
#    - Consider using AWS Cloud Map API for service discovery instead of DNS
#
# 4. Cost Optimization:
#    - Route 53 hosted zones have monthly costs ($0.50 per zone)
#    - DNS queries are charged per million queries
#    - Consider consolidating services under fewer namespaces
#    - Use appropriate TTL values to balance between freshness and query costs
#
# 5. Service Discovery Options:
#    - DNS queries: Use standard DNS resolution (A, AAAA, SRV records)
#    - API calls: Use DiscoverInstances API for programmatic discovery
#    - Health checks: Implement custom health checks for reliable service discovery
#
# 6. Integration Patterns:
#    - ECS: Use service_registries block for automatic registration
#    - EKS: Use AWS Cloud Map Controller for Kubernetes integration
#    - EC2: Register instances manually using RegisterInstance API
#    - Lambda: Use API-based discovery for function-to-service communication
#
# 7. High Availability:
#    - Register multiple instances per service for redundancy
#    - Use appropriate routing policies (MULTIVALUE, WEIGHTED)
#    - Set reasonable TTL values for DNS records (10-60 seconds typical)
#    - Implement health checks to ensure only healthy instances are discovered
#
# 8. Tagging Strategy:
#    - Use consistent tags across all namespaces and services
#    - Include Environment, Team, Application, CostCenter tags
#    - Leverage AWS Organizations tag policies for governance
#    - Tags are inherited by Route 53 hosted zone
#
# 9. Lifecycle Management:
#    - Deletion requires all services to be deleted first
#    - Route 53 hosted zone is automatically deleted with namespace
#    - Use terraform destroy carefully to avoid orphaned resources
#    - Consider using lifecycle prevent_destroy for production namespaces
#
# 10. Monitoring and Observability:
#     - Monitor Route 53 query counts via CloudWatch metrics
#     - Track service registration/deregistration events
#     - Set up CloudWatch alarms for unhealthy instance counts
#     - Use AWS X-Ray for end-to-end service discovery tracing
#
################################################################################
# Common Error Scenarios and Troubleshooting
################################################################################
#
# Error: "InvalidInput: The namespace name you specified is invalid"
# Solution: Ensure the name follows DNS naming conventions and is a valid domain
#
# Error: "DuplicateRequest: The namespace already exists"
# Solution: Choose a different name or import the existing namespace into Terraform
#
# Error: "ResourceInUse: The namespace cannot be deleted because it still contains services"
# Solution: Delete all services within the namespace before deleting the namespace
#
# Error: "AccessDeniedException"
# Solution: Ensure IAM permissions include:
#   - servicediscovery:CreatePublicDnsNamespace
#   - servicediscovery:DeleteNamespace
#   - servicediscovery:TagResource
#   - route53:CreateHostedZone
#   - route53:DeleteHostedZone
#
################################################################################
