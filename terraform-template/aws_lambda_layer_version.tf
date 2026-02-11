# ============================================================
# AWS Lambda Layer Version
# ============================================================
# Manages an AWS Lambda Layer Version for sharing code and dependencies
# across multiple Lambda functions. Layers help reduce deployment package
# sizes, promote separation of concerns, and enable sharing of dependencies.
#
# Provider Version: 6.28.0
# Resource: aws_lambda_layer_version
# Documentation: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_layer_version
# AWS Documentation: https://docs.aws.amazon.com/lambda/latest/dg/chapter-layers.html
# ============================================================

resource "aws_lambda_layer_version" "example" {
  # ============================================================
  # Required Arguments
  # ============================================================

  # layer_name - (Required) Unique name for your Lambda Layer
  # The name identifies the layer and is used in function configurations.
  # Must be unique within your AWS account and region.
  # Type: string
  layer_name = "example-layer"

  # ============================================================
  # Deployment Package Source (Choose One)
  # ============================================================
  # You must specify either filename OR the s3_* options, but not both.

  # filename - (Optional) Path to the function's deployment package within
  # the local filesystem. If defined, the s3_*-prefixed options cannot be used.
  # The layer content is extracted to /opt in the function execution environment.
  # Type: string
  # Conflicts with: s3_bucket, s3_key, s3_object_version
  filename = "lambda_layer_payload.zip"

  # s3_bucket - (Optional) S3 bucket location containing the layer's deployment
  # package. Conflicts with filename. This bucket must reside in the same AWS
  # region where you are creating the layer.
  # Type: string
  # Conflicts with: filename
  # s3_bucket = "my-lambda-layers-bucket"

  # s3_key - (Optional) S3 key of an object containing the layer's deployment
  # package. Conflicts with filename. Used in conjunction with s3_bucket.
  # Type: string
  # Conflicts with: filename
  # s3_key = "layers/my-layer-v1.0.0.zip"

  # s3_object_version - (Optional) Object version containing the layer's
  # deployment package. Conflicts with filename. Enables versioned deployments
  # from S3 with object versioning enabled.
  # Type: string
  # Conflicts with: filename
  # s3_object_version = "abc123..."

  # ============================================================
  # Runtime and Architecture Compatibility
  # ============================================================

  # compatible_runtimes - (Optional) List of Runtimes this layer is compatible
  # with. Up to 15 runtimes can be specified. When specified, only functions
  # using these runtimes can use this layer.
  # Type: list(string)
  # Valid values include: nodejs18.x, nodejs20.x, python3.11, python3.12,
  # python3.13, java11, java17, java21, dotnet6, dotnet8, ruby3.2, ruby3.3,
  # provided.al2, provided.al2023, etc.
  # Reference: https://docs.aws.amazon.com/lambda/latest/dg/API_PublishLayerVersion.html#SSS-PublishLayerVersion-request-CompatibleRuntimes
  compatible_runtimes = [
    "nodejs20.x",
    "python3.12"
  ]

  # compatible_architectures - (Optional) List of Architectures this layer is
  # compatible with. Currently x86_64 and arm64 can be specified. If not
  # specified, the layer is compatible with both architectures.
  # Type: list(string)
  # Valid values: x86_64, arm64
  # Reference: https://docs.aws.amazon.com/lambda/latest/dg/API_PublishLayerVersion.html#SSS-PublishLayerVersion-request-CompatibleArchitectures
  compatible_architectures = [
    "x86_64",
    "arm64"
  ]

  # ============================================================
  # Metadata and Documentation
  # ============================================================

  # description - (Optional) Description of what your Lambda Layer does.
  # Helps document the purpose and contents of the layer for other developers.
  # Type: string
  description = "Shared utilities and dependencies for Lambda functions"

  # license_info - (Optional) License info for your Lambda Layer. Can be a
  # SPDX license identifier (e.g., MIT, Apache-2.0) or a URL to the license.
  # Helps comply with open source licensing requirements.
  # Type: string
  # Reference: https://docs.aws.amazon.com/lambda/latest/dg/API_PublishLayerVersion.html#SSS-PublishLayerVersion-request-LicenseInfo
  # license_info = "MIT"

  # ============================================================
  # Version Control and Updates
  # ============================================================

  # source_code_hash - (Optional) Virtual attribute used to trigger replacement
  # when source code changes. Must be set to a base64-encoded SHA256 hash of
  # the package file specified with either filename or s3_key.
  # The usual way to set this is filebase64sha256("file.zip") (Terraform 0.11.12+)
  # or base64sha256(file("file.zip")) (Terraform 0.11.11 and earlier).
  # This ensures Terraform detects changes to the layer content.
  # Type: string
  source_code_hash = filebase64sha256("lambda_layer_payload.zip")

  # skip_destroy - (Optional) Whether to retain the old version of a previously
  # deployed Lambda Layer. Default is false. When set to true, the AWS Provider
  # will not destroy any layer version, even when running terraform destroy.
  # Layer versions are thus intentional dangling resources that are not managed
  # by Terraform and may incur extra expense in your AWS account.
  # Type: bool
  # Default: false
  # Note: When not set to true, changing any of the following forces deletion
  # of the existing layer version and creation of a new layer version:
  # - compatible_architectures
  # - compatible_runtimes
  # - description
  # - filename
  # - layer_name
  # - license_info
  # - s3_bucket
  # - s3_key
  # - s3_object_version
  # - source_code_hash
  # skip_destroy = false

  # ============================================================
  # Regional Configuration
  # ============================================================

  # region - (Optional) Region where this resource will be managed.
  # Defaults to the Region set in the provider configuration.
  # Type: string
  # Reference: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"
}

# ============================================================
# Attribute Reference
# ============================================================
# In addition to all arguments above, the following attributes are exported:
#
# arn - ARN of the Lambda Layer with version (e.g., arn:aws:lambda:us-east-1:123456789012:layer:example-layer:1)
#   Example: aws_lambda_layer_version.example.arn
#
# layer_arn - ARN of the Lambda Layer without version (e.g., arn:aws:lambda:us-east-1:123456789012:layer:example-layer)
#   Use this when you want to reference the layer without a specific version
#   Example: aws_lambda_layer_version.example.layer_arn
#
# version - Lambda Layer version number (incremented with each new version)
#   Example: aws_lambda_layer_version.example.version
#
# code_sha256 - Base64-encoded representation of raw SHA-256 sum of the zip file
#   Example: aws_lambda_layer_version.example.code_sha256
#
# created_date - Date this resource was created (ISO 8601 format)
#   Example: aws_lambda_layer_version.example.created_date
#
# source_code_size - Size in bytes of the layer .zip file
#   Example: aws_lambda_layer_version.example.source_code_size
#
# signing_job_arn - ARN of a signing job (if code signing is enabled)
#   Example: aws_lambda_layer_version.example.signing_job_arn
#
# signing_profile_version_arn - ARN for a signing profile version (if code signing is enabled)
#   Example: aws_lambda_layer_version.example.signing_profile_version_arn

# ============================================================
# Usage Examples
# ============================================================

# Example 1: Basic Layer with Local File
# resource "aws_lambda_layer_version" "basic" {
#   filename   = "lambda_layer_payload.zip"
#   layer_name = "lambda_layer_name"
#
#   compatible_runtimes = ["nodejs20.x"]
# }

# Example 2: Layer with S3 Source
# resource "aws_lambda_layer_version" "s3_layer" {
#   s3_bucket = aws_s3_object.lambda_layer_zip.bucket
#   s3_key    = aws_s3_object.lambda_layer_zip.key
#
#   layer_name = "lambda_layer_name"
#
#   compatible_runtimes      = ["nodejs20.x", "python3.12"]
#   compatible_architectures = ["x86_64", "arm64"]
# }

# Example 3: Layer with Multiple Runtimes and Architectures
# resource "aws_lambda_layer_version" "multi_runtime" {
#   filename         = "lambda_layer_payload.zip"
#   layer_name       = "multi_runtime_layer"
#   description      = "Shared utilities for Lambda functions"
#   license_info     = "MIT"
#   source_code_hash = filebase64sha256("lambda_layer_payload.zip")
#
#   compatible_runtimes = [
#     "nodejs18.x",
#     "nodejs20.x",
#     "python3.11",
#     "python3.12"
#   ]
#
#   compatible_architectures = ["x86_64", "arm64"]
# }

# Example 4: Using Layer in Lambda Function
# resource "aws_lambda_function" "example" {
#   # ... other configuration ...
#
#   layers = [
#     aws_lambda_layer_version.example.arn
#   ]
# }

# ============================================================
# Important Notes
# ============================================================
# 1. Layer Versions are Immutable:
#    - Each layer version is an immutable snapshot
#    - To update a layer, create a new version (version number increments automatically)
#    - Functions reference layers by ARN with version number
#
# 2. Layer Content Structure:
#    - Layers are extracted to /opt directory in function execution environment
#    - For Python: place libraries in python/lib/python3.x/site-packages/
#    - For Node.js: place libraries in nodejs/node_modules/
#    - For Java: place JAR files in java/lib/
#    - For other runtimes: consult AWS documentation
#
# 3. Layer Limitations:
#    - Maximum 5 layers per function
#    - Maximum layer size (uncompressed): 250 MB
#    - Maximum deployment package size (all layers + function): 250 MB (uncompressed)
#    - Layers can only be used with .zip file deployments (not container images)
#
# 4. Best Practices:
#    - Use layers to share common dependencies across functions
#    - Version your layer deployments using source_code_hash
#    - Document layer contents and compatible runtimes clearly
#    - Consider using skip_destroy for production layers to prevent accidental deletion
#    - For Go and Rust functions, include dependencies in deployment package instead
#
# 5. Source Code Hash:
#    - Always use source_code_hash to detect changes in layer content
#    - Without it, Terraform won't detect changes to the zip file
#    - Use filebase64sha256() for files or etag from S3 object
#
# 6. Deployment from S3:
#    - S3 bucket must be in the same region as the layer
#    - Use s3_object_version for versioned deployments
#    - Consider lifecycle policies to manage old layer versions
#
# 7. Permissions:
#    - Use aws_lambda_layer_version_permission to grant access to other accounts
#    - Layer permissions are separate from function permissions
#
# 8. Cost Considerations:
#    - Layer storage counts toward the 75 GB quota for functions and layers
#    - Old layer versions continue to consume storage unless deleted
#    - Use skip_destroy carefully as it can lead to orphaned resources
#
# 9. Regional Availability:
#    - Lambda layers are region-specific resources
#    - Deploy the same layer in multiple regions for multi-region architectures
#
# 10. Runtime Compatibility:
#     - Specify compatible_runtimes to prevent incompatible usage
#     - Keep layers updated with current runtime versions
#     - Test layers with all specified compatible runtimes
