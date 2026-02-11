################################################################################
# AWS CloudWatch Composite Alarm - Annotated Template
################################################################################
# Generated: 2026-01-18
# Provider Version: 6.28.0
#
# NOTE: This template was generated at a specific point in time and may not
# reflect the latest resource specifications. Always refer to the official
# documentation for the most current information:
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_composite_alarm
################################################################################

resource "aws_cloudwatch_composite_alarm" "example" {
  ##############################################################################
  # Required Arguments
  ##############################################################################

  # (Required) The name for the composite alarm.
  # This name must be unique within the region.
  # Type: string
  alarm_name = "example-composite-alarm"

  # (Required) An expression that specifies which other alarms are to be
  # evaluated to determine this composite alarm's state.
  # The maximum length is 10240 characters.
  # For syntax, see: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Create_Composite_Alarm.html
  #
  # Supported operators:
  # - AND: All specified alarms must be in ALARM state
  # - OR: At least one specified alarm must be in ALARM state
  # - NOT: Inverts the state of the specified alarm
  #
  # Example: ALARM(alarm-1) OR ALARM(alarm-2)
  # Example: ALARM(cpu-alarm) AND NOT ALARM(maintenance-alarm)
  # Type: string
  alarm_rule = <<EOF
ALARM(${aws_cloudwatch_metric_alarm.example.alarm_name}) OR
ALARM(${aws_cloudwatch_metric_alarm.example2.alarm_name})
EOF

  ##############################################################################
  # Optional Arguments
  ##############################################################################

  # (Optional, Forces new resource) Indicates whether actions should be
  # executed during any changes to the alarm state of the composite alarm.
  # Defaults to true.
  # Type: bool
  # Default: true
  actions_enabled = true

  # (Optional) The set of actions to execute when this alarm transitions to
  # the ALARM state from any other state.
  # Each action is specified as an ARN (e.g., SNS topic ARN, Auto Scaling
  # policy ARN, Lambda function ARN).
  # Maximum: 5 actions allowed
  # Type: set(string)
  alarm_actions = [
    # aws_sns_topic.example.arn,
    # aws_autoscaling_policy.example.arn,
  ]

  # (Optional) The description for the composite alarm.
  # Type: string
  alarm_description = "This is a composite alarm that monitors multiple metric alarms"

  # (Optional) The set of actions to execute when this alarm transitions to
  # the INSUFFICIENT_DATA state from any other state.
  # Each action is specified as an ARN.
  # Maximum: 5 actions allowed
  # Type: set(string)
  insufficient_data_actions = [
    # aws_sns_topic.example.arn,
  ]

  # (Optional) The set of actions to execute when this alarm transitions to
  # an OK state from any other state.
  # Each action is specified as an ARN.
  # Maximum: 5 actions allowed
  # Type: set(string)
  ok_actions = [
    # aws_sns_topic.example.arn,
  ]

  # (Optional) Region where this resource will be managed.
  # Defaults to the Region set in the provider configuration.
  # Reference: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # Type: string
  # region = "us-east-1"

  # (Optional) A map of tags to associate with the alarm.
  # Maximum: 50 tags allowed
  # If configured with a provider default_tags configuration block, tags with
  # matching keys will overwrite those defined at the provider-level.
  # Type: map(string)
  tags = {
    Name        = "example-composite-alarm"
    Environment = "production"
    ManagedBy   = "terraform"
  }

  # (Optional) A map of tags assigned to the resource, including those
  # inherited from the provider default_tags configuration block.
  # Note: This is typically managed by Terraform and the provider automatically.
  # Type: map(string)
  # tags_all = {}

  ##############################################################################
  # Optional Nested Blocks
  ##############################################################################

  # (Optional) Actions will be suppressed if the suppressor alarm is in the
  # ALARM state.
  # Maximum: 1 block allowed
  #
  # Use Case: Prevent alarm actions during maintenance windows or when a
  # related alarm indicates that the situation is already being handled.
  actions_suppressor {
    # (Required) Can be an AlarmName or an Amazon Resource Name (ARN) from
    # an existing alarm.
    # When this alarm is in ALARM state, actions for the composite alarm
    # will be suppressed.
    # Type: string
    alarm = "maintenance-window-alarm"

    # (Required) The maximum time in seconds that the composite alarm waits
    # after suppressor alarm goes out of the ALARM state.
    # After this time, the composite alarm performs its actions.
    # This prevents rapid action execution if the suppressor alarm flaps.
    # Type: number
    extension_period = 60

    # (Required) The maximum time in seconds that the composite alarm waits
    # for the suppressor alarm to go into the ALARM state.
    # After this time, the composite alarm performs its actions.
    # This ensures that if the suppressor alarm doesn't activate quickly
    # enough, the composite alarm will still take action.
    # Type: number
    wait_period = 300
  }
}

################################################################################
# Computed Attributes (Read-Only)
################################################################################
# These attributes are exported by the resource but cannot be set in configuration:
#
# - arn: The ARN of the composite alarm
#   Example: arn:aws:cloudwatch:us-east-1:123456789012:alarm:example-composite-alarm
#
# - id: The ID of the composite alarm resource, which is equivalent to its alarm_name
#   Example: example-composite-alarm
################################################################################

################################################################################
# Important Notes
################################################################################
# 1. Cyclical Dependencies:
#    An alarm (composite or metric) cannot be destroyed when there are other
#    composite alarms depending on it. This can lead to a cyclical dependency
#    on update, as Terraform will unsuccessfully attempt to destroy alarms
#    before updating the rule. Consider using depends_on, references to alarm
#    names, and two-stage updates.
#
# 2. Alarm Rule Expression:
#    The alarm_rule expression can combine multiple alarms using Boolean logic.
#    Maximum length is 10240 characters.
#    See: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Create_Composite_Alarm.html
#
# 3. Actions Limits:
#    Each action set (alarm_actions, ok_actions, insufficient_data_actions)
#    can contain up to 5 actions.
#
# 4. Actions Suppressor:
#    The actions_suppressor block is useful for implementing maintenance windows
#    or preventing duplicate notifications when a parent alarm is already
#    handling the situation.
#
# 5. State Transitions:
#    Composite alarms can be in one of three states:
#    - ALARM: At least one condition in the alarm_rule is met
#    - OK: None of the conditions in the alarm_rule are met
#    - INSUFFICIENT_DATA: At least one alarm being evaluated has insufficient data
#
# 6. Regional Resource:
#    CloudWatch Composite Alarms are regional resources. The alarms referenced
#    in the alarm_rule must be in the same region as the composite alarm.
################################################################################

################################################################################
# References
################################################################################
# - Terraform Documentation:
#   https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_composite_alarm
#
# - AWS CloudWatch Composite Alarms:
#   https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Create_Composite_Alarm.html
#
# - Creating a Composite Alarm (How To):
#   https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Create_Composite_Alarm_How_To.html
#
# - AWS Regional Endpoints:
#   https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
################################################################################
