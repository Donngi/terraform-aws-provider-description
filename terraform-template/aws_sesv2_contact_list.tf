################################################################################
# AWS SESv2 Contact List
################################################################################
# Terraform resource for managing an AWS SESv2 (Simple Email V2) Contact List.
#
# AWS SESv2 Contact Lists allow you to organize email recipients into groups
# for managing email subscriptions and preferences. Contact lists can include
# topics that recipients can subscribe to or unsubscribe from.
#
# Provider Version: 6.28.0
# Resource Documentation: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sesv2_contact_list
################################################################################

resource "aws_sesv2_contact_list" "example" {
  ################################################################################
  # Required Arguments
  ################################################################################

  # Name of the contact list
  # - Must be unique within your AWS account
  # - Used to identify and reference the contact list
  # - This value cannot be changed after creation (forces new resource)
  contact_list_name = "example-contact-list"

  ################################################################################
  # Optional Arguments
  ################################################################################

  # Description of what the contact list is about
  # - Helps explain the purpose of the contact list
  # - Visible in the AWS console and API responses
  # - Maximum length: 500 characters
  description = "Example contact list for newsletter subscribers"

  # Region where this resource will be managed
  # - Defaults to the Region set in the provider configuration
  # - Allows you to manage resources in a specific region
  # - See: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  # Key-value map of resource tags for the contact list
  # - If configured with a provider default_tags configuration block,
  #   tags with matching keys will overwrite those defined at the provider-level
  # - Use tags for resource organization, cost tracking, and access control
  tags = {
    Environment = "Production"
    ManagedBy   = "Terraform"
    Purpose     = "Newsletter"
  }

  ################################################################################
  # Topic Configuration Block (Optional, Multiple Blocks Supported)
  ################################################################################
  # Configuration block(s) with topic for the contact list
  # - Topics allow recipients to subscribe to specific types of content
  # - You can define multiple topics within a single contact list
  # - Recipients can manage their topic preferences individually

  topic {
    # Required: Default subscription status to be applied to a contact if the
    # contact has not noted their preference for subscribing to a topic
    # - Valid values: "OPT_IN" or "OPT_OUT"
    # - OPT_IN: Contacts are automatically subscribed unless they opt out
    # - OPT_OUT: Contacts must explicitly opt in to subscribe
    default_subscription_status = "OPT_OUT"

    # Required: Name of the topic the contact will see
    # - This is the user-facing name shown to recipients
    # - Should be descriptive and clear about the topic content
    # - Maximum length: 128 characters
    display_name = "Weekly Newsletter"

    # Required: Name of the topic
    # - Technical identifier for the topic
    # - Must be unique within the contact list
    # - Used in API calls and backend operations
    # - Maximum length: 128 characters
    topic_name = "weekly-newsletter"

    # Optional: Description of what the topic is about, which the contact will see
    # - Provides additional context to help recipients decide whether to subscribe
    # - Visible in subscription preference centers
    # - Maximum length: 500 characters
    description = "Receive our weekly newsletter with the latest updates and articles"
  }

  # Example: Additional topic for product announcements
  topic {
    default_subscription_status = "OPT_OUT"
    display_name                = "Product Announcements"
    topic_name                  = "product-announcements"
    description                 = "Stay informed about new product launches and major updates"
  }

  # Example: Additional topic for marketing offers
  topic {
    default_subscription_status = "OPT_OUT"
    display_name                = "Special Offers"
    topic_name                  = "special-offers"
    description                 = "Get notified about exclusive deals and promotional campaigns"
  }
}

################################################################################
# Computed Attributes (Available after creation)
################################################################################
# The following attributes are exported and can be referenced:
#
# - arn: Amazon Resource Name (ARN) of the contact list
#   Example: aws_sesv2_contact_list.example.arn
#
# - id: Name of the contact list (same as contact_list_name)
#   Example: aws_sesv2_contact_list.example.id
#
# - created_timestamp: Timestamp noting when the contact list was created in ISO 8601 format
#   Example: aws_sesv2_contact_list.example.created_timestamp
#
# - last_updated_timestamp: Timestamp noting the last time the contact list was updated in ISO 8601 format
#   Example: aws_sesv2_contact_list.example.last_updated_timestamp
#
# - tags_all: Map of tags assigned to the resource, including those inherited from
#   the provider default_tags configuration block
#   Example: aws_sesv2_contact_list.example.tags_all
################################################################################

################################################################################
# Usage Examples
################################################################################

# Example 1: Basic Contact List (Minimal Configuration)
# resource "aws_sesv2_contact_list" "basic" {
#   contact_list_name = "basic-contact-list"
# }

# Example 2: Contact List with Single Topic
# resource "aws_sesv2_contact_list" "single_topic" {
#   contact_list_name = "single-topic-list"
#   description       = "Newsletter subscribers"
#
#   topic {
#     default_subscription_status = "OPT_IN"
#     display_name                = "Monthly Newsletter"
#     topic_name                  = "monthly-newsletter"
#     description                 = "Receive our monthly digest"
#   }
# }

# Example 3: Contact List with Multiple Topics and Tags
# resource "aws_sesv2_contact_list" "comprehensive" {
#   contact_list_name = "comprehensive-contact-list"
#   description       = "All subscriber preferences"
#
#   topic {
#     default_subscription_status = "OPT_OUT"
#     display_name                = "Blog Updates"
#     topic_name                  = "blog-updates"
#     description                 = "New blog post notifications"
#   }
#
#   topic {
#     default_subscription_status = "OPT_OUT"
#     display_name                = "Event Invitations"
#     topic_name                  = "event-invitations"
#     description                 = "Upcoming event announcements"
#   }
#
#   topic {
#     default_subscription_status = "OPT_IN"
#     display_name                = "Important Updates"
#     topic_name                  = "important-updates"
#     description                 = "Critical service announcements"
#   }
#
#   tags = {
#     Environment = "Production"
#     Team        = "Marketing"
#     Application = "Email-Service"
#     CostCenter  = "Marketing-123"
#   }
# }

################################################################################
# Import
################################################################################
# SESv2 (Simple Email V2) Contact List can be imported using the contact_list_name
#
# Example:
# terraform import aws_sesv2_contact_list.example example-contact-list
################################################################################

################################################################################
# Best Practices and Considerations
################################################################################
# 1. Contact List Naming:
#    - Use descriptive, lowercase names with hyphens
#    - Keep names short but meaningful
#    - Consider including purpose or audience in the name
#
# 2. Topic Organization:
#    - Create separate topics for different content types
#    - Use clear, user-friendly display names
#    - Provide detailed descriptions to help recipients understand each topic
#
# 3. Default Subscription Status:
#    - Use OPT_OUT for marketing content to comply with regulations
#    - Use OPT_IN for critical updates that most users should receive
#    - Consider your legal requirements (GDPR, CAN-SPAM, etc.)
#
# 4. Tagging Strategy:
#    - Tag for cost allocation and tracking
#    - Include environment, team, and application identifiers
#    - Use consistent tagging across all SES resources
#
# 5. Regional Considerations:
#    - SES is available in specific regions only
#    - Choose a region based on your sending patterns and latency requirements
#    - Consider data residency requirements for your recipients
#
# 6. Security:
#    - Use IAM policies to control who can manage contact lists
#    - Regularly review and audit contact list access
#    - Implement proper data retention policies
#
# 7. Lifecycle Management:
#    - Document the purpose and owner of each contact list
#    - Regularly clean up unused contact lists
#    - Monitor contact list size and engagement metrics
################################################################################
