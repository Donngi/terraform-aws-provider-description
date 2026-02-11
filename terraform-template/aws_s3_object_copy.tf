# ============================================================
# AWS S3 Object Copy Resource
# ============================================================
# Provides a resource for copying an S3 object.
#
# This resource creates a copy of an existing S3 object within the same
# or different bucket. It supports copying objects with various options
# including encryption, metadata, ACLs, and conditional copy operations.
#
# Provider Version: 6.28.0
# Resource: aws_s3_object_copy
# Documentation: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object_copy
# ============================================================

resource "aws_s3_object_copy" "example" {
  # ============================================================
  # Required Arguments
  # ============================================================

  # (Required) Name of the destination bucket where the object will be copied
  # Type: string
  bucket = "destination-bucket-name"

  # (Required) Name of the object once it is in the destination bucket
  # Type: string
  # Note: Terraform ignores all leading `/`s and treats multiple `/`s as a single `/`
  # Example: `/index.html` and `index.html` refer to the same object
  key = "destination/path/object-key"

  # (Required) Specifies the source object for the copy operation
  # Type: string
  # Format options:
  #   - For regular buckets: "source-bucket-name/source-object-key"
  #   - For access point objects: "arn:aws:s3:<region>:<account-id>:accesspoint/<access-point-name>/object/<key>"
  # Example: "source-bucket/path/to/source-object.json"
  source = "source-bucket-name/source-object-key"

  # ============================================================
  # Optional - Basic Configuration
  # ============================================================

  # (Optional) Region where this resource will be managed
  # Type: string
  # Default: Provider region
  # region = "us-east-1"

  # (Optional) Canned ACL to apply to the object
  # Type: string (computed)
  # Valid values: private, public-read, public-read-write, authenticated-read,
  #               aws-exec-read, bucket-owner-read, bucket-owner-full-control
  # Conflicts with: grant
  # acl = "private"

  # (Optional) Specifies caching behavior along the request/reply chain
  # Type: string (computed)
  # Reference: http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.9
  # cache_control = "max-age=3600"

  # (Optional) Standard MIME type describing the format of the object data
  # Type: string (computed)
  # Example: "application/json", "text/html", "image/png"
  # content_type = "application/octet-stream"

  # (Optional) Presentational information for the object
  # Type: string (computed)
  # Reference: http://www.w3.org/Protocols/rfc2616/rfc2616-sec19.html#sec19.5.1
  # content_disposition = "attachment; filename=\"download.txt\""

  # (Optional) Content encodings applied to the object
  # Type: string (computed)
  # Reference: http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.11
  # content_encoding = "gzip"

  # (Optional) Language the content is in
  # Type: string (computed)
  # Example: "en-US", "en-GB", "ja-JP"
  # content_language = "en-US"

  # (Optional) Target URL for website redirect
  # Type: string (computed)
  # Reference: http://docs.aws.amazon.com/AmazonS3/latest/dev/how-to-page-redirect.html
  # website_redirect = "https://example.com/new-location"

  # ============================================================
  # Optional - Conditional Copy Operations
  # ============================================================

  # (Optional) Copies the object if its entity tag (ETag) matches the specified tag
  # Type: string
  # copy_if_match = "\"abc123def456\""

  # (Optional) Copies the object if it has been modified since the specified time
  # Type: string
  # Format: RFC3339 (https://tools.ietf.org/html/rfc3339#section-5.8)
  # copy_if_modified_since = "2024-01-01T00:00:00Z"

  # (Optional) Copies the object if its entity tag (ETag) is different than specified
  # Type: string
  # copy_if_none_match = "\"abc123def456\""

  # (Optional) Copies the object if it hasn't been modified since the specified time
  # Type: string
  # Format: RFC3339
  # copy_if_unmodified_since = "2024-01-01T00:00:00Z"

  # ============================================================
  # Optional - Metadata and Directives
  # ============================================================

  # (Optional) Map of keys/values to provision metadata
  # Type: map(string) (computed)
  # Note: Only lowercase labels are currently supported by the AWS Go API
  # Keys will be automatically prefixed by `x-amz-meta-`
  # metadata = {
  #   "source-system" = "backup-service"
  #   "copied-date"   = "2024-01-01"
  # }

  # (Optional) Specifies whether metadata is copied or replaced
  # Type: string
  # Valid values: COPY, REPLACE
  # Default: COPY (if not specified)
  # metadata_directive = "COPY"

  # (Optional) Specifies whether object tag-set is copied or replaced
  # Type: string
  # Valid values: COPY, REPLACE
  # Default: COPY (if not specified)
  # tagging_directive = "COPY"

  # (Optional) Map of tags to assign to the object
  # Type: map(string)
  # Note: Tags with matching keys will overwrite provider default_tags
  # tags = {
  #   Environment = "production"
  #   Application = "data-migration"
  #   CopiedFrom  = "source-bucket"
  # }

  # ============================================================
  # Optional - Server-Side Encryption (Destination)
  # ============================================================

  # (Optional) Server-side encryption of the object in S3
  # Type: string (computed)
  # Valid values: AES256, aws:kms
  # server_side_encryption = "aws:kms"

  # (Optional) AWS KMS Key ARN to use for object encryption
  # Type: string (computed, sensitive)
  # Note: Use the exported `arn` attribute from aws_kms_key resource
  # Example: kms_key_id = aws_kms_key.example.arn
  # kms_key_id = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"

  # (Optional) AWS KMS Encryption Context to use for object encryption
  # Type: string (computed, sensitive)
  # Format: Base64-encoded UTF-8 string holding JSON with key-value pairs
  # kms_encryption_context = "base64-encoded-json-context"

  # (Optional) Specifies whether Amazon S3 should use an S3 Bucket Key for object encryption
  # Type: bool (computed)
  # bucket_key_enabled = true

  # ============================================================
  # Optional - Customer-Provided Encryption (Destination)
  # ============================================================

  # (Optional) Algorithm to use when encrypting the object (destination)
  # Type: string (computed)
  # Example: "AES256"
  # customer_algorithm = "AES256"

  # (Optional) Customer-provided encryption key for Amazon S3 to use (destination)
  # Type: string (sensitive)
  # Note: This value is used to store the object and then discarded
  # customer_key = "base64-encoded-256-bit-key"

  # (Optional) 128-bit MD5 digest of the encryption key according to RFC 1321
  # Type: string (computed)
  # customer_key_md5 = "base64-encoded-md5-digest"

  # ============================================================
  # Optional - Source Object Encryption
  # ============================================================

  # (Optional) Algorithm to use when decrypting the source object
  # Type: string
  # Example: "AES256"
  # source_customer_algorithm = "AES256"

  # (Optional) Customer-provided encryption key to decrypt the source object
  # Type: string (sensitive)
  # Note: Must be the same key used when the source object was created
  # source_customer_key = "base64-encoded-256-bit-key"

  # (Optional) 128-bit MD5 digest of the source object encryption key
  # Type: string
  # source_customer_key_md5 = "base64-encoded-md5-digest"

  # ============================================================
  # Optional - Checksum Configuration
  # ============================================================

  # (Optional) Algorithm used to create the checksum for the object
  # Type: string
  # Valid values: CRC32, CRC32C, CRC64NVME, SHA1, SHA256
  # Note: If object is encrypted with KMS, you must have kms:Decrypt permission
  # checksum_algorithm = "SHA256"

  # ============================================================
  # Optional - Storage and Expiration
  # ============================================================

  # (Optional) Desired storage class for the object
  # Type: string (computed)
  # Valid values: STANDARD, REDUCED_REDUNDANCY, STANDARD_IA, ONEZONE_IA,
  #               INTELLIGENT_TIERING, GLACIER, DEEP_ARCHIVE, GLACIER_IR
  # Default: STANDARD
  # Reference: https://docs.aws.amazon.com/AmazonS3/latest/API/API_CopyObject.html#AmazonS3-CopyObject-request-header-StorageClass
  # storage_class = "STANDARD"

  # (Optional) Date and time at which the object is no longer cacheable
  # Type: string
  # Format: RFC3339
  # expires = "2025-12-31T23:59:59Z"

  # ============================================================
  # Optional - Object Lock Configuration
  # ============================================================

  # (Optional) Legal hold status to apply to the object
  # Type: string (computed)
  # Valid values: ON, OFF
  # Reference: https://docs.aws.amazon.com/AmazonS3/latest/dev/object-lock-overview.html#object-lock-legal-holds
  # object_lock_legal_hold_status = "ON"

  # (Optional) Object lock retention mode to apply
  # Type: string (computed)
  # Valid values: GOVERNANCE, COMPLIANCE
  # Reference: https://docs.aws.amazon.com/AmazonS3/latest/dev/object-lock-overview.html#object-lock-retention-modes
  # object_lock_mode = "GOVERNANCE"

  # (Optional) Date and time when object lock will expire
  # Type: string (computed)
  # Format: RFC3339
  # Reference: https://docs.aws.amazon.com/AmazonS3/latest/dev/object-lock-overview.html#object-lock-retention-periods
  # object_lock_retain_until_date = "2025-12-31T23:59:59Z"

  # ============================================================
  # Optional - Access Control and Ownership
  # ============================================================

  # (Optional) Account ID of the expected destination bucket owner
  # Type: string
  # Note: Request will fail with HTTP 403 if owner doesn't match
  # expected_bucket_owner = "123456789012"

  # (Optional) Account ID of the expected source bucket owner
  # Type: string
  # Note: Request will fail with HTTP 403 if owner doesn't match
  # expected_source_bucket_owner = "123456789012"

  # (Optional) Confirms requester will be charged for the request
  # Type: string
  # Valid value: requester
  # Note: Only needed for requester pays buckets
  # Reference: https://docs.aws.amazon.com/AmazonS3/latest/dev/ObjectsinRequesterPaysBuckets.html
  # request_payer = "requester"

  # ============================================================
  # Optional - Lifecycle Management
  # ============================================================

  # (Optional) Allow the object to be deleted by removing any legal hold
  # Type: bool
  # Default: false
  # Note: Set to true only if the bucket has S3 object lock enabled
  # force_destroy = false

  # ============================================================
  # Optional - Grant Block (ACL Alternative)
  # ============================================================
  # Conflicts with: acl
  # Use this for more granular access control

  # grant {
  #   # (Required) List of permissions to grant
  #   # Valid values: READ, READ_ACP, WRITE_ACP, FULL_CONTROL
  #   permissions = ["READ", "READ_ACP"]
  #
  #   # (Required) Type of grantee
  #   # Valid values: CanonicalUser, Group, AmazonCustomerByEmail
  #   type = "CanonicalUser"
  #
  #   # (Optional) Canonical user ID of the grantee
  #   # Used only when type is CanonicalUser
  #   id = "canonical-user-id"
  #
  #   # (Optional) Email address of the grantee
  #   # Used only when type is AmazonCustomerByEmail
  #   # email = "user@example.com"
  #
  #   # (Optional) URI of the grantee group
  #   # Used only when type is Group
  #   # uri = "http://acs.amazonaws.com/groups/global/AllUsers"
  # }

  # ============================================================
  # Optional - Override Provider Configuration
  # ============================================================

  # override_provider {
  #   default_tags {
  #     # (Optional) Override provider default_tags
  #     # Set to empty map to ignore provider default_tags
  #     tags = {}
  #   }
  # }
}

# ============================================================
# Computed Attributes (Read-Only Outputs)
# ============================================================
# These attributes are automatically set by AWS and can be
# referenced as: aws_s3_object_copy.example.<attribute_name>

# arn                     - ARN of the object
# checksum_crc32          - Base64-encoded, 32-bit CRC32 checksum of the object
# checksum_crc32c         - Base64-encoded, 32-bit CRC32C checksum of the object
# checksum_crc64nvme      - Base64-encoded, 64-bit CRC64NVME checksum of the object
# checksum_sha1           - Base64-encoded, 160-bit SHA-1 digest of the object
# checksum_sha256         - Base64-encoded, 256-bit SHA-256 digest of the object
# etag                    - ETag generated for the object (MD5 sum or other hash)
#                          Reference: https://docs.aws.amazon.com/AmazonS3/latest/API/RESTCommonResponseHeaders.html
# expiration              - Object expiration configuration (if configured)
# last_modified           - Date object was last modified (RFC3339 format)
# request_charged         - Indicates if requester was successfully charged
# source_version_id       - Version of the copied object in the source bucket
# tags_all                - Map of tags including provider default_tags
# version_id              - Version ID of the newly created copy

# ============================================================
# Usage Examples
# ============================================================

# Example 1: Simple copy within same bucket
# resource "aws_s3_object_copy" "simple" {
#   bucket = "my-bucket"
#   key    = "backup/data.json"
#   source = "my-bucket/original/data.json"
# }

# Example 2: Copy with encryption
# resource "aws_s3_object_copy" "encrypted" {
#   bucket                 = "destination-bucket"
#   key                    = "encrypted-copy.txt"
#   source                 = "source-bucket/original.txt"
#   server_side_encryption = "aws:kms"
#   kms_key_id            = aws_kms_key.example.arn
# }

# Example 3: Copy with custom metadata
# resource "aws_s3_object_copy" "with_metadata" {
#   bucket             = "destination-bucket"
#   key                = "processed/file.csv"
#   source             = "source-bucket/raw/file.csv"
#   metadata_directive = "REPLACE"
#   metadata = {
#     "processed-date" = "2024-01-01"
#     "processor"      = "etl-pipeline"
#   }
#   tags = {
#     Status = "processed"
#   }
# }

# Example 4: Conditional copy based on modification time
# resource "aws_s3_object_copy" "conditional" {
#   bucket                 = "backup-bucket"
#   key                    = "latest-backup.zip"
#   source                 = "source-bucket/data.zip"
#   copy_if_modified_since = "2024-01-01T00:00:00Z"
# }

# Example 5: Copy from access point
# resource "aws_s3_object_copy" "from_access_point" {
#   bucket = "destination-bucket"
#   key    = "copied-from-ap.txt"
#   source = "arn:aws:s3:us-west-2:123456789012:accesspoint/my-access-point/object/source-key.txt"
# }

# ============================================================
# Important Notes
# ============================================================
# 1. Path Handling: Terraform normalizes paths by removing leading
#    slashes and collapsing multiple consecutive slashes
#
# 2. Encryption: When copying encrypted objects, ensure you have
#    appropriate KMS permissions (kms:Decrypt on source, kms:Encrypt
#    on destination)
#
# 3. ETag Values: For KMS-encrypted objects or multipart uploads,
#    the ETag is not an MD5 digest
#
# 4. Cross-Account: For cross-account copies, ensure both source
#    and destination bucket policies allow the operation
#
# 5. Versioning: If source bucket has versioning enabled, use
#    source_version_id output to track which version was copied
#
# 6. Metadata Directive: Using REPLACE allows you to change metadata
#    during the copy operation
#
# 7. Object Lock: force_destroy should only be set to true when
#    the bucket has S3 Object Lock enabled and you need to remove
#    legal holds on deletion
#
# 8. Storage Class: The copied object can have a different storage
#    class than the source object
# ============================================================
