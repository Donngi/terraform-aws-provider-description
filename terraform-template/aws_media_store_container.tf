# ============================================================================
# AWS MediaStore Container - Terraform Annotated Reference
# ============================================================================
# Provider Version: 6.28.0
# Resource: aws_media_store_container
# Last Updated: 2026-02-04
#
# ⚠️ IMPORTANT DEPRECATION NOTICE ⚠️
# This resource is DEPRECATED and will be removed in a future version.
# AWS has announced the discontinuation of AWS Elemental MediaStore,
# effective November 13, 2025.
#
# MIGRATION RECOMMENDATIONS:
# - Simple live streaming workflows → Migrate to Amazon S3
# - Advanced use cases (packaging, DRM, cross-region redundancy) →
#   Migrate to AWS Elemental MediaPackage
#
# For more information:
# https://aws.amazon.com/blogs/media/support-for-aws-elemental-mediastore-ending-soon/
# ============================================================================

# ----------------------------------------------------------------------------
# OVERVIEW
# ----------------------------------------------------------------------------
# AWS Elemental MediaStore is a storage service optimized for media content.
# It provides low-latency, high-throughput storage specifically designed for
# live streaming and on-demand video workflows.
#
# Key Features:
# - High-performance storage for media assets
# - Optimized for live and on-demand video workflows
# - Direct integration with AWS Elemental MediaPackage
# - CloudFront distribution support
# - Fine-grained access control via container policies
# - CORS policy support for browser-based playback
#
# Use Cases:
# - Live streaming video delivery
# - Video-on-demand (VOD) content storage
# - Time-shifted media applications
# - High-throughput media origin storage
# ⚠️ Note: Consider S3 or MediaPackage alternatives given the deprecation
# ----------------------------------------------------------------------------

# ----------------------------------------------------------------------------
# BASIC EXAMPLE
# ----------------------------------------------------------------------------
resource "aws_media_store_container" "example" {
  # (Required) The name of the container
  # Must contain alphanumeric characters or underscores only
  # This name becomes part of the container endpoint URL
  name = "example"

  # (Optional) A map of tags to assign to the resource
  # Tags help with resource organization, cost tracking, and access control
  # If configured with a provider default_tags configuration block,
  # tags with matching keys will overwrite those defined at the provider-level
  tags = {
    Environment = "production"
    Application = "video-streaming"
    ManagedBy   = "terraform"
  }

  # (Optional) Region where this resource will be managed
  # Defaults to the Region set in the provider configuration
  # Uncomment to explicitly set the region:
  # region = "us-east-1"
}

# ----------------------------------------------------------------------------
# ARGUMENT REFERENCE
# ----------------------------------------------------------------------------
#
# Required Arguments:
# -------------------
# name - (Required) The name of the container
#   - Must contain alphanumeric characters or underscores only
#   - The name must be unique within your AWS account in a specific region
#   - This name is used in the container endpoint URL
#   - Example: "live-streaming-origin", "vod_content_store"
#
# Optional Arguments:
# -------------------
# region - (Optional) Region where this resource will be managed
#   - Defaults to the Region set in the provider configuration
#   - Explicitly setting this can be useful for multi-region deployments
#   - Example: "us-east-1", "eu-west-1", "ap-northeast-1"
#
# tags - (Optional) A map of tags to assign to the resource
#   - Key-value pairs for resource organization and management
#   - If configured with a provider default_tags configuration block,
#     tags with matching keys will overwrite those defined at the provider-level
#   - Common tags: Environment, Application, Owner, CostCenter
#   - Example: { Environment = "prod", Team = "media" }
#
# ----------------------------------------------------------------------------

# ----------------------------------------------------------------------------
# ATTRIBUTE REFERENCE
# ----------------------------------------------------------------------------
# In addition to all arguments above, the following attributes are exported:
#
# arn - The ARN (Amazon Resource Name) of the container
#   - Format: arn:aws:mediastore:region:account-id:container/container-name
#   - Used for IAM policies, resource-based policies, and cross-service integrations
#   - Example: arn:aws:mediastore:us-east-1:123456789012:container/example
#
# endpoint - The DNS endpoint of the container
#   - This is the URL used to access objects within the container
#   - Format: https://<container-id>.data.mediastore.<region>.amazonaws.com
#   - Used as the origin for CloudFront distributions
#   - Required for uploading and downloading media objects
#   - Example: https://abcd1234.data.mediastore.us-east-1.amazonaws.com
#
# tags_all - A map of tags assigned to the resource
#   - Includes tags explicitly set on the resource
#   - Also includes tags inherited from the provider default_tags configuration
#   - Useful for auditing and understanding all tags applied to the resource
# ----------------------------------------------------------------------------

# ----------------------------------------------------------------------------
# OUTPUT EXAMPLES
# ----------------------------------------------------------------------------
output "media_store_container_arn" {
  description = "The ARN of the MediaStore container"
  value       = aws_media_store_container.example.arn
}

output "media_store_container_endpoint" {
  description = "The DNS endpoint URL for the MediaStore container"
  value       = aws_media_store_container.example.endpoint
}

output "media_store_container_name" {
  description = "The name of the MediaStore container"
  value       = aws_media_store_container.example.name
}

# ----------------------------------------------------------------------------
# ADVANCED EXAMPLE: Live Streaming Origin
# ----------------------------------------------------------------------------
resource "aws_media_store_container" "live_streaming" {
  name = "live_streaming_origin"

  tags = {
    Name        = "Live Streaming Origin"
    Environment = "production"
    UseCase     = "live-streaming"
    CostCenter  = "media-delivery"
    Deprecated  = "true" # Marking for migration tracking
  }
}

# Note: Container policies, CORS policies, and lifecycle policies
# are managed separately using aws_media_store_container_policy resource
# (not shown here as this is a resource-specific reference)

# ----------------------------------------------------------------------------
# ADVANCED EXAMPLE: Video-on-Demand Storage
# ----------------------------------------------------------------------------
resource "aws_media_store_container" "vod_content" {
  name = "vod_content_storage"

  tags = {
    Name        = "VOD Content Storage"
    Environment = "production"
    UseCase     = "video-on-demand"
    DataClass   = "media-assets"
    Deprecated  = "true" # Marking for migration tracking
  }
}

# ----------------------------------------------------------------------------
# INTEGRATION NOTES
# ----------------------------------------------------------------------------
# CloudFront Integration:
# - Use the container endpoint as the origin domain name in CloudFront
# - Configure CloudFront with appropriate cache behaviors
# - Enable header-based authentication for MediaStore origins
# - Example: Set Origin Domain Name to the endpoint attribute value
#
# MediaPackage Integration:
# - MediaStore can serve as an origin for MediaPackage
# - Use for packaging live and VOD content
# - Supports DRM, DASH, HLS, and CMAF formats
#
# Access Control:
# - Configure container policies using aws_media_store_container_policy
# - Supports both resource-based and IAM-based access control
# - Use IAM roles for service-to-service access
# - Configure CORS policies for browser-based playback
#
# Object Management:
# - Upload objects using AWS SDK, CLI, or MediaStore API
# - Objects are stored at the container endpoint URL
# - Folder structure can be created using path prefixes
# - Example path: /video/content/stream.m3u8
# ----------------------------------------------------------------------------

# ----------------------------------------------------------------------------
# MIGRATION GUIDANCE
# ----------------------------------------------------------------------------
# Given the deprecation of MediaStore, plan your migration strategy:
#
# Option 1: Migrate to Amazon S3
# - Best for: Simple live streaming and VOD workflows
# - Benefits: Lower cost, broader feature set, extensive integrations
# - Steps:
#   1. Create S3 buckets with appropriate lifecycle policies
#   2. Transfer media assets to S3
#   3. Update CloudFront origins to point to S3
#   4. Update application code to use S3 APIs
#
# Option 2: Migrate to AWS Elemental MediaPackage
# - Best for: Advanced workflows requiring packaging, DRM, or redundancy
# - Benefits: Built-in packaging, DRM support, origin redundancy
# - Steps:
#   1. Set up MediaPackage channels and endpoints
#   2. Configure live or VOD packaging settings
#   3. Integrate with existing MediaLive or S3 origins
#   4. Update player applications with new endpoint URLs
#
# Timeline:
# - AWS Elemental MediaStore end of support: November 13, 2025
# - Begin migration as soon as possible
# - Test thoroughly before switching production traffic
# ----------------------------------------------------------------------------

# ----------------------------------------------------------------------------
# IMPORT
# ----------------------------------------------------------------------------
# MediaStore Containers can be imported using the container name:
#
# $ terraform import aws_media_store_container.example example
#
# This allows you to bring existing MediaStore containers under Terraform
# management without recreating them.
# ----------------------------------------------------------------------------

# ----------------------------------------------------------------------------
# ADDITIONAL RESOURCES
# ----------------------------------------------------------------------------
# AWS Documentation:
# - MediaStore User Guide:
#   https://docs.aws.amazon.com/mediastore/latest/ug/
# - MediaStore API Reference:
#   https://docs.aws.amazon.com/mediastore/latest/apireference/
# - Deprecation Announcement:
#   https://aws.amazon.com/blogs/media/support-for-aws-elemental-mediastore-ending-soon/
#
# Terraform Provider Documentation:
# - aws_media_store_container:
#   https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/media_store_container
# - aws_media_store_container_policy:
#   https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/media_store_container_policy
#
# Related AWS Services:
# - Amazon S3: https://docs.aws.amazon.com/s3/
# - AWS Elemental MediaPackage: https://docs.aws.amazon.com/mediapackage/
# - Amazon CloudFront: https://docs.aws.amazon.com/cloudfront/
# ----------------------------------------------------------------------------
