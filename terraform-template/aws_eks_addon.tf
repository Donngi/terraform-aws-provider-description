################################################################################
# Terraform AWS Resource: aws_eks_addon
# Provider Version: 6.28.0
#
# Description:
# Manages an Amazon EKS add-on. Add-ons are software that provide supporting
# operational capabilities to Kubernetes applications, including observability
# agents, Kubernetes drivers for networking/compute/storage, and other essential
# cluster functionality.
#
# AWS Official Documentation:
# https://docs.aws.amazon.com/eks/latest/userguide/eks-add-ons.html
#
# Terraform Registry Documentation:
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon
################################################################################

resource "aws_eks_addon" "example" {
  #-----------------------------------------------------------------------------
  # REQUIRED ARGUMENTS
  #-----------------------------------------------------------------------------

  # addon_name - (Required) string
  # Name of the EKS add-on. The name must match one of the names returned by
  # the AWS CLI command: aws eks describe-addon-versions
  #
  # Common add-ons include:
  # - vpc-cni: Amazon VPC CNI plugin for Kubernetes (pod networking)
  # - kube-proxy: Kubernetes network proxy (service networking)
  # - coredns: CoreDNS for cluster DNS resolution
  # - aws-ebs-csi-driver: Amazon EBS CSI driver for persistent storage
  # - aws-efs-csi-driver: Amazon EFS CSI driver for shared file storage
  # - aws-mountpoint-s3-csi-driver: Mountpoint for Amazon S3 CSI driver
  # - eks-pod-identity-agent: EKS Pod Identity agent for IAM credentials
  # - snapshot-controller: Volume snapshot controller
  # - adot: AWS Distro for OpenTelemetry (observability)
  #
  # AWS Documentation:
  # https://docs.aws.amazon.com/eks/latest/userguide/workloads-add-ons-available-eks.html
  addon_name = "vpc-cni"

  # cluster_name - (Required) string
  # Name of the EKS Cluster where the add-on will be installed.
  # Must reference an existing EKS cluster in the same region.
  #
  # Best Practice: Use a Terraform reference to ensure proper dependency ordering
  # Example: cluster_name = aws_eks_cluster.example.name
  cluster_name = "my-eks-cluster"

  #-----------------------------------------------------------------------------
  # OPTIONAL ARGUMENTS
  #-----------------------------------------------------------------------------

  # addon_version - (Optional) string
  # The version of the EKS add-on. Must match one of the versions returned by
  # aws eks describe-addon-versions --addon-name <addon-name>
  #
  # If not specified, AWS will install the default version for your cluster's
  # Kubernetes version. Format typically follows semantic versioning with a
  # build suffix, e.g., "v1.15.1-eksbuild.1"
  #
  # Important Considerations:
  # - Different add-on versions may be compatible with different Kubernetes versions
  # - Check compatibility before upgrading cluster version or add-on version
  # - Use describe-addon-versions to see available versions and their Kubernetes compatibility
  # - Omitting this allows AWS to manage version selection automatically
  #
  # AWS Documentation:
  # https://docs.aws.amazon.com/cli/latest/reference/eks/describe-addon-versions.html
  addon_version = "v1.15.1-eksbuild.1"

  # configuration_values - (Optional) string (JSON)
  # Custom configuration values for the add-on provided as a single JSON string.
  # This JSON string must match the JSON schema returned by:
  # aws eks describe-addon-configuration --addon-name <addon-name> --addon-version <version>
  #
  # The configuration schema varies by add-on and version. Common use cases:
  # - VPC CNI: Configure IPAM settings, prefix delegation, security groups
  # - CoreDNS: Adjust resource limits, replica counts, node selectors
  # - EBS CSI Driver: Set volume snapshot settings, encryption options
  #
  # Important Notes:
  # - Must be valid JSON that conforms to the add-on's schema
  # - Configuration changes may require add-on restart
  # - Use jsonencode() in Terraform for proper JSON formatting
  # - Not all add-ons support configuration values
  #
  # Example for VPC CNI:
  # configuration_values = jsonencode({
  #   env = {
  #     ENABLE_PREFIX_DELEGATION = "true"
  #     WARM_PREFIX_TARGET       = "1"
  #   }
  # })
  #
  # AWS Documentation:
  # https://docs.aws.amazon.com/eks/latest/APIReference/API_DescribeAddonConfiguration.html
  configuration_values = jsonencode({
    resources = {
      limits = {
        cpu    = "100m"
        memory = "128Mi"
      }
    }
  })

  # resolve_conflicts_on_create - (Optional) string
  # How to resolve field value conflicts when migrating a self-managed add-on
  # to an Amazon EKS add-on during creation.
  #
  # Valid Values:
  # - NONE: Amazon EKS doesn't change the value. The update might fail.
  # - OVERWRITE: Amazon EKS overwrites any conflicting fields with EKS add-on values
  #
  # Use Cases:
  # - NONE: Use when you want to preserve existing configurations and handle conflicts manually
  # - OVERWRITE: Use when migrating from self-managed to EKS-managed and want AWS defaults
  #
  # Default: NONE
  #
  # Important Considerations:
  # - Only applies when installing EKS add-on over existing self-managed add-on
  # - OVERWRITE will replace your custom configurations with AWS defaults
  # - Review differences before choosing OVERWRITE to avoid unexpected changes
  #
  # AWS Documentation:
  # https://docs.aws.amazon.com/eks/latest/APIReference/API_CreateAddon.html
  resolve_conflicts_on_create = "OVERWRITE"

  # resolve_conflicts_on_update - (Optional) string
  # How to resolve field value conflicts when updating an Amazon EKS add-on
  # if you've changed a value from the Amazon EKS default value.
  #
  # Valid Values:
  # - NONE: Don't resolve conflicts. The update might fail.
  # - OVERWRITE: Overwrite any conflicting fields with EKS add-on values
  # - PRESERVE: Preserve the existing custom values and don't overwrite them
  #
  # Use Cases:
  # - NONE: Fail updates if conflicts exist, requiring manual resolution
  # - OVERWRITE: Force AWS-managed values, losing custom configurations
  # - PRESERVE: Keep your custom configurations during updates (recommended for most cases)
  #
  # Default: NONE
  #
  # Important Considerations:
  # - PRESERVE allows you to maintain customizations while updating versions
  # - OVERWRITE will replace any manual changes made outside Terraform
  # - Use PRESERVE to maintain configurations not managed by Terraform
  # - EKS uses Kubernetes server-side apply to track field ownership
  #
  # AWS Documentation:
  # https://docs.aws.amazon.com/eks/latest/APIReference/API_UpdateAddon.html
  # https://docs.aws.amazon.com/eks/latest/userguide/kubernetes-field-management.html
  resolve_conflicts_on_update = "PRESERVE"

  # service_account_role_arn - (Optional) string (ARN)
  # The Amazon Resource Name (ARN) of an existing IAM role to bind to the
  # add-on's service account. This enables the add-on to make AWS API calls.
  #
  # IAM Roles for Service Accounts (IRSA):
  # - Provides fine-grained IAM permissions to Kubernetes service accounts
  # - More secure than using node IAM role permissions
  # - Follows principle of least privilege
  #
  # Prerequisites:
  # - IAM OIDC provider must be created for your EKS cluster
  # - IAM role must have trust relationship with cluster's OIDC provider
  # - Role must include necessary IAM permissions for the add-on
  #
  # Common Add-on IAM Requirements:
  # - VPC CNI: Requires EC2 and ENI management permissions
  # - EBS CSI Driver: Requires EBS volume management permissions
  # - EFS CSI Driver: Requires EFS access permissions
  # - Load Balancer Controller: Requires EC2, ELB, and ACM permissions
  #
  # If Not Specified:
  # - Add-on uses permissions from the node IAM role
  # - Less secure as all pods on node inherit same permissions
  #
  # Best Practice: Always specify a dedicated service account role with
  # minimal required permissions for production workloads.
  #
  # AWS Documentation:
  # https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html
  # https://docs.aws.amazon.com/eks/latest/userguide/enable-iam-roles-for-service-accounts.html
  service_account_role_arn = "arn:aws:iam::123456789012:role/eks-vpc-cni-role"

  # preserve - (Optional) bool
  # Indicates if you want to preserve the created Kubernetes resources when
  # deleting the EKS add-on from AWS.
  #
  # When true:
  # - Deleting the Terraform resource removes add-on from EKS API management
  # - Kubernetes resources (Deployments, DaemonSets, etc.) remain in cluster
  # - Add-on becomes self-managed but continues running
  #
  # When false (default):
  # - Deleting the Terraform resource removes both EKS add-on and Kubernetes resources
  # - Add-on functionality is completely removed from cluster
  #
  # Use Cases for preserve = true:
  # - Migrating from EKS-managed to self-managed add-ons
  # - Temporary removal from Terraform management
  # - Testing different add-on management approaches
  #
  # Use Cases for preserve = false:
  # - Complete add-on removal (e.g., switching to alternative CNI)
  # - Clean cluster teardown
  # - Standard lifecycle management
  #
  # Default: false
  #
  # Warning: Setting preserve = true means kubectl will show the add-on
  # resources even after Terraform destroy, which may cause confusion.
  preserve = false

  # tags - (Optional) map(string)
  # Key-value map of resource tags for the EKS add-on resource.
  #
  # Tag Behavior:
  # - Tags are applied to the EKS add-on resource in AWS (visible in EKS console)
  # - Tags are NOT automatically propagated to Kubernetes resources created by add-on
  # - If provider default_tags are configured, they merge with these tags
  # - Keys matching provider default_tags will be overwritten by these values
  #
  # Common Tagging Strategies:
  # - Environment: dev, staging, prod
  # - Owner/Team: team name or email
  # - Cost Center: for billing allocation
  # - Compliance: security or regulatory requirements
  #
  # Tag Constraints:
  # - Maximum 50 tags per resource
  # - Key length: 1-128 characters
  # - Value length: 0-256 characters
  # - Keys and values are case-sensitive
  #
  # Best Practice: Use consistent tagging strategy across all AWS resources
  # for better cost allocation, resource organization, and access control.
  #
  # AWS Documentation:
  # https://docs.aws.amazon.com/eks/latest/userguide/eks-using-tags.html
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
    Team        = "platform"
    CostCenter  = "engineering"
  }

  # region - (Optional) string
  # AWS Region where this add-on resource will be managed.
  #
  # Behavior:
  # - If not specified, uses the region from provider configuration
  # - Must match the region where the EKS cluster exists
  # - Cannot be changed after creation (forces replacement)
  #
  # Use Cases:
  # - Multi-region deployments with single provider configuration
  # - Explicit region specification for clarity
  # - Override default provider region for specific resources
  #
  # Best Practice: Usually omit this and rely on provider configuration
  # unless you have specific multi-region requirements.
  #
  # AWS Documentation:
  # https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-west-2"

  #-----------------------------------------------------------------------------
  # OPTIONAL NESTED BLOCK: pod_identity_association
  #-----------------------------------------------------------------------------

  # pod_identity_association - (Optional) block
  # Configuration for EKS Pod Identity association. This is an alternative to
  # IRSA (IAM Roles for Service Accounts) introduced in EKS 1.24+.
  #
  # EKS Pod Identity vs IRSA:
  # - Pod Identity: Newer, simpler setup, no OIDC provider needed
  # - IRSA: Older method, requires OIDC provider configuration
  #
  # Use Pod Identity when:
  # - Running EKS 1.24 or later
  # - Want simplified IAM integration without OIDC setup
  # - Need to associate multiple IAM roles per namespace
  #
  # Note: Some add-ons use service_account_role_arn (IRSA) instead of
  # Pod Identity. Check add-on documentation for supported methods.
  #
  # Block Structure:
  # pod_identity_association {
  #   role_arn        = "arn:aws:iam::123456789012:role/pod-identity-role"
  #   service_account = "addon-service-account"
  # }
  #
  # AWS Documentation:
  # https://docs.aws.amazon.com/eks/latest/userguide/pod-identities.html

  pod_identity_association {
    # role_arn - (Required within block) string (ARN)
    # The Amazon Resource Name (ARN) of the IAM role to associate with the
    # service account. The EKS Pod Identity agent manages credentials to
    # assume this role for applications running in pods using this service account.
    #
    # IAM Role Requirements:
    # - Trust policy must allow eks-pod-identity.amazonaws.com to assume role
    # - Must include permissions required by the add-on
    # - Can be more restrictive than node IAM role
    #
    # Trust Policy Example:
    # {
    #   "Version": "2012-10-17",
    #   "Statement": [{
    #     "Effect": "Allow",
    #     "Principal": {
    #       "Service": "pods.eks.amazonaws.com"
    #     },
    #     "Action": ["sts:AssumeRole", "sts:TagSession"]
    #   }]
    # }
    #
    # Security Best Practice: Grant only permissions required by the specific
    # add-on following the principle of least privilege.
    role_arn = "arn:aws:iam::123456789012:role/my-addon-pod-identity-role"

    # service_account - (Required within block) string
    # The name of the Kubernetes service account inside the cluster to
    # associate with the IAM role credentials.
    #
    # Service Account Behavior:
    # - Must match the service account used by the add-on
    # - EKS automatically injects IAM credentials as environment variables
    # - Pods using this service account can assume the specified IAM role
    #
    # Default Service Accounts by Add-on:
    # - VPC CNI: aws-node (in kube-system namespace)
    # - EBS CSI Driver: ebs-csi-controller-sa (in kube-system)
    # - EFS CSI Driver: efs-csi-controller-sa (in kube-system)
    # - Load Balancer Controller: aws-load-balancer-controller
    #
    # Note: Service account must exist in the cluster before add-on installation,
    # or the add-on will create it automatically.
    #
    # Check add-on's default service account with:
    # aws eks describe-addon-configuration --addon-name <addon-name>
    service_account = "my-addon-service-account"
  }

  #-----------------------------------------------------------------------------
  # EXPORTED ATTRIBUTES (Available after apply)
  #-----------------------------------------------------------------------------

  # These attributes are available after the resource is created and can be
  # referenced in other Terraform resources using: aws_eks_addon.example.<attribute>
  #
  # arn - string (ARN)
  # Amazon Resource Name (ARN) of the EKS add-on.
  # Format: arn:aws:eks:<region>:<account-id>:addon/<cluster-name>/<addon-name>/<addon-id>
  # Use for: IAM policies, resource references, CloudWatch monitoring
  #
  # id - string
  # EKS Cluster name and EKS Addon name separated by a colon.
  # Format: <cluster-name>:<addon-name>
  # Use for: Import existing add-ons, resource identification
  #
  # status - string
  # Current status of the EKS add-on.
  # Possible values:
  # - CREATING: Add-on is being installed
  # - ACTIVE: Add-on is running successfully
  # - CREATE_FAILED: Installation failed
  # - UPDATING: Add-on is being updated
  # - DELETING: Add-on is being removed
  # - DELETE_FAILED: Deletion failed
  # - DEGRADED: Add-on is running but with issues
  # - UPDATE_FAILED: Update failed
  # Use for: Conditional logic, monitoring, health checks
  #
  # created_at - string (RFC3339 timestamp)
  # Date and time when the EKS add-on was created.
  # Format: 2024-01-15T10:30:00Z
  # Use for: Auditing, age-based policies, sorting
  #
  # modified_at - string (RFC3339 timestamp)
  # Date and time when the EKS add-on was last updated.
  # Format: 2024-01-15T10:30:00Z
  # Use for: Change tracking, update monitoring, compliance
  #
  # tags_all - map(string)
  # Map of all tags assigned to the resource, including those inherited from
  # provider default_tags configuration block.
  # Use for: Complete tag visibility, compliance validation

  #-----------------------------------------------------------------------------
  # IMPORT SYNTAX
  #-----------------------------------------------------------------------------

  # Existing EKS add-ons can be imported using cluster name and add-on name:
  # terraform import aws_eks_addon.example my-cluster:vpc-cni

  #-----------------------------------------------------------------------------
  # COMMON PATTERNS AND EXAMPLES
  #-----------------------------------------------------------------------------

  # Example 1: VPC CNI with IPAM Configuration
  # ------------------------------------
  # resource "aws_eks_addon" "vpc_cni" {
  #   cluster_name = aws_eks_cluster.main.name
  #   addon_name   = "vpc-cni"
  #   addon_version = "v1.15.1-eksbuild.1"
  #
  #   configuration_values = jsonencode({
  #     env = {
  #       ENABLE_PREFIX_DELEGATION = "true"
  #       ENABLE_POD_ENI           = "true"
  #       POD_SECURITY_GROUP_ENFORCING_MODE = "standard"
  #     }
  #   })
  #
  #   service_account_role_arn = aws_iam_role.vpc_cni.arn
  #   resolve_conflicts_on_update = "PRESERVE"
  # }

  # Example 2: EBS CSI Driver with Encryption
  # ------------------------------------
  # resource "aws_eks_addon" "ebs_csi" {
  #   cluster_name = aws_eks_cluster.main.name
  #   addon_name   = "aws-ebs-csi-driver"
  #
  #   service_account_role_arn = aws_iam_role.ebs_csi.arn
  #
  #   tags = {
  #     Environment = "production"
  #     Addon       = "ebs-csi-driver"
  #   }
  # }

  # Example 3: CoreDNS with Custom Resource Limits
  # ------------------------------------
  # resource "aws_eks_addon" "coredns" {
  #   cluster_name = aws_eks_cluster.main.name
  #   addon_name   = "coredns"
  #
  #   configuration_values = jsonencode({
  #     resources = {
  #       limits = {
  #         cpu    = "100m"
  #         memory = "128Mi"
  #       }
  #       requests = {
  #         cpu    = "100m"
  #         memory = "128Mi"
  #       }
  #     }
  #   })
  #
  #   resolve_conflicts_on_update = "PRESERVE"
  # }

  # Example 4: Pod Identity Agent
  # ------------------------------------
  # resource "aws_eks_addon" "pod_identity" {
  #   cluster_name = aws_eks_cluster.main.name
  #   addon_name   = "eks-pod-identity-agent"
  #
  #   tags = {
  #     Purpose = "IAM integration"
  #   }
  # }

  #-----------------------------------------------------------------------------
  # IMPORTANT CONSIDERATIONS
  #-----------------------------------------------------------------------------

  # 1. Version Compatibility:
  #    - Always check add-on version compatibility with cluster Kubernetes version
  #    - Use: aws eks describe-addon-versions --kubernetes-version <version>
  #    - Some versions may not support all cluster versions

  # 2. Update Strategy:
  #    - Add-ons typically support rolling updates
  #    - Updates may cause temporary pod restarts
  #    - Test updates in non-production first
  #    - Use resolve_conflicts_on_update = "PRESERVE" to keep customizations

  # 3. IAM Permissions:
  #    - Always use service_account_role_arn or pod_identity_association
  #    - Don't rely on node IAM role for production workloads
  #    - Follow least privilege principle
  #    - Enable IAM OIDC provider before using IRSA

  # 4. Configuration Changes:
  #    - Some config changes require add-on restart
  #    - Validate JSON schema with describe-addon-configuration
  #    - Use jsonencode() for proper JSON formatting in Terraform
  #    - Not all add-ons support configuration_values

  # 5. Namespace Considerations:
  #    - Most add-ons install in kube-system namespace by default
  #    - Custom namespaces supported for some add-ons (check documentation)
  #    - Cannot change namespace after installation without recreation

  # 6. Monitoring and Troubleshooting:
  #    - Check add-on status regularly
  #    - Monitor CloudWatch logs for add-on errors
  #    - Use kubectl to inspect add-on pods: kubectl get pods -n kube-system
  #    - Review add-on events: kubectl describe deployment -n kube-system

  # 7. Cost Optimization:
  #    - Add-ons run on cluster nodes (no separate AWS charges)
  #    - Consider resource limits in configuration_values
  #    - Some add-ons may use AWS resources (EBS volumes, ELBs) with separate costs

  # 8. Deletion Behavior:
  #    - By default (preserve = false), deletion removes all Kubernetes resources
  #    - Set preserve = true to keep resources when removing from Terraform
  #    - Critical add-ons (vpc-cni, coredns, kube-proxy) needed for cluster operation

  # 9. Auto Mode Clusters:
  #    - EKS Auto Mode includes built-in functionality for some add-ons
  #    - May not need vpc-cni, kube-proxy, coredns, ebs-csi-driver
  #    - Add-ons have anti-affinity rules for compute type compatibility
  #    - Check supported compute types with describe-addon-versions

  # 10. Security Best Practices:
  #     - Enable add-on updates for security patches
  #     - Use latest compatible versions
  #     - Implement network policies for add-on workloads
  #     - Regularly review IAM permissions
  #     - Enable audit logging for add-on API calls
}

################################################################################
# Additional Usage Examples and Patterns
################################################################################

# Example: Complete VPC CNI Setup with IAM Role
# ------------------------------------
# resource "aws_iam_role" "vpc_cni" {
#   name = "eks-vpc-cni-role"
#
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [{
#       Effect = "Allow"
#       Principal = {
#         Federated = aws_iam_openid_connect_provider.eks.arn
#       }
#       Action = "sts:AssumeRoleWithWebIdentity"
#       Condition = {
#         StringEquals = {
#           "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub" = "system:serviceaccount:kube-system:aws-node"
#           "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:aud" = "sts.amazonaws.com"
#         }
#       }
#     }]
#   })
# }
#
# resource "aws_iam_role_policy_attachment" "vpc_cni" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
#   role       = aws_iam_role.vpc_cni.name
# }
#
# resource "aws_eks_addon" "vpc_cni" {
#   cluster_name             = aws_eks_cluster.main.name
#   addon_name               = "vpc-cni"
#   service_account_role_arn = aws_iam_role.vpc_cni.arn
#   resolve_conflicts_on_update = "PRESERVE"
# }

# Example: Multiple Add-ons with Dependencies
# ------------------------------------
# resource "aws_eks_addon" "vpc_cni" {
#   cluster_name = aws_eks_cluster.main.name
#   addon_name   = "vpc-cni"
# }
#
# resource "aws_eks_addon" "coredns" {
#   cluster_name = aws_eks_cluster.main.name
#   addon_name   = "coredns"
#
#   depends_on = [aws_eks_addon.vpc_cni]
# }
#
# resource "aws_eks_addon" "kube_proxy" {
#   cluster_name = aws_eks_cluster.main.name
#   addon_name   = "kube-proxy"
#
#   depends_on = [aws_eks_addon.vpc_cni]
# }

# Example: Conditional Add-on Creation
# ------------------------------------
# variable "enable_ebs_csi" {
#   type    = bool
#   default = true
# }
#
# resource "aws_eks_addon" "ebs_csi" {
#   count = var.enable_ebs_csi ? 1 : 0
#
#   cluster_name             = aws_eks_cluster.main.name
#   addon_name               = "aws-ebs-csi-driver"
#   service_account_role_arn = aws_iam_role.ebs_csi[0].arn
# }

################################################################################
# Troubleshooting Guide
################################################################################

# Issue 1: Add-on stuck in CREATE_FAILED or UPDATE_FAILED
# Solution:
# - Check EKS cluster logs in CloudWatch
# - Verify IAM role permissions and trust relationships
# - Check for conflicting self-managed add-on resources
# - Review configuration_values against schema
# - Ensure cluster has available node capacity

# Issue 2: Configuration changes not applying
# Solution:
# - Verify JSON schema with describe-addon-configuration
# - Check resolve_conflicts_on_update setting
# - Some changes require add-on version update
# - Manually delete add-on pods to force restart

# Issue 3: IAM permissions errors
# Solution:
# - Verify OIDC provider is created and configured
# - Check IAM role trust policy includes correct OIDC provider
# - Ensure service account name matches add-on's default
# - Validate IAM policy includes required permissions
# - Check CloudTrail for denied API calls

# Issue 4: Version compatibility issues
# Solution:
# - Run: aws eks describe-addon-versions --kubernetes-version <version>
# - Check add-on version supports your cluster version
# - Upgrade cluster version before add-on if needed
# - Review AWS documentation for breaking changes

# Issue 5: Add-on conflicts with existing resources
# Solution:
# - Use resolve_conflicts_on_create = "OVERWRITE" carefully
# - Back up existing configurations before migration
# - Remove self-managed add-on resources before installing EKS add-on
# - Check for duplicate DaemonSets or Deployments

################################################################################
# Related Resources and Useful Commands
################################################################################

# AWS CLI Commands:
# -----------------
# List available add-ons:
# aws eks describe-addon-versions --kubernetes-version 1.28

# Get add-on details:
# aws eks describe-addon --cluster-name <cluster> --addon-name <addon>

# List installed add-ons:
# aws eks list-addons --cluster-name <cluster>

# Get configuration schema:
# aws eks describe-addon-configuration --addon-name <addon> --addon-version <version>

# Update add-on:
# aws eks update-addon --cluster-name <cluster> --addon-name <addon> --addon-version <version>

# Kubectl Commands:
# -----------------
# Check add-on pods:
# kubectl get pods -n kube-system -l k8s-app=<addon-name>

# View add-on logs:
# kubectl logs -n kube-system -l k8s-app=<addon-name>

# Describe add-on deployment:
# kubectl describe deployment -n kube-system <addon-deployment>

# Related Terraform Resources:
# ----------------------------
# - aws_eks_cluster: The EKS cluster where add-ons run
# - aws_iam_role: IAM roles for add-on service accounts
# - aws_iam_openid_connect_provider: OIDC provider for IRSA
# - aws_eks_pod_identity_association: Standalone pod identity associations
# - aws_iam_role_policy_attachment: Attach policies to add-on roles

################################################################################
# References
################################################################################

# AWS Documentation:
# - EKS Add-ons Overview: https://docs.aws.amazon.com/eks/latest/userguide/eks-add-ons.html
# - Available AWS Add-ons: https://docs.aws.amazon.com/eks/latest/userguide/workloads-add-ons-available-eks.html
# - IRSA Setup: https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html
# - Pod Identity: https://docs.aws.amazon.com/eks/latest/userguide/pod-identities.html
# - Field Management: https://docs.aws.amazon.com/eks/latest/userguide/kubernetes-field-management.html
# - CreateAddon API: https://docs.aws.amazon.com/eks/latest/APIReference/API_CreateAddon.html
# - UpdateAddon API: https://docs.aws.amazon.com/eks/latest/APIReference/API_UpdateAddon.html
# - DescribeAddonConfiguration API: https://docs.aws.amazon.com/eks/latest/APIReference/API_DescribeAddonConfiguration.html

# Terraform Documentation:
# - aws_eks_addon Resource: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon
# - AWS Provider Configuration: https://registry.terraform.io/providers/hashicorp/aws/latest/docs

################################################################################

