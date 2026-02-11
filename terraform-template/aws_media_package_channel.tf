################################################################################
# AWS MediaPackage Channel
################################################################################

# AWS MediaPackage Channel is used to receive content streams and is the input
# to MediaPackage for incoming live content from an encoder like AWS Elemental
# MediaLive. The channel receives content, packages it, and outputs it through
# an origin endpoint to downstream devices (video players or CDNs).
#
# Key Features:
# - Receives and packages live video content for delivery to various devices
# - Provides fixed input URLs (HLS ingest endpoints) for the channel's lifetime
# - Automatically scales resources based on incoming content
# - Supports redundant inputs for high availability
# - Integrates with AWS Elemental MediaLive and other encoders
#
# Use Cases:
# - Live streaming events (sports, concerts, conferences)
# - 24/7 live channels (news, entertainment)
# - Live-to-VOD content delivery workflows
# - Multi-device streaming (Apple devices, browsers, mobile apps)
#
# Important Notes:
# - After creating a channel, you must add an endpoint to enable content playback
# - The channel provides two ingest endpoint URLs for redundancy
# - Input URLs contain username and password credentials for the upstream encoder
# - Avoid entering sensitive information in free-form fields (Name, Description)
# - The channel becomes active immediately after creation
#
# Related Resources:
# - aws_media_package_endpoint (required for content playback)
# - aws_medialive_channel (common upstream source)
# - aws_cloudwatch_log_group (for monitoring)
#
# References:
# - Create Channel API: https://docs.aws.amazon.com/mediapackage/latest/APIReference/API_CreateChannel.html
# - Channels Overview: https://docs.aws.amazon.com/mediapackage/latest/ug/channels.html
# - Getting Started: https://docs.aws.amazon.com/mediapackage/latest/ug/getting-started-live.html
# - Provider Version: 6.28.0

resource "aws_media_package_channel" "example" {
  #------------------------------------------------------------------------------
  # Required Arguments
  #------------------------------------------------------------------------------

  # Unique identifier for the channel
  # - Must be unique within your AWS account and region
  # - Used as the primary identifier for the channel
  # - Cannot be changed after creation
  # - Recommended format: alphanumeric with hyphens (e.g., "my-live-channel")
  # - Avoid using sensitive information in the channel ID
  # - Will be included in the input URLs provided by MediaPackage
  #
  # Example values:
  # - "live-sports-channel"
  # - "news-24-7"
  # - "concert-stream-2024"
  channel_id = "my-live-channel"

  #------------------------------------------------------------------------------
  # Optional Arguments
  #------------------------------------------------------------------------------

  # Human-readable description of the channel
  # - Helps identify the channel's purpose
  # - Not used for operational purposes
  # - Avoid including sensitive information (may appear in logs/CloudWatch Events)
  # - Maximum length and character restrictions may apply
  #
  # Example values:
  # - "Primary live sports streaming channel"
  # - "24/7 news broadcast channel"
  # - "Corporate events and webinar channel"
  # description = "Live streaming channel for sports events"

  # AWS region where the channel will be created
  # - If not specified, defaults to the provider's configured region
  # - Important for latency considerations (choose region close to your encoder)
  # - Must match the region of associated resources (endpoints, MediaLive channels)
  # - Once set, the channel cannot be moved to another region
  #
  # Example values:
  # - "us-east-1"
  # - "us-west-2"
  # - "eu-west-1"
  # - "ap-northeast-1"
  # region = "us-east-1"

  # Tags for resource organization and cost tracking
  # - Applied to the channel resource
  # - Useful for billing, access control, and resource organization
  # - Can be used with AWS Cost Explorer for cost allocation
  # - Maximum of 50 tags per resource
  # - Tag keys and values are case-sensitive
  #
  # Common tag examples:
  # - Environment: dev, staging, production
  # - Project: project name or identifier
  # - CostCenter: for billing purposes
  # - Owner: team or individual responsible
  tags = {
    Name        = "my-live-channel"
    Environment = "production"
    Application = "live-streaming"
    ManagedBy   = "terraform"
  }

  # All tags including those managed by the provider
  # - Computed attribute that includes both user-defined tags and provider default tags
  # - Automatically managed by Terraform
  # - Do not set this directly; use 'tags' instead
  # - Useful for outputs when you need the complete tag set
  # tags_all = {} # Computed - do not set manually

  #------------------------------------------------------------------------------
  # Computed Attributes (Read-only)
  #------------------------------------------------------------------------------

  # The following attributes are computed by AWS and available after creation:
  #
  # id - The unique identifier of the channel (same as channel_id)
  #      Format: channel_id value
  #
  # arn - Amazon Resource Name (ARN) of the channel
  #       Format: arn:aws:mediapackage:region:account-id:channels/channel_id
  #       Use for: IAM policies, cross-service references
  #
  # hls_ingest - HLS ingest configuration (list of objects)
  #   Contains ingest_endpoints list with the following for each endpoint:
  #   - url: The URL for the HLS ingest endpoint (HTTP PUT requests)
  #   - username: Username for authentication to the ingest endpoint
  #   - password: Password for authentication to the ingest endpoint
  #
  #   Note: Two ingest endpoints are provided for redundancy
  #   These credentials must be configured in your upstream encoder
  #   The URLs are fixed for the channel's lifetime
  #
  #   Example access pattern:
  #   aws_media_package_channel.example.hls_ingest[0].ingest_endpoints[0].url
  #   aws_media_package_channel.example.hls_ingest[0].ingest_endpoints[0].username
  #   aws_media_package_channel.example.hls_ingest[0].ingest_endpoints[0].password

  #------------------------------------------------------------------------------
  # Post-Creation Steps
  #------------------------------------------------------------------------------

  # After creating the channel:
  # 1. Create an aws_media_package_endpoint to enable content playback
  # 2. Configure your upstream encoder (e.g., MediaLive) with the ingest URLs
  # 3. Set up CloudWatch monitoring for the channel
  # 4. Test the streaming workflow end-to-end
  #
  # Example endpoint creation:
  # resource "aws_media_package_endpoint" "example" {
  #   channel_id = aws_media_package_channel.example.id
  #   endpoint_id = "my-hls-endpoint"
  #   # ... additional endpoint configuration
  # }
  #
  # Example output for encoder configuration:
  # output "ingest_endpoints" {
  #   value = aws_media_package_channel.example.hls_ingest[0].ingest_endpoints
  #   sensitive = true
  # }
}

################################################################################
# Outputs
################################################################################

# Channel ARN for use in IAM policies and cross-service references
output "media_package_channel_arn" {
  description = "ARN of the MediaPackage channel"
  value       = aws_media_package_channel.example.arn
}

# Channel ID for creating endpoints
output "media_package_channel_id" {
  description = "ID of the MediaPackage channel"
  value       = aws_media_package_channel.example.id
}

# HLS ingest endpoints (marked sensitive due to credentials)
# Use these to configure your upstream encoder
output "media_package_channel_ingest_endpoints" {
  description = "HLS ingest endpoints with credentials for upstream encoder configuration"
  value       = aws_media_package_channel.example.hls_ingest
  sensitive   = true
}

# Primary ingest endpoint URL
output "media_package_channel_primary_ingest_url" {
  description = "Primary HLS ingest endpoint URL"
  value       = try(aws_media_package_channel.example.hls_ingest[0].ingest_endpoints[0].url, null)
  sensitive   = true
}

# Secondary ingest endpoint URL (for redundancy)
output "media_package_channel_secondary_ingest_url" {
  description = "Secondary HLS ingest endpoint URL for redundancy"
  value       = try(aws_media_package_channel.example.hls_ingest[0].ingest_endpoints[1].url, null)
  sensitive   = true
}

################################################################################
# Example Configurations
################################################################################

# Example 1: Basic live streaming channel
# resource "aws_media_package_channel" "basic" {
#   channel_id  = "basic-live-stream"
#   description = "Basic live streaming channel"
#
#   tags = {
#     Name        = "basic-live-stream"
#     Environment = "production"
#   }
# }

# Example 2: Multi-region channel with specific region
# resource "aws_media_package_channel" "regional" {
#   channel_id  = "apac-live-stream"
#   description = "Live streaming channel for APAC region"
#   region      = "ap-southeast-1"
#
#   tags = {
#     Name        = "apac-live-stream"
#     Environment = "production"
#     Region      = "apac"
#   }
# }

# Example 3: Development/testing channel
# resource "aws_media_package_channel" "dev" {
#   channel_id  = "dev-test-channel"
#   description = "Development and testing channel"
#
#   tags = {
#     Name        = "dev-test-channel"
#     Environment = "development"
#     AutoDelete  = "true"
#   }
# }

# Example 4: Channel with comprehensive tagging
# resource "aws_media_package_channel" "tagged" {
#   channel_id  = "enterprise-live-events"
#   description = "Enterprise live events streaming channel"
#
#   tags = {
#     Name          = "enterprise-live-events"
#     Environment   = "production"
#     Application   = "live-streaming"
#     CostCenter    = "marketing"
#     Owner         = "media-team"
#     Compliance    = "required"
#     BackupPolicy  = "daily"
#     ManagedBy     = "terraform"
#   }
# }

################################################################################
# Integration Examples
################################################################################

# Example: Complete live streaming workflow with MediaPackage channel and endpoint
#
# # Create the channel
# resource "aws_media_package_channel" "live" {
#   channel_id  = "live-event-channel"
#   description = "Live event streaming channel"
#
#   tags = {
#     Name = "live-event-channel"
#   }
# }
#
# # Create an HLS endpoint for the channel
# resource "aws_media_package_endpoint" "hls" {
#   channel_id  = aws_media_package_channel.live.id
#   endpoint_id = "hls-endpoint"
#
#   hls_package {
#     segment_duration_seconds = 6
#   }
# }
#
# # Output the ingest credentials for encoder configuration
# output "encoder_config" {
#   value = {
#     primary_url   = aws_media_package_channel.live.hls_ingest[0].ingest_endpoints[0].url
#     primary_user  = aws_media_package_channel.live.hls_ingest[0].ingest_endpoints[0].username
#     primary_pass  = aws_media_package_channel.live.hls_ingest[0].ingest_endpoints[0].password
#     secondary_url = aws_media_package_channel.live.hls_ingest[0].ingest_endpoints[1].url
#   }
#   sensitive = true
# }

################################################################################
# Best Practices
################################################################################

# 1. Redundancy and High Availability
#    - Always configure your encoder to use both ingest endpoints
#    - Implement failover logic in your encoder
#    - Monitor both ingest endpoints for availability
#
# 2. Security
#    - Store ingest credentials securely (use AWS Secrets Manager or Parameter Store)
#    - Rotate credentials periodically using the credential rotation feature
#    - Mark outputs containing credentials as sensitive
#    - Use IAM policies to restrict access to the channel
#    - Enable CloudWatch Logs for ingress/egress access monitoring
#
# 3. Monitoring and Logging
#    - Set up CloudWatch alarms for key metrics:
#      * IngressBytes and EgressBytes
#      * IngressResponseTime
#      * 4xx and 5xx error rates
#    - Enable access logs for troubleshooting
#    - Monitor the health of ingest endpoints
#
# 4. Cost Optimization
#    - Delete unused channels to avoid charges
#    - Monitor data transfer costs (ingress/egress)
#    - Use appropriate endpoint configurations to optimize bandwidth
#    - Consider region selection for cost optimization
#
# 5. Naming and Tagging
#    - Use consistent naming conventions for channel_id
#    - Avoid sensitive information in channel IDs and descriptions
#    - Tag resources for cost allocation and organization
#    - Use environment-specific tags for resource filtering
#
# 6. Lifecycle Management
#    - Always delete endpoints before deleting the channel
#    - Use Terraform's prevent_destroy lifecycle rule for production channels
#    - Implement proper cleanup procedures for temporary channels
#
# 7. Regional Considerations
#    - Choose a region close to your encoder for lower latency
#    - Consider multi-region deployments for global audiences
#    - Be aware of service availability in different regions
#
# 8. Testing
#    - Test the complete workflow before production use
#    - Verify both ingest endpoints function correctly
#    - Test failover scenarios
#    - Validate downstream playback through endpoints

################################################################################
# Troubleshooting
################################################################################

# Common Issues:
#
# 1. Channel Creation Fails
#    - Check if you've exceeded account quotas (request increase via Service Quotas)
#    - Verify IAM permissions for mediapackage:CreateChannel
#    - Ensure channel_id is unique within your account/region
#
# 2. Encoder Cannot Connect
#    - Verify ingest endpoint URLs are correctly configured
#    - Check username and password are correctly copied (no extra spaces)
#    - Ensure encoder has network access to AWS endpoints
#    - Verify HLS stream format is compatible
#
# 3. No Content Flowing
#    - Check encoder is actively sending content
#    - Verify encoder is using the correct ingest URL format
#    - Check CloudWatch metrics for IngressBytes
#    - Review encoder logs for errors
#
# 4. Terraform State Issues
#    - If channel exists but Terraform shows as missing, import it:
#      terraform import aws_media_package_channel.example channel_id
#
# 5. Tags Not Updating
#    - Check for provider-level default_tags configuration
#    - Verify IAM permissions for mediapackage:TagResource

################################################################################
# Additional Resources
################################################################################

# Documentation:
# - AWS MediaPackage User Guide: https://docs.aws.amazon.com/mediapackage/latest/ug/
# - API Reference: https://docs.aws.amazon.com/mediapackage/latest/apireference/
# - Terraform AWS Provider: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/media_package_channel
#
# Related Services:
# - AWS Elemental MediaLive: Encode live video for broadcast and streaming
# - AWS Elemental MediaConnect: Reliable transport for live video
# - Amazon CloudFront: Global content delivery network
# - AWS Elemental MediaTailor: Server-side ad insertion
#
# Support:
# - AWS Support: https://console.aws.amazon.com/support/
# - MediaPackage Service Quotas: https://docs.aws.amazon.com/mediapackage/latest/ug/limits.html
# - Terraform Issues: https://github.com/hashicorp/terraform-provider-aws/issues
