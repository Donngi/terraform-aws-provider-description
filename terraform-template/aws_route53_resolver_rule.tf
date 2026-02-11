################################################################################
# Route 53 Resolver Rule
################################################################################
# Provides a Route53 Resolver rule for forwarding DNS queries between your VPCs
# and your on-premises network. Route 53 Resolver evaluates queries through
# forwarding rules and system rules to determine how to resolve DNS queries.
#
# Documentation:
# - AWS Provider: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_resolver_rule
# - AWS API: https://docs.aws.amazon.com/Route53/latest/APIReference/API_route53resolver_CreateResolverRule.html
# - AWS Service: https://aws.amazon.com/route53/resolver/
################################################################################

resource "aws_route53_resolver_rule" "this" {
  #============================================================================
  # Required Arguments
  #============================================================================

  # (Required) DNS queries for this domain name are forwarded to the IP addresses
  # that are specified using target_ip.
  # Example: "example.com", "subdomain.example.com"
  domain_name = "example.com"

  # (Required) Rule type. Valid values are:
  # - FORWARD: Forward DNS queries to the IP addresses specified in target_ip
  # - SYSTEM: Selectively override the behavior defined in a FORWARD rule
  # - RECURSIVE: Route 53 Resolver performs recursive DNS lookups for this domain
  # - DELEGATE: Delegate resolution to the authoritative nameservers
  rule_type = "FORWARD"

  #============================================================================
  # Optional Arguments
  #============================================================================

  # (Optional) Friendly name that lets you easily find a rule in the Resolver
  # dashboard in the Route 53 console.
  # - Maximum 64 characters
  # - Can contain letters, numbers, hyphens, underscores, and spaces
  # - Cannot consist of only numbers
  name = null

  # (Optional) Region where this resource will be managed.
  # Defaults to the Region set in the provider configuration.
  # Reference: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  # (Optional) ID of the outbound Resolver endpoint to use for forwarding DNS
  # queries to the specified IP addresses.
  # This is required for FORWARD rule type.
  # Example: aws_route53_resolver_endpoint.foo.id
  resolver_endpoint_id = null

  # (Optional) Map of tags to assign to the resource.
  # If configured with a provider default_tags configuration block, tags with
  # matching keys will overwrite those defined at the provider-level.
  tags = {
    Name        = "example-resolver-rule"
    Environment = "production"
  }

  #============================================================================
  # Nested Blocks
  #============================================================================

  # (Optional) Configuration block(s) indicating the IPs that you want Resolver
  # to forward DNS queries to.
  # This argument should only be specified for FORWARD type rules.
  # You can specify multiple target_ip blocks for redundancy.
  target_ip {
    # (Optional) One IPv4 address that you want to forward DNS queries to.
    # Either ip or ipv6 must be specified, but not both.
    ip = "123.45.67.89"

    # (Optional) One IPv6 address that you want to forward DNS queries to.
    # Either ip or ipv6 must be specified, but not both.
    # Example: "2600:1f18:1686:2000:4e60:6e3e:258:da36"
    ipv6 = null

    # (Optional) Port at ip/ipv6 that you want to forward DNS queries to.
    # Default value is 53.
    port = 53

    # (Optional) Protocol for the resolver endpoint.
    # Valid values can be found in the AWS documentation:
    # https://docs.aws.amazon.com/Route53/latest/APIReference/API_route53resolver_TargetAddress.html
    # Default value is "Do53" (DNS over port 53).
    # Other options include "DoH" (DNS over HTTPS) and "DoH-FIPS".
    protocol = "Do53"
  }

  # Example: Additional target IP for redundancy
  # target_ip {
  #   ip       = "123.45.67.90"
  #   port     = 53
  #   protocol = "Do53"
  # }

  # (Optional) Timeout configuration for resource operations
  # timeouts {
  #   create = "10m"
  #   update = "10m"
  #   delete = "10m"
  # }
}

################################################################################
# Computed Attributes (Available after apply)
################################################################################
# These attributes are exported and can be referenced in other resources:
#
# - id: ID of the resolver rule
#   Example: aws_route53_resolver_rule.this.id
#
# - arn: ARN (Amazon Resource Name) for the resolver rule
#   Example: arn:aws:route53resolver:us-east-1:123456789012:resolver-rule/rslvr-rr-0123456789abcdef0
#
# - owner_id: When a rule is shared with another AWS account, the account ID
#   of the account that the rule is shared with
#
# - share_status: Whether the rule is shared and, if so, whether the current
#   account is sharing the rule with another account, or another account is
#   sharing the rule with the current account
#   Values: NOT_SHARED, SHARED_BY_ME, or SHARED_WITH_ME
#
# - tags_all: Map of tags assigned to the resource, including those inherited
#   from the provider default_tags configuration block
################################################################################

################################################################################
# Example Configurations
################################################################################

# Example 1: System Rule
# Use SYSTEM rule to selectively override the behavior defined in a FORWARD rule
# resource "aws_route53_resolver_rule" "system" {
#   domain_name = "subdomain.example.com"
#   rule_type   = "SYSTEM"
# }

# Example 2: Forward Rule with IPv4
# resource "aws_route53_resolver_rule" "forward_ipv4" {
#   domain_name          = "example.com"
#   name                 = "example-forward"
#   rule_type            = "FORWARD"
#   resolver_endpoint_id = aws_route53_resolver_endpoint.outbound.id
#
#   target_ip {
#     ip = "123.45.67.89"
#   }
#
#   target_ip {
#     ip = "123.45.67.90"
#   }
#
#   tags = {
#     Environment = "production"
#   }
# }

# Example 3: Forward Rule with IPv6
# resource "aws_route53_resolver_rule" "forward_ipv6" {
#   domain_name          = "example.com"
#   name                 = "example-forward-ipv6"
#   rule_type            = "FORWARD"
#   resolver_endpoint_id = aws_route53_resolver_endpoint.outbound.id
#
#   target_ip {
#     ipv6 = "2600:1f18:1686:2000:4e60:6e3e:258:da36"
#   }
#
#   tags = {
#     Environment = "production"
#   }
# }

# Example 4: Recursive Rule
# Route 53 Resolver performs recursive DNS lookups for this domain
# resource "aws_route53_resolver_rule" "recursive" {
#   domain_name = "recursive.example.com"
#   rule_type   = "RECURSIVE"
#   name        = "recursive-rule"
# }

################################################################################
# Best Practices and Notes
################################################################################
# 1. Rule Types:
#    - Use FORWARD for queries that should be sent to on-premises DNS servers
#    - Use SYSTEM to create exceptions to FORWARD rules
#    - Use RECURSIVE for standard Route 53 Resolver recursive DNS lookups
#    - Use DELEGATE to delegate resolution to authoritative nameservers
#
# 2. Target IPs:
#    - Only specify target_ip for FORWARD rule types
#    - Always configure multiple target IPs for high availability
#    - Default port is 53, but can be customized if needed
#
# 3. Domain Names:
#    - Can be a fully qualified domain name (FQDN) or a wildcard
#    - More specific rules take precedence over less specific rules
#
# 4. Sharing Rules:
#    - Rules can be shared across AWS accounts using AWS RAM
#    - Check share_status attribute to determine sharing state
#
# 5. Protocol Options:
#    - Do53: Standard DNS over port 53 (default)
#    - DoH: DNS over HTTPS
#    - DoH-FIPS: DNS over HTTPS with FIPS compliance
#
# 6. Association:
#    - After creating a rule, associate it with VPCs using
#      aws_route53_resolver_rule_association resource
#
# 7. Monitoring:
#    - Use Route 53 Resolver query logs to monitor DNS traffic
#    - Configure CloudWatch metrics for resolver endpoints
################################################################################
