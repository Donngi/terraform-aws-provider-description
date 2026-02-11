################################################################################
# AWS CodeCatalyst Source Repository
################################################################################
# 生成日: 2026-01-19
# Provider Version: 6.28.0
#
# 注意: このテンプレートは生成時点の AWS Provider 仕様に基づいています。
#       最新の仕様については、以下の公式ドキュメントを参照してください。
#       https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codecatalyst_source_repository
################################################################################

resource "aws_codecatalyst_source_repository" "example" {
  ################################################################################
  # 必須パラメータ
  ################################################################################

  # リポジトリ名
  # CodeCatalystプロジェクト内で一意である必要があります。
  # 命名規則の詳細: https://docs.aws.amazon.com/codecatalyst/latest/userguide/source-quotas.html
  # 例: "my-application-repo", "backend-service"
  name = "example-repo"

  # CodeCatalystスペース名
  # このリポジトリが作成されるCodeCatalystスペースの名前を指定します。
  # スペースはAWS Builder IDまたはIAM Identity Centerによる認証を使用します。
  # 例: "my-organization-space"
  space_name = "example-space"

  # CodeCatalystプロジェクト名
  # このリポジトリが属するプロジェクトの名前を指定します。
  # プロジェクトはチームメンバー間で共有され、リソースやユーザーを管理します。
  # 例: "web-application-project"
  project_name = "example-project"

  ################################################################################
  # オプションパラメータ
  ################################################################################

  # リポジトリの説明
  # このリポジトリの目的や内容を説明するテキストです。
  # プロジェクトメンバー全員に表示されます。
  # 例: "Main application repository for the customer portal"
  description = "Example source repository for CodeCatalyst"

  # リソースID
  # 通常は自動的に計算されるため、明示的に指定する必要はありません。
  # 指定した場合、その値がリソースIDとして使用されます。
  # デフォルト: 自動計算（リポジトリ名が使用されます）
  # id = "custom-id"

  # AWS リージョン
  # このリソースが管理されるAWSリージョンを指定します。
  # 指定しない場合、プロバイダー設定のリージョンが使用されます。
  # CodeCatalystはグローバルサービスですが、リソースは特定のリージョンで管理されます。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # 例: "us-west-2", "ap-northeast-1"
  # region = "us-west-2"

  ################################################################################
  # タイムアウト設定
  ################################################################################

  # リソース操作のタイムアウト時間を設定します。
  # デフォルト値が適切でない場合に調整してください。
  timeouts {
    # リポジトリ作成時のタイムアウト時間
    # デフォルト: 設定なし
    # 例: "10m" (10分)
    # create = "10m"

    # リポジトリ更新時のタイムアウト時間
    # デフォルト: 設定なし
    # 例: "10m" (10分)
    # update = "10m"

    # リポジトリ削除時のタイムアウト時間
    # デフォルト: 設定なし
    # 例: "10m" (10分)
    # delete = "10m"
  }
}

################################################################################
# 出力値の例
################################################################################

# リポジトリID（リポジトリ名と同じ値）
# output "repository_id" {
#   description = "The ID of the CodeCatalyst source repository"
#   value       = aws_codecatalyst_source_repository.example.id
# }

################################################################################
# 参考リンク
################################################################################
# - Terraform AWS Provider ドキュメント:
#   https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codecatalyst_source_repository
#
# - AWS CodeCatalyst ソースリポジトリの作成:
#   https://docs.aws.amazon.com/codecatalyst/latest/userguide/source-repositories-create.html
#
# - AWS CodeCatalyst ソースリポジトリの概念:
#   https://docs.aws.amazon.com/codecatalyst/latest/userguide/source-concepts.html
#
# - CodeCatalystのクォータ:
#   https://docs.aws.amazon.com/codecatalyst/latest/userguide/source-quotas.html
################################################################################
