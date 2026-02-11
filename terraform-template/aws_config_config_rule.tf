#======================================
# AWS Config Rule - Annotated Template
#======================================
# Generated: 2026-01-19
# Provider Version: hashicorp/aws 6.28.0
#
# Note: This template was generated based on the provider schema and documentation
#       available at the time of generation. Always refer to the official Terraform
#       AWS Provider documentation for the most up-to-date information:
#       https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_config_rule
#
# AWS Config Rule provides a mechanism to evaluate the configuration settings of your
# AWS resources against desired compliance rules. Rules can be AWS managed rules,
# custom Lambda functions, or custom policy-based rules.
#
# Important: Config Rules require an existing Configuration Recorder to be present.
#            Use depends_on to avoid race conditions.
#======================================

resource "aws_config_config_rule" "example" {
  #--------------------------------------
  # Required Arguments
  #--------------------------------------

  # (Required) The name of the rule
  # Must be unique within the region
  name = "example-config-rule"

  #--------------------------------------
  # Optional Arguments
  #--------------------------------------

  # (Optional) Description of the rule
  # Provides context about what this rule evaluates
  description = "Example AWS Config rule to evaluate resource compliance"

  # (Optional) A string in JSON format that is passed to the AWS Config rule Lambda function
  # Used to customize the behavior of managed rules or custom Lambda rules
  # The specific parameters depend on the rule being used
  # Example for IAM_PASSWORD_POLICY: {"RequireUppercaseCharacters":"true","RequireLowercaseCharacters":"true"}
  # Reference: https://docs.aws.amazon.com/config/latest/developerguide/evaluate-config_use-managed-rules.html
  input_parameters = jsonencode({
    key1 = "value1"
    key2 = "value2"
  })

  # (Optional) The maximum frequency with which AWS Config runs evaluations for a rule
  # Valid values: One_Hour, Three_Hours, Six_Hours, Twelve_Hours, TwentyFour_Hours
  # Only valid for rules with trigger type ScheduledNotification
  # Reference: https://docs.aws.amazon.com/config/latest/APIReference/API_ConfigRule.html
  maximum_execution_frequency = "TwentyFour_Hours"

  # (Optional) Region where this resource will be managed
  # Defaults to the Region set in the provider configuration
  # Reference: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = "us-east-1"

  # (Optional) A map of tags to assign to the resource
  # Tags are useful for resource organization, cost allocation, and access control
  # If configured with a provider default_tags configuration block, tags with matching keys
  # will overwrite those defined at the provider-level
  # Reference: https://docs.aws.amazon.com/config/latest/developerguide/tagging.html
  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
    Purpose     = "compliance-monitoring"
  }

  # (Optional) A map of tags assigned to the resource, including those inherited from
  # the provider default_tags configuration block
  # This is typically computed by Terraform and merges provider-level default tags
  # with resource-specific tags
  tags_all = {
    Environment = "production"
    ManagedBy   = "terraform"
  }

  #--------------------------------------
  # Nested Blocks
  #--------------------------------------

  # (Optional) The modes the Config rule can be evaluated in
  # Evaluation modes determine when resources are evaluated (before or after deployment)
  # Reference: https://docs.aws.amazon.com/config/latest/developerguide/evaluating-your-resources.html
  evaluation_mode {
    # (Optional) The mode of an evaluation
    # Valid values: DETECTIVE, PROACTIVE
    # - DETECTIVE: Evaluates resources that have already been deployed (default behavior)
    # - PROACTIVE: Evaluates resources before deployment to check compliance
    # Reference: https://docs.aws.amazon.com/config/latest/APIReference/API_EvaluationModeConfiguration.html
    mode = "DETECTIVE"
  }

  # (Optional) Scope defines which resources can trigger an evaluation for the rule
  # Use this to limit the rule to specific resources, resource types, or tagged resources
  # Reference: https://docs.aws.amazon.com/config/latest/APIReference/API_Scope.html
  scope {
    # (Optional) The ID of the only AWS resource that you want to trigger an evaluation for the rule
    # If you specify a resource ID, you must specify one resource type for compliance_resource_types
    # Example: "i-1234567890abcdef0" for an EC2 instance
    compliance_resource_id = "i-1234567890abcdef0"

    # (Optional) A list of resource types of only those AWS resources that you want to trigger
    # an evaluation for the rule
    # You can only specify one type if you also specify a resource ID for compliance_resource_id
    # Examples: AWS::EC2::Instance, AWS::S3::Bucket, AWS::RDS::DBInstance
    # Reference: https://docs.aws.amazon.com/config/latest/developerguide/resource-config-reference.html
    compliance_resource_types = [
      "AWS::EC2::Instance",
      "AWS::S3::Bucket",
    ]

    # (Optional) The tag key that is applied to only those AWS resources that you want to
    # trigger an evaluation for the rule
    # Required if tag_value is specified
    # Use this to scope the rule to resources with a specific tag
    tag_key = "Environment"

    # (Optional) The tag value applied to only those AWS resources that you want to
    # trigger an evaluation for the rule
    # Must be used in conjunction with tag_key
    tag_value = "production"
  }

  # (Required) Source specifies the rule owner, the rule identifier, and the notifications
  # that cause the function to evaluate your AWS resources
  # This block defines whether the rule is AWS-managed, custom Lambda, or custom policy-based
  # Reference: https://docs.aws.amazon.com/config/latest/developerguide/evaluate-config_components.html
  source {
    # (Required) Indicates whether AWS or the customer owns and manages the AWS Config rule
    # Valid values:
    # - AWS: AWS managed rule (predefined rules maintained by AWS)
    # - CUSTOM_LAMBDA: Custom rule using Lambda function
    # - CUSTOM_POLICY: Custom rule using Guard policy language
    # Reference: https://docs.aws.amazon.com/config/latest/developerguide/evaluate-config_use-managed-rules.html
    owner = "AWS"

    # (Optional) For AWS Config managed rules, a predefined identifier
    # For custom Lambda rules, the ARN of the Lambda Function
    # Examples:
    # - AWS managed: "S3_BUCKET_VERSIONING_ENABLED", "IAM_PASSWORD_POLICY"
    # - Custom Lambda: "arn:aws:lambda:us-east-1:123456789012:function:custom_rule_name"
    # Reference: https://docs.aws.amazon.com/config/latest/developerguide/managed-rules-by-aws-config.html
    source_identifier = "S3_BUCKET_VERSIONING_ENABLED"

    # (Optional) Provides the source and type of the event that causes AWS Config to
    # evaluate your AWS resources
    # Only valid if owner is CUSTOM_LAMBDA or CUSTOM_POLICY
    # Can define up to 25 source detail blocks
    # Reference: https://docs.aws.amazon.com/config/latest/APIReference/API_SourceDetail.html
    source_detail {
      # (Optional) The source of the event, such as an AWS service, that triggers AWS Config
      # to evaluate your AWS resources
      # Defaults to "aws.config" and is the only valid value
      event_source = "aws.config"

      # (Optional) The frequency that you want AWS Config to run evaluations for a rule
      # that is triggered periodically
      # If specified, requires message_type to be ScheduledNotification
      # Valid values: One_Hour, Three_Hours, Six_Hours, Twelve_Hours, TwentyFour_Hours
      maximum_execution_frequency = "TwentyFour_Hours"

      # (Optional) The type of notification that triggers AWS Config to run an evaluation
      # Valid values:
      # - ConfigurationItemChangeNotification: Triggers when a resource changes
      # - OversizedConfigurationItemChangeNotification: Triggers for oversized config items
      # - ScheduledNotification: Triggers periodic evaluation at specified frequency
      # - ConfigurationSnapshotDeliveryCompleted: Triggers when config snapshot is delivered
      # Reference: https://docs.aws.amazon.com/config/latest/APIReference/API_SourceDetail.html
      message_type = "ConfigurationItemChangeNotification"
    }

    # (Optional) Provides the runtime system, policy definition, and whether debug logging is enabled
    # Required when owner is set to CUSTOM_POLICY
    # Custom policies use Guard policy-as-code language to define evaluation logic
    # Reference: https://docs.aws.amazon.com/config/latest/developerguide/evaluate-config_develop-rules_cfn-guard.html
    custom_policy_details {
      # (Optional) The boolean expression for enabling debug logging for your Config Custom Policy rule
      # Default value is false
      # Debug logs can help troubleshoot policy evaluation issues
      enable_debug_log_delivery = false

      # (Required) The runtime system for your Config Custom Policy rule
      # Guard is a policy-as-code language that allows you to write policies enforced by Config
      # Valid values follow the pattern: guard-2.x.x
      # Reference: https://github.com/aws-cloudformation/cloudformation-guard
      policy_runtime = "guard-2.x.x"

      # (Required) The policy definition containing the logic for your Config Custom Policy rule
      # Written in Guard policy language
      # Defines the compliance evaluation logic for resources
      # Example: Checking if DynamoDB tables have point-in-time recovery enabled
      policy_text = <<-EOF
        rule tableisactive when
          resourceType == "AWS::DynamoDB::Table" {
          configuration.tableStatus == ['ACTIVE']
        }

        rule checkcompliance when
          resourceType == "AWS::DynamoDB::Table"
          tableisactive {
            supplementaryConfiguration.ContinuousBackupsDescription.pointInTimeRecoveryDescription.pointInTimeRecoveryStatus == "ENABLED"
        }
      EOF
    }
  }

  # Dependency management
  # Config Rule requires an existing Configuration Recorder to be present
  # Use depends_on to avoid race conditions during resource creation
  # Reference: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_configuration_recorder
  depends_on = [
    aws_config_configuration_recorder.example
  ]
}

#======================================
# Computed Attributes (Read-Only)
#======================================
# These attributes are computed by AWS and cannot be set in the configuration:
#
# - arn: The ARN of the config rule
#   Format: arn:aws:config:region:account-id:config-rule/config-rule-id
#
# - rule_id: The ID of the config rule
#   A unique identifier assigned by AWS Config
#
#======================================
# References
#======================================
# AWS Config Rules Documentation:
# https://docs.aws.amazon.com/config/latest/developerguide/evaluate-config.html
#
# AWS Config Managed Rules:
# https://docs.aws.amazon.com/config/latest/developerguide/managed-rules-by-aws-config.html
#
# AWS Config Custom Rules:
# https://docs.aws.amazon.com/config/latest/developerguide/evaluate-config_develop-rules.html
#
# AWS Config Custom Lambda Rules:
# https://docs.aws.amazon.com/config/latest/developerguide/evaluate-config_develop-rules_lambda-functions.html
#
# AWS Config Custom Policy Rules (Guard):
# https://docs.aws.amazon.com/config/latest/developerguide/evaluate-config_develop-rules_cfn-guard.html
#
# Evaluation Modes (Proactive vs Detective):
# https://docs.aws.amazon.com/config/latest/developerguide/evaluating-your-resources.html
#
# Terraform AWS Provider - aws_config_config_rule:
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_config_rule
#
# AWS Config API Reference:
# https://docs.aws.amazon.com/config/latest/APIReference/Welcome.html
#======================================
