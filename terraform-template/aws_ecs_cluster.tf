# ==============================================================================
# AWS ECS Cluster - Annotated Reference Template
# Provider Version: 6.28.0
# ==============================================================================
#
# Amazon Elastic Container Service (ECS) is a fully managed container
# orchestration service that makes it easy to deploy, manage, and scale
# containerized applications using Docker containers.
#
# An ECS cluster is a logical grouping of tasks or services. Tasks can run on:
# - AWS Fargate (serverless compute for containers)
# - EC2 instances (self-managed infrastructure)
# - External instances (on-premises servers using ECS Anywhere)
#
# Key Features:
# - Execute Command: Enables interactive shell access to containers for debugging
# - Service Connect: Simplifies service-to-service communication with service mesh
# - Container Insights: Provides deep visibility into containerized applications
# - Managed Storage: Encrypts ephemeral and persistent storage using KMS keys
#
# Official Documentation:
# https://docs.aws.amazon.com/AmazonECS/latest/developerguide/clusters.html
# Terraform Registry:
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster
# ==============================================================================

resource "aws_ecs_cluster" "example" {
  # ============================================================================
  # REQUIRED ARGUMENTS
  # ============================================================================

  # --------------------------------------------------------------------------
  # name - (Required) string
  # --------------------------------------------------------------------------
  # The name of the ECS cluster. Must be unique within the AWS account and
  # region. Can contain up to 255 letters (uppercase and lowercase), numbers,
  # hyphens, and underscores.
  #
  # Naming Conventions:
  # - Use descriptive names: prod-web-cluster, dev-api-cluster
  # - Include environment: prod-, dev-, staging-
  # - Keep it concise and meaningful
  #
  # Note: Changing this value will force replacement of the cluster.
  # --------------------------------------------------------------------------
  name = "example-ecs-cluster"

  # ============================================================================
  # OPTIONAL ARGUMENTS
  # ============================================================================

  # --------------------------------------------------------------------------
  # region - (Optional) string | Computed
  # --------------------------------------------------------------------------
  # The AWS Region where this cluster will be managed. If not specified,
  # defaults to the region set in the provider configuration.
  #
  # Use Cases:
  # - Multi-region deployments with explicit region management
  # - Cross-region resource dependencies
  # - Regional compliance requirements
  #
  # Reference: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # --------------------------------------------------------------------------
  # region = "us-east-1"

  # --------------------------------------------------------------------------
  # tags - (Optional) map(string)
  # --------------------------------------------------------------------------
  # A map of tags to assign to the cluster. Tags help organize and manage
  # AWS resources through:
  # - Cost allocation and tracking
  # - Access control policies
  # - Automation and filtering
  # - Resource organization
  #
  # Best Practices:
  # - Use consistent tag keys across all resources
  # - Include: Environment, Application, Team, CostCenter
  # - Consider AWS Config and AWS Organizations tag policies
  #
  # Note: If configured with a provider default_tags configuration block,
  # tags with matching keys will overwrite those defined at the provider level.
  #
  # Reference: https://docs.aws.amazon.com/general/latest/gr/aws_tagging.html
  # --------------------------------------------------------------------------
  tags = {
    Name        = "example-ecs-cluster"
    Environment = "production"
    ManagedBy   = "terraform"
    Application = "web-services"
    Team        = "platform"
  }

  # ============================================================================
  # NESTED BLOCKS
  # ============================================================================

  # --------------------------------------------------------------------------
  # configuration - (Optional) block | Max Items: 1
  # --------------------------------------------------------------------------
  # The execute command and managed storage configuration for the cluster.
  # This block configures advanced cluster features for debugging and security.
  # --------------------------------------------------------------------------
  configuration {

    # ------------------------------------------------------------------------
    # execute_command_configuration - (Optional) block | Max Items: 1
    # ------------------------------------------------------------------------
    # Enables and configures ECS Exec (Execute Command) feature for interactive
    # access to containers. This allows running commands in containers via the
    # AWS CLI or AWS Management Console.
    #
    # Use Cases:
    # - Debugging running containers
    # - Troubleshooting application issues
    # - Running ad-hoc commands for maintenance
    #
    # Security Considerations:
    # - Requires IAM permissions for users and task roles
    # - Audit all commands executed via CloudWatch Logs
    # - Use KMS encryption for command data in transit
    #
    # Reference: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-exec.html
    # ------------------------------------------------------------------------
    execute_command_configuration {

      # ----------------------------------------------------------------------
      # kms_key_id - (Optional) string
      # ----------------------------------------------------------------------
      # The AWS KMS key ID to encrypt the data between the local client and
      # the container. This ensures that command input/output is encrypted
      # during transmission.
      #
      # Format: Can be key ARN, key ID, alias ARN, or alias name
      # Example: "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
      #
      # Security Best Practice: Always use KMS encryption for production
      # clusters to protect sensitive data during execute command sessions.
      # ----------------------------------------------------------------------
      kms_key_id = aws_kms_key.ecs_exec.arn

      # ----------------------------------------------------------------------
      # logging - (Optional) string
      # ----------------------------------------------------------------------
      # The log setting to use for redirecting logs for execute command results.
      #
      # Valid Values:
      # - NONE: Turn off logging (not recommended for production)
      # - DEFAULT: CloudWatch logs using the awslogs log driver configuration
      # - OVERRIDE: Custom log configuration (requires log_configuration block)
      #
      # Compliance: Many security frameworks require audit logging of all
      # interactive sessions. Use DEFAULT or OVERRIDE for production.
      # ----------------------------------------------------------------------
      logging = "OVERRIDE"

      # ----------------------------------------------------------------------
      # log_configuration - (Optional) block | Max Items: 1
      # ----------------------------------------------------------------------
      # Custom log configuration for execute command results. Required when
      # logging is set to "OVERRIDE".
      #
      # Audit Logging: Captures all commands and their output for security
      # auditing and compliance requirements.
      # ----------------------------------------------------------------------
      log_configuration {

        # --------------------------------------------------------------------
        # cloud_watch_encryption_enabled - (Optional) bool
        # --------------------------------------------------------------------
        # Whether to enable encryption on the CloudWatch logs. If not
        # specified, encryption is disabled.
        #
        # Security: Enable this to encrypt logs at rest in CloudWatch Logs.
        # Works in conjunction with CloudWatch Logs KMS encryption.
        # --------------------------------------------------------------------
        cloud_watch_encryption_enabled = true

        # --------------------------------------------------------------------
        # cloud_watch_log_group_name - (Optional) string
        # --------------------------------------------------------------------
        # The name of the CloudWatch log group to send execute command logs to.
        # The log group must exist before enabling execute command.
        #
        # Log Organization: Use a dedicated log group for execute command
        # logs to separate them from application logs.
        # --------------------------------------------------------------------
        cloud_watch_log_group_name = "/aws/ecs/cluster/example/exec"

        # --------------------------------------------------------------------
        # s3_bucket_name - (Optional) string
        # --------------------------------------------------------------------
        # The name of the S3 bucket to send execute command logs to. Useful
        # for long-term log retention and archival.
        #
        # Use Cases:
        # - Long-term audit log retention
        # - Compliance with data retention policies
        # - Cost optimization (S3 is cheaper than CloudWatch for long-term storage)
        # --------------------------------------------------------------------
        # s3_bucket_name = "my-ecs-exec-logs-bucket"

        # --------------------------------------------------------------------
        # s3_bucket_encryption_enabled - (Optional) bool
        # --------------------------------------------------------------------
        # Whether to enable encryption on the logs sent to S3. If not
        # specified, encryption is disabled.
        #
        # Security: Enable this to encrypt logs at rest in S3 using S3
        # server-side encryption.
        # --------------------------------------------------------------------
        # s3_bucket_encryption_enabled = true

        # --------------------------------------------------------------------
        # s3_key_prefix - (Optional) string
        # --------------------------------------------------------------------
        # An optional folder in the S3 bucket to place logs in. Helps organize
        # logs within the bucket.
        #
        # Example: "ecs-exec-logs/" or "clusters/production/exec/"
        # --------------------------------------------------------------------
        # s3_key_prefix = "exec-logs/"
      }
    }

    # ------------------------------------------------------------------------
    # managed_storage_configuration - (Optional) block | Max Items: 1
    # ------------------------------------------------------------------------
    # Configures encryption for managed storage in the cluster. Provides
    # encryption at rest for:
    # - Fargate ephemeral storage (container layer storage)
    # - ECS-managed EBS volumes attached to tasks
    #
    # Security Compliance: Many compliance frameworks (PCI-DSS, HIPAA, SOC2)
    # require encryption at rest for all data storage.
    #
    # Reference: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/fargate-task-storage.html
    # ------------------------------------------------------------------------
    managed_storage_configuration {

      # ----------------------------------------------------------------------
      # fargate_ephemeral_storage_kms_key_id - (Optional) string
      # ----------------------------------------------------------------------
      # AWS KMS key ARN to encrypt Fargate ephemeral storage. When specified,
      # AWS Fargate encrypts the ephemeral storage using this key.
      #
      # Fargate Ephemeral Storage:
      # - Platform version 1.4.0+: 20 GiB minimum, expandable to 200 GiB
      # - Stores container images, layers, and writable container layer
      # - Automatically encrypted with AES-256 (default) or customer-managed KMS
      #
      # Requirements:
      # - Must be a single-region KMS key (multi-region keys not supported)
      # - Key policy must grant Fargate service permissions
      # - Not supported for Windows containers or platform versions < 1.4.0
      #
      # Key Policy Requirements:
      # - kms:GenerateDataKeyWithoutPlaintext permission
      # - kms:CreateGrant with Decrypt operation
      # - Encryption context: aws:ecs:clusterAccount and aws:ecs:clusterName
      #
      # Cost: Additional KMS API call charges apply for key operations
      #
      # Example Key Policy: See AWS documentation for complete policy example
      # https://docs.aws.amazon.com/AmazonECS/latest/developerguide/fargate-create-storage-key.html
      # ----------------------------------------------------------------------
      fargate_ephemeral_storage_kms_key_id = aws_kms_key.fargate_storage.arn

      # ----------------------------------------------------------------------
      # kms_key_id - (Optional) string
      # ----------------------------------------------------------------------
      # AWS KMS key ID to encrypt Amazon ECS managed storage. This encrypts:
      # - Amazon EBS volumes managed by ECS
      # - Persistent data volumes attached to tasks
      #
      # ECS Managed Volumes:
      # - Used for persistent task storage
      # - Automatically created and managed by ECS
      # - Encrypted at rest when this key is specified
      #
      # Requirements:
      # - Must be a single-region KMS key
      # - Key policy must grant ECS service permissions
      #
      # Note: Different from fargate_ephemeral_storage_kms_key_id, which is
      # specifically for Fargate ephemeral storage. This is for EBS volumes.
      # ----------------------------------------------------------------------
      kms_key_id = aws_kms_key.ecs_storage.arn
    }
  }

  # --------------------------------------------------------------------------
  # service_connect_defaults - (Optional) block | Max Items: 1
  # --------------------------------------------------------------------------
  # Default Service Connect namespace for the cluster. When configured, any
  # new service created in the cluster with Service Connect enabled will
  # automatically use this namespace if no other namespace is specified.
  #
  # Amazon ECS Service Connect:
  # - Provides service-to-service communication without manual service discovery
  # - Built on AWS Cloud Map for DNS-based service discovery
  # - Includes automatic proxy container for traffic management
  # - Enables cross-cluster service communication
  # - Provides enhanced observability with metrics and logs
  #
  # Benefits:
  # - Simplified service discovery (use short names instead of DNS)
  # - Automatic health checking and traffic routing
  # - Increased visibility into service-to-service traffic
  # - No code changes required for service mesh capabilities
  #
  # Use Cases:
  # - Microservices architectures
  # - Multi-service applications requiring service discovery
  # - Applications needing service mesh capabilities
  #
  # Reference: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/service-connect.html
  # --------------------------------------------------------------------------
  service_connect_defaults {

    # ------------------------------------------------------------------------
    # namespace - (Required) string
    # ------------------------------------------------------------------------
    # The ARN of the AWS Cloud Map HTTP namespace to use as the default for
    # Service Connect in this cluster.
    #
    # Format: ARN of aws_service_discovery_http_namespace resource
    # Example: "arn:aws:servicediscovery:us-east-1:123456789012:namespace/ns-xxxxx"
    #
    # Namespace Types:
    # - HTTP Namespace: For Service Connect (required)
    # - DNS Namespace: Not supported for Service Connect defaults
    #
    # Cross-Account: Namespaces can be shared across accounts using
    # AWS Resource Access Manager (RAM).
    #
    # Cluster Provisioning: When creating a cluster with this configuration,
    # the cluster remains in PROVISIONING state while ECS creates/configures
    # the namespace.
    #
    # Note: You must create the aws_service_discovery_http_namespace resource
    # before referencing it here.
    # ------------------------------------------------------------------------
    namespace = aws_service_discovery_http_namespace.example.arn
  }

  # --------------------------------------------------------------------------
  # setting - (Optional) block | Set
  # --------------------------------------------------------------------------
  # Configuration block for cluster settings. Can be specified multiple times
  # for different settings (as a set, not a list).
  #
  # Currently Supported Settings:
  # - containerInsights: Enable/disable CloudWatch Container Insights
  #
  # Multiple settings can be configured by adding multiple setting blocks.
  # --------------------------------------------------------------------------
  setting {

    # ------------------------------------------------------------------------
    # name - (Required) string
    # ------------------------------------------------------------------------
    # The name of the cluster setting to manage.
    #
    # Valid Values:
    # - containerInsights: Enable CloudWatch Container Insights
    #
    # Container Insights:
    # - Collects, aggregates, and summarizes metrics and logs
    # - Provides automatic dashboards in CloudWatch
    # - Monitors cluster, service, task, and container-level metrics
    # - Includes CPU, memory, network, and storage metrics
    #
    # Reference: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/ContainerInsights.html
    # ------------------------------------------------------------------------
    name = "containerInsights"

    # ------------------------------------------------------------------------
    # value - (Required) string
    # ------------------------------------------------------------------------
    # The value to assign to the setting.
    #
    # Valid Values for containerInsights:
    # - enabled: Turn on Container Insights (standard monitoring)
    # - enhanced: Turn on Container Insights with enhanced observability
    # - disabled: Turn off Container Insights
    #
    # Monitoring Levels:
    #
    # enabled (standard):
    # - Cluster, service, and task-level metrics
    # - Basic CPU, memory, network, disk metrics
    # - CloudWatch dashboard with standard visualizations
    # - Lower cost, standard granularity
    #
    # enhanced:
    # - All standard metrics plus container-level granularity
    # - Additional metrics for EBS filesystem utilization
    # - Enhanced troubleshooting capabilities
    # - Integration with CloudWatch Logs for metric correlation
    # - Higher cost, but deeper visibility
    #
    # disabled:
    # - No Container Insights data collected
    # - Only basic CloudWatch metrics available
    # - Lowest cost
    #
    # Cost Considerations:
    # - Container Insights incurs CloudWatch Logs ingestion and storage costs
    # - Enhanced mode costs more than standard mode
    # - Consider cost vs. observability needs for production workloads
    #
    # Best Practice: Enable Container Insights for production clusters to
    # maintain visibility into containerized workloads. Use enhanced mode
    # for critical production workloads requiring detailed troubleshooting.
    #
    # Reference: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Container-Insights-enhanced-observability-metrics-ECS.html
    # ------------------------------------------------------------------------
    value = "enabled"
  }

  # ============================================================================
  # COMPUTED ATTRIBUTES (Read-Only)
  # ============================================================================
  #
  # The following attributes are exported and can be referenced in other
  # resources using: aws_ecs_cluster.example.<attribute_name>
  #
  # arn - (string)
  #   The Amazon Resource Name (ARN) that identifies the cluster.
  #   Format: arn:aws:ecs:region:account-id:cluster/cluster-name
  #   Example: arn:aws:ecs:us-east-1:123456789012:cluster/example-ecs-cluster
  #
  #   Usage:
  #   - Reference in IAM policies for permission boundaries
  #   - Use in aws_ecs_service to specify the cluster
  #   - Tag-based access control and resource grouping
  #
  # id - (string)
  #   The cluster identifier. In this resource, it's the same as the ARN.
  #   Can be used as a unique identifier in Terraform state.
  #
  # tags_all - (map(string))
  #   Map of tags assigned to the resource, including those inherited from the
  #   provider default_tags configuration block.
  #
  #   Use Cases:
  #   - View all effective tags (resource + provider default tags)
  #   - Reference in data sources and outputs
  #   - Audit tag compliance
  #
  # region - (string) - Also Optional
  #   The AWS Region where the cluster is managed. Computed if not explicitly set.
  # ============================================================================
}

# ==============================================================================
# RELATED RESOURCES EXAMPLES
# ==============================================================================
#
# Complete cluster setup typically requires additional resources:
# ==============================================================================

# KMS Key for ECS Exec encryption
resource "aws_kms_key" "ecs_exec" {
  description             = "KMS key for ECS Exec command encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  tags = {
    Name = "ecs-exec-encryption-key"
  }
}

# KMS Key for Fargate ephemeral storage
resource "aws_kms_key" "fargate_storage" {
  description             = "KMS key for Fargate ephemeral storage encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  tags = {
    Name = "fargate-storage-encryption-key"
  }
}

# KMS Key Policy for Fargate ephemeral storage
# Required to grant Fargate service permissions
resource "aws_kms_key_policy" "fargate_storage" {
  key_id = aws_kms_key.fargate_storage.id
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "ECSClusterFargatePolicy"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid    = "Allow generate data key access for Fargate tasks"
        Effect = "Allow"
        Principal = {
          Service = "fargate.amazonaws.com"
        }
        Action = [
          "kms:GenerateDataKeyWithoutPlaintext"
        ]
        Condition = {
          StringEquals = {
            "kms:EncryptionContext:aws:ecs:clusterAccount" = [
              data.aws_caller_identity.current.account_id
            ]
            "kms:EncryptionContext:aws:ecs:clusterName" = [
              "example-ecs-cluster"
            ]
          }
        }
        Resource = "*"
      },
      {
        Sid    = "Allow grant creation permission for Fargate tasks"
        Effect = "Allow"
        Principal = {
          Service = "fargate.amazonaws.com"
        }
        Action = [
          "kms:CreateGrant"
        ]
        Condition = {
          StringEquals = {
            "kms:EncryptionContext:aws:ecs:clusterAccount" = [
              data.aws_caller_identity.current.account_id
            ]
            "kms:EncryptionContext:aws:ecs:clusterName" = [
              "example-ecs-cluster"
            ]
          }
          "ForAllValues:StringEquals" = {
            "kms:GrantOperations" = [
              "Decrypt"
            ]
          }
        }
        Resource = "*"
      }
    ]
  })
}

# KMS Key for ECS managed storage (EBS volumes)
resource "aws_kms_key" "ecs_storage" {
  description             = "KMS key for ECS managed storage encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  tags = {
    Name = "ecs-storage-encryption-key"
  }
}

# CloudWatch Log Group for ECS Exec logs
resource "aws_cloudwatch_log_group" "ecs_exec" {
  name              = "/aws/ecs/cluster/example/exec"
  retention_in_days = 30
  kms_key_id        = aws_kms_key.ecs_exec.arn

  tags = {
    Name = "ecs-exec-logs"
  }
}

# Service Discovery HTTP Namespace for Service Connect
resource "aws_service_discovery_http_namespace" "example" {
  name        = "example-namespace"
  description = "Service Connect namespace for example ECS cluster"

  tags = {
    Name = "example-service-connect-namespace"
  }
}

# Data source to get current AWS account ID
data "aws_caller_identity" "current" {}

# ==============================================================================
# USAGE EXAMPLES
# ==============================================================================

# Reference the cluster in an ECS service
# resource "aws_ecs_service" "example" {
#   name            = "example-service"
#   cluster         = aws_ecs_cluster.example.id
#   task_definition = aws_ecs_task_definition.example.arn
#   desired_count   = 3
#   launch_type     = "FARGATE"
#
#   # Service Connect configuration (uses cluster default namespace)
#   service_connect_configuration {
#     enabled = true
#   }
# }

# Reference cluster ARN in IAM policy
# data "aws_iam_policy_document" "ecs_exec" {
#   statement {
#     actions = [
#       "ecs:ExecuteCommand"
#     ]
#     resources = [
#       "${aws_ecs_cluster.example.arn}/*"
#     ]
#   }
# }

# ==============================================================================
# BEST PRACTICES & RECOMMENDATIONS
# ==============================================================================
#
# 1. Security:
#    - Always enable KMS encryption for execute command in production
#    - Use customer-managed KMS keys for data encryption at rest
#    - Enable CloudWatch logging for audit trails
#    - Apply least-privilege IAM policies for execute command access
#    - Regularly rotate KMS keys
#
# 2. Monitoring:
#    - Enable Container Insights for production clusters
#    - Use enhanced mode for critical workloads requiring detailed metrics
#    - Set appropriate CloudWatch Logs retention periods (cost vs. compliance)
#    - Create CloudWatch alarms for cluster-level metrics
#    - Monitor cluster capacity and utilization
#
# 3. Cost Optimization:
#    - Consider Container Insights costs (standard vs. enhanced)
#    - Use Fargate for variable workloads, EC2 for predictable workloads
#    - Set CloudWatch Logs retention to balance cost and compliance
#    - Review and clean up unused clusters regularly
#    - Use Savings Plans or Reserved Instances for EC2-backed clusters
#
# 4. High Availability:
#    - Deploy services across multiple Availability Zones
#    - Use multiple clusters for critical applications (regional redundancy)
#    - Implement proper task health checks
#    - Configure Service Connect for resilient service-to-service communication
#
# 5. Operations:
#    - Use descriptive, consistent naming conventions
#    - Tag all resources for cost allocation and organization
#    - Document cluster purpose and ownership in tags/descriptions
#    - Implement proper backup and disaster recovery procedures
#    - Regularly review and update cluster configurations
#
# 6. Service Connect:
#    - Use Service Connect for simplified service discovery
#    - Configure default namespace to standardize service communication
#    - Monitor Service Connect metrics for traffic patterns
#    - Plan namespace strategy for multi-cluster deployments
#
# 7. Compliance:
#    - Enable encryption at rest for all storage (Fargate and EBS)
#    - Enable encryption in transit for execute command
#    - Maintain audit logs for all administrative actions
#    - Regular security audits and compliance checks
#    - Follow organizational and regulatory requirements
#
# ==============================================================================
# MIGRATION NOTES
# ==============================================================================
#
# From Provider Version < 6.0.0:
# - Validate all cluster configurations after upgrade
# - Review any deprecated attributes or behaviors
# - Test execute command and Service Connect features
# - Verify KMS key permissions and policies
#
# From Other Container Orchestration:
# - Map existing cluster concepts to ECS equivalents
# - Plan service discovery migration to Service Connect
# - Review networking and security group configurations
# - Consider gradual migration with hybrid setups
#
# ==============================================================================
# TROUBLESHOOTING
# ==============================================================================
#
# Common Issues:
#
# 1. Execute Command Not Working:
#    - Verify KMS key permissions
#    - Check IAM task role has ssmmessages permissions
#    - Ensure task has enableExecuteCommand = true
#    - Verify network connectivity to Systems Manager endpoints
#
# 2. Service Connect Issues:
#    - Ensure namespace ARN is correct and accessible
#    - Verify services have proper Service Connect configuration
#    - Check Cloud Map namespace is in same region
#    - Review security groups for service-to-service communication
#
# 3. Container Insights Not Showing Data:
#    - Verify setting is enabled (not just configured)
#    - Check IAM permissions for CloudWatch Logs
#    - Wait a few minutes for initial metrics to appear
#    - Ensure task role has required CloudWatch permissions
#
# 4. KMS Encryption Errors:
#    - Verify key policy grants necessary permissions
#    - Check key is in the same region as cluster
#    - Ensure key is enabled and not pending deletion
#    - Review encryption context requirements
#
# ==============================================================================
