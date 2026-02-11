################################################################################
# AWS FMS Resource Set
# https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/fms_resource_set
# AWS Documentation: https://docs.aws.amazon.com/waf/latest/developerguide/fms-resource-sets.html
################################################################################
# Terraform resource for managing an AWS FMS (Firewall Manager) Resource Set.
# A Resource Set allows grouping of AWS resources (such as Network Firewalls)
# for easier management within Firewall Manager policies. Resource sets provide
# granular control over which resources to manage in a policy and can be
# associated with multiple Firewall Manager policies.
#
# Key Features:
# - Groups resources for centralized Firewall Manager policy management
# - Supports AWS Network Firewall and other compatible resource types
# - Can be associated with multiple policies
# - Validates ARNs but doesn't verify resource existence
# - Resources remain referenced even if deleted or accounts leave organization
################################################################################

resource "aws_fms_resource_set" "example" {
  #==============================================================================
  # REGION CONFIGURATION
  #==============================================================================
  # region - (Optional) Region where this resource will be managed.
  # Type: string
  # Defaults to the Region set in the provider configuration.
  # AWS Doc: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  #
  # Specifies the AWS Region where this Firewall Manager resource set will be
  # created and managed. If not specified, uses the provider's default region.
  # This is particularly important for multi-region deployments where you need
  # to manage resource sets in specific regions.
  #
  # Example values:
  # - "us-east-1"
  # - "eu-west-1"
  # - "ap-southeast-1"
  #==============================================================================
  # region = "us-east-1"

  #==============================================================================
  # RESOURCE SET CONFIGURATION BLOCK
  #==============================================================================
  # resource_set - (Required) Details about the resource set to be created or updated.
  # Type: block
  # AWS Doc: https://docs.aws.amazon.com/fms/2018-01-01/APIReference/API_ResourceSet.html
  #
  # This block defines the complete configuration for the Firewall Manager
  # resource set, including its name, description, resource types, and status.
  # A resource set is a logical grouping of AWS resources that can be managed
  # together through Firewall Manager policies.
  #==============================================================================
  resource_set {
    #============================================================================
    # RESOURCE SET NAME
    #============================================================================
    # name - (Required) Descriptive name of the resource set.
    # Type: string
    # Length: 1-128 characters
    # Pattern: Alphanumeric characters, hyphens, periods, colons, slashes, equals, plus signs, and at symbols
    # Note: You can't change the name of a resource set after you create it.
    #
    # The unique, descriptive identifier for this resource set. This name is
    # used to identify the resource set in the Firewall Manager console and APIs.
    # Choose a meaningful name that reflects the purpose or contents of the
    # resource set, as it cannot be changed after creation.
    #
    # Example values:
    # - "production-network-firewalls"
    # - "dev-environment-firewalls"
    # - "critical-infrastructure-resources"
    #============================================================================
    name = "testing"

    #============================================================================
    # RESOURCE TYPE LIST
    #============================================================================
    # resource_type_list - (Required) Determines the resources that can be associated to the resource set.
    # Type: list(string)
    # AWS Doc: https://docs.aws.amazon.com/fms/2018-01-01/APIReference/API_ResourceSet.html
    #
    # Specifies the types of AWS resources that can be included in this resource
    # set. Currently, Firewall Manager supports creating and managing resource
    # sets primarily for AWS Network Firewall resources. When adding a resource
    # to this set, Firewall Manager validates the ARN but does not verify if the
    # resource actually exists. This allows you to reference resources that will
    # be created in the future.
    #
    # Supported resource types:
    # - "AWS::NetworkFirewall::Firewall" - AWS Network Firewall instances
    # - Additional types may be supported depending on AWS service updates
    #
    # Note: Depending on your setting for max results and the number of resource
    # sets, a single call might not return the full list.
    #============================================================================
    resource_type_list = ["AWS::NetworkFirewall::Firewall"]

    #============================================================================
    # RESOURCE SET DESCRIPTION
    #============================================================================
    # description - (Optional) Description of the resource set.
    # Type: string
    # Length: 0-256 characters
    # Pattern: Alphanumeric characters, hyphens, periods, colons, slashes, equals, plus signs, and at symbols
    #
    # Provides additional context and details about the purpose and contents of
    # this resource set. Use this field to document what types of resources are
    # included, why they're grouped together, or any special considerations for
    # managing this resource set.
    #
    # Example values:
    # - "Network Firewalls protecting production VPCs"
    # - "Development environment firewall resources"
    # - "Critical infrastructure firewalls for compliance scope"
    #============================================================================
    # description = "Resource set for managing network firewalls"

    #============================================================================
    # LAST UPDATE TIME
    #============================================================================
    # last_update_time - (Optional) Last time that the resource set was changed.
    # Type: string (timestamp)
    # AWS Doc: https://docs.aws.amazon.com/fms/2018-01-01/APIReference/API_ResourceSet.html
    #
    # Records the timestamp of the most recent modification to this resource set.
    # This is typically managed by AWS and is primarily informational. It helps
    # track when changes were made to the resource set configuration.
    #
    # Note: This is generally a read-only attribute managed by the service.
    #============================================================================
    # last_update_time = "2024-01-15T10:30:00Z"

    #============================================================================
    # RESOURCE SET STATUS
    #============================================================================
    # resource_set_status - (Optional) Indicates whether the resource set is in or out of the admin's Region scope.
    # Type: string
    # Valid values:
    # - "ACTIVE" - Admin can manage and delete the resource set
    # - "OUT_OF_ADMIN_SCOPE" - Admin can view the resource set, but can't edit or delete it
    # AWS Doc: https://docs.aws.amazon.com/fms/2018-01-01/APIReference/API_ResourceSetSummary.html
    #
    # Defines the administrative scope and permissions for this resource set.
    # When set to ACTIVE, the Firewall Manager administrator has full control
    # over the resource set, including the ability to modify and delete it.
    # When set to OUT_OF_ADMIN_SCOPE, the administrator can only view the
    # resource set without modification privileges.
    #
    # This is particularly useful in multi-region or multi-account setups where
    # you need to control which administrators can manage specific resource sets.
    #
    # Important considerations:
    # - If a member account leaves the AWS Organizations organization, resource
    #   references remain in the set but are no longer managed by policies
    # - If a resource in the set is deleted, the reference remains until manually
    #   removed by the administrator
    #============================================================================
    # resource_set_status = "ACTIVE"
  }

  #==============================================================================
  # TAGS (Not directly supported on this resource)
  #==============================================================================
  # Note: The aws_fms_resource_set resource does not directly support tags.
  # However, you can add tags when creating the resource set through the
  # PutResourceSet API, which can be used for organizing and identifying
  # resource sets in your AWS account.
  #
  # If you need to tag resources for organization or cost allocation, consider:
  # 1. Tagging the individual resources within the resource set
  # 2. Using naming conventions in the resource set name and description
  # 3. Implementing a tagging strategy at the policy level
  #==============================================================================

  #==============================================================================
  # COMPUTED ATTRIBUTES (Read-Only)
  #==============================================================================
  # The following attributes are exported and can be referenced after creation:
  #
  # arn - ARN of the Resource Set.
  # Example: arn:aws:fms:us-east-1:123456789012:resource-set/abcd1234-ef56-gh78-ij90-klmnopqrstuv
  # Use case: Reference in IAM policies or for cross-account access
  # Reference: aws_fms_resource_set.example.arn
  #
  # id - Unique identifier for the resource set.
  # Length: 22 alphanumeric characters
  # Example: "1234567890abcdefghij12"
  # Use case: Used in update and delete operations, or for referencing in policies
  # Reference: aws_fms_resource_set.example.id
  #
  # These attributes are returned in the responses to create and list commands
  # and should be provided to operations like update and delete.
  #==============================================================================
}

################################################################################
# USAGE EXAMPLES
################################################################################
# Example 1: Basic Network Firewall Resource Set
# resource "aws_fms_resource_set" "network_firewalls" {
#   resource_set {
#     name               = "production-network-firewalls"
#     description        = "All network firewalls protecting production VPCs"
#     resource_type_list = ["AWS::NetworkFirewall::Firewall"]
#     resource_set_status = "ACTIVE"
#   }
# }

# Example 2: Multi-Region Resource Set
# resource "aws_fms_resource_set" "eu_firewalls" {
#   region = "eu-west-1"
#   resource_set {
#     name               = "eu-compliance-firewalls"
#     description        = "European region firewalls for GDPR compliance"
#     resource_type_list = ["AWS::NetworkFirewall::Firewall"]
#     resource_set_status = "ACTIVE"
#   }
# }

# Example 3: Resource Set for Development Environment
# resource "aws_fms_resource_set" "dev_firewalls" {
#   resource_set {
#     name               = "development-environment-firewalls"
#     description        = "Network firewalls for non-production environments"
#     resource_type_list = ["AWS::NetworkFirewall::Firewall"]
#   }
# }

################################################################################
# IMPORTANT NOTES AND BEST PRACTICES
################################################################################
# 1. Immutable Name: The resource set name cannot be changed after creation.
#    Plan your naming convention carefully before creating the resource set.
#
# 2. ARN Validation: Firewall Manager validates the ARN format when adding
#    resources but doesn't check if the resource exists. This allows you to
#    reference resources that will be created later.
#
# 3. Resource Persistence: If a resource in the set is deleted from AWS, the
#    reference remains in the resource set until manually removed by the admin.
#
# 4. Organization Changes: If a member account leaves your AWS Organizations
#    organization, its resources remain referenced but are no longer managed
#    by associated policies.
#
# 5. Multi-Policy Association: A resource set can be associated with multiple
#    Firewall Manager policies, but not all policy types support managing the
#    same resource with multiple policies.
#
# 6. Supported Resource Types: Currently, AWS Network Firewall is the primary
#    supported resource type. Check AWS documentation for updates on additional
#    supported resource types.
#
# 7. Regional Scope: Resource sets are regional resources. For multi-region
#    deployments, create separate resource sets in each region.
#
# 8. Administrator Scope: Use resource_set_status to control administrative
#    access, especially important in delegated administrator scenarios.
#
# 9. Policy Integration: Resource sets are designed to work with Firewall
#    Manager policies. Consider your policy structure when designing resource
#    sets.
#
# 10. Naming Convention: Use descriptive names that indicate the purpose,
#     environment, or scope of the resources in the set for easier management.
################################################################################

################################################################################
# TROUBLESHOOTING
################################################################################
# Common Issues:
#
# 1. Cannot modify resource set name
#    - The name is immutable after creation
#    - Solution: Create a new resource set with the desired name and migrate
#
# 2. Resources not appearing in policy
#    - Check that resource_type_list matches the resources you're trying to manage
#    - Verify the resource ARNs are correctly formatted
#    - Ensure the resources exist in the same region as the resource set
#
# 3. Permission denied when managing resource set
#    - Verify the Firewall Manager administrator role has necessary permissions
#    - Check that resource_set_status is set to "ACTIVE" for the managing admin
#    - Confirm the admin account is in the correct organizational scope
#
# 4. Resource references remain after deletion
#    - This is expected behavior
#    - Manually remove the resource references from the resource set
#    - Consider implementing automation to clean up stale references
#
# 5. Multi-policy conflicts
#    - Not all policy types support multiple policies managing the same resource
#    - Review Firewall Manager policy type documentation
#    - Consider using separate resource sets for different policy types
################################################################################

################################################################################
# RELATED RESOURCES
################################################################################
# - aws_fms_policy - Firewall Manager Policy for managing security policies
# - aws_fms_admin_account - Designate Firewall Manager administrator account
# - aws_networkfirewall_firewall - Network Firewall instances to include in set
# - aws_networkfirewall_firewall_policy - Firewall policies for Network Firewall
# - aws_organizations_organization - AWS Organizations for multi-account management
################################################################################

################################################################################
# REFERENCES
################################################################################
# Terraform Documentation:
# https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/fms_resource_set
#
# AWS Firewall Manager Resource Sets:
# https://docs.aws.amazon.com/waf/latest/developerguide/fms-resource-sets.html
#
# Creating Resource Sets:
# https://docs.aws.amazon.com/waf/latest/developerguide/fms-creating-resource-set.html
#
# AWS API Reference - ResourceSet:
# https://docs.aws.amazon.com/fms/2018-01-01/APIReference/API_ResourceSet.html
#
# AWS API Reference - PutResourceSet:
# https://docs.aws.amazon.com/fms/2018-01-01/APIReference/API_PutResourceSet.html
#
# AWS API Reference - ResourceSetSummary:
# https://docs.aws.amazon.com/fms/2018-01-01/APIReference/API_ResourceSetSummary.html
################################################################################
