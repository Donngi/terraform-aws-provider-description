################################################################################
# AWS Provider Version: 6.28.0
# Resource: aws_s3_bucket_cors_configuration
# Documentation: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/s3_bucket_cors_configuration
################################################################################

# Overview:
# Provides an S3 bucket CORS configuration resource for enabling Cross-Origin
# Resource Sharing (CORS). CORS allows client web applications loaded in one
# domain to interact with resources in a different domain.
#
# Important Notes:
# - S3 Buckets only support a single CORS configuration
# - Declaring multiple aws_s3_bucket_cors_configuration resources to the same
#   S3 Bucket will cause a perpetual difference in configuration
# - This resource cannot be used with S3 directory buckets
# - You can configure up to 100 CORS rules per bucket

resource "aws_s3_bucket_cors_configuration" "example" {
  ################################################################################
  # Required Arguments
  ################################################################################

  # (Required, Forces new resource) Name of the S3 bucket
  # Type: string
  # Example: "my-bucket-name"
  # Note: Changing this forces a new resource to be created
  bucket = "my-bucket-name"

  ################################################################################
  # Optional Arguments
  ################################################################################

  # (Optional, Forces new resource) Account ID of the expected bucket owner
  # Type: string
  # Default: null
  # Use Case: Validates that the bucket belongs to the expected AWS account
  # Note: Changing this forces a new resource to be created
  # expected_bucket_owner = "123456789012"

  # (Optional) AWS region where this resource will be managed
  # Type: string
  # Default: Inherited from provider configuration
  # Reference: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  ################################################################################
  # CORS Rule Configuration (Required Block)
  # Min Items: 1, Max Items: 100
  ################################################################################

  # CORS Rule Example 1: Full configuration with all optional fields
  # Use Case: Allow PUT and POST requests from specific origins with custom headers
  cors_rule {
    # (Optional) Unique identifier for the rule
    # Type: string
    # Maximum Length: 255 characters
    # Use Case: Helps identify and manage specific rules
    id = "rule-1"

    # (Required) Set of HTTP methods that you allow the origin to execute
    # Type: set(string)
    # Valid Values: "GET", "PUT", "HEAD", "POST", "DELETE"
    # Example: Allow file uploads and form submissions
    allowed_methods = ["PUT", "POST"]

    # (Required) Set of origins you want customers to be able to access the bucket from
    # Type: set(string)
    # Format: Must include the protocol (http:// or https://)
    # Special Value: "*" allows all origins (use with caution for security)
    # Example: Specific domain with HTTPS
    allowed_origins = ["https://s3-website-test.example.com"]

    # (Optional) Set of headers that are specified in the Access-Control-Request-Headers header
    # Type: set(string)
    # Default: null
    # Use Case: Specifies which headers are allowed in preflight OPTIONS requests
    # Special Value: "*" allows all headers
    # Common Headers: "Content-Type", "Authorization", "X-Custom-Header"
    allowed_headers = ["*"]

    # (Optional) Set of headers in the response that you want customers to be able to access
    # Type: set(string)
    # Default: null
    # Use Case: Exposes specific response headers to client applications (e.g., JavaScript XMLHttpRequest)
    # Common Headers: "ETag", "Content-Length", "x-amz-request-id"
    expose_headers = ["ETag"]

    # (Optional) Time in seconds that your browser is to cache the preflight response
    # Type: number
    # Default: null
    # Range: 0 to 2147483647 seconds
    # Use Case: Reduces the number of preflight OPTIONS requests by caching the result
    # Recommendation: 3000 seconds (50 minutes) is a common value
    max_age_seconds = 3000
  }

  # CORS Rule Example 2: Minimal configuration for public read access
  # Use Case: Allow GET requests from any origin (public website assets)
  cors_rule {
    # (Required) Allow only GET method for retrieving objects
    allowed_methods = ["GET"]

    # (Required) Allow access from any origin
    # Security Note: "*" should only be used for truly public resources
    allowed_origins = ["*"]
  }

  # CORS Rule Example 3: Specific domain with HEAD method
  # Use Case: Allow checking object metadata without downloading
  # cors_rule {
  #   id              = "rule-3"
  #   allowed_methods = ["GET", "HEAD"]
  #   allowed_origins = ["https://www.example.com"]
  #   max_age_seconds = 1800
  # }

  # CORS Rule Example 4: Multiple origins with DELETE method
  # Use Case: Allow multiple trusted domains to delete objects
  # cors_rule {
  #   id              = "rule-4"
  #   allowed_methods = ["DELETE"]
  #   allowed_origins = [
  #     "https://app1.example.com",
  #     "https://app2.example.com"
  #   ]
  #   allowed_headers = ["Authorization"]
  #   max_age_seconds = 600
  # }
}

################################################################################
# Attributes Reference
################################################################################

# id - The bucket name or bucket name and expected_bucket_owner separated by
#      a comma (,) if the latter is provided
# Example Output: "my-bucket-name" or "my-bucket-name,123456789012"

################################################################################
# Import
################################################################################

# CORS configuration can be imported using the bucket name:
# terraform import aws_s3_bucket_cors_configuration.example my-bucket-name
#
# If expected_bucket_owner is provided, use comma-separated format:
# terraform import aws_s3_bucket_cors_configuration.example my-bucket-name,123456789012

################################################################################
# Common Use Cases & Best Practices
################################################################################

# 1. Static Website Hosting with API Access
#    - Allow GET for website assets
#    - Allow POST/PUT for API endpoints
#    - Specify exact origins for security
#
# 2. File Upload Applications
#    - Allow PUT/POST methods
#    - Set appropriate allowed_headers for Content-Type
#    - Use expose_headers to return ETag for validation
#
# 3. Public CDN Distribution
#    - Allow GET/HEAD from "*" for public content
#    - Consider caching with max_age_seconds
#
# 4. Multi-Region Applications
#    - Allow origins from all regional domains
#    - Use max_age_seconds to reduce preflight requests
#
# 5. Security Considerations
#    - Avoid using "*" for allowed_origins in production unless truly public
#    - Minimize allowed_methods to only what's necessary
#    - Use specific allowed_headers instead of "*" when possible
#    - Set max_age_seconds appropriately based on how often rules change

################################################################################
# Related AWS Documentation
################################################################################

# - CORS Overview: https://docs.aws.amazon.com/AmazonS3/latest/userguide/cors.html
# - CORS Configuration Elements: https://docs.aws.amazon.com/AmazonS3/latest/userguide/ManageCorsUsing.html
# - Configuring CORS Examples: https://docs.aws.amazon.com/AmazonS3/latest/userguide/enabling-cors-examples.html
# - PutBucketCors API: https://docs.aws.amazon.com/AmazonS3/latest/API/API_PutBucketCors.html

################################################################################
# CORS Preflight Request Flow
################################################################################

# When a browser makes a cross-origin request, it follows this flow:
#
# 1. Browser sends OPTIONS request (preflight) to S3
#    - Includes Origin header with requesting domain
#    - Includes Access-Control-Request-Method header with actual method to use
#    - Includes Access-Control-Request-Headers if custom headers will be sent
#
# 2. S3 evaluates CORS rules in order
#    - Checks if Origin matches allowed_origins
#    - Checks if method matches allowed_methods
#    - Checks if headers match allowed_headers
#
# 3. S3 responds with CORS headers
#    - Access-Control-Allow-Origin: Matched origin or "*"
#    - Access-Control-Allow-Methods: Allowed methods
#    - Access-Control-Allow-Headers: Allowed headers
#    - Access-Control-Max-Age: Cache duration
#    - Access-Control-Expose-Headers: Exposed headers
#
# 4. Browser caches the response for max_age_seconds
#    - Subsequent requests from same origin skip preflight during cache period
#
# 5. Browser makes the actual request
#    - If CORS validation passed, browser allows JavaScript to access response

################################################################################
# Terraform Configuration Examples
################################################################################

# Example: Complete setup with bucket and CORS configuration
#
# resource "aws_s3_bucket" "example" {
#   bucket = "my-cors-enabled-bucket"
# }
#
# resource "aws_s3_bucket_cors_configuration" "example" {
#   bucket = aws_s3_bucket.example.id
#
#   cors_rule {
#     allowed_methods = ["GET", "HEAD"]
#     allowed_origins = ["https://www.example.com"]
#   }
# }
#
# resource "aws_s3_bucket_public_access_block" "example" {
#   bucket = aws_s3_bucket.example.id
#
#   block_public_acls       = false
#   block_public_policy     = false
#   ignore_public_acls      = false
#   restrict_public_buckets = false
# }

################################################################################
# Validation Rules
################################################################################

# - bucket: Must be a valid S3 bucket name
# - cors_rule: At least 1 rule required, maximum 100 rules allowed
# - allowed_methods: At least 1 method required per rule
# - allowed_origins: At least 1 origin required per rule
# - max_age_seconds: Must be between 0 and 2147483647 if specified
# - id (in cors_rule): Maximum 255 characters if specified
