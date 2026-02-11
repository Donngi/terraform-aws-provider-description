################################################################################
# AWS Rekognition Stream Processor
################################################################################
# Terraform resource for managing an AWS Rekognition Stream Processor.
#
# IMPORTANT NOTES:
# - This resource must be configured specifically for your use case, and not all
#   options are compatible with one another
# - Stream Processors configured for Face Recognition cannot have ANY properties
#   updated after creation (will result in API error)
# - Two main use cases supported:
#   1. Label Detection (connected_home) - detects people, pets, packages
#   2. Face Search (face_search) - matches faces against a collection
#
# REFERENCE:
# - AWS API: https://docs.aws.amazon.com/rekognition/latest/APIReference/API_CreateStreamProcessor.html
# - Terraform Docs: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rekognition_stream_processor
################################################################################

resource "aws_rekognition_stream_processor" "this" {
  ################################################################################
  # Required Arguments
  ################################################################################

  # (Required) The name of the Stream Processor
  # Must be unique within your AWS account
  name = "example-stream-processor"

  # (Required) The Amazon Resource Number (ARN) of the IAM role that allows access
  # to the stream processor
  # The IAM role provides:
  # - Read permissions for Kinesis Video Stream
  # - Write permissions to S3 bucket (for label detection)
  # - Write permissions to Kinesis Data Stream (for face search)
  # - Publish permissions to SNS topic (for notifications)
  role_arn = "arn:aws:iam::123456789012:role/rekognition-stream-processor-role"

  ################################################################################
  # Input Configuration (Required)
  ################################################################################
  # Information about the source streaming video

  input {
    # Kinesis Video Stream that provides the source streaming video
    kinesis_video_stream {
      # (Required) ARN of the Kinesis video stream that streams the source video
      arn = "arn:aws:kinesisvideo:us-east-1:123456789012:stream/example-stream/1234567890123"
    }
  }

  ################################################################################
  # Output Configuration (Required)
  ################################################################################
  # Where Amazon Rekognition puts the analysis results
  # Choose either kinesis_data_stream OR s3_destination (not both)

  output {
    # Option 1: Output to Kinesis Data Stream (typically for face search)
    kinesis_data_stream {
      # (Optional) ARN of the output Amazon Kinesis Data Streams stream
      arn = "arn:aws:kinesis:us-east-1:123456789012:stream/example-output-stream"
    }

    # Option 2: Output to S3 (typically for label detection)
    # Uncomment and configure if using S3 instead of Kinesis Data Stream
    #
    # s3_destination {
    #   # (Optional) Name of the Amazon S3 bucket for analysis results
    #   bucket = "example-rekognition-output-bucket"
    #
    #   # (Optional) Prefix value for the location within the bucket
    #   key_prefix = "rekognition-results/"
    # }
  }

  ################################################################################
  # Settings Configuration (Required)
  ################################################################################
  # Input parameters used in streaming video analysis
  # Choose either connected_home OR face_search (not both)

  settings {
    # Option 1: Label Detection for Connected Home
    # Detects objects or people in video frames
    connected_home {
      # (Required) What to detect in the video
      # Valid labels: PERSON, PET, PACKAGE, ALL
      labels = ["PERSON", "PET", "PACKAGE"]

      # (Optional) Minimum confidence required to label an object (0-100)
      # Default: Computed by AWS (typically around 50)
      min_confidence = 70.0
    }

    # Option 2: Face Search Settings
    # Matches detected faces against a face collection
    # IMPORTANT: Stream processors with face_search cannot be updated after creation
    #
    # Uncomment and configure if using face search instead of connected_home
    #
    # face_search {
    #   # (Required) ID of a collection that contains faces to search for
    #   collection_id = "example-face-collection"
    #
    #   # (Optional) Minimum face match confidence score (0-100)
    #   # Default: Computed by AWS (typically around 80)
    #   face_match_threshold = 85.0
    # }
  }

  ################################################################################
  # Optional Arguments
  ################################################################################

  # (Optional) Region where this resource will be managed
  # Defaults to the Region set in the provider configuration
  # region = "us-east-1"

  # (Optional) Data sharing preference for model improvement
  data_sharing_preference {
    # (Required) Whether you are sharing data with Rekognition to improve
    # model performance
    opt_in = false
  }

  # (Optional) KMS key for encryption
  # You can supply: ARN of KMS key, ID of KMS key, alias, or alias ARN
  # Optional parameter for label detection stream processors
  # kms_key_id = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"

  # (Optional) SNS topic for completion status notifications
  notification_channel {
    # (Required) ARN of the SNS topic for completion status updates
    sns_topic_arn = "arn:aws:sns:us-east-1:123456789012:rekognition-notifications"
  }

  # (Optional) Regions of interest in video frames
  # Specifies where Amazon Rekognition checks for objects or people
  # You can define multiple regions using bounding boxes or polygons
  #
  # regions_of_interest {
  #   # Option 1: Bounding box (only 1 per region allowed)
  #   bounding_box {
  #     # (Required) Height as a ratio of overall image height (0.0 - 1.0)
  #     height = 0.5
  #
  #     # (Required) Width as a ratio of overall image width (0.0 - 1.0)
  #     width = 0.5
  #
  #     # (Required) Left coordinate as a ratio of overall image width (0.0 - 1.0)
  #     left = 0.25
  #
  #     # (Required) Top coordinate as a ratio of overall image height (0.0 - 1.0)
  #     top = 0.25
  #   }
  #
  #   # Option 2: Polygon (up to 10 points to define a region)
  #   # Minimum 3 points required to form a polygon
  #   polygon {
  #     # (Required) X coordinate for a point on the polygon (0.0 - 1.0)
  #     x = 0.3
  #
  #     # (Required) Y coordinate for a point on the polygon (0.0 - 1.0)
  #     y = 0.3
  #   }
  #   polygon {
  #     x = 0.7
  #     y = 0.3
  #   }
  #   polygon {
  #     x = 0.5
  #     y = 0.7
  #   }
  # }

  # (Optional) Map of tags to assign to the resource
  # Tags are inherited from provider default_tags if configured
  tags = {
    Name        = "example-stream-processor"
    Environment = "production"
    ManagedBy   = "terraform"
  }

  ################################################################################
  # Timeouts
  ################################################################################
  # Optional operation timeouts

  # timeouts {
  #   # Timeout for create operation (default: provider default)
  #   create = "10m"
  #
  #   # Timeout for update operation (default: provider default)
  #   update = "10m"
  #
  #   # Timeout for delete operation (default: provider default)
  #   delete = "10m"
  # }
}

################################################################################
# Outputs
################################################################################

output "stream_processor_arn" {
  description = "ARN of the Stream Processor"
  value       = aws_rekognition_stream_processor.this.arn
}

output "stream_processor_tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from provider default_tags"
  value       = aws_rekognition_stream_processor.this.tags_all
}

################################################################################
# Example: Label Detection Configuration
################################################################################
# This example demonstrates a complete setup for label detection (connected home)
# including all required supporting resources

# Example S3 bucket for output
# resource "aws_s3_bucket" "rekognition_output" {
#   bucket = "my-rekognition-output-bucket"
# }

# Example SNS topic for notifications
# resource "aws_sns_topic" "rekognition_notifications" {
#   name = "rekognition-stream-processor-notifications"
# }

# Example Kinesis Video Stream (input)
# resource "aws_kinesis_video_stream" "input" {
#   name                    = "rekognition-input-stream"
#   data_retention_in_hours = 24
#   device_name             = "camera-device-1"
#   media_type              = "video/h264"
# }

# Example IAM role for label detection
# resource "aws_iam_role" "rekognition_stream_processor" {
#   name = "rekognition-stream-processor-role"
#
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [{
#       Action = "sts:AssumeRole"
#       Effect = "Allow"
#       Principal = {
#         Service = "rekognition.amazonaws.com"
#       }
#     }]
#   })
#
#   inline_policy {
#     name = "rekognition-stream-processor-policy"
#     policy = jsonencode({
#       Version = "2012-10-17"
#       Statement = [
#         {
#           # S3 write permissions for output
#           Action   = ["s3:PutObject"]
#           Effect   = "Allow"
#           Resource = ["${aws_s3_bucket.rekognition_output.arn}/*"]
#         },
#         {
#           # SNS publish permissions for notifications
#           Action   = ["sns:Publish"]
#           Effect   = "Allow"
#           Resource = [aws_sns_topic.rekognition_notifications.arn]
#         },
#         {
#           # Kinesis Video Stream read permissions
#           Action = [
#             "kinesisvideo:GetDataEndpoint",
#             "kinesisvideo:GetMedia",
#             "kinesisvideo:DescribeStream"
#           ]
#           Effect   = "Allow"
#           Resource = [aws_kinesis_video_stream.input.arn]
#         }
#       ]
#     })
#   }
# }

# Label detection stream processor example
# resource "aws_rekognition_stream_processor" "label_detection" {
#   name     = "label-detection-processor"
#   role_arn = aws_iam_role.rekognition_stream_processor.arn
#
#   input {
#     kinesis_video_stream {
#       arn = aws_kinesis_video_stream.input.arn
#     }
#   }
#
#   output {
#     s3_destination {
#       bucket     = aws_s3_bucket.rekognition_output.bucket
#       key_prefix = "label-detection/"
#     }
#   }
#
#   settings {
#     connected_home {
#       labels         = ["PERSON", "PET", "PACKAGE"]
#       min_confidence = 70.0
#     }
#   }
#
#   data_sharing_preference {
#     opt_in = false
#   }
#
#   notification_channel {
#     sns_topic_arn = aws_sns_topic.rekognition_notifications.arn
#   }
#
#   tags = {
#     UseCase = "LabelDetection"
#   }
# }

################################################################################
# Example: Face Search Configuration
################################################################################
# This example demonstrates a complete setup for face search
# including all required supporting resources

# Example Kinesis Data Stream for output
# resource "aws_kinesis_stream" "face_search_output" {
#   name        = "rekognition-face-search-output"
#   shard_count = 1
# }

# Example Rekognition collection for face search
# resource "aws_rekognition_collection" "faces" {
#   collection_id = "known-faces-collection"
# }

# Example IAM role for face search
# resource "aws_iam_role" "face_search_processor" {
#   name = "rekognition-face-search-role"
#
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [{
#       Action = "sts:AssumeRole"
#       Effect = "Allow"
#       Principal = {
#         Service = "rekognition.amazonaws.com"
#       }
#     }]
#   })
#
#   inline_policy {
#     name = "face-search-policy"
#     policy = jsonencode({
#       Version = "2012-10-17"
#       Statement = [
#         {
#           # Kinesis Data Stream write permissions
#           Action   = ["kinesis:PutRecord", "kinesis:PutRecords"]
#           Effect   = "Allow"
#           Resource = [aws_kinesis_stream.face_search_output.arn]
#         },
#         {
#           # Kinesis Video Stream read permissions
#           Action = [
#             "kinesisvideo:GetDataEndpoint",
#             "kinesisvideo:GetMedia",
#             "kinesisvideo:DescribeStream"
#           ]
#           Effect   = "Allow"
#           Resource = [aws_kinesis_video_stream.input.arn]
#         },
#         {
#           # Rekognition collection access
#           Action = [
#             "rekognition:SearchFaces",
#             "rekognition:SearchFacesByImage"
#           ]
#           Effect   = "Allow"
#           Resource = [aws_rekognition_collection.faces.arn]
#         }
#       ]
#     })
#   }
# }

# Face search stream processor example
# IMPORTANT: Cannot be updated after creation!
# resource "aws_rekognition_stream_processor" "face_search" {
#   name     = "face-search-processor"
#   role_arn = aws_iam_role.face_search_processor.arn
#
#   input {
#     kinesis_video_stream {
#       arn = aws_kinesis_video_stream.input.arn
#     }
#   }
#
#   output {
#     kinesis_data_stream {
#       arn = aws_kinesis_stream.face_search_output.arn
#     }
#   }
#
#   settings {
#     face_search {
#       collection_id        = aws_rekognition_collection.faces.id
#       face_match_threshold = 85.0
#     }
#   }
#
#   data_sharing_preference {
#     opt_in = false
#   }
#
#   # Optional: Define region of interest
#   regions_of_interest {
#     polygon {
#       x = 0.3
#       y = 0.3
#     }
#     polygon {
#       x = 0.7
#       y = 0.3
#     }
#     polygon {
#       x = 0.5
#       y = 0.7
#     }
#   }
#
#   tags = {
#     UseCase = "FaceSearch"
#   }
# }
