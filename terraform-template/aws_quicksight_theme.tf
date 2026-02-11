################################################################################
# AWS QuickSight Theme
# Resource: aws_quicksight_theme
# Provider Version: 6.28.0
#
# Description:
#   Manages a QuickSight Theme. Themes allow you to customize the visual appearance
#   of your QuickSight analyses and dashboards by defining color palettes,
#   typography, and other UI elements.
#
# Use Cases:
#   - Applying corporate branding to QuickSight dashboards
#   - Creating consistent visual themes across multiple analyses
#   - Customizing colors for data visualization
#   - Defining custom UI color schemes
#
# Dependencies:
#   - QuickSight must be enabled in your AWS account
#   - Appropriate IAM permissions for QuickSight operations
#
# Best Practices:
#   - Use base_theme_id to inherit from QuickSight's built-in themes
#   - Define data color palettes with sufficient contrast for accessibility
#   - Use tags for resource organization and cost tracking
#   - Document theme purpose in version_description
#
# Related Resources:
#   - aws_quicksight_analysis
#   - aws_quicksight_dashboard
#   - aws_quicksight_template
################################################################################

resource "aws_quicksight_theme" "example" {
  ##############################################################################
  # Required Arguments
  ##############################################################################

  # theme_id - (Required, Forces new resource)
  # Unique identifier for the theme
  # Type: string
  # Constraints:
  #   - Must be unique within the AWS account
  #   - Cannot be changed after creation
  # Example: "my-corporate-theme"
  theme_id = "example-theme"

  # name - (Required)
  # Display name for the theme
  # Type: string
  # Purpose: Human-readable name shown in QuickSight UI
  # Example: "Corporate Theme 2024"
  name = "Example Theme"

  # base_theme_id - (Required)
  # The ID of the base theme to inherit from
  # Type: string
  # Built-in themes include:
  #   - SEASIDE: Light blue theme
  #   - CLASSIC: Traditional QuickSight theme
  #   - MIDNIGHT: Dark theme
  #   - RAINFOREST: Green theme
  # Purpose: Provides default styling that can be customized
  base_theme_id = "MIDNIGHT"

  # configuration - (Required)
  # Theme display properties and styling configuration
  # Type: object
  # Purpose: Defines all visual customization for the theme
  configuration {
    # data_color_palette - (Optional)
    # Color properties for chart data visualization
    # Type: object
    # Purpose: Controls colors used in data visualization
    # Max items: 1
    data_color_palette {
      # colors - (Optional)
      # List of colors for data series
      # Type: list(string)
      # Format: Hexadecimal color codes (e.g., "#FFFFFF")
      # Constraints:
      #   - Minimum: 8 colors
      #   - Maximum: 20 colors
      # Purpose: Applied sequentially to data series in charts
      # Best Practice: Use colors with sufficient contrast
      colors = [
        "#FFFFFF", # White
        "#111111", # Near black
        "#222222", # Dark gray
        "#333333", # Gray
        "#444444", # Medium gray
        "#555555", # Medium-light gray
        "#666666", # Light gray
        "#777777", # Lighter gray
        "#888888", # Very light gray
        "#999999", # Lightest gray
      ]

      # empty_fill_color - (Optional)
      # Color for areas with no data
      # Type: string
      # Format: Hexadecimal color code
      # Purpose: Highlights missing data in visualizations
      # Example: "#FFFFFF" for white
      empty_fill_color = "#FFFFFF"

      # min_max_gradient - (Optional)
      # Two colors defining gradient endpoints
      # Type: list(string)
      # Constraints: Exactly 2 colors required
      # Format: Hexadecimal color codes
      # Purpose: Creates color gradients in heatmaps and similar visualizations
      # [0] = Minimum value color
      # [1] = Maximum value color
      min_max_gradient = [
        "#FFFFFF", # Minimum value
        "#111111", # Maximum value
      ]
    }

    # sheet - (Optional)
    # Display options for sheets in analyses/dashboards
    # Type: object
    # Purpose: Controls visual appearance of sheet elements
    # Max items: 1
    sheet {
      # tile - (Optional)
      # Display options for individual tiles (visualizations)
      # Type: object
      # Purpose: Controls tile appearance
      # Max items: 1
      tile {
        # border - (Optional)
        # Border configuration for tiles
        # Type: object
        # Max items: 1
        border {
          # show - (Optional)
          # Whether to display borders around tiles
          # Type: bool
          # Default: Provider/API default
          # Purpose: Visual separation of visualizations
          show = true
        }
      }

      # tile_layout - (Optional)
      # Layout options for tile arrangement
      # Type: object
      # Purpose: Controls spacing and margins between tiles
      # Max items: 1
      tile_layout {
        # gutter - (Optional)
        # Space between tiles
        # Type: object
        # Max items: 1
        gutter {
          # show - (Optional)
          # Whether to display space between tiles
          # Type: bool
          # Purpose: Creates visual separation
          show = true
        }

        # margin - (Optional)
        # Margins around the outside of sheets
        # Type: object
        # Max items: 1
        margin {
          # show - (Optional)
          # Whether to display margins around sheets
          # Type: bool
          # Purpose: Provides padding around content
          show = true
        }
      }
    }

    # typography - (Optional)
    # Font family definitions
    # Type: object
    # Purpose: Customizes typography across the theme
    # Max items: 1
    typography {
      # font_families - (Optional)
      # List of font families to use
      # Type: list(object)
      # Constraints: Maximum 5 font families
      # Purpose: Defines available fonts for the theme
      # Note: Fonts must be web-safe or available in QuickSight
      font_families {
        # font_family - (Optional)
        # Name of the font family
        # Type: string
        # Examples: "Arial", "Helvetica", "Times New Roman"
        font_family = "Arial"
      }
    }

    # ui_color_palette - (Optional)
    # Color properties for UI elements (not data)
    # Type: object
    # Purpose: Controls colors of interface elements
    # Max items: 1
    # Best Practice: Maintain adequate contrast for accessibility
    ui_color_palette {
      # accent - (Optional)
      # Color for selected states and buttons
      # Type: string (hexadecimal)
      # Purpose: Highlights interactive elements
      accent = "#0073BB"

      # accent_foreground - (Optional)
      # Color for text/elements over accent color
      # Type: string (hexadecimal)
      # Purpose: Ensures readability on accent backgrounds
      accent_foreground = "#FFFFFF"

      # danger - (Optional)
      # Color for error messages
      # Type: string (hexadecimal)
      # Purpose: Indicates errors or destructive actions
      danger = "#E12D39"

      # danger_foreground - (Optional)
      # Color for text/elements over danger color
      # Type: string (hexadecimal)
      danger_foreground = "#FFFFFF"

      # dimension - (Optional)
      # Color for dimension field names
      # Type: string (hexadecimal)
      # Purpose: Distinguishes dimensional data
      dimension = "#0073BB"

      # dimension_foreground - (Optional)
      # Color for text/elements over dimension color
      # Type: string (hexadecimal)
      dimension_foreground = "#FFFFFF"

      # measure - (Optional)
      # Color for measure field names
      # Type: string (hexadecimal)
      # Purpose: Distinguishes quantitative data
      measure = "#01BCB4"

      # measure_foreground - (Optional)
      # Color for text/elements over measure color
      # Type: string (hexadecimal)
      measure_foreground = "#FFFFFF"

      # primary_background - (Optional)
      # Background color for visuals and high-emphasis UI
      # Type: string (hexadecimal)
      # Purpose: Main background color
      primary_background = "#FFFFFF"

      # primary_foreground - (Optional)
      # Color for text/elements over primary background
      # Type: string (hexadecimal)
      # Purpose: Includes grid lines, borders, icons
      primary_foreground = "#151515"

      # secondary_background - (Optional)
      # Background color for sheets and controls
      # Type: string (hexadecimal)
      # Purpose: Secondary surface color
      secondary_background = "#F7F7F7"

      # secondary_foreground - (Optional)
      # Color for text/elements over secondary background
      # Type: string (hexadecimal)
      # Purpose: Sheet titles and control text
      secondary_foreground = "#151515"

      # success - (Optional)
      # Color for success messages
      # Type: string (hexadecimal)
      # Purpose: Indicates successful operations
      success = "#3A871E"

      # success_foreground - (Optional)
      # Color for text/elements over success color
      # Type: string (hexadecimal)
      success_foreground = "#FFFFFF"

      # warning - (Optional)
      # Color for warnings and informational messages
      # Type: string (hexadecimal)
      # Purpose: Draws attention to important information
      warning = "#FF9900"

      # warning_foreground - (Optional)
      # Color for text/elements over warning color
      # Type: string (hexadecimal)
      warning_foreground = "#FFFFFF"
    }
  }

  ##############################################################################
  # Optional Arguments
  ##############################################################################

  # aws_account_id - (Optional, Forces new resource)
  # AWS account ID where theme will be created
  # Type: string
  # Default: Current AWS account (from provider configuration)
  # Forces new resource: Yes
  # Use case: Cross-account theme management
  # aws_account_id = "123456789012"

  # permissions - (Optional)
  # Resource permissions for the theme
  # Type: set(object)
  # Constraints: Maximum 64 permission sets
  # Purpose: Controls who can access and modify the theme
  # permissions {
  #   # actions - (Required)
  #   # IAM actions to grant/revoke
  #   # Type: set(string)
  #   # Common actions:
  #   #   - quicksight:DescribeTheme
  #   #   - quicksight:DescribeThemeAlias
  #   #   - quicksight:ListThemeVersions
  #   #   - quicksight:DeleteTheme
  #   #   - quicksight:UpdateTheme
  #   #   - quicksight:UpdateThemePermissions
  #   actions = [
  #     "quicksight:DescribeTheme",
  #     "quicksight:DescribeThemeAlias",
  #     "quicksight:ListThemeVersions",
  #   ]
  #
  #   # principal - (Required)
  #   # ARN of the principal (user, group, or role)
  #   # Type: string
  #   # Format: arn:aws:quicksight:region:account-id:user/namespace/username
  #   # See: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_ResourcePermission.html
  #   principal = "arn:aws:quicksight:us-east-1:123456789012:user/default/admin"
  # }

  # region - (Optional)
  # AWS region for resource management
  # Type: string
  # Default: Provider region configuration
  # Purpose: Specify region different from provider default
  # See: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  # tags - (Optional)
  # Resource tags for organization and cost tracking
  # Type: map(string)
  # Best Practices:
  #   - Use consistent tagging strategy
  #   - Include environment, owner, cost center
  #   - Leverage provider default_tags for common tags
  # Note: Merged with provider default_tags
  tags = {
    Environment = "development"
    Project     = "analytics"
    ManagedBy   = "terraform"
  }

  # version_description - (Optional)
  # Description of the current theme version
  # Type: string
  # Purpose: Documents changes in this version
  # Best Practice: Use meaningful descriptions for version tracking
  # Example: "Updated color palette for Q1 2024 branding"
  version_description = "Initial theme configuration"

  ##############################################################################
  # Timeouts Configuration
  ##############################################################################

  # timeouts {
  #   # create - (Optional)
  #   # Timeout for create operation
  #   # Type: string
  #   # Default: 5 minutes
  #   # Format: "5m", "1h"
  #   create = "5m"
  #
  #   # update - (Optional)
  #   # Timeout for update operation
  #   # Type: string
  #   # Default: 5 minutes
  #   update = "5m"
  #
  #   # delete - (Optional)
  #   # Timeout for delete operation
  #   # Type: string
  #   # Default: 5 minutes
  #   delete = "5m"
  # }
}

################################################################################
# Computed Attributes (Read-Only)
################################################################################

# The following attributes are computed by AWS and cannot be set:

# arn - (Computed)
# Amazon Resource Name (ARN) of the theme
# Type: string
# Format: arn:aws:quicksight:region:account-id:theme/theme-id
# Purpose: Unique identifier for AWS resource references
# output "theme_arn" {
#   value = aws_quicksight_theme.example.arn
# }

# created_time - (Computed)
# Timestamp when the theme was created
# Type: string
# Format: RFC3339 timestamp
# output "theme_created_time" {
#   value = aws_quicksight_theme.example.created_time
# }

# id - (Computed)
# Resource identifier
# Type: string
# Format: "aws_account_id,theme_id"
# Purpose: Unique identifier for Terraform state
# Note: Composed of AWS account ID and theme ID
# output "theme_id" {
#   value = aws_quicksight_theme.example.id
# }

# last_updated_time - (Computed)
# Timestamp when the theme was last updated
# Type: string
# Format: RFC3339 timestamp
# output "theme_last_updated_time" {
#   value = aws_quicksight_theme.example.last_updated_time
# }

# status - (Computed)
# Current status of the theme
# Type: string
# Possible values:
#   - CREATION_IN_PROGRESS
#   - CREATION_SUCCESSFUL
#   - CREATION_FAILED
#   - UPDATE_IN_PROGRESS
#   - UPDATE_SUCCESSFUL
#   - UPDATE_FAILED
#   - DELETED
# Purpose: Track theme lifecycle state
# output "theme_status" {
#   value = aws_quicksight_theme.example.status
# }

# tags_all - (Computed)
# Complete map of tags including provider defaults
# Type: map(string)
# Purpose: Shows all tags including inherited default_tags
# output "theme_tags_all" {
#   value = aws_quicksight_theme.example.tags_all
# }

# version_number - (Computed)
# Version number of the current theme version
# Type: number
# Purpose: Tracks theme version history
# Note: Increments with each update
# output "theme_version_number" {
#   value = aws_quicksight_theme.example.version_number
# }

################################################################################
# Common Configuration Examples
################################################################################

# Example 1: Minimal Theme with Base Theme Only
# resource "aws_quicksight_theme" "minimal" {
#   theme_id      = "minimal-theme"
#   name          = "Minimal Theme"
#   base_theme_id = "CLASSIC"
#
#   configuration {
#     data_color_palette {
#       colors = [
#         "#FF6B6B", "#4ECDC4", "#45B7D1", "#FFA07A",
#         "#98D8C8", "#F7DC6F", "#BB8FCE", "#85C1E2",
#       ]
#     }
#   }
# }

# Example 2: Corporate Branding Theme
# resource "aws_quicksight_theme" "corporate" {
#   theme_id      = "corporate-theme"
#   name          = "Corporate Brand Theme"
#   base_theme_id = "MIDNIGHT"
#
#   configuration {
#     data_color_palette {
#       colors = [
#         "#003366", "#336699", "#6699CC", "#99CCFF",
#         "#00CC99", "#66FFCC", "#FF6633", "#FF9966",
#       ]
#       empty_fill_color = "#F5F5F5"
#       min_max_gradient = ["#E0F7FA", "#006064"]
#     }
#
#     ui_color_palette {
#       primary_background   = "#003366"
#       primary_foreground   = "#FFFFFF"
#       secondary_background = "#F5F5F5"
#       secondary_foreground = "#333333"
#       accent              = "#00CC99"
#       accent_foreground   = "#FFFFFF"
#     }
#   }
#
#   tags = {
#     Department = "Marketing"
#     Purpose    = "Corporate Branding"
#   }
# }

# Example 3: Theme with Permissions
# resource "aws_quicksight_theme" "shared" {
#   theme_id      = "shared-theme"
#   name          = "Shared Team Theme"
#   base_theme_id = "SEASIDE"
#
#   configuration {
#     data_color_palette {
#       colors = [
#         "#1ABC9C", "#3498DB", "#9B59B6", "#F39C12",
#         "#E74C3C", "#95A5A6", "#34495E", "#16A085",
#       ]
#     }
#   }
#
#   permissions {
#     actions = [
#       "quicksight:DescribeTheme",
#       "quicksight:DescribeThemeAlias",
#       "quicksight:ListThemeVersions",
#     ]
#     principal = "arn:aws:quicksight:us-east-1:123456789012:group/default/analysts"
#   }
#
#   permissions {
#     actions = [
#       "quicksight:DescribeTheme",
#       "quicksight:DescribeThemeAlias",
#       "quicksight:ListThemeVersions",
#       "quicksight:UpdateTheme",
#       "quicksight:DeleteTheme",
#       "quicksight:UpdateThemePermissions",
#     ]
#     principal = "arn:aws:quicksight:us-east-1:123456789012:user/default/admin"
#   }
# }

# Example 4: Accessible High-Contrast Theme
# resource "aws_quicksight_theme" "accessible" {
#   theme_id      = "accessible-theme"
#   name          = "High Contrast Accessible Theme"
#   base_theme_id = "CLASSIC"
#
#   configuration {
#     data_color_palette {
#       colors = [
#         "#000080", "#FF0000", "#008000", "#800080",
#         "#FF8C00", "#4B0082", "#DC143C", "#006400",
#       ]
#       empty_fill_color = "#FFFFFF"
#       min_max_gradient = ["#FFFFFF", "#000000"]
#     }
#
#     ui_color_palette {
#       primary_background   = "#FFFFFF"
#       primary_foreground   = "#000000"
#       secondary_background = "#F0F0F0"
#       secondary_foreground = "#000000"
#       accent              = "#000080"
#       accent_foreground   = "#FFFFFF"
#       danger              = "#CC0000"
#       danger_foreground   = "#FFFFFF"
#       success             = "#006400"
#       success_foreground  = "#FFFFFF"
#       warning             = "#FF8C00"
#       warning_foreground  = "#000000"
#     }
#   }
#
#   version_description = "WCAG AAA compliant high contrast theme"
#
#   tags = {
#     Accessibility = "HighContrast"
#     WCAG_Level   = "AAA"
#   }
# }

################################################################################
# Import
################################################################################

# Existing QuickSight themes can be imported using the AWS account ID and theme ID
# separated by a comma:
#
# terraform import aws_quicksight_theme.example 123456789012,example-theme
