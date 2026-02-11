# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# AWS Provider v6.28.0
# Resource: aws_lightsail_bucket_resource_access
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#
# Description:
#   Manages a Lightsail bucket resource access. Use this resource to grant a
#   Lightsail resource (such as an instance) access to a specific bucket.
#
# Documentation:
#   https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/lightsail_bucket_resource_access
#
# Example Use Cases:
#   - Grant Lightsail instances access to S3-compatible Lightsail buckets
#   - Enable container services to access bucket resources
#   - Configure cross-resource permissions within Lightsail
#
# Prerequisites:
#   - Existing Lightsail bucket (aws_lightsail_bucket)
#   - Existing Lightsail resource (e.g., aws_lightsail_instance)
#
# Important Notes:
#   - This resource creates a relationship between a bucket and a Lightsail resource
#   - The granted resource can read, write, and delete objects in the bucket
#   - Access is managed at the bucket level, not at individual object level
#
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

resource "aws_lightsail_bucket_resource_access" "example" {
  # ┌─────────────────────────────────────────────────────────────────────────┐
  # │ Required Arguments                                                       │
  # └─────────────────────────────────────────────────────────────────────────┘

  # bucket_name - (Required) Name of the bucket to grant access to.
  # Type: string
  # Must match an existing Lightsail bucket name
  # Example: "my-application-bucket"
  bucket_name = aws_lightsail_bucket.example.id

  # resource_name - (Required) Name of the resource to grant bucket access.
  # Type: string
  # Can be a Lightsail instance, container service, or other compatible resource
  # Must match an existing Lightsail resource name
  # Example: "my-web-instance"
  resource_name = aws_lightsail_instance.example.id


  # ┌─────────────────────────────────────────────────────────────────────────┐
  # │ Optional Arguments                                                       │
  # └─────────────────────────────────────────────────────────────────────────┘

  # region - (Optional) Region where this resource will be managed.
  # Type: string
  # Default: Provider region
  # If not specified, defaults to the Region set in the provider configuration
  # Reference: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # Example: "us-east-1"
  # region = "us-east-1"


  # ┌─────────────────────────────────────────────────────────────────────────┐
  # │ Read-Only Attributes (Exported)                                          │
  # └─────────────────────────────────────────────────────────────────────────┘

  # id - Combination of attributes separated by a comma: bucket_name,resource_name
  # Type: string
  # Format: "<bucket_name>,<resource_name>"
  # Can be used for import: terraform import aws_lightsail_bucket_resource_access.example bucket_name,resource_name
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Example: Complete Lightsail Bucket Access Setup
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Create a Lightsail bucket
resource "aws_lightsail_bucket" "example" {
  name      = "example-bucket"
  bundle_id = "small_1_0"
}

# Create a Lightsail instance
resource "aws_lightsail_instance" "example" {
  name              = "example-instance"
  availability_zone = "us-east-1b"
  blueprint_id      = "amazon_linux_2"
  bundle_id         = "nano_3_0"
}

# Grant the instance access to the bucket
resource "aws_lightsail_bucket_resource_access" "example" {
  bucket_name   = aws_lightsail_bucket.example.id
  resource_name = aws_lightsail_instance.example.id
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Outputs
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

output "bucket_access_id" {
  description = "The ID of the bucket resource access"
  value       = aws_lightsail_bucket_resource_access.example.id
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Additional Notes
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#
# Import:
#   This resource can be imported using the bucket_name and resource_name separated by a comma:
#   $ terraform import aws_lightsail_bucket_resource_access.example example-bucket,example-instance
#
# Common Patterns:
#   1. Web Application: Grant instance access to store/retrieve uploaded files
#   2. Container Service: Enable containers to access bucket for asset storage
#   3. Backup Solution: Allow instances to backup data to Lightsail buckets
#
# Security Considerations:
#   - The granted resource receives full read/write access to the bucket
#   - Consider using separate buckets for different security levels
#   - Monitor access patterns using Lightsail metrics
#   - Revoke access by destroying this resource when no longer needed
#
# Cost Implications:
#   - No additional cost for the access grant itself
#   - Standard Lightsail bucket storage and data transfer charges apply
#   - Review bucket bundle pricing: https://aws.amazon.com/lightsail/pricing/
#
# Related Resources:
#   - aws_lightsail_bucket: Create and manage Lightsail buckets
#   - aws_lightsail_bucket_access_key: Create access keys for bucket access
#   - aws_lightsail_instance: Lightsail virtual private servers
#   - aws_lightsail_container_service: Lightsail container deployments
#
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
