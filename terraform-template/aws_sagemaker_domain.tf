# ============================================================================
# AWS SageMaker Domain
# ============================================================================
# Provides a SageMaker AI Domain resource.
#
# Provider Version: 6.28.0
# Resource: aws_sagemaker_domain
# Documentation: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/sagemaker_domain
#
# SageMaker Domain is a managed environment for machine learning workflows,
# providing Studio and other application interfaces for data scientists.
# ============================================================================

resource "aws_sagemaker_domain" "example" {
  # ----------------------------------------------------------------------------
  # Required Arguments
  # ----------------------------------------------------------------------------

  # (Required) The domain name.
  domain_name = "example-domain"

  # (Required) The mode of authentication that members use to access the domain.
  # Valid values: IAM, SSO
  # - IAM: Users authenticate via AWS IAM
  # - SSO: Users authenticate via AWS IAM Identity Center (formerly SSO)
  auth_mode = "IAM"

  # (Required) The ID of the Amazon Virtual Private Cloud (VPC) that Studio uses
  # for communication.
  vpc_id = "vpc-12345678"

  # (Required) The VPC subnets that Studio uses for communication.
  # Must be in the same VPC as specified in vpc_id.
  subnet_ids = ["subnet-12345678", "subnet-87654321"]

  # ----------------------------------------------------------------------------
  # Required Block: default_user_settings
  # ----------------------------------------------------------------------------
  # The default user settings that apply to all users in the domain.
  # These settings can be overridden at the user profile level.

  default_user_settings {
    # (Required) The execution role ARN for the user.
    # This role is assumed when launching applications like Studio.
    execution_role = "arn:aws:iam::123456789012:role/SageMakerExecutionRole"

    # -------------------------------------------------------------------------
    # Optional: Security Configuration
    # -------------------------------------------------------------------------

    # (Optional) A list of security group IDs that will be attached to the user.
    # Controls network access for user applications.
    # security_groups = ["sg-12345678"]

    # -------------------------------------------------------------------------
    # Optional: Application Settings
    # -------------------------------------------------------------------------

    # (Optional) The settings for the JupyterLab application.
    # jupyter_lab_app_settings {
    #   # (Optional) The default instance type and image configuration.
    #   default_resource_spec {
    #     # (Optional) The instance type that the image version runs on.
    #     # Valid values: ml.t3.medium, ml.t3.large, ml.t3.xlarge, etc.
    #     instance_type = "ml.t3.medium"
    #
    #     # (Optional) The ARN of the SageMaker image that the image version belongs to.
    #     # sagemaker_image_arn = "arn:aws:sagemaker:us-east-1:123456789012:image/example"
    #
    #     # (Optional) The ARN of the image version created on the instance.
    #     # sagemaker_image_version_arn = "arn:aws:sagemaker:us-east-1:123456789012:image-version/example/1"
    #
    #     # (Optional) The SageMaker Image Version Alias.
    #     # sagemaker_image_version_alias = "latest"
    #
    #     # (Optional) The ARN of the Lifecycle Configuration attached to the Resource.
    #     # lifecycle_config_arn = "arn:aws:sagemaker:us-east-1:123456789012:studio-lifecycle-config/example"
    #   }
    #
    #   # (Optional) The Amazon Resource Name (ARN) of the Lifecycle Configurations.
    #   # lifecycle_config_arns = [
    #   #   "arn:aws:sagemaker:us-east-1:123456789012:studio-lifecycle-config/example"
    #   # ]
    #
    #   # (Optional) A list of custom SageMaker images that are configured to run as a JupyterLab app.
    #   # custom_image {
    #   #   # (Required) The name of the App Image Config.
    #   #   app_image_config_name = "example-config"
    #   #
    #   #   # (Required) The name of the Custom Image.
    #   #   image_name = "example-image"
    #   #
    #   #   # (Optional) The version number of the Custom Image.
    #   #   # image_version_number = 1
    #   # }
    #
    #   # (Optional) A list of Git repositories that SageMaker automatically displays to users for cloning.
    #   # code_repository {
    #   #   # (Optional) The URL of the Git repository.
    #   #   repository_url = "https://github.com/example/repo.git"
    #   # }
    #
    #   # (Optional) Indicates whether idle shutdown is activated for JupyterLab applications.
    #   # app_lifecycle_management {
    #   #   idle_settings {
    #   #     # (Optional) The time that SageMaker waits after the application becomes idle before shutting it down.
    #   #     # Valid values: 60 to 525600 minutes (1 min to 365 days)
    #   #     idle_timeout_in_minutes = 60
    #   #
    #   #     # (Optional) Indicates whether idle shutdown is activated for the application type.
    #   #     # Valid values: ENABLED, DISABLED
    #   #     lifecycle_management = "ENABLED"
    #   #
    #   #     # (Optional) The maximum value in minutes that custom idle shutdown can be set to by the user.
    #   #     # Valid values: 60 to 525600
    #   #     # max_idle_timeout_in_minutes = 1440
    #   #
    #   #     # (Optional) The minimum value in minutes that custom idle shutdown can be set to by the user.
    #   #     # Valid values: 60 to 525600
    #   #     # min_idle_timeout_in_minutes = 60
    #   #   }
    #   # }
    #
    #   # (Optional) The lifecycle configuration that runs before the default lifecycle configuration.
    #   # built_in_lifecycle_config_arn = "arn:aws:sagemaker:us-east-1:123456789012:studio-lifecycle-config/example"
    #
    #   # (Optional) Configuration for EMR integration.
    #   # emr_settings {
    #   #   # (Optional) IAM roles that the execution role of SageMaker can assume.
    #   #   # assumable_role_arns = ["arn:aws:iam::123456789012:role/EMRAssumeRole"]
    #   #
    #   #   # (Optional) IAM roles used by EMR cluster instances or job execution environments.
    #   #   # execution_role_arns = ["arn:aws:iam::123456789012:role/EMRExecutionRole"]
    #   # }
    # }

    # (Optional) The Jupyter server's app settings (for Studio Classic).
    # jupyter_server_app_settings {
    #   # Similar structure to jupyter_lab_app_settings
    #   default_resource_spec {
    #     instance_type = "ml.t3.medium"
    #   }
    # }

    # (Optional) The kernel gateway app settings.
    # kernel_gateway_app_settings {
    #   # Similar structure to jupyter_lab_app_settings
    #   default_resource_spec {
    #     instance_type = "ml.t3.medium"
    #   }
    #
    #   # (Optional) A list of custom SageMaker images that are configured to run as a KernelGateway app.
    #   # custom_image {
    #   #   app_image_config_name = "example-config"
    #   #   image_name            = "example-image"
    #   # }
    #
    #   # (Optional) Lifecycle configuration ARNs.
    #   # lifecycle_config_arns = []
    # }

    # (Optional) The Code Editor application settings.
    # code_editor_app_settings {
    #   default_resource_spec {
    #     instance_type = "ml.t3.medium"
    #   }
    #
    #   # (Optional) Lifecycle configuration ARNs.
    #   # lifecycle_config_arns = []
    #
    #   # (Optional) A list of custom SageMaker images for Code Editor.
    #   # custom_image {
    #   #   app_image_config_name = "example-config"
    #   #   image_name            = "example-image"
    #   # }
    #
    #   # (Optional) Idle shutdown configuration.
    #   # app_lifecycle_management {
    #   #   idle_settings {
    #   #     idle_timeout_in_minutes = 60
    #   #     lifecycle_management    = "ENABLED"
    #   #   }
    #   # }
    #
    #   # (Optional) Built-in lifecycle configuration ARN.
    #   # built_in_lifecycle_config_arn = ""
    # }

    # (Optional) The TensorBoard app settings.
    # tensor_board_app_settings {
    #   default_resource_spec {
    #     instance_type = "ml.t3.medium"
    #   }
    # }

    # (Optional) The RSession app settings.
    # r_session_app_settings {
    #   default_resource_spec {
    #     instance_type = "ml.t3.medium"
    #   }
    #
    #   # (Optional) A list of custom SageMaker images for RSession.
    #   # custom_image {
    #   #   app_image_config_name = "example-config"
    #   #   image_name            = "example-image"
    #   # }
    # }

    # -------------------------------------------------------------------------
    # Optional: Canvas Application Settings
    # -------------------------------------------------------------------------

    # (Optional) The Canvas app settings for no-code ML.
    # canvas_app_settings {
    #   # (Optional) The model deployment settings.
    #   # direct_deploy_settings {
    #   #   # (Optional) Describes whether model deployment permissions are enabled or disabled.
    #   #   # Valid values: ENABLED, DISABLED
    #   #   status = "ENABLED"
    #   # }
    #
    #   # (Optional) Time series forecast settings.
    #   # time_series_forecasting_settings {
    #   #   # (Optional) The IAM role that Canvas passes to Amazon Forecast.
    #   #   # amazon_forecast_role_arn = "arn:aws:iam::123456789012:role/ForecastRole"
    #   #
    #   #   # (Optional) Describes whether time series forecasting is enabled or disabled.
    #   #   # Valid values: ENABLED, DISABLED
    #   #   # status = "ENABLED"
    #   # }
    #
    #   # (Optional) The model registry settings.
    #   # model_register_settings {
    #   #   # (Optional) ARN of the SageMaker model registry account (for cross-account registration).
    #   #   # cross_account_model_register_role_arn = ""
    #   #
    #   #   # (Optional) Describes whether the integration to the model registry is enabled or disabled.
    #   #   # Valid values: ENABLED, DISABLED
    #   #   # status = "ENABLED"
    #   # }
    #
    #   # (Optional) The settings for document querying with Amazon Kendra.
    #   # kendra_settings {
    #   #   # (Optional) Describes whether the document querying feature is enabled or disabled.
    #   #   # Valid values: ENABLED, DISABLED
    #   #   status = "ENABLED"
    #   # }
    #
    #   # (Optional) The workspace settings for Canvas.
    #   # workspace_settings {
    #   #   # (Optional) The Amazon S3 bucket used to store artifacts generated by Canvas.
    #   #   # s3_artifact_path = "s3://my-bucket/canvas-artifacts/"
    #   #
    #   #   # (Optional) The KMS encryption key ID for artifacts in S3.
    #   #   # s3_kms_key_id = "arn:aws:kms:us-east-1:123456789012:key/example"
    #   # }
    #
    #   # (Optional) Settings for connecting to external data sources with OAuth.
    #   # identity_provider_oauth_settings {
    #   #   # (Optional) The name of the data source.
    #   #   # Valid values: SalesforceGenie, Snowflake
    #   #   data_source_name = "Snowflake"
    #   #
    #   #   # (Optional) The ARN of an AWS Secrets Manager secret storing the credentials.
    #   #   # secret_arn = "arn:aws:secretsmanager:us-east-1:123456789012:secret:example"
    #   #
    #   #   # (Optional) Describes whether OAuth is enabled or disabled.
    #   #   # Valid values: ENABLED, DISABLED
    #   #   # status = "ENABLED"
    #   # }
    #
    #   # (Optional) Settings for running Amazon EMR Serverless jobs in Canvas.
    #   # emr_serverless_settings {
    #   #   # (Optional) The ARN of the IAM role assumed for running EMR Serverless jobs.
    #   #   # execution_role_arn = "arn:aws:iam::123456789012:role/EMRServerlessRole"
    #   #
    #   #   # (Optional) Describes whether EMR Serverless job capabilities are enabled or disabled.
    #   #   # Valid values: ENABLED, DISABLED
    #   #   # status = "ENABLED"
    #   # }
    # }

    # -------------------------------------------------------------------------
    # Optional: RStudio Configuration
    # -------------------------------------------------------------------------

    # (Optional) A collection of settings that configure user interaction with the RStudioServerPro app.
    # r_studio_server_pro_app_settings {
    #   # (Optional) Indicates whether the current user has access to the RStudioServerPro app.
    #   # Valid values: ENABLED, DISABLED
    #   access_status = "ENABLED"
    #
    #   # (Optional) The level of permissions that the user has within the RStudioServerPro app.
    #   # Valid values: R_STUDIO_USER, R_STUDIO_ADMIN
    #   # R_STUDIO_ADMIN allows access to the RStudio Administrative Dashboard.
    #   user_group = "R_STUDIO_USER"
    # }

    # -------------------------------------------------------------------------
    # Optional: Storage and File System Settings
    # -------------------------------------------------------------------------

    # (Optional) The storage settings for a private space.
    # space_storage_settings {
    #   # (Optional) The default EBS storage settings for a private space.
    #   default_ebs_storage_settings {
    #     # (Required) The default size of the EBS storage volume for a private space (in GB).
    #     default_ebs_volume_size_in_gb = 5
    #
    #     # (Required) The maximum size of the EBS storage volume for a private space (in GB).
    #     maximum_ebs_volume_size_in_gb = 100
    #   }
    # }

    # (Optional) Settings for assigning a custom file system to a user profile.
    # Permitted users can access this file system in SageMaker Studio.
    # custom_file_system_config {
    #   # (Optional) EFS file system configuration.
    #   efs_file_system_config {
    #     # (Required) The ID of your Amazon EFS file system.
    #     file_system_id = "fs-12345678"
    #
    #     # (Required) The path to the file system directory that is accessible in Studio.
    #     # Permitted users can access only this directory and below.
    #     file_system_path = "/home"
    #   }
    # }

    # (Optional) Details about the POSIX identity that is used for file system operations.
    # custom_posix_user_config {
    #   # (Optional) The POSIX group ID.
    #   gid = 1000
    #
    #   # (Optional) The POSIX user ID.
    #   uid = 1000
    # }

    # (Optional) Indicates whether auto-mounting of an EFS volume is supported for the user profile.
    # Valid values: Enabled, Disabled, DefaultAsDomain
    # The DefaultAsDomain value is only supported for user profiles (not for spaces).
    # auto_mount_home_efs = "Enabled"

    # -------------------------------------------------------------------------
    # Optional: Studio Settings
    # -------------------------------------------------------------------------

    # (Optional) The default experience that the user is directed to when accessing the domain.
    # - "studio::": Indicates that Studio is the default experience (requires StudioWebPortal = ENABLED)
    # - "app:JupyterServer:": Indicates that Studio Classic is the default experience
    # default_landing_uri = "studio::"

    # (Optional) Whether the user can access Studio.
    # Valid values: ENABLED, DISABLED
    # If set to DISABLED, the user cannot access Studio, even if that is the default experience for the domain.
    # studio_web_portal = "ENABLED"

    # (Optional) The Studio Web Portal settings.
    # studio_web_portal_settings {
    #   # (Optional) The Applications supported in Studio that are hidden from the Studio left navigation pane.
    #   # hidden_app_types = ["JupyterServer"]
    #
    #   # (Optional) The instance types you are hiding from the Studio user interface.
    #   # hidden_instance_types = ["ml.t3.large"]
    #
    #   # (Optional) The machine learning tools that are hidden from the Studio left navigation pane.
    #   # hidden_ml_tools = ["DataWrangler"]
    # }

    # -------------------------------------------------------------------------
    # Optional: Sharing Settings
    # -------------------------------------------------------------------------

    # (Optional) The sharing settings.
    # sharing_settings {
    #   # (Optional) Whether to include the notebook cell output when sharing the notebook.
    #   # Valid values: Allowed, Disabled
    #   notebook_output_option = "Disabled"
    #
    #   # (Optional) When notebook_output_option is Allowed, the KMS encryption key ID used to encrypt the output.
    #   # s3_kms_key_id = "arn:aws:kms:us-east-1:123456789012:key/example"
    #
    #   # (Optional) When notebook_output_option is Allowed, the S3 bucket used to save the notebook cell output.
    #   # s3_output_path = "s3://my-bucket/notebook-outputs/"
    # }
  }

  # ----------------------------------------------------------------------------
  # Optional Block: default_space_settings
  # ----------------------------------------------------------------------------
  # The default space settings that apply to all spaces in the domain.

  # default_space_settings {
  #   # (Required) The execution role for the space.
  #   execution_role = "arn:aws:iam::123456789012:role/SageMakerExecutionRole"
  #
  #   # (Optional) The security groups for the Amazon Virtual Private Cloud that the space uses for communication.
  #   # security_groups = ["sg-12345678"]
  #
  #   # (Optional) The Jupyter server's app settings.
  #   # jupyter_server_app_settings {
  #   #   default_resource_spec {
  #   #     instance_type = "ml.t3.medium"
  #   #   }
  #   # }
  #
  #   # (Optional) The kernel gateway app settings.
  #   # kernel_gateway_app_settings {
  #   #   default_resource_spec {
  #   #     instance_type = "ml.t3.medium"
  #   #   }
  #   # }
  #
  #   # (Optional) The settings for the JupyterLab application.
  #   # jupyter_lab_app_settings {
  #   #   default_resource_spec {
  #   #     instance_type = "ml.t3.medium"
  #   #   }
  #   # }
  #
  #   # (Optional) The storage settings for a private space.
  #   # space_storage_settings {
  #   #   default_ebs_storage_settings {
  #   #     default_ebs_volume_size_in_gb = 5
  #   #     maximum_ebs_volume_size_in_gb = 100
  #   #   }
  #   # }
  #
  #   # (Optional) Details about the POSIX identity used for file system operations.
  #   # custom_posix_user_config {
  #   #   gid = 1000
  #   #   uid = 1000
  #   # }
  #
  #   # (Optional) Settings for assigning a custom file system to a space.
  #   # custom_file_system_config {
  #   #   efs_file_system_config {
  #   #     file_system_id   = "fs-12345678"
  #   #     file_system_path = "/home"
  #   #   }
  #   # }
  # }

  # ----------------------------------------------------------------------------
  # Optional Arguments
  # ----------------------------------------------------------------------------

  # (Optional) Specifies the VPC used for non-EFS traffic.
  # Valid values: PublicInternetOnly (default), VpcOnly
  # - PublicInternetOnly: Applications access the internet via public IPs
  # - VpcOnly: Applications access the internet via VPC (requires NAT Gateway)
  # app_network_access_type = "PublicInternetOnly"

  # (Optional) The entity that creates and manages the required security groups
  # for inter-app communication in VPCOnly mode.
  # Valid values: Service, Customer
  # - Service: AWS manages the security groups
  # - Customer: You manage the security groups
  # app_security_group_management = "Service"

  # (Optional) The AWS KMS customer managed CMK used to encrypt the EFS volume
  # attached to the domain.
  # kms_key_id = "arn:aws:kms:us-east-1:123456789012:key/example"

  # (Optional) Region where this resource will be managed.
  # Defaults to the Region set in the provider configuration.
  # region = "us-east-1"

  # (Optional) Indicates whether custom tag propagation is supported for the domain.
  # Valid values: ENABLED, DISABLED (default)
  # tag_propagation = "DISABLED"

  # ----------------------------------------------------------------------------
  # Optional Block: domain_settings
  # ----------------------------------------------------------------------------
  # The domain settings for advanced configurations.

  # domain_settings {
  #   # (Optional) The configuration for attaching a SageMaker user profile name
  #   # to the execution role as a sts:SourceIdentity key.
  #   # Valid values: USER_PROFILE_NAME, DISABLED
  #   # execution_role_identity_config = "USER_PROFILE_NAME"
  #
  #   # (Optional) The security groups for the Amazon Virtual Private Cloud
  #   # that the Domain uses for communication between Domain-level apps and user apps.
  #   # security_group_ids = ["sg-12345678"]
  #
  #   # (Optional) A collection of settings that configure the domain's Docker interaction.
  #   # docker_settings {
  #   #   # (Optional) Indicates whether the domain can access Docker.
  #   #   # Valid values: ENABLED, DISABLED
  #   #   enable_docker_access = "ENABLED"
  #   #
  #   #   # (Optional) The list of AWS accounts that are trusted when the domain is created in VPC-only mode.
  #   #   # vpc_only_trusted_accounts = ["123456789012"]
  #   # }
  #
  #   # (Optional) A collection of settings that configure the RStudioServerPro Domain-level app.
  #   # r_studio_server_pro_domain_settings {
  #   #   # (Required) The ARN of the execution role for the RStudioServerPro Domain-level app.
  #   #   domain_execution_role_arn = "arn:aws:iam::123456789012:role/RStudioExecutionRole"
  #   #
  #   #   # (Optional) A URL pointing to an RStudio Connect server.
  #   #   # r_studio_connect_url = "https://rstudio-connect.example.com"
  #   #
  #   #   # (Optional) A URL pointing to an RStudio Package Manager server.
  #   #   # r_studio_package_manager_url = "https://packagemanager.example.com"
  #   #
  #   #   # (Optional) The default instance type and image configuration.
  #   #   # default_resource_spec {
  #   #   #   instance_type = "system"
  #   #   # }
  #   # }
  # }

  # ----------------------------------------------------------------------------
  # Optional Block: retention_policy
  # ----------------------------------------------------------------------------
  # The retention policy for this domain, which specifies whether resources
  # will be retained after the Domain is deleted. By default, all resources are retained.

  # retention_policy {
  #   # (Optional) The retention policy for data stored on an Amazon EFS volume.
  #   # Valid values: Retain (default), Delete
  #   # - Retain: EFS volume is retained when the domain is deleted
  #   # - Delete: EFS volume is deleted when the domain is deleted
  #   home_efs_file_system = "Retain"
  # }

  # ----------------------------------------------------------------------------
  # Tags
  # ----------------------------------------------------------------------------

  # (Optional) A map of tags to assign to the resource.
  tags = {
    Name        = "example-sagemaker-domain"
    Environment = "development"
    ManagedBy   = "terraform"
  }
}

# ============================================================================
# Outputs
# ============================================================================

output "sagemaker_domain_id" {
  description = "The ID of the Domain"
  value       = aws_sagemaker_domain.example.id
}

output "sagemaker_domain_arn" {
  description = "The Amazon Resource Name (ARN) assigned by AWS to this Domain"
  value       = aws_sagemaker_domain.example.arn
}

output "sagemaker_domain_url" {
  description = "The domain's URL"
  value       = aws_sagemaker_domain.example.url
}

output "home_efs_file_system_id" {
  description = "The ID of the Amazon Elastic File System (EFS) managed by this Domain"
  value       = aws_sagemaker_domain.example.home_efs_file_system_id
}

output "security_group_id_for_domain_boundary" {
  description = "The ID of the security group that authorizes traffic between the RSessionGateway apps and the RStudioServerPro app"
  value       = aws_sagemaker_domain.example.security_group_id_for_domain_boundary
}

output "single_sign_on_application_arn" {
  description = "The ARN of the application managed by SageMaker in IAM Identity Center (only for domains created after September 19, 2023)"
  value       = aws_sagemaker_domain.example.single_sign_on_application_arn
}

output "single_sign_on_managed_application_instance_id" {
  description = "The SSO managed application instance ID"
  value       = aws_sagemaker_domain.example.single_sign_on_managed_application_instance_id
}

# ============================================================================
# Example: Basic Usage with IAM Authentication
# ============================================================================
# This example creates a basic SageMaker Domain with IAM authentication.
#
# Prerequisites:
# - VPC with private subnets
# - IAM role with SageMaker execution permissions
# - Security groups for network access
#
# Usage:
#   terraform init
#   terraform plan
#   terraform apply

# ============================================================================
# Example: Advanced Configuration with Custom Images
# ============================================================================
# For advanced scenarios with custom images, configure the following:
#
# 1. Create a SageMaker Image:
#    resource "aws_sagemaker_image" "custom" {
#      image_name = "custom-image"
#      role_arn   = aws_iam_role.sagemaker.arn
#    }
#
# 2. Create an App Image Config:
#    resource "aws_sagemaker_app_image_config" "custom" {
#      app_image_config_name = "custom-config"
#      kernel_gateway_image_config {
#        kernel_spec {
#          name = "python3"
#        }
#      }
#    }
#
# 3. Reference in domain's default_user_settings:
#    custom_image {
#      app_image_config_name = aws_sagemaker_app_image_config.custom.app_image_config_name
#      image_name            = aws_sagemaker_image.custom.id
#    }

# ============================================================================
# Important Notes
# ============================================================================
# 1. Network Configuration:
#    - Use VpcOnly for app_network_access_type in production for better security
#    - Ensure subnets have NAT Gateway access when using VpcOnly mode
#    - Configure security groups to allow necessary communication
#
# 2. Authentication:
#    - IAM mode: Direct AWS IAM authentication
#    - SSO mode: Requires AWS IAM Identity Center configuration
#
# 3. Storage:
#    - EFS volume is automatically created and managed by the domain
#    - Use kms_key_id to encrypt the EFS volume with a custom KMS key
#    - Configure retention_policy to control EFS behavior on domain deletion
#
# 4. Cost Optimization:
#    - Configure idle shutdown settings to automatically stop inactive applications
#    - Use smaller instance types for default_resource_spec when appropriate
#    - Monitor usage and adjust resource allocations accordingly
#
# 5. Deletion:
#    - Before deleting a domain, all associated user profiles and apps must be deleted
#    - Set retention_policy to "Delete" if you want the EFS volume deleted automatically
#    - Backup important data from EFS before domain deletion if needed
#
# 6. Updates:
#    - Changes to certain attributes (vpc_id, subnet_ids, kms_key_id) require replacement
#    - User settings changes apply to new apps, existing apps are not affected
#    - Test changes in a non-production environment first
