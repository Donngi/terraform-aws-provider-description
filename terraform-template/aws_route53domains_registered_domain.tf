################################################################################
# AWS Route 53 Domains Registered Domain
################################################################################
# Terraform Resource: aws_route53domains_registered_domain
# Provider Version: 6.28.0
#
# IMPORTANT: This is an advanced resource with special behavior:
# - Does NOT register new domains - only adopts existing registered domains into Terraform management
# - terraform destroy does NOT delete the domain - only removes it from state
# - To register/renew/deregister domains, use aws_route53domains_domain instead
#
# Use Case:
# - Manage an existing registered domain's settings (name servers, contacts, privacy)
# - Update auto-renewal settings for registered domains
# - Configure transfer lock and WHOIS privacy settings
#
# Documentation: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53domains_registered_domain
################################################################################

resource "aws_route53domains_registered_domain" "example" {
  ################################################################################
  # Required Arguments
  ################################################################################

  # (Required) The name of the registered domain
  # This domain must already be registered and associated with the AWS account
  # Example: "example.com", "my-company.org"
  domain_name = "example.com"

  ################################################################################
  # Name Servers Configuration
  ################################################################################

  # (Optional) List of nameservers for the domain
  # Each name_server block defines a single nameserver
  # At least 2 name servers are typically required for domain delegation
  name_server {
    # (Required) Fully qualified hostname of the name server
    # Example: "ns-195.awsdns-24.com"
    name = "ns-195.awsdns-24.com"

    # (Optional) Glue IP addresses for the name server
    # Required only when using custom name servers within the domain itself
    # Can contain one IPv4 and one IPv6 address
    # glue_ips = ["192.0.2.1", "2001:db8::1"]
  }

  name_server {
    name = "ns-874.awsdns-45.net"
  }

  # Additional name servers can be added as needed
  # name_server {
  #   name = "ns-1234.awsdns-56.org"
  # }

  ################################################################################
  # Domain Settings
  ################################################################################

  # (Optional) Whether the domain registration is set to renew automatically
  # Default: true
  # Setting to false requires manual renewal before expiration
  auto_renew = true

  # (Optional) Whether the domain is locked for transfer
  # Default: true
  # Prevents unauthorized domain transfers to other registrars
  # Must be disabled before transferring the domain
  transfer_lock = true

  ################################################################################
  # WHOIS Privacy Settings
  ################################################################################

  # (Optional) Whether admin contact information is concealed from WHOIS queries
  # Default: true
  # IMPORTANT: admin_privacy, registrant_privacy, and tech_privacy must have the same value
  admin_privacy = true

  # (Optional) Whether registrant contact information is concealed from WHOIS queries
  # Default: true
  registrant_privacy = true

  # (Optional) Whether technical contact information is concealed from WHOIS queries
  # Default: true
  tech_privacy = true

  # (Optional) Whether billing contact information is concealed from WHOIS queries
  # Default: true
  billing_privacy = true

  ################################################################################
  # Contact Information - Admin Contact
  ################################################################################

  # (Optional) Details about the domain administrative contact
  # The admin contact handles administrative issues and domain renewals
  admin_contact {
    # (Optional) First name of the contact
    first_name = "John"

    # (Optional) Last name of the contact
    last_name = "Doe"

    # (Optional) Contact type indicator
    # Valid values: PERSON, COMPANY, ASSOCIATION, PUBLIC_BODY, RESELLER
    # See: https://docs.aws.amazon.com/Route53/latest/APIReference/API_domains_ContactDetail.html#Route53Domains-Type-domains_ContactDetail-ContactType
    contact_type = "PERSON"

    # (Optional) Organization name (required for non-PERSON contact types)
    # organization_name = "Example Corp"

    # (Optional) Email address of the contact
    email = "admin@example.com"

    # (Optional) Phone number in format "+[country code].[number with area code]"
    # Example: "+1.5555551234" for US number
    phone_number = "+1.5555551234"

    # (Optional) Fax number in same format as phone_number
    # fax = "+1.5555551235"

    # (Optional) First line of the contact's address
    address_line_1 = "123 Main St"

    # (Optional) Second line of the contact's address
    # address_line_2 = "Suite 100"

    # (Optional) City of the contact's address
    city = "Seattle"

    # (Optional) State or province of the contact's city
    state = "WA"

    # (Optional) Country code (ISO 3166-1 alpha-2)
    # See: https://docs.aws.amazon.com/Route53/latest/APIReference/API_domains_ContactDetail.html#Route53Domains-Type-domains_ContactDetail-CountryCode
    country_code = "US"

    # (Optional) Zip or postal code of the contact's address
    zip_code = "98101"

    # (Optional) Key-value map of extra parameters required by certain TLDs
    # Some country-code TLDs (.uk, .au, etc.) require additional information
    # extra_params = {
    #   "UK_CONTACT_TYPE" = "IND"
    #   "UK_COMPANY_NUMBER" = "12345678"
    # }
  }

  ################################################################################
  # Contact Information - Registrant Contact
  ################################################################################

  # (Optional) Details about the domain registrant
  # The registrant is the legal owner of the domain
  # If not specified, inherits from admin_contact
  registrant_contact {
    first_name      = "John"
    last_name       = "Doe"
    contact_type    = "PERSON"
    email           = "registrant@example.com"
    phone_number    = "+1.5555551234"
    address_line_1  = "123 Main St"
    city            = "Seattle"
    state           = "WA"
    country_code    = "US"
    zip_code        = "98101"
  }

  ################################################################################
  # Contact Information - Technical Contact
  ################################################################################

  # (Optional) Details about the domain technical contact
  # The tech contact handles technical issues related to the domain
  # If not specified, inherits from admin_contact
  tech_contact {
    first_name      = "Jane"
    last_name       = "Smith"
    contact_type    = "PERSON"
    email           = "tech@example.com"
    phone_number    = "+1.5555555678"
    address_line_1  = "456 Tech Ave"
    city            = "Seattle"
    state           = "WA"
    country_code    = "US"
    zip_code        = "98102"
  }

  ################################################################################
  # Contact Information - Billing Contact
  ################################################################################

  # (Optional) Details about the domain billing contact
  # The billing contact receives invoices and billing notifications
  # If not specified, inherits from admin_contact
  billing_contact {
    first_name      = "Finance"
    last_name       = "Department"
    contact_type    = "COMPANY"
    organization_name = "Example Corp"
    email           = "billing@example.com"
    phone_number    = "+1.5555559999"
    address_line_1  = "789 Finance Blvd"
    city            = "Seattle"
    state           = "WA"
    country_code    = "US"
    zip_code        = "98103"
  }

  ################################################################################
  # Tagging
  ################################################################################

  # (Optional) Map of tags to assign to the resource
  # Tags are propagated to the domain registration
  # If configured with provider default_tags, matching keys will be overwritten
  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
    Department  = "engineering"
  }
}

################################################################################
# Outputs
################################################################################

# Computed attributes available after resource creation/adoption:

# output "domain_id" {
#   description = "The domain name (same as domain_name)"
#   value       = aws_route53domains_registered_domain.example.id
# }

# output "domain_abuse_contact_email" {
#   description = "Email address for reporting domain abuse"
#   value       = aws_route53domains_registered_domain.example.abuse_contact_email
# }

# output "domain_abuse_contact_phone" {
#   description = "Phone number for reporting abuse"
#   value       = aws_route53domains_registered_domain.example.abuse_contact_phone
# }

# output "domain_creation_date" {
#   description = "Date when the domain was created (from WHOIS)"
#   value       = aws_route53domains_registered_domain.example.creation_date
# }

# output "domain_expiration_date" {
#   description = "Date when the domain registration expires"
#   value       = aws_route53domains_registered_domain.example.expiration_date
# }

# output "domain_updated_date" {
#   description = "Last updated date of the domain (from WHOIS)"
#   value       = aws_route53domains_registered_domain.example.updated_date
# }

# output "domain_registrar_name" {
#   description = "Name of the domain registrar"
#   value       = aws_route53domains_registered_domain.example.registrar_name
# }

# output "domain_registrar_url" {
#   description = "Web address of the registrar"
#   value       = aws_route53domains_registered_domain.example.registrar_url
# }

# output "domain_reseller" {
#   description = "Reseller of the domain (if applicable)"
#   value       = aws_route53domains_registered_domain.example.reseller
# }

# output "domain_status_list" {
#   description = "List of domain name status codes (EPP status codes)"
#   value       = aws_route53domains_registered_domain.example.status_list
#   # Common status codes:
#   # - clientTransferProhibited: Transfer lock is enabled
#   # - serverUpdateProhibited: Registry prevents updates
#   # - serverDeleteProhibited: Registry prevents deletion
#   # See: https://www.icann.org/resources/pages/epp-status-codes-2014-06-16-en
# }

# output "domain_whois_server" {
#   description = "WHOIS server that can answer queries for the domain"
#   value       = aws_route53domains_registered_domain.example.whois_server
# }

# output "domain_tags_all" {
#   description = "Map of all tags including provider default_tags"
#   value       = aws_route53domains_registered_domain.example.tags_all
# }

################################################################################
# Usage Notes
################################################################################

# 1. Domain Adoption vs Registration:
#    - This resource ADOPTS existing registered domains
#    - It does NOT register new domains
#    - Use aws_route53domains_domain for registration/renewal/deletion

# 2. Destroy Behavior:
#    - terraform destroy removes the resource from state
#    - The domain itself is NOT deleted or deregistered
#    - The domain remains registered and continues to function

# 3. Privacy Settings Constraint:
#    - admin_privacy, registrant_privacy, and tech_privacy must match
#    - All three must be either true or false
#    - billing_privacy can be set independently

# 4. Contact Information:
#    - At minimum, admin_contact should be specified
#    - Other contacts default to admin_contact if not provided
#    - Contact information must be valid and verifiable

# 5. Name Servers:
#    - Must specify valid, operational name servers
#    - Typically need at least 2 name servers
#    - Use Route 53 name servers for Route 53 hosted zones
#    - Glue records only needed for vanity name servers

# 6. Auto-Renewal:
#    - Enabled by default (auto_renew = true)
#    - Disabling requires manual renewal monitoring
#    - Domain will expire if not renewed before expiration_date

# 7. Transfer Lock:
#    - Enabled by default (transfer_lock = true)
#    - Must be disabled before transferring to another registrar
#    - Prevents unauthorized transfers

# 8. TLD-Specific Requirements:
#    - Some TLDs require extra_params in contact blocks
#    - Check AWS documentation for TLD-specific requirements
#    - Common for country-code TLDs (.uk, .au, .fr, etc.)
