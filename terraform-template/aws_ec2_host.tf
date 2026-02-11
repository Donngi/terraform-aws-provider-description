# ==============================================================================
# AWS EC2 Host - Dedicated Host Resource
# ==============================================================================
# Provider Version: 6.28.0
# Resource: aws_ec2_host
# Purpose: Provides an EC2 Host resource. This allows Dedicated Hosts to be
#          allocated, modified, and released.
#
# Official Documentation:
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_host
# AWS API Reference:
# https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_AllocateHosts.html
# ==============================================================================

resource "aws_ec2_host" "example" {
  # --------------------------------------------------------------------------
  # REQUIRED ATTRIBUTES
  # --------------------------------------------------------------------------

  # availability_zone (Required, Forces new resource)
  # Type: string
  # The Availability Zone in which to allocate the Dedicated Host.
  # The Dedicated Host will be allocated in this specific AZ and cannot be
  # moved to another AZ once created.
  #
  # Example values: "us-west-2a", "us-east-1b", "eu-west-1c"
  availability_zone = "us-west-2a"

  # --------------------------------------------------------------------------
  # INSTANCE TYPE CONFIGURATION (One Required)
  # --------------------------------------------------------------------------
  # You must specify exactly ONE of the following: instance_family OR instance_type
  # These determine what types of instances can be launched on the Dedicated Host.

  # instance_type (Optional)
  # Type: string
  # Specifies the instance type to be supported by the Dedicated Hosts. If you
  # specify an instance type, the Dedicated Hosts support instances of the
  # specified instance type only.
  #
  # Use this when you want to dedicate the host to a specific instance type.
  # Exactly one of instance_family or instance_type must be specified.
  #
  # Example values: "c5.18xlarge", "m5.large", "r5.xlarge", "t3.medium"
  instance_type = "c5.18xlarge"

  # instance_family (Optional)
  # Type: string
  # Specifies the instance family to be supported by the Dedicated Hosts. If
  # you specify an instance family, the Dedicated Hosts support multiple
  # instance types within that instance family.
  #
  # Use this when you want flexibility to run different instance sizes within
  # the same family. Exactly one of instance_family or instance_type must be specified.
  #
  # Example values: "c5", "m5", "r5", "t3"
  # instance_family = "c5"

  # --------------------------------------------------------------------------
  # PLACEMENT AND RECOVERY CONFIGURATION
  # --------------------------------------------------------------------------

  # auto_placement (Optional)
  # Type: string
  # Default: "on"
  # Valid values: "on", "off"
  #
  # Indicates whether the host accepts any untargeted instance launches that
  # match its instance type configuration, or if it only accepts Host tenancy
  # instance launches that specify its unique host ID.
  #
  # - "on": The Dedicated Host accepts untargeted instance launches that match
  #   its instance type configuration
  # - "off": The Dedicated Host only accepts Host tenancy instance launches
  #   that explicitly target the host by its ID
  #
  # Use "on" for flexibility, "off" for strict control over which instances
  # can be placed on the host.
  auto_placement = "on"

  # host_recovery (Optional)
  # Type: string
  # Default: "off"
  # Valid values: "on", "off"
  #
  # Indicates whether to enable or disable host recovery for the Dedicated Host.
  # When enabled, if the underlying hardware fails, AWS automatically launches
  # a replacement Dedicated Host and migrates your instances to it.
  #
  # - "on": Host recovery is enabled
  # - "off": Host recovery is disabled
  #
  # Enable this for improved availability and automatic recovery from hardware failures.
  host_recovery = "on"

  # --------------------------------------------------------------------------
  # OUTPOST CONFIGURATION
  # --------------------------------------------------------------------------

  # outpost_arn (Optional, Forces new resource)
  # Type: string
  # The Amazon Resource Name (ARN) of the AWS Outpost on which to allocate
  # the Dedicated Host.
  #
  # Specify this when you want to allocate the Dedicated Host on an AWS Outpost
  # instead of in a standard AWS Region. If you are allocating the Dedicated
  # Hosts in a Region, omit this parameter.
  #
  # Example: "arn:aws:outposts:us-west-2:123456789012:outpost/op-1234567890abcdef0"
  # outpost_arn = null

  # asset_id (Optional, Computed)
  # Type: string
  # The ID of the Outpost hardware asset on which to allocate the Dedicated Hosts.
  #
  # This parameter is supported only if you specify outpost_arn. If you are
  # allocating the Dedicated Hosts in a Region, omit this parameter.
  #
  # If not specified when using outpost_arn, AWS will compute and assign an
  # appropriate asset ID automatically.
  #
  # Example: "asset-1234567890abcdef0"
  # asset_id = null

  # --------------------------------------------------------------------------
  # REGIONAL CONFIGURATION
  # --------------------------------------------------------------------------

  # region (Optional, Computed)
  # Type: string
  # Region where this resource will be managed.
  #
  # Defaults to the Region set in the provider configuration. You can override
  # this to manage the resource in a different region than the provider default.
  #
  # Reference: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # Example: "us-west-2", "eu-west-1", "ap-southeast-1"
  # region = null

  # --------------------------------------------------------------------------
  # TAGGING
  # --------------------------------------------------------------------------

  # tags (Optional)
  # Type: map(string)
  # Map of tags to assign to this resource.
  #
  # Tags help you organize and manage your AWS resources. You can use tags for
  # cost allocation, access control, and automation.
  #
  # If configured with a provider default_tags configuration block, tags with
  # matching keys will overwrite those defined at the provider-level.
  #
  # Example:
  tags = {
    Name        = "dedicated-host-example"
    Environment = "production"
    ManagedBy   = "terraform"
    CostCenter  = "engineering"
  }

  # tags_all (Optional, Computed)
  # Type: map(string)
  # A map of tags assigned to the resource, including those inherited from the
  # provider default_tags configuration block.
  #
  # This is computed by AWS and includes both explicitly set tags and those
  # from the provider's default_tags. You typically don't need to set this manually.
  # tags_all = null

  # --------------------------------------------------------------------------
  # TIMEOUTS
  # --------------------------------------------------------------------------
  # Configure custom timeouts for create, update, and delete operations.
  # Useful for managing long-running operations or working with resources
  # that may take longer than the default timeouts.

  timeouts {
    # create (Optional)
    # Type: string
    # Default: No timeout
    # Maximum time to wait for the Dedicated Host to be created.
    #
    # Format: Duration string (e.g., "10m", "1h", "30s")
    # Example: "10m"
    # create = null

    # update (Optional)
    # Type: string
    # Default: No timeout
    # Maximum time to wait for the Dedicated Host to be updated.
    #
    # Format: Duration string (e.g., "10m", "1h", "30s")
    # Example: "10m"
    # update = null

    # delete (Optional)
    # Type: string
    # Default: No timeout
    # Maximum time to wait for the Dedicated Host to be deleted.
    #
    # Format: Duration string (e.g., "10m", "1h", "30s")
    # Example: "10m"
    # delete = null
  }
}

# ==============================================================================
# COMPUTED ATTRIBUTES (Read-Only)
# ==============================================================================
# These attributes are computed by AWS and available after resource creation.
# They can be referenced in other resources or outputs.

# id
# Type: string
# The ID of the allocated Dedicated Host. This is used to launch an instance
# onto a specific host by specifying this ID in the instance's host_id attribute.
#
# Example output reference:
# output "host_id" {
#   value       = aws_ec2_host.example.id
#   description = "The ID of the Dedicated Host"
# }

# arn
# Type: string
# The ARN of the Dedicated Host.
# Format: arn:aws:ec2:region:account-id:dedicated-host/host-id
#
# Example output reference:
# output "host_arn" {
#   value       = aws_ec2_host.example.arn
#   description = "The ARN of the Dedicated Host"
# }

# owner_id
# Type: string
# The ID of the AWS account that owns the Dedicated Host.
#
# Example output reference:
# output "host_owner_id" {
#   value       = aws_ec2_host.example.owner_id
#   description = "The AWS account ID that owns the Dedicated Host"
# }

# ==============================================================================
# USAGE EXAMPLES
# ==============================================================================

# Example 1: Basic Dedicated Host with instance type
# resource "aws_ec2_host" "basic" {
#   instance_type     = "c5.18xlarge"
#   availability_zone = "us-west-2a"
#
#   tags = {
#     Name = "basic-dedicated-host"
#   }
# }

# Example 2: Dedicated Host with instance family for flexibility
# resource "aws_ec2_host" "flexible" {
#   instance_family   = "c5"
#   availability_zone = "us-west-2a"
#   auto_placement    = "on"
#   host_recovery     = "on"
#
#   tags = {
#     Name = "flexible-dedicated-host"
#   }
# }

# Example 3: Dedicated Host with strict placement control
# resource "aws_ec2_host" "strict" {
#   instance_type     = "m5.large"
#   availability_zone = "us-west-2a"
#   auto_placement    = "off"  # Only targeted launches allowed
#   host_recovery     = "on"
#
#   tags = {
#     Name        = "strict-dedicated-host"
#     Environment = "production"
#   }
# }

# Example 4: Outpost Dedicated Host
# resource "aws_ec2_host" "outpost" {
#   instance_type     = "c5.large"
#   availability_zone = "us-west-2a"
#   outpost_arn       = "arn:aws:outposts:us-west-2:123456789012:outpost/op-1234567890abcdef0"
#
#   tags = {
#     Name = "outpost-dedicated-host"
#   }
# }

# Example 5: Launch EC2 instance on Dedicated Host
# resource "aws_ec2_host" "app_host" {
#   instance_type     = "c5.xlarge"
#   availability_zone = "us-west-2a"
#   auto_placement    = "off"
#
#   tags = {
#     Name = "app-dedicated-host"
#   }
# }
#
# resource "aws_instance" "app" {
#   ami                    = "ami-0c55b159cbfafe1f0"
#   instance_type          = "c5.xlarge"
#   availability_zone      = "us-west-2a"
#   host_id                = aws_ec2_host.app_host.id
#   tenancy                = "host"
#
#   tags = {
#     Name = "app-on-dedicated-host"
#   }
# }

# ==============================================================================
# IMPORTANT NOTES
# ==============================================================================
#
# 1. INSTANCE TYPE vs INSTANCE FAMILY:
#    - You MUST specify exactly one of instance_type or instance_family
#    - instance_type: More restrictive, allows only specific instance size
#    - instance_family: More flexible, allows any size within the family
#
# 2. BILLING:
#    - Dedicated Hosts are billed per-host, not per-instance
#    - Charges apply regardless of how many instances are running on the host
#    - On-Demand, Reservation, and Savings Plans pricing models are available
#
# 3. AUTO PLACEMENT:
#    - Set to "on" for convenience (instances can auto-launch on the host)
#    - Set to "off" for strict control (must explicitly target the host ID)
#
# 4. HOST RECOVERY:
#    - Recommended to enable ("on") for production workloads
#    - Provides automatic failover in case of hardware issues
#    - Does not support all instance types; check AWS documentation
#
# 5. CAPACITY:
#    - Each Dedicated Host has limited capacity based on instance type/family
#    - Monitor capacity using CloudWatch metrics
#    - Plan your instance placement accordingly
#
# 6. LICENSE COMPLIANCE:
#    - Dedicated Hosts are useful for bring-your-own-license (BYOL) scenarios
#    - Helps meet software licensing requirements that need dedicated hardware
#    - Track license usage using AWS License Manager integration
#
# 7. OUTPOSTS:
#    - When using Outposts, both outpost_arn and asset_id may be required
#    - Verify Outpost has sufficient capacity before allocation
#
# 8. REGION AND AVAILABILITY ZONE:
#    - Cannot move Dedicated Host between AZs after creation
#    - Choose AZ based on your application's placement requirements
#    - Ensure capacity is available in the selected AZ
#
# 9. TAGS:
#    - Use tags for cost allocation tracking
#    - Tag inheritance from provider default_tags is supported
#    - Tags can be modified after creation
#
# 10. FORCE NEW RESOURCE:
#     - Changing availability_zone or outpost_arn forces replacement
#     - Plan accordingly as this will result in downtime
#
# ==============================================================================
