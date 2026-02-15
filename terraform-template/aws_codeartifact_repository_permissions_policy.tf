#---------------------------------------
# aws_codeartifact_repository_permissions_policy
#---------------------------------------
# Provider Version: 6.28.0
# Generated: 2026-02-12
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/codeartifact_repository_permissions_policy
#
# NOTE:
# CodeArtifact リポジトリに対するアクセス許可ポリシーを管理します
# リソースベースのポリシーを使用して、他の AWS アカウントやプリンシパルに対してリポジトリへのアクセス権限を付与できます
#
# 主な用途:
# - クロスアカウントでのリポジトリアクセスの許可
# - 特定のIAMロールやユーザーに対するリポジトリ権限の付与
# - パッケージの読み取り、公開、削除などの細かい権限制御
#
# 制約事項:
# - ポリシードキュメントは有効なJSON形式のIAMポリシーである必要があります
# - ドメインとリポジトリは事前に存在している必要があります
# - ポリシーの変更は即座に反映されます

resource "aws_codeartifact_repository_permissions_policy" "example" {
  #---------------------------------------
  # 必須パラメータ
  #---------------------------------------

  # 設定内容: ドメイン名
  # 設定可能な値: CodeArtifact ドメイン名（2-50文字、小文字英数字とハイフン）
  # 省略時: エラー（必須）
  domain = "example-domain"

  # 設定内容: リポジトリ名
  # 設定可能な値: CodeArtifact リポジトリ名（2-100文字、小文字英数字とハイフンとアンダースコア）
  # 省略時: エラー（必須）
  repository = "example-repository"

  # 設定内容: リポジトリに適用するリソースベースのポリシードキュメント
  # 設定可能な値: JSON形式のIAMポリシードキュメント
  # 省略時: エラー（必須）
  policy_document = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::123456789012:root"
        }
        Action = [
          "codeartifact:ReadFromRepository",
          "codeartifact:DescribeRepository"
        ]
        Resource = "*"
      }
    ]
  })

  #---------------------------------------
  # オプションパラメータ - ドメイン所有者
  #---------------------------------------

  # 設定内容: ドメインの所有者である AWS アカウント ID
  # 設定可能な値: 12桁のAWSアカウントID
  # 省略時: 現在のアカウントIDが使用される
  domain_owner = "123456789012"

  #---------------------------------------
  # オプションパラメータ - リージョン
  #---------------------------------------

  # 設定内容: リソースを管理するリージョン
  # 設定可能な値: AWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンが使用される
  region = "us-east-1"

  #---------------------------------------
  # オプションパラメータ - ポリシーリビジョン
  #---------------------------------------

  # 設定内容: 現在のポリシーリビジョン
  # 設定可能な値: ポリシーリビジョン文字列（楽観的ロック制御に使用）
  # 省略時: 自動的に管理される
  policy_revision = "revision-string"
}

#---------------------------------------
# Attributes Reference
#---------------------------------------
# id              - リソースのID（フォーマット: arn:aws:codeartifact:region:account-id:repository/domain/repository）
# domain_owner    - ドメインの所有者のAWSアカウントID
# policy_revision - 現在のポリシーリビジョン
# resource_arn    - リソースのARN
# region          - リソースが管理されているリージョン
