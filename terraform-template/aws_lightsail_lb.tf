################################################################################
# AWS Lightsail Load Balancer
################################################################################
# Manages a Lightsail load balancer resource for distributing incoming traffic
# across multiple Lightsail instances to improve application availability and
# performance.
#
# Key Features:
# - Distributes traffic across instances in multiple Availability Zones
# - Automatic health checking every 30 seconds
# - Supports HTTP and HTTPS connections with SSL/TLS certificate management
# - Session persistence (sticky sessions) support
# - Dual-stack mode (IPv4 and IPv6) by default
# - Automatically scales to handle traffic spikes
# - Round-robin algorithm for traffic routing
#
# Use Cases:
# - Websites with occasional traffic spikes
# - Applications requiring high availability and fault tolerance
# - Heavy content serving applications
# - Applications requiring HTTPS encryption
#
# Prerequisites:
# - Lightsail instances must be created and configured for load balancing
# - For session persistence: Applications should store session data appropriately
# - For HTTPS: SSL/TLS certificate must be created and validated
#
# Related Resources:
# - aws_lightsail_instance: Target instances to attach to the load balancer
# - aws_lightsail_lb_certificate: SSL/TLS certificate for HTTPS support
# - aws_lightsail_lb_attachment: Attach instances to the load balancer
# - aws_lightsail_lb_certificate_attachment: Attach certificate to load balancer
# - aws_lightsail_lb_stickiness_policy: Configure session persistence
# - aws_lightsail_lb_https_redirection_policy: Configure HTTP to HTTPS redirect
#
# AWS Documentation:
# https://docs.aws.amazon.com/lightsail/latest/userguide/understanding-lightsail-load-balancers.html
#
# Terraform Documentation:
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lightsail_lb
################################################################################

resource "aws_lightsail_lb" "example" {
  ################################################################################
  # Required Arguments
  ################################################################################

  # (Required) Name of the Lightsail load balancer
  # Must be unique within your Lightsail account
  # Used as the resource identifier (matches the 'id' attribute)
  # Constraints:
  # - Must be between 2-255 characters
  # - Can contain letters, numbers, hyphens, and underscores
  # - Must start and end with a letter or number
  # Example: "example-load-balancer", "prod-web-lb", "app-loadbalancer-01"
  name = "example-load-balancer"

  # (Required) Instance port the load balancer will connect to
  # This is the port on your target instances where the application is listening
  # The load balancer forwards traffic to this port on attached instances
  # Common values:
  # - 80: HTTP traffic
  # - 443: HTTPS traffic
  # - 3000: Node.js applications
  # - 8080: Alternative HTTP port
  # - 8443: Alternative HTTPS port
  # Note: All instances must listen on the same port
  instance_port = 80

  ################################################################################
  # Optional Arguments
  ################################################################################

  # (Optional) Health check path of the load balancer
  # Default: "/"
  # The load balancer pings this path every 30 seconds to check instance health
  # Instance status can be "Passed" or "Failed"
  # - If "Failed", traffic is not routed to that instance
  # Customization recommendations:
  # - Use a lightweight page to reduce load (e.g., "/health", "/status")
  # - Ensure the page returns HTTP 200 status code
  # - Page should load quickly to avoid false negatives
  # - Can check database connectivity or other critical components
  # Examples: "/", "/health", "/status", "/healthcheck", "/ping"
  health_check_path = "/"

  # (Optional) IP address type of the load balancer
  # Valid values:
  # - "dualstack": Accepts both IPv4 and IPv6 traffic (default)
  # - "ipv4": Only accepts IPv4 traffic
  # Default: "dualstack"
  # Note: Target instances do not need to be IPv6-enabled
  # The load balancer handles protocol translation
  # Use "ipv4" only if you specifically want to disable IPv6 support
  # ip_address_type = "dualstack"

  # (Optional) Region where this resource will be managed
  # Defaults to the region set in the provider configuration
  # Important:
  # - Target instances must be in the same region as the load balancer
  # - Instances can be in different Availability Zones within the region
  # - Cross-region load balancing is not supported
  # Example: "us-east-1", "us-west-2", "eu-west-1", "ap-southeast-1"
  # region = "us-east-1"

  # (Optional) Map of tags to assign to the resource
  # Tags help organize and manage resources
  # To create a key-only tag, use an empty string as the value
  # If configured with a provider default_tags configuration block,
  # tags with matching keys will overwrite those defined at the provider level
  # Best practices:
  # - Use consistent naming conventions across your infrastructure
  # - Include environment, application, owner, and cost center tags
  # - Use tags for cost allocation and resource grouping
  tags = {
    Name        = "example-load-balancer"
    Environment = "production"
    Application = "web-app"
    ManagedBy   = "terraform"
    # foo         = "bar"
  }

  ################################################################################
  # Computed Attributes (Read-Only)
  ################################################################################
  # These attributes are automatically set by AWS and cannot be configured:
  #
  # - arn: ARN of the Lightsail load balancer
  #   Example: "arn:aws:lightsail:us-east-1:123456789012:LoadBalancer/..."
  #
  # - created_at: Timestamp when the load balancer was created
  #   Format: RFC3339 timestamp
  #   Example: "2024-01-15T10:30:00Z"
  #
  # - dns_name: DNS name of the load balancer
  #   This is the public hostname to access your application
  #   Example: "example-load-balancer-1234567890.us-east-1.elb.amazonaws.com"
  #   Use this in your DNS records (CNAME) to point your domain to the load balancer
  #
  # - id: Name used for this load balancer (matches 'name')
  #   Example: "example-load-balancer"
  #
  # - protocol: Protocol of the load balancer
  #   Values: "HTTP", "HTTPS"
  #   Automatically determined based on configuration
  #
  # - public_ports: List of public ports the load balancer listens on
  #   Example: [80] for HTTP, [443] for HTTPS, or [80, 443] for both
  #
  # - support_code: AWS support code for this load balancer
  #   Include this code when contacting AWS support for faster assistance
  #   Example: "6EXAMPLE3GH/ls-1EXAMPLE23456789012345678901234567890"
  #
  # - tags_all: Map of all tags including those inherited from provider default_tags
  ################################################################################
}

################################################################################
# Additional Configuration Examples
################################################################################

# Example 1: Production load balancer with custom health check
# resource "aws_lightsail_lb" "production" {
#   name              = "prod-web-lb"
#   instance_port     = 8080
#   health_check_path = "/health"
#   ip_address_type   = "dualstack"
#
#   tags = {
#     Name        = "prod-web-lb"
#     Environment = "production"
#     Team        = "platform"
#   }
# }

# Example 2: IPv4-only load balancer for legacy applications
# resource "aws_lightsail_lb" "legacy" {
#   name              = "legacy-app-lb"
#   instance_port     = 80
#   health_check_path = "/"
#   ip_address_type   = "ipv4"
#
#   tags = {
#     Name        = "legacy-app-lb"
#     Environment = "staging"
#     Application = "legacy-crm"
#   }
# }

# Example 3: Load balancer with alternative port
# resource "aws_lightsail_lb" "nodejs_app" {
#   name              = "nodejs-app-lb"
#   instance_port     = 3000
#   health_check_path = "/api/health"
#
#   tags = {
#     Name        = "nodejs-app-lb"
#     Environment = "development"
#     Runtime     = "nodejs"
#   }
# }

################################################################################
# Common Patterns and Best Practices
################################################################################

# 1. Health Check Configuration:
#    - Use a dedicated health check endpoint (e.g., /health, /status)
#    - Keep the health check page lightweight to avoid resource overhead
#    - Include critical component checks (database, cache) in health endpoint
#    - Return HTTP 200 for healthy status, 500+ for unhealthy
#    - Health checks occur every 30 seconds by default

# 2. Instance Configuration:
#    - Ensure all instances listen on the configured instance_port
#    - Configure instances to handle X-Forwarded-For headers
#    - Set up centralized database and media storage for multi-instance setup
#    - Use session persistence if your application stores session data locally

# 3. High Availability:
#    - Attach instances from multiple Availability Zones
#    - Maintain at least 2 instances behind the load balancer
#    - Monitor health check metrics to identify issues early
#    - Use auto-scaling strategies to handle traffic spikes

# 4. Security:
#    - Enable HTTPS with SSL/TLS certificates (use aws_lightsail_lb_certificate)
#    - Configure HTTP to HTTPS redirection for secure traffic
#    - Use appropriate TLS security policies
#    - Regularly update and renew SSL/TLS certificates

# 5. Monitoring:
#    - Monitor health check metrics (healthy/unhealthy host counts)
#    - Track HTTP response codes and instance response times
#    - Set up CloudWatch alarms for critical metrics
#    - Review rejected connection counts for capacity planning

# 6. Session Persistence:
#    - Enable for applications like Magento, e-commerce platforms
#    - Use aws_lightsail_lb_stickiness_policy to configure
#    - Adjust cookie duration based on session timeout requirements
#    - Consider stateless design for better scalability

# 7. Cost Optimization:
#    - Load balancers have a fixed monthly cost
#    - Data transfer costs apply for traffic through the load balancer
#    - Right-size instance types based on actual traffic patterns
#    - Use tags for cost allocation and tracking

# 8. Maintenance:
#    - Test health check endpoints regularly
#    - Plan for instance replacement without service interruption
#    - Keep target instances updated with security patches
#    - Document load balancer configuration and dependencies

################################################################################
# Troubleshooting
################################################################################

# Common Issues:
# 1. Health Check Failures:
#    - Verify the health_check_path returns HTTP 200
#    - Check instance security groups allow traffic on instance_port
#    - Ensure the application is running on the correct port
#    - Review health check path permissions and response times

# 2. Connection Issues:
#    - Verify DNS propagation if using custom domain
#    - Check that instances are in the same region as load balancer
#    - Ensure instances are properly attached to the load balancer
#    - Review network ACLs and security group rules

# 3. Performance Issues:
#    - Monitor instance response time metrics
#    - Check for unhealthy instances in the target pool
#    - Review application logs for errors or slowdowns
#    - Consider scaling up instance size or count

# 4. SSL/TLS Issues:
#    - Verify certificate is validated and attached
#    - Check certificate expiration date
#    - Ensure domain name matches certificate
#    - Review TLS security policy compatibility

################################################################################
# Output Values
################################################################################

# output "lb_dns_name" {
#   description = "DNS name of the load balancer"
#   value       = aws_lightsail_lb.example.dns_name
# }

# output "lb_arn" {
#   description = "ARN of the load balancer"
#   value       = aws_lightsail_lb.example.arn
# }

# output "lb_support_code" {
#   description = "Support code for AWS support requests"
#   value       = aws_lightsail_lb.example.support_code
# }

# output "lb_public_ports" {
#   description = "Public ports the load balancer is listening on"
#   value       = aws_lightsail_lb.example.public_ports
# }
