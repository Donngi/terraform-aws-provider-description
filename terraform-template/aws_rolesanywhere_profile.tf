################################################################################
# AWS IAM Roles Anywhere Profile
################################################################################
# Terraform resource for managing a Roles Anywhere Profile.
#
# AWS IAM Roles Anywhere allows workloads outside of AWS to obtain temporary
# AWS credentials by using X.509 certificates. A profile defines the mapping
# between a certificate and IAM roles, along with session configurations.
#
# Reference:
# - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/rolesanywhere_profile
# - https://docs.aws.amazon.com/rolesanywhere/latest/userguide/introduction.html
################################################################################

resource "aws_rolesanywhere_profile" "example" {
  ################################################################################
  # Required Parameters
  ################################################################################

  # The name of the Profile
  # - Must be unique within your AWS account
  # - Used to identify the profile when creating sessions
  # Type: string
  # Required: Yes
  name = "example-profile"

  ################################################################################
  # Optional Parameters - IAM Role Configuration
  ################################################################################

  # A list of IAM roles that this profile can assume
  # - These roles must have a trust policy that allows rolesanywhere.amazonaws.com
  # - The trust policy should include actions like sts:AssumeRole, sts:TagSession, sts:SetSourceIdentity
  # - Multiple roles can be specified for different access levels
  # Type: set(string)
  # Required: No
  role_arns = [
    # "arn:aws:iam::123456789012:role/RolesAnywhereRole"
  ]

  # A list of managed policy ARNs that apply to the vended session credentials
  # - These policies are attached to the session in addition to role policies
  # - Useful for applying common security policies across profiles
  # - Can reference both AWS managed and customer managed policies
  # Type: set(string)
  # Required: No
  managed_policy_arns = [
    # "arn:aws:iam::aws:policy/ReadOnlyAccess",
    # "arn:aws:iam::123456789012:policy/CustomPolicy"
  ]

  ################################################################################
  # Optional Parameters - Session Configuration
  ################################################################################

  # The number of seconds the vended session credentials are valid for
  # - Valid range: 900 (15 minutes) to 43200 (12 hours)
  # - Shorter durations improve security by limiting credential lifetime
  # - Longer durations reduce the frequency of credential rotation
  # Type: number
  # Default: 3600 (1 hour)
  # Required: No
  duration_seconds = 3600

  # A session policy that applies to the trust boundary of the vended session credentials
  # - Must be a valid JSON policy document
  # - Further restricts the permissions beyond what the role allows
  # - Useful for applying additional constraints based on request context
  # - Maximum size: 2048 characters
  # Type: string (JSON)
  # Required: No
  session_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = "*"
      }
    ]
  })

  # Whether or not a custom role session name is accepted
  # - When true, allows clients to specify a custom session name
  # - When false, a default session name is generated
  # - Custom session names appear in CloudTrail logs for better auditing
  # Type: bool
  # Required: No
  accept_role_session_name = false

  ################################################################################
  # Optional Parameters - Profile Settings
  ################################################################################

  # Whether or not the Profile is enabled
  # - When false, sessions cannot be created using this profile
  # - Useful for temporarily disabling access without deleting the profile
  # - Does not affect existing sessions
  # Type: bool
  # Required: No
  enabled = true

  # Specifies whether instance properties are required in CreateSession requests
  # - When true, requires EC2 instance metadata in session creation
  # - Used to validate that requests come from specific EC2 instances
  # - Enhances security by binding sessions to specific compute resources
  # Reference: https://docs.aws.amazon.com/rolesanywhere/latest/APIReference/API_CreateSession.html
  # Type: bool
  # Required: No
  require_instance_properties = false

  ################################################################################
  # Optional Parameters - Tagging
  ################################################################################

  # A map of tags to assign to the resource
  # - Tags are propagated to CloudTrail events for better tracking
  # - Maximum of 50 tags per resource
  # - Tag keys and values are case-sensitive
  # - If configured with a provider default_tags configuration block,
  #   tags with matching keys will overwrite those defined at the provider-level
  # Type: map(string)
  # Required: No
  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
    Purpose     = "external-workload-authentication"
    # CostCenter  = "engineering"
    # Application = "data-processing"
  }

  ################################################################################
  # Computed Attributes (Read-Only)
  ################################################################################
  # The following attributes are computed by AWS and cannot be set:
  #
  # - arn (string)
  #   Amazon Resource Name (ARN) of the Profile
  #   Format: arn:aws:rolesanywhere:region:account-id:profile/profile-id
  #
  # - id (string)
  #   The Profile ID (UUID format)
  #
  # - tags_all (map(string))
  #   A map of tags assigned to the resource, including those inherited from
  #   the provider default_tags configuration block
  ################################################################################
}

################################################################################
# Example: Complete Profile Configuration
################################################################################

# Example IAM role with proper trust policy for Roles Anywhere
resource "aws_iam_role" "rolesanywhere_example" {
  name = "rolesanywhere-example-role"
  path = "/"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = [
        "sts:AssumeRole",
        "sts:TagSession",
        "sts:SetSourceIdentity"
      ]
      Principal = {
        Service = "rolesanywhere.amazonaws.com"
      }
      Effect = "Allow"
      Sid    = ""
    }]
  })

  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

# Attach a policy to the role
resource "aws_iam_role_policy_attachment" "rolesanywhere_example" {
  role       = aws_iam_role.rolesanywhere_example.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

# Complete profile example with all common configurations
resource "aws_rolesanywhere_profile" "complete_example" {
  name                         = "complete-rolesanywhere-profile"
  role_arns                    = [aws_iam_role.rolesanywhere_example.arn]
  duration_seconds             = 7200 # 2 hours
  enabled                      = true
  accept_role_session_name     = true
  require_instance_properties  = false

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/ReadOnlyAccess"
  ]

  session_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = "*"
      }
    ]
  })

  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
    Purpose     = "external-workload-authentication"
    Team        = "platform"
  }
}

################################################################################
# Outputs
################################################################################

output "profile_arn" {
  description = "The ARN of the Roles Anywhere profile"
  value       = aws_rolesanywhere_profile.example.arn
}

output "profile_id" {
  description = "The ID of the Roles Anywhere profile"
  value       = aws_rolesanywhere_profile.example.id
}

output "complete_profile_arn" {
  description = "The ARN of the complete Roles Anywhere profile"
  value       = aws_rolesanywhere_profile.complete_example.arn
}

################################################################################
# Important Notes
################################################################################
# 1. Trust Policy Requirements:
#    - IAM roles used with Roles Anywhere MUST have a trust policy that allows
#      rolesanywhere.amazonaws.com as the principal
#    - Include sts:AssumeRole, sts:TagSession, and sts:SetSourceIdentity actions
#
# 2. Certificate Management:
#    - Profiles work with Trust Anchors (aws_rolesanywhere_trust_anchor)
#    - Workloads must present valid X.509 certificates for authentication
#    - Certificates must chain to a Trust Anchor configured in your account
#
# 3. Session Duration:
#    - Minimum: 900 seconds (15 minutes)
#    - Maximum: 43200 seconds (12 hours)
#    - Consider security vs. convenience when setting duration
#
# 4. Session Policies:
#    - Session policies can only restrict permissions, not grant new ones
#    - They are evaluated in addition to the role's policies
#    - Maximum size is 2048 characters
#
# 5. Security Best Practices:
#    - Use the principle of least privilege for role permissions
#    - Set appropriate session durations based on use case
#    - Enable CloudTrail to monitor session creation and usage
#    - Use session policies to add request-specific constraints
#    - Regularly rotate certificates used for authentication
#
# 6. Monitoring and Auditing:
#    - Session creation events appear in CloudTrail
#    - Custom session names improve log readability
#    - Use tags for cost allocation and resource tracking
#
# 7. Multi-Region Considerations:
#    - Profiles are regional resources
#    - Create profiles in each region where they are needed
#    - Trust Anchors must also exist in the same region
#
# 8. Integration Requirements:
#    - Requires aws_rolesanywhere_trust_anchor for certificate validation
#    - Requires properly configured IAM roles with trust policies
#    - Client applications must use AWS credentials helper or SDK support
################################################################################
