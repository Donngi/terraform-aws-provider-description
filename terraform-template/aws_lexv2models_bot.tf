################################################################################
# AWS Lex V2 Models Bot
################################################################################
# Terraform resource for managing an AWS Lex V2 Models Bot.
#
# Amazon Lex V2 is a service for building conversational interfaces using voice
# and text. A bot in Lex V2 is a conversational interface that can understand
# user inputs and respond accordingly. This resource creates and manages the
# bot configuration, including data privacy settings, IAM permissions, session
# timeouts, and bot networking capabilities.
#
# Key Features:
# - Data Privacy: COPPA compliance settings for child-directed applications
# - Session Management: Configurable idle session timeout (60-86400 seconds)
# - IAM Integration: Role-based access control for bot operations
# - Bot Networks: Ability to create networks of bots for enterprise use cases
# - Tagging: Support for resource and test alias tags
#
# Important Considerations:
# - Bot names must be unique within the AWS account
# - IAM role must have permissions for Amazon Lex V2 service
# - Session timeout determines how long user conversation data is retained
# - Tags can only be added during bot creation
# - Region can be specified to override provider default region
#
# Reference:
# - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lexv2models_bot
# - https://docs.aws.amazon.com/lexv2/latest/APIReference/API_CreateBot.html
# - https://docs.aws.amazon.com/lexv2/latest/dg/create-bot-console.html
################################################################################

resource "aws_lexv2models_bot" "example" {
  ##############################################################################
  # Required Arguments
  ##############################################################################

  # Name of the bot
  # - Must be unique within the AWS account that creates the bot
  # - Length: 1-100 characters
  # - Used to identify the bot in the console and API operations
  # - Cannot be changed after creation (requires replacement)
  name = "example-bot"

  # Data privacy configuration
  # - Defines privacy protections for the bot's data
  # - Required for COPPA compliance determination
  # - Contains child_directed setting (required)
  data_privacy {
    # Specifies if the bot is subject to COPPA (Children's Online Privacy Protection Act)
    # - Set to true if the bot is directed to children under 13
    # - Set to false if the bot is not directed to children
    # - Required by law for applications targeting children
    # - Affects data collection and retention policies
    child_directed = false
  }

  # Idle session timeout in seconds
  # - Time Amazon Lex retains user conversation information
  # - Range: 60 (1 minute) to 86,400 (24 hours) seconds
  # - After timeout, session data is cleared
  # - Lower values: Better privacy, may interrupt long conversations
  # - Higher values: Better user experience, more data retention
  # - Default behavior if not specified: 300 seconds (5 minutes)
  idle_session_ttl_in_seconds = 300

  # IAM role ARN for bot permissions
  # - Role must have permission to access the bot and related services
  # - Required trust relationship with lexv2.amazonaws.com service
  # - Should include policies for:
  #   - Amazon Lex V2 operations
  #   - CloudWatch Logs (for conversation logs)
  #   - Lambda (if using fulfillment)
  #   - Any other services the bot interacts with
  # - Example assume role policy shown in accompanying IAM role resource below
  role_arn = aws_iam_role.example.arn

  ##############################################################################
  # Optional Arguments
  ##############################################################################

  # Type of bot to create
  # - Valid values: "Bot" (default), "BotNetwork"
  # - "Bot": Standard single bot
  # - "BotNetwork": Network of bots for enterprise use cases
  #   - Allows managing multiple bots under single interface
  #   - Provides unified user experience across multiple bots
  #   - Currently only available in en-US language
  #   - Limited to one account
  # - Default: "Bot"
  type = "Bot"

  # Description of the bot
  # - Appears in lists to help identify the bot
  # - Optional but recommended for documentation
  # - Useful for team collaboration and bot management
  description = "Example Lex V2 bot for customer support"

  # AWS region override
  # - Specifies the region where this resource will be managed
  # - Defaults to the region set in provider configuration
  # - Useful for multi-region deployments
  # - Example: "us-east-1", "eu-west-1", "ap-southeast-2"
  # region = "us-east-1"

  # Bot members configuration (for BotNetwork type only)
  # - List of bots that are members of this network
  # - Only applicable when type = "BotNetwork"
  # - Each member requires: id, name, version, alias_id, alias_name
  # members {
  #   id         = aws_lexv2models_bot.member_bot.id
  #   name       = aws_lexv2models_bot.member_bot.name
  #   version    = "1"
  #   alias_id   = "TSTALIASID"
  #   alias_name = "TestBotAlias"
  # }

  # Resource tags
  # - Tags can only be added when creating a bot
  # - Cannot be modified after creation
  # - Used for organization, cost tracking, and access control
  # - Maximum 50 tags per resource
  tags = {
    Environment = "development"
    Project     = "customer-support"
    ManagedBy   = "terraform"
    CostCenter  = "engineering"
  }

  # Test bot alias tags
  # - Tags for the test alias automatically created with the bot
  # - Can only be added during bot creation
  # - Managed separately from bot tags
  # - Useful for distinguishing test vs production aliases
  test_bot_alias_tags = {
    Environment = "test"
    Purpose     = "automated-testing"
  }
}

##############################################################################
# Supporting IAM Role
##############################################################################
# IAM role that grants Amazon Lex V2 permissions to operate the bot
# This role is required for the bot to function properly

resource "aws_iam_role" "example" {
  name        = "example-lexv2-bot-role"
  description = "IAM role for Amazon Lex V2 bot to access required services"

  # Trust relationship allowing Lex V2 service to assume this role
  # - Principal: lexv2.amazonaws.com
  # - Action: sts:AssumeRole
  # - Required for Lex V2 to act on behalf of your account
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = "AllowLexV2AssumeRole"
        Principal = {
          Service = "lexv2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Environment = "development"
    ManagedBy   = "terraform"
    Service     = "lexv2"
  }
}

# Attach policies to the IAM role as needed
# Example: Attach CloudWatch Logs policy for conversation logging
# resource "aws_iam_role_policy_attachment" "cloudwatch_logs" {
#   role       = aws_iam_role.example.name
#   policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
# }

# Example: Attach Lambda invoke policy for fulfillment
# resource "aws_iam_role_policy_attachment" "lambda_invoke" {
#   role       = aws_iam_role.example.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaRole"
# }

##############################################################################
# Outputs
##############################################################################

output "bot_id" {
  description = "Unique identifier for the bot"
  value       = aws_lexv2models_bot.example.id
}

output "bot_name" {
  description = "Name of the bot"
  value       = aws_lexv2models_bot.example.name
}

output "bot_role_arn" {
  description = "ARN of the IAM role associated with the bot"
  value       = aws_lexv2models_bot.example.role_arn
}

##############################################################################
# Additional Notes
##############################################################################
# 1. Bot Lifecycle:
#    - After creation, add languages and intents to make the bot functional
#    - Build the bot after adding language configurations
#    - Create aliases for different deployment stages (test, staging, production)
#    - Use versions to manage bot changes over time
#
# 2. Data Privacy and COPPA:
#    - COPPA applies to websites/services directed to children under 13
#    - child_directed=true triggers additional privacy protections
#    - Consider legal requirements when setting this value
#    - Consult legal counsel for COPPA compliance questions
#
# 3. Session Management:
#    - idle_session_ttl_in_seconds affects user experience and privacy
#    - Shorter timeouts: Better privacy, less memory usage
#    - Longer timeouts: Better UX for slow-paced conversations
#    - Consider your use case when setting timeout value
#
# 4. IAM Permissions:
#    - The role_arn must have appropriate permissions for:
#      - Lex V2 operations (building, publishing, updating bot)
#      - CloudWatch Logs (if conversation logging enabled)
#      - Lambda (if using fulfillment functions)
#      - Polly (if using voice interactions)
#      - Comprehend (if using sentiment analysis)
#    - Use least privilege principle when defining policies
#
# 5. Bot Networks:
#    - BotNetwork type allows enterprise to manage multiple bots
#    - Provides unified interface for related bots
#    - Simplifies deployment and management at scale
#    - Currently limited to en-US language only
#    - Each member bot must exist before adding to network
#
# 6. Tagging Strategy:
#    - Tags cannot be modified after bot creation
#    - Plan tag strategy before creating bot
#    - Use consistent tagging across all Lex V2 resources
#    - Consider tags for: environment, project, cost center, owner
#    - test_bot_alias_tags are separate from main bot tags
#
# 7. Regional Considerations:
#    - Not all AWS regions support Amazon Lex V2
#    - Verify region availability before deployment
#    - Use region parameter to override provider default
#    - Consider data residency requirements
#
# 8. Error Logging:
#    - Configure CloudWatch Logs for troubleshooting
#    - Monitor bot performance and errors
#    - Set up alarms for critical failures
#    - Review logs regularly for optimization opportunities
#
# 9. Next Steps After Bot Creation:
#    - Add language configuration (aws_lexv2models_bot_locale)
#    - Define intents (aws_lexv2models_intent)
#    - Create slot types (aws_lexv2models_slot_type)
#    - Configure fulfillment (Lambda integration)
#    - Build and test the bot
#    - Create production alias
#    - Set up channel integrations
################################################################################
