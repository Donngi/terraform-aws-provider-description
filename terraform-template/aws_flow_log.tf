# ============================================================================
# Terraform AWS Provider Resource Template: aws_flow_log
# ============================================================================
# Generated: 2026-01-23
# Provider Version: 6.28.0
#
# This template provides a comprehensive, annotated configuration for the
# aws_flow_log resource. It includes all available input parameters with
# detailed descriptions based on the official Terraform AWS Provider schema
# and AWS documentation.
#
# IMPORTANT NOTES:
# - This template reflects the resource specification at the time of generation
# - Always refer to the official documentation for the most up-to-date information
# - Official Documentation: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/flow_log
# - AWS Service Documentation: https://docs.aws.amazon.com/vpc/latest/userguide/flow-logs.html
#
# RESOURCE OVERVIEW:
# Provides a VPC/Subnet/ENI/Transit Gateway/Transit Gateway Attachment Flow Log
# to capture IP traffic for a specific network interface, subnet, or VPC. Logs
# can be sent to a CloudWatch Log Group, an S3 Bucket, or Amazon Data Firehose.
#
# ============================================================================

resource "aws_flow_log" "example" {
  # --------------------------------------------------------------------------
  # Resource Attachment (One of the following is required)
  # --------------------------------------------------------------------------

  # eni_id - (Optional) Elastic Network Interface ID to attach to
  # Captures traffic for a specific network interface
  # Type: string
  # Example: "eni-1234567890abcdef0"
  eni_id = null

  # regional_nat_gateway_id - (Optional) Regional NAT Gateway ID to attach to
  # Captures traffic for a specific NAT gateway
  # Type: string
  # Example: "nat-1234567890abcdef0"
  regional_nat_gateway_id = null

  # subnet_id - (Optional) Subnet ID to attach to
  # Captures traffic for all ENIs in the subnet
  # Type: string
  # Example: "subnet-1234567890abcdef0"
  subnet_id = null

  # transit_gateway_id - (Optional) Transit Gateway ID to attach to
  # Captures traffic for the transit gateway
  # Type: string
  # Example: "tgw-1234567890abcdef0"
  # Note: When specified, max_aggregation_interval must be 60 seconds
  transit_gateway_id = null

  # transit_gateway_attachment_id - (Optional) Transit Gateway Attachment ID to attach to
  # Captures traffic for a specific transit gateway attachment
  # Type: string
  # Example: "tgw-attach-1234567890abcdef0"
  # Note: When specified, max_aggregation_interval must be 60 seconds
  transit_gateway_attachment_id = null

  # vpc_id - (Optional) VPC ID to attach to
  # Captures traffic for all ENIs in the VPC
  # Type: string
  # Example: "vpc-1234567890abcdef0"
  vpc_id = null

  # NOTE: One of eni_id, regional_nat_gateway_id, subnet_id, transit_gateway_id,
  # transit_gateway_attachment_id, or vpc_id must be specified

  # --------------------------------------------------------------------------
  # Traffic Configuration
  # --------------------------------------------------------------------------

  # traffic_type - (Optional) The type of traffic to capture
  # Required if eni_id, regional_nat_gateway_id, subnet_id, or vpc_id is specified
  # Valid values: "ACCEPT", "REJECT", "ALL"
  # - ACCEPT: Only accepted traffic
  # - REJECT: Only rejected traffic
  # - ALL: Both accepted and rejected traffic
  # Type: string
  # Default: N/A (must be specified when using VPC/subnet/ENI/NAT Gateway)
  traffic_type = "ALL"

  # --------------------------------------------------------------------------
  # Destination Configuration
  # --------------------------------------------------------------------------

  # log_destination_type - (Optional) Logging destination type
  # Valid values: "cloud-watch-logs", "s3", "kinesis-data-firehose"
  # Type: string
  # Default: "cloud-watch-logs"
  # AWS API Reference: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_CreateFlowLogs.html
  log_destination_type = "cloud-watch-logs"

  # log_destination - (Optional) ARN of the logging destination
  # - For CloudWatch Logs: ARN of CloudWatch Logs log group
  # - For S3: ARN of S3 bucket (can include subfolder)
  # - For Kinesis Data Firehose: ARN of delivery stream
  # Type: string
  # Example (CloudWatch): "arn:aws:logs:us-east-1:123456789012:log-group:/aws/vpc/flowlogs"
  # Example (S3): "arn:aws:s3:::my-flow-logs-bucket/logs/"
  # Example (Firehose): "arn:aws:firehose:us-east-1:123456789012:deliverystream/my-stream"
  log_destination = null

  # --------------------------------------------------------------------------
  # IAM Configuration
  # --------------------------------------------------------------------------

  # iam_role_arn - (Optional) ARN of the IAM role used to post flow logs
  # Required when log_destination_type is "cloud-watch-logs"
  # Corresponds to DeliverLogsPermissionArn in the AWS API
  # The role must have permissions to create log groups, log streams, and put log events
  # Type: string
  # Example: "arn:aws:iam::123456789012:role/flowlogsRole"
  # AWS Documentation: https://docs.aws.amazon.com/vpc/latest/userguide/flow-logs-cwl.html
  iam_role_arn = null

  # deliver_cross_account_role - (Optional) ARN of the IAM role in the destination account
  # Used for cross-account delivery of flow logs
  # The role name must start with "AWSLogDeliveryFirehoseCrossAccountRole"
  # Type: string
  # Example: "arn:aws:iam::987654321098:role/AWSLogDeliveryFirehoseCrossAccountRole"
  deliver_cross_account_role = null

  # --------------------------------------------------------------------------
  # Log Format Configuration
  # --------------------------------------------------------------------------

  # log_format - (Optional) The fields to include in the flow log record
  # Allows customization of which fields are logged
  # Type: string
  # Default: AWS default format
  # Example: "${interface-id} ${srcaddr} ${dstaddr} ${srcport} ${dstport}"
  # Full example: "${version} ${account-id} ${interface-id} ${srcaddr} ${dstaddr} ${srcport} ${dstport} ${protocol} ${packets} ${bytes} ${start} ${end} ${action} ${log-status}"
  # AWS Documentation: https://docs.aws.amazon.com/vpc/latest/userguide/flow-logs.html#flow-logs-fields
  log_format = null

  # max_aggregation_interval - (Optional) Maximum interval for flow aggregation
  # The maximum interval of time during which a flow of packets is captured
  # and aggregated into a flow log record
  # Valid values: 60 (1 minute) or 600 (10 minutes)
  # Type: number
  # Default: 600
  # Note: When transit_gateway_id or transit_gateway_attachment_id is specified,
  # this must be 60 seconds
  # Note: For network interfaces attached to Nitro-based instances, the aggregation
  # interval is always 60 seconds or less, regardless of the specified value
  max_aggregation_interval = 600

  # --------------------------------------------------------------------------
  # S3 Destination Options
  # --------------------------------------------------------------------------

  # destination_options - (Optional) Describes the destination options for a flow log
  # Only applicable when log_destination_type is "s3"
  # Maximum items: 1
  destination_options {
    # file_format - (Optional) File format for the flow log
    # Valid values: "plain-text", "parquet"
    # Type: string
    # Default: "plain-text"
    # Parquet format can reduce storage costs and improve query performance
    file_format = "plain-text"

    # hive_compatible_partitions - (Optional) Use Hive-compatible prefixes for flow logs
    # Indicates whether to use Hive-compatible prefixes for flow logs stored in S3
    # Useful when querying logs with services like Amazon Athena
    # Type: bool
    # Default: false
    hive_compatible_partitions = false

    # per_hour_partition - (Optional) Partition the flow log per hour
    # Reduces the cost and response time for queries
    # Type: bool
    # Default: false
    per_hour_partition = false
  }

  # --------------------------------------------------------------------------
  # Tags
  # --------------------------------------------------------------------------

  # tags - (Optional) Key-value map of resource tags
  # Type: map(string)
  # If configured with a provider default_tags configuration block, tags with
  # matching keys will overwrite those defined at the provider level
  tags = {
    Name        = "example-flow-log"
    Environment = "production"
  }

  # tags_all - (Optional) Map of tags assigned to the resource
  # This attribute is managed by Terraform and includes tags inherited from
  # the provider default_tags configuration block
  # Type: map(string)
  # Computed: true (automatically managed)
  tags_all = null

  # --------------------------------------------------------------------------
  # Regional Configuration
  # --------------------------------------------------------------------------

  # region - (Optional) Region where this resource will be managed
  # Defaults to the region set in the provider configuration
  # Type: string
  # Example: "us-east-1"
  # AWS Regions: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  # id - (Optional) Flow Log ID
  # Can be imported using the flow log ID
  # Type: string
  # Computed: true
  # This is typically set by Terraform after resource creation
  id = null
}

# ============================================================================
# Computed Attributes (Read-Only)
# ============================================================================
# The following attributes are computed by AWS and cannot be set directly:
#
# - arn: ARN of the Flow Log
#   Type: string
#   Example: "arn:aws:ec2:us-east-1:123456789012:vpc-flow-log/fl-1234567890abcdef0"
#
# ============================================================================
# Usage Examples
# ============================================================================

# Example 1: CloudWatch Logs Destination
# resource "aws_flow_log" "cloudwatch_example" {
#   iam_role_arn    = aws_iam_role.flow_log_role.arn
#   log_destination = aws_cloudwatch_log_group.flow_log_group.arn
#   traffic_type    = "ALL"
#   vpc_id          = aws_vpc.main.id
# }

# Example 2: S3 Destination with Parquet Format
# resource "aws_flow_log" "s3_parquet_example" {
#   log_destination      = aws_s3_bucket.flow_logs.arn
#   log_destination_type = "s3"
#   traffic_type         = "ALL"
#   vpc_id               = aws_vpc.main.id
#
#   destination_options {
#     file_format        = "parquet"
#     per_hour_partition = true
#   }
# }

# Example 3: Kinesis Data Firehose Destination
# resource "aws_flow_log" "firehose_example" {
#   log_destination      = aws_kinesis_firehose_delivery_stream.flow_logs.arn
#   log_destination_type = "kinesis-data-firehose"
#   traffic_type         = "ALL"
#   vpc_id               = aws_vpc.main.id
# }

# Example 4: Subnet-level Flow Log with Custom Format
# resource "aws_flow_log" "subnet_custom_format" {
#   log_destination      = aws_s3_bucket.flow_logs.arn
#   log_destination_type = "s3"
#   traffic_type         = "REJECT"
#   subnet_id            = aws_subnet.private.id
#   log_format           = "${interface-id} ${srcaddr} ${dstaddr} ${srcport} ${dstport} ${protocol} ${packets} ${bytes} ${start} ${end} ${action} ${log-status}"
# }

# Example 5: Cross-Account Firehose Delivery
# resource "aws_flow_log" "cross_account_example" {
#   log_destination_type       = "kinesis-data-firehose"
#   log_destination            = "arn:aws:firehose:us-east-1:987654321098:deliverystream/flow-logs"
#   traffic_type               = "ALL"
#   vpc_id                     = aws_vpc.main.id
#   iam_role_arn               = aws_iam_role.source_account_role.arn
#   deliver_cross_account_role = "arn:aws:iam::987654321098:role/AWSLogDeliveryFirehoseCrossAccountRole"
# }

# ============================================================================
# Additional Resources
# ============================================================================
# - Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/flow_log
# - AWS VPC Flow Logs: https://docs.aws.amazon.com/vpc/latest/userguide/flow-logs.html
# - AWS API Reference: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_FlowLog.html
# - S3 Flow Logs: https://docs.aws.amazon.com/vpc/latest/userguide/flow-logs-s3-create-flow-log.html
# - Firehose Flow Logs: https://docs.aws.amazon.com/vpc/latest/userguide/flow-logs-firehose.html
# ============================================================================
