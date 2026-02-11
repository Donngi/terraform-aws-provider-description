################################################################################
# AWS Cost and Usage Report Definition
################################################################################
# Generated: 2026-01-19
# Provider Version: hashicorp/aws 6.28.0
#
# NOTE: このテンプレートは生成時点の情報です。
#       最新の仕様については公式ドキュメントを確認してください。
#       https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cur_report_definition
#
# IMPORTANT: AWS Cost and Usage Report service is only available in us-east-1
################################################################################

resource "aws_cur_report_definition" "example" {
  ################################################################################
  # Required Arguments
  ################################################################################

  # レポート名
  # 一意である必要があり、大文字小文字を区別します。スペースを含めることはできません。
  # 最大256文字まで。数字または文字で始まる必要があります。
  # Pattern: [0-9A-Za-z!\-_.*'()]+
  # https://docs.aws.amazon.com/aws-cost-management/latest/APIReference/API_cur_ReportDefinition.html
  report_name = "example-cur-report-definition"

  # レポートのデータが測定および表示される頻度
  # 有効な値: HOURLY, DAILY, MONTHLY
  # HOURLY: 時間ごとの粒度でコストと使用状況を追跡
  # DAILY: 日次の粒度でコストと使用状況を追跡
  # MONTHLY: 月次の粒度でコストと使用状況を追跡
  # https://docs.aws.amazon.com/aws-cost-management/latest/APIReference/API_cur_ReportDefinition.html
  time_unit = "HOURLY"

  # レポートのフォーマット
  # 有効な値: textORcsv, Parquet
  # - textORcsv: CSV形式のレポート（compressionはGZIPまたはZIPを指定）
  # - Parquet: Parquet形式のレポート（compressionもParquetを指定する必要がある）
  # Parquetを使用する場合、compressionパラメータも必ずParquetに設定してください。
  # https://docs.aws.amazon.com/aws-cost-management/latest/APIReference/API_cur_ReportDefinition.html
  format = "textORcsv"

  # レポートの圧縮形式
  # 有効な値: GZIP, ZIP, Parquet
  # - GZIP: GZIP圧縮（formatはtextORcsvを指定）
  # - ZIP: ZIP圧縮（formatはtextORcsvを指定）
  # - Parquet: Parquet圧縮（formatもParquetを指定する必要がある）
  # Parquetを使用する場合、formatパラメータも必ずParquetに設定してください。
  # https://docs.aws.amazon.com/aws-cost-management/latest/APIReference/API_cur_ReportDefinition.html
  compression = "GZIP"

  # レポートに含める追加のスキーマ要素のリスト
  # 有効な値: RESOURCES, SPLIT_COST_ALLOCATION_DATA, MANUAL_DISCOUNT_COMPATIBILITY
  # - RESOURCES: 個別のリソースIDなどの情報を含める
  # - SPLIT_COST_ALLOCATION_DATA: コスト配分データを分割して含める
  # - MANUAL_DISCOUNT_COMPATIBILITY: 手動割引との互換性データを含める
  # https://docs.aws.amazon.com/aws-cost-management/latest/APIReference/API_cur_ReportDefinition.html
  additional_schema_elements = ["RESOURCES", "SPLIT_COST_ALLOCATION_DATA"]

  # 生成されたレポートを保存する既存のS3バケット名
  # S3バケットは、レポートの作成に使用されたAWSアカウントによって所有されている必要があります。
  # 最大256文字まで。Pattern: [A-Za-z0-9_\.\-]+
  # https://docs.aws.amazon.com/aws-cost-management/latest/APIReference/API_cur_ReportDefinition.html
  s3_bucket = "example-bucket-name"

  # レポートのS3パスプレフィックス
  # 最大256文字まで。スペースを含めることはできません。
  # 空の文字列("")も可能ですが、その場合AWSコンソールからリソースを変更できなくなります。
  # Pattern: [0-9A-Za-z!\-_.*'()/]*
  # https://docs.aws.amazon.com/aws-cost-management/latest/APIReference/API_cur_ReportDefinition.html
  s3_prefix = "example-cur-report"

  # 生成されたレポートを保存するS3バケットのリージョン
  # 有効な値: af-south-1, ap-east-1, ap-south-1, ap-south-2, ap-southeast-1,
  #          ap-southeast-2, ap-southeast-3, ap-northeast-1, ap-northeast-2,
  #          ap-northeast-3, ca-central-1, eu-central-1, eu-central-2, eu-west-1,
  #          eu-west-2, eu-west-3, eu-north-1, eu-south-1, eu-south-2,
  #          me-central-1, me-south-1, sa-east-1, us-east-1, us-east-2,
  #          us-west-1, us-west-2, cn-north-1, cn-northwest-1
  # https://docs.aws.amazon.com/aws-cost-management/latest/APIReference/API_cur_ReportDefinition.html
  s3_region = "us-east-1"

  ################################################################################
  # Optional Arguments
  ################################################################################

  # このレポートに対してAWSが作成するマニフェストのリスト（追加アーティファクト）
  # 有効な値: REDSHIFT, QUICKSIGHT, ATHENA
  # - REDSHIFT: Amazon Redshift用のマニフェストを生成
  # - QUICKSIGHT: Amazon QuickSight用のマニフェストを生成
  # - ATHENA: Amazon Athena用のマニフェストを生成
  # ATHENAがadditional_artifacts内に存在する場合、他のアーティファクトタイプは宣言できず、
  # report_versioningはOVERWRITE_REPORTである必要があります。
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cur_report_definition
  additional_artifacts = ["REDSHIFT", "QUICKSIGHT"]

  # AWSが前の月に関連する料金を検出した場合、確定後にレポートを更新するかどうか
  # これらの料金には、返金、クレジット、またはサポート料金が含まれる場合があります。
  # true: 確定後もレポートを更新する
  # false: 確定後はレポートを更新しない（デフォルト）
  # https://docs.aws.amazon.com/aws-cost-management/latest/APIReference/API_cur_ReportDefinition.html
  refresh_closed_reports = true

  # レポートのバージョニング方法
  # 有効な値: CREATE_NEW_REPORT, OVERWRITE_REPORT
  # - CREATE_NEW_REPORT: 以前のバージョンに加えてレポートを配信する
  # - OVERWRITE_REPORT: 以前のバージョンを上書きする
  # ATHENAを使用する場合は、OVERWRITE_REPORTを指定する必要があります。
  # https://docs.aws.amazon.com/aws-cost-management/latest/APIReference/API_cur_ReportDefinition.html
  report_versioning = "OVERWRITE_REPORT"

  # リソースに割り当てるタグのキーと値のペア
  # プロバイダーのdefault_tags設定ブロックが存在する場合、
  # 一致するキーを持つタグはプロバイダーレベルで定義されたものを上書きします。
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cur_report_definition
  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
  }

  # NOTE: 以下の属性は含まれていません
  # - id: オプション + computed属性（通常は指定不要）
  # - tags_all: computed属性（プロバイダーのdefault_tagsから自動計算される）
}

################################################################################
# Computed Attributes (Read-Only)
################################################################################
# これらの属性はTerraformによって自動的に計算され、参照のみ可能です。
#
# - arn: Cost and Usage Reportを指定するAmazon Resource Name (ARN)
#
# 参照例:
# output "cur_report_arn" {
#   value = aws_cur_report_definition.example.arn
# }
################################################################################
