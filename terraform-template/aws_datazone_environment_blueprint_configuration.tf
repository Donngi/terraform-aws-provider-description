# ============================================================================
# Terraform AWS Provider - Resource Template
# ============================================================================
# Resource: aws_datazone_environment_blueprint_configuration
# Purpose: Terraform resource for managing an AWS DataZone Environment Blueprint Configuration
#
# Generated: 2026-01-19
# Provider Version: 6.28.0
# Schema Version: 0
#
# Note: This template was generated based on the AWS Provider schema and
# official documentation available at the time of generation. Always refer to
# the latest official documentation for the most up-to-date information:
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/datazone_environment_blueprint_configuration
# https://docs.aws.amazon.com/datazone/latest/APIReference/API_PutEnvironmentBlueprintConfiguration.html
# ============================================================================

resource "aws_datazone_environment_blueprint_configuration" "example" {
  # ============================================================================
  # Required Arguments
  # ============================================================================

  # domain_id - (Required) ID of the DataZone domain.
  # The identifier of the Amazon DataZone domain where the environment blueprint
  # configuration will be created.
  # Type: string
  # Pattern: dzd[-_][a-zA-Z0-9_-]{1,36}
  # Reference: https://docs.aws.amazon.com/datazone/latest/APIReference/API_PutEnvironmentBlueprintConfiguration.html
  domain_id = "dzd_example123456"

  # enabled_regions - (Required) Specifies the enabled AWS Regions.
  # List of AWS regions where the environment blueprint is enabled.
  # Each region string must follow AWS region naming pattern.
  # Type: list(string)
  # Pattern: [a-z]{2}-?(iso|gov)?-{1}[a-z]*-{1}[0-9]
  # Length: 4-16 characters per region
  # Array: Minimum 0 items
  # Reference: https://docs.aws.amazon.com/datazone/latest/APIReference/API_PutEnvironmentBlueprintConfiguration.html
  # See also: https://docs.aws.amazon.com/datazone/latest/userguide/datazone-supported-regions.html
  enabled_regions = ["us-east-1"]

  # environment_blueprint_id - (Required) ID of the environment blueprint.
  # The identifier of the environment blueprint for which configuration is being set.
  # You can use the aws_datazone_environment_blueprint data source to retrieve
  # blueprint IDs for managed blueprints like "DefaultDataLake" or "DefaultDataWarehouse".
  # Type: string
  # Pattern: [a-zA-Z0-9_-]{1,36}
  # Reference: https://docs.aws.amazon.com/datazone/latest/APIReference/API_PutEnvironmentBlueprintConfiguration.html
  environment_blueprint_id = "example-blueprint-id"

  # ============================================================================
  # Optional Arguments
  # ============================================================================

  # manage_access_role_arn - (Optional) ARN of the manage access role.
  # The IAM role ARN that grants permissions for managing access to the
  # environment created using this blueprint.
  # Type: string
  # Pattern: arn:aws[^:]*:iam::\d{12}:(role|role/service-role)/[\w+=,.@-]*
  # Reference: https://docs.aws.amazon.com/datazone/latest/APIReference/API_PutEnvironmentBlueprintConfiguration.html
  manage_access_role_arn = "arn:aws:iam::123456789012:role/DataZoneManageAccessRole"

  # provisioning_role_arn - (Optional) ARN of the provisioning role.
  # The IAM role ARN used to provision resources for environments created
  # using this blueprint configuration.
  # Type: string
  # Pattern: arn:aws[^:]*:iam::\d{12}:(role|role/service-role)/[\w+=,.@-]*
  # Reference: https://docs.aws.amazon.com/datazone/latest/APIReference/API_PutEnvironmentBlueprintConfiguration.html
  provisioning_role_arn = "arn:aws:iam::123456789012:role/DataZoneProvisioningRole"

  # region - (Optional) Region where this resource will be managed.
  # Specifies the AWS region where this DataZone environment blueprint
  # configuration resource will be managed. If not specified, defaults to
  # the region set in the provider configuration.
  # Type: string (computed)
  # Reference: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # Reference: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#aws-configuration-reference
  region = "us-east-1"

  # regional_parameters - (Optional) Parameters for each region in which the blueprint is enabled.
  # A map of regional parameters where the key is the region name and the value
  # is a map of parameter names to values. These parameters are specific to each
  # enabled region and can include blueprint-specific configuration such as
  # S3 bucket locations for Data Lake blueprints.
  # Type: map(map(string))
  # Key Pattern: [a-z]{2}-?(iso|gov)?-{1}[a-z]*-{1}[0-9]
  # Key Length: 4-16 characters
  # Reference: https://docs.aws.amazon.com/datazone/latest/APIReference/API_PutEnvironmentBlueprintConfiguration.html
  #
  # Example for DefaultDataLake blueprint:
  # regional_parameters = {
  #   us-east-1 = {
  #     S3Location = "s3://my-amazon-datazone-bucket"
  #   }
  # }
  regional_parameters = {
    us-east-1 = {
      S3Location = "s3://my-datazone-bucket-us-east-1"
    }
    us-west-2 = {
      S3Location = "s3://my-datazone-bucket-us-west-2"
    }
  }
}

# ============================================================================
# Additional Notes
# ============================================================================
#
# Environment Blueprints in Amazon DataZone:
# - Environment blueprints are templates used to create data environments
# - Common managed blueprints include "DefaultDataLake" and "DefaultDataWarehouse"
# - Each blueprint can be configured with region-specific parameters
# - The configuration determines how environments are provisioned when created
#
# IAM Role Requirements:
# - manage_access_role_arn: Used for managing access to created environments
# - provisioning_role_arn: Used for provisioning AWS resources for environments
# - Both roles must have appropriate trust relationships and permissions
#
# Regional Parameters:
# - Parameters vary by blueprint type
# - DefaultDataLake blueprint typically requires S3Location parameter
# - DefaultDataWarehouse blueprint may require Redshift cluster information
# - Regional parameters must be provided for each enabled region
#
# Related Resources:
# - data.aws_datazone_environment_blueprint: Retrieve blueprint information
# - aws_datazone_domain: The parent DataZone domain resource
# - aws_datazone_environment_profile: Templates for environment creation
#
# Important Considerations:
# - enabled_regions must contain at least one valid AWS region
# - Regional parameters must match the requirements of the specific blueprint
# - IAM roles must exist before creating the configuration
# - Changes to enabled_regions or regional_parameters may affect existing environments
#
# References:
# - Terraform AWS Provider Documentation:
#   https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/datazone_environment_blueprint_configuration
# - AWS DataZone API Reference:
#   https://docs.aws.amazon.com/datazone/latest/APIReference/API_PutEnvironmentBlueprintConfiguration.html
# - Amazon DataZone Supported Regions:
#   https://docs.aws.amazon.com/datazone/latest/userguide/datazone-supported-regions.html
# - Amazon DataZone User Guide:
#   https://docs.aws.amazon.com/datazone/latest/userguide/
# ============================================================================
