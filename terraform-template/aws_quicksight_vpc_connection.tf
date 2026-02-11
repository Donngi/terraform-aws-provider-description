################################################################################
# AWS QuickSight VPC Connection
# https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/quicksight_vpc_connection
################################################################################

# Resource: aws_quicksight_vpc_connection
# Description: Terraform resource for managing an AWS QuickSight VPC Connection.
#
# QuickSight VPC Connection enables QuickSight to access data sources within a VPC.
# It creates network interfaces in your VPC to establish secure connectivity.
#
# Required IAM permissions for the role:
# - ec2:CreateNetworkInterface
# - ec2:ModifyNetworkInterfaceAttribute
# - ec2:DeleteNetworkInterface
# - ec2:DescribeSubnets
# - ec2:DescribeSecurityGroups

resource "aws_quicksight_vpc_connection" "example" {
  ################################################################################
  # Required Arguments
  ################################################################################

  # vpc_connection_id - The ID of the VPC connection
  # Type: string
  # Forces new resource: No
  # Note: Must be unique within the AWS account
  vpc_connection_id = "example-connection-id"

  # name - The display name for the VPC connection
  # Type: string
  # Forces new resource: No
  # Note: User-friendly name displayed in QuickSight console
  name = "Example Connection"

  # role_arn - The IAM role to associate with the VPC connection
  # Type: string
  # Forces new resource: No
  # Note: Role must have appropriate EC2 network interface permissions
  # Example: arn:aws:iam::123456789012:role/QuickSightVPCConnectionRole
  role_arn = "arn:aws:iam::123456789012:role/QuickSightVPCConnectionRole"

  # security_group_ids - A list of security group IDs for the VPC connection
  # Type: set(string)
  # Forces new resource: No
  # Note: Controls network access for QuickSight network interfaces
  security_group_ids = [
    "sg-00000000000000000",
  ]

  # subnet_ids - A list of subnet IDs for the VPC connection
  # Type: set(string)
  # Forces new resource: No
  # Note: QuickSight creates network interfaces in these subnets
  # Recommendation: Use at least 2 subnets in different AZs for high availability
  subnet_ids = [
    "subnet-00000000000000000",
    "subnet-00000000000000001",
  ]

  ################################################################################
  # Optional Arguments
  ################################################################################

  # aws_account_id - AWS account ID
  # Type: string
  # Default: Automatically determined account ID of the Terraform AWS provider
  # Forces new resource: Yes
  # Note: Typically omitted to use the current AWS account
  # aws_account_id = "123456789012"

  # dns_resolvers - A list of IP addresses of DNS resolver endpoints for the VPC connection
  # Type: set(string)
  # Forces new resource: No
  # Note: Custom DNS resolvers for name resolution within the VPC
  # Example use case: Private DNS zones or Route 53 Resolver endpoints
  # dns_resolvers = [
  #   "10.0.1.10",
  #   "10.0.2.10",
  # ]

  # region - Region where this resource will be managed
  # Type: string
  # Default: Region set in the provider configuration
  # Forces new resource: No
  # Documentation: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # Note: Typically omitted to use the provider's default region
  # region = "us-east-1"

  # tags - Key-value map of resource tags
  # Type: map(string)
  # Forces new resource: No
  # Note: Tags with matching keys will overwrite provider default_tags
  # Documentation: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
    Purpose     = "quicksight-vpc-access"
  }

  ################################################################################
  # Timeouts (Optional)
  ################################################################################

  # timeouts - Resource operation timeout configuration
  # Note: All timeouts use Go duration format (e.g., "30s", "2h45m")
  # Valid time units: "s" (seconds), "m" (minutes), "h" (hours)
  # Documentation: https://pkg.go.dev/time#ParseDuration
  timeouts {
    # create - Maximum time to wait for VPC connection creation
    # Default: Provider default timeout
    create = "5m"

    # update - Maximum time to wait for VPC connection update
    # Default: Provider default timeout
    update = "5m"

    # delete - Maximum time to wait for VPC connection deletion
    # Default: Provider default timeout
    # Note: Only applicable if changes are saved into state before destroy
    delete = "5m"
  }
}

################################################################################
# Computed Attributes (Output Only)
################################################################################

# arn - ARN of the VPC connection
# Type: string
# Example: arn:aws:quicksight:us-east-1:123456789012:vpcConnection/example-connection-id

# availability_status - The availability status of the VPC connection
# Type: string
# Valid values: AVAILABLE, UNAVAILABLE, PARTIALLY_AVAILABLE
# Note: Indicates the current operational status of the VPC connection

# id - A comma-delimited string joining AWS account ID and VPC connection ID
# Type: string
# Format: {aws_account_id},{vpc_connection_id}
# Example: 123456789012,example-connection-id

# tags_all - A map of tags assigned to the resource
# Type: map(string)
# Note: Includes tags inherited from provider default_tags configuration block
# Documentation: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block

################################################################################
# Example: Complete VPC Connection Setup with IAM Role
################################################################################

# Example IAM role for QuickSight VPC connection
resource "aws_iam_role" "quicksight_vpc_connection_example" {
  name = "QuickSightVPCConnectionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          Service = "quicksight.amazonaws.com"
        }
      }
    ]
  })

  inline_policy {
    name = "QuickSightVPCConnectionRolePolicy"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Action = [
            "ec2:CreateNetworkInterface",
            "ec2:ModifyNetworkInterfaceAttribute",
            "ec2:DeleteNetworkInterface",
            "ec2:DescribeSubnets",
            "ec2:DescribeSecurityGroups"
          ]
          Resource = ["*"]
        }
      ]
    })
  }

  tags = {
    Purpose = "quicksight-vpc-connection"
  }
}

# Example VPC connection using the IAM role
resource "aws_quicksight_vpc_connection" "complete_example" {
  vpc_connection_id  = "complete-vpc-connection"
  name               = "Production QuickSight VPC Connection"
  role_arn           = aws_iam_role.quicksight_vpc_connection_example.arn
  security_group_ids = ["sg-00000000000000000"]
  subnet_ids = [
    "subnet-00000000000000000",
    "subnet-00000000000000001",
  ]

  dns_resolvers = [
    "10.0.1.10",
    "10.0.2.10",
  ]

  tags = {
    Environment = "production"
    Team        = "data-analytics"
    ManagedBy   = "terraform"
  }
}

################################################################################
# Outputs
################################################################################

output "vpc_connection_arn" {
  description = "ARN of the QuickSight VPC connection"
  value       = aws_quicksight_vpc_connection.example.arn
}

output "vpc_connection_id" {
  description = "ID of the QuickSight VPC connection"
  value       = aws_quicksight_vpc_connection.example.id
}

output "vpc_connection_status" {
  description = "Availability status of the QuickSight VPC connection"
  value       = aws_quicksight_vpc_connection.example.availability_status
}

################################################################################
# Important Notes
################################################################################

# 1. Network Configuration:
#    - Ensure security groups allow necessary outbound traffic for QuickSight
#    - Subnets must have sufficient IP addresses for network interfaces
#    - Consider using private subnets with NAT gateway for internet access
#
# 2. IAM Role Requirements:
#    - Role must be assumable by quicksight.amazonaws.com service
#    - Required EC2 permissions for network interface management
#    - Role ARN must be provided, not just the role name
#
# 3. High Availability:
#    - Use multiple subnets in different Availability Zones
#    - QuickSight creates network interfaces across specified subnets
#
# 4. DNS Resolution:
#    - dns_resolvers are optional but useful for private DNS zones
#    - Required for accessing resources with private DNS names
#
# 5. Resource Updates:
#    - Most attributes can be updated without recreating the resource
#    - Only aws_account_id forces resource replacement
#    - Network interfaces are managed automatically by AWS
#
# 6. Deletion:
#    - QuickSight automatically cleans up network interfaces
#    - Ensure no data sources are actively using the connection before deletion
#
# 7. Availability Status:
#    - AVAILABLE: Connection is ready for use
#    - UNAVAILABLE: Connection cannot be used
#    - PARTIALLY_AVAILABLE: Some network interfaces are unavailable
#
# 8. Tags:
#    - Use tags for cost allocation and resource organization
#    - Tags are inherited from provider default_tags if configured
#
# 9. Region Considerations:
#    - VPC connection must be in the same region as QuickSight account
#    - Data sources accessed via connection should be in the same region
#
# 10. Cost Implications:
#     - Network interface hours are charged per AWS pricing
#     - Data transfer costs apply for VPC traffic
