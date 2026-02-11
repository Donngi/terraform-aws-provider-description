#---------------------------------------------------------------
# AWS Redshift Usage Limit
#---------------------------------------------------------------
#
# Amazon Redshift Usage Limit を作成するリソースです。
# Redshift の使用量に対して制限を設定し、コストやリソースの使用を
# 管理できます。Spectrum、同時実行スケーリング、クロスリージョン
# データ共有などの機能の使用量を制限できます。
#
# AWS公式ドキュメント:
#   - Redshift Usage Limits: https://docs.aws.amazon.com/redshift/latest/mgmt/managing-cluster-usage-limits.html
#   - Redshift Spectrum: https://docs.aws.amazon.com/redshift/latest/dg/c-using-spectrum.html
#   - Concurrency Scaling: https://docs.aws.amazon.com/redshift/latest/dg/concurrency-scaling.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/redshift_usage_limit
#
# Provider Version: 6.28.0
# Generated: 2026-02-03
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_redshift_usage_limit" "example" {
  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # クラスター識別子
  #-------------------------------------------------------------

  # cluster_identifier (Required)
  # 設定内容: 使用量を制限する Redshift クラスターの識別子を指定します。
  # 設定可能な値: 既存の Redshift クラスター ID
  # 注意: クラスターが存在している必要があります。
  cluster_identifier = aws_redshift_cluster.example.id

  #-------------------------------------------------------------
  # 機能タイプ設定
  #-------------------------------------------------------------

  # feature_type (Required)
  # 設定内容: 制限する Amazon Redshift の機能を指定します。
  # 設定可能な値:
  #   - "spectrum": Redshift Spectrum の使用量を制限
  #   - "concurrency-scaling": 同時実行スケーリングの使用量を制限
  #   - "cross-region-datasharing": クロスリージョンデータ共有の使用量を制限
  # 注意:
  #   - spectrum の場合、limit_type は "data-scanned" である必要があります
  #   - concurrency-scaling の場合、limit_type は "time" である必要があります
  #   - cross-region-datasharing の場合、limit_type は "data-scanned" である必要があります
  feature_type = "concurrency-scaling"

  #-------------------------------------------------------------
  # 制限タイプ設定
  #-------------------------------------------------------------

  # limit_type (Required)
  # 設定内容: 制限のタイプを指定します。機能タイプに応じて時間またはデータサイズベースです。
  # 設定可能な値:
  #   - "data-scanned": データスキャン量ベースの制限（TB単位）
  #   - "time": 時間ベースの制限（分単位）
  # 注意:
  #   - FeatureType が "spectrum" の場合、LimitType は "data-scanned" である必要があります
  #   - FeatureType が "concurrency-scaling" の場合、LimitType は "time" である必要があります
  #   - FeatureType が "cross-region-datasharing" の場合、LimitType は "data-scanned" である必要があります
  limit_type = "time"

  #-------------------------------------------------------------
  # 使用量制限設定
  #-------------------------------------------------------------

  # amount (Required)
  # 設定内容: 制限量を指定します。
  # 設定可能な値:
  #   - 時間ベースの場合: 分単位の正の整数
  #   - データベースの場合: テラバイト（TB）単位の正の整数
  # 注意: 正の数値である必要があります。
  # 例:
  #   - 同時実行スケーリングで60分の制限: 60
  #   - Spectrum で100TBの制限: 100
  amount = 60

  #-------------------------------------------------------------
  # 制限期間設定
  #-------------------------------------------------------------

  # period (Optional)
  # 設定内容: 制限量が適用される期間を指定します。
  # 設定可能な値:
  #   - "daily": 日次（毎日リセット）
  #   - "weekly": 週次（毎週日曜日にリセット）
  #   - "monthly": 月次（毎月1日にリセット）
  # 省略時: "monthly" がデフォルト
  # 注意: 週次期間は日曜日に始まります。
  period = "monthly"

  #-------------------------------------------------------------
  # 制限超過時のアクション設定
  #-------------------------------------------------------------

  # breach_action (Optional)
  # 設定内容: 制限に達した際に Amazon Redshift が実行するアクションを指定します。
  # 設定可能な値:
  #   - "log": ログに記録のみ（デフォルト）
  #   - "emit-metric": CloudWatch メトリクスを発行
  #   - "disable": 機能を無効化
  # 省略時: "log"
  # 注意:
  #   - "disable" は機能を完全に停止するため、アプリケーションに影響する可能性があります
  #   - "emit-metric" を使用すると CloudWatch アラームと統合できます
  breach_action = "log"

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWS リソースタグ付け
  #   プロバイダーレベルの default_tags 設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "redshift-usage-limit-example"
    Environment = "production"
  }

  # tags_all (Optional, Computed)
  # 設定内容: プロバイダーの default_tags から継承されたタグを含む全タグのマップです。
  # 注意: 通常は明示的に設定せず、Terraform が自動計算します。
  # tags_all = {}
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: Redshift Usage Limit の ID
#
# - arn: Redshift Usage Limit の Amazon Resource Name (ARN)
#
# - tags_all: プロバイダーの default_tags 設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------

#---------------------------------------------------------------
# resource "aws_redshift_usage_limit" "spectrum_limit" {
#   cluster_identifier = aws_redshift_cluster.example.id
#   feature_type       = "spectrum"
#   limit_type         = "data-scanned"
#   amount             = 100  # 100 TB
#   period             = "monthly"
#   breach_action      = "emit-metric"
#
#   tags = {
#     Name = "spectrum-data-scan-limit"
#   }
#---------------------------------------------------------------
# resource "aws_redshift_usage_limit" "cross_region_limit" {
#   cluster_identifier = aws_redshift_cluster.example.id
#   feature_type       = "cross-region-datasharing"
#   limit_type         = "data-scanned"
#   amount             = 50  # 50 TB
#   period             = "weekly"
#   breach_action      = "disable"
#
#   tags = {
#     Name = "cross-region-datasharing-limit"
#   }
# }
