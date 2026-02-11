/**
 * # aws_rds_cluster_parameter_group
 *
 * Provides an RDS DB cluster parameter group resource. Documentation of the available parameters
 * for various Aurora engines can be found at:
 *
 * * [Aurora MySQL Parameters](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/AuroraMySQL.Reference.html)
 * * [Aurora PostgreSQL Parameters](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/AuroraPostgreSQL.Reference.html)
 *
 * @reference https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/rds_cluster_parameter_group
 * @provider_version 6.28.0
 */

resource "aws_rds_cluster_parameter_group" "example" {
  # ==========================
  # Required Arguments
  # ==========================

  /**
   * (Required) The family of the DB cluster parameter group.
   *
   * @type string
   * @required
   *
   * Examples:
   * - aurora5.6
   * - aurora-mysql5.7
   * - aurora-mysql8.0
   * - aurora-postgresql10
   * - aurora-postgresql11
   * - aurora-postgresql12
   * - aurora-postgresql13
   * - aurora-postgresql14
   * - aurora-postgresql15
   */
  family = "aurora-mysql8.0"

  # ==========================
  # Optional Arguments
  # ==========================

  /**
   * (Optional, Forces new resource) The name of the DB cluster parameter group.
   * If omitted, Terraform will assign a random, unique name.
   *
   * @type string
   * @optional
   * @computed
   * @forces_new
   *
   * Conflicts with: name_prefix
   */
  name = "rds-cluster-pg"

  /**
   * (Optional, Forces new resource) Creates a unique name beginning with the specified prefix.
   * Conflicts with `name`.
   *
   * @type string
   * @optional
   * @computed
   * @forces_new
   *
   * Conflicts with: name
   */
  # name_prefix = "rds-cluster-pg-"

  /**
   * (Optional) The description of the DB cluster parameter group.
   * Defaults to "Managed by Terraform".
   *
   * @type string
   * @optional
   * @default "Managed by Terraform"
   */
  description = "RDS default cluster parameter group"

  /**
   * (Optional) Region where this resource will be managed.
   * Defaults to the Region set in the provider configuration.
   *
   * @type string
   * @optional
   * @computed
   *
   * @reference https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
   */
  # region = "us-east-1"

  /**
   * (Optional) A map of tags to assign to the resource.
   * If configured with a provider `default_tags` configuration block present,
   * tags with matching keys will overwrite those defined at the provider-level.
   *
   * @type map(string)
   * @optional
   */
  tags = {
    Name        = "rds-cluster-pg"
    Environment = "production"
  }

  # ==========================
  # Blocks
  # ==========================

  /**
   * (Optional) A list of DB parameters to apply.
   * Note that parameters may differ from a family to another.
   * Full list of all parameters can be discovered via
   * `aws rds describe-db-cluster-parameters` after initial creation of the group.
   *
   * @type set(object)
   * @optional
   *
   * @reference https://docs.aws.amazon.com/cli/latest/reference/rds/describe-db-cluster-parameters.html
   *
   * Block attributes:
   * - name (Required, string): The name of the DB parameter.
   * - value (Required, string): The value of the DB parameter.
   * - apply_method (Optional, string): "immediate" (default), or "pending-reboot".
   *   Some engines can't apply some parameters without a reboot, and you will need
   *   to specify "pending-reboot" here.
   */
  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_client"
    value = "utf8mb4"
  }

  parameter {
    name         = "max_connections"
    value        = "1000"
    apply_method = "pending-reboot"
  }

  parameter {
    name  = "slow_query_log"
    value = "1"
  }

  parameter {
    name  = "long_query_time"
    value = "2"
  }
}

# ==========================
# Outputs
# ==========================

/**
 * Available attributes for reference in other resources:
 *
 * - id (string): The db cluster parameter group name.
 * - arn (string): The ARN of the db cluster parameter group.
 * - tags_all (map(string)): A map of tags assigned to the resource, including those
 *   inherited from the provider `default_tags` configuration block.
 */

output "rds_cluster_parameter_group_id" {
  description = "The db cluster parameter group name"
  value       = aws_rds_cluster_parameter_group.example.id
}

output "rds_cluster_parameter_group_arn" {
  description = "The ARN of the db cluster parameter group"
  value       = aws_rds_cluster_parameter_group.example.arn
}

output "rds_cluster_parameter_group_tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_rds_cluster_parameter_group.example.tags_all
}

/**
 * ==========================
 * Additional Notes
 * ==========================
 *
 * 1. Parameter Group Family:
 *    - The family must match the DB cluster engine and version you're using
 *    - Common families include aurora5.6, aurora-mysql5.7, aurora-mysql8.0,
 *      aurora-postgresql10, aurora-postgresql11, etc.
 *
 * 2. Parameter Application:
 *    - Some parameters require a reboot to take effect (apply_method = "pending-reboot")
 *    - Use `aws rds describe-db-cluster-parameters` to see which parameters require reboot
 *    - Parameters with apply_method = "immediate" can be applied without restarting the cluster
 *
 * 3. Parameter Discovery:
 *    - To find available parameters for your engine:
 *      aws rds describe-db-cluster-parameters \
 *        --db-cluster-parameter-group-name <group-name>
 *
 * 4. Common Parameters:
 *    Aurora MySQL:
 *    - character_set_server, character_set_client, character_set_database
 *    - max_connections, innodb_buffer_pool_size
 *    - slow_query_log, long_query_time
 *    - binlog_format, server_audit_logging
 *
 *    Aurora PostgreSQL:
 *    - shared_buffers, max_connections
 *    - work_mem, maintenance_work_mem
 *    - log_statement, log_min_duration_statement
 *    - rds.force_ssl
 *
 * 5. Naming Considerations:
 *    - Use either name or name_prefix, not both
 *    - Changing the name forces creation of a new resource
 *    - Parameter group names must be lowercase
 *
 * 6. Best Practices:
 *    - Test parameter changes in non-production environments first
 *    - Monitor cluster performance after applying parameter changes
 *    - Document why specific parameters were set
 *    - Use version control to track parameter group changes over time
 *    - Consider using separate parameter groups for different environments
 *
 * 7. Resource Dependencies:
 *    - This parameter group can be referenced by aws_rds_cluster resources
 *    - Example:
 *      resource "aws_rds_cluster" "example" {
 *        db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.example.name
 *        ...
 *      }
 *
 * 8. Modification Impact:
 *    - Modifying parameters with apply_method = "immediate" will apply changes immediately
 *    - Modifying parameters with apply_method = "pending-reboot" will require a maintenance window
 *    - Changes to family or name will force replacement of the parameter group
 */
