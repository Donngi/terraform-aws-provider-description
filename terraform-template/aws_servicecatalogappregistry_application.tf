################################################################################
# AWS Service Catalog AppRegistry Application
################################################################################
# Terraform resource for managing an AWS Service Catalog AppRegistry Application.
#
# An AWS Service Catalog AppRegistry Application is displayed in the AWS Console
# under "MyApplications".
#
# AWS Service Catalog AppRegistry enables you to create a repository of your
# applications and associated resources. It provides a single source of truth
# for your applications and helps you manage and govern your applications at scale.
#
# Provider Version: 6.28.0
# Resource Documentation: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/servicecatalogappregistry_application
################################################################################

resource "aws_servicecatalogappregistry_application" "example" {
  # ============================================================================
  # REQUIRED ARGUMENTS
  # ============================================================================

  # name - (Required) Name of the application
  # The name must be unique within an AWS region.
  # Type: string
  #
  # Example values:
  #   - "my-application"
  #   - "example-app"
  #   - "production-webapp"
  name = "example-app"

  # ============================================================================
  # OPTIONAL ARGUMENTS
  # ============================================================================

  # description - (Optional) Description of the application
  # Provides additional context about the application's purpose and functionality.
  # Type: string
  #
  # Example values:
  #   - "Production web application for customer portal"
  #   - "Internal tool for data processing"
  description = "Example application managed by Service Catalog AppRegistry"

  # region - (Optional) Region where this resource will be managed
  # Defaults to the Region set in the provider configuration.
  # Reference: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # Type: string
  #
  # Example values:
  #   - "us-east-1"
  #   - "eu-west-1"
  #   - "ap-northeast-1"
  #
  # Note: If not specified, uses the region from the AWS provider configuration.
  # region = "us-east-1"

  # tags - (Optional) A map of tags assigned to the Application
  # Tags are key-value pairs that help you organize and categorize your AWS resources.
  # Type: map(string)
  #
  # Note: If configured with a provider default_tags configuration block,
  # tags with matching keys will overwrite those defined at the provider-level.
  #
  # Best Practices:
  #   - Use consistent tag keys across your organization
  #   - Include environment, owner, and cost center tags
  #   - Consider using tags for automation and resource grouping
  #
  # Example:
  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
    Application = "example-app"
    Owner       = "platform-team"
  }

  # ============================================================================
  # COMPUTED ATTRIBUTES (Read-Only)
  # ============================================================================
  # These attributes are automatically populated by AWS and cannot be set directly.
  # Access them using: aws_servicecatalogappregistry_application.example.<attribute>
  #
  # application_tag - A map with a single tag key-value pair used to associate
  #                   resources with the application. This attribute can be
  #                   passed directly into the tags argument of another resource,
  #                   or merged into a map of existing tags.
  #                   Type: map(string)
  #                   Example: { "awsApplication" = "arn:aws:servicecatalog:..." }
  #
  # arn - ARN (Amazon Resource Name) of the application
  #       Type: string
  #       Example: "arn:aws:servicecatalog:us-east-1:123456789012:application/..."
  #
  # id - Identifier of the application
  #      Type: string
  #      Example: "appregistry-1234567890abcdef0"
  #
  # tags_all - Map of tags assigned to the resource, including those inherited
  #            from the provider default_tags configuration block
  #            Type: map(string)
  # ============================================================================
}

################################################################################
# EXAMPLE: Connecting Resources with application_tag
################################################################################
# The application_tag attribute can be used to associate other AWS resources
# with this application. This creates a logical grouping of resources.
#
# Example: Associate an S3 bucket with the application
#
# resource "aws_s3_bucket" "example" {
#   bucket = "example-bucket"
#
#   # Use the application_tag to associate this bucket with the application
#   tags = aws_servicecatalogappregistry_application.example.application_tag
# }
#
# Example: Merge application_tag with additional tags
#
# resource "aws_lambda_function" "example" {
#   function_name = "example-function"
#   # ... other configuration ...
#
#   tags = merge(
#     aws_servicecatalogappregistry_application.example.application_tag,
#     {
#       Name        = "example-function"
#       Environment = "production"
#     }
#   )
# }
################################################################################

################################################################################
# USAGE NOTES
################################################################################
# 1. Application Name Uniqueness:
#    - Application names must be unique within an AWS region
#    - Choose descriptive names that reflect the application's purpose
#
# 2. Resource Association:
#    - Use the application_tag attribute to tag related AWS resources
#    - This creates a logical grouping in AWS Service Catalog AppRegistry
#    - Associated resources will appear in the AWS Console under "MyApplications"
#
# 3. Regional Considerations:
#    - By default, the resource is created in the provider's configured region
#    - Use the region argument to explicitly manage the resource in a different region
#
# 4. Tagging Strategy:
#    - Implement a consistent tagging strategy across your organization
#    - Use tags for cost allocation, automation, and resource management
#    - Consider using AWS Tag Policies for tag governance
#
# 5. Integration with Other Services:
#    - AppRegistry integrates with AWS Systems Manager Application Manager
#    - Provides a unified view of application health and operational data
#    - Supports cost tracking and resource optimization
################################################################################

################################################################################
# OUTPUTS (Example)
################################################################################
# You can reference these values in other resources or output them for use elsewhere.
#
# output "application_id" {
#   description = "The ID of the Service Catalog AppRegistry Application"
#   value       = aws_servicecatalogappregistry_application.example.id
# }
#
# output "application_arn" {
#   description = "The ARN of the Service Catalog AppRegistry Application"
#   value       = aws_servicecatalogappregistry_application.example.arn
# }
#
# output "application_tag" {
#   description = "Tag to associate resources with this application"
#   value       = aws_servicecatalogappregistry_application.example.application_tag
# }
################################################################################
