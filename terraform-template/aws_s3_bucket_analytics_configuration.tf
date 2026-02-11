################################################################################
# AWS S3 Bucket Analytics Configuration
################################################################################
# Provides S3 bucket analytics configuration for storage class analysis.
# This helps analyze storage access patterns to determine when to transition
# less frequently accessed data to STANDARD_IA storage class.
#
# Important Notes:
# - This resource cannot be used with S3 directory buckets
# - Analysis observes access patterns for 30+ days before providing results
# - Only provides recommendations for STANDARD to STANDARD_IA transitions
# - Daily usage visualizations are available in the S3 console
# - Analysis data can be exported daily to an S3 bucket
# - Up to 1,000 filters can be configured per bucket
#
# Provider Version: 6.28.0
# Terraform Resource: aws_s3_bucket_analytics_configuration
# AWS API Reference: https://docs.aws.amazon.com/AmazonS3/latest/API/API_PutBucketAnalyticsConfiguration.html
# AWS Documentation: https://docs.aws.amazon.com/AmazonS3/latest/userguide/analytics-storage-class.html
################################################################################

resource "aws_s3_bucket_analytics_configuration" "example" {
  ################################################################################
  # Required Arguments
  ################################################################################

  # (Required) Name of the S3 bucket this analytics configuration is associated with
  # Type: string
  # Must be an existing S3 bucket name or reference
  # Example: "my-bucket" or aws_s3_bucket.example.id
  bucket = aws_s3_bucket.example.id

  # (Required) Unique identifier of the analytics configuration for the bucket
  # Type: string
  # Must be unique within the bucket
  # Used to identify this specific analytics configuration
  # Example: "EntireBucket", "ImportantDocuments", "HighPriorityObjects"
  name = "EntireBucket"

  ################################################################################
  # Optional Arguments
  ################################################################################

  # (Optional) Region where this resource will be managed
  # Type: string
  # Default: Region set in the provider configuration
  # Reference: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # Uncomment to explicitly set the region:
  # region = "us-east-1"

  ################################################################################
  # Optional Block: filter
  ################################################################################
  # Object filtering that accepts a prefix, tags, or a logical AND of prefix and tags
  # If no filter is specified, all objects in the bucket are analyzed
  # Max items: 1
  #
  # Use Cases:
  # - Analyze specific object prefixes (e.g., documents/, logs/)
  # - Filter by object tags (e.g., priority=high, environment=production)
  # - Combine prefix and tags for precise filtering
  #
  # Example 1: Filter by prefix only
  # filter {
  #   prefix = "documents/"
  # }
  #
  # Example 2: Filter by tags only
  # filter {
  #   tags = {
  #     priority    = "high"
  #     class       = "blue"
  #     environment = "production"
  #   }
  # }
  #
  # Example 3: Filter by both prefix and tags (logical AND)
  # filter {
  #   prefix = "documents/"
  #   tags = {
  #     priority = "high"
  #     class    = "blue"
  #   }
  # }

  ################################################################################
  # Optional Block: storage_class_analysis
  ################################################################################
  # Configuration for the analytics data export
  # Max items: 1
  # This block enables exporting analysis data to another S3 bucket
  #
  # Use Cases:
  # - Export daily analytics data for long-term analysis
  # - Use business intelligence tools to analyze storage patterns
  # - Share analytics data across teams or accounts
  #
  # When to use:
  # - You need to analyze storage patterns over time
  # - You want to integrate with external analytics tools
  # - You need to share analysis results with other teams
  storage_class_analysis {
    ################################################################################
    # Required Nested Block: data_export
    ################################################################################
    # Configuration for exporting analytics data
    # Min items: 1, Max items: 1
    # Exports are generated daily and contain storage access pattern information
    data_export {
      # (Optional) Schema version of exported analytics data
      # Type: string
      # Default: "V_1"
      # Allowed values: "V_1"
      # The exported CSV file includes columns for:
      # - Date, Filter Name, Storage Class, Object Age Group
      # - Object Count, Data Uploaded, Storage, Data Retrieved
      # - GET Request Count, Cumulative Access Ratio
      # output_schema_version = "V_1"

      ################################################################################
      # Required Nested Block: destination
      ################################################################################
      # Specifies the destination for the exported analytics data
      # Min items: 1, Max items: 1
      destination {
        ################################################################################
        # Required Nested Block: s3_bucket_destination
        ################################################################################
        # S3 bucket destination for analytics data export
        # Currently only S3 bucket destinations are supported
        # Min items: 1, Max items: 1
        #
        # Prerequisites:
        # - Destination bucket must exist
        # - Destination bucket must have appropriate bucket policy
        # - If using customer managed KMS key, grant S3 permission to encrypt
        #
        # Bucket Policy Example (grant S3 write permissions):
        # {
        #   "Version": "2012-10-17",
        #   "Statement": [{
        #     "Sid": "S3AnalyticsExport",
        #     "Effect": "Allow",
        #     "Principal": {"Service": "s3.amazonaws.com"},
        #     "Action": "s3:PutObject",
        #     "Resource": "arn:aws:s3:::analytics-destination/*",
        #     "Condition": {
        #       "StringEquals": {
        #         "aws:SourceAccount": "123456789012",
        #         "s3:x-amz-acl": "bucket-owner-full-control"
        #       }
        #     }
        #   }]
        # }
        s3_bucket_destination {
          # (Required) ARN of the destination bucket where analytics data will be exported
          # Type: string
          # Must be a valid S3 bucket ARN
          # Example: "arn:aws:s3:::analytics-destination"
          bucket_arn = aws_s3_bucket.analytics.arn

          # (Optional) Account ID that owns the destination bucket
          # Type: string
          # Use when exporting to a bucket in a different AWS account
          # Example: "123456789012"
          # bucket_account_id = "123456789012"

          # (Optional) Output format of exported analytics data
          # Type: string
          # Default: "CSV"
          # Allowed values: "CSV"
          # The CSV file is updated daily with storage access pattern information
          # format = "CSV"

          # (Optional) Prefix to append to exported analytics data
          # Type: string
          # Helps organize exported files in the destination bucket
          # Example: "analytics-exports/"
          # The full object key will be: <prefix><source-bucket>/<config-name>/<date>.csv
          # prefix = "analytics-exports/"
        }
      }
    }
  }
}

################################################################################
# Example: Basic Configuration (Entire Bucket)
################################################################################
# Analyzes all objects in the bucket without filtering
# No data export configured (console-only analysis)
#
# resource "aws_s3_bucket_analytics_configuration" "basic" {
#   bucket = aws_s3_bucket.example.id
#   name   = "EntireBucket"
# }

################################################################################
# Example: With Prefix Filter
################################################################################
# Analyzes only objects with a specific prefix
# Useful for analyzing specific directories or object categories
#
# resource "aws_s3_bucket_analytics_configuration" "prefix_filtered" {
#   bucket = aws_s3_bucket.example.id
#   name   = "DocumentsAnalysis"
#
#   filter {
#     prefix = "documents/"
#   }
# }

################################################################################
# Example: With Tag Filter
################################################################################
# Analyzes only objects matching specific tags
# Useful for analyzing objects by metadata (priority, class, environment)
#
# resource "aws_s3_bucket_analytics_configuration" "tag_filtered" {
#   bucket = aws_s3_bucket.example.id
#   name   = "HighPriorityBlueDocuments"
#
#   filter {
#     tags = {
#       priority = "high"
#       class    = "blue"
#     }
#   }
# }

################################################################################
# Example: With Prefix and Tag Filter
################################################################################
# Combines prefix and tags for precise filtering (logical AND)
# Both conditions must be met for objects to be included in analysis
#
# resource "aws_s3_bucket_analytics_configuration" "combined_filter" {
#   bucket = aws_s3_bucket.example.id
#   name   = "ImportantBlueDocuments"
#
#   filter {
#     prefix = "documents/"
#
#     tags = {
#       priority = "high"
#       class    = "blue"
#     }
#   }
# }

################################################################################
# Example: With Data Export to Another S3 Bucket
################################################################################
# Exports daily analytics data to another S3 bucket
# Enables long-term analysis and integration with external tools
#
# resource "aws_s3_bucket_analytics_configuration" "with_export" {
#   bucket = aws_s3_bucket.source.id
#   name   = "EntireBucketWithExport"
#
#   storage_class_analysis {
#     data_export {
#       output_schema_version = "V_1"
#
#       destination {
#         s3_bucket_destination {
#           bucket_arn        = aws_s3_bucket.analytics_destination.arn
#           bucket_account_id = "123456789012"  # Optional: for cross-account
#           format            = "CSV"
#           prefix            = "analytics-exports/"
#         }
#       }
#     }
#   }
# }

################################################################################
# Example: Cross-Region Export
################################################################################
# Exports analytics data to a bucket in a different region
# Useful for centralized analytics storage
#
# resource "aws_s3_bucket_analytics_configuration" "cross_region" {
#   bucket = aws_s3_bucket.source.id
#   name   = "CrossRegionAnalytics"
#   region = "us-west-2"
#
#   storage_class_analysis {
#     data_export {
#       destination {
#         s3_bucket_destination {
#           bucket_arn = "arn:aws:s3:::analytics-destination-us-east-1"
#           prefix     = "west-bucket-analytics/"
#         }
#       }
#     }
#   }
# }

################################################################################
# Example: Multiple Analytics Configurations
################################################################################
# Configure multiple analytics configurations per bucket (up to 1,000)
# Each configuration receives a separate analysis
#
# # Analyze entire bucket
# resource "aws_s3_bucket_analytics_configuration" "entire_bucket" {
#   bucket = aws_s3_bucket.example.id
#   name   = "EntireBucket"
# }
#
# # Analyze documents folder
# resource "aws_s3_bucket_analytics_configuration" "documents" {
#   bucket = aws_s3_bucket.example.id
#   name   = "Documents"
#
#   filter {
#     prefix = "documents/"
#   }
# }
#
# # Analyze logs folder
# resource "aws_s3_bucket_analytics_configuration" "logs" {
#   bucket = aws_s3_bucket.example.id
#   name   = "Logs"
#
#   filter {
#     prefix = "logs/"
#   }
# }
#
# # Analyze high priority objects
# resource "aws_s3_bucket_analytics_configuration" "high_priority" {
#   bucket = aws_s3_bucket.example.id
#   name   = "HighPriority"
#
#   filter {
#     tags = {
#       priority = "high"
#     }
#   }
# }

################################################################################
# Related Resources
################################################################################
# These resources are commonly used with aws_s3_bucket_analytics_configuration

# Source S3 bucket being analyzed
resource "aws_s3_bucket" "example" {
  bucket = "example-source-bucket"

  # Best Practice: Enable versioning for data protection
  # versioning {
  #   enabled = true
  # }

  # Best Practice: Add tags for resource management
  # tags = {
  #   Environment = "production"
  #   Purpose     = "analytics-source"
  # }
}

# Destination S3 bucket for analytics export (if using data export)
resource "aws_s3_bucket" "analytics" {
  bucket = "analytics-destination-bucket"

  # Best Practice: Enable versioning for exported data
  # versioning {
  #   enabled = true
  # }

  # Best Practice: Add lifecycle rules to manage exported data
  # lifecycle_rule {
  #   id      = "archive-old-analytics"
  #   enabled = true
  #
  #   transition {
  #     days          = 90
  #     storage_class = "GLACIER"
  #   }
  #
  #   expiration {
  #     days = 365
  #   }
  # }

  # Best Practice: Add tags for resource management
  # tags = {
  #   Environment = "production"
  #   Purpose     = "analytics-destination"
  # }
}

# Bucket policy for destination bucket (required for data export)
# Grants S3 permission to write analytics data to the destination bucket
# resource "aws_s3_bucket_policy" "analytics_destination" {
#   bucket = aws_s3_bucket.analytics.id
#
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Sid    = "AllowS3AnalyticsExport"
#         Effect = "Allow"
#         Principal = {
#           Service = "s3.amazonaws.com"
#         }
#         Action = "s3:PutObject"
#         Resource = "${aws_s3_bucket.analytics.arn}/*"
#         Condition = {
#           StringEquals = {
#             "aws:SourceAccount" = data.aws_caller_identity.current.account_id
#             "s3:x-amz-acl"     = "bucket-owner-full-control"
#           }
#           ArnLike = {
#             "aws:SourceArn" = aws_s3_bucket.example.arn
#           }
#         }
#       }
#     ]
#   })
# }

# Get current AWS account ID
# data "aws_caller_identity" "current" {}

################################################################################
# Outputs
################################################################################
# Useful output values for reference and integration

output "analytics_configuration_id" {
  description = "The ID of the analytics configuration (format: bucket:name)"
  value       = aws_s3_bucket_analytics_configuration.example.id
}

output "analytics_configuration_name" {
  description = "The name of the analytics configuration"
  value       = aws_s3_bucket_analytics_configuration.example.name
}

output "analytics_bucket" {
  description = "The bucket this analytics configuration is associated with"
  value       = aws_s3_bucket_analytics_configuration.example.bucket
}

output "analytics_region" {
  description = "The region where the analytics configuration is managed"
  value       = aws_s3_bucket_analytics_configuration.example.region
}

################################################################################
# Best Practices and Recommendations
################################################################################
#
# 1. Filter Strategy:
#    - Use no filter to analyze the entire bucket
#    - Use prefix filters for directory-based analysis
#    - Use tag filters for metadata-based analysis
#    - Combine prefix and tags for precise filtering
#    - Create multiple configurations for different object categories (up to 1,000)
#
# 2. Data Export:
#    - Enable data export for long-term analysis and external tools
#    - Configure appropriate bucket policy on destination bucket
#    - Use prefixes to organize exported data
#    - Consider lifecycle policies for managing exported CSV files
#    - Monitor export bucket storage costs
#
# 3. Security:
#    - Grant minimum required permissions on destination bucket
#    - Use bucket policies with source account and source ARN conditions
#    - If using KMS encryption, grant S3 permission to encrypt objects
#    - Enable logging on destination bucket to track access
#
# 4. Monitoring:
#    - Wait at least 30 days for initial analysis results
#    - Review daily visualizations in S3 console
#    - Check exported CSV files for detailed access patterns
#    - Monitor storage class transition recommendations
#    - Track cost savings from transitioning to STANDARD_IA
#
# 5. Cost Optimization:
#    - Use filters to focus analysis on specific object groups
#    - Implement recommended storage class transitions
#    - Consider minimum object size (128KB) for STANDARD_IA
#    - Review minimum storage duration (30 days) for STANDARD_IA
#    - Calculate cost-benefit of retrieval fees vs. storage savings
#
# 6. Naming Convention:
#    - Use descriptive names for analytics configurations
#    - Include scope in name (e.g., "EntireBucket", "DocumentsOnly")
#    - Use consistent naming across configurations
#    - Document purpose of each configuration
#
# 7. Lifecycle Management:
#    - Create S3 lifecycle rules based on analytics recommendations
#    - Test transitions on small object groups first
#    - Monitor access patterns after implementing transitions
#    - Adjust lifecycle rules based on ongoing analysis
#
# 8. Integration:
#    - Export data for analysis in spreadsheet applications
#    - Integrate with business intelligence tools (e.g., Amazon QuickSight)
#    - Automate lifecycle rule creation based on export data
#    - Track storage optimization metrics over time
#
# 9. Limitations:
#    - Not supported for S3 directory buckets
#    - Only provides STANDARD to STANDARD_IA recommendations
#    - Does not recommend ONEZONE_IA or Glacier transitions
#    - Requires 30+ days of access patterns for results
#    - Maximum 1,000 configurations per bucket
#
# 10. Complementary Services:
#     - Use with S3 Lifecycle policies for automatic transitions
#     - Combine with S3 Intelligent-Tiering for automatic optimization
#     - Use S3 Storage Lens for comprehensive storage insights
#     - Monitor with CloudWatch metrics and alarms
#     - Track costs with AWS Cost Explorer
#
################################################################################
# Troubleshooting
################################################################################
#
# Common Issues:
#
# 1. "Access Denied" when exporting data:
#    - Verify destination bucket policy grants S3 write permissions
#    - Check source account and source ARN conditions
#    - Verify bucket exists in correct region
#
# 2. No analysis results after 30 days:
#    - Verify objects exist that match the filter criteria
#    - Check that objects are in STANDARD storage class
#    - Ensure bucket has access activity during observation period
#
# 3. Export files not appearing in destination bucket:
#    - Verify destination bucket ARN is correct
#    - Check bucket policy allows PutObject from S3 service
#    - Confirm output_schema_version is set to "V_1"
#    - Wait 24-48 hours after configuration for first export
#
# 4. KMS encryption errors:
#    - Grant S3 service permission to use KMS key
#    - Verify KMS key policy allows encrypt/decrypt operations
#    - Check key is in same region as destination bucket
#
# 5. Configuration conflicts:
#    - Ensure configuration names are unique within bucket
#    - Verify no duplicate filter combinations
#    - Check maximum 1,000 configurations per bucket limit
#
################################################################################
