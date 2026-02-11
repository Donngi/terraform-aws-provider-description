# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# aws_lambda_runtime_management_config
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Terraform AWS Provider Version: 6.28.0
# Resource: aws_lambda_runtime_management_config
# Description: Manages an AWS Lambda Runtime Management Config
#
# Use this resource to control how Lambda updates the runtime for your function.
# Refer to the AWS Lambda documentation for supported runtimes:
# https://docs.aws.amazon.com/lambda/latest/dg/lambda-runtimes.html
#
# Note: Deletion of this resource returns the runtime update mode to Auto
# (the default behavior). To leave the configured runtime management options
# in-place, use a removed block with the destroy lifecycle set to false.
#
# Documentation: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_runtime_management_config
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# ┌────────────────────────────────────────────────────────────────────────────┐
# │ Example 1: Basic Usage - Function Update Mode                              │
# └────────────────────────────────────────────────────────────────────────────┘
# Runtime updates only when the function code is updated
resource "aws_lambda_runtime_management_config" "example_function_update" {
  function_name     = aws_lambda_function.example.function_name
  update_runtime_on = "FunctionUpdate"
}

# ┌────────────────────────────────────────────────────────────────────────────┐
# │ Example 2: Manual Runtime Update                                           │
# └────────────────────────────────────────────────────────────────────────────┘
# Manual control over runtime updates with specific runtime version ARN
resource "aws_lambda_runtime_management_config" "example_manual" {
  function_name     = aws_lambda_function.example.function_name
  update_runtime_on = "Manual"

  # Runtime version ARN's contain a hashed value (not the friendly runtime name)
  # There are currently no API's to retrieve this ARN, but the value can be
  # copied from the "Runtime settings" section of a function in the AWS console
  runtime_version_arn = "arn:aws:lambda:us-east-1::runtime:abcd1234"
}

# ┌────────────────────────────────────────────────────────────────────────────┐
# │ Example 3: Auto Update Mode (Default)                                      │
# └────────────────────────────────────────────────────────────────────────────┘
# Lambda automatically updates the runtime
resource "aws_lambda_runtime_management_config" "example_auto" {
  function_name     = aws_lambda_function.example.function_name
  update_runtime_on = "Auto"
}

# ┌────────────────────────────────────────────────────────────────────────────┐
# │ Example 4: With Qualifier (Specific Version)                               │
# └────────────────────────────────────────────────────────────────────────────┘
# Manage runtime configuration for a specific function version
resource "aws_lambda_runtime_management_config" "example_versioned" {
  function_name     = aws_lambda_function.example.function_name
  qualifier         = "1"  # Published version number or $LATEST
  update_runtime_on = "FunctionUpdate"
}

# ┌────────────────────────────────────────────────────────────────────────────┐
# │ Example 5: Cross-Region Configuration                                      │
# └────────────────────────────────────────────────────────────────────────────┘
# Manage runtime configuration in a specific region
resource "aws_lambda_runtime_management_config" "example_cross_region" {
  function_name     = aws_lambda_function.example.function_name
  region            = "us-west-2"
  update_runtime_on = "FunctionUpdate"
}

# ┌────────────────────────────────────────────────────────────────────────────┐
# │ Example 6: Complete Configuration with All Options                         │
# └────────────────────────────────────────────────────────────────────────────┘
resource "aws_lambda_runtime_management_config" "example_complete" {
  # Required Arguments
  # ──────────────────────────────────────────────────────────────────────────

  # function_name - (Required) Name or ARN of the Lambda function
  # Type: string
  # Update: Replacement
  function_name = aws_lambda_function.example.function_name

  # Optional Arguments
  # ──────────────────────────────────────────────────────────────────────────

  # qualifier - (Optional) Version of the function
  # Type: string
  # Default: Manages runtime configuration for $LATEST
  # Valid values: $LATEST or a published version number
  # Update: Replacement
  # Note: If omitted, this resource will manage the runtime configuration for $LATEST
  qualifier = "$LATEST"

  # region - (Optional) Region where this resource will be managed
  # Type: string
  # Default: Region set in the provider configuration
  # Update: Replacement
  # Reference: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = "us-east-1"

  # runtime_version_arn - (Optional) ARN of the runtime version
  # Type: string
  # Default: null
  # Update: No interruption
  # Note: Only required when update_runtime_on is Manual
  # Note: Runtime version ARNs contain a hashed value (not the friendly runtime name)
  # Note: There are currently no APIs to retrieve this ARN
  # Note: The value can be copied from the "Runtime settings" section in AWS console
  runtime_version_arn = "arn:aws:lambda:us-east-1::runtime:abcd1234"

  # update_runtime_on - (Optional) Runtime update mode
  # Type: string
  # Default: Auto (when a function is created)
  # Valid values: Auto, FunctionUpdate, Manual
  # Update: No interruption
  # - Auto: Lambda automatically updates the runtime
  # - FunctionUpdate: Runtime updates only when function code is updated
  # - Manual: Requires manual specification of runtime_version_arn
  update_runtime_on = "Manual"
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Computed Attributes Reference
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# The following attributes are exported in addition to the arguments listed above:
#
# - function_arn - ARN of the function
#
# Example Output Usage:
# output "function_arn" {
#   value = aws_lambda_runtime_management_config.example_complete.function_arn
# }

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Import
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Lambda Runtime Management Config can be imported using the function_name or
# function_name:qualifier, e.g.,
#
# Import without qualifier ($LATEST):
# $ terraform import aws_lambda_runtime_management_config.example my_function
#
# Import with qualifier:
# $ terraform import aws_lambda_runtime_management_config.example my_function:1

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Attribute Schema Details
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Attribute            | Type   | Required | Computed | Optional | Description
# ────────────────────────────────────────────────────────────────────────────
# function_arn         | string | No       | Yes      | No       | ARN of the function
# function_name        | string | Yes      | No       | No       | Name or ARN of the Lambda function
# qualifier            | string | No       | No       | Yes      | Version of the function ($LATEST or version number)
# region               | string | No       | Yes      | Yes      | Region where this resource will be managed
# runtime_version_arn  | string | No       | No       | Yes      | ARN of the runtime version (required for Manual mode)
# update_runtime_on    | string | No       | No       | Yes      | Runtime update mode (Auto, FunctionUpdate, Manual)

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Best Practices & Important Notes
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#
# 1. Default Behavior:
#    - When a function is created, the default update_runtime_on mode is Auto
#    - Deleting this resource returns the runtime update mode to Auto
#
# 2. Manual Mode Requirements:
#    - When using update_runtime_on = "Manual", runtime_version_arn is required
#    - Runtime version ARNs contain a hashed value, not the friendly runtime name
#    - No API exists to retrieve runtime version ARNs programmatically
#    - Copy the ARN from "Runtime settings" in the AWS Console
#
# 3. Update Modes:
#    - Auto: Lambda automatically updates the runtime (default)
#    - FunctionUpdate: Runtime updates only when function code is updated
#    - Manual: Requires explicit runtime_version_arn specification
#
# 4. Versioning:
#    - Use qualifier to manage runtime config for specific function versions
#    - Omitting qualifier manages the configuration for $LATEST
#    - Valid qualifiers: $LATEST or published version numbers
#
# 5. Resource Removal:
#    - Standard deletion returns to Auto mode
#    - To preserve configuration on destroy, use a removed block with
#      destroy lifecycle set to false
#
# 6. Cross-Region Management:
#    - Use the region parameter to manage functions in different regions
#    - Defaults to the provider's configured region if not specified
#
# 7. Import Considerations:
#    - Import without qualifier manages $LATEST
#    - Use function_name:qualifier format for specific versions
#
# 8. Update Behavior:
#    - Changes to function_name, qualifier, or region require replacement
#    - Changes to runtime_version_arn and update_runtime_on have no interruption
#
# 9. Documentation References:
#    - Supported runtimes: https://docs.aws.amazon.com/lambda/latest/dg/lambda-runtimes.html
#    - Regional endpoints: https://docs.aws.amazon.com/general/latest/gr/rande.html
#
# 10. Security Considerations:
#     - Monitor runtime updates for security patches
#     - Use FunctionUpdate or Manual mode for controlled deployments
#     - Test runtime updates in non-production environments first
