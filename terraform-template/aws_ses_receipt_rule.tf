################################################################################
# AWS SES Receipt Rule
################################################################################
# Provides an SES receipt rule resource for processing incoming emails.
# Receipt rules define actions to perform on emails matching specific criteria.
#
# AWS Documentation:
# https://docs.aws.amazon.com/ses/latest/dg/receiving-email-receipt-rules.html
#
# Terraform Documentation:
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ses_receipt_rule
#
# Provider Version: 6.28.0
################################################################################

resource "aws_ses_receipt_rule" "example" {
  ################################################################################
  # Required Arguments
  ################################################################################

  # (Required) The name of the receipt rule
  # Must be unique within the rule set
  # Example: "process-support-emails", "store-invoices"
  name = "example-receipt-rule"

  # (Required) The name of the rule set to which to add the rule
  # The rule set must already exist in your AWS account
  # Example: "default-rule-set", "production-rule-set"
  rule_set_name = "default-rule-set"

  ################################################################################
  # Optional Arguments
  ################################################################################

  # (Optional) The name of the rule to place this rule after
  # Controls the order in which rules are evaluated
  # If not specified, the rule will be inserted at the beginning of the rule set
  # Example: "previous-rule-name"
  # after = "another-rule"

  # (Optional) If true, the rule will be enabled
  # Default: true
  # Set to false to disable the rule without deleting it
  # enabled = true

  # (Optional) A list of email addresses to match against the recipient
  # If specified, the rule only applies to emails sent to these addresses
  # If not specified or empty, the rule applies to all recipients
  # Example: ["support@example.com", "info@example.com"]
  # recipients = ["user@example.com"]

  # (Optional) If true, incoming emails will be scanned for spam and viruses
  # Default: false
  # When enabled, adds spam and virus scan headers to the email
  # scan_enabled = true

  # (Optional) Require or Optional for TLS encryption
  # Valid values: "Require" or "Optional"
  # - "Require": Rejects emails that are not sent over a TLS connection
  # - "Optional": Accepts emails sent over TLS and non-TLS connections
  # Default: "Optional"
  # Example: "Require"
  # tls_policy = "Optional"

  # (Optional) Region where this resource will be managed
  # Defaults to the Region set in the provider configuration
  # Example: "us-east-1", "us-west-2"
  # region = "us-east-1"

  ################################################################################
  # Action Blocks
  ################################################################################
  # Actions are executed in order based on their position attribute
  # Multiple actions can be defined, and they will be processed sequentially

  # Add Header Action
  # Adds a custom header to the email before passing it to the next action
  # add_header_action {
  #   # (Required) The name of the header to add
  #   # Example: "X-Custom-Header", "X-Environment"
  #   header_name = "X-Custom-Header"
  #
  #   # (Required) The value of the header to add
  #   # Example: "Production", "Processed by SES"
  #   header_value = "Added by SES"
  #
  #   # (Required) The position of the action in the receipt rule
  #   # Actions are executed in ascending order (1, 2, 3, etc.)
  #   position = 1
  # }

  # Bounce Action
  # Rejects the email with a bounce response
  # bounce_action {
  #   # (Required) The message to include in the bounce response
  #   # Example: "Mailbox does not exist"
  #   message = "Mailbox does not exist"
  #
  #   # (Required) The email address of the sender for the bounce message
  #   # Must be a verified email address or domain in SES
  #   # Example: "bounces@example.com"
  #   sender = "bounces@example.com"
  #
  #   # (Required) The RFC 5321 SMTP reply code
  #   # Common values: "550" (permanent failure), "450" (temporary failure)
  #   smtp_reply_code = "550"
  #
  #   # (Optional) The RFC 3463 SMTP enhanced status code
  #   # Example: "5.1.1" (bad destination mailbox address)
  #   # status_code = "5.1.1"
  #
  #   # (Optional) The ARN of an SNS topic to notify when the bounce action is taken
  #   # Example: "arn:aws:sns:us-east-1:123456789012:ses-bounces"
  #   # topic_arn = "arn:aws:sns:us-east-1:123456789012:bounce-notifications"
  #
  #   # (Required) The position of the action in the receipt rule
  #   position = 1
  # }

  # Lambda Action
  # Invokes a Lambda function to process the email
  # lambda_action {
  #   # (Required) The ARN of the Lambda function to invoke
  #   # The function must exist in the same region as the SES receipt rule
  #   # Example: "arn:aws:lambda:us-east-1:123456789012:function:process-email"
  #   function_arn = "arn:aws:lambda:us-east-1:123456789012:function:email-processor"
  #
  #   # (Optional) The invocation type of the Lambda function
  #   # Valid values: "Event" (async) or "RequestResponse" (sync)
  #   # Default: "Event"
  #   # - "Event": Lambda is invoked asynchronously, SES continues processing
  #   # - "RequestResponse": Lambda is invoked synchronously, SES waits for response
  #   # invocation_type = "Event"
  #
  #   # (Optional) The ARN of an SNS topic to notify
  #   # Notifies when the Lambda action completes or fails
  #   # Example: "arn:aws:sns:us-east-1:123456789012:lambda-notifications"
  #   # topic_arn = "arn:aws:sns:us-east-1:123456789012:lambda-notifications"
  #
  #   # (Required) The position of the action in the receipt rule
  #   position = 1
  # }

  # S3 Action
  # Stores the email in an S3 bucket
  # s3_action {
  #   # (Required) The name of the S3 bucket to store emails
  #   # The bucket must exist and have appropriate permissions for SES
  #   # Example: "my-ses-emails", "company-email-archive"
  #   bucket_name = "my-ses-emails"
  #
  #   # (Optional) The ARN of the IAM role for SES to assume
  #   # Required when using SSE-KMS encryption or publishing to SNS
  #   # The role must have permissions to write to the S3 bucket
  #   # Example: "arn:aws:iam::123456789012:role/ses-s3-role"
  #   # iam_role_arn = "arn:aws:iam::123456789012:role/ses-s3-role"
  #
  #   # (Optional) The ARN of the KMS key to use for encryption
  #   # If specified, emails will be encrypted using this KMS key
  #   # Example: "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
  #   # kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
  #
  #   # (Optional) The key prefix to use for storing emails in S3
  #   # Helps organize emails in the bucket using a folder structure
  #   # Example: "emails/", "inbox/", "support/"
  #   # object_key_prefix = "emails/"
  #
  #   # (Optional) The ARN of an SNS topic to notify when email is stored
  #   # Example: "arn:aws:sns:us-east-1:123456789012:email-stored"
  #   # topic_arn = "arn:aws:sns:us-east-1:123456789012:s3-notifications"
  #
  #   # (Required) The position of the action in the receipt rule
  #   position = 2
  # }

  # SNS Action
  # Publishes the email to an SNS topic
  # sns_action {
  #   # (Required) The ARN of the SNS topic to publish to
  #   # The topic must exist in the same region as the SES receipt rule
  #   # Example: "arn:aws:sns:us-east-1:123456789012:ses-emails"
  #   topic_arn = "arn:aws:sns:us-east-1:123456789012:email-notifications"
  #
  #   # (Optional) The encoding to use for the email within the SNS notification
  #   # Valid values: "UTF-8" or "Base64"
  #   # Default: "UTF-8"
  #   # - "UTF-8": Email content is included as UTF-8 encoded text
  #   # - "Base64": Email content is Base64 encoded
  #   # encoding = "UTF-8"
  #
  #   # (Required) The position of the action in the receipt rule
  #   position = 1
  # }

  # Stop Action
  # Terminates the evaluation of the receipt rule set
  # No further rules in the rule set will be evaluated
  # stop_action {
  #   # (Required) The scope to apply
  #   # Only acceptable value: "RuleSet"
  #   # Stops processing of all subsequent rules in the rule set
  #   scope = "RuleSet"
  #
  #   # (Optional) The ARN of an SNS topic to notify when stop action is taken
  #   # Example: "arn:aws:sns:us-east-1:123456789012:stop-notifications"
  #   # topic_arn = "arn:aws:sns:us-east-1:123456789012:stop-notifications"
  #
  #   # (Required) The position of the action in the receipt rule
  #   position = 1
  # }

  # WorkMail Action
  # Integrates with Amazon WorkMail to deliver email
  # workmail_action {
  #   # (Required) The ARN of the WorkMail organization
  #   # Example: "arn:aws:workmail:us-east-1:123456789012:organization/m-1234567890abcdef"
  #   organization_arn = "arn:aws:workmail:us-east-1:123456789012:organization/m-example"
  #
  #   # (Optional) The ARN of an SNS topic to notify
  #   # Notifies when email is delivered to WorkMail
  #   # Example: "arn:aws:sns:us-east-1:123456789012:workmail-notifications"
  #   # topic_arn = "arn:aws:sns:us-east-1:123456789012:workmail-notifications"
  #
  #   # (Required) The position of the action in the receipt rule
  #   position = 1
  # }
}

################################################################################
# Common Use Cases
################################################################################
# 1. Store emails in S3 and add custom header:
#    - Use add_header_action (position=1) to tag email
#    - Use s3_action (position=2) to store in bucket
#
# 2. Process emails with Lambda and notify via SNS:
#    - Use lambda_action (position=1) to process
#    - Use sns_action (position=2) to notify
#
# 3. Filter spam with scanning and bounce:
#    - Set scan_enabled = true
#    - Use bounce_action to reject suspicious emails
#
# 4. Archive all emails to S3:
#    - Set recipients = [] to match all emails
#    - Use s3_action to store all incoming emails
#
# 5. Route to WorkMail with notification:
#    - Use workmail_action (position=1) to deliver
#    - Use sns_action (position=2) to notify
################################################################################

################################################################################
# Outputs
################################################################################

output "ses_receipt_rule_id" {
  description = "The SES receipt rule name"
  value       = aws_ses_receipt_rule.example.id
}

output "ses_receipt_rule_arn" {
  description = "The SES receipt rule ARN"
  value       = aws_ses_receipt_rule.example.arn
}

################################################################################
# Important Notes
################################################################################
# 1. Receipt rules can only process emails for verified domains in SES
# 2. The rule set must be active to process emails
# 3. Actions are executed in the order specified by the position attribute
# 4. When using S3 action, ensure the bucket policy allows SES to write
# 5. When using Lambda action, ensure the function has permissions to be invoked by SES
# 6. TLS policy "Require" will reject all non-TLS connections
# 7. Recipients field accepts full email addresses, not domain wildcards
# 8. Multiple actions can be combined in a single rule
# 9. The stop_action prevents subsequent rules in the rule set from processing
# 10. Scan results are added as headers when scan_enabled is true
################################################################################

################################################################################
# Required IAM Permissions
################################################################################
# To manage this resource, you need the following IAM permissions:
# - ses:CreateReceiptRule
# - ses:UpdateReceiptRule
# - ses:DeleteReceiptRule
# - ses:DescribeReceiptRule
# - ses:SetReceiptRulePosition (when using 'after' attribute)
#
# For S3 action, the S3 bucket policy must allow:
# - Principal: { "Service": "ses.amazonaws.com" }
# - Action: "s3:PutObject"
# - Resource: "arn:aws:s3:::bucket-name/*"
# - Condition: { "StringEquals": { "AWS:SourceAccount": "account-id" } }
#
# For Lambda action, the Lambda function policy must allow:
# - Principal: { "Service": "ses.amazonaws.com" }
# - Action: "lambda:InvokeFunction"
# - SourceAccount: "account-id"
#
# For SNS action, the SNS topic policy must allow:
# - Principal: { "Service": "ses.amazonaws.com" }
# - Action: "SNS:Publish"
################################################################################
