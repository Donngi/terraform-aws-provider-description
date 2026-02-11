#
# Terraform AWS Resource Template: aws_cognito_identity_provider
#
# Generated: 2026-01-19
# Provider Version: 6.28.0
#
# Note: This template represents the resource schema as of the generation date.
# Always refer to the official documentation for the latest specifications:
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_identity_provider
#

# aws_cognito_identity_provider
# Provides a Cognito User Pool Identity Provider resource. This resource allows you to configure
# third-party identity providers (IdPs) for your Cognito User Pool, enabling federated sign-in
# through social providers (Facebook, Google, Amazon, Apple) or enterprise providers (SAML, OIDC).
#
# AWS Documentation:
# - Identity Provider Configuration: https://docs.aws.amazon.com/cognito/latest/developerguide/cognito-user-pools-identity-provider.html
# - API Reference: https://docs.aws.amazon.com/cognito-user-identity-pools/latest/APIReference/API_CreateIdentityProvider.html
# - Identity Federation: https://docs.aws.amazon.com/cognito/latest/developerguide/cognito-user-pools-identity-federation.html
resource "aws_cognito_identity_provider" "example" {
  # ============================================================================
  # Required Arguments
  # ============================================================================

  # user_pool_id (required)
  # Type: string
  # The ID of the user pool to associate this identity provider with.
  # Must be in the format: [region]_[alphanumeric string]
  # Example: "us-east-1_abc123DEF"
  user_pool_id = "us-east-1_abc123DEF"

  # provider_name (required)
  # Type: string
  # A friendly name for the IdP. This name will be displayed in the hosted UI
  # and used to identify the IdP in your user pool.
  # Length: 1-32 characters
  # Pattern: [\p{L}\p{M}\p{S}\p{N}\p{P}\p{Z}]+
  # Example: "Google", "Facebook", "MyCompanySAML"
  provider_name = "Google"

  # provider_type (required)
  # Type: string
  # The type of identity provider.
  # Valid values: "SAML" | "Facebook" | "Google" | "LoginWithAmazon" | "SignInWithApple" | "OIDC"
  #
  # - SAML: For enterprise SAML 2.0 identity providers
  # - Facebook: For Facebook Login integration
  # - Google: For Google Sign-In integration
  # - LoginWithAmazon: For Login with Amazon integration
  # - SignInWithApple: For Sign in with Apple integration
  # - OIDC: For OpenID Connect providers (e.g., Salesforce, Ping Identity)
  provider_type = "Google"

  # provider_details (required)
  # Type: map(string)
  # The scopes, URLs, and identifiers for your external identity provider.
  # The required keys vary by provider type:
  #
  # For Google:
  #   - client_id (required): Your Google OAuth 2.0 client ID
  #   - client_secret (required): Your Google OAuth 2.0 client secret
  #   - authorize_scopes (required): Space-separated list of OAuth scopes
  #     Example: "email profile openid"
  #
  # For Facebook:
  #   - client_id (required): Your Facebook App ID
  #   - client_secret (required): Your Facebook App Secret
  #   - authorize_scopes (required): Comma-separated list of Facebook permissions
  #     Example: "public_profile, email"
  #   - api_version (optional): Facebook Graph API version (e.g., "v17.0")
  #
  # For LoginWithAmazon:
  #   - client_id (required): Your Amazon client ID
  #   - client_secret (required): Your Amazon client secret
  #   - authorize_scopes (required): Space-separated list of scopes
  #     Example: "profile postal_code"
  #
  # For SignInWithApple:
  #   - client_id (required): Your Apple service ID (e.g., "com.example.cognito")
  #   - team_id (required): Your Apple team ID
  #   - key_id (required): Your Apple key ID
  #   - private_key (required): Your Apple private key
  #   - authorize_scopes (required): Space-separated list of scopes
  #     Example: "email name"
  #
  # For OIDC:
  #   - client_id (required): Your OIDC client ID
  #   - client_secret (required): Your OIDC client secret
  #   - authorize_scopes (required): Space-separated OAuth scopes
  #     Example: "openid profile email"
  #   - oidc_issuer (optional): The OIDC issuer URL (used for auto-discovery)
  #     Example: "https://accounts.google.com"
  #   - attributes_request_method (optional): HTTP method for userInfo endpoint ("GET" or "POST")
  #   - attributes_url (optional): URL of the userInfo endpoint
  #   - authorize_url (optional): URL of the authorization endpoint
  #   - token_url (optional): URL of the token endpoint
  #   - jwks_uri (optional): URL of the JSON Web Key Set endpoint
  #
  # For SAML:
  #   - MetadataURL (optional): HTTPS URL to the IdP metadata document
  #   - MetadataFile (optional): Metadata XML document (if not using MetadataURL)
  #   - IDPSignout (optional): Enable IdP-initiated sign-out ("true" or "false")
  #   - IDPInit (optional): Enable IdP-initiated sign-in ("true" or "false")
  #   - EncryptedResponses (optional): Enable encrypted SAML responses ("true" or "false")
  #   - RequestSigningAlgorithm (optional): Signing algorithm (e.g., "rsa-sha256")
  #
  # AWS Documentation:
  # - Provider Details by Type: https://docs.aws.amazon.com/cognito-user-identity-pools/latest/APIReference/API_IdentityProviderType.html
  provider_details = {
    client_id        = "1example23456789.apps.googleusercontent.com"
    client_secret    = "provider-app-client-secret"
    authorize_scopes = "email profile openid"
  }

  # ============================================================================
  # Optional Arguments
  # ============================================================================

  # attribute_mapping (optional)
  # Type: map(string)
  # A mapping of IdP attributes to standard and custom user pool attributes.
  # This determines which user attributes from the IdP are mapped to your user pool's schema.
  #
  # Common mappings:
  # - email: Maps the IdP's email to the user pool's email attribute
  # - username: Maps the IdP's unique identifier to the username
  # - name: Maps the IdP's name to the user pool's name attribute
  # - given_name: Maps the IdP's first name
  # - family_name: Maps the IdP's last name
  # - picture: Maps the IdP's profile picture URL
  #
  # For OIDC/Social providers, use standard claim names (e.g., "email", "sub").
  # For SAML providers, use the exact attribute names from your SAML assertion.
  #
  # Note: The "sub" claim from the IdP is automatically mapped to the "Username"
  # attribute in your user pool by default.
  #
  # Key length: 1-32 characters
  # Value length: 0-131072 characters
  #
  # AWS Documentation:
  # - Attribute Mapping: https://docs.aws.amazon.com/cognito/latest/developerguide/cognito-user-pools-specifying-attribute-mapping.html
  attribute_mapping = {
    email    = "email"
    username = "sub"
    name     = "name"
  }

  # idp_identifiers (optional)
  # Type: list(string)
  # A list of IdP identifiers that can be used to route user authorization requests
  # to the right IdP. These identifiers are typically domain names or friendly names.
  #
  # When a user enters their email address during sign-in, Cognito can automatically
  # route them to the appropriate IdP based on the email domain matching an identifier.
  #
  # Example use case: If you add "example.com" as an IdP identifier, when a user
  # enters "user@example.com" at sign-in, they will be automatically routed to this IdP.
  #
  # Array size: 0-50 items
  # Item length: 1-40 characters
  # Pattern: [\w\s+=.@-]+
  #
  # AWS Documentation:
  # - Authorization Endpoint Parameters: https://docs.aws.amazon.com/cognito/latest/developerguide/authorization-endpoint.html#get-authorize-request-parameters
  idp_identifiers = [
    "example.com",
    "MyIdP",
  ]

  # region (optional)
  # Type: string
  # The AWS region where this identity provider will be managed.
  # If not specified, defaults to the region set in the provider configuration.
  #
  # This is useful for multi-region deployments where you want to explicitly
  # specify the region for this resource.
  #
  # AWS Documentation:
  # - Regional Endpoints: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  # ============================================================================
  # Note: Computed-Only Attributes (Not User-Configurable)
  # ============================================================================
  #
  # The following attributes are computed by AWS and cannot be set by users:
  # - id: The unique identifier for the identity provider (format: user_pool_id:provider_name)
  #
  # These attributes are managed by AWS and will be populated after resource creation.
}

# ============================================================================
# Example Configurations by Provider Type
# ============================================================================

# Example: Facebook Identity Provider
resource "aws_cognito_identity_provider" "facebook" {
  user_pool_id  = aws_cognito_user_pool.main.id
  provider_name = "Facebook"
  provider_type = "Facebook"

  provider_details = {
    client_id        = "your-facebook-app-id"
    client_secret    = "your-facebook-app-secret"
    authorize_scopes = "public_profile, email"
    api_version      = "v17.0"
  }

  attribute_mapping = {
    email    = "email"
    username = "id"
    name     = "name"
  }
}

# Example: SAML Identity Provider
resource "aws_cognito_identity_provider" "saml" {
  user_pool_id  = aws_cognito_user_pool.main.id
  provider_name = "MyCompanySAML"
  provider_type = "SAML"

  provider_details = {
    MetadataURL              = "https://auth.example.com/sso/saml/metadata"
    IDPSignout               = "true"
    IDPInit                  = "true"
    EncryptedResponses       = "true"
    RequestSigningAlgorithm  = "rsa-sha256"
  }

  attribute_mapping = {
    email    = "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress"
    username = "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name"
  }

  idp_identifiers = ["example.com"]
}

# Example: Custom OIDC Identity Provider (e.g., Salesforce)
resource "aws_cognito_identity_provider" "oidc" {
  user_pool_id  = aws_cognito_user_pool.main.id
  provider_name = "Salesforce"
  provider_type = "OIDC"

  provider_details = {
    client_id                   = "your-oidc-client-id"
    client_secret               = "your-oidc-client-secret"
    authorize_scopes            = "openid profile email"
    oidc_issuer                 = "https://login.salesforce.com"
    attributes_request_method   = "GET"
  }

  attribute_mapping = {
    email    = "email"
    username = "sub"
    name     = "name"
  }
}

# Example: Sign in with Apple
resource "aws_cognito_identity_provider" "apple" {
  user_pool_id  = aws_cognito_user_pool.main.id
  provider_name = "SignInWithApple"
  provider_type = "SignInWithApple"

  provider_details = {
    client_id        = "com.example.cognito"
    team_id          = "YOUR_TEAM_ID"
    key_id           = "YOUR_KEY_ID"
    private_key      = "-----BEGIN PRIVATE KEY-----\n...\n-----END PRIVATE KEY-----"
    authorize_scopes = "email name"
  }

  attribute_mapping = {
    email    = "email"
    username = "sub"
    name     = "name"
  }
}

# ============================================================================
# Additional Notes
# ============================================================================
#
# 1. Before configuring an identity provider in Cognito, you must:
#    - Create a developer account with the identity provider
#    - Register your application with the provider
#    - Obtain the necessary credentials (client ID, secret, certificates, etc.)
#
# 2. After creating the identity provider, you must:
#    - Add it to one or more app clients in your user pool
#    - Configure the hosted UI or implement custom authentication flows
#    - Test the authentication flow end-to-end
#
# 3. Social provider setup guides:
#    - Google: https://developers.google.com/identity/
#    - Facebook: https://developers.facebook.com/docs/facebook-login
#    - Amazon: https://developer.amazon.com/login-with-amazon
#    - Apple: https://developer.apple.com/sign-in-with-apple/
#
# 4. For SAML providers:
#    - Use MetadataURL when possible for automatic metadata refresh
#    - Cognito refreshes metadata every 6 hours or before expiration
#    - Ensure your SAML IdP trusts Cognito's service provider metadata
#
# 5. For OIDC providers:
#    - Use oidc_issuer for automatic endpoint discovery via .well-known/openid-configuration
#    - Only ports 443 and 80 are supported for OIDC endpoints
#    - All URLs must use HTTPS
#
# 6. Security best practices:
#    - Store client secrets in AWS Secrets Manager or Parameter Store
#    - Use Terraform sensitive variables for credentials
#    - Regularly rotate client secrets and certificates
#    - Enable MFA for administrative access to your IdP accounts
#
# 7. The identity provider can be referenced in Cognito hosted UI via the
#    identity_providers parameter in the authorize endpoint:
#    https://your-domain.auth.region.amazoncognito.com/oauth2/authorize?identity_provider=Google
#
# 8. Users authenticated through an IdP will have an "identities" attribute
#    in their user profile containing the provider name and unique ID.
