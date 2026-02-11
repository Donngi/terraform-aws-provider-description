# ============================================================================
# Resource: aws_eks_fargate_profile
# Provider Version: 6.28.0
# ============================================================================
# 
# Description:
# Manages an EKS Fargate Profile for Amazon Elastic Kubernetes Service (EKS).
# 
# AWS Fargate is a serverless compute engine for containers that allows you to 
# run Kubernetes pods without managing the underlying EC2 infrastructure. A 
# Fargate profile defines which pods should be scheduled on Fargate based on 
# namespace and label selectors.
# 
# Key Concepts:
# - Fargate profiles are immutable once created (cannot be modified)
# - Each profile can have up to 5 selectors
# - Pods matching a selector are automatically scheduled on Fargate
# - Only private subnets with NAT gateway access are supported
# - Requires a pod execution IAM role for kubelet operations
# 
# Common Use Cases:
# - Running stateless applications without managing worker nodes
# - Isolating workloads with dedicated compute resources
# - Scaling applications without pre-provisioning capacity
# - Running batch jobs or scheduled tasks
# 
# Important Limitations:
# - Cannot modify selectors after creation (must create new profile)
# - Only works with private subnets
# - Pods must match a selector to run on Fargate
# - Maximum of 5 selectors per profile
# - Cannot delete a profile while pods are still running on it
# 
# AWS Documentation:
# https://docs.aws.amazon.com/eks/latest/userguide/fargate-profile.html
# 
# Terraform Registry:
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_fargate_profile
# ============================================================================

resource "aws_eks_fargate_profile" "example" {
  # ============================================================================
  # REQUIRED ARGUMENTS
  # ============================================================================

  # --------------------------------------------------------------------------
  # cluster_name (Required)
  # --------------------------------------------------------------------------
  # Type: string
  # 
  # The name of the EKS cluster to which this Fargate profile will be 
  # associated. The cluster must already exist before creating the profile.
  # 
  # Example values:
  # - "my-eks-cluster"
  # - "production-cluster"
  # - "dev-eks"
  # 
  # AWS Documentation:
  # The cluster must be in ACTIVE state before adding a Fargate profile.
  # --------------------------------------------------------------------------
  cluster_name = "my-eks-cluster"

  # --------------------------------------------------------------------------
  # fargate_profile_name (Required)
  # --------------------------------------------------------------------------
  # Type: string
  # 
  # The name of the Fargate profile. Must be unique within the cluster.
  # 
  # Naming constraints:
  # - Must be alphanumeric with hyphens allowed
  # - Cannot start or end with a hyphen
  # - Maximum length varies by AWS limits
  # 
  # Example values:
  # - "default-profile"
  # - "app-workloads"
  # - "batch-jobs"
  # 
  # Best practices:
  # - Use descriptive names that indicate the profile's purpose
  # - Consider including environment or application names
  # --------------------------------------------------------------------------
  fargate_profile_name = "app-workloads"

  # --------------------------------------------------------------------------
  # pod_execution_role_arn (Required)
  # --------------------------------------------------------------------------
  # Type: string (ARN)
  # 
  # The Amazon Resource Name (ARN) of the IAM role that provides permissions 
  # for the EKS Fargate Profile. This role is used by the kubelet running on 
  # Fargate infrastructure to interact with AWS services.
  # 
  # Required IAM permissions:
  # - Trust relationship with eks-fargate-pods.amazonaws.com
  # - AmazonEKSFargatePodExecutionRolePolicy managed policy attached
  # 
  # The role grants permissions for:
  # - Pulling container images from Amazon ECR
  # - Writing logs to CloudWatch Logs
  # - Accessing secrets from AWS Secrets Manager (if configured)
  # 
  # Example value:
  # "arn:aws:iam::123456789012:role/eks-fargate-pod-execution-role"
  # 
  # AWS Documentation:
  # This role is added to the cluster's Kubernetes RBAC for authorization.
  # https://docs.aws.amazon.com/eks/latest/userguide/pod-execution-role.html
  # --------------------------------------------------------------------------
  pod_execution_role_arn = aws_iam_role.fargate_pod_execution.arn

  # --------------------------------------------------------------------------
  # subnet_ids (Required)
  # --------------------------------------------------------------------------
  # Type: set of strings
  # 
  # Identifiers of private EC2 subnets to associate with the EKS Fargate 
  # Profile. Pods matching the selectors will be launched into these subnets.
  # 
  # Requirements:
  # - Must be private subnets (no direct internet gateway route)
  # - Must have a NAT gateway for outbound internet access
  # - Must have the tag: kubernetes.io/cluster/CLUSTER_NAME with any value
  # - Must be in different Availability Zones for high availability
  # - Must have sufficient IP addresses for pod scheduling
  # 
  # Constraints:
  # - Only private subnets are supported (Fargate does not support public subnets)
  # - Subnets must be in the same VPC as the EKS cluster
  # - At least 2 subnets recommended for HA
  # 
  # Example:
  # subnet_ids = [
  #   "subnet-0123456789abcdef0",
  #   "subnet-0123456789abcdef1"
  # ]
  # 
  # Best practices:
  # - Use at least 2 subnets in different AZs for high availability
  # - Ensure subnets have adequate CIDR ranges for pod IP allocation
  # - Verify NAT gateway is configured for outbound connectivity
  # 
  # AWS Documentation:
  # Fargate pods require private subnets with NAT gateway access to AWS services.
  # --------------------------------------------------------------------------
  subnet_ids = [
    "subnet-0123456789abcdef0",
    "subnet-0123456789abcdef1",
    "subnet-0123456789abcdef2"
  ]

  # --------------------------------------------------------------------------
  # selector (Required)
  # --------------------------------------------------------------------------
  # Type: list of objects
  # 
  # Configuration block(s) for selecting Kubernetes pods to execute with this 
  # EKS Fargate Profile. At least one selector is required, with a maximum of 
  # 5 selectors per profile.
  # 
  # Structure:
  # - namespace (Required): Kubernetes namespace for selection
  # - labels (Optional): Key-value map of Kubernetes labels for selection
  # 
  # Selector matching logic:
  # - Pods must be in the specified namespace
  # - If labels are specified, pod must have ALL matching labels
  # - If a pod matches multiple selectors, the first alphabetically sorted 
  #   selector name determines which profile is used
  # - Wildcards are not supported in namespace or label values
  # 
  # Example use cases:
  # 1. Select all pods in a namespace:
  #    selector { namespace = "production" }
  # 
  # 2. Select pods with specific labels:
  #    selector {
  #      namespace = "production"
  #      labels = {
  #        compute-type = "fargate"
  #      }
  #    }
  # 
  # 3. Multiple selectors for different workloads:
  #    selector { namespace = "production" }
  #    selector { namespace = "staging" }
  #    selector {
  #      namespace = "default"
  #      labels = { app = "batch-job" }
  #    }
  # 
  # Best practices:
  # - Use labels to provide fine-grained control over pod placement
  # - Consider creating separate profiles for different application tiers
  # - Document your selector logic for team members
  # - Test selectors in a non-production environment first
  # 
  # AWS Documentation:
  # Selectors are immutable. To change selectors, create a new profile.
  # --------------------------------------------------------------------------
  selector {
    # ------------------------------------------------------------------------
    # namespace (Required - within selector block)
    # ------------------------------------------------------------------------
    # Type: string
    # 
    # The Kubernetes namespace for pod selection. Pods must be in this 
    # namespace to be considered for scheduling on Fargate.
    # 
    # Common namespaces:
    # - "default": Default namespace for pods without a specified namespace
    # - "kube-system": System components (use with caution)
    # - "production", "staging", "dev": Environment-based namespaces
    # - Custom application namespaces
    # 
    # Note: The namespace must exist in the cluster before pods can be scheduled
    # ------------------------------------------------------------------------
    namespace = "production"

    # ------------------------------------------------------------------------
    # labels (Optional - within selector block)
    # ------------------------------------------------------------------------
    # Type: map of strings
    # 
    # Key-value map of Kubernetes labels that pods must have to be selected 
    # for this Fargate profile. If specified, pods must have ALL matching 
    # labels in addition to being in the correct namespace.
    # 
    # Label selection behavior:
    # - All specified labels must match (AND logic)
    # - Label values are case-sensitive
    # - Wildcards are not supported
    # - Empty map or omitted means no label filtering (all pods in namespace)
    # 
    # Example use cases:
    # 1. Select pods by application name:
    #    labels = { app = "web-server" }
    # 
    # 2. Select pods by compute type:
    #    labels = { compute-type = "fargate" }
    # 
    # 3. Multiple label criteria:
    #    labels = {
    #      app         = "api"
    #      environment = "production"
    #      tier        = "backend"
    #    }
    # 
    # Best practices:
    # - Use consistent labeling conventions across your organization
    # - Document required labels in your deployment manifests
    # - Consider using labels like "fargate: true" to explicitly opt-in
    # ------------------------------------------------------------------------
    labels = {
      compute-type = "fargate"
      app          = "web-api"
    }
  }

  # Additional selector example for different namespace
  selector {
    namespace = "staging"
  }

  # ============================================================================
  # OPTIONAL ARGUMENTS
  # ============================================================================

  # --------------------------------------------------------------------------
  # tags (Optional)
  # --------------------------------------------------------------------------
  # Type: map of strings
  # Default: {}
  # 
  # Key-value map of resource tags to assign to the Fargate profile. Tags are 
  # useful for cost allocation, resource organization, and access control.
  # 
  # Tag inheritance:
  # - If a provider default_tags configuration block is present, tags with 
  #   matching keys defined here will overwrite provider-level tags
  # - Tags are applied to the Fargate profile resource itself, not to pods
  # 
  # Common tag examples:
  # - Environment: "production", "staging", "development"
  # - Owner: Team or person responsible
  # - CostCenter: For billing allocation
  # - Project: Associated project name
  # - ManagedBy: "terraform"
  # 
  # Tag constraints:
  # - Maximum 50 tags per resource
  # - Key length: 1-128 characters
  # - Value length: 0-256 characters
  # - Keys and values are case-sensitive
  # - Reserved prefix: "aws:" (cannot be used)
  # 
  # Best practices:
  # - Use consistent tagging strategy across all resources
  # - Include tags for cost allocation and ownership
  # - Consider compliance requirements (e.g., data classification)
  # 
  # AWS Documentation:
  # Tags can be used with AWS Config rules and AWS IAM policies.
  # --------------------------------------------------------------------------
  tags = {
    Name        = "app-workloads-fargate-profile"
    Environment = "production"
    ManagedBy   = "terraform"
    CostCenter  = "engineering"
    Application = "web-api"
  }

  # ============================================================================
  # COMPUTED ATTRIBUTES (Read-Only)
  # ============================================================================
  # 
  # The following attributes are exported by this resource and can be 
  # referenced in other resources using the resource reference syntax:
  # aws_eks_fargate_profile.example.<attribute_name>
  # 
  # --------------------------------------------------------------------------
  # arn
  # --------------------------------------------------------------------------
  # Type: string (ARN)
  # 
  # The Amazon Resource Name (ARN) of the EKS Fargate Profile.
  # 
  # Format: arn:aws:eks:REGION:ACCOUNT_ID:fargateprofile/CLUSTER_NAME/PROFILE_NAME/UUID
  # 
  # Example:
  # "arn:aws:eks:us-east-1:123456789012:fargateprofile/my-cluster/app-workloads/12a34567-89bc-0def-1234-56789abcdef0"
  # 
  # Usage:
  # - Reference in IAM policies
  # - Use in AWS resource tags
  # - Cross-stack references
  # 
  # Access via: aws_eks_fargate_profile.example.arn
  # --------------------------------------------------------------------------
  
  # --------------------------------------------------------------------------
  # id
  # --------------------------------------------------------------------------
  # Type: string
  # 
  # The EKS Cluster name and EKS Fargate Profile name separated by a colon (:).
  # 
  # Format: CLUSTER_NAME:FARGATE_PROFILE_NAME
  # 
  # Example: "my-eks-cluster:app-workloads"
  # 
  # Usage:
  # - Used for resource imports
  # - Reference in data sources
  # - Terraform state management
  # 
  # Access via: aws_eks_fargate_profile.example.id
  # --------------------------------------------------------------------------
  
  # --------------------------------------------------------------------------
  # status
  # --------------------------------------------------------------------------
  # Type: string
  # 
  # The status of the EKS Fargate Profile. Indicates the current operational 
  # state of the profile.
  # 
  # Possible values:
  # - CREATING: Profile is being created
  # - ACTIVE: Profile is active and ready to schedule pods
  # - DELETING: Profile is being deleted
  # - CREATE_FAILED: Profile creation failed (check AWS CloudTrail for details)
  # - DELETE_FAILED: Profile deletion failed
  # 
  # Notes:
  # - Only ACTIVE profiles can schedule pods
  # - Profile must be ACTIVE before creating another profile in the same cluster
  # - Deletion may take time if pods are still running
  # 
  # Access via: aws_eks_fargate_profile.example.status
  # --------------------------------------------------------------------------
  
  # --------------------------------------------------------------------------
  # tags_all
  # --------------------------------------------------------------------------
  # Type: map of strings
  # 
  # A map of all tags assigned to the resource, including those inherited 
  # from the provider default_tags configuration block.
  # 
  # This includes:
  # - Tags explicitly defined in the resource's tags argument
  # - Tags inherited from provider-level default_tags
  # 
  # Usage:
  # - Audit complete tag set on resource
  # - Reference in outputs or other resources
  # - Verify tag propagation
  # 
  # Access via: aws_eks_fargate_profile.example.tags_all
  # --------------------------------------------------------------------------
}

# ============================================================================
# EXAMPLE: Complete EKS Fargate Profile Setup
# ============================================================================
# 
# This example demonstrates a complete setup including:
# - IAM role for Fargate pod execution
# - IAM role policy attachment
# - Fargate profile with multiple selectors
# ============================================================================

# IAM role for EKS Fargate pod execution
resource "aws_iam_role" "fargate_pod_execution" {
  name = "eks-fargate-pod-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks-fargate-pods.amazonaws.com"
      }
    }]
  })

  tags = {
    Name      = "EKS Fargate Pod Execution Role"
    ManagedBy = "terraform"
  }
}

# Attach the AWS managed policy for Fargate pod execution
resource "aws_iam_role_policy_attachment" "fargate_pod_execution_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
  role       = aws_iam_role.fargate_pod_execution.name
}

# Fargate profile with multiple selectors
resource "aws_eks_fargate_profile" "complete_example" {
  cluster_name           = aws_eks_cluster.main.name
  fargate_profile_name   = "complete-app-profile"
  pod_execution_role_arn = aws_iam_role.fargate_pod_execution.arn
  subnet_ids             = aws_subnet.private[*].id

  # Selector for production namespace with Fargate label
  selector {
    namespace = "production"
    labels = {
      compute-type = "fargate"
    }
  }

  # Selector for all pods in staging namespace
  selector {
    namespace = "staging"
  }

  # Selector for batch jobs in default namespace
  selector {
    namespace = "default"
    labels = {
      workload-type = "batch"
    }
  }

  tags = {
    Name        = "complete-app-fargate-profile"
    Environment = "multi-env"
    ManagedBy   = "terraform"
  }

  # Ensure the IAM role is created before the Fargate profile
  depends_on = [
    aws_iam_role_policy_attachment.fargate_pod_execution_policy
  ]
}

# ============================================================================
# IMPORT EXAMPLE
# ============================================================================
# 
# To import an existing EKS Fargate Profile:
# 
# terraform import aws_eks_fargate_profile.example my-cluster:my-profile
# 
# Format: CLUSTER_NAME:FARGATE_PROFILE_NAME
# ============================================================================

# ============================================================================
# OUTPUTS EXAMPLE
# ============================================================================
# 
# Example outputs for referencing Fargate profile attributes
# ============================================================================

output "fargate_profile_arn" {
  description = "The ARN of the EKS Fargate Profile"
  value       = aws_eks_fargate_profile.example.arn
}

output "fargate_profile_id" {
  description = "The ID of the EKS Fargate Profile (cluster:profile format)"
  value       = aws_eks_fargate_profile.example.id
}

output "fargate_profile_status" {
  description = "The status of the EKS Fargate Profile"
  value       = aws_eks_fargate_profile.example.status
}

# ============================================================================
# ADDITIONAL NOTES AND BEST PRACTICES
# ============================================================================
# 
# 1. Subnet Configuration:
#    - Fargate profiles require private subnets with NAT gateway
#    - Subnets must be tagged with: kubernetes.io/cluster/CLUSTER_NAME
#    - Ensure sufficient IP address space for pod scaling
# 
# 2. IAM Role Requirements:
#    - Pod execution role must trust eks-fargate-pods.amazonaws.com
#    - Must have AmazonEKSFargatePodExecutionRolePolicy attached
#    - Role is used by kubelet running on Fargate infrastructure
# 
# 3. Selector Strategy:
#    - Maximum 5 selectors per profile
#    - Selectors are immutable (cannot be modified after creation)
#    - Use labels for fine-grained pod placement control
#    - Consider creating separate profiles for different application tiers
# 
# 4. Profile Management:
#    - Profiles cannot be modified, only replaced
#    - To change selectors, create a new profile and delete the old one
#    - Ensure no pods are running before deleting a profile
#    - Only one profile can be in CREATING/DELETING state at a time per cluster
# 
# 5. Cost Optimization:
#    - Fargate pricing is based on vCPU and memory resources
#    - Right-size pod resource requests for cost efficiency
#    - Consider using EC2 node groups for long-running workloads
#    - Use Fargate for bursty or variable workloads
# 
# 6. Networking Considerations:
#    - Each pod gets its own ENI (Elastic Network Interface)
#    - Security groups are applied at the pod level
#    - Ensure VPC has sufficient ENIs available
#    - Private subnets must have route to NAT gateway
# 
# 7. Security Best Practices:
#    - Use least-privilege IAM policies for pod execution role
#    - Implement network policies to restrict pod-to-pod communication
#    - Use AWS Secrets Manager or Parameter Store for sensitive data
#    - Enable CloudWatch Logs for pod logging
#    - Regularly update Fargate platform version for security patches
# 
# 8. Monitoring and Logging:
#    - Configure Fluent Bit or CloudWatch Container Insights
#    - Monitor Fargate profile status changes
#    - Set up CloudWatch alarms for pod failures
#    - Use AWS X-Ray for distributed tracing
# 
# 9. Troubleshooting:
#    - Check pod execution role permissions if pods fail to start
#    - Verify subnet tags are correctly set
#    - Ensure NAT gateway is properly configured
#    - Review CloudTrail logs for API errors
#    - Check pod resource requests/limits
# 
# 10. Migration Considerations:
#     - Plan migration from EC2 node groups to Fargate
#     - Test workload compatibility with Fargate
#     - Consider using both EC2 and Fargate for hybrid approach
#     - Update CI/CD pipelines to set appropriate pod labels
# 
# ============================================================================
# RELATED RESOURCES
# ============================================================================
# 
# - aws_eks_cluster: EKS cluster that this profile belongs to
# - aws_iam_role: IAM role for pod execution
# - aws_iam_role_policy_attachment: Attach policies to execution role
# - aws_subnet: Private subnets for pod placement
# - aws_vpc: VPC containing the EKS cluster
# - aws_security_group: Security groups for pod networking
# - aws_cloudwatch_log_group: Log groups for pod logs
# 
# ============================================================================
# REFERENCES
# ============================================================================
# 
# AWS Documentation:
# - Fargate Profile Overview: https://docs.aws.amazon.com/eks/latest/userguide/fargate-profile.html
# - Getting Started with Fargate: https://docs.aws.amazon.com/eks/latest/userguide/fargate-getting-started.html
# - Pod Execution Role: https://docs.aws.amazon.com/eks/latest/userguide/pod-execution-role.html
# - CreateFargateProfile API: https://docs.aws.amazon.com/eks/latest/APIReference/API_CreateFargateProfile.html
# 
# Terraform Documentation:
# - Resource Documentation: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_fargate_profile
# - Provider Configuration: https://registry.terraform.io/providers/hashicorp/aws/latest/docs
# 
# ============================================================================
