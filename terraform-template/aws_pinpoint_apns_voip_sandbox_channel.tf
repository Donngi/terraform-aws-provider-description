# ================================================================
# aws_pinpoint_apns_voip_sandbox_channel
# ================================================================
# Resource: aws_pinpoint_apns_voip_sandbox_channel
# Provider Version: 6.28.0
#
# Description:
# Provides a Pinpoint APNs VoIP Sandbox Channel resource.
#
# IMPORTANT SECURITY NOTICE:
# All arguments, including certificates and tokens, will be stored in the
# raw state as plain-text. Read more about sensitive data in state:
# https://www.terraform.io/docs/state/sensitive-data.html
#
# Official Documentation:
# https://raw.githubusercontent.com/hashicorp/terraform-provider-aws/main/website/docs/r/pinpoint_apns_voip_sandbox_channel.html.markdown
# ================================================================

# ================================================================
# Basic Example - Certificate-based Authentication
# ================================================================
resource "aws_pinpoint_apns_voip_sandbox_channel" "example" {
  # ----------------------------------------------------------------
  # Required Arguments
  # ----------------------------------------------------------------

  # Application ID for the Pinpoint application
  # Type: string
  # Required: Yes
  application_id = aws_pinpoint_app.example.application_id

  # ----------------------------------------------------------------
  # Certificate-based Authentication (Option 1)
  # ----------------------------------------------------------------
  # Use this set of credentials for certificate-based APNs authentication

  # PEM encoded TLS Certificate from Apple
  # Type: string
  # Required: Yes (if using certificate authentication)
  # Sensitive: Yes
  certificate = file("./certificate.pem")

  # Certificate Private Key file (e.g., .key file)
  # Type: string
  # Required: Yes (if using certificate authentication)
  # Sensitive: Yes
  private_key = file("./private_key.key")

  # ----------------------------------------------------------------
  # Optional Arguments
  # ----------------------------------------------------------------

  # Whether the channel is enabled or disabled
  # Type: bool
  # Default: true
  enabled = true

  # The default authentication method used for APNs
  # NOTE: Amazon Pinpoint uses this default for every APNs push notification
  # sent via console. You can override when sending programmatically.
  # If default authentication fails, Pinpoint won't attempt other methods.
  # Type: string
  # Possible values: "CERTIFICATE" or "TOKEN"
  default_authentication_method = "CERTIFICATE"

  # Region where this resource will be managed
  # Type: string
  # Default: Provider region
  # Computed: Yes
  # region = "us-east-1"
}

# ----------------------------------------------------------------
# Supporting Resource: Pinpoint App
# ----------------------------------------------------------------
resource "aws_pinpoint_app" "example" {
  # name = "example-app"
}

# ================================================================
# Alternative Example - Token-based Authentication (Key credentials)
# ================================================================
resource "aws_pinpoint_apns_voip_sandbox_channel" "token_based" {
  # ----------------------------------------------------------------
  # Required Arguments
  # ----------------------------------------------------------------

  application_id = aws_pinpoint_app.example.application_id

  # ----------------------------------------------------------------
  # Token-based Authentication (Option 2)
  # ----------------------------------------------------------------
  # Use this set of credentials for token-based APNs authentication

  # ID assigned to your iOS app
  # To find: Certificates, IDs & Profiles → App IDs in Identifiers → your app
  # Type: string
  # Required: Yes (if using token authentication)
  # Sensitive: Yes
  bundle_id = "com.example.app"

  # ID assigned to your Apple developer account team
  # Provided on the Membership page
  # Type: string
  # Required: Yes (if using token authentication)
  # Sensitive: Yes
  team_id = "ABCDE12345"

  # The .p8 file downloaded from Apple developer account
  # Created when you create an authentication key
  # Type: string
  # Required: Yes (if using token authentication)
  # Sensitive: Yes
  token_key = file("./AuthKey_ABCDE12345.p8")

  # ID assigned to your signing key
  # To find: Certificates, IDs & Profiles → Keys section → your key
  # Type: string
  # Required: Yes (if using token authentication)
  # Sensitive: Yes
  token_key_id = "ABCDE12345"

  # ----------------------------------------------------------------
  # Optional Arguments
  # ----------------------------------------------------------------

  enabled = true

  default_authentication_method = "TOKEN"
}

# ================================================================
# Attribute Reference
# ================================================================
# In addition to all arguments above, the following attributes are exported:
#
# - id: The application ID (same as application_id)
# - region: The AWS region where the resource is managed

# ================================================================
# Import
# ================================================================
# Pinpoint APNs VoIP Sandbox Channel can be imported using the application_id:
#
# terraform import aws_pinpoint_apns_voip_sandbox_channel.example application-id

# ================================================================
# Notes and Best Practices
# ================================================================
# 1. SECURITY: All sensitive values (certificates, keys, tokens) are stored
#    in plain-text in the Terraform state file. Consider using:
#    - State encryption at rest
#    - Secure state storage (e.g., S3 with encryption and access controls)
#    - Secret management solutions (AWS Secrets Manager, HashiCorp Vault)
#
# 2. AUTHENTICATION METHODS: Choose one of two authentication approaches:
#    a) Certificate-based: Requires certificate and private_key
#    b) Token-based: Requires bundle_id, team_id, token_key, and token_key_id
#
# 3. SANDBOX vs PRODUCTION: This resource is for VoIP Sandbox channels.
#    - Use for testing with development iOS devices
#    - Use aws_pinpoint_apns_voip_channel for production environments
#
# 4. DEFAULT AUTHENTICATION: The default_authentication_method is used for
#    console-initiated notifications. API/SDK calls can override this setting.
#
# 5. FILE REFERENCES: Use file() function to load certificates and keys
#    from local files, ensuring proper path references in your Terraform config.
#
# 6. VOIP NOTIFICATIONS: VoIP push notifications are specifically for
#    Voice over IP applications, providing high-priority delivery for calls.
