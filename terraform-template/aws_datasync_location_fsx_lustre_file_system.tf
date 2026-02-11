# ==============================================================================
# Terraform Template: aws_datasync_location_fsx_lustre_file_system
# ==============================================================================
# Generated: 2026-01-19
# Provider: hashicorp/aws v6.28.0
#
# NOTE: This template is generated based on the schema at the time of creation.
#       Please verify the latest specifications in the official documentation:
#       https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/datasync_location_fsx_lustre_file_system
# ==============================================================================

# ------------------------------------------------------------------------------
# Resource: aws_datasync_location_fsx_lustre_file_system
# ------------------------------------------------------------------------------
# Manages an AWS DataSync FSx Lustre Location.
#
# This resource creates a transfer location for an Amazon FSx for Lustre file
# system. DataSync can use this location as a source or destination for
# transferring data.
#
# DataSync accesses your FSx for Lustre file system using the Lustre client
# and mounts the file system as the root user (UID and GID of 0).
#
# AWS Documentation:
# - User Guide: https://docs.aws.amazon.com/datasync/latest/userguide/create-lustre-location.html
# - API Reference: https://docs.aws.amazon.com/datasync/latest/userguide/API_CreateLocationFsxLustre.html
# ------------------------------------------------------------------------------

resource "aws_datasync_location_fsx_lustre_file_system" "example" {
  # ============================================================================
  # Required Arguments
  # ============================================================================

  # fsx_filesystem_arn - (Required)
  # The Amazon Resource Name (ARN) for the FSx for Lustre file system.
  # This is the fully qualified ARN of the file system that you want to read
  # from or write to.
  #
  # Format: arn:aws:fsx:region:account-id:file-system/filesystem-id
  #
  # Example: "arn:aws:fsx:us-west-2:123456789012:file-system/fs-0123456789abcdef0"
  #
  # Reference: https://docs.aws.amazon.com/fsx/latest/LustreGuide/getting-started.html
  fsx_filesystem_arn = "arn:aws:fsx:us-west-2:123456789012:file-system/fs-0123456789abcdef0"

  # security_group_arns - (Required)
  # The Amazon Resource Names (ARNs) of the security groups that are used to
  # configure the FSx for Lustre file system.
  #
  # You can specify up to five security groups that provide access to your
  # FSx for Lustre file system. The security groups must be able to access
  # the file system's ports, and the file system must also allow access from
  # the security groups.
  #
  # DataSync applies these security groups to the network interfaces created
  # in the file system's preferred subnet.
  #
  # Format: Set of security group ARNs
  # Example: ["arn:aws:ec2:us-west-2:123456789012:security-group/sg-0123456789abcdef0"]
  #
  # Reference: https://docs.aws.amazon.com/fsx/latest/LustreGuide/limit-access-security-groups.html
  security_group_arns = ["arn:aws:ec2:us-west-2:123456789012:security-group/sg-0123456789abcdef0"]

  # ============================================================================
  # Optional Arguments
  # ============================================================================

  # subdirectory - (Optional)
  # Subdirectory to perform actions as source or destination.
  #
  # This is the mount path for your FSx for Lustre file system. The path can
  # include a subdirectory. When the location is used as a source, DataSync
  # reads data from the mount path. When the location is used as a destination,
  # DataSync writes all data to the mount path.
  #
  # If a subdirectory isn't provided, DataSync uses the root directory (/).
  #
  # Example: "/my-subdirectory" or "/data/exports"
  #
  # Default: "/" (root directory)
  subdirectory = "/my-subdirectory"

  # region - (Optional)
  # Region where this resource will be managed.
  #
  # Defaults to the Region set in the provider configuration. This parameter
  # allows you to specify a different region for this specific resource.
  #
  # Example: "us-west-2"
  #
  # Reference: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = "us-west-2"

  # tags - (Optional)
  # Key-value pairs of resource tags to assign to the DataSync Location.
  #
  # If configured with a provider default_tags configuration block, tags with
  # matching keys will overwrite those defined at the provider-level.
  #
  # Tags help you manage, filter, and search for your AWS resources.
  # It's recommended to create at least a name tag for your location.
  #
  # Example:
  # tags = {
  #   Name        = "my-fsx-lustre-location"
  #   Environment = "production"
  #   Project     = "data-migration"
  # }
  #
  # Reference: https://docs.aws.amazon.com/general/latest/gr/aws_tagging.html
  tags = {
    Name        = "my-fsx-lustre-location"
    Environment = "production"
  }

  # tags_all - (Optional)
  # A map of tags assigned to the resource, including those inherited from
  # the provider default_tags configuration block.
  #
  # This argument is typically managed by Terraform and includes all tags,
  # both those explicitly set in the tags argument and those inherited from
  # the provider configuration.
  #
  # Note: In most cases, you should use the 'tags' argument instead of
  # 'tags_all'. The 'tags_all' argument is primarily used when you need to
  # explicitly override provider-level default tags.
  #
  # Reference: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  # tags_all = {}

  # id - (Optional)
  # The unique identifier for the DataSync Location.
  #
  # This is typically set to the Amazon Resource Name (ARN) of the DataSync
  # Location. In most cases, this is computed by Terraform and does not need
  # to be explicitly set.
  #
  # Note: This is generally a computed attribute and rarely needs to be
  # explicitly configured.
  # id = ""
}

# ==============================================================================
# Computed Attributes (Read-Only)
# ==============================================================================
# The following attributes are exported and can be referenced but cannot be set:
#
# - arn            : Amazon Resource Name (ARN) of the DataSync Location
# - creation_time  : The time that the FSx for Lustre location was created
# - uri            : The URL of the FSx for Lustre location
# - id             : Amazon Resource Name (ARN) of the DataSync Location (if not set)
#
# Example usage of computed attributes:
#
# output "location_arn" {
#   description = "The ARN of the DataSync FSx Lustre location"
#   value       = aws_datasync_location_fsx_lustre_file_system.example.arn
# }
#
# output "location_uri" {
#   description = "The URI of the FSx Lustre location"
#   value       = aws_datasync_location_fsx_lustre_file_system.example.uri
# }
# ==============================================================================
