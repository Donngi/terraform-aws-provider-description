# AWS Provider Version: 6.28.0
# Resource: aws_location_map
# Purpose: Provides a Location Service Map resource for rendering map tiles from global location data providers
# Documentation: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/location_map
# API Reference: https://docs.aws.amazon.com/location/latest/APIReference/API_CreateMap.html

/*
OVERVIEW:
Amazon Location Service Maps provides access to base map data for 190 countries with 5 million daily updates.
The service offers both dynamic and static maps with customizable styles from various data providers including
Esri, HERE Technologies, GrabMaps, and Open Data. Maps can be styled using predefined AWS Map Styles or
customized using style descriptors following the MapLibre GL style specification.

KEY FEATURES:
- Multiple map styles (Standard, Monochrome, Hybrid, Satellite)
- Vector and raster tile support
- Advanced styling features (terrain, contour density, traffic, travel modes)
- Localization and internationalization support
- Real-time traffic overlay capabilities
- Transportation-specific routing information

USE CASES:
- Embedding interactive maps in web/mobile applications
- Creating static maps for reports or documentation
- Data visualization and analysis on geographic contexts
- Enhancing real estate and travel experiences
- Supporting logistics planning and disaster response
- Outdoor navigation with topographic features

IMPORTANT NOTES:
- Esri data provider cannot be used for asset tracking or routing applications
- Hybrid styles retrieve both vector and raster tiles, increasing tile retrieval charges
- GrabMaps is only available in Asia Pacific (Singapore) Region and covers Southeast Asia
- Some styles support custom layers (e.g., POI layer for VectorEsriNavigation)
- Political view and custom layers are not supported by all map styles
- The VectorHereBerlin style has been renamed to VectorHereContrast but continues to work
*/

resource "aws_location_map" "example" {
  # ============================================================================
  # REQUIRED ARGUMENTS
  # ============================================================================

  # map_name (Required) - string
  # The name for the map resource.
  # Must be unique within your AWS account and region.
  # Length: 1-100 characters
  # Pattern: ^[-._\w]+$
  # Example values: "my-map", "production-map", "map_2024"
  map_name = "example-map"

  # configuration (Required) - block (min: 1, max: 1)
  # Configuration block with the map style selected from an available data provider.
  # Each map resource must have exactly one configuration block.
  configuration {
    # style (Required) - string
    # Specifies the map style selected from an available data provider.
    # The style determines the visual appearance of the map tiles.
    #
    # VALID ESRI MAP STYLES:
    # - VectorEsriDarkGrayCanvas: Dark gray neutral background, minimal colors/labels
    # - RasterEsriImagery: High-resolution satellite and aerial imagery
    # - VectorEsriLightGrayCanvas: Light gray neutral background for thematic content
    # - VectorEsriTopographic: Detailed basemap with classic Esri topographic style
    # - VectorEsriStreets: Detailed street map symbolized with classic Esri style
    # - VectorEsriNavigation: Navigation-optimized basemap for daytime mobile use
    #
    # VALID HERE TECHNOLOGIES MAP STYLES:
    # - VectorHereContrast (formerly VectorHereBerlin): High-contrast 3D/2D blended world map
    # - VectorHereExplore: Neutral global map with roads, buildings, landmarks, water
    # - VectorHereExploreTruck: Truck restrictions/attributes for transport and logistics
    # - RasterHereExploreSatellite: Global high-resolution satellite imagery
    # - HybridHereExploreSatellite: Road network overlaid on satellite imagery (retrieves both vector and raster tiles)
    #
    # VALID GRABMAPS STYLES (Southeast Asia only, ap-southeast-1 region):
    # - VectorGrabStandardLight: Detailed land use, roads, landmarks for Southeast Asia
    # - VectorGrabStandardDark: Dark variation of standard basemap for Southeast Asia
    #
    # VALID OPEN DATA STYLES:
    # - VectorOpenDataStandardLight: Detailed light-themed world basemap
    # - VectorOpenDataStandardDark: Detailed dark-themed world basemap
    # - VectorOpenDataVisualizationLight: Light theme with muted colors for data overlays
    # - VectorOpenDataVisualizationDark: Dark theme with muted colors for data overlays
    #
    # IMPORTANT CONSIDERATIONS:
    # - Hybrid styles (e.g., HybridHereExploreSatellite) retrieve both vector and raster tiles,
    #   resulting in higher tile retrieval charges
    # - Some styles support custom layers (e.g., VectorEsriNavigation supports POI layer)
    # - Not all styles support political views - check AWS documentation for compatibility
    # - Esri styles cannot be used for asset tracking or routing applications
    #
    # Reference: https://docs.aws.amazon.com/location/latest/APIReference/API_CreateMap.html
    style = "VectorHereContrast"
  }

  # ============================================================================
  # OPTIONAL ARGUMENTS
  # ============================================================================

  # description (Optional) - string
  # An optional description for the map resource.
  # Useful for documenting the purpose or usage of the map.
  # Example: "Production map for customer-facing web application"
  description = "Example map using HERE Contrast style for demonstration"

  # region (Optional) - string
  # Computed: true (defaults to provider region if not specified)
  # Region where this resource will be managed.
  # Defaults to the Region set in the provider configuration.
  # Valid values: Any valid AWS region code (e.g., "us-east-1", "eu-west-1", "ap-southeast-1")
  #
  # IMPORTANT REGIONAL RESTRICTIONS:
  # - GrabMaps styles are only available in ap-southeast-1 (Asia Pacific Singapore)
  # - Some map features may have regional availability differences
  #
  # Reference: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  # tags (Optional) - map(string)
  # Key-value tags for the map resource.
  # Tags are useful for resource organization, cost allocation, and access control.
  #
  # If configured with a provider default_tags configuration block, tags with
  # matching keys will overwrite those defined at the provider-level.
  #
  # Example use cases:
  # - Environment identification (Environment = "production")
  # - Cost center tracking (CostCenter = "engineering")
  # - Application association (Application = "mobile-app")
  tags = {
    Name        = "example-map"
    Environment = "development"
    ManagedBy   = "terraform"
    Purpose     = "demonstration"
  }

  # ============================================================================
  # COMPUTED ATTRIBUTES (Reference Only - Cannot be set)
  # ============================================================================

  # The following attributes are automatically computed by AWS and can be
  # referenced after the resource is created:
  #
  # id (string)
  # - The unique identifier for the map resource (typically the map_name)
  #
  # map_arn (string)
  # - The Amazon Resource Name (ARN) for the map resource
  # - Used to specify the resource across all AWS services
  # - Format: arn:aws:geo:region:account-id:map/map-name
  # - Can be referenced as: aws_location_map.example.map_arn
  #
  # create_time (string)
  # - The timestamp for when the map resource was created in ISO 8601 format
  # - Example: "2024-01-15T10:30:00.000Z"
  # - Can be referenced as: aws_location_map.example.create_time
  #
  # update_time (string)
  # - The timestamp for when the map resource was last updated in ISO 8601 format
  # - Example: "2024-01-20T14:45:00.000Z"
  # - Can be referenced as: aws_location_map.example.update_time
  #
  # tags_all (map(string))
  # - A map of tags assigned to the resource, including those inherited from
  #   the provider default_tags configuration block
  # - Can be referenced as: aws_location_map.example.tags_all
}

# ============================================================================
# USAGE EXAMPLES
# ============================================================================

# Example 1: Simple map with Open Data Standard Light style
resource "aws_location_map" "open_data_map" {
  map_name = "open-data-standard-map"

  configuration {
    style = "VectorOpenDataStandardLight"
  }

  description = "Open data map for public-facing applications"

  tags = {
    Environment = "production"
    DataSource  = "OpenData"
  }
}

# Example 2: Esri topographic map for geographic visualization
resource "aws_location_map" "topographic_map" {
  map_name = "esri-topographic-map"

  configuration {
    style = "VectorEsriTopographic"
  }

  description = "Topographic map for outdoor and hiking applications"

  tags = {
    Environment = "production"
    UseCase     = "outdoor-navigation"
    Provider    = "Esri"
  }
}

# Example 3: HERE truck routing map for logistics
resource "aws_location_map" "truck_routing_map" {
  map_name = "here-truck-routing-map"

  configuration {
    style = "VectorHereExploreTruck"
  }

  description = "Map with truck restrictions and attributes for logistics planning"

  tags = {
    Environment = "production"
    UseCase     = "logistics"
    Provider    = "HERE"
  }
}

# Example 4: Satellite imagery map for real estate
resource "aws_location_map" "satellite_map" {
  map_name = "satellite-imagery-map"

  configuration {
    style = "RasterEsriImagery"
  }

  description = "High-resolution satellite imagery for real estate applications"

  tags = {
    Environment = "production"
    UseCase     = "real-estate"
    MapType     = "satellite"
  }
}

# Example 5: Hybrid map combining satellite imagery with road network
resource "aws_location_map" "hybrid_map" {
  map_name = "hybrid-satellite-map"

  configuration {
    # Note: Hybrid styles retrieve both vector and raster tiles,
    # which will increase tile retrieval charges
    style = "HybridHereExploreSatellite"
  }

  description = "Hybrid map showing road network over satellite imagery"

  tags = {
    Environment = "production"
    UseCase     = "navigation"
    MapType     = "hybrid"
    CostNote    = "higher-tile-charges"
  }
}

# Example 6: Dark theme map for data visualization
resource "aws_location_map" "dark_visualization_map" {
  map_name = "dark-viz-map"

  configuration {
    style = "VectorOpenDataVisualizationDark"
  }

  description = "Dark-themed map with muted colors for data overlay visualization"

  tags = {
    Environment = "production"
    UseCase     = "data-visualization"
    Theme       = "dark"
  }
}

# Example 7: GrabMaps for Southeast Asia region
resource "aws_location_map" "grab_sea_map" {
  map_name = "grab-southeast-asia-map"

  # GrabMaps is only available in ap-southeast-1 region
  region = "ap-southeast-1"

  configuration {
    style = "VectorGrabStandardLight"
  }

  description = "GrabMaps standard light map for Southeast Asia coverage"

  tags = {
    Environment = "production"
    Region      = "southeast-asia"
    Provider    = "Grab"
  }
}

# ============================================================================
# REFERENCING MAP ATTRIBUTES
# ============================================================================

# Output the map ARN for use in other resources
output "example_map_arn" {
  description = "ARN of the example map resource"
  value       = aws_location_map.example.map_arn
}

# Output the map creation timestamp
output "example_map_created" {
  description = "Timestamp when the example map was created"
  value       = aws_location_map.example.create_time
}

# Reference the map name in other Location Service resources
# For example, in a Location Service tracker or geofence collection
# that needs to reference this map for visualization purposes

# ============================================================================
# INTEGRATION WITH OTHER SERVICES
# ============================================================================

/*
COMMON INTEGRATION PATTERNS:

1. Web/Mobile Applications:
   - Use MapLibre GL JS or MapLibre Native SDKs to render dynamic maps
   - Reference the map resource using its ARN or name
   - Implement authentication using Amazon Cognito or API keys

2. Static Map Generation:
   - Use GetStaticMap API to generate map images
   - Customize with overlays (markers, routes, polygons)
   - Embed in reports, emails, or documentation

3. Data Visualization:
   - Overlay custom data layers on visualization-optimized styles
   - Use GeoJSON format for geographic data
   - Implement interactivity with MapLibre event handlers

4. Navigation Applications:
   - Combine with Amazon Location Route Calculator
   - Use navigation-optimized styles (VectorEsriNavigation, VectorHereExplore)
   - Display real-time traffic with traffic overlay features

5. Asset Tracking:
   - Integrate with Amazon Location Tracker
   - Display device positions on map
   - Use appropriate styles (not Esri for tracking applications)

6. Logistics and Fleet Management:
   - Use truck routing styles (VectorHereExploreTruck)
   - Combine with Route Calculator for optimized routing
   - Display truck restrictions and attributes

ADVANCED STYLING FEATURES (AWS Map Styles):

The following features are available through the GetStyleDescriptor API:

- ColorScheme: Set map colors to Light or Dark (Standard and Monochrome styles)
- Terrain: Show topographic hillshade (Standard style)
- ContourDensity: Display topographic elevation lines (Standard style)
- Traffic: Show real-time traffic conditions (Standard style)
- TravelMode: Optimize for transit or truck usage (Standard style)
- PoliticalView: Tailored geopolitical views for specific countries
- Language: Set local language using BCP47 language codes

SECURITY BEST PRACTICES:

1. Use IAM roles and policies to control access to map resources
2. Implement fine-grained access control with resource-based policies
3. Enable CloudTrail logging for audit and compliance
4. Use Amazon Cognito for user authentication in client applications
5. Rotate API keys regularly if using API key authentication
6. Implement rate limiting to prevent abuse
7. Use VPC endpoints for private network access

COST OPTIMIZATION:

1. Choose appropriate map styles based on use case (vector vs raster)
2. Avoid hybrid styles unless road overlay is necessary
3. Implement client-side caching of map tiles
4. Use static maps for non-interactive use cases
5. Monitor tile retrieval metrics in CloudWatch
6. Set appropriate zoom level limits to control tile requests
7. Consider Open Data styles for cost-effective general-purpose maps

MONITORING AND OBSERVABILITY:

1. Monitor API usage metrics in CloudWatch
2. Set up alarms for unusual access patterns
3. Track tile retrieval counts and costs
4. Log API calls with CloudTrail for compliance
5. Monitor map resource updates and configuration changes
6. Implement application-level usage tracking

COMPLIANCE AND RESTRICTIONS:

1. Esri data cannot be used for:
   - Standalone asset tracking applications
   - Routing applications without map visualization
   - Applications that compete with Esri products

2. GrabMaps restrictions:
   - Only available in ap-southeast-1 region
   - Geographic coverage limited to Southeast Asia countries
   - Check coverage area documentation before deployment

3. Data provider terms:
   - Review and comply with each provider's terms of service
   - Ensure appropriate attribution in applications
   - Understand usage limits and restrictions

Reference: https://docs.aws.amazon.com/location/latest/developerguide/maps.html
*/
