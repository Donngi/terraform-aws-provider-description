################################################################################
# AWS SageMaker Studio Lifecycle Configuration
################################################################################
# This resource creates a lifecycle configuration for Amazon SageMaker Studio,
# which allows you to automate customization tasks when Studio applications start.
# Lifecycle configurations are shell scripts that run during application startup
# and can be used to install packages, configure extensions, preload datasets,
# or set up source code repositories.
#
# Use Cases:
# - Automatically install Python packages when JupyterLab starts
# - Configure IDE extensions for Code Editor applications
# - Set up Git repositories and authentication
# - Preload datasets for ML experiments
# - Configure environment variables and credentials
# - Automatically shut down idle kernels to reduce costs
#
# References:
# - AWS API: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_CreateStudioLifecycleConfig.html
# - User Guide: https://docs.aws.amazon.com/sagemaker/latest/dg/studio-lifecycle-configurations.html
# - Terraform Docs: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sagemaker_studio_lifecycle_config
################################################################################

resource "aws_sagemaker_studio_lifecycle_config" "example" {
  ################################################################################
  # Required Arguments
  ################################################################################

  # studio_lifecycle_config_name - (Required) The name of the Studio Lifecycle Config.
  # - Must be 0-63 characters long
  # - Must match pattern: [a-zA-Z0-9](-*[a-zA-Z0-9]){0,62}
  # - Must be alphanumeric with hyphens allowed (but not at start/end)
  # - Used as the identifier for this lifecycle configuration
  # - Must be unique within your AWS account and region
  studio_lifecycle_config_name = "example-lifecycle-config"

  # studio_lifecycle_config_app_type - (Required) The application type to attach this lifecycle config to.
  # Valid values:
  # - "JupyterServer" - For SageMaker Studio Classic JupyterServer applications (deprecated)
  # - "KernelGateway" - For SageMaker Studio Classic notebook kernel environments (deprecated)
  # - "CodeEditor" - For Code Editor (VSCode-based) applications in Studio
  # - "JupyterLab" - For JupyterLab applications in Studio (recommended for new deployments)
  #
  # Note: JupyterServer and KernelGateway are for Studio Classic which is deprecated as of Nov 30, 2023.
  # For new implementations, use JupyterLab or CodeEditor app types.
  studio_lifecycle_config_app_type = "JupyterLab"

  # studio_lifecycle_config_content - (Required) The content of the lifecycle configuration script.
  # - Must be base64 encoded
  # - Must be 1-16384 characters after encoding
  # - The script is executed as a shell script when the application starts
  # - Timeout: Scripts have a 5-minute timeout. Use nohup for long-running tasks.
  # - Logs: Script output (STDOUT/STDERR) is sent to CloudWatch Logs at /aws/sagemaker/studio
  #
  # Example scripts:
  # - Install Python packages: pip install package-name
  # - Configure Git: git config --global user.name "Your Name"
  # - Download datasets: aws s3 cp s3://bucket/data.csv /home/sagemaker-user/
  # - Set environment variables: export VAR_NAME=value
  #
  # This example installs common ML packages at startup:
  studio_lifecycle_config_content = base64encode(<<-EOT
    #!/bin/bash
    set -eux

    # Install common ML packages
    pip install --upgrade pip
    pip install pandas numpy scikit-learn matplotlib seaborn

    # Configure Git (optional)
    # git config --global user.name "Your Name"
    # git config --global user.email "your.email@example.com"

    # Download sample datasets (optional)
    # aws s3 cp s3://my-bucket/datasets/ /home/sagemaker-user/datasets/ --recursive

    echo "Lifecycle configuration completed successfully"
  EOT
  )

  ################################################################################
  # Optional Arguments
  ################################################################################

  # tags - (Optional) A map of tags to assign to the lifecycle configuration.
  # - Maximum 50 tags allowed
  # - Tag keys must be unique per resource
  # - Tags are searchable using the AWS Search API
  # - Inherited by resources created from this lifecycle config
  # - Useful for cost allocation, access control, and resource organization
  tags = {
    Name        = "example-lifecycle-config"
    Environment = "development"
    Purpose     = "ML development environment setup"
    ManagedBy   = "terraform"
  }

  # region - (Optional) Region where this resource will be managed.
  # - Defaults to the region set in the provider configuration
  # - Explicitly setting this overrides the provider's default region
  # - Useful for multi-region deployments
  # region = "us-east-1"
}

################################################################################
# Outputs
################################################################################

output "sagemaker_studio_lifecycle_config_id" {
  description = "The name of the Studio Lifecycle Config (same as studio_lifecycle_config_name)"
  value       = aws_sagemaker_studio_lifecycle_config.example.id
}

output "sagemaker_studio_lifecycle_config_arn" {
  description = "The Amazon Resource Name (ARN) assigned by AWS to this Studio Lifecycle Config"
  value       = aws_sagemaker_studio_lifecycle_config.example.arn
}

output "sagemaker_studio_lifecycle_config_tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_sagemaker_studio_lifecycle_config.example.tags_all
}

################################################################################
# Usage Notes
################################################################################
# 1. Attaching to Studio Domain/User Profile:
#    After creating this lifecycle config, attach it to a SageMaker Studio Domain
#    or User Profile using aws_sagemaker_domain or aws_sagemaker_user_profile resources.
#    Reference this config's ARN in the appropriate settings block.
#
# 2. Debugging Lifecycle Configurations:
#    - View logs in CloudWatch Logs: /aws/sagemaker/studio
#    - Search by domain ID, space name, and application type
#    - If application fails to start, check CloudWatch logs for script errors
#
# 3. Script Timeout:
#    - Scripts must complete within 5 minutes
#    - For longer tasks, use nohup to run processes in the background
#    - Example: nohup long-running-command &
#
# 4. Default Lifecycle Configs:
#    - Set at domain level: applies to all users and spaces
#    - Set at user profile level: overrides domain-level defaults
#    - JupyterServer configs run automatically on sign-in
#    - KernelGateway configs are selected by default in launcher
#
# 5. Script Best Practices:
#    - Use 'set -eux' for better error handling and logging
#    - Install packages in user space (--user flag) when possible
#    - Use absolute paths in scripts
#    - Test scripts locally before deploying
#    - Keep scripts idempotent (can run multiple times safely)
#
# 6. Security Considerations:
#    - Never hardcode credentials in lifecycle scripts
#    - Use IAM roles and instance profiles for AWS access
#    - Store sensitive data in AWS Secrets Manager or Parameter Store
#    - Limit script permissions to minimum required
#
# 7. Common Use Cases by App Type:
#    - JupyterLab: Install Python packages, configure extensions, set up Git
#    - CodeEditor: Install VSCode extensions, configure linters, set up debuggers
#    - KernelGateway (deprecated): Install kernel-specific packages per notebook
#    - JupyterServer (deprecated): One-time setup when Studio Classic starts
#
# 8. Migration from Studio Classic:
#    - Studio Classic (JupyterServer/KernelGateway) is deprecated as of Nov 30, 2023
#    - Migrate to new Studio with JupyterLab or CodeEditor app types
#    - Update lifecycle scripts to work with new application environments
#    - Test thoroughly as directory structures and environments differ
#
# Example: Attaching to a User Profile
# resource "aws_sagemaker_user_profile" "example" {
#   domain_id         = aws_sagemaker_domain.example.id
#   user_profile_name = "example-user"
#
#   user_settings {
#     jupyter_lab_app_settings {
#       lifecycle_config_arns = [
#         aws_sagemaker_studio_lifecycle_config.example.arn
#       ]
#     }
#   }
# }
################################################################################
