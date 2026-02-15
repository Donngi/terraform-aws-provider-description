#--------------------------------------------------------------
# AWS Cost and Usage Report Definition
#--------------------------------------------------------------
# AWS Cost and Usage Reportの定義を管理するリソース
# コストと使用状況データをS3バケットに定期的に配信する設定を行う
#
# Provider Version: 6.28.0
# Generated: 2026-02-13
#
# NOTE: このリソースはus-east-1リージョンでのみ作成可能です
#
# 関連ドキュメント:
# - https://docs.aws.amazon.com/cur/latest/userguide/what-is-cur.html
# - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/cur_report_definition
#
# 前提条件:
# - S3バケットが作成済みであること
# - S3バケットにCURサービスからの書き込み権限が付与されていること
# - us-east-1リージョンのプロバイダー設定が必要
#
# 主な用途:
# - コスト分析とレポーティング
# - 予算管理とコスト最適化
# - チャージバックとショーバック
# - コストアロケーション
#--------------------------------------------------------------

resource "aws_cur_report_definition" "example" {
  #--------------------------------------------------------------
  # レポート基本設定
  #--------------------------------------------------------------

  # 設定内容: レポートの一意な名前
  # 制約事項: 256文字以内、英数字、アンダースコア、ハイフンのみ使用可能
  report_name = "example-cost-report"

  # 設定内容: レポートの時間単位
  # 設定可能な値: HOURLY, DAILY, MONTHLY
  # 制約事項: レポート作成後は変更不可
  time_unit = "DAILY"

  #--------------------------------------------------------------
  # データスキーマとフォーマット
  #--------------------------------------------------------------

  # 設定内容: レポートに含める追加のスキーマ要素
  # 設定可能な値: RESOURCES (リソースID情報)
  # 推奨設定: ["RESOURCES"] - 詳細なリソース分析に必要
  additional_schema_elements = ["RESOURCES"]

  # 設定内容: レポートのフォーマット形式
  # 設定可能な値: textORcsv, Parquet
  # 推奨設定: Parquet - データサイズが小さくクエリパフォーマンスが高い
  format = "Parquet"

  # 設定内容: レポートファイルの圧縮形式
  # 設定可能な値: ZIP, GZIP, Parquet (formatがParquetの場合)
  # 注意事項: formatがParquetの場合は必ずParquetを指定
  compression = "Parquet"

  # 設定内容: レポートに含める追加のアーティファクト
  # 設定可能な値: REDSHIFT, QUICKSIGHT, ATHENA
  # 省略時: 追加アーティファクトなし
  additional_artifacts = ["ATHENA"]

  #--------------------------------------------------------------
  # S3配信先設定
  #--------------------------------------------------------------

  # 設定内容: レポート配信先のS3バケット名
  # 前提条件: バケットポリシーでCURサービスへの書き込み権限付与が必要
  s3_bucket = "example-cur-reports-bucket"

  # 設定内容: S3バケット内のプレフィックス（パス）
  # 設定例: "cur-reports/" - レポートの保存先ディレクトリ
  s3_prefix = "cur-reports/"

  # 設定内容: S3バケットが存在するリージョン
  # 設定可能な値: 有効なAWSリージョンコード
  s3_region = "us-east-1"

  #--------------------------------------------------------------
  # レポート更新設定
  #--------------------------------------------------------------

  # 設定内容: レポートのバージョニング方式
  # 設定可能な値: CREATE_NEW_REPORT, OVERWRITE_REPORT
  # 省略時: CREATE_NEW_REPORT
  # 推奨設定: CREATE_NEW_REPORT - 過去のレポートを保持
  report_versioning = "CREATE_NEW_REPORT"

  # 設定内容: 確定した過去レポートを更新するか
  # 省略時: false
  # 推奨設定: true - リファンドやクレジットの反映に必要
  refresh_closed_reports = true

  #--------------------------------------------------------------
  # タグ設定
  #--------------------------------------------------------------

  # 設定内容: リソースに付与するタグ
  # 用途: コスト配分、リソース管理、検索の容易化
  tags = {
    Environment = "production"
    Service     = "cost-management"
    ManagedBy   = "terraform"
  }
}

#--------------------------------------------------------------
# Attributes Reference
#--------------------------------------------------------------
# このリソースをapply後に参照可能な属性:
#
# - id: レポート定義のID（report_nameと同一）
# - arn: レポート定義のARN
#   形式: arn:aws:cur:us-east-1:123456789012:definition/example-cost-report
# - tags_all: デフォルトタグを含む全てのタグのマップ
#
# 参照例:
# output "cur_report_arn" {
#   value = aws_cur_report_definition.example.arn
# }
