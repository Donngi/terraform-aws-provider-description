# -----------------------------------------------------------------------------
# Resource: aws_redshift_data_share_consumer_association
# Provider Version: 6.28.0
# Description: Terraform resource for managing an AWS Redshift Data Share Consumer Association.
# AWS Documentation: https://docs.aws.amazon.com/redshift/latest/dg/datashare-overview.html
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/redshift_data_share_consumer_association
# -----------------------------------------------------------------------------

# This resource allows you to associate a Redshift data share with a consumer.
# Data sharing enables you to securely share live data across Redshift clusters
# and AWS accounts without copying or moving data.

resource "aws_redshift_data_share_consumer_association" "example" {
  # ============================================================================
  # Required Arguments
  # ============================================================================

  # data_share_arn (Required)
  # Amazon Resource Name (ARN) of the datashare that the consumer is to use
  # with the account or the namespace.
  # The ARN format is typically:
  # arn:aws:redshift:<region>:<account-id>:datashare:<cluster-namespace-id>/<datashare-name>
  # Example: "arn:aws:redshift:us-west-2:123456789012:datashare:b3bfde75-73fd-408b-9086-d6fccfd6d588/example"
  data_share_arn = "arn:aws:redshift:us-west-2:123456789012:datashare:b3bfde75-73fd-408b-9086-d6fccfd6d588/example"

  # ============================================================================
  # Optional Arguments (Consumer Selection)
  # ============================================================================
  # IMPORTANT: Choose ONE of the following three options. These are mutually exclusive:
  # - associate_entire_account: Associate with the entire AWS account
  # - consumer_arn: Associate with a specific cluster namespace
  # - consumer_region: Associate with all namespaces in a specific region

  # Option 1: associate_entire_account (Optional)
  # Whether the datashare is associated with the entire account.
  # Conflicts with: consumer_arn, consumer_region
  # Default: Not set
  # When true, associates the datashare with all current and future namespaces
  # in the account.
  associate_entire_account = true

  # Option 2: consumer_arn (Optional)
  # Amazon Resource Name (ARN) of the consumer cluster namespace that is
  # associated with the datashare.
  # Conflicts with: associate_entire_account, consumer_region
  # The ARN format is typically:
  # arn:aws:redshift:<region>:<account-id>:namespace:<namespace-id>
  # Example: "arn:aws:redshift:us-west-2:123456789012:namespace:b3bfde75-73fd-408b-9086-d6fccfd6d588"
  # consumer_arn = "arn:aws:redshift:us-west-2:123456789012:namespace:b3bfde75-73fd-408b-9086-d6fccfd6d588"

  # Option 3: consumer_region (Optional)
  # From a datashare consumer account, associates a datashare with all
  # existing and future namespaces in the specified AWS Region.
  # Conflicts with: associate_entire_account, consumer_arn
  # Example: "us-west-2"
  # consumer_region = "us-west-2"

  # ============================================================================
  # Optional Arguments (Additional Configuration)
  # ============================================================================

  # allow_writes (Optional)
  # Whether to allow write operations for a datashare.
  # Default: Not set (read-only access)
  # When true, consumers can write back to the shared data.
  # Note: This feature requires specific Redshift configurations and permissions.
  # allow_writes = false

  # region (Optional)
  # Region where this resource will be managed.
  # Defaults to the Region set in the provider configuration.
  # Example: "us-west-2"
  # region = "us-west-2"

  # ============================================================================
  # Computed Attributes (Read-Only)
  # ============================================================================
  # These attributes are automatically populated by AWS after creation:
  # - id: A comma-delimited string concatenating data_share_arn and the
  #       consumer selection (associate_entire_account, consumer_arn, or consumer_region)
  # - managed_by: Identifier of a datashare to show its managing entity
  # - producer_arn: Amazon Resource Name (ARN) of the producer
}

# -----------------------------------------------------------------------------
# Example: Associate with specific consumer cluster
# -----------------------------------------------------------------------------
# resource "aws_redshift_data_share_consumer_association" "specific_cluster" {
#   data_share_arn = "arn:aws:redshift:us-west-2:123456789012:datashare:b3bfde75-73fd-408b-9086-d6fccfd6d588/example"
#   consumer_arn   = "arn:aws:redshift:us-west-2:987654321098:namespace:a1a1a1a1-1111-1111-1111-111111111111"
# }

# -----------------------------------------------------------------------------
# Example: Associate with all clusters in a specific region
# -----------------------------------------------------------------------------
# resource "aws_redshift_data_share_consumer_association" "regional" {
#   data_share_arn  = "arn:aws:redshift:us-west-2:123456789012:datashare:b3bfde75-73fd-408b-9086-d6fccfd6d588/example"
#   consumer_region = "us-east-1"
# }

# -----------------------------------------------------------------------------
# Example: Associate with write permissions
# -----------------------------------------------------------------------------
# resource "aws_redshift_data_share_consumer_association" "with_writes" {
#   data_share_arn           = "arn:aws:redshift:us-west-2:123456789012:datashare:b3bfde75-73fd-408b-9086-d6fccfd6d588/example"
#   associate_entire_account = true
#   allow_writes             = true
# }

# -----------------------------------------------------------------------------
# Outputs
# -----------------------------------------------------------------------------
# output "data_share_association_id" {
#   description = "The ID of the data share consumer association"
#   value       = aws_redshift_data_share_consumer_association.example.id
# }
#
# output "producer_arn" {
#   description = "The ARN of the data share producer"
#   value       = aws_redshift_data_share_consumer_association.example.producer_arn
# }
#
# output "managed_by" {
#   description = "Identifier showing the managing entity of the datashare"
#   value       = aws_redshift_data_share_consumer_association.example.managed_by
# }

# -----------------------------------------------------------------------------
# Notes
# -----------------------------------------------------------------------------
# 1. Consumer Selection: You must specify exactly ONE of:
#    - associate_entire_account
#    - consumer_arn
#    - consumer_region
#    These options are mutually exclusive.
#
# 2. Cross-Account Sharing: This resource is used on the consumer side.
#    The producer must first create the datashare and authorize the consumer
#    using aws_redshift_data_share_authorization.
#
# 3. Permissions: The consumer account needs appropriate IAM permissions
#    to associate with datashares, including:
#    - redshift:AssociateDataShareConsumer
#    - redshift:DescribeDataSharesForConsumer
#
# 4. Region Considerations: For cross-region datashares, ensure that
#    the consumer_region is different from the producer's region.
#
# 5. Write Operations: The allow_writes parameter requires additional
#    configuration on both producer and consumer clusters to enable
#    bi-directional data sharing.
