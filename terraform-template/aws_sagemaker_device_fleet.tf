# ================================================================================
# AWS SageMaker Device Fleet
# ================================================================================
# Provides a SageMaker AI Device Fleet resource.
#
# SageMaker Edge Manager enables you to manage machine learning models on fleets
# of edge devices such as smart cameras, robots, personal computers, and mobile
# devices. Device fleets are logical groupings of edge devices used for data
# collection, model deployment, and performance monitoring.
#
# Documentation: https://docs.aws.amazon.com/sagemaker/latest/dg/edge-device-fleet.html
# Provider Version: 6.28.0
# ================================================================================

resource "aws_sagemaker_device_fleet" "example" {
  # --------------------------------------------------------------------------------
  # Required Arguments
  # --------------------------------------------------------------------------------

  # device_fleet_name - (Required) The name of the Device Fleet (must be unique).
  #
  # The device fleet name must be unique within your AWS account and region.
  # This name is used to identify and manage the fleet of edge devices.
  #
  # Example: "production-camera-fleet", "iot-sensor-fleet"
  device_fleet_name = "example-device-fleet"

  # role_arn - (Required) The Amazon Resource Name (ARN) that has access to AWS
  # Internet of Things (IoT).
  #
  # This IAM role allows SageMaker Edge Manager to interact with AWS IoT services.
  # The role must have permissions to create and manage IoT role aliases, and
  # access to the S3 bucket specified in output_config.
  #
  # Required permissions:
  # - iot:CreateRoleAlias
  # - iot:DescribeRoleAlias
  # - iot:UpdateRoleAlias
  # - s3:PutObject
  # - s3:GetObject
  #
  # Example: "arn:aws:iam::123456789012:role/SageMakerEdgeManagerRole"
  role_arn = aws_iam_role.example.arn

  # output_config - (Required) Specifies details about the repository for storing
  # model output and device data.
  #
  # The output configuration defines where SageMaker Edge Manager stores:
  # - Sample input/output data captured from edge devices
  # - Model predictions and inference results
  # - Device telemetry and heartbeat data
  #
  # This data can be used for model monitoring, drift detection, and retraining.
  output_config {
    # s3_output_location - (Required) The Amazon Simple Storage (S3) bucket URI.
    #
    # Specify the S3 location where device data and model outputs will be stored.
    # The URI must include the s3:// prefix and can include a prefix/path.
    # The IAM role specified in role_arn must have write access to this bucket.
    #
    # Format: s3://bucket-name/prefix/
    # Example: s3://my-sagemaker-edge-bucket/device-data/
    s3_output_location = "s3://${aws_s3_bucket.example.bucket}/device-fleet-output/"

    # kms_key_id - (Optional) The AWS Key Management Service (AWS KMS) key that
    # Amazon SageMaker AI uses to encrypt data on the storage volume after
    # compilation job.
    #
    # If you don't provide a KMS key ID, Amazon SageMaker AI uses the default
    # KMS key for Amazon S3 for your role's account. For enhanced security and
    # compliance, specify a customer-managed KMS key.
    #
    # The KMS key must be in the same region as the S3 bucket and the device fleet.
    #
    # Example: "arn:aws:kms:us-west-2:123456789012:key/12345678-1234-1234-1234-123456789012"
    # kms_key_id = aws_kms_key.example.arn
  }

  # --------------------------------------------------------------------------------
  # Optional Arguments
  # --------------------------------------------------------------------------------

  # description - (Optional) A description of the fleet.
  #
  # Provide a human-readable description to help identify the purpose and scope
  # of this device fleet. Maximum length is 800 characters.
  #
  # Example: "Production fleet for smart camera devices in retail stores"
  description = "Example SageMaker Edge device fleet for managing ML models on IoT devices"

  # enable_iot_role_alias - (Optional) Whether to create an AWS IoT Role Alias
  # during device fleet creation.
  #
  # When set to true, SageMaker automatically creates an IoT role alias that
  # devices can use to authenticate and obtain temporary credentials. The role
  # alias name follows the pattern: "SageMakerEdge-{DeviceFleetName}".
  #
  # IoT role aliases enable devices to assume the IAM role specified in role_arn
  # and access AWS resources securely without embedding long-term credentials.
  #
  # Default: false
  # Example: true
  enable_iot_role_alias = true

  # region - (Optional) Region where this resource will be managed.
  #
  # Defaults to the Region set in the provider configuration. Specify this if
  # you need to explicitly set the region for this resource.
  #
  # Example: "us-west-2", "eu-west-1"
  # region = "us-west-2"

  # tags - (Optional) A map of tags to assign to the resource.
  #
  # Tags help organize and identify resources for cost allocation, access control,
  # and operational management. If configured with a provider default_tags
  # configuration block, tags with matching keys will overwrite those defined
  # at the provider-level.
  #
  # Best practices:
  # - Use consistent tagging strategy across all resources
  # - Include tags for environment, team, cost center, and project
  # - Maximum of 50 tags per resource
  tags = {
    Name        = "example-device-fleet"
    Environment = "production"
    ManagedBy   = "terraform"
    Purpose     = "edge-ml-deployment"
  }

  # --------------------------------------------------------------------------------
  # Computed Attributes (Read-Only)
  # --------------------------------------------------------------------------------
  # These attributes are exported and can be referenced but cannot be set:
  #
  # - id: The name of the Device Fleet (same as device_fleet_name)
  # - arn: The Amazon Resource Name (ARN) assigned by AWS to this Device Fleet
  #   Format: arn:aws:sagemaker:region:account-id:device-fleet/fleet-name
  # - iot_role_alias: The IoT role alias created for this fleet (if enable_iot_role_alias is true)
  #   Format: SageMakerEdge-{DeviceFleetName}
  # - tags_all: A map of tags assigned to the resource, including those inherited
  #   from the provider default_tags configuration block
  # --------------------------------------------------------------------------------
}

# ================================================================================
# Outputs
# ================================================================================

output "device_fleet_arn" {
  description = "The ARN of the SageMaker device fleet"
  value       = aws_sagemaker_device_fleet.example.arn
}

output "device_fleet_id" {
  description = "The ID (name) of the SageMaker device fleet"
  value       = aws_sagemaker_device_fleet.example.id
}

output "iot_role_alias" {
  description = "The IoT role alias created for this device fleet"
  value       = aws_sagemaker_device_fleet.example.iot_role_alias
}

# ================================================================================
# Additional Notes
# ================================================================================
#
# Device Fleet Setup Process:
# 1. Create IAM roles for SageMaker and AWS IoT with appropriate permissions
# 2. Create an S3 bucket for storing device data and model outputs
# 3. Create the device fleet using this resource
# 4. Register individual devices to the fleet using aws_sagemaker_device
# 5. Deploy the SageMaker Edge Agent on your edge devices
# 6. Deploy compiled models to devices using SageMaker Edge Manager
#
# Prerequisites:
# - An AWS account with SageMaker and IoT services enabled
# - IAM role with permissions for SageMaker, IoT, and S3
# - S3 bucket for storing device data
# - Models compiled with SageMaker Neo for target device hardware
#
# Best Practices:
# - Use IoT role aliases (enable_iot_role_alias = true) for secure device authentication
# - Encrypt data at rest using customer-managed KMS keys
# - Implement least-privilege IAM policies for the fleet role
# - Use consistent naming conventions for device fleet names
# - Tag resources appropriately for cost tracking and organization
# - Monitor device heartbeats and model performance through CloudWatch
# - Regularly update models on devices based on performance metrics
#
# Integration with Other Services:
# - AWS IoT Core: For device authentication and communication
# - SageMaker Neo: For optimizing models for edge deployment
# - Amazon S3: For storing device data and model artifacts
# - AWS KMS: For encrypting data at rest
# - CloudWatch: For monitoring device and model performance
# - AWS IoT Greengrass: For deploying and managing models on edge devices
#
# Security Considerations:
# - Use X.509 certificates for device authentication
# - Enable encryption for data in transit and at rest
# - Implement proper IAM policies with least privilege access
# - Regularly rotate certificates and credentials
# - Monitor and audit device access and activities
# - Use VPC endpoints for private connectivity where applicable
#
# Cost Optimization:
# - Monitor data transfer costs from edge devices to S3
# - Use S3 lifecycle policies to manage data retention
# - Optimize model sampling frequency to reduce data volume
# - Consider regional deployment to minimize cross-region data transfer
#
# Related Resources:
# - aws_iam_role: IAM role for SageMaker Edge Manager
# - aws_s3_bucket: S3 bucket for device data storage
# - aws_kms_key: KMS key for encrypting device data
# - aws_iot_thing: IoT thing objects for individual devices
# - aws_iot_certificate: X.509 certificates for device authentication
# - aws_iot_policy: IoT policies for device authorization
#
# ================================================================================
