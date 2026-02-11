#---------------------------------------------------------------
# Amazon Redshift Serverless Usage Limit
#---------------------------------------------------------------
#
# Amazon Redshift Serverless Usage Limitリソースは、Redshift Serverlessワークグループの
# 使用量制限を設定するために使用されます。コンピューティング使用量やクロスリージョン
# データ共有の使用量に対して制限を設定でき、使用量が制限に達した際のアクションを
# 定義できます。
#
# 主な用途:
#   - Redshift Serverlessのコンピューティング使用量の制限設定
#   - クロスリージョンデータ共有の使用量制限
#   - 使用量制限到達時のアクション設定 (ログ記録、メトリクス送信、無効化)
#   - コスト管理と予算管理の実装
#
# AWS公式ドキュメント:
#   - Redshift Serverless 概要: https://docs.aws.amazon.com/redshift/latest/mgmt/serverless-overview.html
#   - Usage Limits: https://docs.aws.amazon.com/redshift/latest/mgmt/serverless-usage-limits.html
#   - Redshift Serverless API リファレンス: https://docs.aws.amazon.com/redshift-serverless/latest/APIReference/Welcome.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/redshiftserverless_usage_limit
#
# Provider Version: 6.28.0
# Generated: 2026-02-03
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_redshiftserverless_usage_limit" "example" {
  #-------------------------------------------------------------
  # 必須パラメータ
  #-------------------------------------------------------------

  # resource_arn (Required)
  # 設定内容: 使用量制限を作成するAmazon Redshift Serverlessリソース(ワークグループ)のARNを指定します。
  # 設定可能な値: 有効なRedshift ServerlessワークグループのARN
  # 用途: 使用量制限を適用する対象ワークグループの指定に必須
  # 関連機能: Redshift Serverless Workgroup
  #   ワークグループは、Redshift Serverlessのコンピューティングリソースを管理する単位です。
  #   使用量制限はワークグループに対して設定されます。
  #   - https://docs.aws.amazon.com/redshift/latest/mgmt/serverless-workgroups.html
  resource_arn = aws_redshiftserverless_workgroup.example.arn

  # usage_type (Required)
  # 設定内容: 使用量制限を作成するAmazon Redshift Serverless使用量のタイプを指定します。
  # 設定可能な値:
  #   - "serverless-compute": サーバーレスコンピューティング使用量の制限
  #   - "cross-region-datasharing": クロスリージョンデータ共有の使用量制限
  # 用途: 制限対象となる使用量のタイプを指定
  # 関連機能: Redshift Serverless Usage Types
  #   serverless-compute: RPU(Redshift Processing Units)時間単位で測定されるコンピューティング使用量
  #   cross-region-datasharing: リージョン間でのデータ転送量(TB単位)
  #   - https://docs.aws.amazon.com/redshift/latest/mgmt/serverless-usage-limits.html
  usage_type = "serverless-compute"

  # amount (Required)
  # 設定内容: 使用量制限の量を指定します。
  # 設定可能な値: 正の数値
  # 時間ベースの場合: 1時間あたりに消費されるRedshift Processing Units (RPU)
  # データベースの場合: クロスアカウント共有でリージョン間転送されるデータ量(テラバイト単位)
  # 用途: 使用量の上限値を設定してコスト管理を実施
  # 関連機能: Usage Limit Amount
  #   serverless-computeの場合はRPU時間、cross-region-datasharingの場合はTB単位で指定。
  #   制限値に達するとbreach_actionで指定されたアクションが実行されます。
  #   - https://docs.aws.amazon.com/redshift/latest/mgmt/serverless-usage-limits.html
  amount = 60

  #-------------------------------------------------------------
  # オプションパラメータ
  #-------------------------------------------------------------

  # breach_action (Optional)
  # 設定内容: 使用量制限に達した際にAmazon Redshift Serverlessが取るアクションを指定します。
  # 設定可能な値:
  #   - "log": 制限到達をCloudWatch Logsに記録 (デフォルト)
  #   - "emit-metric": CloudWatchメトリクスを送信
  #   - "deactivate": ワークグループを無効化
  # 省略時: "log" がデフォルトとして適用されます
  # 用途: 使用量超過時の自動対応を定義
  # 関連機能: Breach Actions
  #   log: 監査目的でログに記録
  #   emit-metric: メトリクスベースのアラートやダッシュボードで監視
  #   deactivate: 即座にワークグループを停止してコスト超過を防止
  #   - https://docs.aws.amazon.com/redshift/latest/mgmt/serverless-usage-limits.html
  breach_action = "log"

  # period (Optional)
  # 設定内容: 使用量制限が適用される時間期間を指定します。
  # 設定可能な値:
  #   - "daily": 日次制限 (1日ごとにリセット)
  #   - "weekly": 週次制限 (日曜日から開始)
  #   - "monthly": 月次制限 (デフォルト)
  # 省略時: "monthly" がデフォルトとして適用されます
  # 用途: 使用量制限のリセット周期を制御
  # 関連機能: Usage Limit Period
  #   dailyは毎日0:00 UTC、weeklyは毎週日曜日0:00 UTC、monthlyは毎月1日0:00 UTCにリセットされます。
  #   短い期間を設定することで、より細かい使用量管理が可能になります。
  #   - https://docs.aws.amazon.com/redshift/latest/mgmt/serverless-usage-limits.html
  period = "monthly"

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード (例: us-east-1, ap-northeast-1)
  # 省略時: プロバイダー設定のリージョンを使用
  # 関連機能: Regional Endpoints
  #   - https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  # id (Optional, Computed)
  # 設定内容: リソースのID (Usage Limit ID)
  # 注意: 通常は明示的に設定する必要はありません。Terraformが自動管理します
  id = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: Redshift Serverless Usage LimitのAmazon Resource Name (ARN)
#
# - id: Redshift Usage Limit ID
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 例1: serverless-computeの日次制限設定
#
# resource "aws_redshiftserverless_workgroup" "example" {
#   namespace_name = aws_redshiftserverless_namespace.example.namespace_name
#   workgroup_name = "example"
# }
#
# resource "aws_redshiftserverless_usage_limit" "compute_daily" {
#   resource_arn  = aws_redshiftserverless_workgroup.example.arn
#   usage_type    = "serverless-compute"
#   amount        = 100
#   period        = "daily"
#   breach_action = "emit-metric"
#---------------------------------------------------------------
