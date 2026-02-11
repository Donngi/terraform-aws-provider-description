# ==============================================================================
# aws_s3_bucket_ownership_controls
# ==============================================================================
# Provides a resource to manage S3 Bucket Ownership Controls. For more
# information, see the S3 Developer Guide:
# https://docs.aws.amazon.com/AmazonS3/latest/dev/about-object-ownership.html
#
# Note: This resource cannot be used with S3 directory buckets.
#
# Provider Version: 6.28.0
# Documentation: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/s3_bucket_ownership_controls
# ==============================================================================

resource "aws_s3_bucket_ownership_controls" "example" {
  # --------------------------------------------------------------------------
  # Required Arguments
  # --------------------------------------------------------------------------

  # bucket - (Required) Name of the bucket that you want to associate this
  # access point with.
  # Type: string
  bucket = aws_s3_bucket.example.id

  # --------------------------------------------------------------------------
  # Optional Arguments
  # --------------------------------------------------------------------------

  # region - (Optional) Region where this resource will be managed.
  # Defaults to the Region set in the provider configuration.
  # Type: string
  # region = "us-east-1"

  # --------------------------------------------------------------------------
  # Required Blocks
  # --------------------------------------------------------------------------

  # rule - (Required) Configuration block with Ownership Controls rules.
  # Note: Exactly one rule block is required (min_items: 1, max_items: 1)
  rule {
    # object_ownership - (Required) Object ownership setting.
    # Valid values:
    #   - "BucketOwnerPreferred": Objects uploaded to the bucket change
    #     ownership to the bucket owner if the objects are uploaded with
    #     the "bucket-owner-full-control" canned ACL.
    #   - "ObjectWriter": Uploading account will own the object if the object
    #     is uploaded with the "bucket-owner-full-control" canned ACL.
    #   - "BucketOwnerEnforced": Bucket owner automatically owns and has full
    #     control over every object in the bucket. ACLs no longer affect
    #     permissions to data in the S3 bucket.
    # Type: string
    object_ownership = "BucketOwnerPreferred"
  }
}

# ==============================================================================
# Computed Attributes
# ==============================================================================
# id - S3 Bucket name.

# ==============================================================================
# Example Usage
# ==============================================================================
# resource "aws_s3_bucket" "example" {
#   bucket = "example"
# }
#
# resource "aws_s3_bucket_ownership_controls" "example" {
#   bucket = aws_s3_bucket.example.id
#
#   rule {
#     object_ownership = "BucketOwnerPreferred"
#   }
# }

# ==============================================================================
# Common Patterns
# ==============================================================================

# Pattern 1: BucketOwnerEnforced (recommended for most use cases)
# This disables ACLs and ensures the bucket owner owns all objects
# resource "aws_s3_bucket_ownership_controls" "enforced" {
#   bucket = aws_s3_bucket.example.id
#
#   rule {
#     object_ownership = "BucketOwnerEnforced"
#   }
# }

# Pattern 2: BucketOwnerPreferred (for cross-account uploads)
# Allows cross-account uploads to transfer ownership with proper ACL
# resource "aws_s3_bucket_ownership_controls" "preferred" {
#   bucket = aws_s3_bucket.example.id
#
#   rule {
#     object_ownership = "BucketOwnerPreferred"
#   }
# }

# Pattern 3: ObjectWriter (legacy compatibility)
# Maintains object ownership with the uploading account
# resource "aws_s3_bucket_ownership_controls" "writer" {
#   bucket = aws_s3_bucket.example.id
#
#   rule {
#     object_ownership = "ObjectWriter"
#   }
# }

# ==============================================================================
# Important Notes
# ==============================================================================
# 1. When using BucketOwnerEnforced, all bucket ACLs and object ACLs are
#    disabled. Bucket policies and IAM policies are the only way to grant
#    access.
#
# 2. BucketOwnerPreferred requires that objects be uploaded with the
#    "bucket-owner-full-control" canned ACL for ownership to transfer.
#
# 3. Changing ownership controls may affect existing objects in the bucket.
#
# 4. This resource is often used in conjunction with:
#    - aws_s3_bucket
#    - aws_s3_bucket_acl (when not using BucketOwnerEnforced)
#    - aws_s3_bucket_public_access_block
#
# 5. For new buckets, AWS recommends using BucketOwnerEnforced to disable
#    ACLs and simplify permissions management.
