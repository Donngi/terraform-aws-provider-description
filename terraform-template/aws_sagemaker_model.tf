################################################################################
# AWS SageMaker Model
################################################################################
# Amazon SageMaker AI Model resource for deploying machine learning models
# to hosting services for real-time or batch inference.
#
# Key Concepts:
# - Model: Defines the Docker container image and model artifacts for inference
# - Execution Role: IAM role that SageMaker assumes to access model artifacts and ECR images
# - Primary Container: The main container for single-model endpoints
# - Multi-Container: Support for inference pipelines with multiple containers
# - VPC Configuration: Private network configuration for secure inference
#
# Use Cases:
# - Real-time inference endpoints for low-latency predictions
# - Batch transform jobs for offline inference
# - Multi-model endpoints for hosting multiple models on a single instance
# - Inference pipelines for pre/post-processing with serial container execution
#
# AWS Documentation:
# - Model Deployment: https://docs.aws.amazon.com/sagemaker/latest/dg/deploy-model.html
# - Custom Inference Code: https://docs.aws.amazon.com/sagemaker/latest/dg/your-algorithms-inference-code.html
# - VPC Configuration: https://docs.aws.amazon.com/sagemaker/latest/dg/host-vpc.html
################################################################################

resource "aws_sagemaker_model" "example" {
  ################################################################################
  # Basic Configuration
  ################################################################################

  # Name of the model (must be unique within the AWS account and region)
  # - If omitted, Terraform will assign a random, unique name
  # - Must follow SageMaker naming constraints: max 63 characters, alphanumeric and hyphens
  # - Used when creating endpoint configurations and deploying to endpoints
  # Type: string, Optional
  name = "my-sagemaker-model"

  # IAM role ARN that SageMaker can assume to access model artifacts and Docker images
  # Required permissions:
  # - S3 access: s3:GetObject for model artifacts in S3
  # - ECR access: ecr:GetAuthorizationToken, ecr:BatchCheckLayerAvailability, ecr:GetDownloadUrlForLayer, ecr:BatchGetImage
  # - CloudWatch Logs: logs:CreateLogGroup, logs:CreateLogStream, logs:PutLogEvents (for endpoint logs)
  # Type: string, Required
  # AWS Documentation: https://docs.aws.amazon.com/sagemaker/latest/dg/sagemaker-roles.html
  execution_role_arn = aws_iam_role.sagemaker_execution_role.arn

  # AWS region where the model will be managed
  # - Defaults to the region set in provider configuration if not specified
  # - Model artifacts and container images must be accessible from this region
  # Type: string, Optional (computed)
  # region = "us-east-1"

  # Enable network isolation for the model container
  # - When true, containers cannot make outbound network calls
  # - No inbound network calls can reach containers
  # - Enhances security by preventing data exfiltration
  # - Model artifacts are still loaded from S3 before isolation is enforced
  # Type: bool, Optional (default: false)
  # enable_network_isolation = true

  ################################################################################
  # Primary Container Configuration
  ################################################################################
  # The main container for single-model endpoints
  # - Exactly one of primary_container or container blocks must be specified
  # - Use primary_container for single-model endpoints
  # - Use multiple container blocks for inference pipelines (multi-container endpoints)
  ################################################################################

  primary_container {
    # Docker image URI for the inference container
    # - ECR image format: <account-id>.dkr.ecr.<region>.amazonaws.com/<repository-name>:<tag>
    # - SageMaker provides pre-built images for popular frameworks (TensorFlow, PyTorch, XGBoost, etc.)
    # - Custom images must implement SageMaker inference specification (respond to /invocations and /ping)
    # - Container must listen on port 8080 and respond to POST requests within 60 seconds
    # Type: string, Optional (required if model_package_name is not specified)
    # AWS Documentation: https://docs.aws.amazon.com/sagemaker/latest/dg/your-algorithms-inference-code.html
    image = data.aws_sagemaker_prebuilt_ecr_image.example.registry_path

    # S3 URI of the compressed model artifacts (.tar.gz file)
    # - Format: s3://<bucket-name>/<key-path>/model.tar.gz
    # - SageMaker extracts artifacts to /opt/ml/model in the container
    # - Use model_data_source for uncompressed model deployment (large models)
    # - Mutually exclusive with model_package_name and model_data_source
    # Type: string, Optional
    # model_data_url = "s3://my-bucket/models/my-model.tar.gz"

    # ARN of a model package from SageMaker Model Registry
    # - Simplifies deployment of versioned models from the registry
    # - Mutually exclusive with image, model_data_url, and environment
    # - Model package includes pre-configured container image and model artifacts
    # Type: string, Optional
    # model_package_name = "arn:aws:sagemaker:us-east-1:123456789012:model-package/my-model-package/1"

    # DNS hostname for the container (used in multi-container inference pipelines)
    # - Allows containers to reference each other by hostname
    # - Required when mode is set in inference_execution_config
    # Type: string, Optional
    # container_hostname = "primary"

    # Environment variables passed to the Docker container
    # - Used to configure model behavior and inference parameters
    # - Common variables: SAGEMAKER_PROGRAM (entrypoint script), SAGEMAKER_SUBMIT_DIRECTORY
    # - Framework-specific variables (e.g., TF_ENABLE_WINOGRAD_NONFUSED for TensorFlow)
    # Type: map(string), Optional
    # environment = {
    #   SAGEMAKER_PROGRAM          = "inference.py"
    #   SAGEMAKER_SUBMIT_DIRECTORY = "/opt/ml/model/code"
    #   MODEL_SERVER_TIMEOUT       = "3600"
    # }

    # Container mode for hosting
    # - SingleModel: Default mode for hosting a single model per endpoint
    # - MultiModel: Enables multi-model endpoints for hosting multiple models on one instance
    # Type: string, Optional (default: "SingleModel")
    # Allowed values: "SingleModel", "MultiModel"
    # mode = "SingleModel"

    # Inference specification name in the model package version
    # - Used when model_package_name references a package with multiple inference specifications
    # - Specifies which inference configuration to use from the model package
    # Type: string, Optional
    # inference_specification_name = "default"

    ################################################################################
    # Image Configuration (for private Docker registries)
    ################################################################################
    # Configuration for accessing container images in private Docker registries
    # - Required when using images from VPC-accessible private registries
    # - Not needed for ECR images (use standard ECR permissions instead)
    ################################################################################

    # image_config {
    #   # Access mode for the repository
    #   # - Platform: Image is hosted in Amazon ECR (default)
    #   # - Vpc: Image is in a private Docker registry accessible from your VPC
    #   # Type: string, Required
    #   # Allowed values: "Platform", "Vpc"
    #   repository_access_mode = "Platform"
    #
    #   # Authentication configuration for private Docker registry (required when repository_access_mode = "Vpc")
    #   # repository_auth_config {
    #   #   # ARN of AWS Lambda function that provides authentication credentials
    #   #   # - Lambda function must return Docker registry credentials
    #   #   # - Function needs permission to access the private registry
    #   #   # Type: string, Required
    #   #   # AWS Documentation: https://docs.aws.amazon.com/lambda/latest/dg/getting-started-create-function.html
    #   #   repository_credentials_provider_arn = aws_lambda_function.docker_auth.arn
    #   # }
    # }

    ################################################################################
    # Model Data Source (for uncompressed models)
    ################################################################################
    # Alternative to model_data_url for deploying large uncompressed models
    # - Improves deployment speed by skipping decompression
    # - Required for models larger than 10GB
    # - Mutually exclusive with model_data_url
    ################################################################################

    # model_data_source {
    #   s3_data_source {
    #     # S3 URI of the model artifacts
    #     # - For S3Prefix: s3://<bucket>/<prefix>/ (SageMaker loads all objects under prefix)
    #     # - For S3Object: s3://<bucket>/<key> (single object)
    #     # Type: string, Required
    #     s3_uri = "s3://my-bucket/large-model-artifacts/"
    #
    #     # Type of S3 data source
    #     # - S3Prefix: Load all objects under the specified prefix
    #     # - S3Object: Load a single object
    #     # Type: string, Required
    #     # Allowed values: "S3Prefix", "S3Object"
    #     s3_data_type = "S3Prefix"
    #
    #     # Compression type of the model data
    #     # - None: Uncompressed model artifacts (for large model inference)
    #     # - Gzip: Gzip-compressed artifacts
    #     # Type: string, Required
    #     # Allowed values: "None", "Gzip"
    #     compression_type = "None"
    #
    #     # Model access configuration (for marketplace models with EULA)
    #     # model_access_config {
    #     #   # Accept the model end-user license agreement
    #     #   # - Must be set to true to accept EULA for marketplace models
    #     #   # - You are responsible for reviewing and complying with license terms
    #     #   # Type: bool, Required
    #     #   accept_eula = true
    #     # }
    #   }
    # }

    ################################################################################
    # Additional Model Data Sources
    ################################################################################
    # Additional data sources available to the model (beyond primary model artifacts)
    # - Useful for models requiring multiple data sources (e.g., embeddings, vocabularies)
    # - Data is loaded to /opt/ml/additional-model-data-sources/<channel_name>/
    ################################################################################

    # additional_model_data_source {
    #   # Custom name for the additional data source (used as directory name)
    #   # Type: string, Required
    #   channel_name = "embeddings"
    #
    #   s3_data_source {
    #     # S3 URI of the additional data
    #     # Type: string, Required
    #     s3_uri = "s3://my-bucket/embeddings/"
    #
    #     # Type of S3 data source
    #     # Type: string, Required
    #     # Allowed values: "S3Prefix", "S3Object"
    #     s3_data_type = "S3Prefix"
    #
    #     # Compression type
    #     # Type: string, Required
    #     # Allowed values: "None", "Gzip"
    #     compression_type = "None"
    #
    #     # Model access configuration (optional, for EULA acceptance)
    #     # model_access_config {
    #     #   accept_eula = true
    #     # }
    #   }
    # }

    ################################################################################
    # Multi-Model Configuration
    ################################################################################
    # Configuration for multi-model endpoints that host multiple models on a single instance
    # - Models are dynamically loaded and unloaded based on invocation patterns
    # - Reduces costs by sharing infrastructure across multiple models
    # - Requires mode = "MultiModel" in the container configuration
    ################################################################################

    # multi_model_config {
    #   # Model cache setting controls whether models are cached in memory
    #   # - Enabled: Models remain in memory after first invocation (default, better for frequently-invoked models)
    #   # - Disabled: Models are unloaded after each invocation (better for large number of infrequently-invoked models)
    #   # Type: string, Optional (default: "Enabled")
    #   # Allowed values: "Enabled", "Disabled"
    #   model_cache_setting = "Enabled"
    # }
  }

  ################################################################################
  # Multi-Container Configuration (Inference Pipelines)
  ################################################################################
  # Alternative to primary_container for inference pipelines with multiple containers
  # - Containers can execute in serial (preprocessing -> model -> postprocessing)
  # - Or in direct mode (client routes requests to specific containers)
  # - Maximum 15 containers per model
  ################################################################################

  # container {
  #   # Container configuration (same attributes as primary_container)
  #   image              = "123456789012.dkr.ecr.us-east-1.amazonaws.com/preprocessing:latest"
  #   container_hostname = "preprocessing"
  # }
  #
  # container {
  #   image              = data.aws_sagemaker_prebuilt_ecr_image.example.registry_path
  #   model_data_url     = "s3://my-bucket/models/my-model.tar.gz"
  #   container_hostname = "inference"
  # }
  #
  # container {
  #   image              = "123456789012.dkr.ecr.us-east-1.amazonaws.com/postprocessing:latest"
  #   container_hostname = "postprocessing"
  # }

  ################################################################################
  # Inference Execution Configuration
  ################################################################################
  # Specifies how containers in a multi-container endpoint are invoked
  # - Required when using multiple container blocks
  # - Not applicable when using primary_container
  ################################################################################

  # inference_execution_config {
  #   # Execution mode for multi-container endpoints
  #   # - Serial: Containers are invoked sequentially (inference pipeline)
  #   #   - Output of one container becomes input to the next
  #   #   - Used for preprocessing -> inference -> postprocessing workflows
  #   # - Direct: Client specifies which container to invoke via TargetContainerHostname header
  #   #   - Allows routing to specific containers in the pipeline
  #   # Type: string, Required
  #   # Allowed values: "Serial", "Direct"
  #   mode = "Serial"
  # }

  ################################################################################
  # VPC Configuration
  ################################################################################
  # Private network configuration for model containers
  # - Enhances security by running containers within your VPC
  # - Allows access to resources in private subnets (databases, internal APIs)
  # - Requires VPC endpoints for S3 and SageMaker API access
  # - Subnets must have sufficient IP addresses (recommend at least one IP per instance)
  ################################################################################

  # vpc_config {
  #   # List of security group IDs for the model containers
  #   # - Security groups control inbound and outbound traffic
  #   # - Must allow HTTPS (443) outbound for SageMaker API and S3 access via VPC endpoints
  #   # - For multi-instance deployments, allow communication between instances
  #   # Type: set(string), Required
  #   security_group_ids = [aws_security_group.sagemaker_model.id]
  #
  #   # List of subnet IDs in the VPC for the model containers
  #   # - Subnets should be private subnets with NAT gateway or VPC endpoints for internet access
  #   # - Multiple subnets recommended for high availability
  #   # - Ensure sufficient IP addresses for the number of instances
  #   # Type: set(string), Required
  #   # AWS Documentation: https://docs.aws.amazon.com/sagemaker/latest/dg/host-vpc.html
  #   subnets = [
  #     aws_subnet.private_a.id,
  #     aws_subnet.private_b.id,
  #   ]
  # }

  ################################################################################
  # Tags
  ################################################################################
  # Resource tags for organization, cost allocation, and access control
  # - Inherited by endpoint configurations and endpoints created from this model
  # - Merged with provider default_tags if configured
  ################################################################################

  tags = {
    Name        = "my-sagemaker-model"
    Environment = "production"
    Project     = "ml-inference"
    ManagedBy   = "terraform"
    Framework   = "pytorch"
    ModelType   = "classification"
  }
}

################################################################################
# Outputs
################################################################################

# ARN of the created SageMaker model
# - Used when creating endpoint configurations
# - Format: arn:aws:sagemaker:<region>:<account-id>:model/<model-name>
output "sagemaker_model_arn" {
  description = "Amazon Resource Name (ARN) assigned by AWS to this model"
  value       = aws_sagemaker_model.example.arn
}

# Name of the SageMaker model
# - Required when creating endpoint configurations
# - May be auto-generated if name attribute was not specified
output "sagemaker_model_name" {
  description = "Name of the model (auto-generated if not specified)"
  value       = aws_sagemaker_model.example.name
}

# Region where the model is managed
# - Informational output for multi-region deployments
output "sagemaker_model_region" {
  description = "AWS region where the model is managed"
  value       = aws_sagemaker_model.example.region
}

################################################################################
# Example IAM Role for SageMaker Model Execution
################################################################################
# This role grants SageMaker permissions to access model artifacts and container images

resource "aws_iam_role" "sagemaker_execution_role" {
  name = "sagemaker-model-execution-role"

  # Trust policy allowing SageMaker to assume this role
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "sagemaker.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name      = "sagemaker-model-execution-role"
    ManagedBy = "terraform"
  }
}

# Policy granting access to S3 model artifacts
resource "aws_iam_role_policy" "sagemaker_s3_access" {
  name = "sagemaker-s3-access"
  role = aws_iam_role.sagemaker_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket",
        ]
        Resource = [
          "arn:aws:s3:::my-model-bucket",
          "arn:aws:s3:::my-model-bucket/*",
        ]
      }
    ]
  })
}

# Policy granting access to ECR for pulling container images
resource "aws_iam_role_policy" "sagemaker_ecr_access" {
  name = "sagemaker-ecr-access"
  role = aws_iam_role.sagemaker_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
        ]
        Resource = "*"
      }
    ]
  })
}

# Policy granting access to CloudWatch Logs
resource "aws_iam_role_policy" "sagemaker_cloudwatch_access" {
  name = "sagemaker-cloudwatch-access"
  role = aws_iam_role.sagemaker_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
        ]
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

################################################################################
# Example Data Source for SageMaker Pre-built Container Image
################################################################################
# SageMaker provides optimized pre-built images for popular ML frameworks

data "aws_sagemaker_prebuilt_ecr_image" "example" {
  # Repository name of the pre-built algorithm
  # Common values: "xgboost", "kmeans", "linear-learner", "pca", "factorization-machines",
  # "blazingtext", "deepar", "forecasting-deepar", "object-detection", "image-classification",
  # "semantic-segmentation", "seq2seq", "ipinsights", "lda", "ntm", "randomcutforest"
  repository_name = "xgboost"

  # Optional: Specify image tag/version
  # - "latest" uses the most recent version
  # - Specific versions ensure reproducibility (e.g., "1.5-1")
  # image_tag = "latest"
}

################################################################################
# Related Resources
################################################################################
# After creating a model, you typically need:
# 1. aws_sagemaker_endpoint_configuration: Define instance type and count
# 2. aws_sagemaker_endpoint: Deploy the model for inference
#
# Example workflow:
# 1. Create model (this resource)
# 2. Create endpoint configuration referencing this model
# 3. Create endpoint referencing the endpoint configuration
# 4. Invoke endpoint for real-time predictions
#
# Alternative deployment options:
# - aws_sagemaker_transform_job: Batch inference without persistent endpoint
# - aws_sagemaker_pipeline: Orchestrate training and deployment workflows
################################################################################
