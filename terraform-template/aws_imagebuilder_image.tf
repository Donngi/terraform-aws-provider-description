# ============================================================================ #
# AWS Image Builder Image Resource
# ============================================================================ #
# Resource: aws_imagebuilder_image
# Provider Version: 6.28.0
# Description: Manages an Image Builder Image.
#
# Official Documentation:
# https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/imagebuilder_image
# https://docs.aws.amazon.com/imagebuilder/latest/userguide/what-is-image-builder.html
#
# AWS Image Builder simplifies the building, testing, and deployment of
# Virtual Machine and container images for use on AWS or on-premises.
# ============================================================================ #

resource "aws_imagebuilder_image" "example" {
  # -------------------------------------------------------------------------- #
  # Required Arguments
  # -------------------------------------------------------------------------- #

  # infrastructure_configuration_arn - (Required) Amazon Resource Name (ARN)
  # of the Image Builder Infrastructure Configuration.
  # This defines the infrastructure used to build and test the image, including
  # instance type, security groups, IAM role, and other configuration details.
  #
  # Type: string
  # Example: "arn:aws:imagebuilder:us-east-1:123456789012:infrastructure-configuration/example"
  infrastructure_configuration_arn = aws_imagebuilder_infrastructure_configuration.example.arn

  # -------------------------------------------------------------------------- #
  # Optional Arguments - Recipe Configuration
  # -------------------------------------------------------------------------- #
  # Note: You must specify either image_recipe_arn OR container_recipe_arn,
  # but not both. Image recipes are for AMIs, container recipes are for
  # container images.

  # image_recipe_arn - (Optional) Amazon Resource Name (ARN) of the image recipe.
  # An image recipe defines the source image, components to apply, and tests to run.
  # Use this for creating Amazon Machine Images (AMIs).
  #
  # Type: string
  # Example: "arn:aws:imagebuilder:us-east-1:123456789012:image-recipe/example/1.0.0"
  image_recipe_arn = aws_imagebuilder_image_recipe.example.arn

  # container_recipe_arn - (Optional) Amazon Resource Name (ARN) of the
  # container recipe. Use this for creating container images instead of AMIs.
  #
  # Type: string
  # Example: "arn:aws:imagebuilder:us-east-1:123456789012:container-recipe/example/1.0.0"
  # container_recipe_arn = aws_imagebuilder_container_recipe.example.arn

  # -------------------------------------------------------------------------- #
  # Optional Arguments - Distribution and Execution
  # -------------------------------------------------------------------------- #

  # distribution_configuration_arn - (Optional) Amazon Resource Name (ARN)
  # of the Image Builder Distribution Configuration.
  # Defines how and where to distribute the output image (e.g., copy to regions,
  # share with accounts, publish to container registry).
  #
  # Type: string
  # Example: "arn:aws:imagebuilder:us-east-1:123456789012:distribution-configuration/example"
  distribution_configuration_arn = aws_imagebuilder_distribution_configuration.example.arn

  # execution_role - (Optional) Amazon Resource Name (ARN) of the service-linked
  # role to be used by Image Builder to execute workflows.
  # This role is used when executing workflow steps during the image build process.
  #
  # Type: string
  # Example: "arn:aws:iam::123456789012:role/ImageBuilderExecutionRole"
  # Reference: https://docs.aws.amazon.com/imagebuilder/latest/userguide/manage-image-workflows.html
  # execution_role = aws_iam_role.imagebuilder_execution.arn

  # -------------------------------------------------------------------------- #
  # Optional Arguments - Image Configuration
  # -------------------------------------------------------------------------- #

  # enhanced_image_metadata_enabled - (Optional) Whether additional information
  # about the image being created is collected. This includes details like
  # installed packages and system configuration.
  #
  # Type: bool
  # Default: true
  # enhanced_image_metadata_enabled = true

  # -------------------------------------------------------------------------- #
  # Image Tests Configuration Block
  # -------------------------------------------------------------------------- #
  # Configuration for image tests that validate the image meets requirements.

  image_tests_configuration {
    # image_tests_enabled - (Optional) Whether image tests are enabled.
    # When enabled, Image Builder runs validation tests against the built image.
    #
    # Type: bool
    # Default: true
    image_tests_enabled = true

    # timeout_minutes - (Optional) Number of minutes before image tests time out.
    # This value determines how long tests can run before being terminated.
    #
    # Type: number
    # Valid range: 60-1440 minutes
    # Default: 720 (12 hours)
    timeout_minutes = 720
  }

  # -------------------------------------------------------------------------- #
  # Image Scanning Configuration Block
  # -------------------------------------------------------------------------- #
  # Configuration for vulnerability scanning of the output image.

  image_scanning_configuration {
    # image_scanning_enabled - (Optional) Indicates whether Image Builder keeps
    # a snapshot of the vulnerability scans that Amazon Inspector runs against
    # the build instance when you create a new image.
    #
    # Type: bool
    # Default: false
    image_scanning_enabled = false

    # ecr_configuration - (Optional) Configuration block for ECR scanning.
    # Used when scanning container images stored in Amazon ECR.
    ecr_configuration {
      # repository_name - (Optional) The name of the container repository that
      # Amazon Inspector scans to identify findings for your container images.
      #
      # Type: string
      # Example: "my-container-repository"
      # repository_name = "example-repo"

      # container_tags - (Optional) Set of tags for Image Builder to apply to
      # the output container image that Amazon Inspector scans.
      #
      # Type: set(string)
      # Example: ["latest", "v1.0.0"]
      # container_tags = ["latest"]
    }
  }

  # -------------------------------------------------------------------------- #
  # Logging Configuration Block
  # -------------------------------------------------------------------------- #
  # Configuration for CloudWatch Logs integration during the image build process.

  logging_configuration {
    # log_group_name - (Optional) Name of the CloudWatch Log Group to send logs to.
    # Build logs from the image creation process will be streamed to this log group.
    #
    # Type: string
    # Example: "/aws/imagebuilder/example"
    log_group_name = "/aws/imagebuilder/example"
  }

  # -------------------------------------------------------------------------- #
  # Workflow Configuration Blocks
  # -------------------------------------------------------------------------- #
  # Workflows define automated actions to perform during image creation.
  # You can specify multiple workflow blocks for different stages.

  workflow {
    # workflow_arn - (Required) Amazon Resource Name (ARN) of the Image Builder
    # Workflow. Workflows define a series of steps to execute during image builds.
    #
    # Type: string
    # Example: "arn:aws:imagebuilder:us-east-1:123456789012:workflow/test/example/1.0.0/1"
    workflow_arn = aws_imagebuilder_workflow.test.arn

    # on_failure - (Optional) The action to take if the workflow fails.
    # CONTINUE: Continue with the image creation process
    # ABORT: Stop the image creation process immediately
    #
    # Type: string
    # Valid values: "CONTINUE", "ABORT"
    # on_failure = "ABORT"

    # parallel_group - (Optional) The parallel group in which to run a test workflow.
    # Workflows with the same parallel_group value run concurrently.
    #
    # Type: string
    # Example: "group-1"
    # parallel_group = "group-1"

    # parameter - (Optional) Configuration block for workflow parameters.
    # Parameters allow you to pass dynamic values to workflow steps.
    parameter {
      # name - (Required) The name of the workflow parameter.
      #
      # Type: string
      # Example: "InstanceType"
      name = "InstanceType"

      # value - (Required) The value of the workflow parameter.
      #
      # Type: string
      # Example: "t3.medium"
      value = "t3.medium"
    }

    # Additional parameters can be added as needed
    # parameter {
    #   name  = "AnotherParameter"
    #   value = "parameter-value"
    # }
  }

  # Additional workflows can be added for different stages or purposes
  # workflow {
  #   workflow_arn = aws_imagebuilder_workflow.distribution.arn
  #   on_failure   = "CONTINUE"
  # }

  # -------------------------------------------------------------------------- #
  # Resource Tags
  # -------------------------------------------------------------------------- #

  # tags - (Optional) Key-value map of resource tags for the Image Builder Image.
  # Tags are useful for organizing resources, cost allocation, and automation.
  #
  # Type: map(string)
  # Note: If configured with a provider default_tags configuration block,
  # tags with matching keys will overwrite those defined at the provider-level.
  tags = {
    Name        = "example-image"
    Environment = "development"
    ManagedBy   = "terraform"
    Purpose     = "application-server"
  }
}

# ============================================================================ #
# Computed Attributes Reference
# ============================================================================ #
# The following attributes are exported and can be referenced after creation:
#
# - id                    : Amazon Resource Name (ARN) of the image
# - arn                   : Amazon Resource Name (ARN) of the image (same as id)
# - date_created          : Date the image was created (ISO 8601 format)
# - platform              : Platform of the image (e.g., "Linux", "Windows")
# - os_version            : Operating System version of the image
# - version               : Version of the image (semantic versioning)
# - tags_all              : Map of tags assigned to the resource, including
#                           those inherited from the provider default_tags
# - output_resources      : List of objects with resources created by the image
#   - output_resources.amis: Set of objects with each Amazon Machine Image (AMI) created
#     - account_id  : Account identifier of the AMI
#     - description : Description of the AMI
#     - image       : Identifier of the AMI (ami-xxxxx)
#     - name        : Name of the AMI
#     - region      : Region of the AMI
#   - output_resources.containers: Set of objects with each container image created
#     - image_uris  : Set of URIs for created containers
#     - region      : Region of the container image
#
# Example usage of computed attributes:
# output "image_arn" {
#   value = aws_imagebuilder_image.example.arn
# }
#
# output "image_version" {
#   value = aws_imagebuilder_image.example.version
# }
#
# output "created_amis" {
#   value = aws_imagebuilder_image.example.output_resources[0].amis
# }
# ============================================================================ #

# ============================================================================ #
# Additional Notes
# ============================================================================ #
# 1. Build Process:
#    - Image Builder launches a temporary EC2 instance based on the infrastructure
#      configuration
#    - Applies the base image and components from the recipe
#    - Runs tests defined in the test configuration
#    - Creates the output image (AMI or container)
#    - Distributes the image according to distribution configuration
#    - Terminates the temporary instance
#
# 2. Recipe Types:
#    - Image Recipe: Used for creating AMIs for EC2 instances
#    - Container Recipe: Used for creating Docker container images
#    - Only one recipe type can be specified per image resource
#
# 3. Workflows:
#    - Workflows automate additional tasks during image creation
#    - Common use cases: security scanning, compliance checks, custom validations
#    - Workflows can run in parallel groups for better performance
#    - Parameters allow dynamic configuration of workflow behavior
#
# 4. Distribution:
#    - Distribution configuration controls how images are shared and deployed
#    - Can copy images to multiple regions automatically
#    - Can share images with specific AWS accounts or organizations
#    - Can set launch permissions and AMI tags
#
# 5. Image Versions:
#    - Image Builder uses semantic versioning (major.minor.patch)
#    - Each build creates a new version
#    - Version is automatically incremented based on recipe version
#
# 6. Cost Considerations:
#    - Charges apply for EC2 instances used during builds
#    - Storage costs for AMIs and snapshots
#    - Data transfer costs if distributing across regions
#    - CloudWatch Logs storage if logging is enabled
#
# 7. Security Best Practices:
#    - Use least-privilege IAM roles for infrastructure configuration
#    - Enable image scanning to detect vulnerabilities
#    - Encrypt AMIs and snapshots at rest
#    - Use private VPC subnets for build instances
#    - Review and approve components before adding to recipes
#
# 8. Monitoring and Troubleshooting:
#    - Enable CloudWatch Logs to capture build logs
#    - Monitor build status through AWS Console or CLI
#    - Review test results to identify issues
#    - Check workflow execution logs for custom validations
#
# 9. Resource Dependencies:
#    Required resources that must exist before creating this image:
#    - aws_imagebuilder_infrastructure_configuration
#    - aws_imagebuilder_image_recipe OR aws_imagebuilder_container_recipe
#    Optional but commonly used:
#    - aws_imagebuilder_distribution_configuration
#    - aws_imagebuilder_workflow
#    - aws_cloudwatch_log_group (for logging)
#    - IAM roles and policies for execution
#
# 10. Terraform Lifecycle:
#     - Creating an image triggers a build process (can take 30-90 minutes)
#     - Updating recipe or configuration ARNs triggers a new build
#     - Image resources are immutable - changes create new versions
#     - Use lifecycle rules to manage image retention
#
# Related Resources:
# - aws_imagebuilder_image_pipeline     : Automates image creation on schedule
# - aws_imagebuilder_image_recipe       : Defines how to build an AMI
# - aws_imagebuilder_container_recipe   : Defines how to build container images
# - aws_imagebuilder_component          : Reusable build/test components
# - aws_imagebuilder_infrastructure_configuration : Build environment settings
# - aws_imagebuilder_distribution_configuration   : Image distribution settings
# - aws_imagebuilder_workflow           : Custom automation workflows
# ============================================================================ #
