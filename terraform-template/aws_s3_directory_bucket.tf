# ================================================================================
# AWS S3 Directory Bucket - Terraform Annotated Template
# ================================================================================
# Provider Version: 6.28.0
# Resource: aws_s3_directory_bucket
#
# Overview:
# - Amazon S3 Express One Zone storage class専用のDirectory Bucketリソースです
# - 単一のAvailability Zone内でデータを冗長化し、99.95%の可用性を提供します
# - 単桁ミリ秒の低レイテンシーとS3 Standardの10倍のパフォーマンスを実現します
# - データを階層的なディレクトリ構造で整理し、プレフィックス制限がありません
# - 1秒あたり最大200万回の読み取りと20万回の書き込みをサポートします
#
# Important Notes:
# - S3 Express One Zone storage classでのみ使用可能です
# - バケット名は "[bucket_name]--[azid]--x-s3" の形式が必須です
# - バケットタイプ作成後は変更できません
# - データは単一AZ内のみに保存され、複数AZには冗長化されません
# - General Purpose Bucketとは異なり、Directory Bucketには独自のAPIがあります
#
# Use Cases:
# - リクエスト集約型のワークロード(機械学習トレーニング、金融モデリング)
# - パフォーマンスが重要なアプリケーション(リアルタイム分析、メディア処理)
# - EC2/EKS/ECSと同じAZにストレージを配置して最高速度を実現
# - 単桁ミリ秒のPUT/GETレイテンシーが必要な場合
# ================================================================================

# ================================================================================
# Example 1: Basic Directory Bucket in Availability Zone
# ================================================================================
# 最もシンプルなAvailability Zone内のDirectory Bucket構成
# - デフォルトでSingleAvailabilityZone冗長性を使用
# - サーバー側暗号化はSSE-S3がデフォルトで有効
# ================================================================================

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_s3_directory_bucket" "example" {
  # ================================================================================
  # Required Arguments
  # ================================================================================

  # bucket - (Required) バケット名(必須フォーマット: [bucket_name]--[azid]--x-s3)
  # - Availability Zone ID または Local Zone IDをサフィックスに含む必要があります
  # - 3〜63文字の長さ(サフィックス含む)
  # - 小文字、数字、ハイフンのみ使用可能
  # - 先頭と末尾は文字または数字
  # - ゾーン内で一意である必要があります
  #
  # 命名規則の例:
  # - Availability Zone: "my-bucket--usw2-az1--x-s3"
  # - Local Zone: "my-bucket--usw2-lax1-az1--x-s3"
  #
  # 禁止されたプレフィックス:
  # - xn--
  # - sthree-
  # - sthree-configurator
  # - amzn-s3-demo-
  bucket = "example-bucket--${data.aws_availability_zones.available.zone_ids[0]}--x-s3"

  # location - (Required) バケットのロケーション設定
  # - Availability Zone IDまたはLocal Zone IDを指定
  # - バケット作成後は変更不可
  # - max_items: 1
  location {
    # name - (Required) Availability Zone IDまたはLocal Zone ID
    # - 例: "usw2-az1" (Availability Zone)
    # - 例: "usw2-lax1-az1" (Local Zone)
    # - コンピュートリソースと同じゾーンを指定してパフォーマンスを最適化
    # - サポートされているゾーン一覧: https://docs.aws.amazon.com/AmazonS3/latest/userguide/s3-express-Endpoints.html
    name = data.aws_availability_zones.available.zone_ids[0]

    # type - (Optional) ロケーションタイプ
    # - デフォルト: "AvailabilityZone"
    # - 有効な値: "AvailabilityZone", "LocalZone"
    # - Availability Zoneを使用する場合は明示的な指定は不要
    # type = "AvailabilityZone"
  }

  # ================================================================================
  # Optional Arguments
  # ================================================================================

  # data_redundancy - (Optional) データ冗長性レベル
  # - デフォルト: location.typeに応じて自動決定
  #   * AvailabilityZone の場合: "SingleAvailabilityZone"
  #   * LocalZone の場合: "SingleLocalZone"
  # - 有効な値:
  #   * "SingleAvailabilityZone": 単一AZ内で複数デバイスに冗長化
  #   * "SingleLocalZone": 単一Local Zone内で冗長化
  # - 99.95%の可用性を提供(単一ゾーン内)
  # data_redundancy = "SingleAvailabilityZone"

  # force_destroy - (Optional) バケット削除時に内部オブジェクトを自動削除するか
  # - デフォルト: false
  # - true: バケット破棄時にすべてのオブジェクトを削除してバケットを破棄可能
  # - false: オブジェクトが存在する場合、バケット削除がエラーになる
  #
  # 重要な注意事項:
  # - trueに設定後、terraform applyを成功させる必要があります
  # - apply成功前にdestroyを実行してもこのフラグは効果を持ちません
  # - バケット削除やreplaceが必要な操作と同時に設定しても効果なし
  # - インポートしたバケットの場合、terraform apply成功後に有効化されます
  # - 削除されたオブジェクトは復元不可能です
  # force_destroy = false

  # region - (Optional) リソースを管理するリージョン
  # - デフォルト: プロバイダー設定のリージョン
  # - Directory Bucketがサポートされているリージョンである必要があります
  # - サポートリージョン: https://docs.aws.amazon.com/AmazonS3/latest/userguide/s3-express-Endpoints.html
  # region = "us-west-2"

  # tags - (Optional) バケットに割り当てるタグのマップ
  # - provider default_tagsと組み合わせて使用可能
  # - コスト配分、リソース管理、アクセス制御に活用
  tags = {
    Name        = "example-directory-bucket"
    Environment = "production"
    StorageClass = "S3ExpressOneZone"
    ManagedBy   = "terraform"
  }

  # type - (Optional) バケットタイプ
  # - デフォルト: "Directory"
  # - 有効な値: "Directory"
  # - 現在はDirectoryのみサポート
  # - バケット作成後は変更不可
  # type = "Directory"
}

# ================================================================================
# Example 2: Directory Bucket in Local Zone
# ================================================================================
# Local Zone内にDirectory Bucketを配置する構成
# - エッジロケーションに近い配置でさらに低レイテンシーを実現
# - location.typeを "LocalZone" に明示的に指定
# ================================================================================

resource "aws_s3_directory_bucket" "local_zone" {
  bucket = "local-bucket--usw2-lax1-az1--x-s3"

  location {
    # Local Zone IDを指定
    name = "usw2-lax1-az1"

    # Local Zoneを使用する場合は明示的にtypeを指定
    type = "LocalZone"
  }

  # Local Zoneの場合の冗長性設定
  data_redundancy = "SingleLocalZone"

  tags = {
    Name         = "local-zone-directory-bucket"
    Environment  = "production"
    LocationType = "LocalZone"
    Zone         = "usw2-lax1-az1"
  }
}

# ================================================================================
# Example 3: Directory Bucket with Force Destroy
# ================================================================================
# テスト環境やCI/CD環境での使用を想定した構成
# - force_destroyを有効にしてバケット削除を簡素化
# - 開発環境やステージング環境に適しています
# ================================================================================

resource "aws_s3_directory_bucket" "dev_with_force_destroy" {
  bucket = "dev-bucket--${data.aws_availability_zones.available.zone_ids[0]}--x-s3"

  location {
    name = data.aws_availability_zones.available.zone_ids[0]
  }

  # 開発環境でのクリーンアップを容易にする
  force_destroy = true

  tags = {
    Name        = "dev-directory-bucket"
    Environment = "development"
    AutoCleanup = "enabled"
    ManagedBy   = "terraform"
  }
}

# ================================================================================
# Example 4: Directory Bucket Co-located with Compute
# ================================================================================
# EC2インスタンスと同じAZにバケットを配置する最適化構成
# - 最高のアクセス速度とスループットを実現
# - レイテンシーセンシティブなアプリケーションに最適
# ================================================================================

# EC2インスタンスのサブネット情報からAZ IDを取得
data "aws_subnet" "compute" {
  id = "subnet-12345678" # 実際のサブネットIDに置き換え
}

resource "aws_s3_directory_bucket" "colocated" {
  # コンピュートリソースと同じAZにバケットを配置
  bucket = "colocated-bucket--${data.aws_subnet.compute.availability_zone_id}--x-s3"

  location {
    name = data.aws_subnet.compute.availability_zone_id
  }

  tags = {
    Name            = "colocated-directory-bucket"
    Environment     = "production"
    ColocatedWith   = "ec2-compute-cluster"
    OptimizedFor    = "low-latency"
  }
}

# ================================================================================
# Computed Attributes (Output Examples)
# ================================================================================
# Directory Bucket作成後に参照可能な属性

output "directory_bucket_arn" {
  description = "Directory BucketのARN"
  # - フォーマット: arn:aws:s3express:region:account-id:bucket/bucket-name
  # - IAMポリシーやリソースポリシーで使用
  value = aws_s3_directory_bucket.example.arn
}

output "directory_bucket_id" {
  description = "Directory BucketのID(非推奨、代わりにbucketを使用)"
  # - 非推奨: 今後のバージョンで削除される可能性があります
  # - 代わりに bucket 属性を使用してください
  value = aws_s3_directory_bucket.example.id
}

output "directory_bucket_name" {
  description = "Directory Bucketの名前"
  # - 作成されたバケットの名前
  # - S3 API呼び出しで使用
  value = aws_s3_directory_bucket.example.bucket
}

output "directory_bucket_tags_all" {
  description = "割り当てられた全タグ(provider default_tags含む)"
  # - リソースに割り当てられたすべてのタグのマップ
  # - provider default_tagsからの継承タグを含む
  value = aws_s3_directory_bucket.example.tags_all
}

# ================================================================================
# Best Practices & Recommendations
# ================================================================================
# 1. パフォーマンス最適化
#    - コンピュートリソース(EC2/EKS/ECS)と同じAZにバケットを配置
#    - Regional endpointとZonal endpointを適切に使い分ける
#    - 必要に応じてTPS上限の引き上げをAWSに申請
#    - 毎秒200万読み取り/20万書き込みの上限を考慮した設計
#
# 2. コスト最適化
#    - ストレージコストはS3 Standardより約20%高いが、リクエストコストは大幅に低い
#    - 高頻度アクセスパターンの場合、トータルコストは削減される可能性あり
#    - 適切なデータライフサイクル管理でコストを最適化
#
# 3. 可用性と耐久性
#    - 単一AZ内での99.95%可用性(AZ障害時はデータアクセス不可)
#    - ミッションクリティカルなデータは別途レプリケーションを検討
#    - AZ障害リスクを理解し、適切なバックアップ戦略を実装
#
# 4. セキュリティ
#    - デフォルトでSSE-S3暗号化が有効
#    - SSE-KMSも使用可能(KMS RPSクォータに注意)
#    - Block Public Accessは常に有効(変更不可)
#    - Object Ownershipは "Bucket owner enforced" のみサポート
#
# 5. 命名規則
#    - 必須フォーマット: [bucket_name]--[azid]--x-s3
#    - ゾーン内で一意の名前を使用
#    - 機密情報をバケット名に含めない(URLに表示されます)
#    - 一貫性のある命名パターンを組織全体で採用
#
# 6. リソース管理
#    - force_destroyは本番環境では慎重に使用
#    - タグを活用してコスト配分とリソース追跡を実施
#    - provider default_tagsで共通タグを一元管理
#
# 7. モニタリング・ログ
#    - CloudWatch metricsでパフォーマンスを監視
#    - CloudTrailでAPI呼び出しを記録
#    - アクセスパターンを分析してキャパシティプランニング
#
# 8. ネットワーク設計
#    - VPCエンドポイント経由でのプライベートアクセスを検討
#    - Regional endpointとZonal endpointの使い分け:
#      * Zonal endpoint: 最高パフォーマンス(同一AZ内)
#      * Regional endpoint: 複数AZからのアクセス
#
# 9. データ移行
#    - 既存のS3バケットからの移行計画を慎重に立案
#    - S3 Batch Operationsで大規模データ移行を効率化
#    - データ転送コストと時間を事前に見積もる
#
# 10. 制限事項の理解
#     - General Purpose Bucketと異なるAPI操作があることに注意
#     - 一部のS3機能(S3 Select、Glacier移行など)は未サポート
#     - オブジェクトバージョニングは未サポート
#     - レプリケーション(CRR/SRR)は未サポート
# ================================================================================

# ================================================================================
# Related Resources
# ================================================================================
# - aws_s3_bucket: General Purpose Bucket管理(Directory Bucketとは別リソース)
# - aws_s3_access_point: Directory Bucket用のアクセスポイント
# - aws_vpc: VPC設定(VPCエンドポイント経由のアクセス用)
# - aws_kms_key: SSE-KMS暗号化用のKMSキー
# - aws_iam_policy: Directory Bucketアクセス用のIAMポリシー
# ================================================================================

# ================================================================================
# Import
# ================================================================================
# 既存のDirectory Bucketをインポート可能
#
# terraform import aws_s3_directory_bucket.example bucket-name--azid--x-s3
#
# 例:
# terraform import aws_s3_directory_bucket.example my-bucket--usw2-az1--x-s3
# ================================================================================

# ================================================================================
# Additional Resources & Documentation
# ================================================================================
# - S3 Express One Zone User Guide:
#   https://docs.aws.amazon.com/AmazonS3/latest/userguide/s3-express-one-zone.html
# - Directory Bucket Naming Rules:
#   https://docs.aws.amazon.com/AmazonS3/latest/userguide/directory-bucket-naming-rules.html
# - Supported Regions and Availability Zones:
#   https://docs.aws.amazon.com/AmazonS3/latest/userguide/s3-express-Endpoints.html
# - Performance Optimization Guide:
#   https://docs.aws.amazon.com/AmazonS3/latest/userguide/s3-express-performance.html
# - Pricing Information:
#   https://aws.amazon.com/s3/pricing/
# ================================================================================
