################################################################################
# AWS RDS Reserved Instance
#
# Manages an RDS DB Reserved Instance.
#
# Provider Version: 6.28.0
# Resource: aws_rds_reserved_instance
# Documentation: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/rds_reserved_instance
################################################################################

# IMPORTANT NOTES:
# - Once created, a reservation is valid for the 'duration' of the provided
#   'offering_id' and cannot be deleted
# - Performing a 'destroy' will only remove the resource from state
# - For more information see:
#   - RDS Reserved Instances Documentation: https://aws.amazon.com/rds/reserved-instances/
#   - PurchaseReservedDBInstancesOffering API: https://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_PurchaseReservedDBInstancesOffering.html
# - This resource is provided as best effort due to testing costs

################################################################################
# Data Source: RDS Reserved Instance Offering
################################################################################

# First, find an appropriate offering using the data source
data "aws_rds_reserved_instance_offering" "example" {
  # Database instance class (e.g., db.t2.micro, db.t3.medium, db.m5.large)
  db_instance_class = "db.t2.micro"

  # Duration in seconds (31536000 = 1 year, 94608000 = 3 years)
  duration = 31536000

  # Whether the offering applies to Multi-AZ deployments
  multi_az = false

  # Offering type: "No Upfront", "Partial Upfront", "All Upfront"
  offering_type = "All Upfront"

  # Database engine product description (e.g., "mysql", "postgres", "oracle-se2")
  product_description = "mysql"
}

################################################################################
# RDS Reserved Instance
################################################################################

resource "aws_rds_reserved_instance" "example" {
  ################################################################################
  # Required Arguments
  ################################################################################

  # ID of the Reserved DB instance offering to purchase
  # Use the aws_rds_reserved_instance_offering data source to find offerings
  offering_id = data.aws_rds_reserved_instance_offering.example.offering_id

  ################################################################################
  # Optional Arguments
  ################################################################################

  # Number of instances to reserve
  # Default: 1
  instance_count = 3

  # Customer-specified identifier to track this reservation
  # Must be unique for the AWS account
  # If not specified, AWS generates a unique identifier
  reservation_id = "my-rds-reservation-2026"

  # AWS region where this resource will be managed
  # Defaults to the region set in the provider configuration
  # region = "us-east-1"

  # Tags to assign to the DB reservation
  # Note: Tags with matching keys from provider default_tags will be overwritten
  tags = {
    Name        = "Example RDS Reserved Instance"
    Environment = "production"
    ManagedBy   = "Terraform"
    Purpose     = "Cost optimization"
  }

  ################################################################################
  # Computed Attributes (Read-Only)
  ################################################################################

  # The following attributes are computed after creation:
  # - arn                  : ARN for the reserved DB instance
  # - id                   : Unique identifier for the reservation (same as reservation_id)
  # - currency_code        : Currency code for the reserved DB instance
  # - duration             : Duration of the reservation in seconds
  # - fixed_price          : Fixed price charged for this reserved DB instance
  # - db_instance_class    : DB instance class for the reserved DB instance
  # - lease_id             : Unique identifier for the lease (may be needed for AWS Support)
  # - multi_az             : Whether the reservation applies to Multi-AZ deployments
  # - offering_type        : Offering type of this reserved DB instance
  # - product_description  : Description of the reserved DB instance
  # - recurring_charges    : Recurring price charged to run this reserved DB instance
  # - start_time           : Time the reservation started
  # - state                : State of the reserved DB instance
  # - usage_price          : Hourly price charged for this reserved DB instance
  # - tags_all             : Map of tags including provider default_tags
}

################################################################################
# Outputs
################################################################################

output "rds_reserved_instance_id" {
  description = "The ID of the reserved DB instance"
  value       = aws_rds_reserved_instance.example.id
}

output "rds_reserved_instance_arn" {
  description = "The ARN of the reserved DB instance"
  value       = aws_rds_reserved_instance.example.arn
}

output "rds_reserved_instance_state" {
  description = "The state of the reserved DB instance"
  value       = aws_rds_reserved_instance.example.state
}

output "rds_reserved_instance_db_class" {
  description = "The DB instance class for the reserved DB instance"
  value       = aws_rds_reserved_instance.example.db_instance_class
}

output "rds_reserved_instance_lease_id" {
  description = "The lease ID for the reserved DB instance (for AWS Support)"
  value       = aws_rds_reserved_instance.example.lease_id
}

output "rds_reserved_instance_fixed_price" {
  description = "The fixed price charged for this reserved DB instance"
  value       = aws_rds_reserved_instance.example.fixed_price
}

output "rds_reserved_instance_usage_price" {
  description = "The hourly price charged for this reserved DB instance"
  value       = aws_rds_reserved_instance.example.usage_price
}

output "rds_reserved_instance_start_time" {
  description = "The time the reservation started"
  value       = aws_rds_reserved_instance.example.start_time
}

################################################################################
# Additional Usage Examples
################################################################################

# Example 1: PostgreSQL Reserved Instance with different configuration
# resource "aws_rds_reserved_instance" "postgres_example" {
#   offering_id    = data.aws_rds_reserved_instance_offering.postgres.offering_id
#   instance_count = 1
#   reservation_id = "postgres-prod-reservation"
#
#   tags = {
#     Name   = "PostgreSQL Production Reserved Instance"
#     Engine = "PostgreSQL"
#   }
# }

# Example 2: Multi-AZ MySQL Reserved Instance
# data "aws_rds_reserved_instance_offering" "multi_az" {
#   db_instance_class   = "db.m5.large"
#   duration            = 94608000  # 3 years
#   multi_az            = true
#   offering_type       = "Partial Upfront"
#   product_description = "mysql"
# }
#
# resource "aws_rds_reserved_instance" "multi_az_example" {
#   offering_id    = data.aws_rds_reserved_instance_offering.multi_az.offering_id
#   instance_count = 2
#
#   tags = {
#     Name        = "Multi-AZ MySQL Reserved Instance"
#     Availability = "High"
#   }
# }

# Example 3: Oracle Reserved Instance
# data "aws_rds_reserved_instance_offering" "oracle" {
#   db_instance_class   = "db.m5.xlarge"
#   duration            = 31536000  # 1 year
#   multi_az            = false
#   offering_type       = "No Upfront"
#   product_description = "oracle-se2"
# }
#
# resource "aws_rds_reserved_instance" "oracle_example" {
#   offering_id    = data.aws_rds_reserved_instance_offering.oracle.offering_id
#   instance_count = 1
#   reservation_id = "oracle-se2-reservation"
#
#   tags = {
#     Name   = "Oracle SE2 Reserved Instance"
#     Engine = "Oracle"
#   }
# }
