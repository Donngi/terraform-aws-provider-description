# Terraform AWS Rekognition Project Resource Template
# AWS Provider Version: 6.28.0
# Resource: aws_rekognition_project
# Documentation: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rekognition_project

# ============================================================================
# Resource Overview
# ============================================================================
# This resource manages an AWS Rekognition Project, which is used to create
# and manage custom machine learning models for:
# - CUSTOM_LABELS: Training custom image classification and object detection models
# - CONTENT_MODERATION: Custom content moderation models with automatic retraining
#
# Key Features:
# - Supports both Custom Labels and Content Moderation features
# - Optional automatic model retraining for Content Moderation projects
# - Regional resource deployment
# - Tag-based resource organization

# ============================================================================
# Basic Example: Custom Labels Project
# ============================================================================
resource "aws_rekognition_project" "custom_labels_example" {
  # Required: Project name (must be unique within your AWS account)
  name = "my-custom-labels-project"

  # Optional: Feature type (defaults to CUSTOM_LABELS)
  # Valid values: "CUSTOM_LABELS" | "CONTENT_MODERATION"
  feature = "CUSTOM_LABELS"

  # Note: Do NOT set auto_update when feature is "CUSTOM_LABELS"
  # auto_update is only valid for CONTENT_MODERATION projects

  # Optional: Tags for resource organization
  tags = {
    Environment = "development"
    Project     = "image-classification"
    ManagedBy   = "terraform"
  }
}

# ============================================================================
# Example: Content Moderation Project with Auto-Update
# ============================================================================
resource "aws_rekognition_project" "content_moderation_example" {
  # Required: Project name
  name = "my-content-moderation-project"

  # Required for CONTENT_MODERATION: Feature type
  feature = "CONTENT_MODERATION"

  # Required when feature is CONTENT_MODERATION: Enable/disable automatic retraining
  # Valid values: "ENABLED" | "DISABLED"
  # When enabled, the model automatically retrains with new data
  auto_update = "ENABLED"

  # Optional: Specify deployment region
  # Defaults to provider region if not specified
  region = "us-east-1"

  tags = {
    Environment = "production"
    Feature     = "content-safety"
    AutoUpdate  = "enabled"
  }
}

# ============================================================================
# Complete Configuration Example
# ============================================================================
resource "aws_rekognition_project" "complete" {
  # ┌─────────────────────────────────────────────────────────────────────┐
  # │ REQUIRED ARGUMENTS                                                   │
  # └─────────────────────────────────────────────────────────────────────┘

  # name - (Required) The name of the Rekognition project
  # - Must be unique within your AWS account
  # - Used to identify the project in API calls and console
  # - Cannot be changed after creation (forces new resource)
  name = "example-rekognition-project"

  # ┌─────────────────────────────────────────────────────────────────────┐
  # │ OPTIONAL ARGUMENTS                                                   │
  # └─────────────────────────────────────────────────────────────────────┘

  # feature - (Optional) The feature being customized
  # - Valid values: "CUSTOM_LABELS" | "CONTENT_MODERATION"
  # - Default: "CUSTOM_LABELS"
  # - CUSTOM_LABELS: For custom image classification and object detection
  # - CONTENT_MODERATION: For custom content moderation models
  feature = "CUSTOM_LABELS"

  # auto_update - (Optional) Automatic retraining configuration
  # - Valid values: "ENABLED" | "DISABLED"
  # - MUST be set when feature is "CONTENT_MODERATION"
  # - MUST NOT be set when feature is "CUSTOM_LABELS"
  # - When enabled, automatically retrains model with new data
  # auto_update = "ENABLED"  # Uncomment only for CONTENT_MODERATION

  # region - (Optional) AWS region for resource management
  # - Defaults to the region configured in the AWS provider
  # - Specify to deploy in a different region than provider default
  # - Follows AWS regional endpoint structure
  # region = "us-west-2"

  # tags - (Optional) Resource tags for organization and cost allocation
  # - Map of string key-value pairs
  # - Merged with provider default_tags if configured
  # - Supports standard AWS tagging features
  tags = {
    Name        = "example-rekognition-project"
    Environment = "production"
    Application = "ml-inference"
    CostCenter  = "engineering"
    ManagedBy   = "terraform"
  }
}

# ============================================================================
# Exported Attributes (Read-Only)
# ============================================================================
# These attributes are computed by AWS and available after resource creation:
#
# arn - Amazon Resource Name (ARN) of the Rekognition project
#   Format: arn:aws:rekognition:region:account-id:project/project-name/creation-timestamp
#   Example: arn:aws:rekognition:us-east-1:123456789012:project/my-project/1234567890123
#
# tags_all - Complete map of tags including provider default_tags
#   Combines resource-specific tags with provider-level default tags

# ============================================================================
# Usage Examples with Outputs
# ============================================================================

# Output the project ARN for use in other resources
output "project_arn" {
  description = "ARN of the Rekognition project"
  value       = aws_rekognition_project.complete.arn
}

# Output the project name
output "project_name" {
  description = "Name of the Rekognition project"
  value       = aws_rekognition_project.complete.name
}

# Output all tags including defaults
output "all_tags" {
  description = "All tags applied to the project"
  value       = aws_rekognition_project.complete.tags_all
}

# ============================================================================
# Important Notes and Best Practices
# ============================================================================
# 1. Feature Selection:
#    - Choose CUSTOM_LABELS for image classification and object detection
#    - Choose CONTENT_MODERATION for content safety and moderation use cases
#
# 2. Auto-Update Configuration:
#    - Only applicable to CONTENT_MODERATION projects
#    - MUST be specified when feature = "CONTENT_MODERATION"
#    - MUST NOT be specified when feature = "CUSTOM_LABELS"
#    - Terraform will fail if this constraint is violated
#
# 3. Resource Lifecycle:
#    - Project name cannot be changed after creation
#    - Changing name forces resource replacement
#    - Ensure proper backup of trained models before replacement
#
# 4. Regional Considerations:
#    - Rekognition service availability varies by region
#    - Check AWS documentation for regional availability
#    - Data residency requirements may dictate region selection
#
# 5. Cost Management:
#    - Charges apply for training, storage, and inference
#    - Use tags for cost allocation and tracking
#    - Consider project lifecycle and cleanup unused projects
#
# 6. Project Dependencies:
#    - Projects are containers for dataset versions and model versions
#    - Training datasets must be created after project creation
#    - Models are trained using dataset versions within the project
#
# 7. IAM Permissions Required:
#    - rekognition:CreateProject (creation)
#    - rekognition:DescribeProjects (read/refresh)
#    - rekognition:DeleteProject (deletion)
#    - rekognition:TagResource (tagging)
#    - rekognition:UntagResource (tag removal)
#
# 8. Integration Pattern:
#    After creating a project, typical workflow includes:
#    - Create dataset versions with training/testing data
#    - Train models using the dataset versions
#    - Deploy trained models for inference
#    - Monitor model performance and retrain as needed

# ============================================================================
# Related Resources
# ============================================================================
# Consider using these related resources for complete ML workflow:
# - aws_s3_bucket: Store training images and datasets
# - aws_iam_role: Service role for Rekognition access to S3
# - aws_cloudwatch_log_group: Monitor training and inference logs
# - aws_kms_key: Encrypt project data and model artifacts

# ============================================================================
# Troubleshooting
# ============================================================================
# Common Issues:
#
# 1. "auto_update cannot be specified for CUSTOM_LABELS":
#    - Remove auto_update argument or change feature to CONTENT_MODERATION
#
# 2. "auto_update is required for CONTENT_MODERATION":
#    - Add auto_update = "ENABLED" or "DISABLED" to configuration
#
# 3. Project creation fails:
#    - Verify Rekognition service is available in target region
#    - Check IAM permissions for rekognition:CreateProject
#    - Ensure project name is unique within account
#
# 4. Tags not appearing:
#    - Check provider default_tags configuration
#    - Use tags_all to see complete tag set including defaults
