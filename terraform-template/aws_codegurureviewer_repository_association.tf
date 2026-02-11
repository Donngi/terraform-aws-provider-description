#
# Terraform Resource: aws_codegurureviewer_repository_association
#
# AWS Provider Version: 6.28.0
# Generated: 2026-01-19
#
# This template is auto-generated and reflects the resource schema at the time of generation.
# For the latest specifications and updates, always refer to the official documentation:
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codegurureviewer_repository_association
#
# Note: As of November 7, 2025, new repository associations cannot be created in Amazon CodeGuru Reviewer.
#

resource "aws_codegurureviewer_repository_association" "example" {
  #================================================
  # Required Arguments
  #================================================

  # repository - (Required) Configuration block for the repository to associate.
  # Must specify exactly one of: codecommit, bitbucket, github_enterprise_server, or s3_bucket.
  # Note: For repositories that leverage CodeStar connections (ex. bitbucket, github_enterprise_server),
  # the connection must be in "Available" status prior to creating this resource.
  # https://docs.aws.amazon.com/codeguru/latest/reviewer-ug/working-with-repositories.html
  repository {
    # Option 1: AWS CodeCommit Repository
    # Uncomment to use CodeCommit repository
    # codecommit {
    #   # name - (Required) The name of the AWS CodeCommit repository.
    #   name = "example-repository"
    # }

    # Option 2: Bitbucket Repository
    # Uncomment to use Bitbucket repository (requires CodeStar connection)
    # bitbucket {
    #   # connection_arn - (Required) The Amazon Resource Name (ARN) of the AWS CodeStar connection.
    #   # The connection must be in "Available" status.
    #   connection_arn = "arn:aws:codestar-connections:us-west-2:123456789012:connection/example"
    #
    #   # name - (Required) The name of the third party source repository.
    #   name = "example-repo"
    #
    #   # owner - (Required) The username for the account that owns the repository.
    #   owner = "example-owner"
    # }

    # Option 3: GitHub Enterprise Server Repository
    # Uncomment to use GitHub Enterprise Server repository (requires CodeStar connection)
    # github_enterprise_server {
    #   # connection_arn - (Required) The Amazon Resource Name (ARN) of the AWS CodeStar connection.
    #   # The connection must be in "Available" status.
    #   connection_arn = "arn:aws:codestar-connections:us-west-2:123456789012:connection/example"
    #
    #   # name - (Required) The name of the third party source repository.
    #   name = "example-repo"
    #
    #   # owner - (Required) The username for the account that owns the repository.
    #   owner = "example-owner"
    # }

    # Option 4: S3 Bucket Repository
    # Uncomment to use S3 bucket as repository
    # s3_bucket {
    #   # bucket_name - (Required) The name of the S3 bucket used for associating a new S3 repository.
    #   bucket_name = "example-bucket"
    #
    #   # name - (Required) The name of the repository in the S3 bucket.
    #   name = "example-repository"
    # }
  }

  #================================================
  # Optional Arguments
  #================================================

  # region - (Optional) Region where this resource will be managed.
  # Defaults to the Region set in the provider configuration.
  # https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-west-2"

  # tags - (Optional) Key-value map of resource tags.
  # https://docs.aws.amazon.com/general/latest/gr/aws_tagging.html
  tags = {
    Name        = "example-repository-association"
    Environment = "production"
  }

  #================================================
  # Optional Blocks
  #================================================

  # kms_key_details - (Optional) Configuration block for KMS encryption details.
  # By default, all associated repositories are encrypted using an AWS-managed key.
  # You can optionally encrypt using a customer-managed KMS key.
  # https://docs.aws.amazon.com/codeguru/latest/reviewer-ug/encrypt-repository-association.html
  kms_key_details {
    # encryption_option - (Optional) The encryption option for the repository association.
    # Valid values: "AWS_OWNED_CMK" (default, AWS-managed key) or "CUSTOMER_MANAGED_CMK" (customer-managed key).
    # https://docs.aws.amazon.com/codeguru/latest/reviewer-api/API_KMSKeyDetails.html
    encryption_option = "CUSTOMER_MANAGED_CMK"

    # kms_key_id - (Optional) The ID of the AWS KMS key that is associated with the repository association.
    # Required when encryption_option is set to "CUSTOMER_MANAGED_CMK".
    # Can be a key ID, key ARN, alias name, or alias ARN.
    # Length: 1-2048 characters. Pattern: [a-zA-Z0-9-]+
    # Note: Disabling or removing CodeGuru Reviewer access to this key will result in
    # unavailability of related recommendations and inability to review code.
    kms_key_id = "arn:aws:kms:us-west-2:123456789012:key/12345678-1234-1234-1234-123456789012"
  }

  # timeouts - (Optional) Configuration block for resource operation timeouts.
  timeouts {
    # create - (Optional) How long to wait for the repository association to be created.
    # Default: 30 minutes
    create = "30m"

    # update - (Optional) How long to wait for the repository association to be updated.
    # Default: 30 minutes
    update = "30m"

    # delete - (Optional) How long to wait for the repository association to be deleted.
    # Default: 30 minutes
    delete = "30m"
  }

  #================================================
  # Computed Attributes (Read-Only)
  #================================================
  # The following attributes are exported by the resource but cannot be set:
  #
  # - arn: The Amazon Resource Name (ARN) identifying the repository association.
  # - association_id: The ID of the repository association.
  # - connection_arn: The Amazon Resource Name (ARN) of an AWS CodeStar Connections connection.
  # - id: The Amazon Resource Name (ARN) identifying the repository association.
  # - name: The name of the repository.
  # - owner: The owner of the repository.
  # - provider_type: The provider type of the repository association (e.g., CodeCommit, Bitbucket, GitHubEnterpriseServer, S3Bucket).
  # - state: The state of the repository association (e.g., Associated, Associating, Failed, Disassociating, Disassociated).
  # - state_reason: A description of why the repository association is in the current state.
  # - s3_repository_details: Details about the S3 repository (only populated for S3 bucket associations).
  #================================================

  # Lifecycle considerations:
  # - The association status is initially "Associating" during setup.
  # - Once complete, status changes to "Associated" and CodeGuru Reviewer performs its first full scan.
  # - For CodeCommit repositories, consider using lifecycle ignore_changes for the "codeguru-reviewer" tag
  #   that is automatically added by the CodeGuru service.
  #
  # lifecycle {
  #   ignore_changes = [
  #     tags["codeguru-reviewer"]
  #   ]
  # }
}

#================================================
# Additional Notes
#================================================
#
# 1. Repository Association Prerequisites:
#    - For CodeCommit: Repository must exist in the same AWS account and region
#    - For Bitbucket/GitHub Enterprise: CodeStar connection must be in "Available" status
#    - For S3: Bucket must be accessible and contain source code artifacts
#
# 2. Encryption:
#    - Default encryption uses AWS-managed keys (no additional cost)
#    - Customer-managed KMS keys incur additional charges
#    - To change encryption method, you must disassociate and recreate the association
#
# 3. Code Review Process:
#    - CodeGuru Reviewer automatically reviews source code changes in pull requests
#    - Source code is transiently stored in memory and encrypted before being stored in S3 for up to 10 days
#    - Repository metadata is retained until disassociation
#    - Recommendations are retained for one year before deletion
#
# 4. Service Availability:
#    - As of November 7, 2025, new repository associations cannot be created
#    - Existing associations continue to function
#
# 5. Permissions Required:
#    - IAM permissions for codeguru-reviewer:AssociateRepository
#    - IAM permissions for the source repository (CodeCommit, CodeStar Connections, S3)
#    - If using customer-managed KMS key: kms:Decrypt, kms:GenerateDataKey permissions
#
# References:
# - Resource Documentation: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codegurureviewer_repository_association
# - API Reference: https://docs.aws.amazon.com/codeguru/latest/reviewer-api/API_AssociateRepository.html
# - User Guide: https://docs.aws.amazon.com/codeguru/latest/reviewer-ug/working-with-repositories.html
# - KMS Encryption: https://docs.aws.amazon.com/codeguru/latest/reviewer-ug/encrypt-repository-association.html
# - Data Protection: https://docs.aws.amazon.com/codeguru/latest/reviewer-ug/data-protection.html
#================================================
