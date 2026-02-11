################################################################################
# AWS ECR Lifecycle Policy
################################################################################
# Manages an ECR repository lifecycle policy.
#
# NOTE: Only one aws_ecr_lifecycle_policy resource can be used with the same
# ECR repository. To apply multiple rules, they must be combined in the policy JSON.
#
# NOTE: The AWS ECR API seems to reorder rules based on rulePriority. If you
# define multiple rules that are not sorted in ascending rulePriority order in
# the Terraform code, the resource will be flagged for recreation every terraform plan.
#
# Provider Version: 6.28.0
# Documentation: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_lifecycle_policy
################################################################################

resource "aws_ecr_lifecycle_policy" "this" {
  ################################################################################
  # Required Arguments
  ################################################################################

  # (Required) Name of the repository to apply the policy.
  # Type: string
  # Example: "example-repo"
  repository = "example-repo"

  # (Required) The policy document. This is a JSON formatted string.
  # See more details about Policy Parameters:
  # http://docs.aws.amazon.com/AmazonECR/latest/userguide/LifecyclePolicies.html#lifecycle_policy_parameters
  # Consider using the aws_ecr_lifecycle_policy_document data source to
  # generate/manage the JSON document used for the policy argument.
  # Type: string (JSON)
  #
  # Policy Structure:
  # - rules: Array of rule objects
  #   - rulePriority: Integer (1-999), rules with lower priority are evaluated first
  #   - description: String describing the rule
  #   - selection: Object defining which images to target
  #     - tagStatus: "tagged", "untagged", or "any"
  #     - tagPrefixList: (Optional) Array of tag prefixes (only for tagged)
  #     - tagPatternList: (Optional) Array of tag patterns (only for tagged)
  #     - storageClass: (Optional) "archive" (for archived images)
  #     - countType: "imageCountMoreThan", "sinceImagePushed", "sinceImagePulled", or "sinceImageTransitioned"
  #     - countUnit: "days" (required for since* countTypes)
  #     - countNumber: Integer threshold
  #   - action: Object defining what to do with matched images
  #     - type: "expire" or "transition"
  #     - targetStorageClass: (Required for transition) "archive"
  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Expire untagged images older than 14 days"
        selection = {
          tagStatus   = "untagged"
          countType   = "sinceImagePushed"
          countUnit   = "days"
          countNumber = 14
        }
        action = {
          type = "expire"
        }
      },
      {
        rulePriority = 2
        description  = "Keep last 30 tagged images with v prefix"
        selection = {
          tagStatus      = "tagged"
          tagPrefixList  = ["v"]
          countType      = "imageCountMoreThan"
          countNumber    = 30
        }
        action = {
          type = "expire"
        }
      }
    ]
  })

  ################################################################################
  # Optional Arguments
  ################################################################################

  # (Optional) Region where this resource will be managed.
  # Defaults to the Region set in the provider configuration.
  # Type: string
  # Example: "us-west-2"
  # region = "us-west-2"

  ################################################################################
  # Computed Attributes (Read-only)
  ################################################################################

  # id - The repository name.
  # Type: string (Computed)

  # registry_id - The registry ID where the repository was created.
  # Type: string (Computed)
}

################################################################################
# Example: Policy on Untagged Images
################################################################################

# resource "aws_ecr_repository" "example" {
#   name = "example-repo"
# }
#
# resource "aws_ecr_lifecycle_policy" "example_untagged" {
#   repository = aws_ecr_repository.example.name
#
#   policy = jsonencode({
#     rules = [
#       {
#         rulePriority = 1
#         description  = "Expire images older than 14 days"
#         selection = {
#           tagStatus   = "untagged"
#           countType   = "sinceImagePushed"
#           countUnit   = "days"
#           countNumber = 14
#         }
#         action = {
#           type = "expire"
#         }
#       }
#     ]
#   })
# }

################################################################################
# Example: Policy on Tagged Images
################################################################################

# resource "aws_ecr_repository" "example" {
#   name = "example-repo"
# }
#
# resource "aws_ecr_lifecycle_policy" "example_tagged" {
#   repository = aws_ecr_repository.example.name
#
#   policy = jsonencode({
#     rules = [
#       {
#         rulePriority = 1
#         description  = "Keep last 30 images"
#         selection = {
#           tagStatus      = "tagged"
#           tagPrefixList  = ["v"]
#           countType      = "imageCountMoreThan"
#           countNumber    = 30
#         }
#         action = {
#           type = "expire"
#         }
#       }
#     ]
#   })
# }

################################################################################
# Example: Policy to Archive and Delete
################################################################################

# resource "aws_ecr_repository" "example" {
#   name = "example-repo"
# }
#
# resource "aws_ecr_lifecycle_policy" "example_archive" {
#   repository = aws_ecr_repository.example.name
#
#   policy = jsonencode({
#     rules = [
#       {
#         rulePriority = 1
#         description  = "Archive images not pulled in 90 days"
#         selection = {
#           tagStatus   = "any"
#           countType   = "sinceImagePulled"
#           countUnit   = "days"
#           countNumber = 90
#         }
#         action = {
#           type               = "transition"
#           targetStorageClass = "archive"
#         }
#       },
#       {
#         rulePriority = 2
#         description  = "Delete images archived for more than 365 days"
#         selection = {
#           tagStatus    = "any"
#           storageClass = "archive"
#           countType    = "sinceImageTransitioned"
#           countUnit    = "days"
#           countNumber  = 365
#         }
#         action = {
#           type = "expire"
#         }
#       }
#     ]
#   })
# }

################################################################################
# Common Use Cases and Best Practices
################################################################################

# 1. Untagged Image Cleanup
#    - Remove untagged images after a certain period (e.g., 14 days)
#    - Helps reduce storage costs and maintain repository hygiene
#    - Use countType: "sinceImagePushed" with countUnit: "days"

# 2. Image Count Limits
#    - Keep only the most recent N images
#    - Useful for production images with semantic versioning
#    - Use countType: "imageCountMoreThan" with tagStatus: "tagged"

# 3. Image Archival Strategy
#    - Archive infrequently accessed images to reduce costs
#    - Use countType: "sinceImagePulled" to identify unused images
#    - Transition to "archive" storage class before deletion

# 4. Multi-Rule Policies
#    - Combine multiple rules with different priorities
#    - Rules are evaluated in order of rulePriority (ascending)
#    - Lower priority numbers are evaluated first

# 5. Tag-Based Policies
#    - Use tagPrefixList to target specific tag patterns (e.g., ["v", "prod"])
#    - Use tagPatternList for more complex tag matching
#    - Combine with tagStatus: "tagged" for precise control

# 6. Storage Cost Optimization
#    - Archive: ~75% cost reduction compared to standard storage
#    - Archive retrieval takes longer (12-48 hours)
#    - Use for long-term retention requirements

# Important Notes:
# - Only one lifecycle policy per repository
# - Rules must be sorted by rulePriority in ascending order
# - Policy changes may take a few minutes to take effect
# - Test policies carefully before applying to production repositories
# - Use aws_ecr_lifecycle_policy_document data source for complex policies
# - Monitor AWS CloudWatch Events for lifecycle policy actions
