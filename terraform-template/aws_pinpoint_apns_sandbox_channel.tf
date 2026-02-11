########################################
# AWS Pinpoint APNs Sandbox Channel
########################################
# Provides a Pinpoint APNs Sandbox Channel resource.
#
# ~> Note: All arguments, including certificates and tokens, will be stored in the raw state as plain-text.
# Read more about sensitive data in state: https://www.terraform.io/docs/state/sensitive-data.html
#
# This resource allows you to configure Apple Push Notification service (APNs) Sandbox
# environment for testing push notifications in your iOS apps before production deployment.
#
# AWS Provider Version: 6.28.0
# Terraform Resource: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/pinpoint_apns_sandbox_channel

resource "aws_pinpoint_apns_sandbox_channel" "example" {
  ########################################
  # Required Arguments
  ########################################

  # (Required) The application ID of the Pinpoint app for which to configure this APNs Sandbox channel.
  # This ID is returned when you create a Pinpoint app.
  # Type: string
  application_id = null # Example: aws_pinpoint_app.app.application_id


  ########################################
  # Optional Arguments - Channel Configuration
  ########################################

  # (Optional) Whether the channel is enabled or disabled.
  # When disabled, Pinpoint will not send push notifications through this channel.
  # Type: bool
  # Default: true
  # enabled = true

  # (Optional) The default authentication method used for APNs Sandbox.
  # Valid values:
  #   - "CERTIFICATE" - Use certificate-based authentication
  #   - "TOKEN" - Use token-based authentication (recommended)
  # NOTE: Amazon Pinpoint uses this default for every APNs push notification that you send using the console.
  # You can override the default when you send a message programmatically using the Amazon Pinpoint API, the AWS CLI, or an AWS SDK.
  # If your default authentication type fails, Amazon Pinpoint doesn't attempt to use the other authentication type.
  # Type: string
  # default_authentication_method = "TOKEN"

  # (Optional) Region where this resource will be managed.
  # Defaults to the Region set in the provider configuration.
  # Type: string
  # Computed: true
  # region = null


  ########################################
  # Certificate-Based Authentication (Option 1)
  ########################################
  # Use these arguments if you choose certificate-based authentication.
  # You'll need to provide both the certificate and private key.

  # (Optional) The PEM encoded TLS Certificate from Apple.
  # This is the SSL certificate you download from the Apple Developer portal.
  # Type: string
  # Sensitive: true
  # Example: certificate = file("./certificate.pem")
  # certificate = null

  # (Optional) The Certificate Private Key file (i.e., .key file).
  # This is the private key associated with your SSL certificate.
  # Type: string
  # Sensitive: true
  # Example: private_key = file("./private_key.key")
  # private_key = null


  ########################################
  # Token-Based Authentication (Option 2) - Recommended
  ########################################
  # Use these arguments if you choose token-based authentication (APNs Auth Key).
  # Token-based authentication is the recommended approach as it:
  # - Never expires (unlike certificates which expire annually)
  # - Can be used across multiple apps
  # - Is easier to manage

  # (Optional) The ID assigned to your iOS app.
  # To find this value in Apple Developer portal:
  # 1. Choose Certificates, IDs & Profiles
  # 2. Choose App IDs in the Identifiers section
  # 3. Choose your app
  # Type: string
  # Sensitive: true
  # bundle_id = null

  # (Optional) The ID assigned to your Apple developer account team.
  # This value is provided on the Membership page of your Apple Developer account.
  # Type: string
  # Sensitive: true
  # team_id = null

  # (Optional) The .p8 file that you download from your Apple developer account when you create an authentication key.
  # This is the APNs Auth Key file content.
  # Type: string
  # Sensitive: true
  # Example: token_key = file("./AuthKey_XXXXXXXXXX.p8")
  # token_key = null

  # (Optional) The ID assigned to your signing key (Key ID).
  # To find this value in Apple Developer portal:
  # 1. Choose Certificates, IDs & Profiles
  # 2. Choose your key in the Keys section
  # The Key ID is a 10-character string (e.g., "XXXXXXXXXX")
  # Type: string
  # Sensitive: true
  # token_key_id = null


  ########################################
  # Computed Attributes
  ########################################
  # These attributes are computed by AWS and exported after resource creation:
  #
  # - id (string) - The unique identifier for this channel (computed)
  # - region (string) - The AWS region where the resource is managed (computed if not specified)


  ########################################
  # Additional Notes
  ########################################
  # Security Considerations:
  # - All credentials (certificates, keys, tokens) are stored as plain-text in the Terraform state
  # - Use remote state with encryption for production environments
  # - Consider using AWS Secrets Manager or similar for credential management
  #
  # Authentication Method Selection:
  # - Choose ONE authentication method (Certificate OR Token)
  # - Token-based authentication is recommended for new implementations
  # - Set default_authentication_method accordingly
  #
  # APNs Sandbox vs Production:
  # - Use APNs Sandbox channel for testing with development/TestFlight builds
  # - Use APNs (production) channel for App Store builds
  # - The sandbox environment has different endpoints and certificate requirements
  #
  # Testing:
  # - Ensure your iOS app is configured with the appropriate APNs environment
  # - Development builds must use the sandbox channel
  # - Test notifications before deploying to production
}


########################################
# Example Configurations
########################################

# Example 1: Certificate-based authentication
# resource "aws_pinpoint_apns_sandbox_channel" "certificate_example" {
#   application_id = aws_pinpoint_app.app.application_id
#
#   default_authentication_method = "CERTIFICATE"
#   certificate                   = file("./certificate.pem")
#   private_key                   = file("./private_key.key")
#   enabled                       = true
# }

# Example 2: Token-based authentication (Recommended)
# resource "aws_pinpoint_apns_sandbox_channel" "token_example" {
#   application_id = aws_pinpoint_app.app.application_id
#
#   default_authentication_method = "TOKEN"
#   bundle_id                     = "com.example.myapp"
#   team_id                       = "TEAM123456"
#   token_key                     = file("./AuthKey_XXXXXXXXXX.p8")
#   token_key_id                  = "XXXXXXXXXX"
#   enabled                       = true
# }

# Example 3: Complete setup with Pinpoint app
# resource "aws_pinpoint_app" "app" {
#   name = "my-mobile-app-sandbox"
# }
#
# resource "aws_pinpoint_apns_sandbox_channel" "sandbox" {
#   application_id = aws_pinpoint_app.app.application_id
#
#   default_authentication_method = "TOKEN"
#   bundle_id                     = "com.example.myapp"
#   team_id                       = "TEAM123456"
#   token_key                     = file("./AuthKey_XXXXXXXXXX.p8")
#   token_key_id                  = "XXXXXXXXXX"
#   enabled                       = true
# }
