# ================================================================
# AWS Kendra Experience
# ================================================================
# Terraform resource for managing an AWS Kendra Experience.
# A Kendra Experience provides a customized search experience for your users
# with specific data sources, FAQs, and user identity configuration.
#
# Version: AWS Provider 6.28.0
# Documentation: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kendra_experience
# ================================================================

resource "aws_kendra_experience" "example" {
  # ================================================================
  # Required Arguments
  # ================================================================

  # The identifier of the index for your Amazon Kendra experience
  # Type: string
  # Forces new resource
  index_id = "your-kendra-index-id" # e.g., aws_kendra_index.example.id

  # A name for your Amazon Kendra experience
  # Type: string
  name = "example-experience"

  # The Amazon Resource Name (ARN) of a role with permission to access Query API,
  # QuerySuggestions API, SubmitFeedback API, and AWS SSO that stores your user and group information
  # For more information, see: https://docs.aws.amazon.com/kendra/latest/dg/iam-roles.html
  # Type: string
  role_arn = "arn:aws:iam::123456789012:role/KendraExperienceRole"

  # ================================================================
  # Optional Arguments
  # ================================================================

  # A description for your Amazon Kendra experience
  # Type: string
  # Forces new resource if removed
  # description = "My Kendra Experience for customer support"

  # Region where this resource will be managed
  # Defaults to the Region set in the provider configuration
  # Type: string (computed)
  # region = "us-east-1"

  # ================================================================
  # Configuration Block (Optional)
  # ================================================================
  # Configuration information for your Amazon Kendra experience
  # Terraform will only perform drift detection when present in configuration
  # NOTE: By default of the AWS Kendra API, updates to an existing aws_kendra_experience
  # resource (e.g. updating the name) will also update the
  # configuration.content_source_configuration.direct_put_content parameter to false
  # if not already provided

  configuration {
    # ----------------------------------------------------------------
    # Content Source Configuration (Optional)
    # ----------------------------------------------------------------
    # The identifiers of your data sources and FAQs, or specify that you want to
    # use documents indexed via the BatchPutDocument API
    # Required if user_identity_configuration not provided
    # Maximum of 1 block

    content_source_configuration {
      # The identifiers of the data sources you want to use for your Amazon Kendra experience
      # Type: set of strings
      # Maximum number of 100 items
      # data_source_ids = [
      #   "data-source-id-1",
      #   "data-source-id-2"
      # ]

      # Whether to use documents you indexed directly using the BatchPutDocument API
      # Type: bool
      # Defaults to false
      direct_put_content = true

      # The identifier of the FAQs that you want to use for your Amazon Kendra experience
      # Type: set of strings
      # Maximum number of 100 items
      # faq_ids = [
      #   "faq-id-1",
      #   "faq-id-2"
      # ]
    }

    # ----------------------------------------------------------------
    # User Identity Configuration (Optional)
    # ----------------------------------------------------------------
    # The AWS SSO field name that contains the identifiers of your users
    # Required if content_source_configuration not provided
    # Maximum of 1 block

    # user_identity_configuration {
    #   # The AWS SSO field name that contains the identifiers of your users, such as their emails
    #   # Type: string (required)
    #   identity_attribute_name = "email"
    # }
  }

  # ================================================================
  # Timeouts Block (Optional)
  # ================================================================
  # Customize timeout durations for create, update, and delete operations

  # timeouts {
  #   # Timeout for create operations
  #   # Type: string
  #   # create = "30m"
  #
  #   # Timeout for update operations
  #   # Type: string
  #   # update = "30m"
  #
  #   # Timeout for delete operations
  #   # Type: string
  #   # delete = "30m"
  # }
}

# ================================================================
# Computed Attributes (Read-only)
# ================================================================
# These attributes are exported by the resource and can be referenced
# in other parts of your Terraform configuration

# Output examples:
# - id: The unique identifiers of the experience and index separated by a slash (/)
#   Example: aws_kendra_experience.example.id
#
# - arn: ARN of the Experience
#   Example: aws_kendra_experience.example.arn
#
# - experience_id: The unique identifier of the experience
#   Example: aws_kendra_experience.example.experience_id
#
# - status: The current processing status of your Amazon Kendra experience
#   Example: aws_kendra_experience.example.status
#
# - endpoints: Shows the endpoint URLs for your Amazon Kendra experiences
#   The URLs are unique and fully hosted by AWS
#   Example: aws_kendra_experience.example.endpoints
#   Structure:
#     - endpoint: The endpoint of your Amazon Kendra experience
#     - endpoint_type: The type of endpoint for your Amazon Kendra experience
#
# - region: The AWS region where the experience is managed (computed if not set)
#   Example: aws_kendra_experience.example.region

# ================================================================
# Example Usage with All Options
# ================================================================

# resource "aws_kendra_experience" "full_example" {
#   index_id    = aws_kendra_index.example.id
#   name        = "comprehensive-experience"
#   role_arn    = aws_iam_role.kendra_experience.arn
#   description = "Comprehensive Kendra Experience with all configuration options"
#   region      = "us-east-1"
#
#   configuration {
#     content_source_configuration {
#       data_source_ids    = [aws_kendra_data_source.s3.id]
#       direct_put_content = true
#       faq_ids            = [aws_kendra_faq.example.faq_id]
#     }
#
#     user_identity_configuration {
#       identity_attribute_name = "email"
#     }
#   }
#
#   timeouts {
#     create = "60m"
#     update = "60m"
#     delete = "60m"
#   }
# }

# ================================================================
# Related Resources
# ================================================================
# - aws_kendra_index: The Kendra index resource
# - aws_kendra_data_source: Kendra data source resources
# - aws_kendra_faq: Kendra FAQ resources
# - aws_iam_role: IAM role for Kendra Experience permissions
#
# Reference: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kendra_experience
