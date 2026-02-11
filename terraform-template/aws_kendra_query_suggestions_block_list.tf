################################################################################
# AWS Kendra Query Suggestions Block List
################################################################################

# Use the aws_kendra_index_block_list resource to manage an AWS Kendra block
# list used for query suggestions for an index.
#
# A block list allows you to define words or phrases that should be blocked
# from query suggestions. This is useful for filtering out inappropriate or
# irrelevant suggestions.
#
# Docs: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/kendra_query_suggestions_block_list
# API: https://docs.aws.amazon.com/kendra/latest/APIReference/API_CreateQuerySuggestionsBlockList.html

resource "aws_kendra_query_suggestions_block_list" "this" {
  # REQUIRED ARGUMENTS
  # ============================================================================

  # Identifier of the index for a block list.
  # This associates the block list with a specific Kendra index.
  # Forces new resource if changed.
  # Type: string
  index_id = "<KENDRA_INDEX_ID>"

  # Name for the block list.
  # Used to identify the block list within the index.
  # Must be unique within the index.
  # Type: string
  name = "<BLOCK_LIST_NAME>"

  # IAM role ARN used to access the block list text file in S3.
  # The role must have permissions to read from the specified S3 location.
  # Required permissions: s3:GetObject
  # Type: string
  role_arn = "<IAM_ROLE_ARN>"

  # S3 path where your block list text file is located.
  # The text file should contain one word or phrase per line.
  # Format: plain text with UTF-8 encoding
  # Type: object
  source_s3_path {
    # Name of the S3 bucket that contains the file.
    # Must be in the same region as the Kendra index.
    # Type: string
    bucket = "<S3_BUCKET_NAME>"

    # Name of the file (object key in the bucket).
    # Can include prefixes (folders).
    # Example: "blocklists/suggestions.txt"
    # Type: string
    key = "<S3_OBJECT_KEY>"
  }

  # OPTIONAL ARGUMENTS
  # ============================================================================

  # Description for the block list.
  # Provides context about the purpose of this block list.
  # Type: string
  # Default: null
  # description = "Block list for filtering inappropriate query suggestions"

  # Region where this resource will be managed.
  # Defaults to the region set in the provider configuration.
  # Type: string
  # Default: provider region
  # region = "us-east-1"

  # Key-value map of resource tags.
  # Tags are propagated to all resources created by this block list.
  # If configured with a provider default_tags configuration block,
  # tags with matching keys will overwrite those defined at the provider-level.
  # Type: map(string)
  # Default: {}
  # tags = {
  #   Environment = "production"
  #   Project     = "search-improvement"
  #   ManagedBy   = "terraform"
  # }
}

################################################################################
# Outputs
################################################################################

# ARN of the query suggestions block list
output "kendra_query_suggestions_block_list_arn" {
  description = "ARN of the Kendra query suggestions block list"
  value       = aws_kendra_query_suggestions_block_list.this.arn
}

# Unique identifier of the query suggestions block list
output "kendra_query_suggestions_block_list_id" {
  description = "Unique identifier of the Kendra query suggestions block list"
  value       = aws_kendra_query_suggestions_block_list.this.query_suggestions_block_list_id
}

# All tags assigned to the resource
output "kendra_query_suggestions_block_list_tags_all" {
  description = "Map of tags assigned to the resource, including inherited tags"
  value       = aws_kendra_query_suggestions_block_list.this.tags_all
}

################################################################################
# Example Usage
################################################################################

# Example: Complete Kendra Query Suggestions Block List Configuration
#
# resource "aws_kendra_query_suggestions_block_list" "example" {
#   index_id    = aws_kendra_index.example.id
#   name        = "inappropriate-terms-blocklist"
#   description = "Block list for filtering inappropriate query suggestions"
#   role_arn    = aws_iam_role.kendra_blocklist.arn
#
#   source_s3_path {
#     bucket = aws_s3_bucket.kendra_data.id
#     key    = "blocklists/query-suggestions.txt"
#   }
#
#   tags = {
#     Environment = "production"
#     Project     = "enterprise-search"
#     ManagedBy   = "terraform"
#   }
# }
#
# # Required IAM Role for Block List Access
# resource "aws_iam_role" "kendra_blocklist" {
#   name = "kendra-blocklist-role"
#
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Principal = {
#           Service = "kendra.amazonaws.com"
#         }
#         Action = "sts:AssumeRole"
#       }
#     ]
#   })
# }
#
# # IAM Policy for S3 Access
# resource "aws_iam_role_policy" "kendra_blocklist_s3" {
#   name = "kendra-blocklist-s3-access"
#   role = aws_iam_role.kendra_blocklist.id
#
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Action = [
#           "s3:GetObject"
#         ]
#         Resource = "${aws_s3_bucket.kendra_data.arn}/blocklists/*"
#       }
#     ]
#   })
# }
#
# # S3 Bucket for Block List File
# resource "aws_s3_bucket" "kendra_data" {
#   bucket = "my-kendra-data-bucket"
# }
#
# # Upload Block List File to S3
# resource "aws_s3_object" "blocklist_file" {
#   bucket  = aws_s3_bucket.kendra_data.id
#   key     = "blocklists/query-suggestions.txt"
#   content = <<-EOT
#     inappropriate-term-1
#     inappropriate-term-2
#     blocked-phrase
#   EOT
# }

################################################################################
# Important Notes
################################################################################

# 1. Block List File Format:
#    - Plain text file with UTF-8 encoding
#    - One word or phrase per line
#    - Case-insensitive matching
#    - Maximum file size: 5 MB
#    - Maximum 10,000 terms per block list
#
# 2. IAM Permissions:
#    - The role_arn must allow Kendra to assume it
#    - Required S3 permissions: s3:GetObject
#    - Trust relationship must include kendra.amazonaws.com
#
# 3. Update Behavior:
#    - Changes to the S3 file require updating the resource
#    - Kendra periodically syncs the block list from S3
#    - May take a few minutes for changes to take effect
#
# 4. Limitations:
#    - Maximum 1 block list per index
#    - index_id cannot be changed (forces new resource)
#    - S3 bucket must be in the same region as the index
#
# 5. Cost Considerations:
#    - No additional charge for query suggestions block lists
#    - Standard S3 storage and request charges apply
#    - Query suggestions are included in the Kendra index pricing
#
# 6. Best Practices:
#    - Use descriptive names for easy identification
#    - Document the purpose in the description field
#    - Version control your block list files
#    - Test block list effectiveness with sample queries
#    - Regularly review and update blocked terms
#    - Use tags for resource organization
