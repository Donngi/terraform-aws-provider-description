################################################################################
# AWS Lambda Code Signing Configuration
################################################################################
# This resource manages an AWS Lambda Code Signing Config to define allowed
# signing profiles and code-signing validation policies for Lambda functions.
# Code signing ensures code integrity and authenticity by verifying that Lambda
# function code is signed by a trusted source before deployment.
#
# Use Cases:
# - Enforce code signing for production Lambda functions to prevent unauthorized code
# - Implement multi-environment signing policies (strict for prod, flexible for dev)
# - Ensure compliance with security policies requiring signed code artifacts
# - Block or warn on deployments that fail code signing validation
#
# Documentation:
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_code_signing_config
# https://docs.aws.amazon.com/lambda/latest/dg/configuration-codesigning.html
################################################################################

################################################################################
# Complete Example: Production Code Signing Configuration
################################################################################
# This example demonstrates a complete code signing setup with strict enforcement
# for production Lambda functions. It includes signing profiles and enforcement
# policies to block unsigned or improperly signed deployments.

# Create signing profile for production code signing
resource "aws_signer_signing_profile" "prod" {
  platform_id = "AWSLambda-SHA384-ECDSA" # AWS Lambda signing platform
  name_prefix = "prod_lambda_"

  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

# Production code signing configuration with strict enforcement
resource "aws_lambda_code_signing_config" "prod" {
  # REQUIRED: Description of this code signing configuration
  # This helps identify the purpose and scope of the configuration
  description = "Production code signing configuration with strict enforcement"

  # REQUIRED: Configuration block defining allowed publishers
  # Specifies which signing profiles are trusted to sign Lambda function code
  allowed_publishers {
    # REQUIRED: Set of ARNs for signing profiles (maximum 20)
    # Each ARN represents a trusted signing profile that can sign code packages
    # Use version ARN (not profile ARN) to ensure specific profile versions
    signing_profile_version_arns = [
      aws_signer_signing_profile.prod.version_arn, # Production signing profile
    ]
  }

  # OPTIONAL: Code signing policies defining validation failure actions
  # Controls what happens when code signing validation checks fail
  policies {
    # REQUIRED: Policy for deployment validation failure
    # - "Enforce": Blocks deployment if code-signing validation fails
    # - "Warn": Allows deployment but creates CloudWatch log warning
    # Default: "Warn"
    untrusted_artifact_on_deployment = "Enforce" # Block unsigned deployments
  }

  # OPTIONAL: Region where this resource will be managed
  # Defaults to the provider region if not specified
  # Uncomment to explicitly set the region
  # region = "us-east-1"

  # OPTIONAL: Tags for resource organization and cost tracking
  # Tags are inherited from provider default_tags if configured
  tags = {
    Environment = "production"
    Security    = "strict"
    Purpose     = "code-signing"
    ManagedBy   = "terraform"
  }
}

# Output the code signing configuration ARN for use with Lambda functions
output "prod_code_signing_config_arn" {
  description = "ARN of the production code signing configuration"
  value       = aws_lambda_code_signing_config.prod.arn
}

# Output the configuration ID
output "prod_code_signing_config_id" {
  description = "Unique identifier for the code signing configuration"
  value       = aws_lambda_code_signing_config.prod.config_id
}

################################################################################
# Example: Multi-Environment Code Signing Setup
################################################################################
# This example shows how to configure different signing policies for different
# environments (strict enforcement for production, warnings for development).

# Development signing profile
resource "aws_signer_signing_profile" "dev" {
  platform_id = "AWSLambda-SHA384-ECDSA"
  name_prefix = "dev_lambda_"

  tags = {
    Environment = "development"
    ManagedBy   = "terraform"
  }
}

# Test signing profile
resource "aws_signer_signing_profile" "test" {
  platform_id = "AWSLambda-SHA384-ECDSA"
  name_prefix = "test_lambda_"

  tags = {
    Environment = "test"
    ManagedBy   = "terraform"
  }
}

# Development code signing configuration with warning-only policy
resource "aws_lambda_code_signing_config" "dev" {
  description = "Development code signing configuration with warnings"

  allowed_publishers {
    # Allow both development and test signing profiles
    signing_profile_version_arns = [
      aws_signer_signing_profile.dev.version_arn,
      aws_signer_signing_profile.test.version_arn,
    ]
  }

  policies {
    # Warn on unsigned code but allow deployment
    # Useful for development environments where flexibility is needed
    untrusted_artifact_on_deployment = "Warn"
  }

  tags = {
    Environment = "development"
    Security    = "flexible"
    Purpose     = "code-signing"
    ManagedBy   = "terraform"
  }
}

################################################################################
# Example: Code Signing Config with Multiple Signing Profiles
################################################################################
# This example demonstrates allowing multiple signing profiles from different
# teams or departments while maintaining strict enforcement.

# Signing profiles for different teams
resource "aws_signer_signing_profile" "team_a" {
  platform_id = "AWSLambda-SHA384-ECDSA"
  name_prefix = "team_a_lambda_"

  tags = {
    Team      = "team-a"
    ManagedBy = "terraform"
  }
}

resource "aws_signer_signing_profile" "team_b" {
  platform_id = "AWSLambda-SHA384-ECDSA"
  name_prefix = "team_b_lambda_"

  tags = {
    Team      = "team-b"
    ManagedBy = "terraform"
  }
}

# Shared code signing configuration for multiple teams
resource "aws_lambda_code_signing_config" "multi_team" {
  description = "Code signing configuration for multiple teams"

  allowed_publishers {
    # Allow signing profiles from both teams
    # Up to 20 signing profiles can be specified
    signing_profile_version_arns = [
      aws_signer_signing_profile.team_a.version_arn,
      aws_signer_signing_profile.team_b.version_arn,
    ]
  }

  policies {
    untrusted_artifact_on_deployment = "Enforce"
  }

  tags = {
    Environment = "shared"
    Security    = "strict"
    ManagedBy   = "terraform"
  }
}

################################################################################
# Example: Associating Code Signing Config with Lambda Function
################################################################################
# This example shows how to use the code signing configuration with a Lambda function.

# Lambda function with code signing configuration
resource "aws_lambda_function" "signed_function" {
  filename         = "lambda_function.zip"
  function_name    = "signed-lambda-function"
  role            = "arn:aws:iam::123456789012:role/lambda-role" # Replace with actual role ARN
  handler         = "index.handler"
  runtime         = "python3.11"
  source_code_hash = filebase64sha256("lambda_function.zip")

  # Associate with code signing configuration
  # This enables code signing validation for this function
  code_signing_config_arn = aws_lambda_code_signing_config.prod.arn

  tags = {
    Environment = "production"
    CodeSigning = "enabled"
    ManagedBy   = "terraform"
  }
}

################################################################################
# Attribute Reference
################################################################################
# The following attributes are exported by this resource:
#
# - arn: ARN of the code signing configuration
#   Example: arn:aws:lambda:us-east-1:123456789012:code-signing-config:csc-1234567890abcdef0
#
# - config_id: Unique identifier for the code signing configuration
#   Example: csc-1234567890abcdef0
#
# - last_modified: Date and time that the code signing configuration was last modified
#   Example: 2024-01-15T10:30:00Z
#
# - tags_all: Map of all tags assigned to the resource, including those inherited
#   from the provider default_tags configuration block

################################################################################
# Important Notes
################################################################################
# 1. Code Signing Requirements:
#    - Lambda functions must be signed with AWS Signer before deployment
#    - Code signing is applied at deployment time, not runtime
#    - Unsigned or improperly signed code will be blocked if policy is "Enforce"
#
# 2. Signing Profile Versions:
#    - Always use signing_profile_version_arns (version ARN), not profile ARN
#    - Version ARNs ensure specific versions are used for validation
#    - Example: arn:aws:signer:us-east-1:123456789012:/signing-profiles/prod_lambda_/version
#
# 3. Policy Modes:
#    - "Enforce": Blocks deployments that fail validation (recommended for production)
#    - "Warn": Allows deployments but logs failures to CloudWatch (useful for development)
#
# 4. Maximum Limits:
#    - Up to 20 signing profile version ARNs per configuration
#    - Each signing profile can be used across multiple configurations
#
# 5. Region Considerations:
#    - Code signing configs are regional resources
#    - Signing profiles must be in the same region as the configuration
#    - Use the region argument to explicitly set the region if needed
#
# 6. Lambda Function Association:
#    - Associate code signing config with Lambda functions via code_signing_config_arn
#    - Once associated, all function updates must meet signing requirements
#    - Cannot remove code signing config from a function once enabled
#
# 7. Security Best Practices:
#    - Use "Enforce" mode for production environments
#    - Limit signing profiles to only trusted sources
#    - Regularly rotate signing profiles for security
#    - Monitor CloudWatch logs for validation failures
#    - Use separate signing profiles for different environments
#
# 8. Import:
#    - Code signing configurations can be imported using the ARN
#    - Example: terraform import aws_lambda_code_signing_config.prod arn:aws:lambda:us-east-1:123456789012:code-signing-config:csc-1234567890abcdef0
#
# 9. Provider Default Tags:
#    - Tags defined in provider default_tags will be automatically applied
#    - Resource-level tags with matching keys override provider default tags
#    - Use tags_all attribute to see all effective tags
