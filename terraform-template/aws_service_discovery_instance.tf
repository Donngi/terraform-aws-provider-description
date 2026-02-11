# ============================================================
# AWS Service Discovery Instance
# ============================================================
# Provider Version: 6.28.0
# Resource: aws_service_discovery_instance
# Description: Provides a Service Discovery Instance resource.
#
# This resource is used to register an instance with AWS Cloud Map
# (formerly AWS Service Discovery). Instances can represent any
# resource such as EC2 instances, IP addresses, or other endpoints.
# ============================================================

resource "aws_service_discovery_instance" "example" {
  # ============================================================
  # Required Arguments
  # ============================================================

  # instance_id - (Required, ForceNew)
  # Description: The ID of the service instance.
  # Type: string
  # Note: Changing this value will force recreation of the resource.
  # This should be a unique identifier for your instance.
  # Example: "example-instance-id", "web-server-001", "i-0abdg374kd892cj6dl"
  instance_id = "example-instance-id"

  # service_id - (Required, ForceNew)
  # Description: The ID of the service that you want to use to create the instance.
  # Type: string
  # Note: Changing this value will force recreation of the resource.
  # This should reference the ID of an aws_service_discovery_service resource.
  # Example: aws_service_discovery_service.example.id
  service_id = "srv-example123456"

  # attributes - (Required)
  # Description: A map contains the attributes of the instance.
  # Type: map(string)
  # Note: The supported attributes depend on the namespace type:
  #   - For DNS namespaces (DNS_PUBLIC, DNS_PRIVATE):
  #     * AWS_INSTANCE_IPV4: IPv4 address (required for A records)
  #     * AWS_INSTANCE_IPV6: IPv6 address (required for AAAA records)
  #     * AWS_INSTANCE_PORT: Port number
  #   - For HTTP namespaces:
  #     * AWS_INSTANCE_IPV4: IPv4 address
  #     * AWS_INSTANCE_IPV6: IPv6 address
  #     * AWS_INSTANCE_PORT: Port number
  #     * AWS_EC2_INSTANCE_ID: EC2 instance ID
  #   - Custom attributes: You can add any custom key-value pairs
  # Reference: https://docs.aws.amazon.com/cloud-map/latest/api/API_RegisterInstance.html#API_RegisterInstance_RequestSyntax
  attributes = {
    AWS_INSTANCE_IPV4 = "172.18.0.1"
    AWS_INSTANCE_PORT = "80"
    custom_attribute  = "custom_value"
  }

  # ============================================================
  # Optional Arguments
  # ============================================================

  # region - (Optional, Computed)
  # Description: Region where this resource will be managed.
  # Type: string
  # Note: Defaults to the Region set in the provider configuration.
  # Only specify this if you need to override the provider region.
  # Reference: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-west-2"

  # ============================================================
  # Computed Attributes (Read-Only)
  # ============================================================
  # The following attributes are exported but cannot be set:
  #
  # id - The ID of the instance (format: service_id/instance_id)
  # ============================================================
}

# ============================================================
# Example Usage Scenarios
# ============================================================

# Example 1: DNS Namespace with IPv4 Address
# This example registers an instance with a private DNS namespace
# resource "aws_service_discovery_instance" "dns_example" {
#   instance_id = "web-server-001"
#   service_id  = aws_service_discovery_service.example.id
#
#   attributes = {
#     AWS_INSTANCE_IPV4 = "172.18.0.1"
#     AWS_INSTANCE_PORT = "80"
#   }
# }

# Example 2: HTTP Namespace with EC2 Instance
# This example registers an EC2 instance with an HTTP namespace
# resource "aws_service_discovery_instance" "http_example" {
#   instance_id = "web-server-002"
#   service_id  = aws_service_discovery_service.http_service.id
#
#   attributes = {
#     AWS_EC2_INSTANCE_ID = "i-0abdg374kd892cj6dl"
#     AWS_INSTANCE_IPV4   = "10.0.1.50"
#   }
# }

# Example 3: Multiple Custom Attributes
# This example includes multiple custom attributes for application metadata
# resource "aws_service_discovery_instance" "custom_example" {
#   instance_id = "app-instance-001"
#   service_id  = aws_service_discovery_service.example.id
#
#   attributes = {
#     AWS_INSTANCE_IPV4 = "172.18.0.5"
#     AWS_INSTANCE_PORT = "8080"
#     environment       = "production"
#     version           = "1.2.3"
#     availability_zone = "us-east-1a"
#   }
# }

# ============================================================
# Complete Integration Example
# ============================================================
# This shows how to create a complete Service Discovery setup
# with VPC, namespace, service, and instance

# resource "aws_vpc" "example" {
#   cidr_block           = "10.0.0.0/16"
#   enable_dns_support   = true
#   enable_dns_hostnames = true
# }
#
# resource "aws_service_discovery_private_dns_namespace" "example" {
#   name        = "example.terraform.local"
#   description = "Private DNS namespace for service discovery"
#   vpc         = aws_vpc.example.id
# }
#
# resource "aws_service_discovery_service" "example" {
#   name = "example-service"
#
#   dns_config {
#     namespace_id = aws_service_discovery_private_dns_namespace.example.id
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
# resource "aws_service_discovery_instance" "example" {
#   instance_id = "example-instance-001"
#   service_id  = aws_service_discovery_service.example.id
#
#   attributes = {
#     AWS_INSTANCE_IPV4 = "172.18.0.1"
#     custom_attribute  = "production"
#   }
# }

# ============================================================
# Important Notes
# ============================================================
# 1. Instance ID and Service ID cannot be changed after creation
#    (ForceNew = true). Any change will destroy and recreate the resource.
#
# 2. The attributes map must contain the appropriate AWS_INSTANCE_*
#    keys based on your namespace and DNS record type:
#    - For A records: AWS_INSTANCE_IPV4 is required
#    - For AAAA records: AWS_INSTANCE_IPV6 is required
#    - For SRV records: AWS_INSTANCE_PORT is required
#
# 3. Custom attributes can be added to the attributes map for
#    application-specific metadata and are queryable via the
#    Cloud Map API.
#
# 4. The instance will be automatically deregistered when the
#    resource is destroyed.
#
# 5. Health checks can be configured at the service level and
#    will affect instance health status.
#
# 6. For HTTP namespaces, instances are not resolvable via DNS
#    but can be discovered through the AWS Cloud Map API.
# ============================================================

# ============================================================
# Terraform Configuration
# ============================================================
# Ensure your terraform block specifies the correct provider version:
#
# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "6.28.0"
#     }
#   }
# }
# ============================================================
