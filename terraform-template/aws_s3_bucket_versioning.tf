################################################################################
# AWS S3 Bucket Versioning
#
# Provides a resource for controlling versioning on an S3 bucket.
# Deleting this resource will either suspend versioning on the associated S3 bucket or
# simply remove the resource from Terraform state if the associated S3 bucket is unversioned.
#
# For more information, see:
# https://docs.aws.amazon.com/AmazonS3/latest/userguide/manage-versioning-examples.html
#
# NOTE: If you are enabling versioning on the bucket for the first time, AWS recommends
# that you wait for 15 minutes after enabling versioning before issuing write operations
# (PUT or DELETE) on objects in the bucket.
#
# NOTE: This resource cannot be used with S3 directory buckets.
#
# Provider Version: 6.28.0
# Resource Documentation: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/s3_bucket_versioning
################################################################################

resource "aws_s3_bucket_versioning" "example" {
  ################################################################################
  # Required Arguments
  ################################################################################

  # (Required, Forces new resource) Name of the S3 bucket.
  # Type: string
  bucket = "example-bucket-name"

  ################################################################################
  # Optional Arguments
  ################################################################################

  # (Optional, Forces new resource) Account ID of the expected bucket owner.
  # Type: string
  # expected_bucket_owner = "123456789012"

  # (Optional, Required if versioning_configuration mfa_delete is enabled)
  # Concatenation of the authentication device's serial number, a space, and the value
  # that is displayed on your authentication device.
  # Type: string
  # Example: "arn:aws:iam::123456789012:mfa/user 123456"
  # mfa = null

  # (Optional) Region where this resource will be managed.
  # Defaults to the Region set in the provider configuration.
  # See: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # Type: string (computed)
  # region = null

  ################################################################################
  # Versioning Configuration Block (Required)
  ################################################################################

  versioning_configuration {
    # (Required) Versioning state of the bucket.
    # Valid values: "Enabled", "Suspended", or "Disabled"
    # NOTE: "Disabled" should only be used when creating or importing resources that
    # correspond to unversioned S3 buckets.
    # Type: string
    status = "Enabled"

    # (Optional) Specifies whether MFA delete is enabled in the bucket versioning configuration.
    # Valid values: "Enabled" or "Disabled"
    # Type: string (computed)
    # mfa_delete = null
  }

  ################################################################################
  # Computed Attributes (Read-Only)
  ################################################################################

  # id - The bucket or bucket and expected_bucket_owner separated by a comma (,)
  #      if the latter is provided.
}

################################################################################
# Example Usage Patterns
################################################################################

# Example 1: Basic versioning enabled
# resource "aws_s3_bucket_versioning" "basic" {
#   bucket = aws_s3_bucket.example.id
#   versioning_configuration {
#     status = "Enabled"
#   }
# }

# Example 2: Versioning with expected bucket owner
# resource "aws_s3_bucket_versioning" "with_owner" {
#   bucket                = aws_s3_bucket.example.id
#   expected_bucket_owner = "123456789012"
#   versioning_configuration {
#     status = "Enabled"
#   }
# }

# Example 3: Suspending versioning
# resource "aws_s3_bucket_versioning" "suspended" {
#   bucket = aws_s3_bucket.example.id
#   versioning_configuration {
#     status = "Suspended"
#   }
# }

# Example 4: Versioning with MFA delete enabled
# resource "aws_s3_bucket_versioning" "mfa_delete" {
#   bucket = aws_s3_bucket.example.id
#   mfa    = "arn:aws:iam::123456789012:mfa/user 123456"
#   versioning_configuration {
#     status     = "Enabled"
#     mfa_delete = "Enabled"
#   }
# }

# Example 5: Object dependency on versioning
# resource "aws_s3_bucket" "example" {
#   bucket = "example-bucket"
# }
#
# resource "aws_s3_bucket_versioning" "example" {
#   bucket = aws_s3_bucket.example.id
#   versioning_configuration {
#     status = "Enabled"
#   }
# }
#
# resource "aws_s3_object" "example" {
#   bucket = aws_s3_bucket_versioning.example.id
#   key    = "example-key"
#   source = "example.txt"
# }
