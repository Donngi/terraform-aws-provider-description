################################################################################
# AWS QuickSight Ingestion
# https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/quicksight_ingestion
#
# Terraform resource for managing an AWS QuickSight Ingestion.
# An ingestion is a process that imports data into a QuickSight dataset.
################################################################################

resource "aws_quicksight_ingestion" "this" {
  ################################################################################
  # Required Arguments
  ################################################################################

  # ID of the dataset used in the ingestion
  # The dataset must already exist in QuickSight
  # Example: "example-dataset-id"
  data_set_id = null # Required: string

  # Unique ID for the ingestion
  # This is used to identify and track the ingestion job
  # Example: "example-ingestion-id"
  ingestion_id = null # Required: string

  # Type of ingestion to be created
  # Valid values:
  #   - INCREMENTAL_REFRESH: Only imports new or changed data
  #   - FULL_REFRESH: Imports all data, replacing existing data
  # Example: "FULL_REFRESH"
  ingestion_type = null # Required: string (INCREMENTAL_REFRESH | FULL_REFRESH)

  ################################################################################
  # Optional Arguments
  ################################################################################

  # AWS account ID
  # Defaults to automatically determined account ID of the Terraform AWS provider
  # Forces new resource if changed
  # Example: "123456789012"
  # aws_account_id = null # Optional: string

  # Region where this resource will be managed
  # Defaults to the Region set in the provider configuration
  # Reference: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # Example: "us-east-1"
  # region = null # Optional: string

  ################################################################################
  # Computed Attributes (Read-Only)
  ################################################################################

  # arn                - ARN of the Ingestion
  # id                 - A comma-delimited string joining AWS account ID, data set ID, and ingestion ID
  # ingestion_status   - Current status of the ingestion (e.g., INITIALIZED, QUEUED, RUNNING, COMPLETED, FAILED, CANCELLED)
}

################################################################################
# Example Usage
################################################################################

# Example: Basic QuickSight Ingestion
# resource "aws_quicksight_ingestion" "example" {
#   data_set_id    = aws_quicksight_data_set.example.data_set_id
#   ingestion_id   = "example-id"
#   ingestion_type = "FULL_REFRESH"
# }

# Example: Incremental refresh ingestion
# resource "aws_quicksight_ingestion" "incremental" {
#   data_set_id    = aws_quicksight_data_set.example.data_set_id
#   ingestion_id   = "incremental-refresh-id"
#   ingestion_type = "INCREMENTAL_REFRESH"
# }

# Example: Ingestion with specific AWS account ID
# resource "aws_quicksight_ingestion" "cross_account" {
#   data_set_id    = aws_quicksight_data_set.example.data_set_id
#   ingestion_id   = "cross-account-ingestion-id"
#   ingestion_type = "FULL_REFRESH"
#   aws_account_id = "123456789012"
# }

# Example: Ingestion in specific region
# resource "aws_quicksight_ingestion" "regional" {
#   data_set_id    = aws_quicksight_data_set.example.data_set_id
#   ingestion_id   = "regional-ingestion-id"
#   ingestion_type = "FULL_REFRESH"
#   region         = "us-west-2"
# }

################################################################################
# Outputs Example
################################################################################

# output "quicksight_ingestion_arn" {
#   description = "ARN of the QuickSight Ingestion"
#   value       = aws_quicksight_ingestion.this.arn
# }

# output "quicksight_ingestion_id" {
#   description = "ID of the QuickSight Ingestion"
#   value       = aws_quicksight_ingestion.this.id
# }

# output "quicksight_ingestion_status" {
#   description = "Status of the QuickSight Ingestion"
#   value       = aws_quicksight_ingestion.this.ingestion_status
# }

################################################################################
# Notes
################################################################################

# 1. The dataset (data_set_id) must exist before creating an ingestion
# 2. INCREMENTAL_REFRESH requires the dataset to be configured for incremental refresh
# 3. Ingestion status can be monitored using the ingestion_status attribute
# 4. Multiple ingestions can be created for the same dataset with different ingestion_ids
# 5. The aws_account_id parameter forces a new resource if changed
# 6. Common ingestion statuses: INITIALIZED, QUEUED, RUNNING, COMPLETED, FAILED, CANCELLED
