# ==============================================================================
# Terraform AWS Provider - aws_cloudfront_function
# ==============================================================================
# Generated: 2026-01-18
# Provider Version: 6.28.0
#
# NOTE: This template is generated based on the provider version at the time of
# creation. Always refer to the official documentation for the latest specifications:
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_function
# ==============================================================================

# ------------------------------------------------------------------------------
# CloudFront Function Resource
# ------------------------------------------------------------------------------
# Provides a CloudFront Function resource. With CloudFront Functions in Amazon
# CloudFront, you can write lightweight functions in JavaScript for high-scale,
# latency-sensitive CDN customizations.
#
# CloudFront Functions are ideal for simple, quick transformations at the edge,
# such as HTTP header manipulation, URL rewrites, and simple authorization checks.
#
# Official Documentation:
# - CloudFront Functions: https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/cloudfront-functions.html
# - API Reference: https://docs.aws.amazon.com/cloudfront/latest/APIReference/API_FunctionConfig.html
#
# IMPORTANT: You cannot delete a function if it's associated with a cache behavior.
# First, update your distributions to remove the function association from all
# cache behaviors, then delete the function.
# ------------------------------------------------------------------------------

resource "aws_cloudfront_function" "example" {
  # --------------------------------------------------------------------------
  # Required Arguments
  # --------------------------------------------------------------------------

  # name - (Required) Unique name for your CloudFront Function.
  # The function name must be unique within your AWS account.
  # Type: string
  # Example: "my-cloudfront-function"
  name = "example-function"

  # code - (Required) Source code of the function.
  # This is the JavaScript code that will be executed at CloudFront edge locations.
  # The function code must be compatible with the specified runtime version.
  # You can use the file() function to load code from an external file.
  # Type: string
  # Example: file("${path.module}/function.js")
  # Reference: https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/writing-function-code.html
  code = file("${path.module}/function.js")

  # runtime - (Required) Identifier of the function's runtime.
  # Specifies the JavaScript runtime environment version for the function.
  # The runtime determines which JavaScript features and APIs are available.
  #
  # Valid values:
  # - "cloudfront-js-1.0": JavaScript runtime 1.0 (based on ECMAScript 5.1)
  # - "cloudfront-js-2.0": JavaScript runtime 2.0 (recommended, includes additional
  #   features like Buffer module and Key Value Store support)
  #
  # Type: string
  # Note: To use Key Value Store associations, you must use "cloudfront-js-2.0"
  # Reference: https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/functions-javascript-runtime-features.html
  runtime = "cloudfront-js-2.0"

  # --------------------------------------------------------------------------
  # Optional Arguments
  # --------------------------------------------------------------------------

  # comment - (Optional) Comment describing the function.
  # This is a human-readable description of what the function does.
  # Maximum length: 128 characters
  # Type: string
  # Example: "Redirect users based on geolocation"
  comment = "Example CloudFront Function"

  # publish - (Optional) Whether to publish creation/change as Live CloudFront
  # Function Version.
  #
  # When set to true, the function is automatically published to the LIVE stage
  # after creation or update. When false, the function remains in the DEVELOPMENT
  # stage, allowing you to test it before publishing.
  #
  # Type: bool
  # Default: true
  #
  # Stages:
  # - DEVELOPMENT: Test stage where you can validate function behavior
  # - LIVE: Production stage where the function can be associated with distributions
  #
  # Note: Only LIVE stage functions can be associated with CloudFront distributions.
  publish = true

  # key_value_store_associations - (Optional) List of aws_cloudfront_key_value_store
  # ARNs to be associated with the function.
  #
  # CloudFront KeyValueStore is a secure, global, low-latency key-value datastore
  # that enables advanced customizable logic at CloudFront edge locations. It allows
  # you to update data without deploying code changes.
  #
  # Type: set(string)
  # AWS Limitations: Maximum of one key value store per function
  #
  # Requirements:
  # - The function must use JavaScript runtime 2.0 (cloudfront-js-2.0)
  # - The same key value store can be associated with multiple functions
  # - A function can have only one key value store association
  #
  # Use Cases:
  # - URL rewrites or redirects based on dynamic data
  # - A/B testing and feature flags
  # - Access authorization with frequently updated rules
  #
  # Example: ["arn:aws:cloudfront::123456789012:key-value-store/example-kvs"]
  # Reference: https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/kvs-with-functions.html
  key_value_store_associations = []

  # --------------------------------------------------------------------------
  # Computed Attributes (Read-Only)
  # --------------------------------------------------------------------------
  # These attributes are automatically computed by AWS and cannot be set directly:
  #
  # - arn: Amazon Resource Name (ARN) identifying your CloudFront Function
  #   Type: string
  #
  # - etag: ETag hash of the function for the DEVELOPMENT stage
  #   Type: string
  #   Use: For conditional updates and versioning
  #
  # - live_stage_etag: ETag hash of the LIVE stage of the function
  #   Type: string
  #   Use: For tracking published version changes
  #
  # - status: Status of the function
  #   Type: string
  #   Possible values:
  #   - "UNPUBLISHED": Function exists only in DEVELOPMENT stage
  #   - "UNASSOCIATED": Function is published but not associated with any distribution
  #   - "ASSOCIATED": Function is published and associated with one or more distributions
  #
  # - id: Unique identifier for the function (typically the function name)
  #   Type: string
  # --------------------------------------------------------------------------
}

# ------------------------------------------------------------------------------
# Example: Basic CloudFront Function
# ------------------------------------------------------------------------------
# This example demonstrates a minimal CloudFront Function configuration that
# adds a custom header to all responses.
# ------------------------------------------------------------------------------

# Example function code (save as function.js):
# function handler(event) {
#     var response = event.response;
#     var headers = response.headers;
#
#     // Add custom header
#     headers['x-custom-header'] = { value: 'Custom Value' };
#
#     return response;
# }

# ------------------------------------------------------------------------------
# Example: CloudFront Function with Key Value Store
# ------------------------------------------------------------------------------
# This example shows how to use a CloudFront Function with a Key Value Store
# for dynamic URL rewrites.
# ------------------------------------------------------------------------------

# resource "aws_cloudfront_key_value_store" "example" {
#   name    = "example-kvs"
#   comment = "Example Key Value Store for URL rewrites"
# }
#
# resource "aws_cloudfront_function" "with_kvs" {
#   name    = "url-rewrite-function"
#   runtime = "cloudfront-js-2.0"  # Required for Key Value Store
#   comment = "Rewrites URLs based on Key Value Store data"
#   publish = true
#   code    = file("${path.module}/rewrite-function.js")
#
#   key_value_store_associations = [
#     aws_cloudfront_key_value_store.example.arn
#   ]
# }

# Example function code with KVS (save as rewrite-function.js):
# import cf from 'cloudfront';
#
# const kvsHandle = cf.kvs();
#
# async function handler(event) {
#     const request = event.request;
#     const uri = request.uri;
#
#     // Get rewrite path from Key Value Store
#     const newPath = await kvsHandle.get(uri);
#
#     if (newPath) {
#         request.uri = newPath;
#     }
#
#     return request;
# }

# ------------------------------------------------------------------------------
# Output Examples
# ------------------------------------------------------------------------------

# output "function_arn" {
#   description = "ARN of the CloudFront Function"
#   value       = aws_cloudfront_function.example.arn
# }
#
# output "function_etag" {
#   description = "ETag of the function (DEVELOPMENT stage)"
#   value       = aws_cloudfront_function.example.etag
# }
#
# output "function_live_etag" {
#   description = "ETag of the function (LIVE stage)"
#   value       = aws_cloudfront_function.example.live_stage_etag
# }
#
# output "function_status" {
#   description = "Status of the CloudFront Function"
#   value       = aws_cloudfront_function.example.status
# }
