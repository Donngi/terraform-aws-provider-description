# ==============================================================================
# Terraform AWS Resource Template: aws_cloudfront_field_level_encryption_profile
# ==============================================================================
# Generated: 2026-01-18
# Provider Version: 6.28.0
#
# Note: This template is generated based on the AWS Provider schema at the time
# of generation. For the most up-to-date information, please refer to the
# official Terraform documentation:
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_field_level_encryption_profile
# ==============================================================================

# ------------------------------------------------------------------------------
# CloudFront Field-Level Encryption Profile
# ------------------------------------------------------------------------------
# Provides a CloudFront Field-level Encryption Profile resource.
#
# Field-level encryption adds an additional layer of security that lets you
# protect specific data throughout system processing so that only certain
# applications can see it. The sensitive information provided by your users
# is encrypted at the edge, close to the user, and remains encrypted throughout
# your entire application stack.
#
# AWS Documentation:
# - User Guide: https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/field-level-encryption.html
# - API Reference: https://docs.aws.amazon.com/cloudfront/latest/APIReference/API_FieldLevelEncryptionProfileConfig.html
# ------------------------------------------------------------------------------

resource "aws_cloudfront_field_level_encryption_profile" "example" {
  # ----------------------------------------------------------------------------
  # Required Arguments
  # ----------------------------------------------------------------------------

  # name - (Required) The name of the Field Level Encryption Profile.
  # The name can't have spaces and can include only alphanumeric characters,
  # underscores (_), and hyphens (-). Maximum 128 characters.
  # Type: string
  name = "example-fle-profile"

  # ----------------------------------------------------------------------------
  # Optional Arguments
  # ----------------------------------------------------------------------------

  # comment - (Optional) An optional comment about the Field Level Encryption
  # Profile. The comment cannot be longer than 128 characters.
  # Type: string
  comment = "Example field-level encryption profile for sensitive data"

  # id - (Optional) The identifier for the Field Level Encryption Profile.
  # If not specified, Terraform will assign a computed ID.
  # Type: string
  # Note: Typically not set explicitly as CloudFront generates this value.
  # id = "K3D5EWEUDCCXON"

  # ----------------------------------------------------------------------------
  # Block: encryption_entities
  # ----------------------------------------------------------------------------
  # (Required) The encryption entities config block for field-level encryption
  # profiles that contains an attribute 'items' which includes the encryption
  # key and field pattern specifications.
  #
  # This block defines which fields should be encrypted and with which public key.
  # Max items: 1
  # ----------------------------------------------------------------------------
  encryption_entities {
    # --------------------------------------------------------------------------
    # Block: items
    # --------------------------------------------------------------------------
    # (Required) A complex data type of encryption entities for the field-level
    # encryption profile that include the public key ID, provider, and field
    # patterns for specifying which fields to encrypt with this key.
    #
    # Nesting mode: set
    # You can specify multiple items to encrypt different sets of fields with
    # different keys.
    # --------------------------------------------------------------------------
    items {
      # provider_id - (Required) The provider associated with the public key
      # being used for encryption. This value, along with the private key, is
      # required for applications to decrypt data. The provider name can't have
      # spaces and can include only alphanumeric characters, colons (:),
      # underscores (_), and hyphens (-). Maximum 128 characters.
      # Type: string
      provider_id = "example-provider"

      # public_key_id - (Required) The public key associated with a set of
      # field-level encryption patterns, to be used when encrypting the fields
      # that match the patterns. This should reference a CloudFront public key
      # that you've previously uploaded.
      # Type: string
      # Reference: aws_cloudfront_public_key resource
      public_key_id = "K3Q5EWEUDCCXON"

      # ------------------------------------------------------------------------
      # Block: field_patterns
      # ------------------------------------------------------------------------
      # (Required) Object that contains an attribute 'items' that contains the
      # list of field patterns in a field-level encryption content type profile
      # specify the fields that you want to be encrypted.
      #
      # Min items: 1, Max items: 1
      # ------------------------------------------------------------------------
      field_patterns {
        # items - (Optional) A list of field patterns in a field-level
        # encryption content type profile that specify the fields that you want
        # to be encrypted. You can provide the full field name, or any beginning
        # characters followed by a wildcard (*). You can't use overlapping field
        # patterns. For example, you can't have both ABC* and AB*.
        #
        # Field name patterns must include only alphanumeric characters, square
        # brackets ([ and ]), periods (.), underscores (_), and hyphens (-), in
        # addition to the optional wildcard character (*).
        #
        # Field names are case-sensitive. Maximum 128 characters per field name.
        # You can encrypt up to 10 data fields in a request.
        #
        # Type: set of strings
        #
        # Examples:
        # - "DateOfBirth" - Encrypts exact field name
        # - "CreditCard*" - Encrypts any field starting with CreditCard
        # - "SSN" - Encrypts Social Security Number field
        items = [
          "DateOfBirth",
          "CreditCard*",
          "SSN",
        ]
      }
    }

    # Example: Multiple encryption entities with different keys
    # You can define multiple items blocks to encrypt different field sets
    # with different public keys.
    #
    # items {
    #   provider_id   = "payment-provider"
    #   public_key_id = "K2B4EWEUDCCXON"
    #
    #   field_patterns {
    #     items = [
    #       "CardNumber",
    #       "CVV",
    #     ]
    #   }
    # }
  }

  # ----------------------------------------------------------------------------
  # Computed Attributes (Read-Only)
  # ----------------------------------------------------------------------------
  # These attributes are set by AWS and cannot be configured:
  #
  # - arn: The Field Level Encryption Profile ARN
  #   Example: "arn:aws:cloudfront::123456789012:field-level-encryption-profile/K3D5EWEUDCCXON"
  #
  # - caller_reference: Internal value used by CloudFront to allow future
  #   updates to the Field Level Encryption Profile
  #   Example: "terraform-20230315120000000000000001"
  #
  # - etag: The current version of the Field Level Encryption Profile
  #   Example: "E2QWRUHAPOMQZL"
  # ----------------------------------------------------------------------------
}

# ------------------------------------------------------------------------------
# Example: Using with CloudFront Public Key
# ------------------------------------------------------------------------------
# Field-level encryption profiles require a public key to be uploaded to
# CloudFront first. Here's a complete example:
# ------------------------------------------------------------------------------

# resource "aws_cloudfront_public_key" "example" {
#   comment     = "Public key for field-level encryption"
#   encoded_key = file("public_key.pem")
#   name        = "example-public-key"
# }
#
# resource "aws_cloudfront_field_level_encryption_profile" "example" {
#   name    = "example-profile"
#   comment = "Encrypt sensitive customer data"
#
#   encryption_entities {
#     items {
#       provider_id   = "my-payment-provider"
#       public_key_id = aws_cloudfront_public_key.example.id
#
#       field_patterns {
#         items = [
#           "DateOfBirth",
#           "CreditCard*",
#         ]
#       }
#     }
#   }
# }

# ------------------------------------------------------------------------------
# Important Notes
# ------------------------------------------------------------------------------
# 1. RSA Key Pair: You must create a 2048-bit RSA key pair. The public key is
#    uploaded to CloudFront, and the private key is kept secure at your origin
#    for decryption.
#
# 2. Origin Support: Your origin must support chunked encoding to use
#    field-level encryption.
#
# 3. HTTPS Required: Field-level encryption requires HTTPS connections.
#    The cache behavior using this profile must have ViewerProtocolPolicy
#    set to "redirect-to-https" or "https-only".
#
# 4. HTTP Methods: The cache behavior must accept POST and PUT requests
#    (AllowedMethods must include GET, HEAD, OPTIONS, PUT, POST, PATCH, DELETE).
#
# 5. Field Patterns: You can use wildcards (*) in field name patterns, but
#    patterns cannot overlap (e.g., you can't have both "ABC*" and "AB*").
#
# 6. Encryption Limit: You can encrypt up to 10 data fields in a request.
#
# 7. Configuration: After creating a profile, you need to create a field-level
#    encryption configuration and associate it with a CloudFront distribution's
#    cache behavior.
#
# 8. Decryption: At your origin, use the AWS Encryption SDK to decrypt the
#    encrypted field data using your private key.
# ------------------------------------------------------------------------------
