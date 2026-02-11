################################################################################
# AWS Service Quotas Template Association
################################################################################
# Terraform resource for managing an AWS Service Quotas Template Association.
#
# IMPORTANT PREREQUISITES:
# - This resource can ONLY be created by the management account of an AWS Organization
# - Must be created in the us-east-1 region
# - AWS Organizations must have "All Features" mode enabled
# - Service Quotas trusted access must be enabled in AWS Organizations
#
# BEHAVIOR:
# - When associated (status = ASSOCIATED), quota increase requests in the template
#   are automatically applied to new AWS accounts created in the organization
# - This resource manages the association state, not the quota template content itself
# - Use aws_servicequotas_template to define specific quota increase requests
#
# USE CASES:
# - Automatically apply standardized quota increases to new accounts in an organization
# - Ensure consistent resource limits across all accounts in an organization
# - Reduce manual work by automating quota increase requests for new accounts
#
# LIMITATIONS:
# - Templates are only supported in commercial AWS Regions
# - Not available in China Regions or opt-in Regions
# - Maximum of 10 quotas can be added to a template
# - Only works with new accounts created after template association
#
# REFERENCES:
# - https://docs.aws.amazon.com/servicequotas/latest/userguide/organization-templates.html
# - https://docs.aws.amazon.com/organizations/latest/userguide/services-that-can-integrate-servicequotas.html
################################################################################

resource "aws_servicequotas_template_association" "example" {
  ################################################################################
  # Optional: Region Configuration
  ################################################################################
  # Region where this resource will be managed.
  # IMPORTANT: Service Quota template associations MUST be managed in us-east-1
  #
  # Type: string
  # Default: Region set in the provider configuration
  # Required: No
  #
  # BEST PRACTICE:
  # - Always explicitly set to "us-east-1" to avoid confusion
  # - Use a provider alias if your main provider uses a different region
  #
  # Example:
  # region = "us-east-1"
  ################################################################################
  # region = "us-east-1"

  ################################################################################
  # Optional: Skip Destroy Configuration
  ################################################################################
  # Skip disassociating the quota increase template upon destruction.
  #
  # Type: bool
  # Default: false
  # Required: No
  #
  # BEHAVIOR:
  # - When set to true:
  #   * Resource is removed from Terraform state upon destruction
  #   * Remote association remains active in AWS
  #   * Existing accounts continue to use the template for new accounts
  # - When set to false (default):
  #   * Resource is disassociated from the organization upon destruction
  #   * New accounts will receive default quota values
  #
  # USE CASES:
  # - Set to true when managing the association outside of Terraform
  # - Set to true to prevent accidental disassociation during testing
  # - Set to false (default) for normal lifecycle management
  #
  # WARNING:
  # - Setting this to true means Terraform destroy will not disassociate the template
  # - Manual cleanup via AWS Console or CLI will be required if you want to disassociate
  #
  # Example:
  # skip_destroy = false
  ################################################################################
  # skip_destroy = false
}

################################################################################
# COMPUTED ATTRIBUTES
################################################################################
# The following attributes are exported by this resource:
#
# id:
#   - AWS account ID of the management account
#   - Can be referenced as: aws_servicequotas_template_association.example.id
#
# status:
#   - Association status of the template
#   - Value: "ASSOCIATED" when successfully created
#   - When status is "ASSOCIATED", quota increase requests in the template
#     are automatically applied to new AWS accounts in the organization
#   - Can be referenced as: aws_servicequotas_template_association.example.status
################################################################################

################################################################################
# EXAMPLE: Complete Configuration with Provider Alias
################################################################################
# When your default provider is not in us-east-1, use a provider alias:
#
# provider "aws" {
#   alias  = "us_east_1"
#   region = "us-east-1"
# }
#
# resource "aws_servicequotas_template_association" "example" {
#   provider = aws.us_east_1
# }
################################################################################

################################################################################
# EXAMPLE: Full Configuration with Related Resources
################################################################################
# Complete setup with quota template and association:
#
# # Define quota increase requests in the template
# resource "aws_servicequotas_template" "ec2_instances" {
#   provider     = aws.us_east_1
#   region       = "us-east-1"
#   quota_code   = "L-1216C47A"
#   service_code = "ec2"
#   value        = 100
# }
#
# resource "aws_servicequotas_template" "vpc_per_region" {
#   provider     = aws.us_east_1
#   region       = "us-east-1"
#   quota_code   = "L-F678F1CE"
#   service_code = "vpc"
#   value        = 10
# }
#
# # Associate the template with the organization
# resource "aws_servicequotas_template_association" "example" {
#   provider = aws.us_east_1
#
#   # Ensure all quota templates are created before association
#   depends_on = [
#     aws_servicequotas_template.ec2_instances,
#     aws_servicequotas_template.vpc_per_region
#   ]
# }
#
# # Output the association status
# output "template_association_status" {
#   description = "Status of the Service Quotas template association"
#   value       = aws_servicequotas_template_association.example.status
# }
################################################################################

################################################################################
# TROUBLESHOOTING
################################################################################
# Common errors and solutions:
#
# 1. "AccessDeniedException":
#    - Ensure you are using the management account of the organization
#    - Verify IAM permissions for Service Quotas operations
#
# 2. "AWSServiceAccessNotEnabledException":
#    - Enable Service Quotas trusted access in AWS Organizations
#    - Run: aws organizations enable-aws-service-access --service-principal servicequotas.amazonaws.com
#
# 3. "NoAvailableOrganizationException":
#    - Ensure the AWS account is part of an organization
#    - Create or join an organization first
#
# 4. "OrganizationNotInAllFeaturesModeException":
#    - Enable "All Features" mode in AWS Organizations
#    - Organizations in "Consolidated Billing" mode are not supported
#
# 5. "TemplatesNotAvailableInRegionException":
#    - Ensure you are creating this resource in us-east-1
#    - Use a provider alias if necessary
#
# 6. "TooManyRequestsException":
#    - API throttling occurred, retry after a delay
#    - Implement exponential backoff in automation scripts
################################################################################

################################################################################
# SECURITY CONSIDERATIONS
################################################################################
# IAM Permissions Required (for management account):
# - servicequotas:AssociateServiceQuotaTemplate
# - servicequotas:GetAssociationForServiceQuotaTemplate
# - servicequotas:DisassociateServiceQuotaTemplate
# - organizations:DescribeOrganization
# - organizations:EnableAWSServiceAccess
#
# Service-Linked Role:
# - A service-linked role named "AWSServiceRoleForServiceQuotas" is automatically
#   created in the management account when Service Quotas is integrated with
#   AWS Organizations
# - This role allows Service Quotas to perform operations within the organization
# - Can only be assumed by the service principal: servicequotas.amazonaws.com
#
# Best Practices:
# - Restrict this resource to be managed only by organization administrators
# - Use AWS CloudTrail to audit changes to template associations
# - Implement SCPs to control which quotas can be increased via templates
# - Review quota increase requests in templates regularly for security implications
################################################################################

################################################################################
# COST CONSIDERATIONS
################################################################################
# - There is no direct cost for creating or maintaining a Service Quotas template association
# - However, quota increases applied via templates may enable:
#   * Creation of more resources in member accounts
#   * Potentially higher AWS costs across the organization
#
# Recommendations:
# - Monitor quota usage across accounts using AWS Service Quotas console
# - Set up AWS Budgets to track spending in member accounts
# - Review quota templates regularly to ensure they align with organizational policies
################################################################################

################################################################################
# OPERATIONAL NOTES
################################################################################
# Lifecycle:
# - Creation: Enables automatic quota increases for new accounts
# - Updates: This resource has minimal configuration, updates are rare
# - Deletion: Disassociates template (unless skip_destroy = true)
#
# Impact on Existing Accounts:
# - Template association does NOT affect existing accounts
# - Only new accounts created after association receive the quota increases
# - Use aws_servicequotas_service_quota resource for existing accounts
#
# Template Management:
# - Use aws_servicequotas_template resource to manage individual quota requests
# - Up to 10 quota increase requests can be added to a template
# - Template modifications are independent of the association resource
#
# Monitoring:
# - Use GetAssociationForServiceQuotaTemplate API to check association status
# - Monitor CloudTrail for AssociateServiceQuotaTemplate and
#   DisassociateServiceQuotaTemplate events
# - Check Service Quotas console in us-east-1 for template status
################################################################################
