################################################################################
# Resource: aws_opensearch_package_association
# Provider Version: 6.28.0
#
# Description:
#   Manages an AWS OpenSearch Package Association. This resource associates
#   a package (such as custom dictionaries or analyzers) with an OpenSearch domain.
#
# Official Documentation:
#   https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/opensearch_package_association
#
# AWS Documentation:
#   https://docs.aws.amazon.com/opensearch-service/latest/developerguide/custom-packages.html
################################################################################

resource "aws_opensearch_package_association" "example" {
  ################################################################################
  # Required Arguments
  ################################################################################

  # package_id - (Required, Forces new resource)
  # Description: Internal ID of the package to associate with a domain.
  #              This is the unique identifier of the OpenSearch package resource
  #              that you want to associate with the domain.
  # Type: string
  # Forces new resource: yes
  #
  # Example values:
  #   package_id = aws_opensearch_package.example.id
  #   package_id = "F123456789"
  #
  # AWS Constraints:
  #   - Must be a valid package ID
  #   - Package must exist in the same AWS account
  #   - Package must be in 'AVAILABLE' state before association
  #
  # Notes:
  #   - Once set, changing this value will force recreation of the resource
  #   - Ensure the package is fully uploaded and available before creating association
  package_id = aws_opensearch_package.example.id

  # domain_name - (Required, Forces new resource)
  # Description: Name of the OpenSearch domain to associate the package with.
  #              This must be the name of an existing OpenSearch domain in your account.
  # Type: string
  # Forces new resource: yes
  #
  # Example values:
  #   domain_name = aws_opensearch_domain.my_domain.domain_name
  #   domain_name = "my-opensearch-domain"
  #
  # AWS Constraints:
  #   - Must be 3-28 characters
  #   - Must start with a lowercase letter
  #   - Can contain lowercase letters, numbers, and hyphens
  #   - Domain must exist and be in 'Active' state
  #
  # Notes:
  #   - Once set, changing this value will force recreation of the resource
  #   - The domain must be in a compatible state to accept package associations
  #   - Some package types may require specific OpenSearch/Elasticsearch versions
  domain_name = aws_opensearch_domain.my_domain.domain_name

  ################################################################################
  # Optional Arguments
  ################################################################################

  # region - (Optional)
  # Description: Region where this resource will be managed.
  #              Defaults to the region set in the provider configuration.
  # Type: string
  # Default: Provider region
  #
  # Example values:
  #   region = "us-east-1"
  #   region = "eu-west-1"
  #
  # Notes:
  #   - Typically not needed as provider region is used by default
  #   - Use when you need to manage resources in a different region than provider
  #   - Both package and domain must exist in the specified region
  # region = "us-east-1"

  ################################################################################
  # Attribute Reference (Read-only attributes exported by this resource)
  ################################################################################

  # In addition to all arguments above, the following attributes are exported:
  #
  # id - The ID of the package association
  #      Format: <package_id>/<domain_name>
  #      Example: F123456789/my-opensearch-domain
}

################################################################################
# Additional Examples
################################################################################

# Example 1: Complete package association with custom dictionary
# This example shows how to create an S3 bucket, upload a dictionary file,
# create a package, and associate it with an OpenSearch domain.

resource "aws_s3_bucket" "my_opensearch_packages" {
  bucket = "my-opensearch-packages-bucket"
}

resource "aws_s3_object" "dictionary" {
  bucket = aws_s3_bucket.my_opensearch_packages.bucket
  key    = "dictionaries/custom-dictionary.txt"
  source = "path/to/local/custom-dictionary.txt"
  etag   = filemd5("path/to/local/custom-dictionary.txt")
}

resource "aws_opensearch_domain" "my_domain" {
  domain_name    = "my-opensearch-domain"
  engine_version = "OpenSearch_2.11"

  cluster_config {
    instance_type  = "r6g.large.search"
    instance_count = 2
  }

  ebs_options {
    ebs_enabled = true
    volume_size = 20
    volume_type = "gp3"
  }
}

resource "aws_opensearch_package" "custom_dictionary" {
  package_name = "custom-dictionary"
  package_type = "TXT-DICTIONARY"

  package_source {
    s3_bucket_name = aws_s3_bucket.my_opensearch_packages.bucket
    s3_key         = aws_s3_object.dictionary.key
  }

  package_description = "Custom dictionary for text analysis"
}

resource "aws_opensearch_package_association" "custom_dictionary" {
  package_id  = aws_opensearch_package.custom_dictionary.id
  domain_name = aws_opensearch_domain.my_domain.domain_name

  # Wait for domain to be ready
  depends_on = [
    aws_opensearch_domain.my_domain,
    aws_opensearch_package.custom_dictionary
  ]
}

# Example 2: Multiple package associations
# Associate multiple packages with the same domain

resource "aws_opensearch_package" "synonyms" {
  package_name = "custom-synonyms"
  package_type = "TXT-DICTIONARY"

  package_source {
    s3_bucket_name = aws_s3_bucket.my_opensearch_packages.bucket
    s3_key         = "dictionaries/synonyms.txt"
  }
}

resource "aws_opensearch_package_association" "synonyms" {
  package_id  = aws_opensearch_package.synonyms.id
  domain_name = aws_opensearch_domain.my_domain.domain_name
}

resource "aws_opensearch_package" "stopwords" {
  package_name = "custom-stopwords"
  package_type = "TXT-DICTIONARY"

  package_source {
    s3_bucket_name = aws_s3_bucket.my_opensearch_packages.bucket
    s3_key         = "dictionaries/stopwords.txt"
  }
}

resource "aws_opensearch_package_association" "stopwords" {
  package_id  = aws_opensearch_package.stopwords.id
  domain_name = aws_opensearch_domain.my_domain.domain_name
}

################################################################################
# Important Notes and Best Practices
################################################################################

# 1. Package Types:
#    - TXT-DICTIONARY: For custom dictionaries (synonyms, stopwords, etc.)
#    - ZIP-PLUGIN: For custom analyzer plugins
#
# 2. Package State Requirements:
#    - The package must be in 'AVAILABLE' state before association
#    - The domain must be in 'Active' state
#    - Association process may take several minutes
#
# 3. Version Compatibility:
#    - Ensure package is compatible with domain's OpenSearch/Elasticsearch version
#    - Some packages may only work with specific versions
#
# 4. Package Usage:
#    - After association, packages can be referenced in index settings
#    - Custom dictionaries are used in analyzers
#    - Changes to package content require reassociation
#
# 5. Dissociation:
#    - Deleting this resource will dissociate the package from the domain
#    - The package itself is not deleted
#    - Indices using the package may need to be reindexed
#
# 6. IAM Permissions Required:
#    - es:AssociatePackage
#    - es:DescribePackages
#    - es:DescribeDomain
#    - s3:GetObject (for package source)
#
# 7. Lifecycle Considerations:
#    - Use depends_on to ensure domain and package are ready
#    - Consider using timeouts for association operations
#    - Monitor CloudWatch for association status
#
# 8. Cost Considerations:
#    - No additional cost for package association itself
#    - S3 storage costs for package files
#    - Potential compute impact when applying custom analyzers
#
# 9. Limitations:
#    - Maximum package size varies by package type
#    - Limited number of packages per domain (check AWS limits)
#    - Cannot associate same package twice to same domain
#
# 10. Troubleshooting:
#     - Check package is in AVAILABLE state: aws opensearch describe-packages
#     - Verify domain is Active: aws opensearch describe-domain
#     - Review CloudWatch logs for association errors
#     - Ensure IAM roles have necessary permissions

################################################################################
# Related Resources
################################################################################

# - aws_opensearch_domain: The OpenSearch domain to associate with
# - aws_opensearch_package: The package to associate
# - aws_s3_bucket: Bucket storing the package source files
# - aws_s3_object: Package source file in S3
# - aws_iam_role: IAM role for OpenSearch service access

################################################################################
# Terraform Import
################################################################################

# Package associations can be imported using the package_id and domain_name:
#
# terraform import aws_opensearch_package_association.example F123456789/my-opensearch-domain
#
# Format: <package_id>/<domain_name>
