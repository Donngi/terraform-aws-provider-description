################################################################################
# AWS Location Tracker Association
################################################################################
# Terraform resource for managing an AWS Location Tracker Association.
#
# This resource links a tracker resource to a geofence collection, enabling
# automatic evaluation of location updates against geofences in the collection.
# When a device position falls within or exits a geofence, an event is generated
# in Amazon EventBridge.
#
# Key Features:
# - Associates a geofence collection with a tracker resource
# - Enables automatic geofence evaluation for position updates
# - Generates ENTER and EXIT events for EventBridge integration
# - Supports up to 5 geofence collections per tracker resource
#
# Common Use Cases:
# - Automatic geofence monitoring for tracked devices
# - Location-based alerting and notifications
# - Fleet management and asset tracking
# - Supply chain visibility with geofence events
#
# AWS Documentation:
# https://docs.aws.amazon.com/location/latest/developerguide/associate-consumer.html
# https://docs.aws.amazon.com/location/latest/APIReference/API_WaypointTracking_AssociateTrackerConsumer.html
#
# Terraform AWS Provider Documentation:
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/location_tracker_association
#
# Last Updated: 2025-01-31
################################################################################

# Example: Basic tracker association with geofence collection
resource "aws_location_tracker_association" "example" {
  # REQUIRED: The name of the tracker resource to be associated with a geofence collection
  # This must reference an existing Amazon Location Service tracker
  # The tracker receives position updates from devices and evaluates them against
  # geofences in the associated collection
  tracker_name = aws_location_tracker.example.tracker_name

  # REQUIRED: The Amazon Resource Name (ARN) for the geofence collection
  # This specifies which geofence collection should receive position updates
  # from the tracker for automatic evaluation
  # Format: arn:aws:geo:region:account-id:geofence-collection/collection-name
  consumer_arn = aws_location_geofence_collection.example.collection_arn

  # OPTIONAL: AWS Region where this resource will be managed
  # If not specified, defaults to the region set in the provider configuration
  # Useful for multi-region deployments or cross-region resource management
  # region = "us-east-1"

  # OPTIONAL: Timeouts configuration for resource operations
  # Customize timeout values for create and delete operations
  # timeouts {
  #   # Maximum time to wait for association creation
  #   # Default: 30 minutes
  #   create = "30m"
  #
  #   # Maximum time to wait for association deletion
  #   # Default: 30 minutes
  #   delete = "30m"
  # }
}

################################################################################
# Supporting Resources (for reference)
################################################################################

# Example geofence collection that will be associated with the tracker
resource "aws_location_geofence_collection" "example" {
  collection_name = "example-geofence-collection"
  description     = "Example geofence collection for tracker association"

  # Optional: KMS key for encryption
  # kms_key_id = aws_kms_key.example.arn

  # Optional: Tags for resource management
  # tags = {
  #   Environment = "production"
  #   Purpose     = "geofence-monitoring"
  # }
}

# Example tracker resource that will be associated with the geofence collection
resource "aws_location_tracker" "example" {
  tracker_name = "example-tracker"
  description  = "Example tracker for device position monitoring"

  # Optional: Position filtering configuration
  # Reduces storage and evaluations by filtering position updates
  # position_filtering = "TimeBased"  # Options: TimeBased, DistanceBased, AccuracyBased

  # Optional: KMS key for encryption
  # kms_key_id = aws_kms_key.example.arn

  # Optional: Tags for resource management
  # tags = {
  #   Environment = "production"
  #   Purpose     = "fleet-tracking"
  # }
}

################################################################################
# Advanced Examples
################################################################################

# Example: Multiple geofence collections associated with one tracker
# Note: Each tracker can be associated with up to 5 geofence collections
resource "aws_location_tracker_association" "warehouse_geofences" {
  tracker_name = aws_location_tracker.fleet_tracker.tracker_name
  consumer_arn = aws_location_geofence_collection.warehouses.collection_arn
}

resource "aws_location_tracker_association" "delivery_zone_geofences" {
  tracker_name = aws_location_tracker.fleet_tracker.tracker_name
  consumer_arn = aws_location_geofence_collection.delivery_zones.collection_arn
}

resource "aws_location_tracker_association" "restricted_area_geofences" {
  tracker_name = aws_location_tracker.fleet_tracker.tracker_name
  consumer_arn = aws_location_geofence_collection.restricted_areas.collection_arn
}

# Example: Cross-region tracker association
resource "aws_location_tracker_association" "cross_region" {
  tracker_name = aws_location_tracker.global_tracker.tracker_name
  consumer_arn = aws_location_geofence_collection.regional_geofences.collection_arn
  region       = "eu-west-1"

  timeouts {
    create = "45m"
    delete = "45m"
  }
}

################################################################################
# Outputs
################################################################################

output "tracker_association_id" {
  description = "The ID of the tracker association (format: tracker_name|consumer_arn)"
  value       = aws_location_tracker_association.example.id
}

output "tracker_name" {
  description = "The name of the associated tracker"
  value       = aws_location_tracker_association.example.tracker_name
}

output "consumer_arn" {
  description = "The ARN of the associated geofence collection"
  value       = aws_location_tracker_association.example.consumer_arn
}

output "region" {
  description = "The AWS region where the association is managed"
  value       = aws_location_tracker_association.example.region
}

################################################################################
# Notes and Best Practices
################################################################################
# 1. Association Limits:
#    - Each tracker can be associated with up to 5 geofence collections
#    - Plan your associations based on your geofencing requirements
#
# 2. Event Generation:
#    - When associated, position updates are automatically evaluated
#    - ENTER events are generated when a device enters a geofence
#    - EXIT events are generated when a device exits a geofence
#    - Events are sent to Amazon EventBridge for further processing
#
# 3. Performance Considerations:
#    - Position filtering on the tracker reduces evaluation overhead
#    - Use TimeBased filtering to evaluate updates every 30 seconds
#    - Use DistanceBased filtering to ignore updates < 30m movement
#    - Use AccuracyBased filtering based on device accuracy measurements
#
# 4. Cost Optimization:
#    - You are charged for position updates stored and evaluated
#    - Enable position filtering to reduce costs
#    - Associate only necessary geofence collections to minimize evaluations
#
# 5. Security:
#    - Use IAM policies to control access to tracker and geofence resources
#    - Enable KMS encryption for sensitive location data
#    - Use VPC endpoints for private connectivity
#
# 6. Integration Patterns:
#    - Use EventBridge rules to route geofence events to Lambda, SNS, SQS
#    - Combine with Step Functions for complex workflow orchestration
#    - Integrate with CloudWatch for monitoring and alerting
#
# 7. Resource Dependencies:
#    - Both tracker and geofence collection must exist before association
#    - Terraform handles the dependency chain automatically when using references
#    - Deleting the association does not delete the tracker or collection
#
# 8. Troubleshooting:
#    - Verify IAM permissions for AssociateTrackerConsumer action
#    - Check that the geofence collection ARN is correct
#    - Ensure the tracker name exists and is active
#    - Review CloudWatch Logs for evaluation errors
#
# 9. Migration and Updates:
#    - Changing tracker_name or consumer_arn forces resource replacement
#    - Plan maintenance windows for association changes
#    - Test associations in non-production environments first
#
# 10. Monitoring:
#     - Monitor geofence evaluation metrics in CloudWatch
#     - Track ENTER/EXIT event counts
#     - Set alarms for evaluation failures or throttling
################################################################################
