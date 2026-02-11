##############################################################################
# Resource: aws_route53recoverycontrolconfig_routing_control
#
# AWS Route 53 Application Recovery Controller (ARC) Routing Control
#
# Overview:
# - An on/off switch that controls traffic routing to application cells
# - Integrated with Route 53 health checks for multi-region failover
# - Part of Application Recovery Controller for disaster recovery
# - Supports both active-passive and active-active architectures
# - Enables manual override for maintenance or recovery operations
#
# Key Concepts:
# - Routing controls are hosted on ARC clusters (5 redundant endpoints)
# - Controls are grouped in control panels for organization
# - State (ON/OFF) determines whether traffic flows to a cell
# - Works with Route 53 DNS failover records for traffic redirection
# - Can be protected by safety rules to prevent accidental misconfigurations
#
# Use Cases:
# - Disaster recovery failover across AWS Regions
# - Planned maintenance traffic shifts
# - Application traffic management for multi-AZ deployments
# - Coordinated recovery for large-scale applications
# - Manual override during incidents or testing
#
# Related Resources:
# - aws_route53recoverycontrolconfig_cluster (required parent)
# - aws_route53recoverycontrolconfig_control_panel (optional grouping)
# - aws_route53recoverycontrolconfig_safety_rule (optional protection)
# - aws_route53_health_check (for routing control integration)
#
# Provider Version: 6.28.0
# Documentation: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/route53recoverycontrolconfig_routing_control
##############################################################################

resource "aws_route53recoverycontrolconfig_routing_control" "example" {
  ##############################################################################
  # Required Arguments
  ##############################################################################

  # Name of the routing control
  # - Must be unique within the control panel
  # - Descriptive name for the cell or traffic destination this control manages
  # - Typically includes region or AZ identifier (e.g., "us-east-1-cell")
  # - Used in operations and monitoring
  # - Cannot be changed after creation (forces replacement)
  name = "us-east-1-primary-cell"

  # ARN of the cluster hosting this routing control
  # - Must reference an existing Route 53 ARC cluster
  # - Cluster provides 5 redundant regional endpoints for API calls
  # - All routing controls in a cluster share the same data plane
  # - Format: arn:aws:route53-recovery-control::ACCOUNT-ID:cluster/CLUSTER-ID
  # - Cannot be changed after creation (forces replacement)
  # Example: "arn:aws:route53-recovery-control::123456789012:cluster/8d47920e-d789-437d-803a-2dcc4b204393"
  cluster_arn = "arn:aws:route53-recovery-control::123456789012:cluster/YOUR-CLUSTER-ID"

  ##############################################################################
  # Optional Arguments
  ##############################################################################

  # ARN of the control panel for organizing routing controls
  # - If not specified, routing control is added to the default control panel
  # - Control panels group related routing controls together
  # - Enables centralized management and safety rule application
  # - Recommended for complex multi-region architectures
  # - Format: arn:aws:route53-recovery-control::ACCOUNT-ID:controlpanel/PANEL-ID
  # - Cannot be changed after creation (forces replacement)
  # Example: "arn:aws:route53-recovery-control::123456789012:controlpanel/abd5fbfc052d4844a082dbf400f61da8"
  control_panel_arn = null # Optional, defaults to default control panel

  ##############################################################################
  # Read-Only Attributes (Exported)
  ##############################################################################

  # arn - ARN of the routing control
  # - Unique identifier for this routing control
  # - Used in Route 53 health checks and IAM policies
  # - Required for UpdateRoutingControlState API calls
  # - Format: arn:aws:route53-recovery-control::ACCOUNT-ID:controlpanel/PANEL-ID/routingcontrol/CONTROL-ID
  #
  # status - Deployment status of the routing control
  # - PENDING: Being created or updated
  # - PENDING_DELETION: Being deleted
  # - DEPLOYED: Successfully deployed and operational
  # - Check this before making state updates
}

##############################################################################
# Example: Basic Routing Control
##############################################################################

# Create a simple routing control in the default control panel
resource "aws_route53recoverycontrolconfig_routing_control" "basic" {
  name        = "primary-region-control"
  cluster_arn = "arn:aws:route53-recovery-control::123456789012:cluster/YOUR-CLUSTER-ID"
}

##############################################################################
# Example: Routing Control with Custom Control Panel
##############################################################################

# Create a routing control in a specific control panel for better organization
resource "aws_route53recoverycontrolconfig_routing_control" "with_panel" {
  name              = "us-west-2-secondary-cell"
  cluster_arn       = "arn:aws:route53-recovery-control::123456789012:cluster/YOUR-CLUSTER-ID"
  control_panel_arn = "arn:aws:route53-recovery-control::123456789012:controlpanel/YOUR-PANEL-ID"
}

##############################################################################
# Example: Multi-Region Active-Passive Setup
##############################################################################

# Primary region routing control (typically starts ON)
resource "aws_route53recoverycontrolconfig_routing_control" "primary_region" {
  name              = "us-east-1-primary"
  cluster_arn       = var.arc_cluster_arn
  control_panel_arn = var.arc_control_panel_arn
}

# Secondary region routing control (typically starts OFF)
resource "aws_route53recoverycontrolconfig_routing_control" "secondary_region" {
  name              = "us-west-2-secondary"
  cluster_arn       = var.arc_cluster_arn
  control_panel_arn = var.arc_control_panel_arn
}

##############################################################################
# Example: Multi-AZ Cell Controls
##############################################################################

# Routing control for AZ-a cell
resource "aws_route53recoverycontrolconfig_routing_control" "cell_az_a" {
  name              = "application-cell-az-a"
  cluster_arn       = var.arc_cluster_arn
  control_panel_arn = var.arc_control_panel_arn
}

# Routing control for AZ-b cell
resource "aws_route53recoverycontrolconfig_routing_control" "cell_az_b" {
  name              = "application-cell-az-b"
  cluster_arn       = var.arc_cluster_arn
  control_panel_arn = var.arc_control_panel_arn
}

# Routing control for AZ-c cell
resource "aws_route53recoverycontrolconfig_routing_control" "cell_az_c" {
  name              = "application-cell-az-c"
  cluster_arn       = var.arc_cluster_arn
  control_panel_arn = var.arc_control_panel_arn
}

##############################################################################
# Example: Outputs for Integration
##############################################################################

# Export routing control ARN for use in Route 53 health checks
output "routing_control_arn" {
  description = "ARN of the routing control for Route 53 health check integration"
  value       = aws_route53recoverycontrolconfig_routing_control.example.arn
}

# Export routing control status
output "routing_control_status" {
  description = "Deployment status of the routing control"
  value       = aws_route53recoverycontrolconfig_routing_control.example.status
}

##############################################################################
# Important Notes and Best Practices
##############################################################################

# 1. CLUSTER DEPENDENCY
#    - Always create the ARC cluster before routing controls
#    - Use depends_on if needed to enforce creation order
#    - Cluster ARN cannot be changed after control creation

# 2. NAMING STRATEGY
#    - Use descriptive names indicating region/AZ/cell
#    - Keep names unique within each control panel
#    - Consider naming conventions for large deployments
#    - Names cannot be changed (forces resource replacement)

# 3. CONTROL PANEL ORGANIZATION
#    - Group related routing controls in control panels
#    - Use separate panels for different applications/environments
#    - Default panel is created automatically with cluster
#    - Recommended for complex multi-region setups

# 4. INITIAL STATE
#    - Routing controls are created in OFF state by default
#    - Use AWS CLI/SDK/Console to set initial state after creation
#    - Initial state cannot be set via Terraform during creation
#    - Plan your initial traffic routing before deployment

# 5. STATE MANAGEMENT
#    - Terraform creates/deletes routing controls only
#    - State updates (ON/OFF) must be done outside Terraform
#    - Use UpdateRoutingControlState API for state changes
#    - Connect to cluster endpoints to update states

# 6. SAFETY RULES
#    - Create safety rules separately to protect routing controls
#    - Assertion rules ensure minimum healthy controls
#    - Gating rules prevent simultaneous state changes
#    - Protects against accidental misconfigurations

# 7. ROUTE 53 INTEGRATION
#    - Create Route 53 health checks referencing routing control ARN
#    - Associate health checks with DNS failover records
#    - Health check follows routing control state (ON=healthy, OFF=unhealthy)
#    - Use for automated DNS-based traffic shifting

# 8. HIGH AVAILABILITY
#    - ARC clusters have 5 redundant endpoints across regions
#    - Use cluster endpoints for state update API calls
#    - Cluster is independent of any specific AWS region
#    - Survives regional failures for disaster recovery

# 9. IAM PERMISSIONS
#    - Requires route53-recovery-control-config:* permissions for creation
#    - Requires route53-recovery-cluster:* for state updates
#    - Use least privilege for production deployments
#    - Separate permissions for control plane vs data plane operations

# 10. MONITORING AND OPERATIONS
#     - Monitor routing control state changes via CloudWatch Events
#     - Track state transitions for audit and compliance
#     - Use control panel for grouped visibility
#     - Test failover procedures regularly

# 11. DELETION CONSIDERATIONS
#     - Cannot delete routing control with active safety rules
#     - Remove from control panel associations first
#     - Check for Route 53 health check dependencies
#     - Status changes to PENDING_DELETION during deletion

# 12. MULTI-REGION STRATEGY
#     - Design for active-passive or active-active architectures
#     - Create routing controls for each traffic destination
#     - Coordinate with Route 53 DNS records in multiple regions
#     - Plan failover sequences and testing procedures

# 13. COST CONSIDERATIONS
#     - Charged per routing control per month
#     - Cluster has separate charges
#     - No charge for state update API calls
#     - Consider consolidation for cost optimization

# 14. LIMITS AND QUOTAS
#     - Default: 1000 routing controls per cluster
#     - Default: 500 routing controls per control panel
#     - Request quota increases via AWS Support if needed
#     - Plan capacity for large-scale deployments

##############################################################################
# Common Patterns and Anti-Patterns
##############################################################################

# PATTERN: Active-Passive with Safety Rules
# - Create two routing controls (primary ON, secondary OFF)
# - Add assertion rule requiring at least one ON
# - Prevents both regions from being OFF simultaneously
# - Recommended for critical production workloads

# PATTERN: Gradual Traffic Shift
# - Use multiple routing controls for weighted routing
# - Combine with Route 53 weighted routing policies
# - Enable canary deployments and gradual failover
# - Provides fine-grained traffic control

# ANTI-PATTERN: Managing State in Terraform
# - Routing control state cannot be managed in Terraform
# - Do not try to use lifecycle rules for state management
# - Use separate automation for state updates
# - Keep infrastructure (Terraform) separate from operations (state changes)

# ANTI-PATTERN: Single Region Dependency
# - Do not create routing controls in only one region
# - Always plan for multi-region architecture
# - Consider Availability Zone isolation
# - Design for regional failure scenarios

##############################################################################
# Related AWS Services Integration
##############################################################################

# Integration with Route 53 Health Checks:
# resource "aws_route53_health_check" "routing_control" {
#   type                   = "RECOVERY_CONTROL"
#   routing_control_arn    = aws_route53recoverycontrolconfig_routing_control.example.arn
#   cloudwatch_alarm_name  = "routing-control-alarm"
# }

# Integration with Route 53 DNS Records:
# resource "aws_route53_record" "failover_primary" {
#   zone_id = aws_route53_zone.main.zone_id
#   name    = "app.example.com"
#   type    = "A"
#
#   set_identifier = "primary"
#   failover_routing_policy {
#     type = "PRIMARY"
#   }
#
#   health_check_id = aws_route53_health_check.routing_control.id
#
#   alias {
#     name                   = aws_lb.primary.dns_name
#     zone_id                = aws_lb.primary.zone_id
#     evaluate_target_health = false
#   }
# }

##############################################################################
# References and Additional Resources
##############################################################################

# AWS Documentation:
# - Route 53 ARC Overview: https://aws.amazon.com/route53/application-recovery-controller/
# - Routing Control Guide: https://docs.aws.amazon.com/r53recovery/latest/dg/routing-control.html
# - API Reference: https://docs.aws.amazon.com/recovery-cluster/latest/api/
# - Best Practices: https://docs.aws.amazon.com/r53recovery/latest/dg/routing-control.best-practices.html

# Terraform Provider Documentation:
# - Resource: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/route53recoverycontrolconfig_routing_control
# - Cluster Resource: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53recoverycontrolconfig_cluster
# - Control Panel: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53recoverycontrolconfig_control_panel
# - Safety Rules: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53recoverycontrolconfig_safety_rule

##############################################################################
