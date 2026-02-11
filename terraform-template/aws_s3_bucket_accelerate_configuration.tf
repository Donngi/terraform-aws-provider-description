# ==============================================================================
# AWS S3 Bucket Accelerate Configuration
# ==============================================================================
# リソース: aws_s3_bucket_accelerate_configuration
# プロバイダー: hashicorp/aws v6.28.0
#
# 概要:
#   S3バケットのTransfer Acceleration（転送高速化）設定を管理するリソースです。
#   Transfer Accelerationは、クライアントとS3バケット間で長距離にわたる
#   高速かつ安全なファイル転送を可能にする機能です。CloudFrontのグローバルに
#   分散されたエッジロケーションを利用してデータを転送することで、
#   特に地理的に離れた場所からのアップロード/ダウンロード速度を向上させます。
#
# 制約事項:
#   - S3 directory bucketsでは使用できません（general purpose bucketsのみ対応）
#   - バケット名にピリオド(.)を含めることはできません
#   - Transfer Accelerationを有効にすると追加料金が発生します
#   - すべてのリージョンで利用可能ではない場合があります
#
# 使用例シナリオ:
#   - 大陸間でのデータ転送を行うアプリケーション
#   - 高速インターネット接続を持つクライアントからの大容量ファイルアップロード
#   - 世界中の複数拠点からS3へのデータアップロードを行うシステム
#   - メディアファイルやバックアップデータの高速転送が必要な場合
#
# 公式ドキュメント:
#   https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_accelerate_configuration
#   https://docs.aws.amazon.com/AmazonS3/latest/userguide/transfer-acceleration.html
# ==============================================================================

# ------------------------------------------------------------------------------
# 基本設定例: Transfer Accelerationの有効化
# ------------------------------------------------------------------------------
# 最もシンプルな設定例。既存のS3バケットに対してTransfer Accelerationを
# 有効化します。
# ------------------------------------------------------------------------------
resource "aws_s3_bucket_accelerate_configuration" "example_enabled" {
  # ------------------------------------------------------------------------------
  # 必須パラメータ
  # ------------------------------------------------------------------------------

  # bucket (必須) - Type: string
  # 設定対象のS3バケット名またはバケットARN
  #
  # 注意事項:
  #   - このパラメータを変更すると、リソースが強制的に再作成されます
  #   - バケット名にピリオド(.)が含まれている場合、Transfer Accelerationは使用できません
  #   - 既存のaws_s3_bucketリソースのidまたはbucket属性を参照することを推奨
  #
  # ベストプラクティス:
  #   - ハードコードではなく、aws_s3_bucket.example.idのように参照を使用する
  #   - バケット名は63文字以内、小文字英数字とハイフンのみを使用
  #
  # 例:
  #   bucket = aws_s3_bucket.mybucket.id
  #   bucket = "my-accelerated-bucket"
  bucket = aws_s3_bucket.example.id

  # status (必須) - Type: string
  # Transfer Accelerationの状態
  #
  # 有効な値:
  #   - "Enabled"   : Transfer Accelerationを有効化（推奨）
  #   - "Suspended" : Transfer Accelerationを一時停止
  #
  # 注意事項:
  #   - 値は大文字小文字を区別します（"enabled"や"ENABLED"は無効）
  #   - Suspendedに設定すると、加速エンドポイントへのアクセスは通常のエンドポイントに
  #     リダイレクトされますが、設定自体は保持されます
  #   - 完全に無効化する場合は、リソースを削除してください
  #
  # ベストプラクティス:
  #   - 本番環境では"Enabled"を使用
  #   - コスト削減のため一時的に無効化する場合は"Suspended"を使用
  #   - 変数化して環境ごとに切り替え可能にすることを推奨
  #
  # パフォーマンス考慮事項:
  #   - Enabledにすると、s3-accelerate.amazonaws.comエンドポイントが利用可能になります
  #   - 地理的に近い場合は、通常のエンドポイントより遅くなる可能性があります
  #   - S3 Transfer Acceleration Speed Comparison toolで事前テストを推奨
  #     https://s3-accelerate-speedtest.s3-accelerate.amazonaws.com/en/accelerate-speed-comparsion.html
  #
  # 例:
  #   status = "Enabled"
  #   status = "Suspended"
  #   status = var.enable_transfer_acceleration ? "Enabled" : "Suspended"
  status = "Enabled"

  # ------------------------------------------------------------------------------
  # オプションパラメータ
  # ------------------------------------------------------------------------------

  # expected_bucket_owner (オプション) - Type: string
  # バケット所有者のAWSアカウントID
  #
  # 用途:
  #   - セキュリティ強化のため、バケットの所有者を検証します
  #   - 指定されたアカウントIDがバケットの所有者と一致しない場合、操作は失敗します
  #
  # 注意事項:
  #   - このパラメータを変更すると、リソースが強制的に再作成されます
  #   - 12桁の数値文字列で指定します
  #   - クロスアカウントアクセスを行う際のセキュリティ対策として有効
  #
  # ベストプラクティス:
  #   - マルチアカウント環境では必ず設定することを推奨
  #   - data.aws_caller_identity.current.account_idを使用して動的に取得
  #   - 予期しないバケットへの設定適用を防止できます
  #
  # 例:
  #   expected_bucket_owner = "123456789012"
  #   expected_bucket_owner = data.aws_caller_identity.current.account_id
  #   expected_bucket_owner = var.bucket_owner_account_id
  # expected_bucket_owner = "123456789012"

  # region (オプション) - Type: string (Computed)
  # このリソースが管理されるAWSリージョン
  #
  # デフォルト動作:
  #   - 指定しない場合、プロバイダー設定のリージョンが使用されます
  #   - 自動的に計算され、明示的な指定は通常不要です
  #
  # 使用ケース:
  #   - マルチリージョン構成で、特定のリージョンを明示的に指定する場合
  #   - プロバイダーのデフォルトリージョンとは異なるリージョンで管理する場合
  #
  # 注意事項:
  #   - バケット自体のリージョンではなく、このTerraformリソースが管理される
  #     リージョンを指定します
  #   - 通常は省略し、プロバイダー設定に従うことを推奨
  #
  # 例:
  #   region = "us-east-1"
  #   region = var.aws_region
  # region = "us-east-1"
}

# ------------------------------------------------------------------------------
# 高度な設定例: セキュリティ強化版
# ------------------------------------------------------------------------------
# マルチアカウント環境でのセキュリティを考慮した設定例
# expected_bucket_ownerを使用してバケット所有者を検証します
# ------------------------------------------------------------------------------
resource "aws_s3_bucket_accelerate_configuration" "example_secure" {
  bucket = aws_s3_bucket.secure_example.id
  status = "Enabled"

  # アカウントIDを検証してセキュリティを強化
  expected_bucket_owner = data.aws_caller_identity.current.account_id
}

# ------------------------------------------------------------------------------
# 条件付き設定例: 環境に応じた切り替え
# ------------------------------------------------------------------------------
# 変数を使用して、環境（本番/開発）に応じてTransfer Accelerationの有効/無効を
# 切り替える設定例。コスト最適化に有効です。
# ------------------------------------------------------------------------------
resource "aws_s3_bucket_accelerate_configuration" "example_conditional" {
  bucket = aws_s3_bucket.conditional_example.id

  # 本番環境のみTransfer Accelerationを有効化
  # 開発/ステージング環境ではコスト削減のため無効化
  status = var.environment == "production" ? "Enabled" : "Suspended"

  expected_bucket_owner = data.aws_caller_identity.current.account_id
}

# ------------------------------------------------------------------------------
# 参照用データソース
# ------------------------------------------------------------------------------
# 現在のAWSアカウント情報を取得
# expected_bucket_ownerパラメータで使用
data "aws_caller_identity" "current" {}

# ------------------------------------------------------------------------------
# 依存リソース例: S3バケット
# ------------------------------------------------------------------------------
# Transfer Accelerationを設定するためのS3バケット
# バケット名にピリオド(.)を含めないように注意
resource "aws_s3_bucket" "example" {
  bucket = "my-accelerated-bucket-example"

  # Transfer Acceleration要件:
  # - バケット名にピリオド(.)を含めない
  # - DNS互換の命名規則に従う
  # - general purpose bucketであること（directory bucketは非対応）
}

resource "aws_s3_bucket" "secure_example" {
  bucket = "my-secure-accelerated-bucket"
}

resource "aws_s3_bucket" "conditional_example" {
  bucket = "my-conditional-accelerated-bucket"
}

# ------------------------------------------------------------------------------
# 変数定義例
# ------------------------------------------------------------------------------
# 実際の使用時には、variables.tfファイルで定義することを推奨

# variable "environment" {
#   description = "デプロイ環境（production, staging, development）"
#   type        = string
#   default     = "development"
#
#   validation {
#     condition     = contains(["production", "staging", "development"], var.environment)
#     error_message = "環境は production, staging, development のいずれかである必要があります。"
#   }
# }

# variable "enable_transfer_acceleration" {
#   description = "Transfer Accelerationを有効化するかどうか"
#   type        = bool
#   default     = false
# }

# variable "bucket_owner_account_id" {
#   description = "バケット所有者のAWSアカウントID（セキュリティ検証用）"
#   type        = string
#   default     = null
#
#   validation {
#     condition     = var.bucket_owner_account_id == null || can(regex("^[0-9]{12}$", var.bucket_owner_account_id))
#     error_message = "アカウントIDは12桁の数値である必要があります。"
#   }
# }

# ------------------------------------------------------------------------------
# 出力値例
# ------------------------------------------------------------------------------
# 他のモジュールやリソースで参照するための出力値

# output "accelerate_configuration_id" {
#   description = "Transfer Acceleration設定のID"
#   value       = aws_s3_bucket_accelerate_configuration.example_enabled.id
# }

# output "accelerate_endpoint" {
#   description = "Transfer Acceleration用のエンドポイントURL"
#   value       = "https://${aws_s3_bucket.example.bucket}.s3-accelerate.amazonaws.com"
# }

# output "bucket_region" {
#   description = "バケットのリージョン"
#   value       = aws_s3_bucket_accelerate_configuration.example_enabled.region
# }

# ==============================================================================
# ベストプラクティスとトラブルシューティング
# ==============================================================================
#
# 1. Transfer Acceleration使用要件:
#    - バケット名にピリオド(.)を含めない
#    - general purpose bucketsのみ対応（directory buckets非対応）
#    - DNS互換の命名規則に従う
#    - バケット名は全世界で一意である必要がある
#
# 2. パフォーマンス最適化:
#    - 使用前にS3 Transfer Acceleration Speed Comparison toolでテスト
#    - 地理的に離れた場所からの転送で最も効果的
#    - 大容量ファイル（数GB以上）の転送で特に有効
#    - 高速インターネット接続環境で最大の効果を発揮
#
# 3. コスト最適化:
#    - 転送速度の向上が見られる場合のみ課金される
#    - 環境変数で本番/開発環境を切り替え、開発環境では無効化を検討
#    - Suspendedステータスで一時的に無効化可能（設定は保持）
#    - 通常のS3転送料金に加えて、Transfer Acceleration料金が発生
#
# 4. セキュリティ考慮事項:
#    - expected_bucket_ownerで所有者検証を実装
#    - マルチアカウント環境では必ず設定を推奨
#    - バケットポリシーと組み合わせてアクセス制御を強化
#    - VPCエンドポイント経由ではTransfer Accelerationは使用不可
#
# 5. エンドポイント使用方法:
#    - 通常: https://bucket-name.s3.amazonaws.com
#    - 加速: https://bucket-name.s3-accelerate.amazonaws.com
#    - デュアルスタック加速: https://bucket-name.s3-accelerate.dualstack.amazonaws.com
#
# 6. AWS CLIでの使用:
#    - aws configure set default.s3.use_accelerate_endpoint true
#    - または --endpoint-url https://s3-accelerate.amazonaws.com
#
# 7. トラブルシューティング:
#    - バケット名にピリオドがある場合は削除または別バケット使用
#    - "Transfer acceleration is not supported for buckets with periods"エラー
#      → バケット名を変更するか、Transfer Accelerationなしで運用
#    - パフォーマンスが向上しない場合は地理的距離が近い可能性
#      → Speed Comparison toolで検証
#    - VPCエンドポイント経由では使用不可
#      → パブリックインターネット経由でアクセス
#
# 8. 依存関係管理:
#    - aws_s3_bucketリソース作成後に設定
#    - depends_onを明示的に指定する必要はなし（bucket参照で自動解決）
#    - バケット削除時は、この設定も自動的に削除される
#
# 9. インポート方法:
#    - terraform import aws_s3_bucket_accelerate_configuration.example bucket-name
#    - expected_bucket_owner使用時:
#      terraform import aws_s3_bucket_accelerate_configuration.example bucket-name,123456789012
#
# 10. 監視とアラート:
#     - CloudWatch Metricsで転送速度を監視
#     - S3アクセスログでエンドポイント使用状況を確認
#     - コスト異常検知アラートの設定を推奨
#
# ==============================================================================
