#---------------------------------------------------------------
# AWS CodeCommit Repository
#---------------------------------------------------------------
#
# AWS CodeCommitのGitリポジトリを作成・管理します。
# ソースコード管理、バージョン管理、コラボレーションのための
# 完全マネージド型Gitサービスを提供します。
#
# AWS公式ドキュメント:
#   - CodeCommit概要: https://docs.aws.amazon.com/codecommit/latest/userguide/welcome.html
#   - リポジトリの作成: https://docs.aws.amazon.com/codecommit/latest/userguide/how-to-create-repository.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codecommit_repository
#
# Provider Version: 6.28.0
# Generated: 2026-02-12
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_codecommit_repository" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # repository_name (Required)
  # 設定内容: CodeCommitリポジトリの名前を指定します。
  # 設定可能な値: 1-100文字、英数字とハイフン、アンダースコア、ピリオドのみ使用可能
  # 注意: リソース作成後の変更はできません（Forces new resource）
  repository_name = "example-repository"

  # description (Optional)
  # 設定内容: リポジトリの用途や内容を説明するテキストを指定します。
  # 設定可能な値: 最大1000文字の文字列
  # 省略時: 説明なし
  description = "Example CodeCommit repository for application source code"

  # default_branch (Optional)
  # 設定内容: リポジトリのデフォルトブランチとして使用するブランチ名を指定します。
  # 設定可能な値: 有効なGitブランチ名（既存のブランチである必要がある）
  # 省略時: デフォルトブランチは設定されない（最初のコミット後に設定可能）
  # 注意: ブランチが存在しない場合はエラーになります
  default_branch = "main"

  #-------------------------------------------------------------
  # 暗号化設定
  #-------------------------------------------------------------

  # kms_key_id (Optional)
  # 設定内容: リポジトリデータの暗号化に使用するAWS KMSキーのID、ARN、またはエイリアスを指定します。
  # 設定可能な値:
  #   - KMSキーID（例: 1234abcd-12ab-34cd-56ef-1234567890ab）
  #   - KMSキーARN（例: arn:aws:kms:us-east-1:123456789012:key/1234abcd-12ab-34cd-56ef-1234567890ab）
  #   - KMSエイリアス（例: alias/example-codecommit-key）
  # 省略時: AWS管理のキー（aws/codecommit）を使用
  # 関連機能: KMS暗号化
  #   CodeCommitはデフォルトでAWS管理キーを使用して暗号化されますが、
  #   カスタマー管理キーを使用することでより詳細な制御が可能になります。
  #   - https://docs.aws.amazon.com/codecommit/latest/userguide/encryption.html
  kms_key_id = "alias/example-codecommit-key"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = "ap-northeast-1"

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リポジトリに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ（最大50タグまで）
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "example-repository"
    Environment = "production"
    Project     = "example-project"
    ManagedBy   = "terraform"
  }

  #-------------------------------------------------------------
  # Attributes Reference（参照専用属性）
  #-------------------------------------------------------------
  # 以下の属性は、リソース作成後に参照可能な読み取り専用の値です:
  # - id                 : リポジトリ名（repository_nameと同じ値）
  # - arn                : リポジトリのARN（例: arn:aws:codecommit:ap-northeast-1:123456789012:example-repository）
  # - repository_id      : リポジトリの一意識別子（UUID形式）
  # - clone_url_http     : HTTPSプロトコルを使用したリポジトリのクローンURL
  # - clone_url_ssh      : SSHプロトコルを使用したリポジトリのクローンURL
  # - tags_all           : デフォルトタグを含む全てのタグのマップ
}
