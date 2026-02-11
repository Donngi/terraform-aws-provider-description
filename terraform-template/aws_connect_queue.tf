################################################################################
# AWS Connect Queue - Annotated Template
################################################################################
# Generated: 2026-01-19
# Provider Version: 6.28.0
#
# NOTE: This template was generated based on the AWS Provider schema and
# documentation available at the time of generation. Always refer to the
# latest official documentation for the most up-to-date information:
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/connect_queue
################################################################################

resource "aws_connect_queue" "example" {
  # ============================================================================
  # Required Arguments
  # ============================================================================

  # (Required) Specifies the identifier of the hosting Amazon Connect Instance.
  # Type: string
  # AWS Documentation: https://docs.aws.amazon.com/connect/latest/adminguide/amazon-connect-get-started.html
  instance_id = "aaaaaaaa-bbbb-cccc-dddd-111111111111"

  # (Required) Specifies the name of the Queue.
  # Type: string
  name = "Example Queue"

  # (Required) Specifies the identifier of the Hours of Operation.
  # Type: string
  # AWS Documentation: https://docs.aws.amazon.com/connect/latest/adminguide/create-queue.html
  hours_of_operation_id = "12345678-1234-1234-1234-123456789012"

  # ============================================================================
  # Optional Arguments
  # ============================================================================

  # (Optional) Specifies the description of the Queue.
  # Type: string
  description = "Example queue description"

  # (Optional) Specifies the maximum number of contacts that can be in the queue
  # before it is considered full. Minimum value of 0.
  # Type: number
  # AWS Documentation: https://docs.aws.amazon.com/connect/latest/adminguide/create-queue.html
  max_contacts = 10

  # (Optional) Specifies a list of quick connects ids that determine the quick
  # connects available to agents who are working the queue.
  # Type: set of strings
  quick_connect_ids = [
    "12345678-abcd-1234-abcd-123456789012"
  ]

  # (Optional) Specifies the status of the Queue.
  # Valid values are: ENABLED, DISABLED
  # Type: string (computed if not specified)
  # AWS Documentation: https://docs.aws.amazon.com/connect/latest/adminguide/create-queue.html
  status = "ENABLED"

  # (Optional) Region where this resource will be managed.
  # Defaults to the Region set in the provider configuration.
  # Type: string (computed if not specified)
  # AWS Documentation: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = "us-east-1"

  # (Optional) Tags to apply to the Queue.
  # If configured with a provider default_tags configuration block, tags with
  # matching keys will overwrite those defined at the provider-level.
  # Type: map of strings
  # AWS Documentation: https://docs.aws.amazon.com/connect/latest/adminguide/tagging.html
  tags = {
    Name        = "Example Queue"
    Environment = "Production"
  }

  # (Optional) A map of tags assigned to the resource, including those inherited
  # from the provider default_tags configuration block.
  # Type: map of strings (computed if not specified)
  # NOTE: This is typically managed automatically by Terraform
  # tags_all = {}

  # (Optional) The identifier of the hosting Amazon Connect Instance and
  # identifier of the Queue separated by a colon (:).
  # Type: string (computed if not specified)
  # NOTE: This is typically computed by Terraform and used for resource identification
  # id = "instance-id:queue-id"

  # ============================================================================
  # Nested Blocks
  # ============================================================================

  # (Optional) A block that defines the outbound caller ID name, number, and
  # outbound whisper flow. Maximum of 1 block.
  # AWS Documentation: https://docs.aws.amazon.com/connect/latest/adminguide/create-queue.html
  outbound_caller_config {
    # (Optional) Specifies the caller ID name displayed to customers during
    # outbound calls from this queue.
    # Type: string
    outbound_caller_id_name = "Example Company"

    # (Optional) Specifies the caller ID number (phone number) displayed to
    # customers during outbound calls from this queue.
    # Type: string
    outbound_caller_id_number_id = "12345678-abcd-1234-abcd-123456789012"

    # (Optional) Specifies outbound whisper flow to be used during an outbound call.
    # The whisper flow plays audio to the agent before connecting them to the customer.
    # Type: string
    outbound_flow_id = "87654321-defg-1234-defg-987654321234"
  }
}

################################################################################
# Computed Attributes (Read-Only)
################################################################################
# These attributes are automatically computed by AWS and cannot be set directly:
#
# - arn          : The Amazon Resource Name (ARN) of the Queue
#                  Example: arn:aws:connect:us-east-1:123456789012:instance/aaaaaaaa-bbbb-cccc-dddd-111111111111/queue/queue-id
#
# - queue_id     : The identifier for the Queue (UUID format)
#                  Example: 12345678-1234-1234-1234-123456789012
#
################################################################################

################################################################################
# Additional Information
################################################################################
# Queue Priority and Delay:
# - Queues can be configured with priority and delay settings in routing profiles
# - Priority determines the order in which contacts are routed to agents
# - Delay settings determine how long a contact must wait before being considered
# - AWS Documentation: https://docs.aws.amazon.com/connect/latest/adminguide/concepts-routing-profiles-priority.html
#
# Queue Types:
# - Standard Queues: Regular queues where contacts wait to be routed to agents
# - Agent Queues: Automatically created queues for direct agent routing
# - AWS Documentation: https://docs.aws.amazon.com/connect/latest/adminguide/concepts-queues-standard-and-agent.html
#
# Queued Callbacks:
# - Customers can maintain their position in queue and receive a callback
# - Callbacks can remain in the same queue or use a dedicated callback queue
# - AWS Documentation: https://docs.aws.amazon.com/connect/latest/adminguide/setup-queued-cb.html
#
# API Management:
# Queues can also be managed using the following AWS APIs:
# - CreateQueue
# - DeleteQueue
# - DescribeQueue
# - ListQueues
# - SearchQueues
# - UpdateQueueHoursOfOperation
# - UpdateQueueMaxContacts
# - UpdateQueueName
# - UpdateQueueOutboundCallerConfig
# - UpdateQueueStatus
#
################################################################################
