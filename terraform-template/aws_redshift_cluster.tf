# ============================================================
# AWS Redshift Cluster Resource
# Terraform AWS Provider Version: 6.28.0
# ============================================================
# Provides a Redshift Cluster Resource.
#
# Note: All arguments including the username and password will be stored in
# the raw state as plain-text. Read more about sensitive data in state.
#
# Note: A Redshift cluster's default IAM role can be managed both by this
# resource's default_iam_role_arn argument and the aws_redshift_cluster_iam_roles
# resource's default_iam_role_arn argument. Do not configure different values
# for both arguments. Doing so will cause a conflict of default IAM roles.
#
# Documentation: https://raw.githubusercontent.com/hashicorp/terraform-provider-aws/main/website/docs/r/redshift_cluster.html.markdown
# ============================================================

resource "aws_redshift_cluster" "example" {
  # ============================================================
  # Required Arguments
  # ============================================================

  # (Required) The Cluster Identifier. Must be a lower case string.
  cluster_identifier = "tf-redshift-cluster"

  # (Required) The node type to be provisioned for the cluster.
  # Examples: dc2.large, dc2.8xlarge, ra3.xlplus, ra3.4xlarge, ra3.16xlarge
  node_type = "dc2.large"

  # ============================================================
  # Master User Credentials (One of the following is required)
  # ============================================================

  # (Required unless snapshot_identifier is provided) Username for the master DB user.
  master_username = "admin"

  # Option 1: Using master_password (stored in state)
  # (Optional) Password for the master DB user.
  # Conflicts with manage_master_password and master_password_wo.
  # Password must contain at least 8 characters and contain at least one
  # uppercase letter, one lowercase letter, and one number.
  # Note: This will be stored in the state file.
  master_password = "ExamplePassword123"

  # Option 2: Using AWS Secrets Manager (Recommended)
  # (Optional) Whether to use AWS SecretsManager to manage the cluster admin credentials.
  # Conflicts with master_password and master_password_wo.
  # manage_master_password = true

  # (Optional) ID of the KMS key used to encrypt the cluster admin credentials secret.
  # Only used when manage_master_password is true.
  # master_password_secret_kms_key_id = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"

  # Option 3: Using Write-Only password (Terraform 1.11.0+)
  # (Optional, Write-Only) Password for the master DB user.
  # Conflicts with manage_master_password and master_password.
  # Note: This may show up in logs but not in state.
  # master_password_wo = "ExamplePassword123"

  # (Optional) Used together with master_password_wo to trigger an update.
  # Increment this value when an update to the master_password_wo is required.
  # master_password_wo_version = 1

  # ============================================================
  # Cluster Configuration
  # ============================================================

  # (Optional) The cluster type to use. Either single-node or multi-node.
  # Default: single-node (when number_of_nodes is not specified)
  cluster_type = "single-node"

  # (Optional) The number of compute nodes in the cluster.
  # This parameter is required when the ClusterType parameter is specified as multi-node.
  # Default: 1
  # number_of_nodes = 2

  # (Optional) The name of the first database to be created when the cluster is created.
  # If you do not provide a name, Amazon Redshift will create a default database called dev.
  database_name = "mydb"

  # (Optional) The version of the Amazon Redshift engine software that you want to deploy.
  # The version selected runs on all the nodes in the cluster.
  # cluster_version = "1.0"

  # ============================================================
  # Networking Configuration
  # ============================================================

  # (Optional) The name of a cluster subnet group to be associated with this cluster.
  # If this parameter is not provided the resulting cluster will be deployed outside VPC.
  # cluster_subnet_group_name = "my-subnet-group"

  # (Optional) A list of Virtual Private Cloud (VPC) security groups to be associated with the cluster.
  # vpc_security_group_ids = ["sg-12345678"]

  # (Optional) The EC2 Availability Zone (AZ) in which you want Amazon Redshift to provision the cluster.
  # Can only be changed if availability_zone_relocation_enabled is true.
  # availability_zone = "us-east-1a"

  # (Optional) If true, the cluster can be relocated to another availability zone,
  # either automatically by AWS or when requested. Default is false.
  # Available for use on clusters from the RA3 instance family.
  # availability_zone_relocation_enabled = false

  # (Optional) The port number on which the cluster accepts incoming connections.
  # Valid values are between 1115 and 65535.
  # Default port is 5439.
  # port = 5439

  # (Optional) If true, the cluster can be accessed from a public network.
  # Default is false.
  # publicly_accessible = false

  # (Optional) The Elastic IP (EIP) address for the cluster.
  # elastic_ip = "203.0.113.25"

  # ============================================================
  # Security & Encryption
  # ============================================================

  # (Optional) If true, the data in the cluster is encrypted at rest.
  # Default is true.
  # encrypted = true

  # (Optional) The ARN for the KMS encryption key.
  # When specifying kms_key_id, encrypted needs to be set to true.
  # kms_key_id = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"

  # (Optional) If true, enhanced VPC routing is enabled.
  # enhanced_vpc_routing = false

  # ============================================================
  # IAM Roles
  # ============================================================

  # (Optional) A list of IAM Role ARNs to associate with the cluster.
  # A Maximum of 10 can be associated to the cluster at any time.
  # iam_roles = [
  #   "arn:aws:iam::123456789012:role/RedshiftRole1",
  #   "arn:aws:iam::123456789012:role/RedshiftRole2"
  # ]

  # (Optional) The Amazon Resource Name (ARN) for the IAM role that was set as
  # default for the cluster when the cluster was created.
  # default_iam_role_arn = "arn:aws:iam::123456789012:role/RedshiftRole1"

  # ============================================================
  # Maintenance & Updates
  # ============================================================

  # (Optional) The weekly time range (in UTC) during which automated cluster maintenance can occur.
  # Format: ddd:hh24:mi-ddd:hh24:mi
  # Example: sun:05:00-sun:06:00
  # preferred_maintenance_window = "sun:05:00-sun:06:00"

  # (Optional) The name of the parameter group to be associated with this cluster.
  # cluster_parameter_group_name = "default.redshift-1.0"

  # (Optional) If true, major version upgrades can be applied during the maintenance window.
  # Default is true.
  # allow_version_upgrade = true

  # (Optional) Specifies whether any cluster modifications are applied immediately,
  # or during the next maintenance window. Default is false.
  # apply_immediately = false

  # (Optional) The name of the maintenance track for the restored cluster.
  # Default value is current.
  # maintenance_track_name = "current"

  # ============================================================
  # Backup & Snapshot Configuration
  # ============================================================

  # (Optional) The number of days that automated snapshots are retained.
  # If the value is 0, automated snapshots are disabled.
  # Default is 1.
  # automated_snapshot_retention_period = 1

  # (Optional) The default number of days to retain a manual snapshot.
  # If the value is -1, the snapshot is retained indefinitely.
  # Valid values are between -1 and 3653. Default value is -1.
  # manual_snapshot_retention_period = -1

  # (Optional) Determines whether a final snapshot of the cluster is created
  # before Amazon Redshift deletes the cluster.
  # Default is false.
  skip_final_snapshot = true

  # (Optional) The identifier of the final snapshot that is to be created
  # immediately before deleting the cluster.
  # If this parameter is provided, skip_final_snapshot must be false.
  # final_snapshot_identifier = "my-final-snapshot"

  # ============================================================
  # Restore from Snapshot
  # ============================================================

  # (Optional) The name of the snapshot from which to create the new cluster.
  # Conflicts with snapshot_arn.
  # snapshot_identifier = "my-snapshot"

  # (Optional) The ARN of the snapshot from which to create the new cluster.
  # Conflicts with snapshot_identifier.
  # snapshot_arn = "arn:aws:redshift:us-east-1:123456789012:snapshot:cluster-name/snapshot-name"

  # (Optional) The name of the cluster the source snapshot was created from.
  # snapshot_cluster_identifier = "source-cluster"

  # (Optional) The AWS customer account used to create or copy the snapshot.
  # Required if you are restoring a snapshot you do not own, optional if you own the snapshot.
  # owner_account = "123456789012"

  # ============================================================
  # Multi-AZ Configuration
  # ============================================================

  # (Optional) Specifies if the Redshift cluster is multi-AZ.
  # multi_az = false

  # ============================================================
  # Deprecated Arguments
  # ============================================================

  # (Optional, Deprecated) The value represents how the cluster is configured
  # to use AQUA (Advanced Query Accelerator) after the cluster is restored.
  # No longer supported by the AWS API. Always returns auto.
  # aqua_configuration_status = "auto"

  # ============================================================
  # Regional Configuration
  # ============================================================

  # (Optional) Region where this resource will be managed.
  # Defaults to the Region set in the provider configuration.
  # region = "us-east-1"

  # ============================================================
  # Tags
  # ============================================================

  # (Optional) A map of tags to assign to the resource.
  tags = {
    Name        = "example-redshift-cluster"
    Environment = "development"
    ManagedBy   = "terraform"
  }
}

# ============================================================
# Timeouts Configuration
# ============================================================
# The aws_redshift_cluster resource supports the following timeouts:
#
# timeouts {
#   create = "75m"  # Default: 75 minutes
#   update = "75m"  # Default: 75 minutes
#   delete = "40m"  # Default: 40 minutes
# }

# ============================================================
# Outputs
# ============================================================

output "redshift_cluster_id" {
  description = "The Redshift Cluster ID"
  value       = aws_redshift_cluster.example.id
}

output "redshift_cluster_arn" {
  description = "Amazon Resource Name (ARN) of cluster"
  value       = aws_redshift_cluster.example.arn
}

output "redshift_cluster_endpoint" {
  description = "The connection endpoint"
  value       = aws_redshift_cluster.example.endpoint
}

output "redshift_cluster_dns_name" {
  description = "The DNS name of the cluster"
  value       = aws_redshift_cluster.example.dns_name
}

output "redshift_cluster_port" {
  description = "The Port the cluster responds on"
  value       = aws_redshift_cluster.example.port
}

output "redshift_cluster_database_name" {
  description = "The name of the default database in the Cluster"
  value       = aws_redshift_cluster.example.database_name
}

output "redshift_cluster_master_username" {
  description = "The master username for the cluster"
  value       = aws_redshift_cluster.example.master_username
  sensitive   = true
}

output "redshift_cluster_master_password_secret_arn" {
  description = "ARN of the cluster admin credentials secret (when manage_master_password is true)"
  value       = aws_redshift_cluster.example.master_password_secret_arn
}

output "redshift_cluster_availability_zone" {
  description = "The availability zone of the Cluster"
  value       = aws_redshift_cluster.example.availability_zone
}

output "redshift_cluster_encrypted" {
  description = "Whether the data in the cluster is encrypted"
  value       = aws_redshift_cluster.example.encrypted
}

output "redshift_cluster_vpc_security_group_ids" {
  description = "The VPC security group Ids associated with the cluster"
  value       = aws_redshift_cluster.example.vpc_security_group_ids
}

output "redshift_cluster_subnet_group_name" {
  description = "The name of a cluster subnet group to be associated with this cluster"
  value       = aws_redshift_cluster.example.cluster_subnet_group_name
}

output "redshift_cluster_parameter_group_name" {
  description = "The name of the parameter group to be associated with this cluster"
  value       = aws_redshift_cluster.example.cluster_parameter_group_name
}

output "redshift_cluster_public_key" {
  description = "The public key for the cluster"
  value       = aws_redshift_cluster.example.cluster_public_key
}

output "redshift_cluster_revision_number" {
  description = "The specific revision number of the database in the cluster"
  value       = aws_redshift_cluster.example.cluster_revision_number
}

output "redshift_cluster_namespace_arn" {
  description = "The namespace Amazon Resource Name (ARN) of the cluster"
  value       = aws_redshift_cluster.example.cluster_namespace_arn
}

output "redshift_cluster_nodes" {
  description = "The nodes in the cluster"
  value       = aws_redshift_cluster.example.cluster_nodes
}

# ============================================================
# Cluster Nodes Attributes (nested)
# ============================================================
# Each cluster node contains:
# - node_role: Whether the node is a leader node or a compute node
# - private_ip_address: The private IP address of a node within a cluster
# - public_ip_address: The public IP address of a node within a cluster

# ============================================================
# Common Configuration Examples
# ============================================================

# Example 1: Multi-node cluster with enhanced VPC routing
# resource "aws_redshift_cluster" "multi_node" {
#   cluster_identifier              = "multi-node-cluster"
#   database_name                   = "analytics"
#   master_username                 = "admin"
#   master_password                 = "ExamplePassword123"
#   node_type                       = "ra3.4xlarge"
#   cluster_type                    = "multi-node"
#   number_of_nodes                 = 3
#   cluster_subnet_group_name       = "my-subnet-group"
#   vpc_security_group_ids          = ["sg-12345678"]
#   enhanced_vpc_routing            = true
#   encrypted                       = true
#   kms_key_id                      = "arn:aws:kms:us-east-1:123456789012:key/12345678"
#   automated_snapshot_retention_period = 7
#   preferred_maintenance_window    = "sun:05:00-sun:06:00"
#   skip_final_snapshot             = false
#   final_snapshot_identifier       = "multi-node-final-snapshot"
#
#   tags = {
#     Name        = "analytics-cluster"
#     Environment = "production"
#   }
# }

# Example 2: Cluster with managed master password (AWS Secrets Manager)
# resource "aws_redshift_cluster" "managed_credentials" {
#   cluster_identifier                  = "managed-creds-cluster"
#   database_name                       = "mydb"
#   master_username                     = "admin"
#   node_type                           = "dc2.large"
#   cluster_type                        = "single-node"
#   manage_master_password              = true
#   master_password_secret_kms_key_id   = "arn:aws:kms:us-east-1:123456789012:key/12345678"
#   skip_final_snapshot                 = true
#
#   tags = {
#     Name = "managed-credentials-cluster"
#   }
# }

# Example 3: Cluster restored from snapshot
# resource "aws_redshift_cluster" "from_snapshot" {
#   cluster_identifier       = "restored-cluster"
#   snapshot_identifier      = "my-snapshot"
#   node_type                = "dc2.large"
#   master_username          = "admin"
#   master_password          = "ExamplePassword123"
#   skip_final_snapshot      = true
#
#   tags = {
#     Name = "restored-cluster"
#   }
# }

# Example 4: Cluster with IAM roles
# resource "aws_redshift_cluster" "with_iam_roles" {
#   cluster_identifier    = "iam-roles-cluster"
#   database_name         = "mydb"
#   master_username       = "admin"
#   master_password       = "ExamplePassword123"
#   node_type             = "dc2.large"
#   cluster_type          = "single-node"
#   skip_final_snapshot   = true
#
#   iam_roles = [
#     "arn:aws:iam::123456789012:role/RedshiftRole1",
#     "arn:aws:iam::123456789012:role/RedshiftRole2"
#   ]
#
#   default_iam_role_arn = "arn:aws:iam::123456789012:role/RedshiftRole1"
#
#   tags = {
#     Name = "iam-roles-cluster"
#   }
# }

# Example 5: Multi-AZ cluster with RA3 instance type
# resource "aws_redshift_cluster" "multi_az" {
#   cluster_identifier                  = "multi-az-cluster"
#   database_name                       = "analytics"
#   master_username                     = "admin"
#   master_password                     = "ExamplePassword123"
#   node_type                           = "ra3.xlplus"
#   cluster_type                        = "multi-node"
#   number_of_nodes                     = 2
#   multi_az                            = true
#   availability_zone_relocation_enabled = true
#   cluster_subnet_group_name           = "my-subnet-group"
#   vpc_security_group_ids              = ["sg-12345678"]
#   encrypted                           = true
#   skip_final_snapshot                 = true
#
#   tags = {
#     Name        = "multi-az-cluster"
#     Environment = "production"
#   }
# }
