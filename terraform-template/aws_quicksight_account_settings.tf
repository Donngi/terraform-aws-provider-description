################################################################################
# AWS QuickSight Account Settings
################################################################################
# Terraform resource for managing an AWS QuickSight Account Settings.
#
# Deletion of this resource will not modify any settings, only remove the
# resource from state.
#
# AWS Documentation:
# https://docs.aws.amazon.com/quicksight/latest/user/managing-quicksight-account.html
#
# Terraform Documentation:
# https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/quicksight_account_settings
################################################################################

resource "aws_quicksight_account_settings" "example" {
  ################################################################################
  # Account Configuration
  ################################################################################

  # (Optional, Forces new resource) AWS account ID.
  # Defaults to automatically determined account ID of the Terraform AWS provider.
  # If you need to manage QuickSight settings for a specific AWS account, provide
  # the account ID here.
  # Type: string
  # Default: Current AWS account ID
  # aws_account_id = "123456789012"

  # (Optional) The default namespace for this Amazon Web Services account.
  # Currently, the default is `default`. Namespaces are used to organize QuickSight
  # resources such as dashboards, analyses, and datasets.
  # Type: string
  # Default: "default"
  # default_namespace = "default"

  # (Optional) Region where this resource will be managed.
  # Defaults to the Region set in the provider configuration.
  # QuickSight account settings are region-specific.
  # Type: string
  # Default: Provider region
  # region = "us-east-1"

  ################################################################################
  # Termination Protection
  ################################################################################

  # (Optional) A boolean value that determines whether or not an Amazon QuickSight
  # account can be deleted. If `true`, it does not allow the account to be deleted
  # and results in an error message if a user tries to make a DeleteAccountSubscription
  # request. If `false`, it will allow the account to be deleted.
  #
  # This is a safety feature to prevent accidental deletion of QuickSight accounts.
  # Enable this for production environments.
  # Type: bool
  # Default: Computed by AWS
  termination_protection_enabled = false

  ################################################################################
  # Timeouts
  ################################################################################

  # timeouts {
  #   # (Optional) How long to wait for resource creation. Default is 5 minutes.
  #   # Valid time units are "s" (seconds), "m" (minutes), "h" (hours).
  #   # Example: "10m", "30s", "1h"
  #   create = "5m"
  #
  #   # (Optional) How long to wait for resource updates. Default is 5 minutes.
  #   # Valid time units are "s" (seconds), "m" (minutes), "h" (hours).
  #   # Example: "10m", "30s", "1h"
  #   update = "5m"
  # }
}

################################################################################
# Outputs
################################################################################

# output "quicksight_account_id" {
#   description = "The AWS account ID for QuickSight account settings"
#   value       = aws_quicksight_account_settings.example.aws_account_id
# }

# output "quicksight_default_namespace" {
#   description = "The default namespace for QuickSight resources"
#   value       = aws_quicksight_account_settings.example.default_namespace
# }

# output "quicksight_region" {
#   description = "The AWS region where QuickSight account settings are managed"
#   value       = aws_quicksight_account_settings.example.region
# }

# output "quicksight_termination_protection" {
#   description = "Whether termination protection is enabled for the QuickSight account"
#   value       = aws_quicksight_account_settings.example.termination_protection_enabled
# }

################################################################################
# Example Usage with QuickSight Account Subscription
################################################################################
#
# This resource is typically used in conjunction with aws_quicksight_account_subscription
# to configure the QuickSight account after subscription is created.
#
# resource "aws_quicksight_account_subscription" "subscription" {
#   account_name          = "quicksight-terraform"
#   authentication_method = "IAM_AND_QUICKSIGHT"
#   edition               = "ENTERPRISE"
#   notification_email    = "notification@email.com"
# }
#
# resource "aws_quicksight_account_settings" "example" {
#   termination_protection_enabled = true
#
#   depends_on = [aws_quicksight_account_subscription.subscription]
# }
#
################################################################################
# Important Notes
################################################################################
#
# 1. Resource Deletion Behavior:
#    - Deleting this resource only removes it from Terraform state
#    - It does NOT modify actual QuickSight account settings
#    - This is intentional to prevent accidental account misconfiguration
#
# 2. Prerequisites:
#    - AWS QuickSight account subscription must exist before using this resource
#    - Use depends_on to ensure proper creation order
#
# 3. Regional Considerations:
#    - QuickSight account settings are region-specific
#    - Each region can have different settings for the same AWS account
#    - Ensure you're managing settings in the correct region
#
# 4. Termination Protection:
#    - When enabled, prevents accidental deletion of QuickSight account subscription
#    - Recommended for production environments
#    - Must be set to false before account deletion
#
# 5. Default Namespace:
#    - Namespaces organize QuickSight resources (dashboards, analyses, datasets)
#    - Default value is "default"
#    - Can be customized for organizational requirements
#
################################################################################
