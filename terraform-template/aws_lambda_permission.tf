################################################################################
# AWS Lambda Permission - Annotated Reference
################################################################################
# Purpose:
#   Manages AWS Lambda function permissions for external services and accounts.
#   Allows AWS services (EventBridge, SNS, API Gateway, S3, etc.) or other AWS
#   accounts to invoke your Lambda functions.
#
# Use Cases:
#   - Grant EventBridge/CloudWatch Events permission to invoke Lambda
#   - Allow SNS topics to trigger Lambda functions
#   - Enable API Gateway to invoke Lambda functions
#   - Allow S3 buckets to trigger Lambda on object events
#   - Grant cross-account Lambda invocation access
#   - Enable CloudWatch Logs to invoke Lambda for log processing
#   - Configure Lambda Function URL with cross-account access
#
# Important Notes:
#   - Permissions are attached to the Lambda function's resource-based policy
#   - Each permission needs a unique statement_id within a function
#   - For API Gateway, use execution ARN with /* to allow all stages/methods
#   - CloudWatch Logs principals are regional (e.g., logs.us-east-1.amazonaws.com)
#   - Function URL invocations require special action: lambda:InvokeFunctionUrl
#   - Use qualifier to grant permission to specific version or alias
#   - principal_org_id allows granting permission to entire AWS Organization
#
# Provider Version: 6.28.0
################################################################################

resource "aws_lambda_permission" "example" {

  ################################################################################
  # Required Arguments
  ################################################################################

  # action (Required)
  # The AWS Lambda action that external sources are allowed to perform
  # Common values:
  #   - "lambda:InvokeFunction" - Standard function invocation (most common)
  #   - "lambda:InvokeFunctionUrl" - Function URL invocation (requires function_url_auth_type)
  # Type: string
  # Constraints: Must be valid Lambda API action
  # Example: "lambda:InvokeFunction"
  action = "lambda:InvokeFunction"

  # function_name (Required)
  # Name or ARN of the Lambda function to grant permission to
  # Can be:
  #   - Function name (e.g., "my-function")
  #   - Function ARN (e.g., "arn:aws:lambda:us-east-1:123456789012:function:my-function")
  #   - Partial ARN (e.g., "123456789012:function:my-function")
  # Type: string
  # Note: Can reference aws_lambda_function.example.function_name
  # Example: "my-lambda-function"
  function_name = "my-lambda-function"

  # principal (Required)
  # The AWS service or AWS account principal that can invoke the function
  # Common AWS service principals:
  #   - "events.amazonaws.com" - EventBridge/CloudWatch Events
  #   - "sns.amazonaws.com" - SNS topics
  #   - "s3.amazonaws.com" - S3 buckets
  #   - "apigateway.amazonaws.com" - API Gateway
  #   - "logs.amazonaws.com" - CloudWatch Logs (include region for Logs)
  #   - "logs.{region}.amazonaws.com" - Regional CloudWatch Logs
  #   - "elasticloadbalancing.amazonaws.com" - Application Load Balancer
  #   - "iot.amazonaws.com" - AWS IoT
  # For cross-account access:
  #   - AWS account ID (e.g., "123456789012")
  #   - IAM role ARN (e.g., "arn:aws:iam::123456789012:role/MyRole")
  # Type: string
  # Example: "events.amazonaws.com"
  principal = "events.amazonaws.com"

  ################################################################################
  # Optional Arguments
  ################################################################################

  # event_source_token (Optional)
  # Event source token to validate the request
  # Only used with Alexa Skills Kit and Alexa Smart Home skills
  # Type: string
  # Default: null
  # Example: "amzn1.ask.skill.xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  # event_source_token = null

  # function_url_auth_type (Optional)
  # Lambda Function URL authentication type
  # Required when action = "lambda:InvokeFunctionUrl"
  # Valid values:
  #   - "AWS_IAM" - IAM authentication required
  #   - "NONE" - No authentication (public access)
  # Type: string
  # Default: null
  # Example: "AWS_IAM"
  # function_url_auth_type = null

  # principal_org_id (Optional)
  # AWS Organizations ID to grant permission to all accounts in the organization
  # Use this to allow any account in your organization to invoke the function
  # Type: string
  # Format: "o-xxxxxxxxxx"
  # Default: null
  # Example: "o-1234567890"
  # principal_org_id = null

  # qualifier (Optional)
  # Lambda function version or alias name to grant permission to
  # If not specified, permission applies to $LATEST version
  # Use to grant permission only to specific version or alias
  # Type: string
  # Common values: alias name, version number, or "$LATEST"
  # Default: null
  # Example: "production" or "1" or "$LATEST"
  # qualifier = null

  # region (Optional)
  # AWS region where this Lambda permission will be managed
  # Type: string
  # Default: Provider region
  # Computed: Yes (defaults to provider configuration)
  # Example: "us-east-1"
  # region = null

  # source_account (Optional)
  # AWS account ID of the source owner
  # Required for S3 bucket permissions to prevent confused deputy problem
  # Recommended for cross-account access and certain AWS services
  # Type: string
  # Format: 12-digit AWS account ID
  # Default: null
  # Example: "123456789012"
  # source_account = null

  # source_arn (Optional)
  # ARN of the specific AWS resource that can invoke the function
  # Restricts invocation to a specific resource instance
  # Common uses:
  #   - EventBridge rule ARN
  #   - SNS topic ARN
  #   - S3 bucket ARN
  #   - API Gateway execution ARN (use /* suffix for all stages/methods)
  #   - CloudWatch log group ARN (use :* suffix)
  # Type: string
  # Default: null
  # Examples:
  #   - EventBridge: "arn:aws:events:us-east-1:123456789012:rule/my-rule"
  #   - SNS: "arn:aws:sns:us-east-1:123456789012:my-topic"
  #   - API Gateway: "arn:aws:execute-api:us-east-1:123456789012:abc123/*"
  #   - CloudWatch Logs: "arn:aws:logs:us-east-1:123456789012:log-group:/aws/lambda/my-function:*"
  # source_arn = null

  # statement_id (Optional)
  # Unique identifier for the permission statement
  # Must be unique within the function's policy
  # If not provided, Terraform generates one automatically
  # Conflicts with statement_id_prefix
  # Type: string
  # Default: Generated by Terraform
  # Computed: Yes
  # Pattern: alphanumeric, hyphens, underscores
  # Example: "AllowExecutionFromEventBridge"
  # statement_id = null

  # statement_id_prefix (Optional)
  # Prefix for auto-generated statement ID
  # Terraform will append random characters to create unique statement_id
  # Conflicts with statement_id
  # Type: string
  # Default: null
  # Computed: Yes (with random suffix)
  # Example: "AllowExecution-"
  # statement_id_prefix = null

  ################################################################################
  # Computed Attributes (Read-Only)
  ################################################################################

  # The following attributes are computed by AWS and cannot be set:
  #
  # id - Unique identifier of the Lambda permission
  #      Format: function_name/statement_id or function_name:qualifier/statement_id
  #
  # statement_id - Final statement identifier (if auto-generated or prefixed)
  #
  # region - AWS region where the permission is managed (if not specified)

  ################################################################################
  # Common Configuration Examples
  ################################################################################

  # Example 1: EventBridge Rule Integration
  # resource "aws_lambda_permission" "allow_eventbridge" {
  #   statement_id  = "AllowExecutionFromEventBridge"
  #   action        = "lambda:InvokeFunction"
  #   function_name = aws_lambda_function.example.function_name
  #   principal     = "events.amazonaws.com"
  #   source_arn    = aws_cloudwatch_event_rule.example.arn
  # }

  # Example 2: SNS Topic Integration
  # resource "aws_lambda_permission" "allow_sns" {
  #   statement_id  = "AllowExecutionFromSNS"
  #   action        = "lambda:InvokeFunction"
  #   function_name = aws_lambda_function.example.function_name
  #   principal     = "sns.amazonaws.com"
  #   source_arn    = aws_sns_topic.example.arn
  # }

  # Example 3: API Gateway Integration (all stages and methods)
  # resource "aws_lambda_permission" "allow_api_gateway" {
  #   statement_id  = "AllowAPIGatewayInvoke"
  #   action        = "lambda:InvokeFunction"
  #   function_name = aws_lambda_function.example.function_name
  #   principal     = "apigateway.amazonaws.com"
  #   source_arn    = "${aws_api_gateway_rest_api.example.execution_arn}/*"
  # }

  # Example 4: S3 Bucket Integration (with source_account for security)
  # resource "aws_lambda_permission" "allow_s3" {
  #   statement_id  = "AllowExecutionFromS3"
  #   action        = "lambda:InvokeFunction"
  #   function_name = aws_lambda_function.example.function_name
  #   principal     = "s3.amazonaws.com"
  #   source_arn    = aws_s3_bucket.example.arn
  #   source_account = data.aws_caller_identity.current.account_id
  # }

  # Example 5: CloudWatch Logs Integration (regional principal)
  # resource "aws_lambda_permission" "allow_cloudwatch_logs" {
  #   action        = "lambda:InvokeFunction"
  #   function_name = aws_lambda_function.example.function_name
  #   principal     = "logs.us-east-1.amazonaws.com"
  #   source_arn    = "${aws_cloudwatch_log_group.example.arn}:*"
  # }

  # Example 6: Cross-Account Access with specific IAM role
  # resource "aws_lambda_permission" "allow_cross_account" {
  #   statement_id   = "AllowCrossAccountInvoke"
  #   action         = "lambda:InvokeFunction"
  #   function_name  = aws_lambda_function.example.function_name
  #   principal      = "arn:aws:iam::123456789012:role/RemoteRole"
  #   source_account = "123456789012"
  # }

  # Example 7: Lambda Function URL with IAM authentication
  # resource "aws_lambda_permission" "allow_function_url" {
  #   action                 = "lambda:InvokeFunctionUrl"
  #   function_name          = aws_lambda_function.example.function_name
  #   principal              = "arn:aws:iam::123456789012:role/RemoteRole"
  #   source_account         = "123456789012"
  #   function_url_auth_type = "AWS_IAM"
  # }

  # Example 8: Permission for specific Lambda alias
  # resource "aws_lambda_permission" "allow_with_qualifier" {
  #   statement_id  = "AllowExecutionFromEventBridge"
  #   action        = "lambda:InvokeFunction"
  #   function_name = aws_lambda_function.example.function_name
  #   principal     = "events.amazonaws.com"
  #   source_arn    = aws_cloudwatch_event_rule.example.arn
  #   qualifier     = aws_lambda_alias.production.name
  # }

  # Example 9: AWS Organization-wide permission
  # resource "aws_lambda_permission" "allow_org" {
  #   statement_id     = "AllowOrganizationInvoke"
  #   action           = "lambda:InvokeFunction"
  #   function_name    = aws_lambda_function.example.function_name
  #   principal        = "*"
  #   principal_org_id = "o-1234567890"
  # }

  # Example 10: Auto-update permission when function changes
  # resource "aws_lambda_permission" "auto_update" {
  #   action        = "lambda:InvokeFunction"
  #   function_name = aws_lambda_function.example.function_name
  #   principal     = "events.amazonaws.com"
  #   source_arn    = aws_cloudwatch_event_rule.example.arn
  #
  #   lifecycle {
  #     replace_triggered_by = [
  #       aws_lambda_function.example
  #     ]
  #   }
  # }

  ################################################################################
  # Best Practices & Security Recommendations
  ################################################################################
  # 1. Always use statement_id for consistent permission management
  # 2. Specify source_arn whenever possible to limit scope of permission
  # 3. Use source_account with S3 to prevent confused deputy attacks
  # 4. For CloudWatch Logs, always include region in principal
  # 5. For API Gateway, use execution_arn with /* suffix
  # 6. Consider using qualifier for blue/green deployments
  # 7. Use principal_org_id for organization-wide sharing
  # 8. For Function URLs, always specify function_url_auth_type
  # 9. Avoid using "*" as principal unless with principal_org_id
  # 10. Document the purpose of each permission with clear statement_id

  ################################################################################
  # Lifecycle Management
  ################################################################################
  # - Permissions are deleted automatically when Lambda function is deleted
  # - Use replace_triggered_by to recreate permission when function changes
  # - Statement IDs must be unique within the function
  # - Changing statement_id forces resource replacement

  ################################################################################
  # Common Errors & Troubleshooting
  ################################################################################
  # Error: ResourceConflictException
  #   Cause: statement_id already exists
  #   Solution: Use unique statement_id or statement_id_prefix
  #
  # Error: ResourceNotFoundException
  #   Cause: Lambda function doesn't exist
  #   Solution: Ensure function is created first, use depends_on if needed
  #
  # Error: Invalid principal
  #   Cause: Incorrect service principal format
  #   Solution: Use correct format (e.g., logs.{region}.amazonaws.com for CloudWatch Logs)
  #
  # Error: Access denied when invoking
  #   Cause: Permission exists but source_arn doesn't match actual source
  #   Solution: Verify source_arn matches the invoking resource exactly

  ################################################################################
  # Related Resources
  ################################################################################
  # - aws_lambda_function - Lambda function to grant permission to
  # - aws_lambda_alias - Lambda alias for versioned permissions
  # - aws_lambda_function_url - Lambda Function URL configuration
  # - aws_cloudwatch_event_rule - EventBridge rule configuration
  # - aws_sns_topic - SNS topic configuration
  # - aws_api_gateway_rest_api - API Gateway REST API
  # - aws_s3_bucket_notification - S3 event notification configuration

  ################################################################################
  # Official Documentation
  ################################################################################
  # AWS Lambda Permissions: https://docs.aws.amazon.com/lambda/latest/dg/access-control-resource-based.html
  # Terraform AWS Provider: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission
  # AWS Lambda AddPermission API: https://docs.aws.amazon.com/lambda/latest/api/API_AddPermission.html
}
