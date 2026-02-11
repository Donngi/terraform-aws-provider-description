################################################################################
# AWS Lightsail Load Balancer HTTPS Redirection Policy
#
# Resource: aws_lightsail_lb_https_redirection_policy
# Provider Version: 6.28.0
#
# Purpose:
# Manages HTTPS redirection for a Lightsail Load Balancer. This resource
# configures automatic redirection of HTTP traffic to HTTPS, ensuring secure
# communication for web applications.
#
# Prerequisites:
# - A Lightsail Load Balancer must be created
# - A valid SSL/TLS certificate must be created and attached to the load balancer
#   before enabling HTTPS redirection
# - The load balancer must have instances attached and be operational
#
# Security Considerations:
# - HTTPS redirection ensures all traffic is encrypted, preventing unauthorized
#   access and data interception
# - Google and other search engines rank secure websites higher in search results
# - Recommended for production environments to protect sensitive data
#
# Important Notes:
# - Changes take a few moments to take effect after applying
# - Only one HTTPS redirection policy can be configured per load balancer
# - The certificate must be validated and attached before enabling redirection
# - If the certificate is removed, HTTPS redirection should be disabled first
#
# Related Resources:
# - aws_lightsail_lb: Creates the load balancer
# - aws_lightsail_lb_certificate: Creates the SSL/TLS certificate
# - aws_lightsail_lb_certificate_attachment: Attaches the certificate to the load balancer
# - aws_lightsail_instance: Instances that are load balanced
#
# AWS Documentation:
# - https://docs.aws.amazon.com/lightsail/latest/userguide/amazon-lightsail-configure-load-balancer-https-redirection.html
# - https://docs.aws.amazon.com/lightsail/latest/userguide/understanding-lightsail-load-balancers.html
# - https://docs.aws.amazon.com/lightsail/2016-11-28/api-reference/API_LoadBalancer.html
#
# Terraform Documentation:
# - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lightsail_lb_https_redirection_policy
################################################################################

resource "aws_lightsail_lb_https_redirection_policy" "example" {
  ##############################################################################
  # Required Arguments
  ##############################################################################

  # (Required) Name of the load balancer to which you want to enable HTTP to HTTPS redirection
  # Type: string
  #
  # This must match the name of an existing Lightsail Load Balancer. The load
  # balancer must have a valid SSL/TLS certificate attached before HTTPS
  # redirection can be enabled.
  #
  # Example values:
  # - "my-load-balancer"
  # - "production-web-lb"
  # - "staging-api-lb"
  #
  # Best practices:
  # - Use consistent naming conventions across your Lightsail resources
  # - Reference the load balancer using aws_lightsail_lb.example.name for
  #   automatic dependency management
  # - Ensure the load balancer exists before creating this policy
  #
  # Related resources:
  # - aws_lightsail_lb.example.name - Primary reference method
  # - aws_lightsail_lb.example.id - Alternative reference (same as name)
  #
  # Constraints:
  # - Must be a valid Lightsail Load Balancer name
  # - Case-sensitive
  # - Must match exactly with the load balancer resource
  lb_name = "example-load-balancer"

  # (Required) Whether to enable HTTP to HTTPS redirection
  # Type: bool
  #
  # - true: Activates HTTP to HTTPS redirection. All HTTP requests (port 80)
  #   will be automatically redirected to HTTPS (port 443)
  # - false: Deactivates HTTP to HTTPS redirection. HTTP and HTTPS traffic
  #   will be handled independently
  #
  # Security implications:
  # - Setting to true ensures all traffic is encrypted
  # - Setting to false allows unencrypted HTTP traffic, which may expose
  #   sensitive data
  # - HTTPS redirection prevents man-in-the-middle attacks
  # - Protects against session hijacking and cookie theft
  #
  # Use cases:
  # - true: Production environments, sites handling sensitive data, SEO optimization,
  #   compliance requirements (PCI DSS, HIPAA, GDPR)
  # - false: Development/testing, troubleshooting, legacy application compatibility,
  #   applications that explicitly require HTTP access
  #
  # Best practices:
  # - Set to true for production environments
  # - Only set to false if there's a specific requirement for HTTP access
  # - Consider application compatibility before enabling
  # - Test thoroughly in staging environment first
  # - Ensure all application resources (CSS, JS, images) support HTTPS
  #
  # Redirection behavior:
  # - HTTP (port 80) → HTTPS (port 443)
  # - Status code: 301 (Moved Permanently) or 302 (Found)
  # - Original URL path and query parameters are preserved
  # - Example: http://example.com/page?id=1 → https://example.com/page?id=1
  enabled = true

  ##############################################################################
  # Optional Arguments
  ##############################################################################

  # (Optional) Region where this resource will be managed
  # Type: string
  # Default: The region set in the provider configuration
  # Computed: Yes (will be set to the provider region if not specified)
  #
  # Specifies the AWS region where the HTTPS redirection policy will be managed.
  # This should match the region where the load balancer is located.
  #
  # Available regions for Lightsail (as of 2025):
  # North America:
  # - us-east-1 (N. Virginia) - Default US region
  # - us-east-2 (Ohio)
  # - us-west-2 (Oregon)
  # - ca-central-1 (Canada Central)
  #
  # Europe:
  # - eu-central-1 (Frankfurt) - Central Europe
  # - eu-west-1 (Ireland) - Western Europe
  # - eu-west-2 (London)
  # - eu-west-3 (Paris)
  # - eu-north-1 (Stockholm)
  #
  # Asia Pacific:
  # - ap-south-1 (Mumbai) - India
  # - ap-southeast-1 (Singapore)
  # - ap-southeast-2 (Sydney) - Australia
  # - ap-northeast-1 (Tokyo) - Japan
  # - ap-northeast-2 (Seoul) - Korea
  #
  # Example values:
  # - "us-east-1"
  # - "eu-west-1"
  # - "ap-northeast-1"
  #
  # Best practices:
  # - Omit this parameter to use the provider's default region
  # - Only specify if the load balancer is in a different region than the provider
  # - Ensure the region matches the load balancer's region
  # - Consider data sovereignty and compliance requirements
  # - Choose regions close to your users for better performance
  #
  # Multi-region considerations:
  # - Each region requires its own load balancer and HTTPS redirection policy
  # - Use multiple resource blocks with different regions for multi-region deployments
  # - Consider using Terraform workspaces for region-specific configurations
  #
  # Documentation:
  # - https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  ##############################################################################
  # Computed Attributes (Read-Only)
  ##############################################################################

  # id - The ID of the HTTPS redirection policy (matches lb_name)
  # Type: string
  # Computed: Yes
  #
  # This attribute is automatically set to the load balancer name and can be
  # used for resource references and dependencies.
  #
  # Usage examples:
  # - Output the policy ID: output "policy_id" { value = aws_lightsail_lb_https_redirection_policy.example.id }
  # - Reference in other resources: depends_on = [aws_lightsail_lb_https_redirection_policy.example]
  # - Data source lookups: data.aws_lightsail_lb.example.id
}

################################################################################
# Complete Example with Related Resources
################################################################################

# Example: Complete setup with load balancer, certificate, and HTTPS redirection

# Step 1: Create the Lightsail Load Balancer
# resource "aws_lightsail_lb" "example" {
#   name              = "example-load-balancer"
#   health_check_path = "/"
#   instance_port     = 80
#
#   tags = {
#     Name        = "Example Load Balancer"
#     Environment = "Production"
#     ManagedBy   = "Terraform"
#   }
# }

# Step 2: Create the SSL/TLS Certificate
# resource "aws_lightsail_lb_certificate" "example" {
#   name        = "example-lb-certificate"
#   lb_name     = aws_lightsail_lb.example.id
#   domain_name = "example.com"
#
#   # Optional: Add Subject Alternative Names (SANs)
#   # Maximum 9 additional domains/subdomains
#   subject_alternative_names = [
#     "www.example.com",
#     "api.example.com"
#   ]
# }

# Step 3: Attach the Certificate to the Load Balancer
# resource "aws_lightsail_lb_certificate_attachment" "example" {
#   lb_name          = aws_lightsail_lb.example.name
#   certificate_name = aws_lightsail_lb_certificate.example.name
# }

# Step 4: Enable HTTPS Redirection
# resource "aws_lightsail_lb_https_redirection_policy" "example" {
#   lb_name = aws_lightsail_lb.example.name
#   enabled = true
#
#   # Ensure the certificate is attached before enabling redirection
#   depends_on = [
#     aws_lightsail_lb_certificate_attachment.example
#   ]
# }

################################################################################
# Use Cases and Patterns
################################################################################

# Use Case 1: Production Website with HTTPS Enforcement
# Description: Redirect all HTTP traffic to HTTPS for security
#
# resource "aws_lightsail_lb_https_redirection_policy" "production" {
#   lb_name = aws_lightsail_lb.production_web.name
#   enabled = true
#
#   depends_on = [
#     aws_lightsail_lb_certificate_attachment.production
#   ]
# }

# Use Case 2: Temporarily Disable HTTPS Redirection
# Description: Disable redirection for troubleshooting or maintenance
#
# resource "aws_lightsail_lb_https_redirection_policy" "maintenance" {
#   lb_name = aws_lightsail_lb.web.name
#   enabled = false
#
#   # Note: Document the reason for disabling in comments or change management
# }

# Use Case 3: Multi-Region Deployment
# Description: Enable HTTPS redirection for load balancers in multiple regions
#
# resource "aws_lightsail_lb_https_redirection_policy" "us_east" {
#   lb_name = aws_lightsail_lb.us_east.name
#   enabled = true
#   region  = "us-east-1"
#
#   depends_on = [
#     aws_lightsail_lb_certificate_attachment.us_east
#   ]
# }
#
# resource "aws_lightsail_lb_https_redirection_policy" "eu_west" {
#   lb_name = aws_lightsail_lb.eu_west.name
#   enabled = true
#   region  = "eu-west-1"
#
#   depends_on = [
#     aws_lightsail_lb_certificate_attachment.eu_west
#   ]
# }

# Use Case 4: Blue/Green Deployment Pattern
# Description: Manage HTTPS redirection across blue/green environments
#
# resource "aws_lightsail_lb_https_redirection_policy" "blue" {
#   lb_name = aws_lightsail_lb.blue.name
#   enabled = var.blue_active ? true : false
#
#   depends_on = [
#     aws_lightsail_lb_certificate_attachment.blue
#   ]
# }
#
# resource "aws_lightsail_lb_https_redirection_policy" "green" {
#   lb_name = aws_lightsail_lb.green.name
#   enabled = var.green_active ? true : false
#
#   depends_on = [
#     aws_lightsail_lb_certificate_attachment.green
#   ]
# }

################################################################################
# Troubleshooting Guide
################################################################################

# Common Issues and Solutions:
#
# 1. Error: "Load balancer not found"
#    Symptoms: Terraform plan/apply fails with load balancer not found error
#    Cause: The specified lb_name does not match any existing load balancer
#    Solution:
#    - Verify the load balancer exists: aws lightsail get-load-balancers --region us-east-1
#    - Check for typos in lb_name
#    - Ensure the load balancer is in the same region
#    - Use aws_lightsail_lb.example.name for automatic reference
#
# 2. Error: "Certificate not attached"
#    Symptoms: HTTPS redirection cannot be enabled without a certificate
#    Cause: No valid SSL/TLS certificate is attached to the load balancer
#    Solution:
#    - Create a certificate: aws_lightsail_lb_certificate
#    - Attach the certificate: aws_lightsail_lb_certificate_attachment
#    - Use depends_on to ensure certificate attachment completes first
#    - Verify certificate status: aws lightsail get-load-balancer-tls-certificates
#
# 3. Error: "Certificate validation pending"
#    Symptoms: Certificate exists but is not yet validated
#    Cause: DNS validation for the certificate has not completed
#    Solution:
#    - Add the required DNS CNAME record to your domain
#    - Wait for certificate validation to complete (can take 30+ minutes)
#    - Check validation status in Lightsail console or via CLI
#    - Consider using count/for_each to conditionally create the policy
#
# 4. HTTPS redirection not working
#    Symptoms: HTTP requests are not being redirected to HTTPS
#    Cause: Configuration changes may not have propagated yet
#    Solution:
#    - Wait a few moments (3-5 minutes) for changes to propagate
#    - Test with curl -I http://example.com (should return 301/302)
#    - Verify enabled = true in the configuration
#    - Check load balancer status: aws lightsail get-load-balancer
#    - Ensure both port 80 and 443 are accessible
#
# 5. Mixed content warnings
#    Symptoms: Browser shows "Not Secure" or mixed content warnings
#    Cause: Application resources (CSS, JS, images) are loaded via HTTP
#    Solution:
#    - Update application code to use relative URLs (e.g., /assets/style.css)
#    - Use protocol-relative URLs (e.g., //example.com/assets/style.css)
#    - Update absolute URLs to use HTTPS
#    - Enable Content Security Policy (CSP) to block mixed content
#
# 6. Redirect loop
#    Symptoms: Browser reports "too many redirects" error
#    Cause: Application is configured to redirect HTTPS to HTTP
#    Solution:
#    - Check application configuration for redirect rules
#    - Review .htaccess or web server configuration
#    - Ensure X-Forwarded-Proto header is respected by the application
#    - Disable application-level HTTPS redirection if using load balancer redirection
#
# 7. Performance issues
#    Symptoms: Slow page load times after enabling HTTPS redirection
#    Cause: Additional SSL/TLS handshake overhead
#    Solution:
#    - Enable HTTP/2 on the application server for better performance
#    - Implement caching strategies
#    - Use CDN for static assets
#    - Optimize SSL/TLS configuration (session resumption, OCSP stapling)
#
# 8. Regional availability issues
#    Symptoms: Resource not available in specified region
#    Cause: Lightsail services may not be available in all regions
#    Solution:
#    - Verify Lightsail is available in the target region
#    - Check AWS service availability: https://aws.amazon.com/about-aws/global-infrastructure/
#    - Use alternative regions if necessary

################################################################################
# Best Practices
################################################################################

# 1. Security:
#    - Always enable HTTPS redirection for production environments
#    - Use strong SSL/TLS security policies (TLS 1.2+ minimum)
#    - Regularly update and renew certificates before expiration
#    - Implement HSTS (HTTP Strict Transport Security) headers in the application
#    - Use certificate pinning for mobile applications
#    - Monitor certificate expiration dates and set up alerts
#    - Rotate certificates regularly as part of security hygiene
#
# 2. Deployment:
#    - Use depends_on to ensure proper resource creation order:
#      1. Load balancer
#      2. Certificate
#      3. Certificate attachment
#      4. HTTPS redirection policy
#    - Test HTTPS redirection in staging/development before production
#    - Document any temporary disabling of redirection in change management
#    - Use lifecycle rules to prevent accidental deletion
#    - Implement gradual rollout for critical production changes
#
# 3. Monitoring:
#    - Monitor certificate expiration dates (set alerts 30-60 days before expiry)
#    - Set up alerts for certificate validation failures
#    - Track HTTP to HTTPS redirection metrics (redirect rate, response times)
#    - Monitor SSL/TLS handshake performance
#    - Track mixed content warnings in application logs
#    - Set up synthetic monitoring to verify HTTPS redirection is working
#
# 4. Resource Management:
#    - Use consistent naming conventions across resources
#    - Tag resources appropriately for cost tracking and organization
#    - Document the purpose of each configuration in comments
#    - Use variables for reusable values (lb_name, region, etc.)
#    - Implement proper state file management (remote state, locking)
#    - Use Terraform modules for reusable configurations
#
# 5. High Availability:
#    - Ensure load balancer spans multiple Availability Zones
#    - Attach multiple instances for redundancy
#    - Configure health checks appropriately (path, interval, threshold)
#    - Implement session persistence if required by the application
#    - Use DNS failover for multi-region high availability
#    - Document disaster recovery procedures
#
# 6. Cost Optimization:
#    - Review load balancer usage and right-size if necessary
#    - Monitor data transfer costs through the load balancer
#    - Use lifecycle policies to clean up unused resources
#    - Consider Lightsail bundle pricing for predictable costs
#    - Use CloudWatch metrics to track resource utilization
#
# 7. Compliance:
#    - Document HTTPS redirection as part of security controls
#    - Include in compliance audits (PCI DSS, HIPAA, SOC 2, etc.)
#    - Maintain audit logs of configuration changes
#    - Implement change management processes for production changes
#    - Regular compliance reviews and updates

################################################################################
# Related AWS CLI Commands
################################################################################

# Get load balancer details:
# aws lightsail get-load-balancers --region us-east-1
#
# Output includes: name, arn, DNS name, protocol, health check path, instance port,
# instance health summary, tags, and HTTPS redirection status

# Get specific load balancer:
# aws lightsail get-load-balancer \
#   --load-balancer-name example-load-balancer \
#   --region us-east-1

# Update HTTPS redirection (enable):
# aws lightsail update-load-balancer-attribute \
#   --load-balancer-name example-load-balancer \
#   --attribute-name HttpsRedirectionEnabled \
#   --attribute-value true \
#   --region us-east-1

# Update HTTPS redirection (disable):
# aws lightsail update-load-balancer-attribute \
#   --load-balancer-name example-load-balancer \
#   --attribute-name HttpsRedirectionEnabled \
#   --attribute-value false \
#   --region us-east-1

# Get certificate details:
# aws lightsail get-load-balancer-tls-certificates \
#   --load-balancer-name example-load-balancer \
#   --region us-east-1
#
# Output includes: certificate name, domain name, status, subject alternative names,
# validation records, and expiration date

# Describe load balancer attributes:
# aws lightsail get-load-balancer-metric-data \
#   --load-balancer-name example-load-balancer \
#   --metric-name HealthyHostCount \
#   --period 300 \
#   --start-time 2025-01-30T00:00:00Z \
#   --end-time 2025-01-31T00:00:00Z \
#   --unit Count \
#   --statistics Average

# Test HTTPS redirection:
# curl -I http://example.com
# Expected response:
#   HTTP/1.1 301 Moved Permanently
#   Location: https://example.com/
#   Content-Length: 0
#   Date: Thu, 30 Jan 2025 12:00:00 GMT

# Test with full redirect chain:
# curl -IL http://example.com
# Shows all redirects in the chain

# Verify SSL/TLS certificate:
# openssl s_client -connect example.com:443 -servername example.com
# Shows certificate details, chain, and SSL/TLS version

################################################################################
# Cost Considerations
################################################################################

# HTTPS Redirection Costs:
# - HTTPS redirection itself has no additional cost beyond the load balancer
#
# Lightsail Load Balancer Pricing (as of 2025):
# - $18/month (varies slightly by region)
# - Includes:
#   * Load balancer service
#   * Up to 18 SSL/TLS certificates (managed via ACM)
#   * Health checking
#   * Session persistence
#   * HTTPS redirection
#
# SSL/TLS Certificate Costs:
# - Lightsail certificates via AWS Certificate Manager (ACM): FREE
# - No charge for certificate creation, validation, or renewal
# - Unlimited certificate renewals
#
# Data Transfer Costs:
# - Data transfer OUT from Lightsail load balancer: $0.09/GB (after free tier)
# - Data transfer IN: FREE
# - Data transfer between Lightsail instances and load balancer: FREE (in same region)
#
# Free Tier:
# - Not applicable to Lightsail load balancers (no free tier)
# - Lightsail instances may have free tier benefits
#
# Cost Optimization Tips:
# - Use a single load balancer for multiple applications/domains (up to 18 certificates)
# - Monitor data transfer and optimize application to reduce bandwidth usage
# - Consider CloudFront CDN for static content to reduce load balancer traffic
# - Use appropriate instance types for backend servers
# - Implement caching to reduce backend processing and data transfer
#
# Estimated Monthly Cost Example:
# - Load balancer: $18/month
# - 2x Lightsail instances ($10/month each): $20/month
# - Data transfer (100 GB): $9/month
# - Total: ~$47/month
#
# Cost Monitoring:
# - Use AWS Cost Explorer to track Lightsail costs
# - Set up billing alerts for unexpected cost increases
# - Review cost allocation tags regularly

################################################################################
# Compliance and Governance
################################################################################

# Security Hub Controls:
# - [ELB.1] Application Load Balancers should redirect HTTP to HTTPS
#   (This control is specific to ALB/CLB but the same principle applies to Lightsail)
# - Similar best practices apply to Lightsail load balancers
# - HTTPS redirection is considered a security best practice across all load balancers
#
# Compliance Frameworks:
#
# PCI DSS (Payment Card Industry Data Security Standard):
# - Requirement 4.1: Use strong cryptography for cardholder data in transit
# - HTTPS redirection ensures all cardholder data is encrypted
# - Required for any application handling credit card information
#
# HIPAA (Health Insurance Portability and Accountability Act):
# - 164.312(e)(1): Transmission Security
# - HTTPS redirection protects ePHI (electronic Protected Health Information) in transit
# - Required for healthcare applications
#
# GDPR (General Data Protection Regulation):
# - Article 32: Security of processing
# - Recommends encryption for personal data protection
# - HTTPS redirection helps meet this requirement
#
# SOC 2 (Service Organization Control 2):
# - CC6.6: Logical and physical access controls
# - HTTPS redirection demonstrates security controls for data in transit
#
# ISO 27001:
# - A.13.1.1: Network controls
# - HTTPS redirection is part of network security controls
#
# NIST Cybersecurity Framework:
# - PR.DS-2: Data-in-transit is protected
# - HTTPS redirection aligns with this protection requirement
#
# Policy Enforcement:
# - Use AWS Config rules to ensure HTTPS redirection is enabled
# - Monitor compliance through AWS Security Hub or similar tools
# - Implement automated remediation for non-compliant resources
# - Regular compliance audits and reviews
# - Document exceptions and obtain appropriate approvals
#
# Governance Best Practices:
# - Establish standard configurations for HTTPS redirection
# - Require approvals for disabling HTTPS redirection in production
# - Maintain audit logs of all configuration changes
# - Implement least privilege access for managing load balancers
# - Regular security assessments and penetration testing
# - Incident response procedures for security events

################################################################################
# Additional Resources
################################################################################

# AWS Documentation:
# - Lightsail Load Balancers Overview:
#   https://docs.aws.amazon.com/lightsail/latest/userguide/understanding-lightsail-load-balancers.html
# - HTTPS Redirection Configuration:
#   https://docs.aws.amazon.com/lightsail/latest/userguide/amazon-lightsail-configure-load-balancer-https-redirection.html
# - SSL/TLS Certificates:
#   https://docs.aws.amazon.com/lightsail/latest/userguide/understanding-tls-ssl-certificates-in-lightsail-https.html
# - LoadBalancer API Reference:
#   https://docs.aws.amazon.com/lightsail/2016-11-28/api-reference/API_LoadBalancer.html
#
# Terraform Documentation:
# - aws_lightsail_lb_https_redirection_policy:
#   https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lightsail_lb_https_redirection_policy
# - aws_lightsail_lb:
#   https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lightsail_lb
# - aws_lightsail_lb_certificate:
#   https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lightsail_lb_certificate
# - aws_lightsail_lb_certificate_attachment:
#   https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lightsail_lb_certificate_attachment
#
# Related Blog Posts and Guides:
# - AWS Builders Library - Ensuring rollback safety during deployments:
#   https://aws.amazon.com/builders-library/ensuring-rollback-safety-during-deployments/
# - Security Hub Controls for ELB:
#   https://docs.aws.amazon.com/securityhub/latest/userguide/elb-controls.html
