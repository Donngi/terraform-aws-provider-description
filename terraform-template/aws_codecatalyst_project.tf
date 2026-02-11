################################################################################
# Terraform Resource: aws_codecatalyst_project
# Generated: 2026-01-19
# Provider Version: hashicorp/aws 6.28.0
#
# 注意: このテンプレートは生成時点の AWS Provider 仕様に基づいています。
#       最新の仕様については公式ドキュメントをご確認ください。
#       https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codecatalyst_project
################################################################################

resource "aws_codecatalyst_project" "example" {
  ################################################################################
  # Required Parameters
  ################################################################################

  # (Required) The name of the CodeCatalyst space where the project will be created.
  # CodeCatalyst spaces are collaborative workspaces that contain projects, repositories,
  # and other resources for development teams.
  # スペース名は、プロジェクトを作成する CodeCatalyst スペースの名前です。
  # AWS公式ドキュメント: https://docs.aws.amazon.com/codecatalyst/latest/userguide/concepts.html
  space_name = "myproject"

  # (Required) The friendly name of the project that will be displayed to users.
  # This is the display name shown in the CodeCatalyst console and to all project members.
  # プロジェクトの表示名は、ユーザーに表示されるわかりやすい名前です。
  # AWS公式ドキュメント: https://docs.aws.amazon.com/codecatalyst/latest/userguide/projects-create.html
  display_name = "MyProject"

  ################################################################################
  # Optional Parameters
  ################################################################################

  # (Optional) The description of the project.
  # This description will be displayed to all users of the project.
  # It is recommended to provide a brief description of the project and its intended purpose.
  # プロジェクトの説明は、すべてのプロジェクトユーザーに表示されます。
  # プロジェクトの目的を簡潔に説明することが推奨されます。
  # AWS公式ドキュメント: https://docs.aws.amazon.com/codecatalyst/latest/userguide/projects-create.html
  description = "My CodeCatalyst Project created using Terraform"

  # (Optional) The resource identifier.
  # Note: This is typically managed by Terraform and AWS. It can be optionally specified
  # for import scenarios, but in most cases should be omitted to allow automatic assignment.
  # 通常、Terraform と AWS によって自動的に管理されるため、指定する必要はありません。
  # id = "project-id"

  # (Optional) Region where this resource will be managed.
  # Defaults to the Region set in the provider configuration.
  # CodeCatalyst projects are regional resources, and this setting determines
  # the AWS region where the project metadata is stored.
  # リソースが管理されるリージョンを指定します。
  # 未指定の場合は、プロバイダー設定のリージョンがデフォルトで使用されます。
  # AWS公式ドキュメント: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-west-2"

  ################################################################################
  # Timeouts
  ################################################################################

  # (Optional) Configuration block for resource operation timeouts.
  # These settings control how long Terraform will wait for project operations to complete
  # before timing out and reporting an error.
  # タイムアウト設定は、Terraform がプロジェクト操作の完了を待機する時間を制御します。
  # timeouts {
  #   # (Optional) Timeout for create operations. Default is typically 30 minutes.
  #   # プロジェクト作成操作のタイムアウト時間を指定します。
  #   create = "30m"
  #
  #   # (Optional) Timeout for update operations. Default is typically 30 minutes.
  #   # プロジェクト更新操作のタイムアウト時間を指定します。
  #   update = "30m"
  #
  #   # (Optional) Timeout for delete operations. Default is typically 30 minutes.
  #   # プロジェクト削除操作のタイムアウト時間を指定します。
  #   delete = "30m"
  # }
}

################################################################################
# Outputs (Computed Attributes)
################################################################################

# The following attributes are available as outputs after resource creation:

# name - The name of the project in the space.
#        This is the unique identifier of the project within the CodeCatalyst space.
#        スペース内のプロジェクトの一意の識別子です。

# Example output configuration:
# output "codecatalyst_project_name" {
#   description = "The name of the CodeCatalyst project"
#   value       = aws_codecatalyst_project.example.name
# }
