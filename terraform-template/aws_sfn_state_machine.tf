################################################################################
# AWS Step Functions State Machine
################################################################################
# Provider Version: 6.28.0
# Resource: aws_sfn_state_machine
# Documentation: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/sfn_state_machine
#
# Description:
# Provides a Step Function State Machine resource for orchestrating AWS services
# through state machines defined in Amazon States Language (ASL).
#
# Key Features:
# - Supports both STANDARD and EXPRESS workflow types
# - Configurable logging with CloudWatch integration
# - Encryption support with AWS KMS
# - X-Ray tracing for monitoring and debugging
# - Version publishing capabilities
################################################################################

resource "aws_sfn_state_machine" "this" {
  # ============================================================================
  # Required Arguments
  # ============================================================================

  # definition - (Required) The Amazon States Language definition of the state machine
  # Type: string
  # The state machine definition in JSON format following Amazon States Language specification.
  # Supports embedded Terraform expressions for dynamic resource references.
  # Ref: https://docs.aws.amazon.com/step-functions/latest/dg/concepts-amazon-states-language.html
  definition = <<EOF
{
  "Comment": "A Hello World example of the Amazon States Language using an AWS Lambda Function",
  "StartAt": "HelloWorld",
  "States": {
    "HelloWorld": {
      "Type": "Task",
      "Resource": "${aws_lambda_function.example.arn}",
      "End": true
    }
  }
}
EOF

  # role_arn - (Required) The Amazon Resource Name (ARN) of the IAM role to use for this state machine
  # Type: string
  # The IAM role must have permissions to execute the actions defined in the state machine,
  # such as invoking Lambda functions, accessing DynamoDB tables, or publishing to SNS topics.
  # The role must also have a trust relationship allowing Step Functions to assume it.
  role_arn = aws_iam_role.sfn_role.arn

  # ============================================================================
  # Optional Arguments - Basic Configuration
  # ============================================================================

  # name - (Optional) The name of the state machine
  # Type: string
  # Default: Terraform will assign a random, unique name if omitted
  # Constraints: Should only contain 0-9, A-Z, a-z, - and _
  # Conflicts with: name_prefix
  name = "my-state-machine"

  # name_prefix - (Optional) Creates a unique name beginning with the specified prefix
  # Type: string
  # Conflicts with: name
  # Use this when you want Terraform to generate a unique name with a consistent prefix
  # name_prefix = "my-prefix-"

  # type - (Optional) Determines whether a Standard or Express state machine is created
  # Type: string
  # Default: "STANDARD"
  # Valid values: "STANDARD", "EXPRESS"
  # Note: You cannot update the type of a state machine once it has been created
  #
  # STANDARD: For long-running, durable, and auditable workflows
  # - Execution history is stored for up to 90 days
  # - Exactly-once workflow execution
  # - Supports all service integrations
  # - Execution rate: Up to 2,000 per second
  # - Maximum execution time: 1 year
  #
  # EXPRESS: For high-volume, event processing workloads
  # - Execution history is not stored unless logging is configured
  # - At-least-once workflow execution
  # - Higher execution rate: Up to 100,000 per second
  # - Maximum execution time: 5 minutes
  # - Lower cost per execution
  type = "STANDARD"

  # region - (Optional) Region where this resource will be managed
  # Type: string
  # Default: Region set in the provider configuration
  # Ref: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # Use this to explicitly specify a region different from the provider's default region
  # region = "us-east-1"

  # publish - (Optional) Set to true to publish a version of the state machine during creation
  # Type: bool
  # Default: false
  # When enabled, creates a numbered, immutable version of the state machine
  # Useful for tracking changes and supporting gradual rollouts
  # publish = true

  # tags - (Optional) Key-value map of resource tags
  # Type: map(string)
  # Tags applied to the state machine for organization, cost allocation, and access control
  # If configured with a provider default_tags configuration block, tags with matching keys
  # will overwrite those defined at the provider-level
  tags = {
    Name        = "my-state-machine"
    Environment = "production"
    ManagedBy   = "terraform"
  }

  # ============================================================================
  # Optional Block - Logging Configuration
  # ============================================================================
  # Valid when type is set to STANDARD or EXPRESS
  # Default: OFF (no logging)
  # Defines what execution history events are logged and where they are logged
  # Ref: https://docs.aws.amazon.com/step-functions/latest/dg/cw-logs.html

  logging_configuration {
    # log_destination - (Optional) Amazon Resource Name (ARN) of a CloudWatch log group
    # Type: string
    # Format: ARN must end with `:*`
    # Example: "arn:aws:logs:us-east-1:123456789012:log-group:/aws/vendedlogs/states/my-log-group:*"
    # Note: Ensure the State Machine IAM role has permissions to write to CloudWatch Logs
    log_destination = "${aws_cloudwatch_log_group.sfn_logs.arn}:*"

    # include_execution_data - (Optional) Determines whether execution data is included in your log
    # Type: bool
    # Default: Not specified (AWS default behavior)
    # When set to false, data is excluded from logs
    # Set to false for sensitive data to comply with security requirements
    include_execution_data = true

    # level - (Optional) Defines which category of execution history events are logged
    # Type: string
    # Valid values: "ALL", "ERROR", "FATAL", "OFF"
    # Default: Not specified
    #
    # ALL: Log all execution events
    # ERROR: Log only when an error occurs
    # FATAL: Log only when the execution fails completely
    # OFF: Turn off logging
    #
    # Ref: https://docs.aws.amazon.com/step-functions/latest/dg/cloudwatch-log-level.html
    level = "ERROR"
  }

  # ============================================================================
  # Optional Block - Encryption Configuration
  # ============================================================================
  # Defines what encryption configuration is used to encrypt data in the State Machine
  # Encrypts data at rest in Step Functions, including execution history and state input/output

  encryption_configuration {
    # type - (Required) The encryption option specified for the state machine
    # Type: string
    # Valid values: "AWS_OWNED_KEY", "CUSTOMER_MANAGED_KMS_KEY"
    #
    # AWS_OWNED_KEY: Use AWS-owned encryption key (no additional cost)
    # CUSTOMER_MANAGED_KMS_KEY: Use customer-managed KMS key (provides more control)
    type = "CUSTOMER_MANAGED_KMS_KEY"

    # kms_key_id - (Optional) The alias, alias ARN, key ID, or key ARN of the symmetric encryption KMS key
    # Type: string
    # Required when type = "CUSTOMER_MANAGED_KMS_KEY"
    # To specify a KMS key in a different AWS account, use the key ARN or alias ARN
    # Ref: https://docs.aws.amazon.com/kms/latest/APIReference/API_DescribeKey.html#API_DescribeKey_RequestParameters
    kms_key_id = aws_kms_key.sfn_encryption.arn

    # kms_data_key_reuse_period_seconds - (Optional) Maximum duration for which Step Functions will reuse data keys
    # Type: number
    # Valid range: 60 to 900 seconds
    # Default: 300 seconds
    # When the period expires, Step Functions will call GenerateDataKey
    # Only applies when type = "CUSTOMER_MANAGED_KMS_KEY"
    # Lower values increase security but also increase KMS API calls and costs
    kms_data_key_reuse_period_seconds = 900
  }

  # ============================================================================
  # Optional Block - Tracing Configuration
  # ============================================================================
  # Selects whether AWS X-Ray tracing is enabled
  # X-Ray helps you analyze and debug distributed applications

  tracing_configuration {
    # enabled - (Optional) When set to true, AWS X-Ray tracing is enabled
    # Type: bool
    # Default: false
    # Note: Ensure the State Machine IAM role has the correct permissions for X-Ray
    # Ref: https://docs.aws.amazon.com/step-functions/latest/dg/xray-iam.html
    #
    # Required IAM permissions for X-Ray:
    # - xray:PutTraceSegments
    # - xray:PutTelemetryRecords
    enabled = true
  }

  # ============================================================================
  # Optional Block - Timeouts
  # ============================================================================
  # Configuration block for resource operation timeouts

  timeouts {
    # create - (Optional) How long to wait for state machine creation
    # Type: string
    # Default: 5 minutes
    # Format: Valid time duration string (e.g., "10m", "1h")
    create = "5m"

    # update - (Optional) How long to wait for state machine update
    # Type: string
    # Default: 1 minute
    update = "1m"

    # delete - (Optional) How long to wait for state machine deletion
    # Type: string
    # Default: 5 minutes
    delete = "5m"
  }
}

################################################################################
# Computed Attributes (Read-Only)
################################################################################
# These attributes are set by AWS and can be referenced after creation:
#
# id                         - The ARN of the state machine
# arn                        - The ARN of the state machine
# creation_date              - The date the state machine was created
# state_machine_version_arn  - The ARN of the state machine version (when publish = true)
# status                     - The current status of the state machine (ACTIVE or DELETING)
# tags_all                   - Map of tags assigned to the resource, including those inherited
#                             from the provider default_tags configuration block
# description                - The description of the state machine
# revision_id                - The revision identifier for the state machine
# version_description        - The description of the state machine version
#
# Usage examples:
# - Reference the ARN: aws_sfn_state_machine.this.arn
# - Check status: aws_sfn_state_machine.this.status
# - Get creation date: aws_sfn_state_machine.this.creation_date
################################################################################

################################################################################
# Example Outputs
################################################################################

output "state_machine_arn" {
  description = "The ARN of the Step Functions state machine"
  value       = aws_sfn_state_machine.this.arn
}

output "state_machine_id" {
  description = "The ID (ARN) of the Step Functions state machine"
  value       = aws_sfn_state_machine.this.id
}

output "state_machine_status" {
  description = "The current status of the state machine"
  value       = aws_sfn_state_machine.this.status
}

output "state_machine_creation_date" {
  description = "The date the state machine was created"
  value       = aws_sfn_state_machine.this.creation_date
}

output "state_machine_version_arn" {
  description = "The ARN of the state machine version (if publish = true)"
  value       = aws_sfn_state_machine.this.state_machine_version_arn
}

################################################################################
# Important Notes and Best Practices
################################################################################
#
# 1. State Machine Type Selection:
#    - Use STANDARD for:
#      * Long-running workflows (minutes to months)
#      * Workflows requiring exactly-once execution semantics
#      * Workflows needing detailed execution history
#      * Complex orchestrations with human approval steps
#
#    - Use EXPRESS for:
#      * High-volume event processing (IoT, streaming data)
#      * Short-duration workflows (< 5 minutes)
#      * Cost-sensitive applications with high throughput
#      * Workflows where at-least-once execution is acceptable
#
# 2. IAM Role Permissions:
#    The role_arn must have:
#    - Trust relationship allowing states.amazonaws.com to assume the role
#    - Permissions for all services accessed by the state machine
#    - Additional permissions if logging or X-Ray tracing is enabled
#
# 3. State Machine Definition:
#    - Must be valid Amazon States Language (ASL) JSON
#    - Can reference Terraform resources using interpolation
#    - Consider using templatefile() for complex definitions
#    - Validate ASL syntax using AWS Step Functions console or CLI
#
# 4. Logging Considerations:
#    - Logging is only available for STANDARD and EXPRESS state machines
#    - CloudWatch Logs incur additional costs
#    - Consider log retention policies to manage costs
#    - Set include_execution_data = false for sensitive data
#
# 5. Encryption:
#    - Customer-managed KMS keys provide more control but increase costs
#    - Ensure KMS key policy allows Step Functions to use the key
#    - Consider key rotation policies for compliance requirements
#
# 6. X-Ray Tracing:
#    - Useful for debugging and performance analysis
#    - Incurs additional AWS X-Ray costs
#    - Provides detailed insights into state transitions and service calls
#
# 7. Versioning:
#    - Set publish = true to create immutable versions
#    - Useful for gradual rollouts and rollback capabilities
#    - Each version has a unique ARN
#
# 8. Name Conflicts:
#    - State machine names must be unique within an AWS account and region
#    - Use name_prefix for automatic unique naming
#    - Use name for explicit, predictable naming
#
# 9. Updates and Immutability:
#    - The type attribute cannot be changed after creation
#    - Changing type requires resource replacement
#    - Plan carefully when choosing between STANDARD and EXPRESS
#
# 10. Cost Optimization:
#     - EXPRESS state machines are more cost-effective for high-volume workloads
#     - Consider log level and retention to optimize CloudWatch costs
#     - Monitor state transitions as they are billed per transition
#
################################################################################

################################################################################
# Related AWS Resources
################################################################################
# Commonly used with:
# - aws_iam_role - IAM role for state machine execution
# - aws_iam_role_policy - Inline policy for the IAM role
# - aws_iam_role_policy_attachment - Managed policy attachment
# - aws_cloudwatch_log_group - CloudWatch log group for logging
# - aws_kms_key - KMS key for encryption
# - aws_lambda_function - Lambda functions invoked by the state machine
# - aws_dynamodb_table - DynamoDB tables accessed by the state machine
# - aws_sqs_queue - SQS queues for event-driven workflows
# - aws_sns_topic - SNS topics for notifications
# - aws_sfn_state_machine_alias - Alias for state machine versions
################################################################################

################################################################################
# Example IAM Role for State Machine
################################################################################
# This is a basic example of an IAM role for Step Functions
# Adjust permissions based on your specific state machine requirements

# resource "aws_iam_role" "sfn_role" {
#   name = "sfn-state-machine-role"
#
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Principal = {
#           Service = "states.amazonaws.com"
#         }
#       }
#     ]
#   })
#
#   tags = {
#     Name = "sfn-state-machine-role"
#   }
# }
#
# # Policy for invoking Lambda functions
# resource "aws_iam_role_policy" "sfn_lambda_policy" {
#   name = "sfn-lambda-policy"
#   role = aws_iam_role.sfn_role.id
#
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Action = [
#           "lambda:InvokeFunction"
#         ]
#         Resource = "*"
#       }
#     ]
#   })
# }
#
# # Policy for CloudWatch Logs (if logging is enabled)
# resource "aws_iam_role_policy" "sfn_cloudwatch_policy" {
#   name = "sfn-cloudwatch-policy"
#   role = aws_iam_role.sfn_role.id
#
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Action = [
#           "logs:CreateLogDelivery",
#           "logs:GetLogDelivery",
#           "logs:UpdateLogDelivery",
#           "logs:DeleteLogDelivery",
#           "logs:ListLogDeliveries",
#           "logs:PutResourcePolicy",
#           "logs:DescribeResourcePolicies",
#           "logs:DescribeLogGroups"
#         ]
#         Resource = "*"
#       }
#     ]
#   })
# }
#
# # Policy for X-Ray (if tracing is enabled)
# resource "aws_iam_role_policy" "sfn_xray_policy" {
#   name = "sfn-xray-policy"
#   role = aws_iam_role.sfn_role.id
#
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Action = [
#           "xray:PutTraceSegments",
#           "xray:PutTelemetryRecords",
#           "xray:GetSamplingRules",
#           "xray:GetSamplingTargets"
#         ]
#         Resource = "*"
#       }
#     ]
#   })
# }

################################################################################
# Example CloudWatch Log Group
################################################################################
# resource "aws_cloudwatch_log_group" "sfn_logs" {
#   name              = "/aws/vendedlogs/states/my-state-machine"
#   retention_in_days = 7
#
#   tags = {
#     Name = "sfn-state-machine-logs"
#   }
# }

################################################################################
# Example KMS Key for Encryption
################################################################################
# resource "aws_kms_key" "sfn_encryption" {
#   description             = "KMS key for Step Functions state machine encryption"
#   deletion_window_in_days = 10
#   enable_key_rotation     = true
#
#   tags = {
#     Name = "sfn-state-machine-key"
#   }
# }
#
# resource "aws_kms_alias" "sfn_encryption" {
#   name          = "alias/sfn-state-machine"
#   target_key_id = aws_kms_key.sfn_encryption.key_id
# }

################################################################################
# Additional Resources and References
################################################################################
# AWS Step Functions Documentation:
# - User Guide: https://docs.aws.amazon.com/step-functions/latest/dg/
# - API Reference: https://docs.aws.amazon.com/step-functions/latest/apireference/
# - Amazon States Language: https://states-language.net/spec.html
# - Best Practices: https://docs.aws.amazon.com/step-functions/latest/dg/best-practices.html
# - Service Integrations: https://docs.aws.amazon.com/step-functions/latest/dg/concepts-service-integrations.html
#
# Terraform Documentation:
# - Resource: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sfn_state_machine
# - Data Source: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/sfn_state_machine
################################################################################
