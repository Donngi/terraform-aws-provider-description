# ================================================================================
# AWS S3 Control Directory Bucket Access Point Scope - Terraform Annotated Template
# ================================================================================
# Provider Version: 6.28.0
# Resource: aws_s3control_directory_bucket_access_point_scope
#
# Overview:
# - Directory Bucketのアクセスポイントに対してスコープを管理するリソースです
# - アクセスポイントスコープを使用して、特定のプレフィックス、APIアクション、
#   またはその両方の組み合わせへのアクセスを制限できます
# - プレフィックスは任意の数を指定できますが、すべてのプレフィックスの
#   文字数の合計は256バイト未満である必要があります
# - Directory BucketはAWS Local Zonesで利用可能で、高スループット・
#   低レイテンシーのワークロードに最適化されています
#
# Important Notes:
# - AWS Local Zonesのすべてのサービス(Amazon S3を含む)では、Local Zoneで
#   リソースを作成またはアクセスする前に、アカウントIDを有効化する必要があります
# - Terraformはアクセスポイントスコープを管理する2つの方法を提供します:
#   1. このスタンドアロンリソース (aws_s3control_directory_bucket_access_point_scope)
#   2. aws_s3_directory_access_pointリソースのインラインスコープ
#   両方を同時に使用することはできません(互いに上書きされます)
# - スコープを削除するには、{permissions=[] prefixes=[]} を設定します
# - デフォルトスコープは {permissions=[] prefixes=[]} です
#
# Use Cases:
# - Directory Bucket内の特定のプレフィックスへのアクセス制限
# - 特定のS3 API操作のみを許可するセキュリティ制御
# - 複数のアプリケーションやチームに対する細かいアクセス管理
# - AWS Local Zonesでの低レイテンシーデータアクセスの最適化
# ================================================================================

# ================================================================================
# Example 1: Basic Directory Bucket Access Point Scope
# ================================================================================
# Directory Bucketアクセスポイントに対する基本的なスコープ設定
# - 特定のプレフィックスへのアクセスを制限
# - 読み取り操作(GetObject、ListBucket)のみを許可
# ================================================================================

# Directory Bucketの作成
data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_s3_directory_bucket" "example" {
  bucket = "example-bucket--${data.aws_availability_zones.available.zone_ids[0]}--x-s3"

  location {
    name = data.aws_availability_zones.available.zone_ids[0]
  }
}

# Directory Bucket用のアクセスポイント
resource "aws_s3_access_point" "example" {
  bucket = aws_s3_directory_bucket.example.id
  # Directory Bucketアクセスポイントの命名規則: "name--zoneId--xa-s3"
  name = "example-ap--${data.aws_availability_zones.available.zone_ids[0]}--xa-s3"
}

resource "aws_s3control_directory_bucket_access_point_scope" "example" {
  # ================================================================================
  # Required Arguments
  # ================================================================================

  # account_id - (Required) 指定されたアクセスポイントを所有するAWSアカウントID
  # - 12桁のAWSアカウント番号
  # - アクセスポイントのオーナーアカウントを明示的に指定
  # - クロスアカウントアクセスの場合は特に重要
  account_id = "123456789012"

  # name - (Required) スコープを適用するアクセスポイントの名前
  # - Directory Bucketアクセスポイントの完全な名前を指定
  # - 命名規則: "name--zoneId--xa-s3" 形式
  # - 例: "example-ap--usw2-az1--xa-s3"
  name = aws_s3_access_point.example.name

  # ================================================================================
  # Optional Arguments
  # ================================================================================

  # region - (Optional) リソースを管理するリージョン
  # - デフォルト: プロバイダー設定のリージョン
  # - Directory Bucketが存在するリージョンと一致させる必要があります
  # region = "us-west-2"

  # ================================================================================
  # scope Block (Optional)
  # ================================================================================
  # - 特定のプレフィックス、API操作、またはその両方の組み合わせへのアクセスを制限
  # - スコープを削除する場合は {permissions=[] prefixes=[]} を設定
  # - デフォルトスコープは {permissions=[] prefixes=[]} です
  # - max_items: 1
  # ================================================================================
  scope {
    # permissions - (Optional) 許可するAPI操作のリスト
    # - Type: 文字列の配列
    # - 有効な値:
    #   * GetObject: オブジェクトの取得
    #   * GetObjectAttributes: オブジェクト属性の取得
    #   * ListMultipartUploadParts: マルチパートアップロードのパート一覧取得
    #   * ListBucket: バケット内のオブジェクト一覧取得
    #   * ListBucketMultipartUploads: バケット内のマルチパートアップロード一覧取得
    #   * PutObject: オブジェクトのアップロード
    #   * DeleteObject: オブジェクトの削除
    #   * AbortMultipartUpload: マルチパートアップロードの中止
    # - 空の配列の場合、すべての操作が許可されます(他の制約に従う)
    # - 1つ以上のAPI操作を含めることができます
    permissions = ["GetObject", "ListBucket"]

    # prefixes - (Optional) アクセスを許可するプレフィックスのリスト
    # - Type: 文字列の配列
    # - すべてのプレフィックスの文字数の合計は256バイト未満である必要があります
    # - ワイルドカード(*)を使用してパターンマッチングが可能
    # - 例: "myobject1.csv" (特定のファイル)
    # - 例: "myobject2*" (プレフィックスにマッチするすべてのオブジェクト)
    # - 例: "data/" (特定のディレクトリ内のすべてのオブジェクト)
    # - 空の配列の場合、すべてのプレフィックスが許可されます(他の制約に従う)
    # - 任意の数のプレフィックスを指定できます(合計256バイト未満)
    prefixes = ["myobject1.csv", "myobject2*"]
  }
}

# ================================================================================
# Example 2: Full Access Scope (Read and Write)
# ================================================================================
# 読み取りと書き込みの両方を許可する完全なアクセススコープ
# - 特定のプレフィックスに対するすべての主要な操作を許可
# ================================================================================

resource "aws_s3_directory_bucket" "full_access_example" {
  bucket = "full-access-bucket--${data.aws_availability_zones.available.zone_ids[0]}--x-s3"

  location {
    name = data.aws_availability_zones.available.zone_ids[0]
  }
}

resource "aws_s3_access_point" "full_access_example" {
  bucket = aws_s3_directory_bucket.full_access_example.id
  name   = "full-access-ap--${data.aws_availability_zones.available.zone_ids[0]}--xa-s3"
}

resource "aws_s3control_directory_bucket_access_point_scope" "full_access" {
  account_id = "123456789012"
  name       = aws_s3_access_point.full_access_example.name

  scope {
    # 読み取り、書き込み、削除を含むすべての主要な操作を許可
    permissions = [
      "GetObject",
      "GetObjectAttributes",
      "PutObject",
      "DeleteObject",
      "ListBucket",
      "ListBucketMultipartUploads",
      "ListMultipartUploadParts",
      "AbortMultipartUpload"
    ]

    # データディレクトリ内のすべてのオブジェクトへのアクセスを許可
    prefixes = ["data/*"]
  }
}

# ================================================================================
# Example 3: Restricted Scope with Multiple Prefixes
# ================================================================================
# 複数のプレフィックスに対する制限されたスコープ
# - 異なるデータカテゴリへのアクセスを管理
# - ワイルドカードを使用したパターンマッチング
# ================================================================================

resource "aws_s3_directory_bucket" "multi_prefix_example" {
  bucket = "multi-prefix-bucket--${data.aws_availability_zones.available.zone_ids[0]}--x-s3"

  location {
    name = data.aws_availability_zones.available.zone_ids[0]
  }
}

resource "aws_s3_access_point" "multi_prefix_example" {
  bucket = aws_s3_directory_bucket.multi_prefix_example.id
  name   = "multi-prefix-ap--${data.aws_availability_zones.available.zone_ids[0]}--xa-s3"
}

resource "aws_s3control_directory_bucket_access_point_scope" "multi_prefix" {
  account_id = "123456789012"
  name       = aws_s3_access_point.multi_prefix_example.name

  scope {
    # 読み取り専用アクセス
    permissions = ["GetObject", "GetObjectAttributes", "ListBucket"]

    # 複数のプレフィックスパターン
    # - logs/配下のすべてのファイル
    # - reports/2024/配下のすべてのファイル
    # - config.jsonという特定のファイル
    # 注意: すべてのプレフィックスの合計は256バイト未満である必要があります
    prefixes = [
      "logs/*",
      "reports/2024/*",
      "config.json"
    ]
  }
}

# ================================================================================
# Example 4: Removing Access Point Scope
# ================================================================================
# アクセスポイントスコープを削除する方法
# - 空のpermissionsとprefixesを設定してデフォルトスコープに戻す
# ================================================================================

resource "aws_s3_directory_bucket" "no_scope_example" {
  bucket = "no-scope-bucket--${data.aws_availability_zones.available.zone_ids[0]}--x-s3"

  location {
    name = data.aws_availability_zones.available.zone_ids[0]
  }
}

resource "aws_s3_access_point" "no_scope_example" {
  bucket = aws_s3_directory_bucket.no_scope_example.id
  name   = "no-scope-ap--${data.aws_availability_zones.available.zone_ids[0]}--xa-s3"
}

resource "aws_s3control_directory_bucket_access_point_scope" "no_scope" {
  account_id = "123456789012"
  name       = aws_s3_access_point.no_scope_example.name

  # スコープを削除するには、空のpermissionsとprefixesを設定
  # これによりデフォルトスコープ {permissions=[] prefixes=[]} に戻ります
  scope {
    permissions = []
    prefixes    = []
  }
}

# ================================================================================
# Computed Attributes (Output Examples)
# ================================================================================
# アクセスポイントスコープリソースには読み取り専用属性はありません
# このリソースは設定した値を反映するのみです

# ================================================================================
# Best Practices & Recommendations
# ================================================================================
# 1. セキュリティ
#    - 最小権限の原則に従い、必要最小限のpermissionsのみを許可
#    - できるだけ具体的なprefixesを指定してアクセス範囲を限定
#    - 読み取り専用アクセスが十分な場合は、書き込み権限を付与しない
#    - アクセスポイントポリシーと組み合わせて多層防御を実装
#
# 2. プレフィックス管理
#    - プレフィックスの合計文字数は256バイト未満に制限
#    - ワイルドカード(*)を効果的に使用してパターンマッチング
#    - 論理的なディレクトリ構造を計画してプレフィックス管理を簡素化
#    - 異なるアクセスパターンには別々のアクセスポイントを作成
#
# 3. パーミッション設定
#    - アプリケーションの要件に基づいて必要なAPI操作のみを許可
#    - 読み取り操作: GetObject, GetObjectAttributes, ListBucket
#    - 書き込み操作: PutObject
#    - 削除操作: DeleteObject
#    - マルチパート操作: ListMultipartUploadParts, ListBucketMultipartUploads,
#      AbortMultipartUpload
#
# 4. スコープ管理戦略
#    - スタンドアロンリソースとインラインスコープを混在させない
#    - スコープ変更は慎重に計画し、既存のアクセスパターンへの影響を評価
#    - スコープ削除時は明示的に {permissions=[] prefixes=[]} を設定
#
# 5. Directory Bucket固有の考慮事項
#    - AWS Local Zonesでのアカウント有効化を事前に確認
#    - アクセスポイント名は "name--zoneId--xa-s3" 形式に従う
#    - Directory Bucketとアクセスポイントは同じZone IDに配置
#    - 高スループット・低レイテンシー要件に最適化された設計
#
# 6. モニタリング・ログ
#    - CloudTrailでアクセスポイント経由のAPI呼び出しを記録
#    - S3サーバーアクセスログでリクエストの詳細を追跡
#    - CloudWatchメトリクスでアクセスパターンを監視
#    - 異常なアクセスパターンに対するアラートを設定
#
# 7. コスト最適化
#    - 必要なプレフィックスのみにアクセスを制限してデータ転送コストを削減
#    - 不要になったアクセスポイントスコープは削除
#    - Local Zonesの使用コストを考慮した設計
#
# 8. 運用管理
#    - アクセスポイントスコープの変更履歴を文書化
#    - 定期的なアクセス権限のレビューと監査
#    - 環境(dev, staging, prod)ごとに異なるスコープ設定を管理
#    - Terraformのstateファイルを安全に管理
# ================================================================================

# ================================================================================
# Related Resources
# ================================================================================
# - aws_s3_directory_bucket: Directory Bucket本体
# - aws_s3_access_point: Directory Bucket用のアクセスポイント
# - aws_s3control_access_point_policy: アクセスポイントポリシー
# - aws_availability_zones: 利用可能なAvailability Zone情報の取得
# - aws_iam_policy: アクセスポイントを使用するための IAM ポリシー
# ================================================================================

# ================================================================================
# Import
# ================================================================================
# 既存のDirectory Bucketアクセスポイントスコープをインポート可能
#
# フォーマット: account-id:access-point-name
# terraform import aws_s3control_directory_bucket_access_point_scope.example 123456789012:example-ap--usw2-az1--xa-s3
# ================================================================================

# ================================================================================
# Documentation References
# ================================================================================
# - AWS Documentation - Manage access point scope:
#   https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-points-directory-buckets-manage-scope.html
#
# - AWS API Reference - PutAccessPointScope:
#   https://docs.aws.amazon.com/AmazonS3/latest/API/API_control_PutAccessPointScope.html
#
# - AWS API Reference - Scope:
#   https://docs.aws.amazon.com/AmazonS3/latest/API/API_control_Scope.html
#
# - AWS Documentation - Directory Buckets Access Points:
#   https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-points-directory-buckets.html
#
# - AWS Documentation - Opt-in to Local Zones:
#   https://docs.aws.amazon.com/AmazonS3/latest/userguide/opt-in-directory-bucket-lz.html
#
# - Terraform Registry - aws_s3control_directory_bucket_access_point_scope:
#   https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3control_directory_bucket_access_point_scope
# ================================================================================
