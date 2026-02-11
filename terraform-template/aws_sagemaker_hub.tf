# ====================================================================
# AWS SageMaker Hub - Annotated Terraform Template
# ====================================================================
# 生成日: 2026-02-04
# Provider: hashicorp/aws
# Version: 6.28.0
#
# このテンプレートは生成時点の情報に基づいています。
# 最新の仕様については公式ドキュメントをご確認ください。
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sagemaker_hub
# ====================================================================

# AWS SageMaker Hub リソース
# SageMaker のプライベートモデルハブを作成します。
# ハブは機械学習モデル、アルゴリズム、ノートブックなどのMLアーティファクトを
# 組織内で安全に共有・管理するための中央リポジトリとして機能します。
#
# SageMaker Hub は以下の用途で使用されます:
# - 組織内でのMLモデルとアルゴリズムの共有
# - MLアーティファクトのバージョン管理とカタログ化
# - チーム間でのベストプラクティスの標準化
# - ガバナンスとコンプライアンスの強化
#
# 参考: https://docs.aws.amazon.com/sagemaker/latest/dg/jumpstart-content-sharing.html
# API: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_CreateHub.html
resource "aws_sagemaker_hub" "example" {
  # ========================================
  # 必須パラメータ
  # ========================================

  # ハブ名
  # SageMaker ハブの一意な名前を指定します。
  # この名前はアカウント内でハブを識別するために使用されます。
  #
  # 制約:
  # - 長さ: 1〜63文字
  # - 使用可能文字: 英数字とハイフン(-)
  # - 先頭と末尾はアルファベットまたは数字である必要があります
  #
  # 例: "ml-models-hub", "team-algorithms-hub", "production-hub"
  hub_name = "example-ml-hub"

  # ハブ説明
  # ハブの目的と内容を説明するテキストを指定します。
  # この説明はハブのカタログやダッシュボードで表示されます。
  #
  # 制約:
  # - 長さ: 0〜1023文字
  # - 必須パラメータ（空文字列も許可されますが、説明的なテキストを推奨）
  #
  # ベストプラクティス:
  # - ハブの目的と対象ユーザーを明確に記載
  # - 含まれるコンテンツのタイプを説明
  # - 利用ガイドラインや連絡先情報を含める
  hub_description = "Central repository for production-ready ML models and algorithms. This hub contains validated models for computer vision, NLP, and tabular data tasks."

  # ========================================
  # オプションパラメータ
  # ========================================

  # ハブ表示名
  # ハブのユーザーフレンドリーな表示名を指定します。
  # この名前はUIやカタログで表示され、hub_name よりも読みやすい形式を使用できます。
  #
  # 制約:
  # - 長さ: 0〜255文字
  # - 指定しない場合は hub_name が表示されます
  #
  # 例: "Production ML Models Hub", "Data Science Team - Algorithms"
  hub_display_name = "Production ML Models Hub"

  # ハブ検索キーワード
  # ハブの検索性を向上させるためのキーワードのセットを指定します。
  # ユーザーがハブを検索する際に、これらのキーワードでヒットするようになります。
  #
  # 制約:
  # - 最大50個のキーワード
  # - 各キーワードの長さ: 0〜255文字
  #
  # ベストプラクティス:
  # - ドメイン固有の用語を含める（例: "computer-vision", "nlp"）
  # - チーム名やプロジェクト名を追加
  # - ユースケースに関連する用語を含める
  hub_search_keywords = [
    "production",
    "machine-learning",
    "computer-vision",
    "nlp",
    "validated-models",
    "approved-algorithms"
  ]

  # リージョン
  # このリソースが管理されるAWSリージョンを指定します。
  # 指定しない場合は、プロバイダー設定のリージョンがデフォルトで使用されます。
  #
  # ハブはリージョン固有のリソースです。別のリージョンでハブを使用する場合は、
  # AWS Resource Access Manager (RAM) を使用してクロスリージョン共有を設定できます。
  #
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = "us-east-1"

  # タグ
  # リソースに割り当てるタグのマップを指定します。
  # タグはリソースの整理、コスト配分、アクセス制御に使用されます。
  # プロバイダーの default_tags 設定ブロックと組み合わせて使用できます。
  #
  # ベストプラクティス:
  # - Environment タグで環境を識別（dev, staging, prod）
  # - Owner タグでリソースの所有者を明示
  # - CostCenter タグでコスト配分を管理
  # - Project タグでプロジェクトを識別
  #
  # 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Environment = "production"
    Owner       = "ml-platform-team"
    Project     = "ml-hub-infrastructure"
    ManagedBy   = "terraform"
    Compliance  = "soc2"
  }

  # tags_all
  # デフォルトタグとリソースタグを統合したすべてのタグのマップです。
  # 通常は Terraform によって自動的に管理されるため、明示的な指定は不要です。
  # プロバイダーの default_tags と tags を統合した結果がここに反映されます。
  # tags_all = {}

  # ========================================
  # ネストブロック: s3_storage_config
  # ========================================
  # S3ストレージ設定（オプション）
  # ハブのコンテンツを保存するための Amazon S3 ストレージ設定を指定します。
  # この設定により、モデルアーティファクト、ノートブック、その他のMLアセットを
  # 指定したS3バケットに保存できます。
  #
  # 注意事項:
  # - 指定しない場合、SageMaker はデフォルトの S3 バケットを使用します
  # - カスタムバケットを使用する場合、適切な IAM ポリシーが必要です
  # - バケットは同じリージョンに存在する必要があります
  #
  # 参考: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_HubS3StorageConfig.html
  s3_storage_config {
    # S3出力パス
    # ハブコンテンツをホストするための S3 バケットプレフィックスを指定します。
    #
    # 形式: s3://bucket-name/prefix/
    #
    # 要件:
    # - バケットは同じリージョンに存在すること
    # - SageMaker サービスがバケットへの読み書きアクセスを持つこと
    # - バケットポリシーで適切なアクセス許可が設定されていること
    #
    # セキュリティのベストプラクティス:
    # - S3 バケットの暗号化を有効化（SSE-S3 または SSE-KMS）
    # - バケットのバージョニングを有効化
    # - アクセスログを有効化
    # - パブリックアクセスをブロック
    #
    # IAM ポリシー例:
    # {
    #   "Version": "2012-10-17",
    #   "Statement": [
    #     {
    #       "Effect": "Allow",
    #       "Principal": {
    #         "Service": "sagemaker.amazonaws.com"
    #       },
    #       "Action": [
    #         "s3:GetObject",
    #         "s3:PutObject",
    #         "s3:DeleteObject",
    #         "s3:ListBucket"
    #       ],
    #       "Resource": [
    #         "arn:aws:s3:::your-bucket-name/*",
    #         "arn:aws:s3:::your-bucket-name"
    #       ]
    #     }
    #   ]
    # }
    s3_output_path = "s3://my-sagemaker-hub-bucket/ml-hub-content/"
  }
}

# ====================================================================
# 出力例（参考）
# ====================================================================
# 以下の computed 属性は、リソース作成後に参照可能です。

# output "hub_arn" {
#   description = "ARN of the SageMaker Hub"
#   value       = aws_sagemaker_hub.example.arn
# }
#
# output "hub_id" {
#   description = "ID of the SageMaker Hub (same as hub_name)"
#   value       = aws_sagemaker_hub.example.id
# }
#
# output "hub_name" {
#   description = "Name of the SageMaker Hub"
#   value       = aws_sagemaker_hub.example.hub_name
# }
#
# output "hub_tags_all" {
#   description = "All tags assigned to the hub, including default tags"
#   value       = aws_sagemaker_hub.example.tags_all
# }

# ====================================================================
# 使用例とベストプラクティス
# ====================================================================
#
# 1. ハブへのコンテンツの追加
#    ハブ作成後、以下の方法でコンテンツを追加できます:
#    - AWS CLI: aws sagemaker import-hub-content
#    - AWS SDK: ImportHubContent API
#    - SageMaker Studio UI
#
# 2. クロスアカウント共有
#    AWS Resource Access Manager (RAM) を使用してハブを共有:
#    - 読み取り専用アクセス
#    - 読み取りと使用アクセス（モデルデプロイ可能）
#    - フルアクセス（コンテンツの追加・削除可能）
#
#    参考: https://docs.aws.amazon.com/sagemaker/latest/dg/jumpstart-curated-hubs-ram.html
#
# 3. ハブのコンテンツタイプ
#    以下のタイプのコンテンツを保存できます:
#    - Model: 学習済みモデル
#    - Notebook: Jupyter ノートブック
#    - ModelReference: 外部モデルへの参照
#    - DataSet: データセット
#    - JsonDoc: JSON ドキュメント
#
# 4. セキュリティのベストプラクティス
#    - VPC エンドポイントを使用してプライベート接続を確保
#    - IAM ポリシーで最小権限の原則を適用
#    - S3 バケットの暗号化を有効化
#    - CloudTrail でハブへのアクセスを監査
#    - タグベースのアクセス制御を実装
#
# 5. コスト最適化
#    - 不要なコンテンツを定期的に削除
#    - S3 ライフサイクルポリシーで古いバージョンをアーカイブ
#    - タグを使用してコスト配分を追跡
#
# 6. モニタリングとログ
#    - CloudWatch メトリクスでハブの使用状況を監視
#    - CloudTrail でハブへのアクセスと変更をログ記録
#    - S3 アクセスログでコンテンツの取得を追跡
#
# 7. 関連する AWS リソース
#    resource "aws_s3_bucket" "hub_storage" {
#      bucket = "my-sagemaker-hub-bucket"
#    }
#
#    resource "aws_s3_bucket_versioning" "hub_storage" {
#      bucket = aws_s3_bucket.hub_storage.id
#      versioning_configuration {
#        status = "Enabled"
#      }
#    }
#
#    resource "aws_s3_bucket_server_side_encryption_configuration" "hub_storage" {
#      bucket = aws_s3_bucket.hub_storage.id
#      rule {
#        apply_server_side_encryption_by_default {
#          sse_algorithm = "AES256"
#        }
#      }
#    }
#
#    resource "aws_s3_bucket_public_access_block" "hub_storage" {
#      bucket                  = aws_s3_bucket.hub_storage.id
#      block_public_acls       = true
#      block_public_policy     = true
#      ignore_public_acls      = true
#      restrict_public_buckets = true
#    }
#
# 8. 削除時の注意事項
#    - ハブを削除する前に、すべてのコンテンツを削除する必要があります
#    - ハブが他のアカウントと共有されている場合、先に共有を解除してください
#    - S3 バケットのコンテンツは自動的に削除されません
#
#    API エラー例:
#    - ResourceInUse: ハブがまだ使用中（コンテンツが残っている）
#    - ResourceNotFound: 指定された名前のハブが存在しない
#
# 9. Terraform での依存関係管理
#    depends_on を使用して、ハブ作成前に必要なリソースを確実に作成:
#
#    resource "aws_sagemaker_hub" "example" {
#      # ... configuration ...
#
#      depends_on = [
#        aws_s3_bucket.hub_storage,
#        aws_s3_bucket_policy.hub_storage_policy
#      ]
#    }
#
# 10. マルチリージョン展開
#     複数リージョンでハブを使用する場合:
#     - 各リージョンで個別にハブを作成
#     - S3 クロスリージョンレプリケーションでコンテンツを同期
#     - AWS RAM でクロスリージョン共有を設定（必要に応じて）
