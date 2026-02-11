################################################################################
# AWS Inspector Resource Group
################################################################################
#
# Provides an Amazon Inspector Classic Resource Group.
#
# Amazon Inspector Classic Resource Groups allow you to define collections of
# EC2 instances based on tags, which can then be used as targets for Inspector
# assessment runs.
#
# Provider Version: 6.28.0
# Resource Documentation: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/inspector_resource_group
#
################################################################################

resource "aws_inspector_resource_group" "example" {
  ################################################################################
  # Required Arguments
  ################################################################################

  # tags - (Required) Key-value map of tags that are used to select the EC2
  # instances to be included in an Amazon Inspector assessment target.
  #
  # The tags specified here will be used to filter and identify EC2 instances
  # that should be included in Inspector assessments. Only instances matching
  # ALL specified tags will be included in the resource group.
  #
  # Example use cases:
  # - Select instances by environment (e.g., production, staging)
  # - Select instances by application or service
  # - Combine multiple tags for precise targeting
  #
  # Type: map(string)
  tags = {
    Name        = "foo"
    Environment = "bar"
  }

  ################################################################################
  # Optional Arguments
  ################################################################################

  # region - (Optional) Region where this resource will be managed.
  # Defaults to the Region set in the provider configuration.
  #
  # When specified, this overrides the provider-level region setting for this
  # specific resource. This is useful when managing Inspector resources across
  # multiple regions within the same Terraform configuration.
  #
  # Type: string
  # Default: Provider region
  # region = "us-east-1"
}

################################################################################
# Outputs
################################################################################

# The resource group ARN
output "inspector_resource_group_arn" {
  description = "The ARN of the Inspector resource group"
  value       = aws_inspector_resource_group.example.arn
}

################################################################################
# Additional Notes
################################################################################
#
# 1. Amazon Inspector Classic vs. Inspector v2:
#    - This resource is for Amazon Inspector Classic
#    - Inspector Classic is being replaced by Amazon Inspector v2
#    - Consider using Inspector v2 for new deployments
#
# 2. Tag-based selection:
#    - EC2 instances must have ALL specified tags to be included
#    - Tag keys and values are case-sensitive
#    - Empty tag values are supported
#
# 3. Assessment targets:
#    - Resource groups are used by Inspector assessment targets
#    - Multiple assessment targets can reference the same resource group
#    - Use with aws_inspector_assessment_target resource
#
# 4. Permissions required:
#    - inspector:CreateResourceGroup
#    - inspector:DescribeResourceGroups
#    - inspector:DeleteResourceGroup
#    - ec2:DescribeInstances (for tag-based filtering)
#
# 5. Limitations:
#    - Resource groups are region-specific
#    - Maximum 50 tags per resource group
#    - Tags must match EC2 instance tags exactly
#
# 6. Best practices:
#    - Use meaningful, consistent tag naming conventions
#    - Document tag requirements for instances to be assessed
#    - Consider using tag inheritance from Auto Scaling Groups
#    - Regularly review and update tag filters as infrastructure evolves
#
# 7. Cost considerations:
#    - No direct cost for creating resource groups
#    - Costs are incurred when assessment runs execute against the group
#    - More instances in the group = higher assessment costs
#
################################################################################
# Example: Multiple Resource Groups
################################################################################

# Example: Production environment resource group
resource "aws_inspector_resource_group" "production" {
  tags = {
    Environment = "production"
    Compliance  = "required"
  }
}

# Example: Development environment resource group
resource "aws_inspector_resource_group" "development" {
  tags = {
    Environment = "development"
  }
}

# Example: Specific application resource group
resource "aws_inspector_resource_group" "web_application" {
  tags = {
    Application = "web-app"
    Tier        = "frontend"
    Environment = "production"
  }
}

################################################################################
# Example: Integration with Assessment Target
################################################################################

# Resource group for web servers
resource "aws_inspector_resource_group" "web_servers" {
  tags = {
    Role        = "web-server"
    Environment = "production"
  }
}

# Assessment target using the resource group
resource "aws_inspector_assessment_target" "web_servers" {
  name               = "web-servers-assessment"
  resource_group_arn = aws_inspector_resource_group.web_servers.arn
}

# Assessment template for the target
resource "aws_inspector_assessment_template" "web_servers" {
  name       = "web-servers-security-assessment"
  target_arn = aws_inspector_assessment_target.web_servers.arn
  duration   = 3600

  rules_package_arns = [
    # Common Vulnerabilities and Exposures (CVE)
    "arn:aws:inspector:us-east-1:316112463485:rulespackage/0-gEjTy7T7",
    # CIS Operating System Security Configuration Benchmarks
    "arn:aws:inspector:us-east-1:316112463485:rulespackage/0-rExsr2X8",
    # Security Best Practices
    "arn:aws:inspector:us-east-1:316112463485:rulespackage/0-R01qwB5Q",
    # Runtime Behavior Analysis
    "arn:aws:inspector:us-east-1:316112463485:rulespackage/0-gBONHN9h",
  ]
}

################################################################################
# Example: Cross-region deployment
################################################################################

# Primary region resource group
resource "aws_inspector_resource_group" "primary" {
  region = "us-east-1"

  tags = {
    Region      = "primary"
    Environment = "production"
  }
}

# Secondary region resource group
resource "aws_inspector_resource_group" "secondary" {
  region = "us-west-2"

  tags = {
    Region      = "secondary"
    Environment = "production"
  }
}

################################################################################
# Terraform Configuration
################################################################################

# Required provider version
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.28.0"
    }
  }
}
