# ============================================================================
# CloudFront Response Headers Policy - Annotated Template
# ============================================================================
# Generated: 2026-01-18
# Provider version: 6.28.0
# Resource: aws_cloudfront_response_headers_policy
#
# This template includes all configurable properties available in the schema.
# Adjust values according to your requirements and remove unused optional blocks.
# Always refer to the latest official documentation for the most current specifications.
#
# Official Documentation:
# https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/creating-response-headers-policies.html
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_response_headers_policy
# ============================================================================

resource "aws_cloudfront_response_headers_policy" "example" {
  # ============================================================================
  # Required Attributes
  # ============================================================================

  # name - (Required) A unique name to identify the response headers policy.
  # The name must be unique within your AWS account.
  # Reference: https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/creating-response-headers-policies.html
  name = "example-response-headers-policy"

  # ============================================================================
  # Optional Attributes
  # ============================================================================

  # comment - (Optional) A comment to describe the response headers policy.
  # Maximum length: 128 characters
  # Use this to provide context about the policy's purpose or usage.
  comment = "Example response headers policy with CORS and security headers"

  # ============================================================================
  # CORS Configuration
  # ============================================================================
  # cors_config - (Optional) A configuration for Cross-Origin Resource Sharing (CORS) headers.
  # CloudFront adds these headers to HTTP responses for CORS requests that match a cache behavior
  # associated with this policy.
  # Reference: https://docs.aws.amazon.com/cloudfront/latest/APIReference/API_ResponseHeadersPolicyCorsConfig.html
  # Blog: https://aws.amazon.com/blogs/networking-and-content-delivery/cors-configuration-through-amazon-cloudfront/

  cors_config {
    # access_control_allow_credentials - (Required) A Boolean value that CloudFront uses as the value
    # for the Access-Control-Allow-Credentials HTTP response header.
    # Set to true to allow credentials (cookies, authorization headers, or TLS client certificates)
    # to be included in CORS requests.
    access_control_allow_credentials = true

    # origin_override - (Required) A Boolean value that determines how CloudFront behaves for the
    # HTTP response header.
    # - true: CloudFront overrides the header received from the origin with the values specified here
    # - false: CloudFront uses the header from the origin if present
    origin_override = true

    # access_control_max_age_sec - (Optional) A number that CloudFront uses as the value for the
    # Access-Control-Max-Age HTTP response header.
    # This specifies how long (in seconds) the results of a preflight request can be cached.
    # Typical values range from 600 (10 minutes) to 86400 (24 hours).
    access_control_max_age_sec = 3600

    # access_control_allow_headers - (Required) Object that contains HTTP header names that CloudFront
    # includes as values for the Access-Control-Allow-Headers HTTP response header.
    # These are the headers that the client is allowed to send in the actual request.
    access_control_allow_headers {
      items = [
        "Authorization",
        "Content-Type",
        "X-Requested-With",
        "X-Custom-Header"
      ]
    }

    # access_control_allow_methods - (Required) Object that contains HTTP methods that CloudFront
    # includes as values for the Access-Control-Allow-Methods HTTP response header.
    # Valid values: GET, POST, OPTIONS, PUT, DELETE, HEAD, ALL
    access_control_allow_methods {
      items = [
        "GET",
        "POST",
        "OPTIONS",
        "PUT",
        "DELETE"
      ]
    }

    # access_control_allow_origins - (Required) Object that contains origins that CloudFront can use
    # as the value for the Access-Control-Allow-Origin HTTP response header.
    # Specify the domains that are allowed to make CORS requests.
    # Use "*" to allow all origins (not recommended for production with credentials).
    access_control_allow_origins {
      items = [
        "https://example.com",
        "https://www.example.com"
      ]
    }

    # access_control_expose_headers - (Optional) Object that contains HTTP headers that CloudFront
    # includes as values for the Access-Control-Expose-Headers HTTP response header.
    # These headers will be exposed to the client JavaScript in CORS requests.
    access_control_expose_headers {
      items = [
        "ETag",
        "X-Custom-Response-Header"
      ]
    }
  }

  # ============================================================================
  # Custom Headers Configuration
  # ============================================================================
  # custom_headers_config - (Optional) Object that contains custom headers to add to HTTP responses.
  # Use this to add any custom HTTP headers that are not covered by security or CORS configurations.
  # Reference: https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/creating-response-headers-policies.html

  custom_headers_config {
    # items - Multiple custom header blocks can be specified
    # Each item represents a custom header to add to the response

    items {
      # header - (Required) The HTTP response header name
      header = "X-Permitted-Cross-Domain-Policies"

      # override - (Required) Whether CloudFront overrides a response header with the same name
      # received from the origin with the header specified here.
      override = true

      # value - (Required) The value for the HTTP response header
      value = "none"
    }

    items {
      header   = "X-Custom-Application-Header"
      override = false
      value    = "custom-value"
    }
  }

  # ============================================================================
  # Remove Headers Configuration
  # ============================================================================
  # remove_headers_config - (Optional) A configuration for removing HTTP headers from responses.
  # CloudFront removes these headers from HTTP responses before sending them to viewers.
  # Common use case: removing Set-Cookie headers to improve cache hit ratio.
  # Reference: https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/creating-response-headers-policies.html

  remove_headers_config {
    # items - Multiple remove header blocks can be specified

    items {
      # header - (Required) The HTTP header name to remove from responses
      header = "Server"
    }

    items {
      header = "X-Powered-By"
    }
  }

  # ============================================================================
  # Security Headers Configuration
  # ============================================================================
  # security_headers_config - (Optional) A configuration for security-related HTTP response headers.
  # These headers help protect against common web vulnerabilities.
  # Reference: https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/creating-response-headers-policies.html

  security_headers_config {

    # --------------------------------------------------------------------------
    # Content Security Policy (CSP)
    # --------------------------------------------------------------------------
    # content_security_policy - (Optional) Configuration for the Content-Security-Policy header.
    # CSP helps prevent XSS attacks by controlling which resources can be loaded.
    # Reference: https://developer.mozilla.org/en-US/docs/Web/HTTP/CSP

    content_security_policy {
      # content_security_policy - (Required) The policy directives and their values
      # Define allowed sources for scripts, styles, images, etc.
      content_security_policy = "default-src 'self'; script-src 'self' 'unsafe-inline'; style-src 'self' 'unsafe-inline'; img-src 'self' data: https:; font-src 'self' data:;"

      # override - (Required) Whether CloudFront overrides the Content-Security-Policy header
      # received from the origin
      override = true
    }

    # --------------------------------------------------------------------------
    # Content Type Options
    # --------------------------------------------------------------------------
    # content_type_options - (Optional) Determines whether CloudFront includes the
    # X-Content-Type-Options HTTP response header with its value set to "nosniff".
    # This prevents MIME type sniffing and forces browsers to respect the declared content type.
    # Reference: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-Content-Type-Options

    content_type_options {
      # override - (Required) Whether CloudFront overrides the X-Content-Type-Options header
      # received from the origin
      override = true
    }

    # --------------------------------------------------------------------------
    # Frame Options
    # --------------------------------------------------------------------------
    # frame_options - (Optional) Configuration for the X-Frame-Options header.
    # Protects against clickjacking attacks by controlling whether the page can be displayed in a frame.
    # Reference: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-Frame-Options

    frame_options {
      # frame_option - (Required) The value of the X-Frame-Options HTTP response header
      # Valid values:
      # - DENY: The page cannot be displayed in a frame
      # - SAMEORIGIN: The page can only be displayed in a frame on the same origin
      frame_option = "DENY"

      # override - (Required) Whether CloudFront overrides the X-Frame-Options header
      # received from the origin
      override = true
    }

    # --------------------------------------------------------------------------
    # Referrer Policy
    # --------------------------------------------------------------------------
    # referrer_policy - (Optional) Configuration for the Referrer-Policy header.
    # Controls how much referrer information is included with requests.
    # Reference: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Referrer-Policy

    referrer_policy {
      # referrer_policy - (Required) The value of the Referrer-Policy HTTP response header
      # Valid values:
      # - no-referrer: Never send the Referer header
      # - no-referrer-when-downgrade: Send referrer to HTTPS destinations only (default)
      # - origin: Send only the origin (scheme, host, port)
      # - origin-when-cross-origin: Send full URL for same-origin, origin only for cross-origin
      # - same-origin: Send referrer for same-origin requests only
      # - strict-origin: Send origin only, and only to HTTPS destinations
      # - strict-origin-when-cross-origin: Full URL for same-origin, origin for cross-origin HTTPS
      # - unsafe-url: Always send full URL (not recommended)
      referrer_policy = "strict-origin-when-cross-origin"

      # override - (Required) Whether CloudFront overrides the Referrer-Policy header
      # received from the origin
      override = true
    }

    # --------------------------------------------------------------------------
    # Strict Transport Security (HSTS)
    # --------------------------------------------------------------------------
    # strict_transport_security - (Optional) Configuration for the Strict-Transport-Security header.
    # Forces browsers to use HTTPS for all future requests to the domain.
    # Reference: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Strict-Transport-Security

    strict_transport_security {
      # access_control_max_age_sec - (Required) A number that CloudFront uses as the value for
      # the max-age directive in the Strict-Transport-Security HTTP response header.
      # Specifies how long (in seconds) browsers should remember that this site is HTTPS only.
      # Common values: 31536000 (1 year), 63072000 (2 years)
      access_control_max_age_sec = 31536000

      # include_subdomains - (Optional) Whether CloudFront includes the includeSubDomains directive
      # in the Strict-Transport-Security header.
      # Set to true to apply HSTS to all subdomains.
      include_subdomains = true

      # preload - (Optional) Whether CloudFront includes the preload directive in the
      # Strict-Transport-Security header.
      # Set to true if you want to submit your site to the HSTS preload list.
      # WARNING: This is a commitment to maintain HTTPS for your domain indefinitely.
      preload = false

      # override - (Required) Whether CloudFront overrides the Strict-Transport-Security header
      # received from the origin
      override = true
    }

    # --------------------------------------------------------------------------
    # XSS Protection
    # --------------------------------------------------------------------------
    # xss_protection - (Optional) Configuration for the X-XSS-Protection header.
    # Enables the browser's XSS filtering and prevents rendering if an attack is detected.
    # Note: This header is largely deprecated in favor of Content-Security-Policy.
    # Reference: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-XSS-Protection

    xss_protection {
      # protection - (Required) A Boolean value that determines the value of the X-XSS-Protection header.
      # - true: X-XSS-Protection header value is "1" (XSS filtering enabled)
      # - false: X-XSS-Protection header value is "0" (XSS filtering disabled)
      protection = true

      # mode_block - (Optional) Whether CloudFront includes the mode=block directive in the
      # X-XSS-Protection header.
      # When true, the browser will block the page from rendering if an XSS attack is detected.
      mode_block = true

      # override - (Required) Whether CloudFront overrides the X-XSS-Protection header
      # received from the origin
      override = true

      # report_uri - (Optional) A reporting URI that CloudFront uses as the value of the
      # report directive in the X-XSS-Protection header.
      # NOTE: You cannot specify report_uri when mode_block is true.
      # report_uri = "https://example.com/xss-report"
    }
  }

  # ============================================================================
  # Server Timing Headers Configuration
  # ============================================================================
  # server_timing_headers_config - (Optional) Configuration for enabling the Server-Timing header.
  # The Server-Timing header provides server performance metrics that can be viewed in browser
  # developer tools. Useful for debugging and performance monitoring.
  # Reference: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Server-Timing

  server_timing_headers_config {
    # enabled - (Required) Whether CloudFront adds the Server-Timing header to HTTP responses
    # for requests that match a cache behavior associated with this policy.
    enabled = true

    # sampling_rate - (Required) A number 0-100 (inclusive) that specifies the percentage of
    # responses that you want CloudFront to add the Server-Timing header to.
    # Use this to sample a subset of requests to reduce overhead.
    # - 100.0: Add header to all responses
    # - 1.0: Add header to 1% of responses
    # Valid range: 0.0 to 100.0
    sampling_rate = 50.0
  }
}

# ============================================================================
# Computed Attributes (Read-only, automatically set by AWS)
# ============================================================================
# The following attributes are computed and cannot be configured:
#
# - arn: The Amazon Resource Name (ARN) of the response headers policy
#        Format: arn:aws:cloudfront::account-id:response-headers-policy/policy-id
#
# - etag: The current version of the response headers policy
#         Used for optimistic concurrency control when updating the policy
#
# - id: The unique identifier for the response headers policy
#       This ID is used to attach the policy to cache behaviors in CloudFront distributions
#
# These can be referenced in other resources using:
#   aws_cloudfront_response_headers_policy.example.arn
#   aws_cloudfront_response_headers_policy.example.etag
#   aws_cloudfront_response_headers_policy.example.id
# ============================================================================

# ============================================================================
# Usage Notes
# ============================================================================
# 1. After creating a response headers policy, attach it to cache behaviors in a
#    CloudFront distribution using the response_headers_policy_id attribute.
#
# 2. CloudFront provides managed response headers policies for common use cases:
#    - CORS-and-SecurityHeadersPolicy
#    - CORS-With-Preflight
#    - CORS-with-preflight-and-SecurityHeadersPolicy
#    - SecurityHeadersPolicy
#    - SimpleCORS
#    Reference: https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/using-managed-response-headers-policies.html
#
# 3. You can configure CORS headers, security headers, custom headers, or any combination.
#    All configuration blocks (cors_config, security_headers_config, etc.) are optional.
#
# 4. When using CORS with credentials (access_control_allow_credentials = true),
#    you cannot use "*" in access_control_allow_origins. Specific origins must be listed.
#
# 5. The response headers policy does not modify the origin's response body, only headers.
#
# 6. Changes to the policy are automatically propagated to all associated cache behaviors
#    in CloudFront distributions.
# ============================================================================
