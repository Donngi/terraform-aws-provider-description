# ============================================================
# AWS Image Builder Lifecycle Policy
# ============================================================
# Manages an Image Builder Lifecycle Policy.
#
# This resource allows you to define lifecycle policies that automatically
# manage the lifecycle of AMI images or container images created by EC2
# Image Builder. Lifecycle policies help you maintain image hygiene by
# automatically deleting, deprecating, or disabling old images based on
# age or count criteria.
#
# Provider Version: 6.28.0
# Resource Type: aws_imagebuilder_lifecycle_policy
# ============================================================

# Prerequisites:
# - IAM role with EC2ImageBuilderLifecycleExecutionPolicy
# - Image Builder images or containers to manage
# - Appropriate tagging strategy for resource selection

# ============================================================
# Data Sources for IAM Role Setup
# ============================================================

data "aws_region" "current" {}

data "aws_partition" "current" {}

# ============================================================
# IAM Role for Lifecycle Policy Execution
# ============================================================

resource "aws_iam_role" "imagebuilder_lifecycle" {
  name = "imagebuilder-lifecycle-policy-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "imagebuilder.${data.aws_partition.current.dns_suffix}"
      }
    }]
  })

  tags = {
    Name        = "imagebuilder-lifecycle-policy-role"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

resource "aws_iam_role_policy_attachment" "imagebuilder_lifecycle" {
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/service-role/EC2ImageBuilderLifecycleExecutionPolicy"
  role       = aws_iam_role.imagebuilder_lifecycle.name
}

# ============================================================
# Example 1: Age-based AMI Lifecycle Policy
# ============================================================
# This policy automatically deletes AMI images older than 6 years
# while retaining at least 10 images. It applies to resources
# with specific tags.

resource "aws_imagebuilder_lifecycle_policy" "ami_age_based" {
  # ------------------------------------------------------------
  # Required Arguments
  # ------------------------------------------------------------

  # The name of the lifecycle policy
  # Type: string
  name = "ami-age-based-cleanup-policy"

  # The type of Image Builder resource that the lifecycle policy applies to
  # Valid values: AMI_IMAGE, CONTAINER_IMAGE
  # Type: string
  resource_type = "AMI_IMAGE"

  # The ARN for the IAM role that grants Image Builder access to run lifecycle actions
  # Must have EC2ImageBuilderLifecycleExecutionPolicy attached
  # Type: string
  execution_role = aws_iam_role.imagebuilder_lifecycle.arn

  # ------------------------------------------------------------
  # Policy Details Configuration
  # ------------------------------------------------------------

  policy_detail {
    # Action to take when filter criteria are met
    action {
      # Type of lifecycle action
      # Valid values: DELETE, DEPRECATE, DISABLE
      # - DELETE: Permanently removes the resource
      # - DEPRECATE: Marks the resource as deprecated
      # - DISABLE: Disables the resource
      # Type: string
      type = "DELETE"

      # Optional: Specify which resources the lifecycle action applies to
      # include_resources {
      #   # Whether to apply action to distributed AMIs
      #   # Type: bool
      #   amis = true
      #
      #   # Whether to apply action to distributed containers
      #   # Type: bool
      #   containers = false
      #
      #   # Whether to apply action to snapshots associated with AMIs
      #   # Type: bool
      #   snapshots = true
      # }
    }

    # Filter criteria for selecting resources
    filter {
      # Filter type - determines how resources are selected
      # Valid values: AGE, COUNT
      # - AGE: Filter by time elapsed since creation
      # - COUNT: Filter by number of resources
      # Type: string
      type = "AGE"

      # The number of units for the filter
      # - For AGE: number of time units (e.g., 6 months)
      # - For COUNT: number of resources (e.g., keep 10 most recent)
      # Type: number
      value = 6

      # Number of resources to retain after DELETE action
      # Only resources exceeding this count are deleted
      # Type: number (optional)
      retain_at_least = 10

      # Time unit for age-based filters
      # Valid values: DAYS, WEEKS, MONTHS, YEARS
      # Required for AGE type filters
      # Type: string (optional)
      unit = "YEARS"
    }

    # Optional: Define exclusion rules for resources that should not be affected
    # exclusion_rules {
    #   # AMI-specific exclusion rules
    #   amis {
    #     # Exclude public AMIs from lifecycle actions
    #     # Type: bool
    #     is_public = true
    #
    #     # Exclude AMIs launched recently
    #     last_launched {
    #       # Time unit for last launched calculation
    #       # Valid values: DAYS, WEEKS, MONTHS, YEARS
    #       # Type: string
    #       unit = "MONTHS"
    #
    #       # Number of time units
    #       # Type: number
    #       value = 3
    #     }
    #
    #     # AWS Regions to exclude from lifecycle action
    #     # Type: list(string)
    #     regions = ["us-east-1", "us-west-2"]
    #
    #     # AWS account IDs to exclude from lifecycle action
    #     # Type: list(string)
    #     shared_accounts = ["123456789012"]
    #
    #     # Tags that exempt AMIs from lifecycle actions
    #     # Type: map(string)
    #     tag_map = {
    #       "DoNotDelete" = "true"
    #       "Production"  = "critical"
    #     }
    #   }
    #
    #   # Tags that exempt any resource from lifecycle actions
    #   # Type: map(string)
    #   tag_map = {
    #     "Permanent" = "true"
    #   }
    # }
  }

  # ------------------------------------------------------------
  # Resource Selection Configuration
  # ------------------------------------------------------------

  resource_selection {
    # Tags used to select resources for lifecycle policy
    # Resources must have all specified tags to be selected
    # Type: map(string) (optional)
    tag_map = {
      "ImageBuilder" = "managed"
      "Lifecycle"    = "enabled"
    }

    # Optional: Select resources by recipe name and version
    # recipe {
    #   # Name of the Image Builder recipe
    #   # Type: string
    #   name = "example-recipe"
    #
    #   # Version of the recipe (semantic version)
    #   # Type: string
    #   semantic_version = "1.0.0"
    # }
  }

  # ------------------------------------------------------------
  # Optional Arguments
  # ------------------------------------------------------------

  # Description of the lifecycle policy
  # Type: string (optional)
  description = "Automatically delete AMI images older than 6 years while retaining at least 10 images"

  # Tags to assign to the lifecycle policy resource
  # Type: map(string) (optional)
  tags = {
    Name        = "ami-age-based-cleanup-policy"
    Environment = "production"
    Purpose     = "image-lifecycle-management"
    ManagedBy   = "terraform"
  }

  # Ensure IAM role is ready before creating policy
  depends_on = [aws_iam_role_policy_attachment.imagebuilder_lifecycle]
}

# ============================================================
# Example 2: Count-based Container Image Lifecycle Policy
# ============================================================
# This policy keeps only the 5 most recent container images
# and deletes older ones based on specific recipe criteria.

resource "aws_imagebuilder_lifecycle_policy" "container_count_based" {
  name           = "container-count-based-cleanup-policy"
  description    = "Keep only the 5 most recent container images for each recipe"
  resource_type  = "CONTAINER_IMAGE"
  execution_role = aws_iam_role.imagebuilder_lifecycle.arn

  policy_detail {
    action {
      # Use DEPRECATE instead of DELETE to mark images as deprecated
      type = "DEPRECATE"

      # Apply action to container images only
      include_resources {
        containers = true
      }
    }

    filter {
      # Use COUNT filter to keep specific number of most recent images
      type = "COUNT"

      # Keep only 5 most recent images
      value = 5

      # Note: retain_at_least is not applicable for COUNT filters
      # Note: unit is not applicable for COUNT filters
    }

    # Exclude images with critical tags from deprecation
    exclusion_rules {
      tag_map = {
        "Critical"   = "true"
        "Production" = "active"
      }
    }
  }

  resource_selection {
    # Select containers from a specific recipe
    recipe {
      name             = "web-app-container-recipe"
      semantic_version = "2.0.0"
    }

    # Additional tag-based selection
    tag_map = {
      "Application" = "web-app"
      "Team"        = "platform"
    }
  }

  tags = {
    Name        = "container-count-based-cleanup-policy"
    Environment = "production"
    Type        = "count-based"
    ManagedBy   = "terraform"
  }

  depends_on = [aws_iam_role_policy_attachment.imagebuilder_lifecycle]
}

# ============================================================
# Example 3: Comprehensive AMI Lifecycle Policy with Exclusions
# ============================================================
# This policy demonstrates advanced configuration including:
# - Multiple inclusion rules for AMIs and snapshots
# - Complex exclusion rules for public AMIs and recently launched instances
# - Regional and account-based exclusions

resource "aws_imagebuilder_lifecycle_policy" "ami_comprehensive" {
  name           = "ami-comprehensive-lifecycle-policy"
  description    = "Comprehensive AMI lifecycle policy with multiple exclusion rules"
  resource_type  = "AMI_IMAGE"
  execution_role = aws_iam_role.imagebuilder_lifecycle.arn

  policy_detail {
    action {
      type = "DELETE"

      # Apply action to both AMIs and their associated snapshots
      include_resources {
        amis      = true
        snapshots = true
      }
    }

    filter {
      # Delete images older than 90 days
      type  = "AGE"
      value = 90
      unit  = "DAYS"

      # Always retain at least 3 images
      retain_at_least = 3
    }

    # Comprehensive exclusion rules
    exclusion_rules {
      # AMI-specific exclusions
      amis {
        # Exclude public AMIs from deletion
        is_public = true

        # Exclude AMIs that were launched within the last 30 days
        last_launched {
          unit  = "DAYS"
          value = 30
        }

        # Exclude AMIs in specific regions
        regions = [
          "us-east-1",
          "eu-west-1",
          "ap-northeast-1"
        ]

        # Exclude AMIs shared with specific accounts
        shared_accounts = [
          "123456789012",
          "210987654321"
        ]

        # Exclude AMIs with specific tags
        tag_map = {
          "DoNotDelete" = "true"
          "Compliance"  = "required"
          "Backup"      = "permanent"
        }
      }

      # General tag-based exclusions (applies to all resources)
      tag_map = {
        "Permanent"  = "true"
        "GoldImage"  = "true"
        "Compliance" = "audit-required"
      }
    }
  }

  resource_selection {
    # Select AMIs based on tags
    tag_map = {
      "ManagedBy"   = "imagebuilder"
      "Environment" = "development"
      "AutoCleanup" = "enabled"
    }
  }

  tags = {
    Name        = "ami-comprehensive-lifecycle-policy"
    Environment = "development"
    Type        = "age-based-with-exclusions"
    ManagedBy   = "terraform"
  }

  depends_on = [aws_iam_role_policy_attachment.imagebuilder_lifecycle]
}

# ============================================================
# Example 4: DISABLE Action for AMI Lifecycle
# ============================================================
# This policy disables (rather than deletes) old AMIs,
# allowing them to remain accessible but preventing new launches.

resource "aws_imagebuilder_lifecycle_policy" "ami_disable" {
  name           = "ami-disable-lifecycle-policy"
  description    = "Disable AMIs older than 1 year instead of deleting them"
  resource_type  = "AMI_IMAGE"
  execution_role = aws_iam_role.imagebuilder_lifecycle.arn

  policy_detail {
    action {
      # DISABLE prevents new EC2 instances from launching with the AMI
      # but keeps the AMI available for reference
      type = "DISABLE"

      include_resources {
        amis = true
        # Don't disable snapshots - only the AMI itself
        snapshots = false
      }
    }

    filter {
      type            = "AGE"
      value           = 1
      unit            = "YEARS"
      retain_at_least = 5
    }
  }

  resource_selection {
    # Select by recipe for precise targeting
    recipe {
      name             = "baseline-ami-recipe"
      semantic_version = "1.2.3"
    }
  }

  tags = {
    Name        = "ami-disable-lifecycle-policy"
    Environment = "production"
    Action      = "disable"
    ManagedBy   = "terraform"
  }

  depends_on = [aws_iam_role_policy_attachment.imagebuilder_lifecycle]
}

# ============================================================
# Outputs
# ============================================================

output "lifecycle_policy_ami_age_based_arn" {
  description = "The ARN of the age-based AMI lifecycle policy"
  value       = aws_imagebuilder_lifecycle_policy.ami_age_based.arn
}

output "lifecycle_policy_ami_age_based_id" {
  description = "The ID of the age-based AMI lifecycle policy"
  value       = aws_imagebuilder_lifecycle_policy.ami_age_based.id
}

output "lifecycle_policy_ami_age_based_status" {
  description = "The status of the age-based AMI lifecycle policy"
  value       = aws_imagebuilder_lifecycle_policy.ami_age_based.status
}

output "lifecycle_policy_container_count_based_arn" {
  description = "The ARN of the count-based container lifecycle policy"
  value       = aws_imagebuilder_lifecycle_policy.container_count_based.arn
}

output "lifecycle_policy_container_count_based_status" {
  description = "The status of the count-based container lifecycle policy"
  value       = aws_imagebuilder_lifecycle_policy.container_count_based.status
}

output "lifecycle_policy_ami_comprehensive_arn" {
  description = "The ARN of the comprehensive AMI lifecycle policy"
  value       = aws_imagebuilder_lifecycle_policy.ami_comprehensive.arn
}

output "lifecycle_policy_ami_disable_arn" {
  description = "The ARN of the AMI disable lifecycle policy"
  value       = aws_imagebuilder_lifecycle_policy.ami_disable.arn
}

output "imagebuilder_lifecycle_role_arn" {
  description = "The ARN of the IAM role used for lifecycle policy execution"
  value       = aws_iam_role.imagebuilder_lifecycle.arn
}

# ============================================================
# Additional Notes
# ============================================================
#
# Best Practices:
# 1. Always use retain_at_least to prevent accidental deletion of all images
# 2. Test lifecycle policies in non-production environments first
# 3. Use exclusion rules to protect critical images
# 4. Consider using DEPRECATE or DISABLE before DELETE for safer transitions
# 5. Monitor lifecycle policy execution through CloudWatch Events
#
# Common Use Cases:
# - Automatic cleanup of development/test AMIs based on age
# - Maintaining a specific count of recent images for rollback capability
# - Disabling old images while preserving them for compliance
# - Managing multi-region image lifecycle with regional exclusions
#
# Important Considerations:
# - Lifecycle policies execute asynchronously
# - Deleted AMIs cannot be recovered
# - Snapshot deletion may incur storage cost savings
# - Public AMIs should typically be excluded from automatic deletion
# - Consider impact on running instances before deleting AMIs
#
# Resource Dependencies:
# - Requires IAM role with EC2ImageBuilderLifecycleExecutionPolicy
# - Image Builder images/containers must exist before policy takes effect
# - Tags must be applied to resources for tag_map selection to work
#
# Attributes Reference:
# - arn: Amazon Resource Name of the lifecycle policy
# - id: Amazon Resource Name of the lifecycle policy (same as arn)
# - status: Current status of the lifecycle policy
# - tags_all: All tags including provider default_tags
#
# ============================================================
