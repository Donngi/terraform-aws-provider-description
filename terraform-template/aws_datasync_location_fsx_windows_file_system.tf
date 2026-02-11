#================================================
# AWS DataSync FSx Windows File System Location
#================================================
# Generated: 2026-01-19
# Provider version: 6.28.0
#
# Note: This template was generated based on the schema and documentation
# available at the time of generation. Always refer to the official
# documentation for the most up-to-date information:
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/datasync_location_fsx_windows_file_system
#================================================

resource "aws_datasync_location_fsx_windows_file_system" "example" {
  #----------------------------
  # Required Arguments
  #----------------------------

  # (Required) The Amazon Resource Name (ARN) for the FSx for Windows file system.
  # Example: arn:aws:fsx:us-west-2:123456789012:file-system/fs-0123456789abcdef0
  # DataSync uses this ARN to identify which FSx for Windows File Server to connect to.
  # https://docs.aws.amazon.com/datasync/latest/userguide/create-fsx-location.html
  fsx_filesystem_arn = "arn:aws:fsx:us-east-1:123456789012:file-system/fs-0123456789abcdef0"

  # (Required) The password of the user who has the permissions to access files and folders
  # in the FSx for Windows file system.
  # This password is used for NTLM authentication. DataSync requires NTLM authentication
  # and does not support Kerberos authentication.
  # Note: This value is sensitive and will not be displayed in Terraform output.
  # https://docs.aws.amazon.com/datasync/latest/userguide/create-fsx-location.html#create-fsx-windows-location-permissions
  password = "SuperSecretPassw0rd"

  # (Required) The Amazon Resource Names (ARNs) of the security groups that are used to
  # configure the FSx for Windows file system.
  # You can specify up to 5 security groups. These security groups must be able to communicate
  # with your file system's security groups. If you choose a security group that doesn't allow
  # connections from within itself, you must configure it to allow communication within itself
  # or choose a different security group.
  # https://docs.aws.amazon.com/datasync/latest/userguide/create-fsx-location.html
  security_group_arns = [
    "arn:aws:ec2:us-east-1:123456789012:security-group/sg-0123456789abcdef0"
  ]

  # (Required) The user who has the permissions to access files and folders in the
  # FSx for Windows file system.
  # This user must belong to a Microsoft Active Directory group for administering the file system:
  # - For AWS Directory Service: member of "AWS Delegated FSx Administrators" group
  # - For self-managed Active Directory: member of "Domain Admins" group or custom delegated
  #   administrators group with "Restore files and directories" (SE_RESTORE_NAME) and
  #   "Manage auditing and security log" (SE_SECURITY_NAME) user rights
  # https://docs.aws.amazon.com/datasync/latest/userguide/create-fsx-location.html#create-fsx-windows-location-permissions
  user = "Admin"

  #----------------------------
  # Optional Arguments
  #----------------------------

  # (Optional) The name of the Windows domain that the FSx for Windows server belongs to.
  # If you have multiple Active Directory domains in your environment, configuring this
  # setting ensures that DataSync connects to the right file system.
  # Example: "corp.example.com"
  # https://docs.aws.amazon.com/datasync/latest/userguide/API_CreateLocationFsxWindows.html
  domain = "corp.example.com"

  # (Optional) Region where this resource will be managed.
  # Defaults to the Region set in the provider configuration.
  # https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs#aws-configuration-reference
  region = "us-east-1"

  # (Optional) Subdirectory to perform actions as source or destination.
  # This is a mount path for the file system using forward slashes.
  # When not specified, defaults to the root of the FSx file system.
  # Example: "/path/to/directory" or "/shared/data"
  # https://docs.aws.amazon.com/datasync/latest/userguide/API_CreateLocationFsxWindows.html
  subdirectory = "/shared/data"

  # (Optional) Key-value pairs of resource tags to assign to the DataSync Location.
  # If configured with a provider default_tags configuration block, tags with matching keys
  # will overwrite those defined at the provider-level.
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "example-datasync-fsx-windows-location"
    Environment = "production"
    Purpose     = "data-transfer"
  }

  # (Optional) A map of tags assigned to the resource, including those inherited from the
  # provider default_tags configuration block.
  # Note: This is typically managed by Terraform automatically when using default_tags.
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags_all = {
    Name        = "example-datasync-fsx-windows-location"
    Environment = "production"
    Purpose     = "data-transfer"
    ManagedBy   = "Terraform"
  }

  # Note: The 'id' attribute is also optional + computed, but it's typically not set by users.
  # It defaults to the ARN of the location and is automatically managed by Terraform.
  # See the Computed Attributes section below for more details.
}

#----------------------------
# Computed Attributes (Read-only)
#----------------------------
# These attributes are computed by AWS and cannot be set in the configuration.
# You can reference them using: aws_datasync_location_fsx_windows_file_system.example.<attribute>
#
# - arn: Amazon Resource Name (ARN) of the DataSync Location
#   Example: arn:aws:datasync:us-east-1:123456789012:location/loc-0123456789abcdef0
#
# - creation_time: The time that the FSx for Windows location was created
#   Format: RFC3339 timestamp
#   Example: "2024-01-15T10:30:00Z"
#
# - id: Amazon Resource Name (ARN) of the DataSync Location (same as arn)
#   Example: arn:aws:datasync:us-east-1:123456789012:location/loc-0123456789abcdef0
#
# - uri: The URL of the FSx for Windows location that was described
#   Example: smb://fs-0123456789abcdef0.corp.example.com/share

#----------------------------
# Important Notes
#----------------------------
# 1. Authentication: FSx for Windows File Server must use NTLM authentication.
#    DataSync cannot access a file server that uses Kerberos authentication.
#
# 2. VPC Requirements: VPCs used with DataSync must have default tenancy.
#    VPCs with dedicated tenancy are not supported.
#
# 3. DFS Namespaces: DataSync does not support Microsoft Distributed File System (DFS) Namespaces.
#    Specify an underlying file server or share instead when creating your DataSync location.
#
# 4. Security Groups: The security groups must allow DataSync to communicate with your
#    FSx file system's security groups. Ensure proper inbound and outbound rules are configured.
#
# 5. User Permissions: The SYSTEM user on your FSx for Windows File Server must have
#    "Full control" permissions on all folders. Do not change NTFS ACL permissions for this user.
#
# 6. Cross-Domain Transfers: When copying Windows ACLs between SMB file servers or FSx systems,
#    the users must belong to the same Active Directory domain or have an Active Directory
#    trust relationship between their domains.

#----------------------------
# References
#----------------------------
# AWS DataSync Documentation:
# - https://docs.aws.amazon.com/datasync/latest/userguide/create-fsx-location.html
# - https://docs.aws.amazon.com/datasync/latest/userguide/API_CreateLocationFsxWindows.html
# - https://docs.aws.amazon.com/datasync/latest/userguide/API_UpdateLocationFsxWindows.html
# - https://docs.aws.amazon.com/datasync/latest/userguide/API_DescribeLocationFsxWindows.html
#
# Amazon FSx for Windows File Server Documentation:
# - https://docs.aws.amazon.com/fsx/latest/WindowsGuide/getting-started.html
# - https://docs.aws.amazon.com/fsx/latest/WindowsGuide/limit-access-security-groups.html
# - https://docs.aws.amazon.com/fsx/latest/WindowsGuide/limit-access-file-folder.html
#
# Terraform Provider Documentation:
# - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/datasync_location_fsx_windows_file_system
