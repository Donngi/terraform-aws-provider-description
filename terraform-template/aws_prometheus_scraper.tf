################################################################################
# AWS Prometheus Scraper
# https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/prometheus_scraper
################################################################################

# Note: If you change a Scraper's source (EKS cluster), Terraform will delete
# the current Scraper and create a new one.
#
# Provides an Amazon Managed Service for Prometheus fully managed collector
# (scraper).
#
# Read more: https://docs.aws.amazon.com/prometheus/latest/userguide/AMP-collector.html

resource "aws_prometheus_scraper" "example" {
  # ============================================================================
  # Required Arguments
  # ============================================================================

  # scrape_configuration - (Required) The configuration file to use in the new
  # scraper. This should be a YAML-formatted string containing Prometheus scrape
  # configuration.
  # More information: https://docs.aws.amazon.com/prometheus/latest/userguide/AMP-collector-how-to.html#AMP-collector-configuration
  scrape_configuration = <<EOT
global:
  scrape_interval: 30s
scrape_configs:
  # pod metrics
  - job_name: pod_exporter
    kubernetes_sd_configs:
      - role: pod
  # container metrics
  - job_name: cadvisor
    scheme: https
    authorization:
      credentials_file: /var/run/secrets/kubernetes.io/serviceaccount/token
    kubernetes_sd_configs:
      - role: node
    relabel_configs:
      - action: labelmap
        regex: __meta_kubernetes_node_label_(.+)
      - replacement: kubernetes.default.svc:443
        target_label: __address__
      - source_labels: [__meta_kubernetes_node_name]
        regex: (.+)
        target_label: __metrics_path__
        replacement: /api/v1/nodes/$1/proxy/metrics/cadvisor
EOT

  # destination - (Required) Configuration block for the managed scraper to send
  # metrics to.
  destination {
    # amp - (Required) Configuration block for an Amazon Managed Prometheus
    # workspace destination.
    amp {
      # workspace_arn - (Required) The Amazon Resource Name (ARN) of the
      # prometheus workspace.
      workspace_arn = aws_prometheus_workspace.example.arn
    }
  }

  # source - (Required) Configuration block to specify where the managed scraper
  # will collect metrics from.
  source {
    # eks - (Required) Configuration block for an EKS cluster source.
    eks {
      # cluster_arn - (Required) The Amazon Resource Name (ARN) of the source
      # EKS cluster.
      cluster_arn = data.aws_eks_cluster.example.arn

      # subnet_ids - (Required) List of subnet IDs. Must be in at least two
      # different availability zones.
      subnet_ids = data.aws_eks_cluster.example.vpc_config[0].subnet_ids

      # security_group_ids - (Optional) List of the security group IDs for the
      # Amazon EKS cluster VPC configuration.
      # Type: set of strings
      # Computed: true (if not specified)
      # security_group_ids = ["sg-12345678"]
    }
  }

  # ============================================================================
  # Optional Arguments
  # ============================================================================

  # alias - (Optional) A name to associate with the managed scraper. This is for
  # your use, and does not need to be unique.
  # Type: string
  # alias = "my-prometheus-scraper"

  # region - (Optional) Region where this resource will be managed.
  # Defaults to the Region set in the provider configuration.
  # Type: string
  # Computed: true (if not specified)
  # region = "us-west-2"

  # role_configuration - (Optional) Configuration block to enable writing to an
  # Amazon Managed Service for Prometheus workspace in a different account.
  # This is used for cross-account configurations.
  # role_configuration {
  #   # source_role_arn - (Optional) The Amazon Resource Name (ARN) of the
  #   # source role configuration. Must be an IAM role ARN.
  #   # Type: string
  #   source_role_arn = aws_iam_role.source.arn
  #
  #   # target_role_arn - (Optional) The Amazon Resource Name (ARN) of the
  #   # target role configuration. Must be an IAM role ARN.
  #   # Type: string
  #   target_role_arn = "arn:aws:iam::123456789012:role/target-role-name"
  # }

  # tags - (Optional) A map of tags to assign to the resource.
  # Type: map of strings
  # tags = {
  #   Environment = "production"
  #   Name        = "example-scraper"
  # }

  # ============================================================================
  # Timeouts
  # ============================================================================

  # timeouts {
  #   # create - (Optional) How long to wait for the scraper to be created.
  #   # Valid time units are "s" (seconds), "m" (minutes), "h" (hours).
  #   # Default: varies by AWS service
  #   create = "10m"
  #
  #   # update - (Optional) How long to wait for the scraper to be updated.
  #   # Valid time units are "s" (seconds), "m" (minutes), "h" (hours).
  #   # Default: varies by AWS service
  #   update = "10m"
  #
  #   # delete - (Optional) How long to wait for the scraper to be deleted.
  #   # Valid time units are "s" (seconds), "m" (minutes), "h" (hours).
  #   # Default: varies by AWS service
  #   delete = "10m"
  # }
}

################################################################################
# Computed Attributes Reference
################################################################################

# In addition to all arguments above, the following attributes are exported:

# arn - The Amazon Resource Name (ARN) of the new scraper.
# Example: output "scraper_arn" {
#   value = aws_prometheus_scraper.example.arn
# }

# role_arn - The Amazon Resource Name (ARN) of the IAM role that provides
# permissions for the scraper to discover, collect, and produce metrics.
# Example: output "scraper_role_arn" {
#   value = aws_prometheus_scraper.example.role_arn
# }

# id - The ID of the scraper (same as ARN).
# Example: output "scraper_id" {
#   value = aws_prometheus_scraper.example.id
# }

# tags_all - A map of tags assigned to the resource, including those inherited
# from the provider default_tags configuration block.
# Example: output "all_tags" {
#   value = aws_prometheus_scraper.example.tags_all
# }

################################################################################
# Additional Examples
################################################################################

# Example: Use default EKS scraper configuration
# data "aws_prometheus_default_scraper_configuration" "example" {}
#
# resource "aws_prometheus_scraper" "with_default_config" {
#   scrape_configuration = data.aws_prometheus_default_scraper_configuration.example.configuration
#
#   destination {
#     amp {
#       workspace_arn = aws_prometheus_workspace.example.arn
#     }
#   }
#
#   source {
#     eks {
#       cluster_arn = data.aws_eks_cluster.example.arn
#       subnet_ids  = data.aws_eks_cluster.example.vpc_config[0].subnet_ids
#     }
#   }
# }

# Example: Cross-Account Configuration
# resource "aws_prometheus_scraper" "cross_account" {
#   scrape_configuration = "..."
#
#   destination {
#     amp {
#       workspace_arn = "arn:aws:aps:us-west-2:123456789012:workspace/ws-12345678"
#     }
#   }
#
#   source {
#     eks {
#       cluster_arn = data.aws_eks_cluster.example.arn
#       subnet_ids  = data.aws_eks_cluster.example.vpc_config[0].subnet_ids
#     }
#   }
#
#   role_configuration {
#     source_role_arn = aws_iam_role.source.arn
#     target_role_arn = "arn:aws:iam::123456789012:role/target-role-name"
#   }
# }

################################################################################
# Important Notes
################################################################################

# 1. Source Changes: If you change a Scraper's source (EKS cluster), Terraform
#    will delete the current Scraper and create a new one.
#
# 2. Subnet Requirements: subnet_ids must include subnets in at least two
#    different availability zones.
#
# 3. Scrape Configuration: The scrape_configuration must be valid YAML in
#    Prometheus format. Use the aws_prometheus_default_scraper_configuration
#    data source for a default configuration.
#
# 4. Cross-Account Access: Use role_configuration when writing metrics to a
#    workspace in a different AWS account.
#
# 5. Status Values: The status attribute can be one of:
#    - ACTIVE
#    - CREATING
#    - DELETING
#    - CREATION_FAILED
#    - DELETION_FAILED
