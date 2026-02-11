################################################################################
# AWS Shield Proactive Engagement
# Provider Version: 6.28.0
################################################################################

# Terraform resource for managing AWS Shield Proactive Engagement
#
# Proactive engagement authorizes the Shield Response Team (SRT) to use email
# and phone to notify contacts about escalations to the SRT and to initiate
# proactive customer support.
#
# Prerequisites:
# - AWS Shield Advanced subscription
# - Business Support or Enterprise Support plan
# - AWS Shield DRT access role configured (aws_shield_drt_access_role_arn_association)
# - Amazon Route 53 health check associated with protected resources
# - AWS WAF (v2) for resources with AWS WAF web ACLs
#
# Important Notes:
# - Proactive engagement allows the SRT to contact you directly when your
#   application's availability or performance is affected due to a possible attack
# - Available for network-layer and transport-layer events on Elastic IP addresses
#   and AWS Global Accelerators
# - Available for web request floods on Amazon CloudFront distributions and
#   Application Load Balancers
# - You can configure up to ten emergency contacts
# - At least one phone number must be provided in the emergency contact list

resource "aws_shield_proactive_engagement" "example" {
  # Boolean value indicating if Proactive Engagement should be enabled or not
  # Required: Yes
  # Type: bool
  #
  # When enabled, the SRT can proactively contact you during detected events
  # When disabled, you maintain control over when to engage with the SRT
  enabled = true

  # Emergency contact information for the Shield Response Team (SRT)
  # Required: Yes (at least one contact required)
  # Maximum: 10 contacts
  #
  # These contacts will be used by the SRT for escalations and proactive
  # customer support. At least one phone number must be provided across
  # all emergency contacts.
  emergency_contact {
    # Valid email address that will be used for this contact
    # Required: Yes
    # Type: string
    # Length: 1-150 characters
    # Format: Valid email address
    #
    # The SRT will use this email for notifications and escalations
    email_address = "contact1@example.com"

    # Phone number for this contact
    # Required: No (but at least one phone number required across all contacts)
    # Type: string
    # Length: 1-16 characters
    # Format: Starting with '+' followed by country code and number
    # Example: "+12358132134" for US number
    #
    # Used by the SRT for urgent escalations and real-time communication
    phone_number = "+12358132134"

    # Additional notes regarding the contact
    # Required: No
    # Type: string
    # Length: 1-1024 characters
    #
    # Use this field to provide context about:
    # - Hours of availability for this contact
    # - Specific responsibilities or expertise
    # - Alternative contact methods
    # - Time zone information
    # - Any special instructions for reaching this contact
    contact_notes = "Primary on-call contact - Available 24/7 - Escalate for critical DDoS events"
  }

  # Additional emergency contact (example of multiple contacts)
  emergency_contact {
    email_address = "contact2@example.com"
    phone_number  = "+12358132135"
    contact_notes = "Secondary contact - Available business hours (9 AM - 5 PM EST) - Network security team lead"
  }

  # Ensure that DRT access role association is configured before enabling
  # proactive engagement. The SRT requires appropriate permissions to access
  # your AWS resources for analysis and mitigation.
  depends_on = [aws_shield_drt_access_role_arn_association.example]
}

################################################################################
# Required Supporting Resources
################################################################################

# IAM role for AWS Shield DRT (DDoS Response Team) access
# This role allows the Shield Response Team to access your AWS resources
# for analysis and mitigation during DDoS events
resource "aws_iam_role" "example" {
  name = "shield-drt-access-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = ""
        Effect = "Allow"
        Principal = {
          Service = "drt.shield.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name        = "Shield DRT Access Role"
    Purpose     = "AWS Shield Proactive Engagement"
    ManagedBy   = "Terraform"
    Environment = "production"
  }
}

# Attach AWS managed policy for Shield DRT access
# This policy grants the necessary permissions for the DRT to assist with
# DDoS mitigation activities
resource "aws_iam_role_policy_attachment" "example" {
  role       = aws_iam_role.example.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSShieldDRTAccessPolicy"
}

# Associate the IAM role with Shield DRT access
# This is a prerequisite for enabling proactive engagement
resource "aws_shield_drt_access_role_arn_association" "example" {
  role_arn = aws_iam_role.example.arn
}

# Example protection group (optional but recommended)
# Protection groups provide logical grouping of protected resources
# for enhanced detection and mitigation
resource "aws_shield_protection_group" "example" {
  protection_group_id = "example-protection-group"

  # Aggregation method for the group
  # Valid values: SUM, MEAN, MAX
  aggregation = "MAX"

  # Pattern for including resources in the group
  # Valid values: ALL, ARBITRARY, BY_RESOURCE_TYPE
  pattern = "ALL"

  tags = {
    Name        = "Example Protection Group"
    ManagedBy   = "Terraform"
    Environment = "production"
  }
}

################################################################################
# Important Considerations
################################################################################

# 1. Cost Implications:
#    - Shield Advanced is a subscription service with monthly costs
#    - Data transfer costs may apply
#    - Consider cost protection features available with Shield Advanced
#
# 2. Support Requirements:
#    - Business Support or Enterprise Support plan required
#    - Ensure your support plan is active before enabling
#
# 3. Health Checks:
#    - Associate Route 53 health checks with protected resources
#    - Health-based detection prevents false positives
#    - Provides faster detection and mitigation
#
# 4. Contact Management:
#    - Keep contact information up to date
#    - Test contact methods regularly
#    - Document escalation procedures
#    - Consider time zone coverage for 24/7 availability
#
# 5. AWS WAF Integration:
#    - Use AWS WAF v2 for web application protection
#    - Shield Advanced covers standard AWS WAF costs for protected resources
#    - Custom rules and managed rule groups can be used
#
# 6. Resource Coverage:
#    - Protect Elastic IP addresses (EC2, Network Load Balancers)
#    - Protect AWS Global Accelerator accelerators
#    - Protect Amazon CloudFront distributions
#    - Protect Application Load Balancers
#    - Protect Amazon Route 53 hosted zones
#
# 7. Proactive Engagement Scope:
#    - Network-layer and transport-layer events on EIPs and Global Accelerators
#    - Web request floods on CloudFront and ALBs
#    - Requires Route 53 health check association
#
# 8. After Initialization:
#    - Use DisableProactiveEngagement to temporarily disable without removing contacts
#    - Use EnableProactiveEngagement to re-enable
#    - Update emergency contacts as needed using UpdateEmergencyContactSettings
#
# 9. Response Time:
#    - Proactive engagement provides the quickest SRT response
#    - Enables troubleshooting before contact is established
#    - Critical for minimizing downtime during DDoS attacks
#
# 10. Monitoring and Visibility:
#     - Use CloudWatch metrics for DDoS event monitoring
#     - Review Shield Advanced reports regularly
#     - Configure CloudWatch alarms for critical events

################################################################################
# Outputs
################################################################################

# Output the proactive engagement enabled status
output "shield_proactive_engagement_enabled" {
  description = "Whether Shield proactive engagement is enabled"
  value       = aws_shield_proactive_engagement.example.enabled
}

# Output the emergency contact emails for reference
output "shield_emergency_contacts" {
  description = "List of emergency contact email addresses"
  value       = [for contact in aws_shield_proactive_engagement.example.emergency_contact : contact.email_address]
}

# Output the DRT role ARN
output "shield_drt_role_arn" {
  description = "ARN of the IAM role used for Shield DRT access"
  value       = aws_iam_role.example.arn
}
