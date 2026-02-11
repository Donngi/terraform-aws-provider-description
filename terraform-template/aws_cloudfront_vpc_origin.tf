# ============================================================================
# Terraform AWS Provider - aws_cloudfront_vpc_origin
# ============================================================================
# Generated: 2026-01-18
# Provider version: 6.28.0
#
# NOTE: This template is generated based on the AWS Provider schema at the time
# of generation. Please refer to the official documentation for the most up-to-date
# specifications and additional details:
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_vpc_origin
# ============================================================================

# Amazon CloudFront VPC Origin
# Creates an Amazon CloudFront VPC origin that enables content delivery from
# applications hosted in private subnets within Amazon VPC. VPC origins provide
# a managed solution to point CloudFront distributions directly to Application
# Load Balancers (ALBs), Network Load Balancers (NLBs), or EC2 instances inside
# private subnets, making CloudFront the sole ingress point for those resources.
#
# AWS Documentation:
# https://docs.aws.amazon.com/cloudfront/latest/APIReference/API_VpcOrigin.html
resource "aws_cloudfront_vpc_origin" "example" {
  # ============================================================================
  # Optional Attributes
  # ============================================================================

  # tags - (Optional) Key-value map of resource tags
  # Tags for the CloudFront VPC origin. If configured with a provider default_tags
  # configuration block, tags with matching keys will overwrite those defined at
  # the provider-level.
  #
  # Type: map(string)
  # Default: null
  tags = {
    Name        = "example-vpc-origin"
    Environment = "production"
    ManagedBy   = "terraform"
  }

  # ============================================================================
  # Nested Blocks
  # ============================================================================

  # vpc_origin_endpoint_config - (Required) Configuration for the VPC origin endpoint
  # Defines the VPC endpoint configuration including the ARN of the resource
  # (ALB, NLB, or EC2 instance), ports, protocol policy, and SSL protocols.
  # This block is required and contains the essential settings for establishing
  # connectivity between CloudFront and the origin in the private subnet.
  #
  # AWS API Reference:
  # https://docs.aws.amazon.com/cloudfront/latest/APIReference/API_VpcOriginEndpointConfig.html
  vpc_origin_endpoint_config {
    # arn - (Required) ARN of the VPC origin resource
    # The Amazon Resource Name (ARN) of the CloudFront VPC origin endpoint
    # configuration. This must be the ARN of an Application Load Balancer (ALB),
    # Network Load Balancer (NLB), or EC2 instance that resides in a private subnet.
    #
    # Type: string
    # Example: "arn:aws:elasticloadbalancing:us-east-1:123456789012:loadbalancer/app/my-alb/50dc6c495c0c9188"
    arn = "arn:aws:elasticloadbalancing:us-east-1:123456789012:loadbalancer/app/example-alb/1234567890abcdef"

    # http_port - (Required) HTTP port for the origin endpoint
    # The HTTP port that CloudFront uses to connect to the origin. The port must
    # be open on the origin resource (ALB, NLB, or EC2 instance) to accept
    # incoming traffic from CloudFront.
    #
    # Type: number
    # Default: 80
    # Valid Range: 1-65535
    http_port = 80

    # https_port - (Required) HTTPS port for the origin endpoint
    # The HTTPS port that CloudFront uses to connect to the origin. The port must
    # be open on the origin resource to accept incoming HTTPS traffic from CloudFront.
    #
    # Type: number
    # Default: 443
    # Valid Range: 1-65535
    https_port = 443

    # name - (Required) Name of the VPC origin endpoint configuration
    # A unique name to identify this VPC origin endpoint configuration. This name
    # is used for reference within your CloudFront distribution configuration.
    #
    # Type: string
    name = "example-vpc-origin"

    # origin_protocol_policy - (Required) Protocol policy for connecting to the origin
    # Specifies the protocol policy that CloudFront uses when connecting to the
    # origin. This determines whether CloudFront uses HTTP, HTTPS, or matches the
    # viewer's protocol when fetching objects from the origin.
    #
    # Type: string
    # Valid values:
    #   - "http-only"   - CloudFront uses only HTTP to access the origin
    #   - "https-only"  - CloudFront uses only HTTPS to access the origin (recommended for security)
    #   - "match-viewer" - CloudFront communicates with the origin using the same protocol the viewer used
    origin_protocol_policy = "https-only"

    # origin_ssl_protocols - (Optional) SSL/TLS protocols for HTTPS connections
    # A complex type containing information about the SSL/TLS protocols that
    # CloudFront can use when establishing an HTTPS connection with the origin.
    # This block is only applicable when origin_protocol_policy is set to
    # "https-only" or "match-viewer".
    origin_ssl_protocols {
      # items - (Required) List of SSL/TLS protocol versions
      # The SSL/TLS protocols that CloudFront can use when establishing an HTTPS
      # connection with the origin. You should specify the protocols that your
      # origin supports.
      #
      # Type: set(string)
      # Valid values: "SSLv3", "TLSv1", "TLSv1.1", "TLSv1.2"
      # Recommended: Use only TLSv1.2 for enhanced security
      items = ["TLSv1.2"]

      # quantity - (Required) Number of SSL/TLS protocols in the items list
      # The number of SSL/TLS protocol versions specified in the items field.
      # This must match the actual number of items in the list.
      #
      # Type: number
      quantity = 1
    }
  }

  # ============================================================================
  # Timeouts Block (Optional)
  # ============================================================================
  # Configuration block for operation timeouts. Allows customization of how long
  # Terraform will wait for create, update, and delete operations to complete.
  timeouts {
    # create - (Optional) Timeout for create operations
    # Maximum time to wait for the VPC origin to be created. Time units: "s" (seconds),
    # "m" (minutes), "h" (hours).
    #
    # Type: string
    # Example: "30m", "1h", "90s"
    # create = "30m"

    # update - (Optional) Timeout for update operations
    # Maximum time to wait for the VPC origin to be updated. Time units: "s" (seconds),
    # "m" (minutes), "h" (hours).
    #
    # Type: string
    # Example: "30m", "1h", "90s"
    # update = "30m"

    # delete - (Optional) Timeout for delete operations
    # Maximum time to wait for the VPC origin to be deleted. Time units: "s" (seconds),
    # "m" (minutes), "h" (hours).
    #
    # Type: string
    # Example: "30m", "1h", "90s"
    # delete = "30m"
  }
}

# ============================================================================
# Computed Attributes (Read-only, not configurable)
# ============================================================================
# The following attributes are computed by AWS and cannot be configured:
#
# - arn       (string) - The VPC origin ARN
# - etag      (string) - The current version of the origin
# - id        (string) - The VPC origin ID
# - tags_all  (map)    - A map of tags assigned to the resource, including those
#                        inherited from the provider default_tags configuration block
#
# These can be referenced in other resources using:
#   aws_cloudfront_vpc_origin.example.arn
#   aws_cloudfront_vpc_origin.example.id
#   aws_cloudfront_vpc_origin.example.etag
# ============================================================================

# ============================================================================
# Usage Example with CloudFront Distribution
# ============================================================================
# After creating a VPC origin, you can reference it in a CloudFront distribution:
#
# resource "aws_cloudfront_distribution" "example" {
#   enabled = true
#
#   origin {
#     domain_name = "example.com"
#     origin_id   = aws_cloudfront_vpc_origin.example.id
#
#     vpc_origin_config {
#       vpc_origin_id = aws_cloudfront_vpc_origin.example.id
#       origin_keepalive_timeout = 5
#       origin_read_timeout      = 30
#     }
#   }
#
#   default_cache_behavior {
#     allowed_methods        = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
#     cached_methods         = ["GET", "HEAD"]
#     target_origin_id       = aws_cloudfront_vpc_origin.example.id
#     viewer_protocol_policy = "redirect-to-https"
#
#     forwarded_values {
#       query_string = false
#       cookies {
#         forward = "none"
#       }
#     }
#   }
#
#   restrictions {
#     geo_restriction {
#       restriction_type = "none"
#     }
#   }
#
#   viewer_certificate {
#     cloudfront_default_certificate = true
#   }
# }
# ============================================================================
