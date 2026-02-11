# ================================================================
# AWS End User Messaging SMS Phone Number
# Resource: aws_pinpointsmsvoicev2_phone_number
# Provider Version: 6.28.0
# ================================================================
# Description:
#   Manages an AWS End User Messaging SMS phone number for sending
#   SMS messages through Amazon Pinpoint SMS and Voice v2.
#
# Use Cases:
#   - Provisioning dedicated phone numbers for SMS campaigns
#   - Setting up transactional SMS notifications
#   - Configuring toll-free or long-code numbers for messaging
#   - Managing two-way SMS communication channels
#
# Documentation:
#   https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/pinpointsmsvoicev2_phone_number
# ================================================================

resource "aws_pinpointsmsvoicev2_phone_number" "example" {
  # ================================================================
  # REQUIRED PARAMETERS
  # These parameters must be provided for the resource to be created
  # ================================================================

  # --------------------------------------------------
  # iso_country_code (required)
  # Type: string
  # --------------------------------------------------
  # Description:
  #   The two-character code, in ISO 3166-1 alpha-2 format, for the
  #   country or region where the phone number will be leased.
  #
  # Valid Values:
  #   - "US" for United States
  #   - "CA" for Canada
  #   - Other ISO 3166-1 alpha-2 country codes as supported
  #
  # Example:
  iso_country_code = "US"

  # --------------------------------------------------
  # message_type (required)
  # Type: string
  # --------------------------------------------------
  # Description:
  #   The type of message that will be sent using this phone number.
  #   This determines message routing and handling.
  #
  # Valid Values:
  #   - "TRANSACTIONAL" - For critical or time-sensitive messages
  #                       (e.g., OTP codes, order confirmations)
  #   - "PROMOTIONAL" - For marketing messages that aren't time-sensitive
  #                    (e.g., special offers, newsletters)
  #
  # Example:
  message_type = "TRANSACTIONAL"

  # --------------------------------------------------
  # number_type (required)
  # Type: string
  # --------------------------------------------------
  # Description:
  #   The type of phone number to request. Different types have
  #   different capabilities and pricing.
  #
  # Valid Values:
  #   - "LONG_CODE" - Standard 10-digit local phone number
  #   - "TOLL_FREE" - Toll-free number (e.g., 1-800, 1-888)
  #   - "TEN_DLC" - 10-Digit Long Code for Application-to-Person (A2P)
  #   - "SIMULATOR" - Test number for development purposes
  #
  # Example:
  number_type = "TOLL_FREE"

  # --------------------------------------------------
  # number_capabilities (required)
  # Type: set of strings
  # --------------------------------------------------
  # Description:
  #   Describes if the origination identity can be used for text
  #   messages, voice calls, or both.
  #
  # Valid Values:
  #   - "SMS" - Enable text message capability
  #   - "VOICE" - Enable voice call capability
  #   - Can specify both ["SMS", "VOICE"] for dual capability
  #
  # Example:
  number_capabilities = ["SMS"]

  # ================================================================
  # OPTIONAL PARAMETERS
  # These parameters have defaults or are not required
  # ================================================================

  # --------------------------------------------------
  # region (optional, computed)
  # Type: string
  # Default: Provider's configured region
  # --------------------------------------------------
  # Description:
  #   Region where this resource will be managed. This determines
  #   the AWS region where the phone number is provisioned.
  #   If not specified, defaults to the region set in the provider
  #   configuration.
  #
  # Example:
  # region = "us-east-1"

  # --------------------------------------------------
  # deletion_protection_enabled (optional, computed)
  # Type: bool
  # Default: false
  # --------------------------------------------------
  # Description:
  #   When set to true, the phone number can't be deleted.
  #   This provides protection against accidental deletion.
  #
  # Example:
  # deletion_protection_enabled = true

  # --------------------------------------------------
  # opt_out_list_name (optional, computed)
  # Type: string
  # --------------------------------------------------
  # Description:
  #   The name of the opt-out list to associate with the phone number.
  #   An opt-out list manages recipients who have requested to stop
  #   receiving messages.
  #
  # Example:
  # opt_out_list_name = "default-opt-out-list"

  # --------------------------------------------------
  # registration_id (optional)
  # Type: string
  # --------------------------------------------------
  # Description:
  #   Use this field to attach your phone number for an external
  #   registration process. Required for certain number types
  #   and use cases (e.g., 10DLC registration).
  #
  # Example:
  # registration_id = "reg-1234567890abcdef"

  # --------------------------------------------------
  # self_managed_opt_outs_enabled (optional, computed)
  # Type: bool
  # Default: false
  # --------------------------------------------------
  # Description:
  #   When set to false (default), AWS automatically replies to HELP/STOP
  #   messages and manages the opt-out list. When set to true, you're
  #   responsible for handling HELP/STOP requests and maintaining the
  #   opt-out list yourself.
  #
  # Example:
  # self_managed_opt_outs_enabled = false

  # --------------------------------------------------
  # two_way_channel_enabled (optional, computed)
  # Type: bool
  # Default: false
  # --------------------------------------------------
  # Description:
  #   When set to true, you can receive incoming text messages from
  #   end recipients. Requires two_way_channel_arn and two_way_channel_role
  #   to be configured.
  #
  # Example:
  # two_way_channel_enabled = true

  # --------------------------------------------------
  # two_way_channel_arn (optional)
  # Type: string
  # --------------------------------------------------
  # Description:
  #   ARN to receive incoming SMS messages. Can be an SNS topic ARN,
  #   or use the format "connect.[region].amazonaws.com" to set
  #   Amazon Connect as the inbound destination.
  #
  # Example:
  # two_way_channel_arn = "arn:aws:sns:us-east-1:123456789012:incoming-sms"

  # --------------------------------------------------
  # two_way_channel_role (optional)
  # Type: string
  # --------------------------------------------------
  # Description:
  #   IAM Role ARN that allows AWS End User Messaging SMS to post
  #   inbound SMS messages to your specified destination (e.g., SNS topic).
  #
  # Example:
  # two_way_channel_role = "arn:aws:iam::123456789012:role/SMSInboundRole"

  # --------------------------------------------------
  # tags (optional)
  # Type: map of strings
  # --------------------------------------------------
  # Description:
  #   A map of tags to assign to the resource. Tags are key-value
  #   pairs used for organizing and managing AWS resources.
  #
  # Example:
  # tags = {
  #   Environment = "production"
  #   Application = "customer-notifications"
  #   ManagedBy   = "terraform"
  # }

  # ================================================================
  # TIMEOUTS BLOCK (optional)
  # ================================================================
  # Description:
  #   Customize timeout durations for create, update, and delete operations.
  #   Use Go duration format (e.g., "30s", "10m", "1h").
  #
  # Example:
  # timeouts {
  #   create = "30m"
  #   update = "30m"
  #   delete = "30m"
  # }
}

# ================================================================
# COMPUTED ATTRIBUTES (Read-Only)
# These attributes are set by AWS after resource creation
# ================================================================
# Available via: aws_pinpointsmsvoicev2_phone_number.example.<attribute>
#
# - arn
#   Type: string
#   Description: ARN of the phone number.
#   Example: "arn:aws:sms-voice:us-east-1:123456789012:phone-number/..."
#
# - id
#   Type: string
#   Description: ID of the phone number (same as phone_number).
#   Example: "+18005551234"
#
# - phone_number
#   Type: string
#   Description: The new phone number that was requested.
#   Example: "+18005551234"
#
# - monthly_leasing_price
#   Type: string
#   Description: The monthly price, in US dollars, to lease the phone number.
#   Example: "2.00"
#
# - tags_all
#   Type: map of strings
#   Description: A map of tags assigned to the resource, including those
#                inherited from the provider default_tags configuration.
# ================================================================

# ================================================================
# USAGE EXAMPLES
# ================================================================

# Example 1: Basic Toll-Free SMS Number for Transactional Messages
# ------------------------------------------------------------------
# resource "aws_pinpointsmsvoicev2_phone_number" "transactional" {
#   iso_country_code = "US"
#   message_type     = "TRANSACTIONAL"
#   number_type      = "TOLL_FREE"
#   number_capabilities = ["SMS"]
#
#   tags = {
#     Name        = "otp-verification-number"
#     Environment = "production"
#   }
# }

# Example 2: Two-Way SMS with Amazon Connect
# ------------------------------------------------------------------
# resource "aws_pinpointsmsvoicev2_phone_number" "two_way" {
#   iso_country_code = "US"
#   message_type     = "TRANSACTIONAL"
#   number_type      = "TOLL_FREE"
#   number_capabilities = ["SMS"]
#
#   two_way_channel_enabled = true
#   two_way_channel_arn     = "connect.us-east-1.amazonaws.com"
#   two_way_channel_role    = aws_iam_role.sms_inbound.arn
#
#   tags = {
#     Name = "customer-support-sms"
#   }
# }

# Example 3: 10DLC Number with Registration and Custom Opt-Out List
# ------------------------------------------------------------------
# resource "aws_pinpointsmsvoicev2_phone_number" "ten_dlc" {
#   iso_country_code = "US"
#   message_type     = "PROMOTIONAL"
#   number_type      = "TEN_DLC"
#   number_capabilities = ["SMS"]
#
#   registration_id              = aws_pinpointsmsvoicev2_registration.example.id
#   opt_out_list_name            = "marketing-opt-outs"
#   deletion_protection_enabled  = true
#
#   tags = {
#     Name        = "marketing-campaigns"
#     CostCenter  = "marketing"
#   }
# }

# Example 4: Long Code Number with Self-Managed Opt-Outs
# ------------------------------------------------------------------
# resource "aws_pinpointsmsvoicev2_phone_number" "long_code" {
#   iso_country_code = "US"
#   message_type     = "TRANSACTIONAL"
#   number_type      = "LONG_CODE"
#   number_capabilities = ["SMS"]
#
#   self_managed_opt_outs_enabled = true
#
#   tags = {
#     Name = "custom-notification-system"
#   }
# }

# ================================================================
# IMPORTANT NOTES AND BEST PRACTICES
# ================================================================
#
# 1. Number Type Selection:
#    - TOLL_FREE: Best for high-volume messaging, no per-message surcharge
#    - TEN_DLC: Required for Application-to-Person (A2P) messaging
#    - LONG_CODE: Standard local numbers, may have throughput limitations
#    - SIMULATOR: Use only for testing, not for production
#
# 2. Message Type:
#    - Use TRANSACTIONAL for time-sensitive messages (OTP, alerts)
#    - Use PROMOTIONAL for marketing campaigns
#    - Message type affects carrier filtering and delivery rates
#
# 3. Registration Requirements:
#    - 10DLC numbers require registration with The Campaign Registry (TCR)
#    - Set registration_id for compliance with carrier requirements
#
# 4. Two-Way Messaging:
#    - Requires IAM role with permissions to write to destination
#    - SNS topic is common destination for inbound messages
#    - Amazon Connect can be used for customer service use cases
#
# 5. Opt-Out Management:
#    - Default behavior handles HELP/STOP automatically
#    - Use self_managed_opt_outs_enabled only if you need custom logic
#    - Must maintain compliance with TCPA regulations
#
# 6. Deletion Protection:
#    - Enable for production phone numbers to prevent accidental deletion
#    - Must be disabled before the number can be deleted
#
# 7. Regional Considerations:
#    - Not all number types are available in all regions
#    - Specify region parameter if deploying across multiple regions
#
# 8. Cost Management:
#    - monthly_leasing_price shows recurring costs
#    - Additional per-message charges apply based on message type
#    - Use tags for cost allocation and tracking
#
# 9. Timeouts:
#    - Phone number provisioning can take several minutes
#    - Consider increasing timeout for create operations
#
# 10. Import:
#     - Existing phone numbers can be imported using their ID
#     - Format: terraform import aws_pinpointsmsvoicev2_phone_number.example +18005551234
# ================================================================
