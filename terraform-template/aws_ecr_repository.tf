#---------------------------------------------------------------
# Amazon ECR Repository
#---------------------------------------------------------------
#
# Amazon Elastic Container Registry (ECR) のプライベートリポジトリを
# プロビジョニングします。コンテナイメージを安全に保存、管理、
# デプロイするためのフルマネージドなコンテナレジストリサービスです。
#
# AWS公式ドキュメント:
#   - Creating a private repository: https://docs.aws.amazon.com/AmazonECR/latest/userguide/repository-create.html
#   - Encryption at rest: https://docs.aws.amazon.com/AmazonECR/latest/userguide/encryption-at-rest.html
#   - Image tag mutability: https://docs.aws.amazon.com/AmazonECR/latest/userguide/image-tag-mutability.html
#   - Image scanning: https://docs.aws.amazon.com/AmazonECR/latest/userguide/image-scanning.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ecr_repository" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # リポジトリ名
  # リポジトリを一意に識別する名前を指定します。
  # 最大256文字まで、小文字英数字、ハイフン、アンダースコア、
  # スラッシュが使用可能です。
  name = "example-repository"

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # リソース管理対象のリージョン
  # このリソースを管理するAWSリージョンを指定します。
  # 未指定の場合、プロバイダー設定のリージョンが使用されます。
  # 詳細: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  # イメージタグの可変性設定
  # プッシュ済みのイメージタグを上書き可能かどうかを制御します。
  # 設定可能な値:
  #   - MUTABLE: イメージタグの上書きを許可（デフォルト）
  #   - IMMUTABLE: イメージタグの上書きを禁止
  #   - IMMUTABLE_WITH_EXCLUSION: 原則不変だが除外フィルタで指定したタグのみ上書き可能
  #   - MUTABLE_WITH_EXCLUSION: 原則可変だが除外フィルタで指定したタグのみ上書き不可
  # 詳細: https://docs.aws.amazon.com/AmazonECR/latest/userguide/image-tag-mutability.html
  image_tag_mutability = "MUTABLE"

  # リポジトリの強制削除
  # trueの場合、リポジトリにイメージが含まれていても削除を許可します。
  # falseの場合（デフォルト）、イメージが存在するリポジトリは削除できません。
  # 本番環境では慎重に使用してください。
  force_delete = false

  # タグ
  # リソースに割り当てるタグのマップ。
  # プロバイダーのdefault_tags設定ブロックと統合されます。
  # キーが重複する場合、このリソースレベルの設定が優先されます。
  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
  }

  # 全タグ（オプション、通常は指定不要）
  # プロバイダーのdefault_tagsを含む全てのタグのマップ。
  # 通常はterraformが自動的に管理するため明示的な指定は不要です。
  # tags_all = {}

  # ID（オプション、通常は指定不要）
  # Terraformリソースの内部ID。通常は自動生成されるため指定不要です。
  # id = null

  #---------------------------------------------------------------
  # ネストブロック: 暗号化設定
  #---------------------------------------------------------------

  # 暗号化設定
  # リポジトリの保存時の暗号化設定を定義します。
  # 未指定の場合、デフォルトでAES256暗号化が使用されます。
  # 詳細: https://docs.aws.amazon.com/AmazonECR/latest/userguide/encryption-at-rest.html
  encryption_configuration {
    # 暗号化タイプ
    # 使用する暗号化方式を指定します。
    # 設定可能な値:
    #   - AES256: Amazon S3マネージド暗号化キーを使用（デフォルト）
    #   - KMS: AWS KMSキーを使用した暗号化
    # 詳細: https://docs.aws.amazon.com/AmazonECR/latest/APIReference/API_EncryptionConfiguration.html
    encryption_type = "AES256"

    # KMSキー
    # encryption_typeがKMSの場合に使用するKMSキーのARNを指定します。
    # 未指定の場合、Amazon ECR用のデフォルトAWSマネージドキーが使用されます。
    # KMSキーはリポジトリと同じリージョンに存在する必要があります。
    # kms_key = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
  }

  #---------------------------------------------------------------
  # ネストブロック: イメージスキャン設定
  #---------------------------------------------------------------

  # イメージスキャン設定
  # リポジトリのイメージスキャン動作を設定します。
  # 脆弱性の検出に役立ちます。
  # 詳細: https://docs.aws.amazon.com/AmazonECR/latest/userguide/image-scanning.html
  image_scanning_configuration {
    # プッシュ時のスキャン
    # イメージがリポジトリにプッシュされた後、
    # 自動的にスキャンを実行するかどうかを指定します。
    # true: 自動スキャンを有効化
    # false: 手動スキャンのみ（デフォルト）
    scan_on_push = true
  }

  #---------------------------------------------------------------
  # ネストブロック: イメージタグ可変性除外フィルタ
  #---------------------------------------------------------------

  # イメージタグ可変性除外フィルタ（最大5個まで設定可能）
  # image_tag_mutabilityがIMMUTABLE_WITH_EXCLUSIONまたは
  # MUTABLE_WITH_EXCLUSIONに設定されている場合に使用します。
  # 特定のタグパターンをデフォルトの可変性設定から除外します。
  # 詳細: https://docs.aws.amazon.com/AmazonECR/latest/APIReference/API_ImageTagMutabilityExclusionFilter.html
  #
  # image_tag_mutability_exclusion_filter {
  #   # フィルタパターン
  #   # 除外するイメージタグのパターンを指定します。
  #   # 1〜128文字、英数字と特殊文字(._*-)のみ使用可能。
  #   # ワイルドカード(*)は最大2個まで使用可能。
  #   # 例: "latest*", "dev-*", "v1.*"
  #   filter = "latest*"
  #
  #   # フィルタタイプ
  #   # フィルタの種類を指定します。
  #   # 現在、WILDCARD のみサポートされています。
  #   filter_type = "WILDCARD"
  # }
  #
  # # 複数のフィルタを設定する例
  # image_tag_mutability_exclusion_filter {
  #   filter      = "dev-*"
  #   filter_type = "WILDCARD"
  # }

  #---------------------------------------------------------------
  # ネストブロック: タイムアウト設定
  #---------------------------------------------------------------

  # タイムアウト設定
  # Terraform操作のタイムアウト時間を設定します。
  # timeouts {
  #   # 削除タイムアウト
  #   # リポジトリ削除操作のタイムアウト時間を指定します。
  #   # 形式: "20m", "1h" など
  #   # デフォルトは20分です。
  #   delete = "20m"
  # }
}

#---------------------------------------------------------------
# Attributes Reference（参照専用の出力属性）
#---------------------------------------------------------------
# 以下の属性はリソース作成後に参照可能ですが、
# 設定ブロックには記述できません（computed-only）。
#
# - arn
#   リポジトリの完全なARN
#   例: "arn:aws:ecr:us-east-1:123456789012:repository/example-repository"
#
# - registry_id
#   リポジトリが作成されたレジストリID（通常はAWSアカウントID）
#   例: "123456789012"
#
# - repository_url
#   リポジトリのURL
#   形式: {aws_account_id}.dkr.ecr.{region}.amazonaws.com/{repository_name}
#   例: "123456789012.dkr.ecr.us-east-1.amazonaws.com/example-repository"
#
# 使用例:
#   output "repository_url" {
#     value = aws_ecr_repository.example.repository_url
#   }
#---------------------------------------------------------------

