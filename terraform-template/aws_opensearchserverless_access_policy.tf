################################################################################
# AWS OpenSearch Serverless Access Policy
################################################################################
# Terraform resource for managing an AWS OpenSearch Serverless Access Policy.
# Access policies define data access permissions for OpenSearch Serverless collections.
#
# See AWS documentation:
# - Data access policies: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/serverless-data-access.html
# - Supported permissions: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/serverless-data-access.html#serverless-data-supported-permissions
#
# Provider Version: 6.28.0
# Resource: aws_opensearchserverless_access_policy
################################################################################

################################################################################
# Example 1: Grant all collection and index permissions
################################################################################
# This example grants full permissions (aoss:*) to all indexes and the collection
# to the current AWS account identity.

data "aws_caller_identity" "current" {}

resource "aws_opensearchserverless_access_policy" "full_access" {
  # REQUIRED: Name of the policy.
  # Must be unique within your AWS account.
  name = "example-full-access"

  # REQUIRED: Type of access policy.
  # Must be "data" - this is the only valid type for OpenSearch Serverless.
  type = "data"

  # OPTIONAL: Description of the policy.
  # Typically used to store information about the permissions defined in the policy.
  description = "Full read and write permissions for example collection"

  # REQUIRED: JSON policy document to use as the content for the new policy.
  # The policy defines:
  # - Rules: List of permission rules
  #   - ResourceType: Type of resource ("index" or "collection")
  #   - Resource: List of resource patterns to match
  #   - Permission: List of allowed permissions
  # - Principal: List of principals (IAM ARNs or SAML identities) granted access
  policy = jsonencode([
    {
      Rules = [
        {
          # Grant permissions for indexes
          ResourceType = "index"
          Resource = [
            "index/example-collection/*" # All indexes in the collection
          ]
          Permission = [
            "aoss:*" # All index operations
          ]
        },
        {
          # Grant permissions for the collection itself
          ResourceType = "collection"
          Resource = [
            "collection/example-collection"
          ]
          Permission = [
            "aoss:*" # All collection operations
          ]
        }
      ]
      Principal = [
        data.aws_caller_identity.current.arn
      ]
    }
  ])

  # OPTIONAL: Region where this resource will be managed.
  # Defaults to the Region set in the provider configuration.
  # Reference: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"
}

################################################################################
# Example 2: Grant read-only collection and index permissions
################################################################################
# This example grants minimal read-only permissions for searching and describing
# collection resources.

resource "aws_opensearchserverless_access_policy" "read_only" {
  name        = "example-read-only"
  type        = "data"
  description = "Read-only permissions for example collection"

  # Available index permissions for read-only access:
  # - aoss:DescribeIndex: Describe index metadata
  # - aoss:ReadDocument: Search and read documents
  #
  # Available collection permissions for read-only access:
  # - aoss:DescribeCollectionItems: Describe collection metadata
  policy = jsonencode([
    {
      Rules = [
        {
          ResourceType = "index"
          Resource = [
            "index/example-collection/*"
          ]
          Permission = [
            "aoss:DescribeIndex",
            "aoss:ReadDocument",
          ]
        },
        {
          ResourceType = "collection"
          Resource = [
            "collection/example-collection"
          ]
          Permission = [
            "aoss:DescribeCollectionItems"
          ]
        }
      ]
      Principal = [
        data.aws_caller_identity.current.arn
      ]
    }
  ])
}

################################################################################
# Example 3: Grant SAML identity permissions
################################################################################
# This example grants permissions to SAML federated users and groups.

resource "aws_opensearchserverless_access_policy" "saml" {
  name        = "example-saml"
  type        = "data"
  description = "SAML federated identity permissions"

  # SAML principal format: saml/{account-id}/{provider-name}/{type}/{name}
  # - type: "user" or "group"
  # - name: The SAML user or group name
  policy = jsonencode([
    {
      Rules = [
        {
          ResourceType = "index"
          Resource = [
            "index/example-collection/*"
          ]
          Permission = [
            "aoss:*"
          ]
        },
        {
          ResourceType = "collection"
          Resource = [
            "collection/example-collection"
          ]
          Permission = [
            "aoss:*"
          ]
        }
      ]
      Principal = [
        "saml/123456789012/myprovider/user/Annie",
        "saml/123456789012/anotherprovider/group/Accounting"
      ]
    }
  ])
}

################################################################################
# Example 4: Granular write permissions
################################################################################
# This example demonstrates specific write permissions for different operations.

resource "aws_opensearchserverless_access_policy" "write" {
  name        = "example-write"
  type        = "data"
  description = "Write permissions for data ingestion"

  # Available write permissions:
  # - aoss:CreateIndex: Create new indexes
  # - aoss:WriteDocument: Index/update/delete documents
  # - aoss:UpdateIndex: Update index settings
  # - aoss:DeleteIndex: Delete indexes
  policy = jsonencode([
    {
      Rules = [
        {
          ResourceType = "index"
          Resource = [
            "index/example-collection/logs-*" # Only indexes matching pattern
          ]
          Permission = [
            "aoss:CreateIndex",
            "aoss:WriteDocument",
            "aoss:UpdateIndex",
            "aoss:DescribeIndex"
          ]
        },
        {
          ResourceType = "collection"
          Resource = [
            "collection/example-collection"
          ]
          Permission = [
            "aoss:DescribeCollectionItems",
            "aoss:CreateCollectionItems"
          ]
        }
      ]
      Principal = [
        data.aws_caller_identity.current.arn
      ]
    }
  ])
}

################################################################################
# Example 5: Multi-principal access policy
################################################################################
# This example grants different permissions to multiple principals.

resource "aws_opensearchserverless_access_policy" "multi_principal" {
  name        = "example-multi-principal"
  type        = "data"
  description = "Multiple principals with different permission levels"

  policy = jsonencode([
    {
      # Admin principals with full access
      Rules = [
        {
          ResourceType = "index"
          Resource     = ["index/example-collection/*"]
          Permission   = ["aoss:*"]
        },
        {
          ResourceType = "collection"
          Resource     = ["collection/example-collection"]
          Permission   = ["aoss:*"]
        }
      ]
      Principal = [
        "arn:aws:iam::123456789012:role/AdminRole"
      ]
    },
    {
      # Read-only principals
      Rules = [
        {
          ResourceType = "index"
          Resource     = ["index/example-collection/*"]
          Permission = [
            "aoss:DescribeIndex",
            "aoss:ReadDocument"
          ]
        },
        {
          ResourceType = "collection"
          Resource     = ["collection/example-collection"]
          Permission   = ["aoss:DescribeCollectionItems"]
        }
      ]
      Principal = [
        "arn:aws:iam::123456789012:role/ReadOnlyRole",
        "arn:aws:iam::123456789012:user/readonly-user"
      ]
    }
  ])
}

################################################################################
# Output Examples
################################################################################
# These outputs demonstrate the available attributes.

output "access_policy_full_access_version" {
  description = "Policy version of the full access policy"
  value       = aws_opensearchserverless_access_policy.full_access.policy_version
}

output "access_policy_read_only_id" {
  description = "ID (name) of the read-only access policy"
  value       = aws_opensearchserverless_access_policy.read_only.id
}

################################################################################
# Available Permissions Reference
################################################################################
# Collection-level permissions:
# - aoss:DescribeCollectionItems: View collection metadata
# - aoss:CreateCollectionItems: Create items in collection
# - aoss:UpdateCollectionItems: Update collection items
# - aoss:DeleteCollectionItems: Delete collection items
# - aoss:*: All collection permissions
#
# Index-level permissions:
# - aoss:CreateIndex: Create new indexes
# - aoss:DeleteIndex: Delete indexes
# - aoss:UpdateIndex: Update index settings
# - aoss:DescribeIndex: View index metadata
# - aoss:ReadDocument: Search and read documents
# - aoss:WriteDocument: Index, update, and delete documents
# - aoss:*: All index permissions
#
# Principal formats:
# - IAM user: arn:aws:iam::account-id:user/username
# - IAM role: arn:aws:iam::account-id:role/rolename
# - SAML user: saml/account-id/provider-name/user/username
# - SAML group: saml/account-id/provider-name/group/groupname
################################################################################

################################################################################
# Important Notes
################################################################################
# 1. Access policies are separate from network and encryption policies in
#    OpenSearch Serverless. All three types must be configured for a collection.
#
# 2. The "type" parameter must always be "data" - this is currently the only
#    supported access policy type.
#
# 3. Resource patterns support wildcards (*) for flexible matching:
#    - index/collection/*: All indexes in collection
#    - index/collection/prefix-*: Indexes matching prefix
#
# 4. Changes to access policies may take a few minutes to propagate.
#
# 5. The policy_version attribute is automatically incremented when the policy
#    is updated.
#
# 6. Access policies can be attached to multiple collections by using collection
#    wildcards in the Resource field.
#
# 7. For SAML principals, ensure the SAML provider is configured in IAM before
#    creating the access policy.
################################################################################
