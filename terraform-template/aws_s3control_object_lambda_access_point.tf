################################################################################
# S3 Control Object Lambda Access Point
################################################################################
# Provides a resource to manage an S3 Object Lambda Access Point.
# An Object Lambda access point is associated with exactly one standard access
# point and thus one Amazon S3 bucket.
#
# Documentation: https://raw.githubusercontent.com/hashicorp/terraform-provider-aws/main/website/docs/r/s3control_object_lambda_access_point.html.markdown
# Provider Version: 6.28.0
################################################################################

resource "aws_s3control_object_lambda_access_point" "this" {
  ################################################################################
  # Required Arguments
  ################################################################################

  # The name for this Object Lambda Access Point.
  # Type: string (required)
  name = "example"

  ################################################################################
  # Configuration Block (Required)
  ################################################################################
  # A configuration block containing details about the Object Lambda Access Point.
  # Min items: 1, Max items: 1
  configuration {
    # (Required) Standard access point associated with the Object Lambda Access Point.
    # This should be the ARN of the standard S3 access point.
    # Type: string (required)
    supporting_access_point = "arn:aws:s3:us-east-1:123456789012:accesspoint/example-access-point"

    ################################################################################
    # Transformation Configuration Block (Required)
    ################################################################################
    # List of transformation configurations for the Object Lambda Access Point.
    # Min items: 1
    transformation_configuration {
      # (Required) The actions of an Object Lambda Access Point configuration.
      # Valid values: GetObject
      # Type: set of strings (required)
      actions = ["GetObject"]

      ################################################################################
      # Content Transformation Block (Required)
      ################################################################################
      # The content transformation of an Object Lambda Access Point configuration.
      # Min items: 1, Max items: 1
      content_transformation {
        ################################################################################
        # AWS Lambda Block (Required)
        ################################################################################
        # Configuration for an AWS Lambda function.
        # Min items: 1, Max items: 1
        aws_lambda {
          # (Required) The Amazon Resource Name (ARN) of the AWS Lambda function.
          # Type: string (required)
          function_arn = "arn:aws:lambda:us-east-1:123456789012:function/example-function"

          # (Optional) Additional JSON that provides supplemental data to the Lambda
          # function used to transform objects.
          # Type: string (optional)
          # function_payload = "{\"key\": \"value\"}"
        }
      }
    }

    ################################################################################
    # Optional Configuration Arguments
    ################################################################################

    # (Optional) Allowed features.
    # Valid values: GetObject-Range, GetObject-PartNumber
    # Type: set of strings (optional)
    # allowed_features = ["GetObject-Range", "GetObject-PartNumber"]

    # (Optional) Whether or not the CloudWatch metrics configuration is enabled.
    # Type: bool (optional)
    # cloud_watch_metrics_enabled = false
  }

  ################################################################################
  # Optional Arguments
  ################################################################################

  # (Optional) The AWS account ID for the owner of the bucket for which you want
  # to create an Object Lambda Access Point.
  # Defaults to automatically determined account ID of the Terraform AWS provider.
  # Type: string (optional, computed)
  # account_id = "123456789012"

  # (Optional) Region where this resource will be managed.
  # Defaults to the Region set in the provider configuration.
  # Type: string (optional, computed)
  # region = "us-east-1"

  ################################################################################
  # Computed Attributes (Read-Only)
  ################################################################################
  # The following attributes are exported by this resource:
  #
  # - alias (string) - Alias for the S3 Object Lambda Access Point
  # - arn (string) - Amazon Resource Name (ARN) of the Object Lambda Access Point
  # - id (string) - The AWS account ID and access point name separated by a colon (:)
}

################################################################################
# Example Usage - Complete Configuration
################################################################################

# resource "aws_s3_bucket" "example" {
#   bucket = "example-bucket"
# }
#
# resource "aws_s3_access_point" "example" {
#   bucket = aws_s3_bucket.example.id
#   name   = "example-access-point"
# }
#
# resource "aws_lambda_function" "example" {
#   filename      = "lambda_function.zip"
#   function_name = "example-function"
#   role          = aws_iam_role.lambda_role.arn
#   handler       = "index.handler"
#   runtime       = "python3.9"
# }
#
# resource "aws_s3control_object_lambda_access_point" "example" {
#   name = "example-object-lambda-ap"
#
#   configuration {
#     supporting_access_point = aws_s3_access_point.example.arn
#
#     transformation_configuration {
#       actions = ["GetObject"]
#
#       content_transformation {
#         aws_lambda {
#           function_arn     = aws_lambda_function.example.arn
#           function_payload = jsonencode({
#             env = "production"
#           })
#         }
#       }
#     }
#
#     allowed_features             = ["GetObject-Range", "GetObject-PartNumber"]
#     cloud_watch_metrics_enabled = true
#   }
#
#   account_id = "123456789012"
#   region     = "us-east-1"
# }

################################################################################
# Additional Notes
################################################################################
# - S3 Object Lambda allows you to add your own code to S3 GET, HEAD, and LIST
#   requests to modify and process data as it is returned to an application.
# - The Object Lambda Access Point must be associated with a standard S3 access
#   point, which in turn is associated with an S3 bucket.
# - The Lambda function specified must have the necessary permissions to be
#   invoked by S3 Object Lambda.
# - CloudWatch metrics can be enabled to monitor the performance of your Object
#   Lambda Access Point.
# - The allowed_features parameter enables additional S3 capabilities:
#   * GetObject-Range: Allows range requests
#   * GetObject-PartNumber: Allows part number requests for multipart objects
################################################################################
