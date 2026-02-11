# ============================================================================
# AWS EventBridge Schema Resource (aws_schemas_schema)
# ============================================================================
# Provider Version: 6.28.0
# Resource Type: aws_schemas_schema
#
# Description:
#   Provides an EventBridge Schema resource for managing custom event schemas
#   in Amazon EventBridge Schema Registry. This resource allows you to define
#   and manage OpenAPI 3.0 or JSONSchema Draft4 schemas that describe the
#   structure of events in your event-driven applications.
#
# Note:
#   EventBridge was formerly known as CloudWatch Events. The functionality
#   is identical.
#
# AWS Documentation:
#   - Schema Creation: https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-schema-create.html
#   - Schema Registry: https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-schema-registry.html
#   - Schemas Overview: https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-schema.html
#
# Use Cases:
#   - Define custom event schemas for event-driven applications
#   - Enable code generation from schemas for strongly-typed event handling
#   - Document event structures for API consumers
#   - Validate event payloads against schemas
#   - Share event contracts between services
#
# Schema Format Support:
#   - OpenAPI 3.0 (OpenApi3): Build-time focused, good for API documentation
#   - JSONSchema Draft4 (JSONSchemaDraft4): Runtime validation focused
#
# Best Practices:
#   - Use JSONSchema for client-side validation to ensure events conform to schema
#   - Keep schema versions under version control
#   - Use descriptive names that reflect the event type
#   - Document schema changes and maintain backward compatibility
#   - Download code bindings for type-safe event handling
#   - Consider schema evolution strategy before deployment
# ============================================================================

# ────────────────────────────────────────────────────────────────────────────
# Example: Basic EventBridge Schema with OpenAPI 3.0
# ────────────────────────────────────────────────────────────────────────────
# This example demonstrates creating a basic event schema using OpenAPI 3.0
# specification. The schema defines a simple event structure with properties.

resource "aws_schemas_registry" "example" {
  name        = "my-custom-registry"
  description = "Custom registry for application events"
}

resource "aws_schemas_schema" "basic_example" {
  # ┌─────────────────────────────────────────────────────────────────────┐
  # │ Required Arguments                                                   │
  # └─────────────────────────────────────────────────────────────────────┘

  # name - (Required) The name of the schema
  # Type: string
  # Constraints: Maximum of 385 characters consisting of lower case letters,
  #              upper case letters, ., -, _, @
  # Pattern: ^[a-zA-Z0-9._@-]+$
  # Note: Schema names must be unique within the registry
  name = "UserCreatedEvent"

  # registry_name - (Required) The name of the registry in which this schema belongs
  # Type: string
  # Note: The registry must exist before creating the schema
  # Default Registries:
  #   - aws.events: AWS event schema registry (managed by AWS)
  #   - discovered-schemas: Auto-discovered schema registry
  # Reference: Can reference a custom registry or use a string value
  registry_name = aws_schemas_registry.example.name

  # type - (Required) The type of the schema
  # Type: string
  # Valid Values:
  #   - "OpenApi3": OpenAPI 3.0 specification format
  #   - "JSONSchemaDraft4": JSON Schema Draft 4 specification format
  # Considerations:
  #   - OpenApi3: Better for API documentation and build-time tooling
  #   - JSONSchemaDraft4: Better for runtime validation and supports more keywords
  # Note: Cannot be changed after creation (requires resource replacement)
  type = "OpenApi3"

  # content - (Required) The schema specification
  # Type: string (JSON-encoded)
  # Format: Must be a valid Open API 3.0 spec or JSONSchema Draft4 spec
  # Note: Use jsonencode() for inline schemas or file() for external files
  # Best Practice: Store complex schemas in separate files for maintainability
  content = jsonencode({
    openapi = "3.0.0"
    info = {
      version = "1.0.0"
      title   = "User Created Event"
    }
    paths = {}
    components = {
      schemas = {
        UserCreatedEvent = {
          type = "object"
          properties = {
            userId = {
              type        = "string"
              description = "Unique identifier for the user"
            }
            email = {
              type        = "string"
              format      = "email"
              description = "User email address"
            }
            createdAt = {
              type        = "string"
              format      = "date-time"
              description = "Timestamp when the user was created"
            }
          }
          required = ["userId", "email", "createdAt"]
        }
      }
    }
  })

  # ┌─────────────────────────────────────────────────────────────────────┐
  # │ Optional Arguments                                                   │
  # └─────────────────────────────────────────────────────────────────────┘

  # description - (Optional) The description of the schema
  # Type: string
  # Constraints: Maximum of 256 characters
  # Default: null
  # Note: Helpful for documenting the purpose and usage of the schema
  description = "Schema for user creation events in the user management system"

  # tags - (Optional) A map of tags to assign to the resource
  # Type: map(string)
  # Default: {}
  # Integration: Tags with matching keys will overwrite those defined at the
  #              provider-level default_tags configuration block
  # Best Practice: Use tags for cost allocation, resource organization, and access control
  tags = {
    Environment = "production"
    Application = "user-management"
    ManagedBy   = "terraform"
    Team        = "backend"
  }

  # region - (Optional) Region where this resource will be managed
  # Type: string
  # Default: Defaults to the Region set in the provider configuration
  # Note: Use this to override the provider-level region for this specific resource
  # Use Case: Multi-region deployments where schemas need to be replicated
  # region = "us-west-2"
}

# ────────────────────────────────────────────────────────────────────────────
# Computed Attributes (Output Values)
# ────────────────────────────────────────────────────────────────────────────
# These attributes are populated after the resource is created and can be
# referenced in other resources or output as values.

output "schema_arn" {
  description = "The Amazon Resource Name (ARN) of the schema"
  value       = aws_schemas_schema.basic_example.arn
  # Example: arn:aws:schemas:us-east-1:123456789012:schema/my-custom-registry/UserCreatedEvent
}

output "schema_version" {
  description = "The version of the schema (auto-generated by AWS)"
  value       = aws_schemas_schema.basic_example.version
  # Example: "1"
  # Note: Version increments automatically when schema content is updated
}

output "schema_last_modified" {
  description = "The last modified date of the schema (RFC3339 format)"
  value       = aws_schemas_schema.basic_example.last_modified
  # Example: "2024-01-15T10:30:45Z"
}

output "schema_version_created_date" {
  description = "The created date of the current version of the schema"
  value       = aws_schemas_schema.basic_example.version_created_date
  # Example: "2024-01-15T10:30:45Z"
}

output "schema_tags_all" {
  description = "Map of all tags including provider default_tags"
  value       = aws_schemas_schema.basic_example.tags_all
  # Note: Includes both resource-level tags and provider default_tags
}

# ────────────────────────────────────────────────────────────────────────────
# Example: JSONSchema Draft4 Format
# ────────────────────────────────────────────────────────────────────────────
# This example shows using JSONSchema Draft4 format, which is better for
# runtime validation and supports more schema keywords than OpenAPI.

resource "aws_schemas_schema" "jsonschema_example" {
  name          = "OrderPlacedEvent"
  registry_name = aws_schemas_registry.example.name
  type          = "JSONSchemaDraft4"
  description   = "Schema for order placement events"

  content = jsonencode({
    "$schema" = "http://json-schema.org/draft-04/schema#"
    title     = "Order Placed Event"
    type      = "object"
    properties = {
      orderId = {
        type        = "string"
        pattern     = "^ORD-[0-9]{10}$"
        description = "Unique order identifier"
      }
      customerId = {
        type        = "string"
        description = "Customer identifier"
      }
      items = {
        type = "array"
        items = {
          type = "object"
          properties = {
            productId = { type = "string" }
            quantity  = { type = "integer", minimum = 1 }
            price     = { type = "number", minimum = 0 }
          }
          required = ["productId", "quantity", "price"]
        }
        minItems = 1
      }
      totalAmount = {
        type    = "number"
        minimum = 0
      }
      timestamp = {
        type   = "string"
        format = "date-time"
      }
    }
    required = ["orderId", "customerId", "items", "totalAmount", "timestamp"]
  })

  tags = {
    EventType = "order"
    Domain    = "commerce"
  }
}

# ────────────────────────────────────────────────────────────────────────────
# Example: Schema with External File Content
# ────────────────────────────────────────────────────────────────────────────
# For complex schemas, it's better to maintain them in separate files.
# This improves readability and allows schema validation tools to work.

resource "aws_schemas_schema" "external_schema_example" {
  name          = "PaymentProcessedEvent"
  registry_name = aws_schemas_registry.example.name
  type          = "OpenApi3"
  description   = "Schema for payment processing events"

  # Use file() function to load schema from external file
  # Note: Schema file should be in the same directory or use relative path
  # content = file("${path.module}/schemas/payment-processed-event.json")

  # For this example, using inline content
  content = jsonencode({
    openapi = "3.0.0"
    info = {
      version = "1.0.0"
      title   = "Payment Processed Event"
    }
    paths = {}
    components = {
      schemas = {
        PaymentProcessedEvent = {
          type = "object"
          properties = {
            paymentId = { type = "string" }
            orderId   = { type = "string" }
            amount = {
              type = "number"
              minimum = 0
            }
            currency = {
              type = "string"
              pattern = "^[A-Z]{3}$"
              description = "ISO 4217 currency code"
            }
            status = {
              type = "string"
              enum = ["pending", "completed", "failed"]
            }
            processedAt = {
              type   = "string"
              format = "date-time"
            }
          }
          required = ["paymentId", "orderId", "amount", "currency", "status", "processedAt"]
        }
      }
    }
  })

  tags = {
    EventType = "payment"
    Domain    = "finance"
  }
}

# ────────────────────────────────────────────────────────────────────────────
# Example: Multi-Region Schema Deployment
# ────────────────────────────────────────────────────────────────────────────
# Deploy the same schema to multiple regions for disaster recovery or
# multi-region event processing.

resource "aws_schemas_schema" "multi_region_primary" {
  name          = "NotificationEvent"
  registry_name = aws_schemas_registry.example.name
  type          = "OpenApi3"
  region        = "us-east-1"
  description   = "Notification event schema - Primary region"

  content = jsonencode({
    openapi = "3.0.0"
    info = {
      version = "1.0.0"
      title   = "Notification Event"
    }
    paths = {}
    components = {
      schemas = {
        NotificationEvent = {
          type = "object"
          properties = {
            notificationId = { type = "string" }
            userId         = { type = "string" }
            message        = { type = "string" }
            channel        = {
              type = "string"
              enum = ["email", "sms", "push"]
            }
            sentAt = {
              type   = "string"
              format = "date-time"
            }
          }
          required = ["notificationId", "userId", "message", "channel", "sentAt"]
        }
      }
    }
  })

  tags = {
    Region = "primary"
  }
}

# Secondary region deployment (requires additional provider configuration)
# provider "aws" {
#   alias  = "west"
#   region = "us-west-2"
# }
#
# resource "aws_schemas_schema" "multi_region_secondary" {
#   provider      = aws.west
#   name          = "NotificationEvent"
#   registry_name = aws_schemas_registry.example.name
#   type          = "OpenApi3"
#   description   = "Notification event schema - Secondary region"
#   content       = aws_schemas_schema.multi_region_primary.content
#
#   tags = {
#     Region = "secondary"
#   }
# }

# ============================================================================
# Additional Information
# ============================================================================

# Import Syntax:
# ──────────────
# Existing schemas can be imported using the registry name and schema name:
#
#   terraform import aws_schemas_schema.example registry-name/schema-name
#
# Example:
#   terraform import aws_schemas_schema.basic_example my-custom-registry/UserCreatedEvent

# Schema Lifecycle:
# ─────────────────
# - Schema versions are automatically managed by AWS EventBridge
# - When content is updated, a new version is created automatically
# - Old versions are retained and can be accessed via the AWS Console or API
# - Inactive schemas are deleted after 2 years (AWS managed lifecycle)

# Code Bindings:
# ──────────────
# After creating a schema, you can download code bindings for:
#   - Java
#   - Python
#   - TypeScript
#   - Go
#
# This enables type-safe event handling in your applications.
# Use AWS Toolkit for JetBrains or VS Code to browse and download bindings.

# Regional Considerations:
# ────────────────────────
# - Schemas are region-specific resources
# - For multi-region applications, replicate schemas to all required regions
# - Use the 'region' argument to override provider-level region
# - Consider using a centralized schema registry strategy

# IAM Permissions Required:
# ─────────────────────────
# - schemas:CreateSchema
# - schemas:DescribeSchema
# - schemas:UpdateSchema
# - schemas:DeleteSchema
# - schemas:TagResource
# - schemas:UntagResource
# - schemas:ListTagsForResource

# Related Resources:
# ──────────────────
# - aws_schemas_registry: Create custom schema registries
# - aws_schemas_discoverer: Auto-discover schemas from event bus
# - aws_cloudwatch_event_rule: Create rules that use schemas
# - aws_cloudwatch_event_bus: Event bus for schema-based events

# Cost Considerations:
# ────────────────────
# - No cost for schema storage (included in EventBridge service)
# - Schema registry API calls may incur charges
# - Consider consolidating related schemas into fewer registries

# Schema Validation:
# ──────────────────
# - EventBridge does not automatically validate events against schemas
# - Implement client-side validation using downloaded code bindings
# - Use JSONSchema format for runtime validation capabilities
# - Consider using schema validation in CI/CD pipeline

# Troubleshooting:
# ────────────────
# Common Issues:
# 1. Invalid schema format: Ensure JSON is valid OpenAPI 3.0 or JSONSchema Draft4
# 2. Schema name conflicts: Names must be unique within a registry
# 3. Content too large: Keep schemas concise, consider using $ref for reusability
# 4. Version conflicts: AWS manages versions automatically, don't specify version numbers

# ============================================================================
# End of aws_schemas_schema Resource Documentation
# ============================================================================
