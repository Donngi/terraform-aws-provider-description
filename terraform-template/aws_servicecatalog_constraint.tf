################################################################################
# AWS Service Catalog Constraint
################################################################################
# Resource: aws_servicecatalog_constraint
# Provider Version: 6.28.0
# Documentation: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/servicecatalog_constraint
#
# Description:
# Manages a Service Catalog Constraint. Constraints are rules that are applied
# to AWS Service Catalog products when end users launch them. They can control
# things like which IAM role is used, notification endpoints, and other launch
# behaviors.
#
# IMPORTANT NOTE:
# This resource does not associate a Service Catalog product and portfolio.
# However, the product and portfolio must be associated (see the
# aws_servicecatalog_product_portfolio_association resource) prior to creating
# a constraint or you will receive an error.
#
# Available Constraint Types:
# - LAUNCH: Specifies the AWS IAM role to use when launching a product
# - NOTIFICATION: Specifies SNS topics for stack events
# - RESOURCE_UPDATE: Controls which properties can be updated after launch
# - STACKSET: Enables CloudFormation StackSet deployment
# - TEMPLATE: Provides additional CloudFormation template constraints
################################################################################

resource "aws_servicecatalog_constraint" "example" {
  # ============================================================================
  # Required Arguments
  # ============================================================================

  # (Required) Portfolio identifier
  # The ID of the portfolio containing this constraint
  portfolio_id = "port-abcd1234efgh"

  # (Required) Product identifier
  # The ID of the product to which this constraint applies
  product_id = "prod-abcd1234efgh"

  # (Required) Type of constraint
  # Valid values: LAUNCH, NOTIFICATION, RESOURCE_UPDATE, STACKSET, TEMPLATE
  # - LAUNCH: Specifies an IAM role for product launch
  # - NOTIFICATION: Configures SNS notifications for stack events
  # - RESOURCE_UPDATE: Defines which resources can be updated
  # - STACKSET: Enables StackSet deployment model
  # - TEMPLATE: Additional template validation rules
  type = "LAUNCH"

  # (Required) Constraint parameters in JSON format
  # The syntax depends on the constraint type selected above
  #
  # Example for LAUNCH constraint:
  # parameters = jsonencode({
  #   "RoleArn" : "arn:aws:iam::123456789012:role/LaunchRole"
  # })
  #
  # Example for NOTIFICATION constraint:
  # parameters = jsonencode({
  #   "NotificationArns" : ["arn:aws:sns:us-east-1:123456789012:topic"]
  # })
  #
  # Example for RESOURCE_UPDATE constraint:
  # parameters = jsonencode({
  #   "TagUpdateOnProvisionedProduct" : "ALLOWED"
  # })
  #
  # Example for STACKSET constraint:
  # parameters = jsonencode({
  #   "AccountList" : ["123456789012"],
  #   "RegionList" : ["us-east-1", "us-west-2"],
  #   "AdminRole" : "arn:aws:iam::123456789012:role/StackSetAdminRole",
  #   "ExecutionRole" : "StackSetExecutionRole"
  # })
  parameters = jsonencode({
    "RoleArn" : "arn:aws:iam::123456789012:role/ServiceCatalogLaunchRole"
  })

  # ============================================================================
  # Optional Arguments
  # ============================================================================

  # (Optional) Language code for localized constraint information
  # Valid values: en (English), jp (Japanese), zh (Chinese)
  # Default: en
  accept_language = "en"

  # (Optional) Description of the constraint
  # Provides context about what this constraint enforces
  description = "Launch constraint to specify IAM role for product deployment"

  # (Optional) Region where this resource will be managed
  # Defaults to the Region set in the provider configuration
  # Useful for multi-region Service Catalog deployments
  # region = "us-east-1"

  # ============================================================================
  # Timeouts Configuration
  # ============================================================================
  # Configure operation timeouts for resource lifecycle operations

  timeouts {
    # Timeout for create operations (default: varies by resource)
    create = "3m"

    # Timeout for read operations (default: varies by resource)
    read = "10m"

    # Timeout for update operations (default: varies by resource)
    update = "3m"

    # Timeout for delete operations (default: varies by resource)
    delete = "3m"
  }

  # ============================================================================
  # Computed Attributes (Read-Only)
  # ============================================================================
  # The following attributes are exported and can be referenced in other resources:
  #
  # - id: Constraint identifier
  #       Example usage: aws_servicecatalog_constraint.example.id
  #
  # - owner: Owner of the constraint (AWS account ID)
  #       Example usage: aws_servicecatalog_constraint.example.owner
  #
  # - status: Current status of the constraint
  #       Example usage: aws_servicecatalog_constraint.example.status
  # ============================================================================
}

################################################################################
# Additional Examples
################################################################################

# Example 1: LAUNCH constraint with IAM role
resource "aws_servicecatalog_constraint" "launch_example" {
  description  = "Launch constraint for EC2 instance product"
  portfolio_id = "port-abcd1234efgh"
  product_id   = "prod-abcd1234efgh"
  type         = "LAUNCH"

  parameters = jsonencode({
    "RoleArn" : "arn:aws:iam::123456789012:role/ServiceCatalogLaunchRole"
  })
}

# Example 2: NOTIFICATION constraint with SNS topic
resource "aws_servicecatalog_constraint" "notification_example" {
  description  = "Notification constraint for stack events"
  portfolio_id = "port-abcd1234efgh"
  product_id   = "prod-abcd1234efgh"
  type         = "NOTIFICATION"

  parameters = jsonencode({
    "NotificationArns" : [
      "arn:aws:sns:us-east-1:123456789012:servicecatalog-notifications"
    ]
  })
}

# Example 3: RESOURCE_UPDATE constraint
resource "aws_servicecatalog_constraint" "resource_update_example" {
  description  = "Allow tag updates on provisioned products"
  portfolio_id = "port-abcd1234efgh"
  product_id   = "prod-abcd1234efgh"
  type         = "RESOURCE_UPDATE"

  parameters = jsonencode({
    "TagUpdateOnProvisionedProduct" : "ALLOWED"
  })
}

# Example 4: STACKSET constraint for multi-account deployment
resource "aws_servicecatalog_constraint" "stackset_example" {
  description  = "StackSet constraint for multi-account deployment"
  portfolio_id = "port-abcd1234efgh"
  product_id   = "prod-abcd1234efgh"
  type         = "STACKSET"

  parameters = jsonencode({
    "AccountList" : ["123456789012", "210987654321"],
    "RegionList" : ["us-east-1", "us-west-2", "eu-west-1"],
    "AdminRole" : "arn:aws:iam::123456789012:role/StackSetAdminRole",
    "ExecutionRole" : "StackSetExecutionRole"
  })
}

# Example 5: TEMPLATE constraint
resource "aws_servicecatalog_constraint" "template_example" {
  description  = "Template constraint for parameter validation"
  portfolio_id = "port-abcd1234efgh"
  product_id   = "prod-abcd1234efgh"
  type         = "TEMPLATE"

  parameters = jsonencode({
    "Rules" : {
      "Rule1" : {
        "Assertions" : [
          {
            "Assert" : {
              "Fn::Contains" : [
                ["t2.micro", "t2.small", "t2.medium"],
                { "Ref" : "InstanceType" }
              ]
            },
            "AssertDescription" : "Instance type must be t2.micro, t2.small, or t2.medium"
          }
        ]
      }
    }
  })
}

################################################################################
# Integration with Other Resources
################################################################################

# Complete example showing integration with portfolio and product
resource "aws_servicecatalog_portfolio" "portfolio" {
  name          = "My Application Portfolio"
  description   = "Portfolio of approved application infrastructure"
  provider_name = "IT Department"
}

resource "aws_servicecatalog_product" "product" {
  name  = "EC2 Web Server"
  owner = "IT Department"
  type  = "CLOUD_FORMATION_TEMPLATE"

  provisioning_artifact_parameters {
    name        = "v1.0"
    description = "EC2 instance for web hosting"
    type        = "CLOUD_FORMATION_TEMPLATE"
    template_url = "https://s3.amazonaws.com/bucket/template.json"
  }
}

resource "aws_servicecatalog_product_portfolio_association" "association" {
  portfolio_id = aws_servicecatalog_portfolio.portfolio.id
  product_id   = aws_servicecatalog_product.product.id
}

# The constraint must be created after the product-portfolio association
resource "aws_servicecatalog_constraint" "integrated_example" {
  description  = "Launch constraint for integrated example"
  portfolio_id = aws_servicecatalog_portfolio.portfolio.id
  product_id   = aws_servicecatalog_product.product.id
  type         = "LAUNCH"

  parameters = jsonencode({
    "RoleArn" : "arn:aws:iam::123456789012:role/ServiceCatalogLaunchRole"
  })

  depends_on = [aws_servicecatalog_product_portfolio_association.association]
}

################################################################################
# Output Values
################################################################################

output "constraint_id" {
  description = "The ID of the Service Catalog constraint"
  value       = aws_servicecatalog_constraint.example.id
}

output "constraint_owner" {
  description = "The owner of the constraint (AWS account ID)"
  value       = aws_servicecatalog_constraint.example.owner
}

output "constraint_status" {
  description = "The status of the constraint"
  value       = aws_servicecatalog_constraint.example.status
}

################################################################################
# Best Practices and Important Notes
################################################################################
#
# 1. Product-Portfolio Association Required:
#    Always ensure the product and portfolio are associated before creating
#    constraints using aws_servicecatalog_product_portfolio_association.
#
# 2. IAM Role Permissions for LAUNCH Constraints:
#    The IAM role specified in LAUNCH constraints must have:
#    - Trust relationship with Service Catalog service
#    - Permissions to create/manage resources in the CloudFormation template
#    - Service Catalog must be able to assume this role
#
# 3. Parameter Format Validation:
#    The parameters field must be valid JSON matching the constraint type's
#    expected schema. Invalid JSON will cause deployment failures.
#
# 4. Multiple Constraints:
#    You can apply multiple constraints to the same product-portfolio
#    combination, but only one of each type.
#
# 5. Regional Considerations:
#    Service Catalog constraints are regional. For multi-region deployments,
#    create separate constraints in each region or use the region parameter.
#
# 6. Notification Constraint SNS Topics:
#    SNS topics specified in NOTIFICATION constraints must exist in the
#    same region and allow Service Catalog to publish messages.
#
# 7. StackSet Constraint Requirements:
#    For STACKSET constraints:
#    - AdminRole must have permissions to create StackSets
#    - ExecutionRole must exist in target accounts
#    - Accounts must be part of your AWS Organization
#
# 8. Tag Update Constraints:
#    RESOURCE_UPDATE constraints with TagUpdateOnProvisionedProduct set to
#    "ALLOWED" enable end users to update tags on their provisioned products.
#
# 9. Template Constraints:
#    TEMPLATE constraints use CloudFormation template constraint rules syntax
#    to validate parameters and enforce business rules.
#
# 10. Localization:
#     Use accept_language parameter to retrieve constraint information in
#     different languages (en, jp, zh) for global deployments.
#
################################################################################
