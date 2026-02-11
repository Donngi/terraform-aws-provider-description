################################################################################
# AWS Service Catalog Service Action
################################################################################
# Resource: aws_servicecatalog_service_action
# Provider Version: 6.28.0
# Description: Manages a Service Catalog self-service action
#
# Service Catalog self-service actions allow end users to perform operational
# tasks on provisioned products without requiring administrative access. These
# actions typically invoke AWS Systems Manager (SSM) documents to automate
# common operational tasks like starting/stopping EC2 instances, creating
# snapshots, or restarting services.
#
# Common Use Cases:
# - Restart EC2 instances for provisioned products
# - Create EBS volume snapshots
# - Stop/Start RDS databases
# - Execute custom automation scripts
# - Perform routine maintenance tasks
#
# Dependencies:
# - SSM Automation documents must exist before creating service actions
# - IAM roles with appropriate permissions for the automation
# - Service Catalog portfolio and product configuration
#
# Related Resources:
# - aws_servicecatalog_portfolio
# - aws_servicecatalog_product
# - aws_servicecatalog_portfolio_share
# - aws_ssm_document
# - aws_iam_role
#
# Official Documentation:
# https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/servicecatalog_service_action
# https://docs.aws.amazon.com/servicecatalog/latest/adminguide/using-service-actions.html
################################################################################

resource "aws_servicecatalog_service_action" "example" {
  ################################################################################
  # Required Arguments
  ################################################################################

  # Name of the self-service action
  # - Must be unique within the AWS account and region
  # - Visible to end users when managing provisioned products
  # - Should clearly describe the action's purpose
  # - Character limit: 1-128 characters
  # Example values: "Restart Instance", "Create Snapshot", "Stop Database"
  name = "Restart-EC2-Instance"

  # Self-service action definition (required block)
  # Configures the SSM automation document that will be executed
  # Must contain exactly one definition block
  definition {
    # Name of the SSM document to execute (Required)
    # - Can be an AWS-managed document (e.g., AWS-RestartEC2Instance)
    # - Can be a custom SSM document
    # - For shared SSM documents, provide the full ARN
    # Common AWS-managed documents:
    #   - AWS-RestartEC2Instance: Restart an EC2 instance
    #   - AWS-CreateSnapshot: Create an EBS snapshot
    #   - AWS-StopEC2Instance: Stop an EC2 instance
    #   - AWS-StartEC2Instance: Start an EC2 instance
    name = "AWS-RestartEC2Instance"

    # SSM document version (Required)
    # - Specify the version number (e.g., "1", "2", "$LATEST")
    # - Use "$LATEST" to always use the newest version
    # - Use specific version numbers for stability
    # - AWS-managed documents typically use version "1"
    version = "1"

    # Optional: IAM role for executing the action
    # - ARN of the role that performs the self-service actions
    # - Must have permissions to execute the SSM document
    # - Special value "LAUNCH_ROLE" reuses the provisioned product launch role
    # Example: "arn:aws:iam::123456789012:role/ServiceCatalogActionRole"
    # assume_role = "LAUNCH_ROLE"

    # Optional: Parameters in JSON format
    # - Defines input parameters for the SSM document
    # - Type can be "TARGET" (runtime) or "TEXT_VALUE" (predefined)
    # - TARGET type allows users to specify values when executing
    # - TEXT_VALUE type uses predefined values
    # Example for runtime parameter:
    # parameters = jsonencode([
    #   {
    #     Name = "InstanceId"
    #     Type = "TARGET"
    #   }
    # ])
    # Example for predefined value:
    # parameters = jsonencode([
    #   {
    #     Name = "InstanceId"
    #     Type = "TEXT_VALUE"
    #   }
    # ])
    # parameters = jsonencode([
    #   {
    #     Name = "InstanceId"
    #     Type = "TARGET"
    #   }
    # ])

    # Optional: Service action definition type
    # - Valid value: "SSM_AUTOMATION"
    # - Default: "SSM_AUTOMATION"
    # - Currently, only SSM_AUTOMATION is supported
    # type = "SSM_AUTOMATION"
  }

  ################################################################################
  # Optional Arguments
  ################################################################################

  # Description of the self-service action
  # - Provides context for end users
  # - Explains what the action does and when to use it
  # - Maximum length: 1-1024 characters
  # - Computed if not provided
  description = "Restart an EC2 instance to resolve connectivity or performance issues"

  # Language code for internationalization
  # - Valid values: "en" (English), "jp" (Japanese), "zh" (Chinese)
  # - Default: "en"
  # - Affects how the action appears in the Service Catalog console
  # accept_language = "en"

  # Region where this resource will be managed
  # - Defaults to the region set in provider configuration
  # - Use this to manage resources in a specific region
  # - Format: AWS region code (e.g., "us-east-1", "eu-west-1")
  # - Computed if not explicitly set
  # region = "us-east-1"

  ################################################################################
  # Timeouts (Optional)
  ################################################################################

  # Configure operation timeout limits
  # All values use Go duration format (e.g., "30m", "1h", "30s")
  # timeouts {
  #   # Timeout for creating the service action
  #   # Default: No timeout
  #   create = "3m"
  #
  #   # Timeout for reading/refreshing the service action
  #   # Default: No timeout
  #   read = "10m"
  #
  #   # Timeout for updating the service action
  #   # Default: No timeout
  #   update = "3m"
  #
  #   # Timeout for deleting the service action
  #   # Default: No timeout
  #   delete = "3m"
  # }

  ################################################################################
  # Tags (Note: Service actions do not support tags in the API)
  ################################################################################
}

################################################################################
# Computed Attributes (Available after creation)
################################################################################
# These attributes are exported and can be referenced in other resources:
#
# - id: Identifier of the service action (computed)
#   Usage: aws_servicecatalog_service_action.example.id
#
# - description: Service action description (computed if not set)
#   Usage: aws_servicecatalog_service_action.example.description
#
# - region: Region where the service action is managed (computed if not set)
#   Usage: aws_servicecatalog_service_action.example.region
################################################################################

################################################################################
# Example: Complete Service Action with Custom SSM Document
################################################################################
# resource "aws_servicecatalog_service_action" "create_snapshot" {
#   name        = "Create-EBS-Snapshot"
#   description = "Create a snapshot of the EC2 instance's root volume"
#
#   definition {
#     name    = "AWS-CreateSnapshot"
#     version = "1"
#
#     assume_role = aws_iam_role.service_action_role.arn
#
#     parameters = jsonencode([
#       {
#         Name = "VolumeId"
#         Type = "TARGET"
#       },
#       {
#         Name = "Description"
#         Type = "TEXT_VALUE"
#       }
#     ])
#   }
#
#   accept_language = "en"
# }

################################################################################
# Example: Service Action Using Launch Role
################################################################################
# resource "aws_servicecatalog_service_action" "stop_instance" {
#   name        = "Stop-EC2-Instance"
#   description = "Stop the EC2 instance to reduce costs during non-business hours"
#
#   definition {
#     name        = "AWS-StopEC2Instance"
#     version     = "1"
#     assume_role = "LAUNCH_ROLE"
#
#     parameters = jsonencode([
#       {
#         Name = "InstanceId"
#         Type = "TARGET"
#       }
#     ])
#   }
# }

################################################################################
# Example: Service Action with Predefined Parameters
################################################################################
# resource "aws_servicecatalog_service_action" "custom_action" {
#   name        = "Run-Custom-Automation"
#   description = "Execute custom automation workflow with predefined parameters"
#
#   definition {
#     name    = "arn:aws:ssm:us-east-1:123456789012:document/CustomAutomation"
#     version = "2"
#
#     assume_role = "arn:aws:iam::123456789012:role/CustomAutomationRole"
#
#     parameters = jsonencode([
#       {
#         Name = "AutomationAssumeRole"
#         Type = "TEXT_VALUE"
#       },
#       {
#         Name = "InstanceId"
#         Type = "TARGET"
#       },
#       {
#         Name = "Action"
#         Type = "TEXT_VALUE"
#       }
#     ])
#   }
#
#   timeouts {
#     create = "5m"
#     update = "5m"
#     delete = "5m"
#   }
# }

################################################################################
# Best Practices
################################################################################
# 1. Use descriptive names that clearly indicate the action's purpose
# 2. Provide detailed descriptions to help end users understand when to use the action
# 3. Use "LAUNCH_ROLE" when possible to simplify permission management
# 4. Test SSM documents independently before creating service actions
# 5. Use specific version numbers for production stability
# 6. Validate IAM permissions for the assume_role
# 7. Use TARGET parameter type for runtime flexibility
# 8. Document the expected behavior and prerequisites
# 9. Consider the security implications of granting self-service actions
# 10. Use accept_language to support international users

################################################################################
# Important Notes
################################################################################
# - Service actions must be associated with portfolios and products to be usable
# - The SSM document must exist before creating the service action
# - The assume_role must have permissions to execute the SSM document
# - Users need appropriate Service Catalog permissions to execute actions
# - Service actions are regional resources
# - Changes to definition parameters require recreation of the resource
# - Service actions cannot be directly tagged (use tagging on associated resources)
# - The parameters field must be valid JSON format
# - Type "TARGET" allows runtime parameter specification by end users
# - Type "TEXT_VALUE" uses predefined values specified in the parameters

################################################################################
# Common Errors and Solutions
################################################################################
# 1. "InvalidParametersException: Invalid assume role"
#    - Verify the IAM role ARN is correct and exists
#    - Check that the role has a trust relationship with Service Catalog
#
# 2. "ResourceNotFoundException: Document not found"
#    - Ensure the SSM document exists in the same region
#    - Verify the document name or ARN is correct
#
# 3. "AccessDeniedException"
#    - Verify Terraform has servicecatalog:CreateServiceAction permission
#    - Check that the assume_role has proper permissions
#
# 4. "InvalidParametersException: Invalid parameters"
#    - Validate the parameters JSON format
#    - Ensure parameter names match the SSM document
#
# 5. "ValidationException: Version not found"
#    - Verify the SSM document version exists
#    - Use "$LATEST" if unsure about the version number
################################################################################
