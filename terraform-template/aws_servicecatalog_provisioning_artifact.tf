################################################################################
# AWS Service Catalog Provisioning Artifact
################################################################################
# Manages a Service Catalog Provisioning Artifact for a specified product.
#
# A "provisioning artifact" is also referred to as a "version."
#
# IMPORTANT NOTES:
# - You cannot create a provisioning artifact for a product that was shared with you
# - The user or role that uses this resource must have the cloudformation:GetTemplate
#   IAM policy permission. This is required when using the template_physical_id argument.
#
# Use Cases:
# - Create versions of Service Catalog products
# - Manage CloudFormation template versions for Service Catalog products
# - Control product version lifecycle (active/inactive, guidance)
# - Support multiple provisioning artifact types (CloudFormation templates, etc.)
#
# References:
# - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/servicecatalog_provisioning_artifact
# - https://docs.aws.amazon.com/servicecatalog/latest/dg/API_ProvisioningArtifactProperties.html
################################################################################

resource "aws_servicecatalog_provisioning_artifact" "example" {
  ################################################################################
  # Required Arguments
  ################################################################################

  # Identifier of the product
  # This is the Service Catalog product ID where this provisioning artifact belongs
  product_id = "prod-xxxxxxxxxxxxx" # Example: aws_servicecatalog_product.example.id

  ################################################################################
  # Template Source (One Required)
  ################################################################################
  # You must specify either template_url OR template_physical_id

  # Template source as URL of the CloudFormation template in Amazon S3
  # Format: https://bucket.s3.region.amazonaws.com/path/to/template.json
  template_url = "https://example-bucket.s3.us-east-1.amazonaws.com/templates/v1.json"

  # OR

  # Template source as the physical ID of the resource that contains the template
  # Currently only supports CloudFormation stack ARN
  # Format: arn:[partition]:cloudformation:[region]:[account ID]:stack/[stack name]/[resource ID]
  # Note: Requires cloudformation:GetTemplate IAM permission
  # template_physical_id = "arn:aws:cloudformation:us-east-1:123456789012:stack/my-stack/abc123"

  ################################################################################
  # Optional Arguments
  ################################################################################

  # Language code for localization
  # Valid values: en (English), jp (Japanese), zh (Chinese)
  # Default: en
  accept_language = "en"

  # Whether the product version is active
  # Inactive provisioning artifacts are invisible to end users
  # End users cannot launch or update a provisioned product from an inactive artifact
  # Default: true
  active = true

  # Description of the provisioning artifact (i.e., version)
  # Include information about how it differs from the previous provisioning artifact
  description = "Initial version of the product with basic features"

  # Whether AWS Service Catalog stops validating the specified provisioning artifact
  # template even if it is invalid
  # Default: false
  disable_template_validation = false

  # Information set by the administrator to provide guidance to end users
  # about which provisioning artifacts to use
  # Valid values: DEFAULT, DEPRECATED
  # Default: DEFAULT
  # Note: Users can update a provisioned product of a deprecated version
  # but cannot launch new provisioned products using a deprecated version
  guidance = "DEFAULT"

  # Name of the provisioning artifact (for example, v1, v2beta)
  # No spaces are allowed
  name = "v1.0.0"

  # Region where this resource will be managed
  # Defaults to the Region set in the provider configuration
  # Reference: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  # Type of provisioning artifact
  # See https://docs.aws.amazon.com/servicecatalog/latest/dg/API_ProvisioningArtifactProperties.html
  # for valid list of values
  # Common value: CLOUD_FORMATION_TEMPLATE
  type = "CLOUD_FORMATION_TEMPLATE"

  ################################################################################
  # Timeouts
  ################################################################################
  # Configure operation timeout values
  timeouts {
    create = "30m" # Default: 30 minutes
    delete = "30m" # Default: 30 minutes
    read   = "10m" # Default: 10 minutes
    update = "30m" # Default: 30 minutes
  }

  ################################################################################
  # Common Tags
  ################################################################################
  # Note: This resource does not support tags directly
  # Tags should be managed at the product level (aws_servicecatalog_product)
}

################################################################################
# Outputs
################################################################################

output "provisioning_artifact_id" {
  description = "The provisioning artifact identifier"
  value       = aws_servicecatalog_provisioning_artifact.example.provisioning_artifact_id
}

output "provisioning_artifact_created_time" {
  description = "Time when the provisioning artifact was created"
  value       = aws_servicecatalog_provisioning_artifact.example.created_time
}

output "provisioning_artifact_status" {
  description = "Status of the provisioning artifact"
  value       = aws_servicecatalog_provisioning_artifact.example.id
}

################################################################################
# Example: Complete Service Catalog Setup
################################################################################

# Example S3 bucket for storing CloudFormation templates
# resource "aws_s3_bucket" "templates" {
#   bucket = "my-service-catalog-templates"
# }

# Example S3 object for the CloudFormation template
# resource "aws_s3_object" "template" {
#   bucket = aws_s3_bucket.templates.id
#   key    = "templates/v1.0.0.json"
#   source = "path/to/local/template.json"
#   etag   = filemd5("path/to/local/template.json")
# }

# Example Service Catalog product
# resource "aws_servicecatalog_product" "example" {
#   name  = "My Product"
#   owner = "IT Services"
#   type  = "CLOUD_FORMATION_TEMPLATE"
#
#   provisioning_artifact_parameters {
#     name        = "v1.0.0"
#     description = "Initial version"
#     type        = "CLOUD_FORMATION_TEMPLATE"
#     template_url = "https://${aws_s3_bucket.templates.bucket_regional_domain_name}/${aws_s3_object.template.key}"
#   }
# }

# Example provisioning artifact with S3 template
# resource "aws_servicecatalog_provisioning_artifact" "v2" {
#   name         = "v2.0.0"
#   description  = "Second version with enhanced features"
#   product_id   = aws_servicecatalog_product.example.id
#   type         = "CLOUD_FORMATION_TEMPLATE"
#   template_url = "https://${aws_s3_bucket.templates.bucket_regional_domain_name}/templates/v2.0.0.json"
#   active       = true
#   guidance     = "DEFAULT"
# }

# Example provisioning artifact with CloudFormation stack as template
# resource "aws_servicecatalog_provisioning_artifact" "from_stack" {
#   name                 = "v3.0.0"
#   description          = "Version based on existing CloudFormation stack"
#   product_id           = aws_servicecatalog_product.example.id
#   type                 = "CLOUD_FORMATION_TEMPLATE"
#   template_physical_id = "arn:aws:cloudformation:us-east-1:123456789012:stack/my-stack/abc123"
#   active               = true
# }

# Example deprecated version
# resource "aws_servicecatalog_provisioning_artifact" "deprecated" {
#   name        = "v0.9.0"
#   description = "Deprecated version - please use v1.0.0 or later"
#   product_id  = aws_servicecatalog_product.example.id
#   type        = "CLOUD_FORMATION_TEMPLATE"
#   template_url = "https://${aws_s3_bucket.templates.bucket_regional_domain_name}/templates/v0.9.0.json"
#   active      = true
#   guidance    = "DEPRECATED"
# }

################################################################################
# Additional Information
################################################################################

# IAM Policy Required:
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Action": [
#         "servicecatalog:CreateProvisioningArtifact",
#         "servicecatalog:DescribeProvisioningArtifact",
#         "servicecatalog:UpdateProvisioningArtifact",
#         "servicecatalog:DeleteProvisioningArtifact",
#         "cloudformation:GetTemplate"
#       ],
#       "Resource": "*"
#     },
#     {
#       "Effect": "Allow",
#       "Action": [
#         "s3:GetObject"
#       ],
#       "Resource": "arn:aws:s3:::your-template-bucket/*"
#     }
#   ]
# }

# Best Practices:
# 1. Use semantic versioning for provisioning artifact names (v1.0.0, v1.1.0, etc.)
# 2. Always provide clear descriptions explaining changes between versions
# 3. Store CloudFormation templates in version-controlled S3 buckets
# 4. Use DEPRECATED guidance instead of making artifacts inactive to allow existing
#    provisioned products to continue functioning
# 5. Test templates thoroughly before creating provisioning artifacts
# 6. Consider using template_url for templates stored in S3 for better version control
# 7. Keep the number of active versions reasonable to avoid confusion
# 8. Document breaking changes clearly in the description field

# Limitations:
# - Cannot create provisioning artifacts for products shared with you
# - CloudFormation stack ARNs are the only supported physical ID format
# - Artifact names cannot contain spaces
# - Once created, the template source cannot be changed (must create new artifact)

# Import Example:
# terraform import aws_servicecatalog_provisioning_artifact.example pa-xxxxxxxx:prod-xxxxxxxx
# Format: provisioning_artifact_id:product_id
