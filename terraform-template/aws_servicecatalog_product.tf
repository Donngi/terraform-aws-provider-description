################################################################################
# AWS Service Catalog Product
################################################################################
# Manages a Service Catalog Product.
#
# NOTE: The user or role that uses this resources must have the
# cloudformation:GetTemplate IAM policy permission. This policy permission is
# required when using the template_physical_id argument.
#
# A "provisioning artifact" is also referred to as a "version."
# A "distributor" is also referred to as a "vendor."
#
# Reference: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/servicecatalog_product
################################################################################

resource "aws_servicecatalog_product" "this" {
  ################################################################################
  # Required Arguments
  ################################################################################

  # (Required) Name of the product.
  # Type: string
  name = "example-product"

  # (Required) Owner of the product.
  # Type: string
  owner = "IT Department"

  # (Required) Type of product.
  # Valid values: CLOUD_FORMATION_TEMPLATE, MARKETPLACE, TERRAFORM_CLOUD, TERRAFORM_OPEN_SOURCE
  # Type: string
  # Reference: https://docs.aws.amazon.com/servicecatalog/latest/dg/API_CreateProduct.html#API_CreateProduct_RequestSyntax
  type = "CLOUD_FORMATION_TEMPLATE"

  ################################################################################
  # Optional Arguments
  ################################################################################

  # (Optional) Language code.
  # Valid values: en (English), jp (Japanese), zh (Chinese)
  # Default: en
  # Type: string
  accept_language = "en"

  # (Optional) Description of the product.
  # Type: string
  description = "Example Service Catalog product"

  # (Optional) Distributor (i.e., vendor) of the product.
  # Type: string
  distributor = "Example Distributor"

  # (Optional) Region where this resource will be managed.
  # Defaults to the Region set in the provider configuration.
  # Type: string
  # Reference: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  # (Optional) Support information about the product.
  # Type: string
  support_description = "Contact our support team for assistance"

  # (Optional) Contact email for product support.
  # Type: string
  support_email = "support@example.com"

  # (Optional) Contact URL for product support.
  # Type: string
  support_url = "https://support.example.com"

  # (Optional) Tags to apply to the product.
  # If configured with a provider default_tags configuration block, tags with
  # matching keys will overwrite those defined at the provider-level.
  # Type: map(string)
  tags = {
    Environment = "production"
    ManagedBy   = "Terraform"
  }

  ################################################################################
  # Nested Blocks
  ################################################################################

  # (Required) Configuration block for provisioning artifact (i.e., version) parameters.
  # NOTE: This block is required and must contain exactly one entry.
  provisioning_artifact_parameters {
    # (Optional) Description of the provisioning artifact (i.e., version),
    # including how it differs from the previous provisioning artifact.
    # Type: string
    description = "Initial version of the product"

    # (Optional) Whether AWS Service Catalog stops validating the specified
    # provisioning artifact template even if it is invalid.
    # Type: bool
    disable_template_validation = false

    # (Optional) Name of the provisioning artifact (for example, v1, v2beta).
    # No spaces are allowed.
    # Type: string
    name = "v1.0"

    # (Required if template_url is not provided) Template source as the physical
    # ID of the resource that contains the template. Currently only supports
    # CloudFormation stack ARN.
    # Format: arn:[partition]:cloudformation:[region]:[account ID]:stack/[stack name]/[resource ID]
    # Type: string
    # NOTE: Either template_physical_id or template_url must be provided.
    # template_physical_id = "arn:aws:cloudformation:us-east-1:123456789012:stack/example-stack/12345678-1234-1234-1234-123456789012"

    # (Required if template_physical_id is not provided) Template source as URL
    # of the CloudFormation template in Amazon S3.
    # Type: string
    # NOTE: Either template_physical_id or template_url must be provided.
    template_url = "https://s3.amazonaws.com/cf-templates-example-us-east-1/product-template.json"

    # (Optional) Type of provisioning artifact.
    # Valid values: CLOUD_FORMATION_TEMPLATE, MARKETPLACE_AMI, MARKETPLACE_CAR,
    # TERRAFORM_CLOUD, TERRAFORM_OPEN_SOURCE
    # Type: string
    # Reference: https://docs.aws.amazon.com/servicecatalog/latest/dg/API_ProvisioningArtifactProperties.html
    type = "CLOUD_FORMATION_TEMPLATE"
  }

  ################################################################################
  # Timeouts (Optional)
  ################################################################################

  # timeouts {
  #   create = "5m"
  #   update = "5m"
  #   delete = "5m"
  #   read   = "5m"
  # }
}

################################################################################
# Outputs
################################################################################

# (Computed) ARN of the product.
# Type: string
output "servicecatalog_product_arn" {
  description = "ARN of the Service Catalog product"
  value       = aws_servicecatalog_product.this.arn
}

# (Computed) Product ID. For example, prod-dnigbtea24ste.
# Type: string
output "servicecatalog_product_id" {
  description = "ID of the Service Catalog product"
  value       = aws_servicecatalog_product.this.id
}

# (Computed) Time when the product was created.
# Type: string
output "servicecatalog_product_created_time" {
  description = "Time when the Service Catalog product was created"
  value       = aws_servicecatalog_product.this.created_time
}

# (Computed) Whether the product has a default path.
# If the product does not have a default path, call ListLaunchPaths to
# disambiguate between paths. Otherwise, ListLaunchPaths is not required,
# and the output of ProductViewSummary can be used directly with
# DescribeProvisioningParameters.
# Type: bool
output "servicecatalog_product_has_default_path" {
  description = "Whether the Service Catalog product has a default path"
  value       = aws_servicecatalog_product.this.has_default_path
}

# (Computed) Status of the product.
# Type: string
output "servicecatalog_product_status" {
  description = "Status of the Service Catalog product"
  value       = aws_servicecatalog_product.this.status
}

# (Computed) A map of tags assigned to the resource, including those inherited
# from the provider default_tags configuration block.
# Type: map(string)
output "servicecatalog_product_tags_all" {
  description = "All tags assigned to the Service Catalog product"
  value       = aws_servicecatalog_product.this.tags_all
}
