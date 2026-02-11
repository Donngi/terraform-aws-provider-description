#---------------------------------------------------------------
# Amazon EFS Access Point
#---------------------------------------------------------------
#
# Provides an Elastic File System (EFS) access point. Access points are
# application-specific entry points that simplify managing access to shared
# datasets on Amazon EFS. They can enforce a user identity (POSIX user/group)
# and a root directory for file system requests made through the access point.
#
# AWS公式ドキュメント:
#   - Working with access points: https://docs.aws.amazon.com/efs/latest/ug/efs-access-points.html
#   - Mounting with EFS access points: https://docs.aws.amazon.com/efs/latest/ug/mounting-access-points.html
#   - Enforcing a user identity: https://docs.aws.amazon.com/efs/latest/ug/enforce-identity-access-points.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_access_point
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_efs_access_point" "example" {
  #---------------------------------------------------------------
  # Required Arguments
  #---------------------------------------------------------------

  # ID of the EFS file system for which this access point is intended.
  # Access points provide application-specific entry points into an EFS file system.
  # You must have an existing EFS file system before creating an access point.
  file_system_id = "fs-12345678"

  #---------------------------------------------------------------
  # Optional Arguments
  #---------------------------------------------------------------

  # ID of the access point. This is typically computed by AWS and should not
  # be manually set. Terraform uses this for resource identification.
  # Type: string (optional, computed)
  # Default: Computed by AWS
  # id = null

  # Region where this resource will be managed. Defaults to the Region set
  # in the provider configuration. Use this to explicitly override the region
  # for this specific resource.
  # Type: string (optional, computed)
  # Default: Provider region
  # region = "us-east-1"

  # Key-value mapping of resource tags. Tags help identify and organize
  # AWS resources. If configured with a provider default_tags configuration
  # block, tags with matching keys will overwrite those defined at the
  # provider-level.
  # Type: map(string)
  # Default: {}
  tags = {
    Name        = "example-access-point"
    Environment = "production"
  }

  # Map of tags assigned to the resource, including those inherited from
  # the provider default_tags configuration block. This is typically computed
  # and should not be manually set.
  # Type: map(string) (optional, computed)
  # Default: Computed from tags + provider default_tags
  # tags_all = {}

  #---------------------------------------------------------------
  # POSIX User Block (Optional)
  #---------------------------------------------------------------
  # Operating system user and group applied to all file system requests
  # made using this access point. When configured, EFS replaces the NFS
  # client's user and group IDs with the identity specified here.
  # This enforces a specific user identity for all operations through
  # this access point, regardless of the NFS client's actual identity.
  # Maximum: 1 block
  #---------------------------------------------------------------

  posix_user {
    # POSIX group ID used for all file system operations using this
    # access point. This becomes the effective group ID for all file
    # operations made through the access point.
    # Type: number (required)
    # Valid range: 0-4294967295
    gid = 1000

    # POSIX user ID used for all file system operations using this
    # access point. This becomes the effective user ID for all file
    # operations made through the access point.
    # Type: number (required)
    # Valid range: 0-4294967295
    uid = 1000

    # Secondary POSIX group IDs used for all file system operations
    # using this access point. These provide additional group memberships
    # for permission evaluation.
    # Type: set(number) (optional)
    # Default: []
    # secondary_gids = [1001, 1002]
  }

  #---------------------------------------------------------------
  # Root Directory Block (Optional)
  #---------------------------------------------------------------
  # Specifies the directory on the EFS file system that the access point
  # exposes as the root directory to NFS clients. This allows you to
  # provide different applications access to different directories within
  # the same file system, appearing to each application as if it's the
  # root directory.
  # Maximum: 1 block
  #---------------------------------------------------------------

  root_directory {
    # Path on the EFS file system to expose as the root directory to
    # NFS clients using this access point. A path can have up to four
    # subdirectories. If the specified path does not exist, you must
    # provide creation_info to have EFS create it automatically.
    # Type: string (optional, computed)
    # Default: "/" (root of the file system)
    # Format: Must start with "/" and can have up to 4 subdirectories
    # Example: "/data/application"
    path = "/app-data"

    #---------------------------------------------------------------
    # Creation Info Sub-block (Optional within root_directory)
    #---------------------------------------------------------------
    # POSIX IDs and permissions to apply when creating the root directory
    # specified in the path. This is required if the path does not exist
    # and needs to be created. EFS will create the directory with these
    # attributes on first mount through this access point.
    # Maximum: 1 block
    #---------------------------------------------------------------

    creation_info {
      # POSIX group ID to apply to the root_directory. This sets the
      # group ownership of the created directory.
      # Type: number (required)
      # Valid range: 0-4294967295
      owner_gid = 1000

      # POSIX user ID to apply to the root_directory. This sets the
      # user ownership of the created directory.
      # Type: number (required)
      # Valid range: 0-4294967295
      owner_uid = 1000

      # POSIX permissions to apply to the root_directory, in the format
      # of an octal number representing the file's mode bits.
      # Type: string (required)
      # Format: 4-digit octal string (e.g., "0755", "0644")
      # Examples:
      #   - "0755": rwxr-xr-x (owner full, group/others read+execute)
      #   - "0750": rwxr-x--- (owner full, group read+execute, others none)
      #   - "0700": rwx------ (owner full, group/others none)
      permissions = "0755"
    }
  }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# In addition to all arguments above, the following attributes are exported:
#
# - arn: ARN of the access point.
#   Example: "arn:aws:elasticfilesystem:us-east-1:123456789012:access-point/fsap-12345678"
#
# - file_system_arn: ARN of the file system.
#   Example: "arn:aws:elasticfilesystem:us-east-1:123456789012:file-system/fs-12345678"
#
# - id: ID of the access point (same as access point ID).
#   Example: "fsap-12345678"
#
# - owner_id: AWS account ID of the access point owner.
#   Example: "123456789012"
#
# - tags_all: Map of tags assigned to the resource, including those
#   inherited from the provider default_tags configuration block.
#
#---------------------------------------------------------------
# Import
#---------------------------------------------------------------
# EFS access points can be imported using the id:
#
# $ terraform import aws_efs_access_point.example fsap-12345678
#
#---------------------------------------------------------------
