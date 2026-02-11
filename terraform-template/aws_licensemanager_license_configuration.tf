################################################################################
# AWS License Manager - License Configuration
################################################################################
# Provides a License Manager license configuration resource.
#
# License Manager helps you manage software licenses from vendors such as
# Microsoft, SAP, Oracle, and IBM across AWS and on-premises environments.
# A license configuration is an abstraction of a customer license agreement
# that can be consumed and enforced by License Manager.
#
# Use Cases:
# - Track and manage Bring Your Own License (BYOL) software licenses
# - Enforce license compliance across your AWS infrastructure
# - Prevent license overuse by setting hard limits
# - Integrate with AWS Systems Manager for automated license discovery
# - Control license distribution across instances, cores, sockets, or vCPUs
#
# Common Patterns:
# - SQL Server licenses tracked by cores with minimum core requirements
# - Windows Server licenses tracked by instances
# - Oracle Database licenses tracked by vCPUs with tenancy restrictions
# - SAP licenses with socket-based counting and affinity rules
#
# Important Notes:
# ⚠️  Removing the license_count attribute is not supported by the License
#     Manager API. Use 'terraform taint' to recreate the resource instead.
# ⚠️  License rules format: #ruleType=value (e.g., #minimumCores=8)
# ⚠️  Hard limit enforcement prevents resource launches when limit is reached
# ⚠️  Automated discovery requires AWS Systems Manager integration
# ⚠️  For RDS Oracle/Db2, only vCPU counting type is supported
#
# AWS Documentation:
# https://docs.aws.amazon.com/license-manager/latest/userguide/license-manager.html
#
# Terraform Documentation:
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/licensemanager_license_configuration
################################################################################

resource "aws_licensemanager_license_configuration" "example" {
  # ============================================================================
  # REQUIRED PARAMETERS
  # ============================================================================

  # Name of the license configuration
  # - Must be unique within your account and region
  # - Used for identification in AWS Console and APIs
  # - Best practice: Use descriptive names like "SQLServer-Enterprise-2019"
  name = "Example-License-Configuration"

  # Dimension to use to track license inventory
  # - vCPU: Virtual CPUs (use for cloud-optimized licensing)
  # - Instance: EC2 instances (use for per-instance licensing)
  # - Core: Physical CPU cores (use for core-based licensing like SQL Server)
  # - Socket: Physical CPU sockets (use for socket-based licensing like Oracle)
  #
  # Choosing the Right Type:
  # - vCPU: Best for elastic workloads, supports vCPU optimization
  # - Instance: Simplest tracking, one license per instance
  # - Core: Common for Microsoft SQL Server, Oracle DB
  # - Socket: Common for older Oracle licenses, SAP HANA
  license_counting_type = "Socket"

  # ============================================================================
  # OPTIONAL PARAMETERS
  # ============================================================================

  # Description of the license configuration
  # - Useful for documenting license terms and conditions
  # - Include vendor name, product version, license agreement details
  # - Example: "Microsoft SQL Server 2019 Enterprise - 96 core license"
  description = "Example license configuration for demonstration"

  # Number of licenses managed by this configuration
  # - Represents the total licenses you've purchased
  # - License Manager tracks consumption against this number
  # - Can be updated to reflect license purchases/renewals
  # - ⚠️  Removing this attribute requires resource recreation (use terraform taint)
  license_count = 10

  # Sets the number of available licenses as a hard limit
  # - true: Prevents resource launches when limit is reached (hard enforcement)
  # - false: Allows overuse but tracks it (soft enforcement, default)
  # - Hard limit is recommended for strict compliance requirements
  # - Soft limit is useful for grace periods and flexibility
  license_count_hard_limit = true

  # Array of configured License Manager rules
  # - Rules vary based on license_counting_type
  # - Format: "#ruleType=value"
  # - Multiple rules can be combined
  #
  # Available Rules by Counting Type:
  #
  # For "Core" counting type:
  # - #licenseAffinityToHost=1-180  : License sticks to host for N days
  # - #maximumCores=N               : Maximum cores per resource
  # - #minimumCores=N               : Minimum cores per resource
  # - #allowedTenancy=EC2-Default|EC2-DedicatedInstance|EC2-DedicatedHost
  #
  # For "Instance" counting type:
  # - #maximumCores=N               : Maximum cores per instance
  # - #minimumCores=N               : Minimum cores per instance
  # - #maximumSockets=N             : Maximum sockets per instance
  # - #minimumSockets=N             : Minimum sockets per instance
  # - #maximumVcpus=N               : Maximum vCPUs per instance
  # - #minimumVcpus=N               : Minimum vCPUs per instance
  # - #allowedTenancy=EC2-Default|EC2-DedicatedInstance|EC2-DedicatedHost
  #
  # For "Socket" counting type:
  # - #licenseAffinityToHost=1-180  : License sticks to host for N days
  # - #maximumSockets=N             : Maximum sockets per resource
  # - #minimumSockets=N             : Minimum sockets per resource
  # - #allowedTenancy=EC2-Default|EC2-DedicatedInstance|EC2-DedicatedHost
  #
  # For "vCPU" counting type:
  # - #maximumVcpus=N               : Maximum vCPUs per resource
  # - #minimumVcpus=N               : Minimum vCPUs per resource
  # - #honorVcpuOptimization=true|false : Respect CPU optimization settings
  # - #allowedTenancy=EC2-Default|EC2-DedicatedInstance|EC2-DedicatedHost
  #
  # Tenancy Options:
  # - EC2-Default: Shared tenancy (multiple customers share physical hardware)
  # - EC2-DedicatedInstance: Dedicated instance (single-tenant hardware)
  # - EC2-DedicatedHost: Dedicated host (required for Core/Socket types)
  # - Multiple values: Comma-separated (e.g., "EC2-Default,EC2-DedicatedInstance")
  #
  # License Affinity (Core and Socket only):
  # - Restricts license usage to a specific host for specified days (1-180)
  # - After affinity period, license becomes available within 24 hours
  # - Useful for preventing license churn and maintaining compliance
  #
  # Common Examples:
  # - SQL Server Enterprise: ["#minimumCores=8", "#allowedTenancy=EC2-DedicatedHost"]
  # - Oracle Database: ["#minimumVcpus=2", "#allowedTenancy=EC2-DedicatedHost"]
  # - Windows Server: ["#allowedTenancy=EC2-Default"]
  # - License affinity: ["#licenseAffinityToHost=90", "#minimumSockets=2"]
  license_rules = [
    "#minimumSockets=2",
  ]

  # Tags for resource organization and cost allocation
  # - Use for tracking license costs by project/team
  # - Useful for automated license reporting and compliance
  # - Supports provider default_tags
  #
  # Common Tag Patterns:
  # - Environment: dev, staging, production
  # - CostCenter: Finance department or team identifier
  # - Vendor: Microsoft, Oracle, SAP, IBM
  # - Product: SQL Server, Oracle DB, Windows Server
  # - LicenseType: BYOL, License Included
  # - ComplianceRequired: true/false
  tags = {
    Name        = "Example License Configuration"
    Environment = "production"
    Vendor      = "Example-Vendor"
    Product     = "Example-Product"
    ManagedBy   = "Terraform"
  }

  # ============================================================================
  # ADVANCED CONFIGURATION (Available but not commonly used)
  # ============================================================================

  # Region where this resource will be managed
  # - Uncomment to specify a different region than the provider default
  # - Useful for multi-region license management
  # region = "us-east-1"
}

################################################################################
# OUTPUTS
################################################################################

output "license_configuration_arn" {
  description = "The ARN of the license configuration"
  value       = aws_licensemanager_license_configuration.example.arn
}

output "license_configuration_id" {
  description = "The ID (ARN) of the license configuration"
  value       = aws_licensemanager_license_configuration.example.id
}

output "license_configuration_owner_account_id" {
  description = "Account ID of the owner of the license configuration"
  value       = aws_licensemanager_license_configuration.example.owner_account_id
}

output "license_configuration_tags_all" {
  description = "Map of tags assigned to the resource, including provider default_tags"
  value       = aws_licensemanager_license_configuration.example.tags_all
}

################################################################################
# ADDITIONAL EXAMPLES
################################################################################

# Example 1: Microsoft SQL Server Enterprise (Core-based licensing)
# Typical scenario: 96-core license with minimum 8 cores per server on Dedicated Hosts
resource "aws_licensemanager_license_configuration" "sql_server_enterprise" {
  name                     = "SQLServer-Enterprise-2019"
  description              = "Microsoft SQL Server 2019 Enterprise - 96 core license"
  license_count            = 96
  license_count_hard_limit = true
  license_counting_type    = "Core"

  license_rules = [
    "#minimumCores=8",                   # Each server must run minimum 8 cores
    "#maximumCores=16",                  # Each server can use maximum 16 cores
    "#allowedTenancy=EC2-DedicatedHost", # Must run on Dedicated Hosts
  ]

  tags = {
    Name            = "SQL Server Enterprise License"
    Vendor          = "Microsoft"
    Product         = "SQL Server Enterprise 2019"
    LicenseType     = "BYOL"
    ComplianceLevel = "Strict"
  }
}

# Example 2: Oracle Database (vCPU-based licensing with optimization)
# Typical scenario: vCPU-based licensing with CPU optimization support
resource "aws_licensemanager_license_configuration" "oracle_database" {
  name                     = "Oracle-Database-Enterprise"
  description              = "Oracle Database Enterprise Edition - vCPU licensing"
  license_count            = 100
  license_count_hard_limit = false # Soft limit for flexibility
  license_counting_type    = "vCPU"

  license_rules = [
    "#minimumVcpus=2",                   # Minimum 2 vCPUs per instance
    "#honorVcpuOptimization=true",       # Respect CPU optimization settings
    "#allowedTenancy=EC2-DedicatedHost", # Dedicated Hosts for licensing compliance
  ]

  tags = {
    Name        = "Oracle Database Enterprise License"
    Vendor      = "Oracle"
    Product     = "Oracle Database Enterprise"
    LicenseType = "BYOL"
  }
}

# Example 3: Windows Server (Instance-based licensing)
# Typical scenario: Per-instance licensing with shared tenancy
resource "aws_licensemanager_license_configuration" "windows_server" {
  name                     = "Windows-Server-2022-Datacenter"
  description              = "Windows Server 2022 Datacenter Edition"
  license_count            = 50
  license_count_hard_limit = false
  license_counting_type    = "Instance"

  license_rules = [
    "#allowedTenancy=EC2-Default", # Shared tenancy allowed
  ]

  tags = {
    Name        = "Windows Server 2022 License"
    Vendor      = "Microsoft"
    Product     = "Windows Server 2022 Datacenter"
    LicenseType = "BYOL"
  }
}

# Example 4: SAP HANA (Socket-based with license affinity)
# Typical scenario: Socket-based licensing with host affinity for 90 days
resource "aws_licensemanager_license_configuration" "sap_hana" {
  name                     = "SAP-HANA-Enterprise"
  description              = "SAP HANA Enterprise Edition - Socket-based licensing"
  license_count            = 24
  license_count_hard_limit = true
  license_counting_type    = "Socket"

  license_rules = [
    "#licenseAffinityToHost=90",         # License sticks to host for 90 days
    "#minimumSockets=2",                 # Minimum 2 sockets per server
    "#allowedTenancy=EC2-DedicatedHost", # Dedicated Hosts required
  ]

  tags = {
    Name           = "SAP HANA Enterprise License"
    Vendor         = "SAP"
    Product        = "SAP HANA Enterprise"
    LicenseType    = "BYOL"
    AffinityPeriod = "90-days"
  }
}

# Example 5: Flexible Instance Licensing (No hard limit, multiple rules)
# Typical scenario: General purpose instance licensing with flexible constraints
resource "aws_licensemanager_license_configuration" "flexible_instance" {
  name                     = "Flexible-Instance-License"
  description              = "Flexible instance-based licensing with constraints"
  license_count            = 200
  license_count_hard_limit = false # Soft limit for monitoring
  license_counting_type    = "Instance"

  license_rules = [
    "#minimumCores=4",                       # Minimum 4 cores
    "#maximumCores=32",                      # Maximum 32 cores
    "#minimumVcpus=8",                       # Minimum 8 vCPUs
    "#maximumVcpus=128",                     # Maximum 128 vCPUs
    "#allowedTenancy=EC2-DedicatedInstance", # Dedicated Instances
  ]

  tags = {
    Name            = "Flexible Instance License"
    Environment     = "multi-env"
    LicenseType     = "BYOL"
    EnforcementType = "Soft"
  }
}

# Example 6: vCPU Optimized License
# Scenario: Database license that respects EC2 CPU optimization settings
resource "aws_licensemanager_license_configuration" "vcpu_optimized" {
  name                     = "vCPU-Optimized-Database"
  description              = "vCPU-based license with CPU optimization support"
  license_count            = 150
  license_count_hard_limit = false
  license_counting_type    = "vCPU"

  license_rules = [
    "#minimumVcpus=4",                                   # Minimum 4 vCPUs
    "#maximumVcpus=96",                                  # Maximum 96 vCPUs
    "#honorVcpuOptimization=true",                       # Count customized vCPUs
    "#allowedTenancy=EC2-Default,EC2-DedicatedInstance", # Shared or Dedicated
  ]

  tags = {
    Name           = "vCPU Optimized Database License"
    Vendor         = "Database-Vendor"
    Optimization   = "Enabled"
    CostOptimized  = "true"
  }
}

################################################################################
# INTEGRATION PATTERNS
################################################################################

# Pattern 1: Associate with EC2 Launch Template
# Automatically associate license configuration with instances at launch time

# data "aws_licensemanager_license_configuration" "existing" {
#   filter {
#     name   = "tag:Name"
#     values = ["SQL Server Enterprise License"]
#   }
# }
#
# resource "aws_launch_template" "app" {
#   name_prefix   = "app-"
#   instance_type = "m5.2xlarge"
#
#   license_specification {
#     license_configuration_arn = data.aws_licensemanager_license_configuration.existing.arn
#   }
# }

# Pattern 2: Resource Access Manager (RAM) Sharing
# Share license configurations across AWS accounts in an organization

# resource "aws_ram_resource_share" "license_share" {
#   name                      = "license-share"
#   allow_external_principals = false
#
#   tags = {
#     Name = "License Configuration Share"
#   }
# }
#
# resource "aws_ram_resource_association" "license" {
#   resource_arn       = aws_licensemanager_license_configuration.sql_server_enterprise.arn
#   resource_share_arn = aws_ram_resource_share.license_share.arn
# }
#
# resource "aws_ram_principal_association" "account" {
#   principal          = "123456789012" # Target account ID
#   resource_share_arn = aws_ram_resource_share.license_share.arn
# }

# Pattern 3: CloudWatch Alarms for License Usage
# Monitor license consumption and alert when thresholds are exceeded

# resource "aws_cloudwatch_metric_alarm" "license_high_usage" {
#   alarm_name          = "license-high-usage"
#   comparison_operator = "GreaterThanThreshold"
#   evaluation_periods  = "1"
#   metric_name         = "ConsumedLicenses"
#   namespace           = "AWS/LicenseManager"
#   period              = "300"
#   statistic           = "Average"
#   threshold           = "80" # Alert at 80% usage
#
#   dimensions = {
#     LicenseConfigurationArn = aws_licensemanager_license_configuration.sql_server_enterprise.arn
#   }
#
#   alarm_description = "Alert when SQL Server licenses exceed 80% usage"
#   alarm_actions     = [aws_sns_topic.alerts.arn]
# }

################################################################################
# IMPORT
################################################################################

# License Manager license configurations can be imported using the resource ARN.
#
# Example:
# terraform import aws_licensemanager_license_configuration.example \
#   arn:aws:license-manager:us-east-1:123456789012:license-configuration:lic-0123456789abcdef0123456789abcdef

################################################################################
# TROUBLESHOOTING TIPS
################################################################################

# Issue: Cannot remove license_count attribute
# Solution: Use 'terraform taint aws_licensemanager_license_configuration.<name>'
#           then run 'terraform apply' to recreate the resource

# Issue: License rules not being enforced
# Solution: Verify that license_count_hard_limit is set to true for hard enforcement
#           Check that license rules match the license_counting_type

# Issue: Instances launching despite license limit
# Solution: Ensure automated discovery is configured in Systems Manager
#           Verify that instances are properly tagged for license tracking
#           Check that the correct license configuration is associated

# Issue: License affinity not working
# Solution: Verify that license_counting_type is "Core" or "Socket"
#           License affinity only works with these counting types
#           Check that instances are running on Dedicated Hosts

# Issue: vCPU optimization not being honored
# Solution: Ensure #honorVcpuOptimization=true is set in license_rules
#           Verify that license_counting_type is "vCPU"
#           Check EC2 instance CPU optimization settings

################################################################################
# COMPLIANCE AND BEST PRACTICES
################################################################################

# 1. License Enforcement:
#    - Use hard limits (license_count_hard_limit = true) for strict compliance
#    - Implement soft limits for development/testing environments
#    - Set up CloudWatch alarms at 80% and 95% thresholds

# 2. Rule Configuration:
#    - Set appropriate minimum/maximum rules to match vendor license terms
#    - Use license affinity (90 days typical) to prevent license churn
#    - Apply tenancy restrictions based on vendor requirements

# 3. Documentation:
#    - Use descriptive names that include vendor and product information
#    - Document license agreement terms in the description field
#    - Include purchase dates and renewal information in tags

# 4. Automation:
#    - Enable automated discovery in Systems Manager for accurate tracking
#    - Associate license configurations with launch templates
#    - Use tagging strategies for automatic license assignment

# 5. Monitoring:
#    - Regularly review License Manager dashboards
#    - Set up automated reports for license usage trends
#    - Monitor for license violations and address proactively

# 6. Cost Optimization:
#    - Right-size instances to avoid over-licensing
#    - Use vCPU optimization for vCPU-based licenses
#    - Identify under-utilized licenses through automated discovery
#    - Share licenses across accounts using AWS RAM when appropriate

# 7. Multi-Account Strategy:
#    - Centralize license management in a dedicated account
#    - Use AWS Organizations and RAM for cross-account sharing
#    - Implement consistent tagging across all accounts

# 8. Audit Preparation:
#    - Compare License Manager data with vendor audit tools
#    - Export license usage reports regularly
#    - Maintain documentation of license purchases and assignments
#    - Track license expiration dates and set renewal reminders

################################################################################
# VENDOR-SPECIFIC GUIDELINES
################################################################################

# Microsoft SQL Server:
# - Use "Core" counting type
# - Minimum 8 cores per server (Enterprise Edition)
# - Require EC2-DedicatedHost tenancy
# - Set license affinity for long-running workloads

# Oracle Database:
# - Use "vCPU" or "Core" depending on license agreement
# - Enable vCPU optimization for cost savings
# - Require EC2-DedicatedHost for most licenses
# - Implement minimum vCPU/core rules per license terms

# Windows Server:
# - Use "Instance" counting type for most scenarios
# - Use "Core" for Datacenter Edition on Dedicated Hosts
# - Shared tenancy acceptable for most licenses
# - Track CALs separately (not managed by License Manager)

# SAP:
# - Use "Socket" counting type
# - Require EC2-DedicatedHost tenancy
# - Implement license affinity for HANA workloads
# - Set minimum/maximum socket requirements

# IBM:
# - Varies by product (DB2, WebSphere, etc.)
# - Consult license agreement for counting type
# - May require Dedicated Hosts or Dedicated Instances
# - Implement appropriate minimum/maximum rules

################################################################################
# RELATED AWS SERVICES
################################################################################

# AWS Systems Manager:
# - Enables automated license discovery
# - Tracks installed software across EC2 instances
# - Required for real-time license consumption tracking

# AWS Resource Access Manager (RAM):
# - Share license configurations across accounts
# - Centralized license management in Organizations
# - Supports principal sharing within organization

# AWS Service Catalog:
# - Create pre-approved product configurations
# - Enforce license compliance through catalog constraints
# - Automate license configuration association

# AWS Config:
# - Monitor license configuration compliance
# - Track changes to license configurations
# - Trigger automated remediation for non-compliance

# Amazon CloudWatch:
# - Monitor license consumption metrics
# - Set alarms for license threshold violations
# - Create dashboards for license usage visibility

################################################################################
# REFERENCE LINKS
################################################################################

# AWS License Manager Documentation:
# https://docs.aws.amazon.com/license-manager/latest/userguide/license-manager.html

# Self-managed License Parameters and Rules:
# https://docs.aws.amazon.com/license-manager/latest/userguide/config-overview.html

# Build Rules from Vendor Licenses:
# https://docs.aws.amazon.com/license-manager/latest/userguide/licenses-to-rules.html

# License Manager API Reference:
# https://docs.aws.amazon.com/license-manager/latest/APIReference/Welcome.html

# Terraform AWS Provider Documentation:
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/licensemanager_license_configuration

# AWS License Manager Pricing:
# https://aws.amazon.com/license-manager/pricing/
