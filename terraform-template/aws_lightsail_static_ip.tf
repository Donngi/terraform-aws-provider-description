###############################################################################
# AWS Provider Version: 6.28.0
# Resource: aws_lightsail_static_ip
# Purpose: Allocate and manage a static IP address for Amazon Lightsail instances
#
# Description:
#   This resource allocates a static IP address that can be attached to Lightsail
#   instances. A static IP provides a consistent public IP address that persists
#   across instance restarts, making it ideal for scenarios where DNS records
#   point to specific instances.
#
# Important Notes:
#   - Static IPs are FREE when attached to an instance
#   - Static IPs incur CHARGES when not attached to any instance
#   - Each static IP is region-specific and can only be attached to instances
#     in the same AWS Region
#   - When an instance without a static IP is stopped/restarted, it receives
#     a new public IP address
#   - Lightsail is only available in select AWS Regions
#
# Common Use Cases:
#   1. Web Server Hosting: Maintain consistent IP for domain DNS records
#   2. API Endpoints: Provide stable endpoint for client applications
#   3. Instance Replacement: Reassign the same IP when replacing instances
#   4. Email Services: Maintain IP reputation for mail servers
#
# References:
#   - Provider Documentation: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/lightsail_static_ip
#   - AWS Documentation: https://docs.aws.amazon.com/lightsail/latest/userguide/understanding-static-ip-addresses-in-amazon-lightsail.html
#   - Regions and AZs: https://lightsail.aws.amazon.com/ls/docs/overview/article/understanding-regions-and-availability-zones-in-amazon-lightsail
###############################################################################

resource "aws_lightsail_static_ip" "example" {
  ###############################################################################
  # Required Arguments
  ###############################################################################

  # Name for the allocated static IP
  #
  # Requirements:
  #   - Must be unique within your AWS account and region
  #   - Can contain alphanumeric characters, dashes, and underscores
  #   - Best practice: Use descriptive names that indicate purpose/instance
  #
  # Examples:
  #   - "web-server-prod-ip"
  #   - "api-gateway-static-ip"
  #   - "wordpress-instance-ip"
  #
  # Type: string
  # Required: Yes
  name = "example-static-ip"

  ###############################################################################
  # Optional Arguments
  ###############################################################################

  # AWS Region where the static IP will be managed
  #
  # Behavior:
  #   - If not specified, uses the provider's configured region
  #   - Static IP can only be attached to instances in the same region
  #   - Once created, the region cannot be changed
  #
  # Available Lightsail Regions (examples):
  #   - us-east-1 (N. Virginia)
  #   - us-west-2 (Oregon)
  #   - eu-west-1 (Ireland)
  #   - ap-southeast-1 (Singapore)
  #   - See AWS documentation for complete list
  #
  # Type: string
  # Default: Provider's configured region
  # Optional: Yes
  # region = "us-east-1"

  ###############################################################################
  # Computed Attributes (Read-Only)
  ###############################################################################

  # ARN of the Lightsail static IP
  # Format: arn:aws:lightsail:{region}:{account-id}:StaticIp/{resource-id}
  # Output: arn

  # The actual allocated static IP address
  # Format: IPv4 address (e.g., "203.0.113.25")
  # Use this value for DNS A records
  # Output: ip_address

  # AWS support code for this static IP
  # Include this code when contacting AWS support for assistance
  # Output: support_code
}

###############################################################################
# Output Examples
###############################################################################

# Export the allocated IP address
output "static_ip_address" {
  description = "The allocated static IP address"
  value       = aws_lightsail_static_ip.example.ip_address
}

# Export the ARN for cross-reference
output "static_ip_arn" {
  description = "The ARN of the static IP"
  value       = aws_lightsail_static_ip.example.arn
}

# Export the support code
output "static_ip_support_code" {
  description = "Support code for AWS assistance"
  value       = aws_lightsail_static_ip.example.support_code
}

###############################################################################
# Additional Configuration Examples
###############################################################################

# Example 1: Static IP for Production Web Server
resource "aws_lightsail_static_ip" "web_production" {
  name   = "web-server-production-ip"
  region = "us-east-1"
}

# Example 2: Static IP for Development Environment
resource "aws_lightsail_static_ip" "web_development" {
  name   = "web-server-dev-ip"
  region = "us-west-2"
}

# Example 3: Static IP with Attachment to Instance
# Note: Use aws_lightsail_static_ip_attachment resource to attach
resource "aws_lightsail_static_ip" "app_server" {
  name = "app-server-static-ip"
}

# Attach the static IP to an instance
# resource "aws_lightsail_static_ip_attachment" "app_server" {
#   static_ip_name = aws_lightsail_static_ip.app_server.name
#   instance_name  = aws_lightsail_instance.app.name
# }

###############################################################################
# Best Practices
###############################################################################

# 1. Cost Management:
#    - Always attach static IPs to instances to avoid charges
#    - Delete unused static IPs immediately to prevent unexpected costs
#    - Monitor static IP usage regularly

# 2. Naming Convention:
#    - Use consistent naming pattern across resources
#    - Include environment (prod/dev/staging) in names
#    - Reference the instance or service purpose

# 3. Regional Planning:
#    - Create static IPs in the same region as target instances
#    - Consider multi-region deployments for high availability
#    - Verify Lightsail availability in chosen regions

# 4. DNS Management:
#    - Create DNS A records pointing to the static IP
#    - Allow DNS propagation time after updates
#    - Use Route53 or your DNS provider for domain mapping

# 5. Security:
#    - Configure instance firewall rules appropriately
#    - Limit access to necessary ports and protocols
#    - Consider DDoS protection for public-facing services

###############################################################################
# Common Errors and Solutions
###############################################################################

# Error: "Static IP already exists"
# Solution: Choose a unique name or delete the existing static IP first

# Error: "Region not supported"
# Solution: Verify Lightsail is available in the specified region
# See: https://lightsail.aws.amazon.com/ls/docs/overview/article/understanding-regions-and-availability-zones-in-amazon-lightsail

# Error: "Cannot attach static IP to instance"
# Solution: Ensure both static IP and instance are in the same region

###############################################################################
# Migration and Import
###############################################################################

# Import existing static IP:
# terraform import aws_lightsail_static_ip.example example-static-ip-name

# Import syntax:
# terraform import aws_lightsail_static_ip.<resource_name> <static_ip_name>

###############################################################################
# Related Resources
###############################################################################

# Resources commonly used with aws_lightsail_static_ip:
# - aws_lightsail_instance: Create Lightsail virtual private server
# - aws_lightsail_static_ip_attachment: Attach static IP to instance
# - aws_route53_record: Create DNS records pointing to static IP
# - aws_lightsail_instance_public_ports: Configure instance firewall
