# ==============================================================================
# AWS CodeStar Notifications Notification Rule
# Terraform Resource Template with Full Property Annotations
# ==============================================================================
#
# Generated: 2026-01-19
# Provider Version: hashicorp/aws 6.28.0
#
# IMPORTANT:
# - This template is generated based on the AWS Provider schema at the time of creation
# - Always refer to the official documentation for the latest specifications
# - AWS Provider Documentation: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codestarnotifications_notification_rule
#
# ==============================================================================

# ------------------------------------------------------------------------------
# Resource: aws_codestarnotifications_notification_rule
# Description: Provides a CodeStar Notifications Rule for monitoring events in AWS developer tools
# Documentation: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codestarnotifications_notification_rule
# AWS Documentation: https://docs.aws.amazon.com/codestar-notifications/latest/userguide/welcome.html
# ------------------------------------------------------------------------------

resource "aws_codestarnotifications_notification_rule" "example" {
  # ============================================================================
  # Required Arguments
  # ============================================================================

  # name - (Required) The name of notification rule
  # Type: string
  # The name must be unique within the AWS account
  name = "example-notification-rule"

  # resource - (Required) The ARN of the resource to associate with the notification rule
  # Type: string
  # Supported resources include:
  # - CodeCommit repositories
  # - CodeBuild projects
  # - CodeDeploy applications
  # - CodePipeline pipelines
  # Documentation: https://docs.aws.amazon.com/codestar-notifications/latest/userguide/concepts.html#rules
  resource = "arn:aws:codecommit:us-east-1:123456789012:example-repo"

  # detail_type - (Required) The level of detail to include in the notifications for this resource
  # Type: string
  # Valid values:
  # - "BASIC" - Includes only a subset of the available information
  # - "FULL" - Includes all information available for the event (default)
  # For detailed differences, see: https://docs.aws.amazon.com/dtconsole/latest/userguide/concepts.html#detail-type
  detail_type = "FULL"

  # event_type_ids - (Required) A list of event types associated with this notification rule
  # Type: set of strings
  # For list of allowed events by resource type:
  # - CodeCommit: https://docs.aws.amazon.com/dtconsole/latest/userguide/concepts.html#events-ref-repositories
  # - CodeBuild: https://docs.aws.amazon.com/dtconsole/latest/userguide/concepts.html#events-ref-buildproject
  # - CodeDeploy: https://docs.aws.amazon.com/dtconsole/latest/userguide/concepts.html#events-ref-deployapplication
  # - CodePipeline: https://docs.aws.amazon.com/dtconsole/latest/userguide/concepts.html#events-ref-pipeline
  #
  # Examples:
  # CodeCommit events:
  # - "codecommit-repository-comments-on-commits"
  # - "codecommit-repository-comments-on-pull-requests"
  # - "codecommit-repository-approvals-status-changed"
  # - "codecommit-repository-approvals-rule-override"
  # - "codecommit-repository-pull-request-created"
  # - "codecommit-repository-pull-request-source-updated"
  # - "codecommit-repository-pull-request-status-changed"
  # - "codecommit-repository-pull-request-merged"
  # - "codecommit-repository-branches-and-tags-created"
  # - "codecommit-repository-branches-and-tags-deleted"
  # - "codecommit-repository-branches-and-tags-updated"
  #
  # CodeBuild events:
  # - "codebuild-project-build-state-failed"
  # - "codebuild-project-build-state-succeeded"
  # - "codebuild-project-build-state-in-progress"
  # - "codebuild-project-build-state-stopped"
  # - "codebuild-project-build-phase-failure"
  # - "codebuild-project-build-phase-success"
  #
  # CodeDeploy events:
  # - "codedeploy-application-deployment-failed"
  # - "codedeploy-application-deployment-succeeded"
  # - "codedeploy-application-deployment-started"
  #
  # CodePipeline events:
  # - "codepipeline-pipeline-action-execution-succeeded"
  # - "codepipeline-pipeline-action-execution-failed"
  # - "codepipeline-pipeline-action-execution-canceled"
  # - "codepipeline-pipeline-action-execution-started"
  # - "codepipeline-pipeline-stage-execution-started"
  # - "codepipeline-pipeline-stage-execution-succeeded"
  # - "codepipeline-pipeline-stage-execution-resumed"
  # - "codepipeline-pipeline-stage-execution-canceled"
  # - "codepipeline-pipeline-stage-execution-failed"
  # - "codepipeline-pipeline-pipeline-execution-failed"
  # - "codepipeline-pipeline-pipeline-execution-canceled"
  # - "codepipeline-pipeline-pipeline-execution-started"
  # - "codepipeline-pipeline-pipeline-execution-resumed"
  # - "codepipeline-pipeline-pipeline-execution-succeeded"
  # - "codepipeline-pipeline-pipeline-execution-superseded"
  # - "codepipeline-pipeline-manual-approval-failed"
  # - "codepipeline-pipeline-manual-approval-needed"
  # - "codepipeline-pipeline-manual-approval-succeeded"
  event_type_ids = [
    "codecommit-repository-comments-on-commits",
    "codecommit-repository-pull-request-created"
  ]

  # ============================================================================
  # Optional Arguments
  # ============================================================================

  # status - (Optional) The status of the notification rule
  # Type: string
  # Valid values:
  # - "ENABLED" - Notifications are sent when events occur (default)
  # - "DISABLED" - Notifications are not sent
  status = "ENABLED"

  # region - (Optional) Region where this resource will be managed
  # Type: string
  # Defaults to the Region set in the provider configuration
  # Documentation: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # Note: Notification rules must be created in the same AWS Region as the resource
  # region = "us-east-1"

  # tags - (Optional) A map of tags to assign to the resource
  # Type: map of strings
  # If configured with a provider default_tags configuration block, tags with matching keys
  # will overwrite those defined at the provider-level
  # Documentation: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
  }

  # ============================================================================
  # Nested Blocks
  # ============================================================================

  # target - (Optional) Configuration blocks containing notification target information
  # Can be specified multiple times (maximum 10 targets)
  # At least one target must be specified on creation
  # Documentation: https://docs.aws.amazon.com/dtconsole/latest/userguide/concepts.html#targets
  target {
    # address - (Required) The ARN of notification target
    # Type: string
    # Valid target types:
    # - Amazon SNS topic ARN
    # - AWS Chatbot Slack client ARN
    # - AWS Chatbot Microsoft Teams client ARN
    # The target must be in the same AWS Region as the notification rule
    # For SNS topics, ensure the topic has the appropriate access policy to allow
    # codestar-notifications.amazonaws.com to publish messages
    # Documentation: https://docs.aws.amazon.com/dtconsole/latest/userguide/set-up-sns.html
    address = "arn:aws:sns:us-east-1:123456789012:example-topic"

    # type - (Optional) The type of the notification target
    # Type: string
    # Valid values:
    # - "SNS" - Amazon SNS topic (default)
    # - "AWSChatbotSlack" - AWS Chatbot client configured for Slack
    # - "AWSChatbotMicrosoftTeams" - AWS Chatbot client configured for Microsoft Teams
    # Default: "SNS"
    type = "SNS"
  }

  # Example: Additional target for AWS Chatbot Slack
  # target {
  #   address = "arn:aws:chatbot::123456789012:chat-configuration/slack-channel/example-slack-config"
  #   type    = "AWSChatbotSlack"
  # }
}

# ==============================================================================
# Computed Attributes (Read-Only)
# ==============================================================================
# The following attributes are exported by this resource and can be referenced
# in other resources using aws_codestarnotifications_notification_rule.example.<attribute>
#
# - id         : The codestar notification rule ARN
# - arn        : The codestar notification rule ARN
# - tags_all   : A map of tags assigned to the resource, including those inherited
#                from the provider default_tags configuration block
# ==============================================================================

# ==============================================================================
# Example Usage with CodeCommit Repository
# ==============================================================================
# resource "aws_codecommit_repository" "example" {
#   repository_name = "example-repo"
#   description     = "Example repository for notifications"
# }
#
# resource "aws_sns_topic" "notifications" {
#   name = "codecommit-notifications"
# }
#
# data "aws_iam_policy_document" "sns_topic_policy" {
#   statement {
#     actions = ["sns:Publish"]
#
#     principals {
#       type        = "Service"
#       identifiers = ["codestar-notifications.amazonaws.com"]
#     }
#
#     resources = [aws_sns_topic.notifications.arn]
#   }
# }
#
# resource "aws_sns_topic_policy" "notifications" {
#   arn    = aws_sns_topic.notifications.arn
#   policy = data.aws_iam_policy_document.sns_topic_policy.json
# }
#
# resource "aws_codestarnotifications_notification_rule" "example" {
#   detail_type    = "FULL"
#   event_type_ids = ["codecommit-repository-comments-on-commits"]
#   name           = "example-notification-rule"
#   resource       = aws_codecommit_repository.example.arn
#
#   target {
#     address = aws_sns_topic.notifications.arn
#   }
# }
# ==============================================================================
