# ================================================================================
# AWS Location Service - Geofence Collection
# ================================================================================
# Resource: aws_location_geofence_collection
# Provider Version: 6.28.0
# Generated: 2026-01-31
# ================================================================================
#
# OVERVIEW:
#   Amazon Location Service Geofence Collection is a resource that manages
#   virtual geographic boundaries (geofences) on a map. A geofence collection
#   can contain up to 50,000 geofences and emits entry/exit events when device
#   positions are evaluated against the geofences in the collection.
#
# USE CASES:
#   - Fleet tracking: Monitor when vehicles enter/exit designated areas
#   - Location-based notifications: Alert users when they enter specific zones
#   - Asset management: Track critical assets and trigger actions based on location
#   - Supply chain visibility: Monitor shipment locations across geofenced areas
#   - Safety and security: Detect when devices enter restricted or dangerous zones
#
# BILLING:
#   - You are billed based on the number of geofence collections evaluated,
#     not the number of geofences within each collection
#   - Consolidating geofences into fewer collections can reduce costs
#   - Each collection can contain up to 50,000 geofences
#
# REGIONAL AVAILABILITY:
#   Amazon Location Service is available in multiple AWS regions including
#   us-east-1, us-west-2, eu-west-1, ap-southeast-1, and others.
#
# REFERENCES:
#   - Terraform AWS Provider Documentation:
#     https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/location_geofence_collection
#   - AWS Documentation - Geofence Concepts:
#     https://docs.aws.amazon.com/location/latest/developerguide/geofence-components.html
#   - AWS Documentation - Getting Started with Geofences:
#     https://docs.aws.amazon.com/location/latest/developerguide/geofence-gs.html
#   - AWS API Reference - CreateGeofenceCollection:
#     https://docs.aws.amazon.com/location/latest/APIReference/API_CreateGeofenceCollection.html
#
# ================================================================================

# ================================================================================
# BASIC EXAMPLE - Minimal Configuration
# ================================================================================
# This example creates a geofence collection with only the required parameter.
# Suitable for development environments or simple geofencing use cases.
# ================================================================================

resource "aws_location_geofence_collection" "basic" {
  # REQUIRED: Unique name for the geofence collection
  # - Must be alphanumeric with no spaces
  # - Must be unique within your AWS account and region
  # - Used as the primary identifier for the collection
  collection_name = "basic-geofence-collection"
}

# ================================================================================
# STANDARD EXAMPLE - Production Configuration
# ================================================================================
# This example demonstrates a production-ready geofence collection with:
# - Descriptive metadata for documentation
# - KMS encryption for data at rest
# - Resource tagging for organization and cost tracking
# - Explicit region specification (optional)
# ================================================================================

resource "aws_location_geofence_collection" "production" {
  # ================================================================================
  # REQUIRED PARAMETERS
  # ================================================================================

  # collection_name (string, REQUIRED)
  #   The name of the geofence collection
  #   - Must be 1-100 characters
  #   - Alphanumeric characters, hyphens, periods, and underscores only
  #   - Cannot contain spaces
  #   - Must be unique within your AWS account and region
  #   Example: "warehouse-geofences", "delivery-zones", "restricted-areas"
  collection_name = "production-geofence-collection"

  # ================================================================================
  # OPTIONAL PARAMETERS
  # ================================================================================

  # description (string, optional)
  #   Human-readable description for the geofence collection
  #   - Maximum 1000 characters
  #   - Helps document the purpose and usage of the collection
  #   - Best practice: Include information about what geofences are in the collection
  #   Example: "Geofences for warehouse delivery zones in North America"
  description = "Production geofence collection for fleet tracking and zone monitoring"

  # kms_key_id (string, optional)
  #   AWS KMS customer managed key identifier for encryption at rest
  #   - Can be a key ID, key ARN, alias name, or alias ARN
  #   - If not specified, AWS uses a service-owned key for encryption
  #   - Recommended for compliance and security requirements
  #   - The key must be in the same region as the geofence collection
  #   - Ensure the key policy allows Amazon Location Service to use the key
  #   Example: "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
  #   Example: "alias/my-location-key"
  kms_key_id = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"

  # region (string, optional, computed)
  #   Region where this resource will be managed
  #   - Defaults to the region set in the provider configuration
  #   - Use this to explicitly specify a region different from the provider
  #   - Changes to this value will force resource replacement
  #   - Geofence collections are regional resources
  #   Example: "us-east-1", "eu-west-1", "ap-southeast-1"
  # region = "us-east-1"  # Uncomment if you need to override provider region

  # tags (map of strings, optional)
  #   Key-value tags for resource organization and cost tracking
  #   - Maximum 50 tags per resource
  #   - Tag keys must be 1-128 characters
  #   - Tag values must be 0-256 characters
  #   - Tags are case-sensitive
  #   - If configured with provider default_tags, matching keys will be overwritten
  #   - Best practices:
  #     * Include Environment (dev, staging, prod)
  #     * Include Owner or Team
  #     * Include Purpose or Application
  #     * Include Cost Center for billing
  tags = {
    Name        = "Production Geofence Collection"
    Environment = "production"
    Team        = "logistics"
    Purpose     = "fleet-tracking"
    CostCenter  = "operations"
    ManagedBy   = "terraform"
  }

  # ================================================================================
  # TIMEOUTS BLOCK (optional)
  # ================================================================================
  # Configure operation timeout values
  # Useful for large deployments or when working with rate-limited APIs
  # ================================================================================

  timeouts {
    # create (string, optional)
    #   Timeout for creating the geofence collection
    #   Default: 30 minutes if not specified
    #   Format: "60m", "1h", "90s"
    create = "30m"

    # update (string, optional)
    #   Timeout for updating the geofence collection
    #   Default: 30 minutes if not specified
    #   Format: "60m", "1h", "90s"
    update = "30m"

    # delete (string, optional)
    #   Timeout for deleting the geofence collection
    #   Default: 30 minutes if not specified
    #   Format: "60m", "1h", "90s"
    delete = "30m"
  }
}

# ================================================================================
# COMPUTED ATTRIBUTES (outputs available after apply)
# ================================================================================
# These attributes are computed by AWS and available after resource creation.
# They cannot be set in the configuration but can be referenced in outputs
# or other resources.
# ================================================================================

# collection_arn (string, computed)
#   The Amazon Resource Name (ARN) for the geofence collection
#   - Format: arn:aws:geo:region:account-id:geofence-collection/collection-name
#   - Used when referencing the resource across AWS services
#   - Used in IAM policies and resource-based policies
#   Example: aws_location_geofence_collection.production.collection_arn

# create_time (string, computed)
#   The timestamp when the geofence collection was created
#   - Format: ISO 8601 timestamp (e.g., "2024-01-15T10:30:00Z")
#   - Automatically set by AWS upon creation
#   - Useful for auditing and lifecycle management
#   Example: aws_location_geofence_collection.production.create_time

# update_time (string, computed)
#   The timestamp when the geofence collection was last updated
#   - Format: ISO 8601 timestamp (e.g., "2024-01-20T14:45:00Z")
#   - Updated automatically by AWS when collection properties change
#   - Useful for change tracking and auditing
#   Example: aws_location_geofence_collection.production.update_time

# id (string, optional, computed)
#   Terraform resource identifier
#   - Defaults to the collection_name value
#   - Can be used for import operations
#   - Used by Terraform for state management
#   Example: aws_location_geofence_collection.production.id

# tags_all (map of strings, optional, computed)
#   All tags including those from provider default_tags
#   - Merges resource-specific tags with provider default_tags
#   - Reflects the actual tags applied to the AWS resource
#   - Read-only attribute managed by Terraform
#   Example: aws_location_geofence_collection.production.tags_all

# ================================================================================
# USAGE EXAMPLES
# ================================================================================

# Example 1: Output the collection ARN for use in other resources
output "geofence_collection_arn" {
  description = "ARN of the geofence collection"
  value       = aws_location_geofence_collection.production.collection_arn
}

# Example 2: Output creation timestamp for auditing
output "geofence_collection_created" {
  description = "When the geofence collection was created"
  value       = aws_location_geofence_collection.production.create_time
}

# Example 3: Reference in IAM policy
# resource "aws_iam_policy" "geofence_access" {
#   name = "geofence-collection-access"
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Action = [
#           "geo:BatchPutGeofence",
#           "geo:BatchDeleteGeofence",
#           "geo:BatchEvaluateGeofences"
#         ]
#         Resource = aws_location_geofence_collection.production.collection_arn
#       }
#     ]
#   })
# }

# ================================================================================
# ADVANCED EXAMPLE - Fleet Tracking Use Case
# ================================================================================
# This example demonstrates a complete fleet tracking solution with:
# - Multiple geofence collections for different purposes
# - Integration with EventBridge for event processing
# - Proper encryption and tagging
# ================================================================================

resource "aws_location_geofence_collection" "warehouses" {
  collection_name = "fleet-warehouse-zones"
  description     = "Geofences for all warehouse delivery zones - triggers entry/exit notifications"
  kms_key_id      = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"

  tags = {
    Name        = "Warehouse Geofences"
    Environment = "production"
    UseCase     = "fleet-tracking"
    EventType   = "delivery-zone"
  }
}

resource "aws_location_geofence_collection" "restricted_areas" {
  collection_name = "fleet-restricted-areas"
  description     = "Geofences for restricted or dangerous zones - triggers safety alerts"
  kms_key_id      = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"

  tags = {
    Name        = "Restricted Area Geofences"
    Environment = "production"
    UseCase     = "safety-monitoring"
    EventType   = "security-alert"
    Priority    = "high"
  }
}

# ================================================================================
# INTEGRATION PATTERNS
# ================================================================================

# Pattern 1: EventBridge Integration
# Geofence collections automatically emit events to EventBridge when devices
# enter or exit geofences. Create EventBridge rules to process these events:
#
# - ENTER events: Triggered when a device enters a geofence
# - EXIT events: Triggered when a device exits a geofence
#
# Event pattern example:
# {
#   "source": ["aws.geo"],
#   "detail-type": ["Location Geofence Event"],
#   "detail": {
#     "EventType": ["ENTER", "EXIT"],
#     "GeofenceId": ["warehouse-123"]
#   }
# }

# Pattern 2: Device State Management
# Amazon Location Service maintains device state for 30 days to determine
# entry/exit events. Previous position data is used to determine if a device
# has crossed a geofence boundary.

# Pattern 3: Batch Operations
# Use batch APIs for efficient geofence management:
# - BatchPutGeofence: Add multiple geofences at once (up to 10 per request)
# - BatchDeleteGeofence: Remove multiple geofences at once (up to 10 per request)
# - BatchEvaluateGeofences: Evaluate multiple positions at once (up to 10 per request)

# ================================================================================
# IMPORTANT NOTES AND BEST PRACTICES
# ================================================================================
#
# COLLECTION LIMITS:
#   - Maximum 100 geofence collections per AWS account per region
#   - Maximum 50,000 geofences per collection
#   - Consolidate geofences into fewer collections to reduce evaluation costs
#
# GEOFENCE GEOMETRY:
#   - Supported types: Circle, Polygon, MultiPolygon
#   - Circles: Defined by center point and radius (useful for proximity alerts)
#   - Polygons: Defined by list of coordinates (useful for precise boundaries)
#   - MultiPolygons: Multiple polygon areas (useful for complex boundaries)
#
# EVENT GENERATION:
#   - Events are only generated when boundaries are crossed (entry/exit)
#   - NOT generated for every position update
#   - Device state is maintained for 30 days
#   - Requires explicit evaluation via API calls or tracker integration
#
# SECURITY:
#   - Use KMS customer managed keys for encryption at rest
#   - Configure appropriate IAM policies for access control
#   - Use resource-based policies for cross-account access
#   - Enable CloudTrail logging for audit trails
#
# COST OPTIMIZATION:
#   - Billed per collection evaluated, not per geofence
#   - Combine related geofences into single collections
#   - Maximum 50,000 geofences per collection allows significant consolidation
#   - Use batch operations to reduce API call costs
#
# MONITORING:
#   - CloudWatch metrics track evaluation requests and errors
#   - EventBridge receives all geofence events (ENTER/EXIT)
#   - CloudTrail logs all API operations
#   - Set up alerts for failed evaluations
#
# DELETION CONSIDERATIONS:
#   - Deleting a collection deletes all geofences within it
#   - Cannot be recovered after deletion
#   - Remove collection from active trackers before deletion
#   - Consider lifecycle policies for unused collections
#
# TAGGING STRATEGY:
#   - Use consistent tag keys across all Location Service resources
#   - Include environment, owner, purpose, and cost center
#   - Leverage default_tags in provider configuration
#   - Use tags for cost allocation reports
#
# REGIONAL DEPLOYMENT:
#   - Geofence collections are regional resources
#   - Deploy in regions closest to your users for lower latency
#   - Consider multi-region deployment for disaster recovery
#   - Replicate critical geofences across regions if needed
#
# ================================================================================
