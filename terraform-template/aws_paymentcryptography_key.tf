################################################################################
# AWS Payment Cryptography Control Plane Key
################################################################################
# Terraform resource for managing an AWS Payment Cryptography Control Plane Key.
# This resource allows you to create and manage cryptographic keys used for
# payment processing operations.
#
# Provider Version: 6.28.0
# Resource Documentation: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/paymentcryptography_key
################################################################################

resource "aws_paymentcryptography_key" "example" {
  #------------------------------------------------------------------------------
  # Required Arguments
  #------------------------------------------------------------------------------

  # Whether the key is exportable from the service
  # Type: bool
  # When set to true, allows the key to be exported for use outside AWS Payment
  # Cryptography service. Consider security implications before enabling.
  exportable = true

  # Role of the key, the algorithm it supports, and the cryptographic operations
  # allowed with the key
  # Type: object
  key_attributes {
    # Key algorithm to be use during creation of an AWS Payment Cryptography key
    # Type: string
    # Common values include:
    # - TDES_2KEY: Triple DES with 2 keys
    # - TDES_3KEY: Triple DES with 3 keys
    # - AES_128: AES with 128-bit key
    # - AES_192: AES with 192-bit key
    # - AES_256: AES with 256-bit key
    # - RSA_2048: RSA with 2048-bit key
    # - RSA_3072: RSA with 3072-bit key
    # - RSA_4096: RSA with 4096-bit key
    key_algorithm = "TDES_3KEY"

    # Type of AWS Payment Cryptography key to create
    # Type: string
    # Valid values:
    # - SYMMETRIC_KEY: For symmetric encryption algorithms
    # - ASYMMETRIC_KEY_PAIR: For asymmetric encryption algorithms
    # - PRIVATE_KEY: Private key component of an asymmetric key pair
    # - PUBLIC_KEY: Public key component of an asymmetric key pair
    key_class = "SYMMETRIC_KEY"

    # Cryptographic usage of an AWS Payment Cryptography key as defined in
    # section A.5.2 of the TR-31 spec
    # Type: string
    # Common TR-31 key usage values include:
    # - TR31_P0_PIN_ENCRYPTION_KEY: PIN encryption key
    # - TR31_D0_SYMMETRIC_DATA_ENCRYPTION_KEY: Data encryption key
    # - TR31_K0_KEY_ENCRYPTION_KEY: Key encryption key
    # - TR31_M1_ISO_9797_1_MAC_KEY: MAC key
    # - TR31_V1_VISA_CVV_KEY: CVV verification key
    key_usage = "TR31_P0_PIN_ENCRYPTION_KEY"

    # Cryptographic operations that the key can perform
    # Type: object
    key_modes_of_use {
      # Whether an AWS Payment Cryptography key can be used to decrypt data
      # Type: bool
      # Default: false
      decrypt = true

      # Whether an AWS Payment Cryptography key can be used to derive new keys
      # Type: bool
      # Default: false
      # derive_key = false

      # Whether an AWS Payment Cryptography key can be used to encrypt data
      # Type: bool
      # Default: false
      encrypt = true

      # Whether an AWS Payment Cryptography key can be used to generate and
      # verify other card and PIN verification keys
      # Type: bool
      # Default: false
      # generate = false

      # Whether an AWS Payment Cryptography key has no special restrictions
      # other than the restrictions implied by KeyUsage
      # Type: bool
      # Default: false
      # no_restrictions = false

      # Whether an AWS Payment Cryptography key can be used for signing
      # Type: bool
      # Default: false
      # sign = false

      # Whether an AWS Payment Cryptography key can be used to unwrap other keys
      # Type: bool
      # Default: false
      unwrap = true

      # Whether an AWS Payment Cryptography key can be used to verify signatures
      # Type: bool
      # Default: false
      # verify = false

      # Whether an AWS Payment Cryptography key can be used to wrap other keys
      # Type: bool
      # Default: false
      wrap = true
    }
  }

  #------------------------------------------------------------------------------
  # Optional Arguments
  #------------------------------------------------------------------------------

  # Whether to enable the key
  # Type: bool
  # Default: true
  # When set to false, the key cannot be used for cryptographic operations
  # enabled = true

  # Algorithm that AWS Payment Cryptography uses to calculate the key check
  # value (KCV)
  # Type: string
  # Valid values:
  # - CMAC: Cipher-based Message Authentication Code
  # - ANSI_X9_24: ANSI X9.24 standard
  # KCV is used to verify key integrity during key exchange
  # key_check_value_algorithm = "CMAC"

  # Region where this resource will be managed
  # Type: string
  # Defaults to the Region set in the provider configuration
  # AWS Payment Cryptography is available in limited regions
  # region = "us-east-1"

  # Map of tags assigned to the resource
  # Type: map(string)
  # Tags are propagated to the key and can be used for cost allocation,
  # access control, and resource organization
  # If configured with a provider default_tags configuration block,
  # tags with matching keys will overwrite those defined at the provider-level
  tags = {
    Name        = "example-payment-key"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

################################################################################
# Outputs
################################################################################

output "paymentcryptography_key_arn" {
  description = "ARN of the Payment Cryptography key"
  value       = aws_paymentcryptography_key.example.arn
}

output "paymentcryptography_key_check_value" {
  description = "Key check value (KCV) used to verify key integrity"
  value       = aws_paymentcryptography_key.example.key_check_value
  sensitive   = true
}

output "paymentcryptography_key_origin" {
  description = "Source of the key material (e.g., AWS_PAYMENT_CRYPTOGRAPHY)"
  value       = aws_paymentcryptography_key.example.key_origin
}

output "paymentcryptography_key_state" {
  description = "Current state of the key (e.g., CREATE_COMPLETE, DELETED)"
  value       = aws_paymentcryptography_key.example.key_state
}

output "paymentcryptography_key_tags_all" {
  description = "Map of all tags assigned to the key including inherited tags"
  value       = aws_paymentcryptography_key.example.tags_all
}
