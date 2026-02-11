# ================================================================================
# Terraform Template: aws_connect_contact_flow_module
# ================================================================================
# Generated on: 2026-01-19
# Provider version: 6.28.0
#
# Note: This template was generated based on the AWS Provider schema at the time
# of generation. Always refer to the official documentation for the most up-to-date
# information and best practices.
#
# Official Documentation:
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/connect_contact_flow_module
# ================================================================================

# Amazon Connect Contact Flow Module Resource
#
# Provides an Amazon Connect Contact Flow Module resource for creating reusable
# sections of flows that can be invoked across multiple contact flows.
#
# Flow modules are reusable components that allow for extracting repeatable logic
# and creating common functions. They simplify managing common functionality,
# make flow maintenance more efficient, and support more reusable and dynamic experiences.
#
# For more information:
# - Amazon Connect Getting Started: https://docs.aws.amazon.com/connect/latest/adminguide/amazon-connect-get-started.html
# - Flow Modules: https://docs.aws.amazon.com/connect/latest/adminguide/contact-flow-modules.html
# - Amazon Connect Flow Language: https://docs.aws.amazon.com/connect/latest/adminguide/flow-language.html
#
# WARNING: Contact Flow Modules exported from the Console are NOT in the Amazon Connect
# Contact Flow Language format and cannot be used with this resource. Use the AWS CLI
# describe-contact-flow-module command instead:
# https://docs.aws.amazon.com/cli/latest/reference/connect/describe-contact-flow-module.html

resource "aws_connect_contact_flow_module" "example" {
  # ============================================================
  # Required Parameters
  # ============================================================

  # instance_id - (Required) Specifies the identifier of the hosting Amazon Connect Instance.
  # Type: string
  # The unique identifier (ID) of the Amazon Connect instance where this contact flow
  # module will be created. You can find the instance ID in the Amazon Connect console
  # or by using the AWS CLI.
  # Example: "aaaaaaaa-bbbb-cccc-dddd-111111111111"
  instance_id = "aaaaaaaa-bbbb-cccc-dddd-111111111111"

  # name - (Required) Specifies the name of the Contact Flow Module.
  # Type: string
  # The name must be unique within the Amazon Connect instance. This name is used
  # to identify the module when invoking it from contact flows.
  # Example: "Example Module"
  name = "Example Module"

  # ============================================================
  # Optional Parameters
  # ============================================================

  # content - (Optional) Specifies the content of the Contact Flow Module, provided as
  # a JSON string, written in Amazon Connect Contact Flow Language.
  # Type: string (JSON)
  # This defines the actual flow logic of the module using Amazon Connect Flow Language.
  # The content must be a valid JSON structure following the Amazon Connect Flow Language
  # specification. If defined, the `filename` argument cannot be used (conflicts with filename).
  #
  # The JSON structure typically includes:
  # - Version: The version of the flow language (e.g., "2019-10-30")
  # - StartAction: The identifier of the first action to execute
  # - Actions: Array of action blocks that define the module's behavior
  # - Settings: Input/output parameters and transitions (Success, Error)
  #
  # Reference: https://docs.aws.amazon.com/connect/latest/adminguide/flow-language.html
  content = jsonencode({
    Version     = "2019-10-30"
    StartAction = "12345678-1234-1234-1234-123456789012"
    Actions = [
      {
        Identifier = "12345678-1234-1234-1234-123456789012"
        Type       = "MessageParticipant"
        Parameters = {
          Text = "Hello from contact flow module"
        }
        Transitions = {
          NextAction = "abcdef-abcd-abcd-abcd-abcdefghijkl"
          Errors     = []
          Conditions = []
        }
      },
      {
        Identifier  = "abcdef-abcd-abcd-abcd-abcdefghijkl"
        Type        = "DisconnectParticipant"
        Parameters  = {}
        Transitions = {}
      }
    ]
    Settings = {
      InputParameters  = []
      OutputParameters = []
      Transitions = [
        {
          DisplayName   = "Success"
          ReferenceName = "Success"
          Description   = ""
        },
        {
          DisplayName   = "Error"
          ReferenceName = "Error"
          Description   = ""
        }
      ]
    }
  })

  # content_hash - (Optional) Used to trigger updates. Must be set to a base64-encoded
  # SHA256 hash of the Contact Flow Module source specified with `filename`.
  # Type: string
  # This parameter is used to detect changes in the external file content and trigger
  # updates to the resource. When using `filename`, set this to ensure Terraform can
  # detect when the file content changes.
  #
  # Terraform 0.11.12 and later: filebase64sha256("contact_flow_module.json")
  # Terraform 0.11.11 and earlier: base64sha256(file("contact_flow_module.json"))
  #
  # Example value: "47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU="
  # Note: Only used when `filename` is specified. Set to null when using `content`.
  content_hash = null

  # description - (Optional) Specifies the description of the Contact Flow Module.
  # Type: string
  # A human-readable description that explains the purpose and functionality of this
  # contact flow module. This helps other administrators understand what the module
  # does when browsing the list of modules.
  # Maximum length: 500 characters
  # Example: "This module handles customer authentication and verification"
  description = "Example Contact Flow Module Description"

  # filename - (Optional) The path to the Contact Flow Module source within the local filesystem.
  # Type: string
  # Path to a local file containing the Contact Flow Module JSON content. This provides
  # an alternative to specifying the content inline. Conflicts with `content` - you can
  # only use one or the other, not both.
  #
  # When using this parameter, also set `content_hash` to ensure Terraform detects
  # file changes and updates the resource accordingly.
  #
  # Example: "modules/contact_flow_module.json"
  # Note: Conflicts with `content`. Set to null when using `content`.
  filename = null

  # id - (Optional) Terraform resource identifier.
  # Type: string
  # This is typically not set manually. Terraform uses this internally to track the resource.
  # The computed value will be in the format: "instance_id:contact_flow_module_id"
  # Example: "aaaaaaaa-bbbb-cccc-dddd-111111111111:cccccccc-dddd-eeee-ffff-222222222222"
  # Note: Generally should not be set manually; Terraform manages this automatically.
  id = null

  # region - (Optional) Region where this resource will be managed.
  # Type: string
  # Specifies the AWS region where this Contact Flow Module will be created.
  # Defaults to the region set in the provider configuration.
  # Reference: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # Example: "us-west-2"
  # Note: If not specified, uses the provider's configured region.
  region = null

  # tags - (Optional) Tags to apply to the Contact Flow Module.
  # Type: map(string)
  # Key-value pairs for organizing and identifying resources. These tags are
  # specific to this resource. If configured with a provider default_tags
  # configuration block, tags with matching keys will overwrite those defined
  # at the provider-level.
  #
  # Reference: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  # Example tags for organizing resources by environment, application, and team
  tags = {
    Name        = "Example Contact Flow Module"
    Environment = "Production"
    Application = "CustomerService"
    ManagedBy   = "Terraform"
  }

  # tags_all - (Optional) A map of tags assigned to the resource, including those
  # inherited from the provider default_tags configuration block.
  # Type: map(string)
  # This attribute is typically computed and managed by Terraform. It combines
  # the tags defined in this resource with any default_tags from the provider.
  # Generally, you don't need to set this manually.
  #
  # Reference: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  # Note: Automatically managed by Terraform when using provider default_tags.
  tags_all = null
}

# ================================================================================
# Computed Attributes (Read-Only)
# ================================================================================
# These attributes are computed by AWS and available after resource creation:
#
# - arn (string): The Amazon Resource Name (ARN) of the Contact Flow Module.
#   Example: "arn:aws:connect:us-east-1:123456789012:instance/aaaaaaaa-bbbb-cccc-dddd-111111111111/contact-flow-module/cccccccc-dddd-eeee-ffff-222222222222"
#
# - contact_flow_module_id (string): The identifier of the Contact Flow Module.
#   This is the unique ID assigned by Amazon Connect when the module is created.
#   Example: "cccccccc-dddd-eeee-ffff-222222222222"
#
# ================================================================================
# Usage Examples
# ================================================================================
#
# Example 1: Basic Contact Flow Module with inline content
# ---------------------------------------------------------
# resource "aws_connect_contact_flow_module" "basic" {
#   instance_id = aws_connect_instance.main.id
#   name        = "CustomerGreeting"
#   description = "Greets customers with a personalized message"
#
#   content = jsonencode({
#     Version     = "2019-10-30"
#     StartAction = "greeting-action"
#     Actions = [
#       {
#         Identifier = "greeting-action"
#         Type       = "MessageParticipant"
#         Parameters = {
#           Text = "Thank you for contacting us!"
#         }
#         Transitions = {
#           NextAction = "end-action"
#           Errors     = []
#           Conditions = []
#         }
#       },
#       {
#         Identifier  = "end-action"
#         Type        = "DisconnectParticipant"
#         Parameters  = {}
#         Transitions = {}
#       }
#     ]
#     Settings = {
#       InputParameters  = []
#       OutputParameters = []
#       Transitions      = [
#         { DisplayName = "Success", ReferenceName = "Success", Description = "" },
#         { DisplayName = "Error", ReferenceName = "Error", Description = "" }
#       ]
#     }
#   })
#
#   tags = {
#     Purpose = "CustomerGreeting"
#   }
# }
#
# Example 2: Contact Flow Module using external file
# ---------------------------------------------------
# resource "aws_connect_contact_flow_module" "from_file" {
#   instance_id  = aws_connect_instance.main.id
#   name         = "AuthenticationModule"
#   description  = "Handles customer authentication"
#   filename     = "${path.module}/flows/authentication_module.json"
#   content_hash = filebase64sha256("${path.module}/flows/authentication_module.json")
#
#   tags = {
#     Purpose = "Authentication"
#   }
# }
#
# Example 3: Output the module ARN and ID
# ----------------------------------------
# output "contact_flow_module_arn" {
#   description = "ARN of the contact flow module"
#   value       = aws_connect_contact_flow_module.example.arn
# }
#
# output "contact_flow_module_id" {
#   description = "ID of the contact flow module"
#   value       = aws_connect_contact_flow_module.example.contact_flow_module_id
# }
#
# ================================================================================
# Important Notes
# ================================================================================
#
# 1. Flow Language Format: The content must be in Amazon Connect Flow Language format.
#    Contact Flow Modules exported from the AWS Console are NOT in this format and
#    cannot be used directly. Use the AWS CLI describe-contact-flow-module command
#    to get the proper format:
#
#    aws connect describe-contact-flow-module \
#      --instance-id <instance-id> \
#      --contact-flow-module-id <module-id> \
#      --region <region> | jq '.ContactFlowModule.Content | fromjson' > module.json
#
# 2. Conflict between content and filename: You must use either `content` or `filename`,
#    not both. Choose based on your preference for inline vs. external file management.
#
# 3. Module Versioning: Amazon Connect supports module versioning and aliasing for
#    better maintenance and deployment control. This is managed through the AWS Console
#    or API, not through Terraform.
#
# 4. Module Limitations:
#    - Modules cannot override flow local data of the invoking flow
#    - Modules cannot invoke other modules
#    - To pass data to/from modules, use attributes
#    - Only supported in Inbound flows
#
# 5. Permissions: Ensure your security profile has permissions to create and manage
#    modules before attempting to use this resource.
#
# 6. Tagging: Use the provider-level default_tags for consistent tagging across
#    all resources in your infrastructure.
#
# ================================================================================
