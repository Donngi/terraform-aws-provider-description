# ==============================================================================
# AWS EC2 Image Builder Container Recipe - Annotated Reference Template
# Provider Version: 6.28.0
# ==============================================================================
#
# EC2 Image Builder Container Recipe is used to define the build instructions
# for creating customized Docker container images. It specifies the base image,
# components to install, and target repository where the built image will be
# stored (typically Amazon ECR).
#
# A container recipe includes:
# - Base container image (parent_image)
# - Build and test components
# - Dockerfile template for image customization
# - Target repository configuration (ECR)
# - Optional instance configuration for build/test environments
#
# Use Cases:
# - Creating standardized container images with security patches
# - Building custom application containers with pre-installed dependencies
# - Automating container image builds with consistent configurations
# - Integrating security scanning and validation into container builds
#
# Official Documentation:
# https://docs.aws.amazon.com/imagebuilder/latest/userguide/container-recipe-details.html
# https://docs.aws.amazon.com/imagebuilder/latest/APIReference/API_ContainerRecipe.html
# Terraform Registry:
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/imagebuilder_container_recipe
# ==============================================================================

resource "aws_imagebuilder_container_recipe" "example" {
  # ============================================================================
  # REQUIRED ARGUMENTS
  # ============================================================================

  # --------------------------------------------------------------------------
  # container_type - (Required) string
  # --------------------------------------------------------------------------
  # The type of container to create. Currently only Docker containers are
  # supported by AWS Image Builder.
  #
  # Valid Values:
  # - DOCKER: Creates a Docker container image
  #
  # Note: This value is case-sensitive and must be uppercase.
  # --------------------------------------------------------------------------
  container_type = "DOCKER"

  # --------------------------------------------------------------------------
  # name - (Required) string
  # --------------------------------------------------------------------------
  # The name of the container recipe. This name must be unique within your
  # AWS account and region.
  #
  # Naming Requirements:
  # - Must match pattern: ^[-_A-Za-z-0-9][-_A-Za-z0-9 ]{1,126}[-_A-Za-z-0-9]$
  # - Length: 1-128 characters
  # - Can contain letters, numbers, hyphens, underscores, and spaces
  #
  # Best Practices:
  # - Use descriptive names: "nginx-web-server", "java-api-base"
  # - Include purpose or application name
  # - Consider including environment if recipe is environment-specific
  #
  # Note: Changing this value will force replacement of the resource.
  # --------------------------------------------------------------------------
  name = "example-container-recipe"

  # --------------------------------------------------------------------------
  # parent_image - (Required) string
  # --------------------------------------------------------------------------
  # The base image for the container recipe. This can be:
  # - An Amazon-managed container image ARN
  # - A public Docker Hub image (e.g., "amazonlinux:latest")
  # - An ECR image URI
  #
  # Amazon-managed Image Examples:
  # - Amazon Linux 2: arn:aws:imagebuilder:region:aws:image/amazon-linux-x86-latest/x.x.x
  # - Ubuntu 20.04: arn:aws:imagebuilder:region:aws:image/ubuntu-server-20-lts-x86/x.x.x
  #
  # Custom Image Examples:
  # - ECR: 123456789012.dkr.ecr.us-east-1.amazonaws.com/my-base-image:latest
  # - Docker Hub: nginx:1.21-alpine
  #
  # Best Practices:
  # - Use specific version tags rather than "latest" for reproducibility
  # - Consider using Amazon-managed images for security and compliance
  # - Ensure the base image matches your target platform
  # --------------------------------------------------------------------------
  parent_image = "arn:aws:imagebuilder:us-east-1:aws:image/amazon-linux-x86-latest/x.x.x"

  # --------------------------------------------------------------------------
  # version - (Required) string
  # --------------------------------------------------------------------------
  # The semantic version of the container recipe. This must follow semantic
  # versioning format: major.minor.patch
  #
  # Format: X.Y.Z (e.g., "1.0.0", "2.1.3")
  # - X = Major version (breaking changes)
  # - Y = Minor version (new features, backward compatible)
  # - Z = Patch version (bug fixes)
  #
  # Version Management:
  # - Each version creates a new container recipe resource
  # - You can have multiple versions of the same recipe name
  # - Pipelines can reference specific versions or use semantic version
  #   wildcards (e.g., 1.0.x for latest patch)
  #
  # Best Practices:
  # - Increment major version for breaking changes
  # - Increment minor version for new component additions
  # - Increment patch version for component updates or bug fixes
  # - Document changes in recipe description
  #
  # Note: Changing this value will force replacement of the resource.
  # --------------------------------------------------------------------------
  version = "1.0.0"

  # ============================================================================
  # OPTIONAL ARGUMENTS
  # ============================================================================

  # --------------------------------------------------------------------------
  # description - (Optional) string
  # --------------------------------------------------------------------------
  # A description of the container recipe. Use this to document the purpose,
  # included components, and any special configurations.
  #
  # Best Practices:
  # - Describe what the container image is used for
  # - List key installed components or software
  # - Document any environment-specific configurations
  # - Include version change notes for tracking
  #
  # Example: "Production-ready NGINX web server with SSL/TLS, security
  # hardening, and CloudWatch monitoring agent. Includes company-standard
  # security patches and compliance configurations."
  # --------------------------------------------------------------------------
  description = "Example container recipe for demonstration purposes"

  # --------------------------------------------------------------------------
  # dockerfile_template_data - (Optional) string | Computed
  # --------------------------------------------------------------------------
  # The Dockerfile template used to build the image, provided as an inline
  # string. This template uses special Image Builder placeholders that are
  # replaced during the build process.
  #
  # Required Placeholders:
  # - {{{ imagebuilder:parentImage }}} - Replaced with the parent_image value
  # - {{{ imagebuilder:environments }}} - Environment variables set by components
  # - {{{ imagebuilder:components }}} - Commands from components in order
  #
  # Example Template:
  # ```
  # FROM {{{ imagebuilder:parentImage }}}
  # {{{ imagebuilder:environments }}}
  # {{{ imagebuilder:components }}}
  # ```
  #
  # Advanced Usage:
  # - Add custom RUN commands between placeholders
  # - Set additional environment variables
  # - Configure WORKDIR, EXPOSE, USER, etc.
  # - Install additional packages not covered by components
  #
  # Conflict Warning:
  # You must specify either dockerfile_template_data OR dockerfile_template_uri,
  # but not both. If neither is provided, Image Builder uses a default template.
  #
  # Best Practices:
  # - Keep templates simple and let components handle most customization
  # - Use multi-line string format (<<EOF...EOF) for better readability
  # - Include comments in the template for documentation
  # - Always include all three required placeholders
  # --------------------------------------------------------------------------
  dockerfile_template_data = <<-EOF
    FROM {{{ imagebuilder:parentImage }}}
    {{{ imagebuilder:environments }}}
    {{{ imagebuilder:components }}}
  EOF

  # --------------------------------------------------------------------------
  # dockerfile_template_uri - (Optional) string
  # --------------------------------------------------------------------------
  # The Amazon S3 URI for the Dockerfile template that will be used to build
  # the container image. Use this option when managing Dockerfile templates
  # in S3 for better version control or sharing across recipes.
  #
  # Format: s3://bucket-name/path/to/dockerfile-template
  # Example: s3://my-imagebuilder-templates/nginx/dockerfile-template.txt
  #
  # S3 Requirements:
  # - The S3 bucket must be in the same region as the container recipe
  # - Image Builder service must have read access to the S3 object
  # - Use bucket policies or IAM roles to grant access
  #
  # Template Requirements:
  # - Must include the same placeholders as dockerfile_template_data
  # - File can be plain text with any extension
  # - Maximum template size: 16 KB
  #
  # Use Cases:
  # - Sharing templates across multiple recipes
  # - Version controlling templates in a central location
  # - Separating template management from recipe management
  # - Using the same template with different components/configurations
  #
  # Conflict Warning:
  # You must specify either dockerfile_template_data OR dockerfile_template_uri,
  # but not both.
  # --------------------------------------------------------------------------
  # dockerfile_template_uri = "s3://my-bucket/templates/dockerfile-template.txt"

  # --------------------------------------------------------------------------
  # kms_key_id - (Optional) string
  # --------------------------------------------------------------------------
  # The ARN of the AWS KMS key used to encrypt the container image. This
  # encryption applies to the image stored in Amazon ECR.
  #
  # Format Options:
  # - Key ARN: arn:aws:kms:region:account-id:key/key-id
  # - Key ID: 12345678-1234-1234-1234-123456789012
  # - Alias ARN: arn:aws:kms:region:account-id:alias/alias-name
  # - Alias name: alias/my-key
  #
  # Encryption Scope:
  # - Encrypts the built container image in ECR
  # - Does not affect intermediate build artifacts
  # - Decryption happens automatically when pulling images (with proper permissions)
  #
  # IAM Requirements:
  # - Image Builder service role needs kms:Encrypt permission
  # - ECR users need kms:Decrypt permission to pull images
  # - Consider using key policies for fine-grained access control
  #
  # Best Practices:
  # - Use customer-managed KMS keys for sensitive production images
  # - Enable key rotation for enhanced security
  # - Use separate keys for different environments (dev/staging/prod)
  # - Tag KMS keys for cost tracking and access management
  #
  # Note: If not specified, ECR uses AWS-managed encryption.
  # --------------------------------------------------------------------------
  # kms_key_id = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"

  # --------------------------------------------------------------------------
  # platform_override - (Optional) string
  # --------------------------------------------------------------------------
  # Specifies the operating system platform when you use a custom base image.
  # This overrides the platform detected from the parent image.
  #
  # Valid Values:
  # - Linux: For Linux-based container images
  # - Windows: For Windows-based container images
  #
  # Use Cases:
  # - When using a custom parent image that Image Builder cannot auto-detect
  # - Explicitly setting platform for custom base images from private registries
  # - Ensuring correct platform when using multi-platform base images
  #
  # Note: Usually not needed when using Amazon-managed images or standard
  # Docker Hub images as the platform is automatically detected.
  # --------------------------------------------------------------------------
  # platform_override = "Linux"

  # --------------------------------------------------------------------------
  # region - (Optional) string | Computed
  # --------------------------------------------------------------------------
  # The AWS Region where this container recipe will be managed. If not
  # specified, defaults to the region set in the provider configuration.
  #
  # Multi-Region Considerations:
  # - Container recipes are region-specific resources
  # - To use in multiple regions, create the recipe in each region
  # - ARNs include the region and cannot be used cross-region
  # - Consider using AWS CloudFormation StackSets for multi-region deployments
  #
  # Use Cases:
  # - Explicitly managing resources in a specific region
  # - Multi-region deployments with different provider configurations
  # - Regional compliance requirements
  #
  # Reference: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # --------------------------------------------------------------------------
  # region = "us-east-1"

  # --------------------------------------------------------------------------
  # tags - (Optional) map(string)
  # --------------------------------------------------------------------------
  # A map of tags to assign to the container recipe. Tags help organize and
  # manage resources through cost allocation, access control, automation, and
  # resource grouping.
  #
  # Common Tag Keys:
  # - Name: Human-readable identifier
  # - Environment: dev, staging, prod
  # - Application: Application or service name
  # - Team: Team or department responsible
  # - CostCenter: For cost allocation
  # - ManagedBy: terraform, cloudformation, manual
  # - Version: Application or image version
  # - Compliance: Compliance framework (e.g., PCI, HIPAA)
  #
  # Best Practices:
  # - Use consistent tag keys across all resources
  # - Implement a tagging strategy at the organization level
  # - Use tags for automated compliance checking
  # - Consider AWS Organizations tag policies
  # - Tags can be used in IAM policies for conditional access
  #
  # Provider default_tags:
  # If configured with a provider default_tags configuration block, tags with
  # matching keys will overwrite those defined at the provider level.
  #
  # Note: Tags are inherited by container images built from this recipe.
  #
  # Reference: https://docs.aws.amazon.com/general/latest/gr/aws_tagging.html
  # --------------------------------------------------------------------------
  tags = {
    Name        = "example-container-recipe"
    Environment = "production"
    ManagedBy   = "terraform"
    Application = "web-services"
  }

  # --------------------------------------------------------------------------
  # working_directory - (Optional) string
  # --------------------------------------------------------------------------
  # The working directory to be used during build and test workflows. This
  # sets the default directory where Image Builder executes component commands.
  #
  # Format: Unix-style path (e.g., /tmp/workdir, /app/build)
  #
  # Use Cases:
  # - Setting a specific directory for build artifacts
  # - Organizing temporary files during the build process
  # - Matching the working directory expected by components
  # - Ensuring consistent build environments
  #
  # Component Interaction:
  # - Components can reference this directory in their scripts
  # - Files created here are available to subsequent components
  # - Directory is created automatically if it doesn't exist
  #
  # Best Practices:
  # - Use a dedicated directory separate from application directories
  # - Consider using /tmp for temporary build files
  # - Ensure the directory path is valid for the target platform
  # - Document the working directory in component documentation
  #
  # Default Behavior:
  # If not specified, Image Builder uses a default working directory.
  # --------------------------------------------------------------------------
  # working_directory = "/tmp/imagebuilder"

  # ============================================================================
  # NESTED BLOCKS - REQUIRED
  # ============================================================================

  # --------------------------------------------------------------------------
  # component - (Required) block | Min Items: 1
  # --------------------------------------------------------------------------
  # Ordered configuration blocks with components for the container recipe.
  # Components define the customization and software to install in the
  # container image. At least one component is required.
  #
  # Component Execution:
  # - Components are executed in the order they are defined
  # - Each component can be a build component or test component
  # - Build components modify the image (install software, configure settings)
  # - Test components validate the image (run tests, security scans)
  #
  # Maximum Components:
  # - Up to 20 build and test components combined
  # - At least 1 component is required
  #
  # Component Sources:
  # - AWS-managed components (provided by AWS)
  # - Custom components (created in your account)
  # - Shared components (shared from other accounts)
  #
  # Ordering Best Practices:
  # - Place dependency installation components first
  # - Add configuration components after installations
  # - Place validation and test components last
  # - Consider component interdependencies
  # --------------------------------------------------------------------------
  component {
    # ------------------------------------------------------------------------
    # component_arn - (Required) string
    # ------------------------------------------------------------------------
    # The Amazon Resource Name (ARN) of the Image Builder Component to
    # associate with this container recipe.
    #
    # ARN Format:
    # arn:aws:imagebuilder:region:account-id:component/component-name/version
    #
    # Component Types:
    # - Build components: Modify the container image
    # - Test components: Validate the container image
    #
    # Version Specification:
    # - Specific version: component-name/1.0.0
    # - Latest patch: component-name/1.0.x
    # - Latest minor: component-name/1.x.x
    # - Latest version: component-name/x.x.x
    #
    # AWS-Managed Components Examples:
    # - arn:aws:imagebuilder:region:aws:component/update-linux/x.x.x
    # - arn:aws:imagebuilder:region:aws:component/aws-cli-version-2-linux/x.x.x
    #
    # Note: Wildcards (x.x.x) automatically use the latest matching version.
    # This is recommended for AWS-managed components to get latest updates.
    # ------------------------------------------------------------------------
    component_arn = "arn:aws:imagebuilder:us-east-1:123456789012:component/my-component/1.0.0"

    # ------------------------------------------------------------------------
    # parameter - (Optional) block
    # ------------------------------------------------------------------------
    # Configuration blocks for parameters to pass to the component. Parameters
    # allow customization of component behavior without modifying the component
    # definition itself.
    #
    # Use Cases:
    # - Passing environment-specific values
    # - Customizing component behavior per recipe
    # - Providing input values required by the component
    # - Overriding component default values
    #
    # Parameter Types:
    # Components define which parameters they accept and their types. Check
    # the component definition for available parameters.
    # ------------------------------------------------------------------------
    parameter {
      # ----------------------------------------------------------------------
      # name - (Required) string
      # ----------------------------------------------------------------------
      # The name of the component parameter. This must match a parameter
      # defined in the component's YAML definition.
      #
      # Parameter names are defined by the component author. Refer to the
      # component documentation or YAML definition for valid parameter names.
      #
      # Example component parameter definitions:
      # - Version: Software version to install
      # - InstallPath: Installation directory
      # - EnableFeature: Boolean flag to enable/disable features
      # - ConfigFile: Path to configuration file
      # ----------------------------------------------------------------------
      name = "Parameter1"

      # ----------------------------------------------------------------------
      # value - (Required) string
      # ----------------------------------------------------------------------
      # The value for the named component parameter. All values are passed
      # as strings, but components can interpret them as different types
      # (boolean, number, path, etc.).
      #
      # Value Formats:
      # - String values: "my-value"
      # - Boolean values: "true", "false"
      # - Numeric values: "123", "3.14"
      # - Paths: "/path/to/file"
      # - URLs: "https://example.com/file"
      #
      # Terraform Variables:
      # You can use Terraform variables and expressions:
      # - var.parameter_value
      # - "${var.prefix}-value"
      # - jsonencode(local.config_map)
      #
      # Best Practices:
      # - Validate parameter values against component requirements
      # - Use Terraform variables for environment-specific values
      # - Document parameter purposes in comments
      # - Consider using locals for complex value construction
      # ----------------------------------------------------------------------
      value = "Value1"
    }

    # Additional parameter blocks can be added as needed
    parameter {
      name  = "Parameter2"
      value = "Value2"
    }
  }

  # Additional component blocks can be added (up to 20 total)
  # component {
  #   component_arn = "arn:aws:imagebuilder:us-east-1:123456789012:component/another-component/1.0.0"
  # }

  # --------------------------------------------------------------------------
  # target_repository - (Required) block | Min Items: 1 | Max Items: 1
  # --------------------------------------------------------------------------
  # The destination repository for the container image. This specifies where
  # the built container image will be pushed after successful build and test.
  #
  # Supported Services:
  # Currently only Amazon Elastic Container Registry (ECR) is supported as
  # the target repository.
  #
  # Repository Lifecycle:
  # - The ECR repository must exist before creating the recipe
  # - Image Builder needs permissions to push to the repository
  # - Built images are tagged automatically by Image Builder
  # - Multiple images can be stored in the same repository
  #
  # Required Permissions:
  # The Image Builder service role must have:
  # - ecr:GetAuthorizationToken
  # - ecr:BatchCheckLayerAvailability
  # - ecr:GetDownloadUrlForLayer
  # - ecr:BatchGetImage
  # - ecr:PutImage
  # - ecr:InitiateLayerUpload
  # - ecr:UploadLayerPart
  # - ecr:CompleteLayerUpload
  # --------------------------------------------------------------------------
  target_repository {
    # ------------------------------------------------------------------------
    # repository_name - (Required) string
    # ------------------------------------------------------------------------
    # The name of the container repository where the output container image
    # will be stored. For ECR, this is the repository name (not the full URI).
    #
    # Format: repository-name (e.g., "my-app", "web-servers/nginx")
    #
    # Repository Naming:
    # - Can include namespaces with forward slashes (e.g., team/app-name)
    # - Must follow ECR naming rules: lowercase, alphanumeric, hyphens,
    #   underscores, and forward slashes
    # - Cannot start or end with forward slashes
    #
    # Image Tagging:
    # Image Builder automatically tags images with:
    # - Recipe version
    # - Build timestamp
    # - Semantic version patterns
    #
    # Example:
    # If repository_name is "my-app" and recipe version is "1.0.0", the
    # built image will be pushed to:
    # 123456789012.dkr.ecr.region.amazonaws.com/my-app:1.0.0
    #
    # Best Practices:
    # - Use repository names that match your application names
    # - Consider using namespaces for organizing repositories
    # - Ensure repository exists before running the pipeline
    # - Configure ECR lifecycle policies to manage image retention
    # - Use ECR scanning for vulnerability detection
    # ------------------------------------------------------------------------
    repository_name = "example-repository"

    # ------------------------------------------------------------------------
    # service - (Required) string
    # ------------------------------------------------------------------------
    # The service in which this image is registered. Currently only Amazon
    # Elastic Container Registry (ECR) is supported.
    #
    # Valid Values:
    # - ECR: Amazon Elastic Container Registry
    #
    # ECR Features:
    # - Fully managed Docker container registry
    # - Integrated with ECS, EKS, and Lambda
    # - Built-in image scanning for vulnerabilities
    # - Lifecycle policies for automatic cleanup
    # - Cross-region and cross-account replication
    # - Encryption at rest using AWS KMS
    #
    # Future Support:
    # AWS may add support for additional container registries in the future,
    # but currently ECR is the only supported option.
    #
    # Note: This value is case-sensitive and must be uppercase.
    # ------------------------------------------------------------------------
    service = "ECR"
  }

  # ============================================================================
  # NESTED BLOCKS - OPTIONAL
  # ============================================================================

  # --------------------------------------------------------------------------
  # instance_configuration - (Optional) block | Max Items: 1
  # --------------------------------------------------------------------------
  # Configuration block used to configure an instance for building and testing
  # container images. Image Builder launches an EC2 instance to build the
  # container image, and this block allows you to customize that instance.
  #
  # Build Instance Purpose:
  # - Provides isolated environment for building container images
  # - Executes Dockerfile instructions and component scripts
  # - Runs test components for validation
  # - Instance is automatically terminated after build/test completes
  #
  # Use Cases:
  # - Customizing the build instance AMI
  # - Configuring storage for large builds
  # - Adding encrypted volumes for security
  # - Optimizing I/O for build performance
  #
  # Cost Considerations:
  # - Build instances incur EC2 charges during the build/test process
  # - Larger instances complete builds faster but cost more
  # - Storage configurations affect EBS costs
  # - Consider build frequency when sizing instances
  #
  # Default Behavior:
  # If not specified, Image Builder uses an appropriate ECS-optimized AMI
  # and default storage configuration.
  # --------------------------------------------------------------------------
  # instance_configuration {
  #
  #   # ------------------------------------------------------------------------
  #   # image - (Optional) string
  #   # ------------------------------------------------------------------------
  #   # The AMI ID to use as the base image for the container build and test
  #   # instance. This is the EC2 instance that will build your container image,
  #   # not the container base image itself (that's parent_image).
  #   #
  #   # AMI Requirements:
  #   # - Must be an ECS-optimized AMI or have Docker pre-installed
  #   # - Should be in the same region as the container recipe
  #   # - Must have SSM agent installed for Image Builder communication
  #   #
  #   # AMI ID Sources:
  #   # - AWS ECS-optimized AMIs: ami-xxxxxxxxxxxxxxxxx
  #   # - Custom AMIs with Docker: Your custom AMI ID
  #   # - AWS Systems Manager Parameter Store:
  #   #   /aws/service/ecs/optimized-ami/amazon-linux-2/recommended/image_id
  #   #
  #   # Use Cases:
  #   # - Using a specific ECS-optimized AMI version for consistency
  #   # - Custom AMI with pre-installed build tools
  #   # - AMI with company-required security agents
  #   # - Compliance-approved AMIs
  #   #
  #   # Best Practices:
  #   # - Use latest ECS-optimized AMI for security patches
  #   # - Consider using SSM parameters for dynamic AMI selection
  #   # - Test custom AMIs thoroughly before production use
  #   # - Document any special AMI requirements
  #   #
  #   # Default Behavior:
  #   # If not specified, Image Builder automatically selects an appropriate
  #   # ECS-optimized AMI based on the container platform (Linux/Windows).
  #   # ------------------------------------------------------------------------
  #   # image = "ami-0123456789abcdef0"
  #
  #   # ------------------------------------------------------------------------
  #   # block_device_mapping - (Optional) block
  #   # ------------------------------------------------------------------------
  #   # Configuration blocks with block device mappings for the build instance.
  #   # This allows you to customize the storage volumes attached to the EC2
  #   # instance used for building container images.
  #   #
  #   # Use Cases:
  #   # - Increasing storage for large container builds
  #   # - Using faster storage types (io2, gp3) for performance
  #   # - Encrypting build volumes for security compliance
  #   # - Optimizing IOPS and throughput for large layer operations
  #   #
  #   # Common Scenarios:
  #   # - Default 8GB may be insufficient for large images
  #   # - Security requirements mandate encrypted volumes
  #   # - Performance optimization for faster builds
  #   # - Compliance requirements for specific volume types
  #   #
  #   # Note: Block devices are attached to the build instance, not the
  #   # container image itself. These are temporary and deleted after build.
  #   # ------------------------------------------------------------------------
  #   # block_device_mapping {
  #   #
  #   #   # ----------------------------------------------------------------------
  #   #   # device_name - (Optional) string
  #   #   # ----------------------------------------------------------------------
  #   #   # The name of the device within the EC2 instance. Device names vary by
  #   #   # instance type and virtualization type.
  #   #   #
  #   #   # Linux Device Names:
  #   #   # - /dev/sda1, /dev/sdf, /dev/sdg (older instances)
  #   #   # - /dev/xvda, /dev/xvdf, /dev/xvdg (HVM instances)
  #   #   # - /dev/nvme0n1, /dev/nvme1n1 (Nitro-based instances)
  #   #   #
  #   #   # Windows Device Names:
  #   #   # - xvdf, xvdg, xvdh (appears as different drive letters)
  #   #   #
  #   #   # Root Device:
  #   #   # The root device name depends on the AMI. Common values:
  #   #   # - Amazon Linux 2: /dev/xvda
  #   #   # - Ubuntu: /dev/sda1
  #   #   #
  #   #   # Additional Devices:
  #   #   # Use sequential names: /dev/sdf, /dev/sdg, /dev/sdh, etc.
  #   #   #
  #   #   # Best Practices:
  #   #   # - Check AMI documentation for correct root device name
  #   #   # - Use /dev/xvd* naming for compatibility
  #   #   # - Avoid conflicts with existing device names
  #   #   # ----------------------------------------------------------------------
  #   #   # device_name = "/dev/xvda"
  #   #
  #   #   # ----------------------------------------------------------------------
  #   #   # no_device - (Optional) bool | Computed
  #   #   # ----------------------------------------------------------------------
  #   #   # Set to true to remove a mapping from the parent image. This suppresses
  #   #   # a device mapping that is in the base AMI.
  #   #   #
  #   #   # Use Cases:
  #   #   # - Removing instance store volumes inherited from AMI
  #   #   # - Disabling unused EBS volumes from parent AMI
  #   #   # - Preventing automatic device attachment
  #   #   #
  #   #   # Important Notes:
  #   #   # - Cannot be used with other attributes (ebs, virtual_name)
  #   #   # - Only valid for devices present in the parent AMI
  #   #   # - Primarily used for instance store volumes
  #   #   #
  #   #   # Example:
  #   #   # To suppress /dev/sdb (instance store) from parent AMI:
  #   #   # device_name = "/dev/sdb"
  #   #   # no_device = true
  #   #   # ----------------------------------------------------------------------
  #   #   # no_device = true
  #   #
  #   #   # ----------------------------------------------------------------------
  #   #   # virtual_name - (Optional) string
  #   #   # ----------------------------------------------------------------------
  #   #   # The virtual device name for instance store volumes. Instance store
  #   #   # provides temporary block-level storage physically attached to the host.
  #   #   #
  #   #   # Format: ephemeralN (where N is 0, 1, 2, 3, etc.)
  #   #   # Examples: ephemeral0, ephemeral1, ephemeral2
  #   #   #
  #   #   # Instance Store Characteristics:
  #   #   # - Temporary storage (data lost on stop/terminate)
  #   #   # - Very high IOPS and throughput
  #   #   # - No additional cost (included with instance)
  #   #   # - Size depends on instance type
  #   #   #
  #   #   # Use Cases:
  #   #   # - Temporary build cache for faster builds
  #   #   # - Scratch space for large operations
  #   #   # - High-performance temporary storage needs
  #   #   #
  #   #   # Availability:
  #   #   # Not all instance types support instance store. Check instance type
  #   #   # specifications. Common instance families with instance store:
  #   #   # - c5d, m5d, r5d (d suffix indicates instance store)
  #   #   # - i3, i3en (storage-optimized)
  #   #   #
  #   #   # Note: Cannot be used with ebs or no_device in the same block.
  #   #   # ----------------------------------------------------------------------
  #   #   # virtual_name = "ephemeral0"
  #   #
  #   #   # ----------------------------------------------------------------------
  #   #   # ebs - (Optional) block | Max Items: 1
  #   #   # ----------------------------------------------------------------------
  #   #   # Configuration block with Elastic Block Storage (EBS) settings for the
  #   #   # device. EBS volumes provide persistent block storage for EC2 instances.
  #   #   #
  #   #   # EBS Volume Types:
  #   #   # - gp3: General Purpose SSD (newest, best price/performance)
  #   #   # - gp2: General Purpose SSD (legacy)
  #   #   # - io2: Provisioned IOPS SSD (highest durability)
  #   #   # - io1: Provisioned IOPS SSD (legacy)
  #   #   # - st1: Throughput Optimized HDD
  #   #   # - sc1: Cold HDD
  #   #   #
  #   #   # Use Cases:
  #   #   # - Increasing root volume size for large builds
  #   #   # - Adding encrypted volumes for security
  #   #   # - Configuring high-performance storage for builds
  #   #   # - Attaching volumes from snapshots
  #   #   # ----------------------------------------------------------------------
  #   #   # ebs {
  #   #   #
  #   #   #   # --------------------------------------------------------------------
  #   #   #   # delete_on_termination - (Optional) string
  #   #   #   # --------------------------------------------------------------------
  #   #   #   # Whether to delete the volume on instance termination. For build
  #   #   #   # instances, this should almost always be true to avoid orphaned
  #   #   #   # volumes.
  #   #   #   #
  #   #   #   # Valid Values:
  #   #   #   # - "true": Delete volume when instance terminates (recommended)
  #   #   #   # - "false": Keep volume after instance terminates
  #   #   #   #
  #   #   #   # Note: Despite being a boolean value, it's passed as a string.
  #   #   #   #
  #   #   #   # Default Behavior:
  #   #   #   # If not specified, inherits from parent image. Most AMIs default
  #   #   #   # to true for root volumes.
  #   #   #   #
  #   #   #   # Best Practices:
  #   #   #   # - Always use "true" for build instances to avoid costs
  #   #   #   # - Only use "false" if you need to debug failed builds
  #   #   #   # --------------------------------------------------------------------
  #   #   #   # delete_on_termination = "true"
  #   #   #
  #   #   #   # --------------------------------------------------------------------
  #   #   #   # encrypted - (Optional) string
  #   #   #   # --------------------------------------------------------------------
  #   #   #   # Whether to encrypt the EBS volume. Encryption provides data
  #   #   #   # protection at rest using AWS KMS keys.
  #   #   #   #
  #   #   #   # Valid Values:
  #   #   #   # - "true": Encrypt the volume
  #   #   #   # - "false": Do not encrypt the volume
  #   #   #   #
  #   #   #   # Note: Despite being a boolean value, it's passed as a string.
  #   #   #   #
  #   #   #   # Encryption Details:
  #   #   #   # - Uses AWS managed key (aws/ebs) by default
  #   #   #   # - Specify kms_key_id for customer-managed key
  #   #   #   # - Encryption is transparent to applications
  #   #   #   # - Minimal performance impact (<5%)
  #   #   #   # - Cannot be disabled after creation
  #   #   #   #
  #   #   #   # Compliance:
  #   #   #   # - Many compliance frameworks require encryption
  #   #   #   # - HIPAA, PCI-DSS, GDPR often mandate at-rest encryption
  #   #   #   #
  #   #   #   # Best Practices:
  #   #   #   # - Enable encryption for all production build instances
  #   #   #   # - Use customer-managed keys for auditability
  #   #   #   # - Consider organizational EBS encryption policies
  #   #   #   #
  #   #   #   # Default Behavior:
  #   #   #   # If not specified, inherits from parent image or account defaults.
  #   #   #   # --------------------------------------------------------------------
  #   #   #   # encrypted = "true"
  #   #   #
  #   #   #   # --------------------------------------------------------------------
  #   #   #   # iops - (Optional) number
  #   #   #   # --------------------------------------------------------------------
  #   #   #   # Number of I/O operations per second (IOPS) to provision for the
  #   #   #   # volume. Only applicable for io1, io2, and gp3 volume types.
  #   #   #   #
  #   #   #   # IOPS by Volume Type:
  #   #   #   # - gp3: 3,000 - 16,000 IOPS (3,000 included, more for extra cost)
  #   #   #   # - io2: 100 - 256,000 IOPS (io2 Block Express: up to 256,000)
  #   #   #   # - io1: 100 - 64,000 IOPS
  #   #   #   # - gp2: Calculated from volume size (3 IOPS per GB)
  #   #   #   #
  #   #   #   # IOPS to Size Ratios:
  #   #   #   # - io2: Up to 1,000 IOPS per GB (io2 Block Express)
  #   #   #   # - io2: Up to 500 IOPS per GB (standard)
  #   #   #   # - io1: Up to 50 IOPS per GB
  #   #   #   # - gp3: Independent of size
  #   #   #   #
  #   #   #   # Use Cases:
  #   #   #   # - Large container images with many layers
  #   #   #   # - Builds with extensive file operations
  #   #   #   # - Time-sensitive build pipelines
  #   #   #   # - High-frequency build operations
  #   #   #   #
  #   #   #   # Cost Considerations:
  #   #   #   # - gp3: Pay only for IOPS above 3,000
  #   #   #   # - io1/io2: Pay per provisioned IOPS
  #   #   #   # - Calculate cost vs. time savings
  #   #   #   #
  #   #   #   # Best Practices:
  #   #   #   # - Start with gp3 default (3,000 IOPS) for most builds
  #   #   #   # - Use higher IOPS for large image builds (>10GB)
  #   #   #   # - Monitor CloudWatch metrics to optimize
  #   #   #   # - Balance IOPS with throughput for best performance
  #   #   #   #
  #   #   #   # Example: For fast builds with large images
  #   #   #   # volume_type = "gp3"
  #   #   #   # iops = 10000
  #   #   #   # --------------------------------------------------------------------
  #   #   #   # iops = 3000
  #   #   #
  #   #   #   # --------------------------------------------------------------------
  #   #   #   # kms_key_id - (Optional) string
  #   #   #   # --------------------------------------------------------------------
  #   #   #   # The ARN of the AWS KMS key to use for EBS encryption. This provides
  #   #   #   # granular control over encryption keys and enables audit trails.
  #   #   #   #
  #   #   #   # Format Options:
  #   #   #   # - Key ARN: arn:aws:kms:region:account:key/key-id
  #   #   #   # - Key ID: 12345678-1234-1234-1234-123456789012
  #   #   #   # - Alias ARN: arn:aws:kms:region:account:alias/alias-name
  #   #   #   # - Alias name: alias/my-key
  #   #   #   #
  #   #   #   # Requirements:
  #   #   #   # - Must set encrypted = "true" when using this
  #   #   #   # - Key must be in the same region as the volume
  #   #   #   # - Image Builder service role needs kms:CreateGrant permission
  #   #   #   #
  #   #   #   # Key Policy Requirements:
  #   #   #   # The KMS key policy must allow:
  #   #   #   # - kms:CreateGrant (Image Builder service)
  #   #   #   # - kms:Decrypt (for reading encrypted volumes)
  #   #   #   # - kms:DescribeKey (for validation)
  #   #   #   # - kms:GenerateDataKey (for encryption)
  #   #   #   #
  #   #   #   # Use Cases:
  #   #   #   # - Compliance requirements for key management
  #   #   #   # - Centralized key control across build environments
  #   #   #   # - Audit trail of encryption key usage
  #   #   #   # - Cross-account encrypted volume sharing
  #   #   #   #
  #   #   #   # Best Practices:
  #   #   #   # - Use customer-managed keys for production builds
  #   #   #   # - Enable automatic key rotation
  #   #   #   # - Use different keys per environment (dev/prod)
  #   #   #   # - Tag keys for cost allocation
  #   #   #   # - Monitor key usage in CloudTrail
  #   #   #   #
  #   #   #   # Default Behavior:
  #   #   #   # If encrypted = "true" but kms_key_id is not specified, AWS uses
  #   #   #   # the default EBS encryption key (aws/ebs).
  #   #   #   # --------------------------------------------------------------------
  #   #   #   # kms_key_id = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
  #   #   #
  #   #   #   # --------------------------------------------------------------------
  #   #   #   # snapshot_id - (Optional) string
  #   #   #   # --------------------------------------------------------------------
  #   #   #   # The ID of an EBS snapshot to use as the starting point for the
  #   #   #   # volume. This creates a volume from the snapshot.
  #   #   #   #
  #   #   #   # Format: snap-xxxxxxxxxxxxxxxxx
  #   #   #   # Example: snap-0123456789abcdef0
  #   #   #   #
  #   #   #   # Snapshot Sources:
  #   #   #   # - Manual snapshots created in your account
  #   #   #   # - Automated snapshots from backup solutions
  #   #   #   # - Shared snapshots from other accounts
  #   #   #   # - Public snapshots (use with caution)
  #   #   #   #
  #   #   #   # Use Cases:
  #   #   #   # - Pre-loading build cache or dependencies
  #   #   #   # - Restoring specific build environment state
  #   #   #   # - Using standardized build volumes
  #   #   #   # - Sharing build environments across teams
  #   #   #   #
  #   #   #   # Important Notes:
  #   #   #   # - Snapshot must be in the same region
  #   #   #   # - Volume size can be larger than snapshot, not smaller
  #   #   #   # - Encryption status inherits from snapshot if not specified
  #   #   #   # - Cannot use with virtual_name (instance store)
  #   #   #   #
  #   #   #   # Encryption Considerations:
  #   #   #   # - Encrypted snapshots create encrypted volumes
  #   #   #   # - Can re-encrypt with different KMS key if needed
  #   #   #   # - Must have permissions for snapshot's KMS key
  #   #   #   #
  #   #   #   # Best Practices:
  #   #   #   # - Verify snapshot integrity before use
  #   #   #   # - Use private snapshots or trusted public snapshots
  #   #   #   # - Tag snapshots for lifecycle management
  #   #   #   # - Test snapshot-based volumes before production use
  #   #   #   # --------------------------------------------------------------------
  #   #   #   # snapshot_id = "snap-0123456789abcdef0"
  #   #   #
  #   #   #   # --------------------------------------------------------------------
  #   #   #   # throughput - (Optional) number
  #   #   #   # --------------------------------------------------------------------
  #   #   #   # The throughput in MiB/s that the volume supports. This parameter
  #   #   #   # is only valid for gp3 volumes.
  #   #   #   #
  #   #   #   # gp3 Throughput Range:
  #   #   #   # - Minimum: 125 MiB/s (included in base price)
  #   #   #   # - Maximum: 1,000 MiB/s
  #   #   #   # - Increment: Any value between 125 and 1,000
  #   #   #   #
  #   #   #   # Throughput and IOPS Relationship:
  #   #   #   # - 3,000 IOPS supports up to 125 MiB/s (included)
  #   #   #   # - Higher IOPS may require higher throughput
  #   #   #   # - Ratio: 1 MiB/s per 4 IOPS (approximately)
  #   #   #   #
  #   #   #   # Use Cases:
  #   #   #   # - Large sequential reads/writes during builds
  #   #   #   # - Building very large container images
  #   #   #   # - Extracting/compressing large files
  #   #   #   # - Streaming large datasets into containers
  #   #   #   #
  #   #   #   # Cost Considerations:
  #   #   #   # - Base gp3 includes 125 MiB/s
  #   #   #   # - Additional throughput incurs extra cost
  #   #   #   # - Often more cost-effective than io1/io2 for throughput
  #   #   #   #
  #   #   #   # Performance Characteristics:
  #   #   #   # - Independent of volume size (unlike gp2)
  #   #   #   # - More predictable performance
  #   #   #   # - Can be adjusted without downtime
  #   #   #   #
  #   #   #   # Best Practices:
  #   #   #   # - Start with default 125 MiB/s
  #   #   #   # - Monitor CloudWatch metrics: VolumeReadBytes, VolumeWriteBytes
  #   #   #   # - Increase if seeing throughput bottlenecks
  #   #   #   # - Balance with IOPS for optimal performance
  #   #   #   # - Use 250 MiB/s for medium-large images (5-20GB)
  #   #   #   # - Use 500+ MiB/s for very large images (>20GB)
  #   #   #   #
  #   #   #   # Example: For fast builds with large images
  #   #   #   # volume_type = "gp3"
  #   #   #   # throughput = 500
  #   #   #   # iops = 10000
  #   #   #   # --------------------------------------------------------------------
  #   #   #   # throughput = 125
  #   #   #
  #   #   #   # --------------------------------------------------------------------
  #   #   #   # volume_size - (Optional) number
  #   #   #   # --------------------------------------------------------------------
  #   #   #   # The size of the volume in gibibytes (GiB). This determines the
  #   #   #   # storage capacity available for the build process.
  #   #   #   #
  #   #   #   # Size Ranges by Volume Type:
  #   #   #   # - gp3, gp2: 1 GiB - 16,384 GiB (16 TiB)
  #   #   #   # - io2: 4 GiB - 16,384 GiB (16 TiB)
  #   #   #   # - io2 Block Express: 4 GiB - 64,384 GiB (64 TiB)
  #   #   #   # - io1: 4 GiB - 16,384 GiB (16 TiB)
  #   #   #   # - st1, sc1: 125 GiB - 16,384 GiB
  #   #   #   #
  #   #   #   # Sizing Considerations:
  #   #   #   # - Container image layers
  #   #   #   # - Build artifacts and temporary files
  #   #   #   # - Component installation space
  #   #   #   # - Test data and logs
  #   #   #   # - Overhead: OS, Docker, Image Builder agent
  #   #   #   #
  #   #   #   # Recommended Sizes:
  #   #   #   # - Small images (<2GB): 30 GiB
  #   #   #   # - Medium images (2-10GB): 50 GiB
  #   #   #   # - Large images (>10GB): 100+ GiB
  #   #   #   # - Multi-stage builds: Add 50% buffer
  #   #   #   #
  #   #   #   # gp2 Performance Note:
  #   #   #   # For gp2, IOPS is tied to volume size (3 IOPS per GiB):
  #   #   #   # - 100 GiB = 300 IOPS (minimum 100 IOPS)
  #   #   #   # - 1,000 GiB = 3,000 IOPS
  #   #   #   # - 5,334 GiB = 16,000 IOPS (maximum)
  #   #   #   #
  #   #   #   # Use Cases:
  #   #   #   # - Large base images require more space
  #   #   #   # - Multi-layer builds need additional capacity
  #   #   #   # - Parallel builds benefit from larger volumes
  #   #   #   #
  #   #   #   # Best Practices:
  #   #   #   # - Monitor build logs for "no space left" errors
  #   #   #   # - Add 20-30% buffer above estimated needs
  #   #   #   # - Consider using gp3 over gp2 for independent IOPS
  #   #   #   # - Start conservative, increase if builds fail
  #   #   #   # - Clean up intermediate layers in Dockerfile
  #   #   #   #
  #   #   #   # Cost Optimization:
  #   #   #   # - Right-size based on actual build needs
  #   #   #   # - Remember: volume is deleted after build
  #   #   #   # - Faster builds with sufficient space can reduce instance costs
  #   #   #   #
  #   #   #   # Default Behavior:
  #   #   #   # If not specified, inherits from parent image (usually 8 GiB).
  #   #   #   # This is often too small for container builds.
  #   #   #   # --------------------------------------------------------------------
  #   #   #   # volume_size = 50
  #   #   #
  #   #   #   # --------------------------------------------------------------------
  #   #   #   # volume_type - (Optional) string
  #   #   #   # --------------------------------------------------------------------
  #   #   #   # The type of EBS volume. Different types offer different performance
  #   #   #   # characteristics and pricing models.
  #   #   #   #
  #   #   #   # Valid Values:
  #   #   #   # - gp3: General Purpose SSD (recommended for most workloads)
  #   #   #   # - gp2: General Purpose SSD (legacy, use gp3 instead)
  #   #   #   # - io2: Provisioned IOPS SSD (highest durability and performance)
  #   #   #   # - io1: Provisioned IOPS SSD (legacy, use io2 instead)
  #   #   #   # - st1: Throughput Optimized HDD (large sequential workloads)
  #   #   #   # - sc1: Cold HDD (infrequent access, lowest cost)
  #   #   #   #
  #   #   #   # Volume Type Comparison:
  #   #   #   #
  #   #   #   # gp3 (Recommended for most builds):
  #   #   #   # - Baseline: 3,000 IOPS, 125 MiB/s
  #   #   #   # - Max: 16,000 IOPS, 1,000 MiB/s
  #   #   #   # - Cost: $0.08/GB-month + optional IOPS/throughput charges
  #   #   #   # - Best for: Most container builds, cost-effective performance
  #   #   #   #
  #   #   #   # gp2 (Legacy, not recommended):
  #   #   #   # - IOPS: 3 per GB (100-16,000 IOPS)
  #   #   #   # - Throughput: 128-250 MiB/s
  #   #   #   # - Cost: $0.10/GB-month
  #   #   #   # - Best for: Legacy compatibility only
  #   #   #   #
  #   #   #   # io2 (High performance and durability):
  #   #   #   # - IOPS: 100-256,000 (Block Express)
  #   #   #   # - Durability: 99.999%
  #   #   #   # - Cost: $0.125/GB-month + $0.065/provisioned IOPS
  #   #   #   # - Best for: Mission-critical builds, very large images
  #   #   #   #
  #   #   #   # io1 (Legacy high performance):
  #   #   #   # - IOPS: 100-64,000
  #   #   #   # - Cost: $0.125/GB-month + $0.065/provisioned IOPS
  #   #   #   # - Best for: Legacy compatibility, use io2 instead
  #   #   #   #
  #   #   #   # st1 (Throughput optimized):
  #   #   #   # - Throughput: 40-500 MiB/s
  #   #   #   # - Minimum size: 125 GB
  #   #   #   # - Cost: $0.045/GB-month
  #   #   #   # - Best for: Large sequential reads/writes (rarely used for builds)
  #   #   #   #
  #   #   #   # sc1 (Cold storage):
  #   #   #   # - Throughput: 12-250 MiB/s
  #   #   #   # - Minimum size: 125 GB
  #   #   #   # - Cost: $0.015/GB-month
  #   #   #   # - Best for: Not recommended for builds (too slow)
  #   #   #   #
  #   #   #   # Selection Guidelines:
  #   #   #   # - Standard builds: Use gp3 (best price/performance)
  #   #   #   # - Large builds (>20GB): Use gp3 with higher IOPS/throughput
  #   #   #   # - Time-critical: Use io2 with high IOPS
  #   #   #   # - Budget-constrained: Use gp3 with default settings
  #   #   #   #
  #   #   #   # Best Practices:
  #   #   #   # - Start with gp3 for new projects
  #   #   #   # - Migrate gp2 to gp3 for cost savings
  #   #   #   # - Use io2 only when gp3 maximum is insufficient
  #   #   #   # - Avoid st1/sc1 for build instances
  #   #   #   # - Monitor performance and adjust type accordingly
  #   #   #   #
  #   #   #   # Default Behavior:
  #   #   #   # If not specified, inherits from parent image (usually gp2 or gp3).
  #   #   #   # --------------------------------------------------------------------
  #   #   #   # volume_type = "gp3"
  #   #   #
  #   #   # }
  #   # }
  # }
}

# ==============================================================================
# ATTRIBUTES REFERENCE
# ==============================================================================
#
# In addition to all arguments above, the following attributes are exported:
#
# - arn (string)
#   Amazon Resource Name (ARN) of the container recipe. This is the globally
#   unique identifier for the recipe.
#   Format: arn:aws:imagebuilder:region:account-id:container-recipe/name/version
#   Example: arn:aws:imagebuilder:us-east-1:123456789012:container-recipe/my-recipe/1.0.0
#
# - date_created (string)
#   Date when the container recipe was created.
#   Format: ISO 8601 timestamp (e.g., "2024-01-15T10:30:00Z")
#   Use for: Auditing, tracking recipe age, lifecycle management
#
# - encrypted (bool)
#   A flag that indicates if the target container is encrypted. This reflects
#   whether KMS encryption is applied to the container image in ECR.
#
# - owner (string)
#   The owner of the container recipe. This is the AWS account ID that created
#   the recipe.
#   Format: 12-digit AWS account ID (e.g., "123456789012")
#
# - platform (string)
#   The platform of the container recipe. Indicates the operating system
#   platform for the container.
#   Values: "Linux" or "Windows"
#   Note: Automatically detected from parent_image or set by platform_override
#
# - tags_all (map(string))
#   A map of tags assigned to the resource, including those inherited from the
#   provider default_tags configuration block. This is the complete set of
#   tags, combining resource-level tags with provider default tags.
#
# ==============================================================================
# IMPORT
# ==============================================================================
#
# Image Builder Container Recipes can be imported using the Amazon Resource
# Name (ARN):
#
# terraform import aws_imagebuilder_container_recipe.example arn:aws:imagebuilder:us-east-1:123456789012:container-recipe/example/1.0.0
#
# Note: When importing, ensure that the version in the ARN matches exactly.
#
# ==============================================================================
# EXAMPLES
# ==============================================================================
#
# Example 1: Simple Container Recipe
# -----------------------------------
# resource "aws_imagebuilder_container_recipe" "simple" {
#   name           = "simple-nginx"
#   version        = "1.0.0"
#   container_type = "DOCKER"
#   parent_image   = "nginx:latest"
#
#   component {
#     component_arn = "arn:aws:imagebuilder:us-east-1:aws:component/update-linux/x.x.x"
#   }
#
#   target_repository {
#     repository_name = aws_ecr_repository.nginx.name
#     service         = "ECR"
#   }
#
#   dockerfile_template_data = <<-EOF
#     FROM {{{ imagebuilder:parentImage }}}
#     {{{ imagebuilder:environments }}}
#     {{{ imagebuilder:components }}}
#   EOF
# }
#
# Example 2: Production Container with Encryption
# ------------------------------------------------
# resource "aws_imagebuilder_container_recipe" "production" {
#   name           = "prod-app"
#   version        = "2.1.0"
#   container_type = "DOCKER"
#   parent_image   = "arn:aws:imagebuilder:us-east-1:aws:image/amazon-linux-x86-latest/x.x.x"
#   description    = "Production application with security hardening"
#   kms_key_id     = aws_kms_key.container_images.arn
#
#   component {
#     component_arn = "arn:aws:imagebuilder:us-east-1:aws:component/update-linux/x.x.x"
#   }
#
#   component {
#     component_arn = aws_imagebuilder_component.app_install.arn
#   }
#
#   target_repository {
#     repository_name = aws_ecr_repository.app.name
#     service         = "ECR"
#   }
#
#   dockerfile_template_data = <<-EOF
#     FROM {{{ imagebuilder:parentImage }}}
#     {{{ imagebuilder:environments }}}
#     {{{ imagebuilder:components }}}
#     EXPOSE 8080
#     USER appuser
#   EOF
#
#   tags = {
#     Environment = "production"
#     Application = "web-app"
#     Compliance  = "PCI-DSS"
#   }
# }
#
# Example 3: Container with Custom Build Instance
# ------------------------------------------------
# resource "aws_imagebuilder_container_recipe" "custom_build" {
#   name           = "large-image"
#   version        = "1.0.0"
#   container_type = "DOCKER"
#   parent_image   = "ubuntu:22.04"
#
#   component {
#     component_arn = aws_imagebuilder_component.custom.arn
#   }
#
#   target_repository {
#     repository_name = aws_ecr_repository.large.name
#     service         = "ECR"
#   }
#
#   instance_configuration {
#     image = data.aws_ami.ecs_optimized.id
#
#     block_device_mapping {
#       device_name = "/dev/xvda"
#
#       ebs {
#         delete_on_termination = "true"
#         encrypted             = "true"
#         kms_key_id            = aws_kms_key.build_volumes.arn
#         volume_size           = 100
#         volume_type           = "gp3"
#         iops                  = 5000
#         throughput            = 250
#       }
#     }
#   }
#
#   dockerfile_template_data = <<-EOF
#     FROM {{{ imagebuilder:parentImage }}}
#     {{{ imagebuilder:environments }}}
#     {{{ imagebuilder:components }}}
#   EOF
# }
#
# ==============================================================================
