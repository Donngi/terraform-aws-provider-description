#---------------------------------------------------------------
# AWS Cost Explorer Anomaly Monitor
#---------------------------------------------------------------
#
# AWS Cost Explorerの異常検知モニターをプロビジョニングするリソースです。
# Anomaly Monitorは、AWSコストの異常なパターンを検出し、予期しないコスト増加を
# 早期に発見するのに役立ちます。
#
# AWS公式ドキュメント:
#   - Cost Anomaly Detection概要: https://docs.aws.amazon.com/cost-management/latest/userguide/manage-ad.html
#   - Expression API: https://docs.aws.amazon.com/aws-cost-management/latest/APIReference/API_Expression.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ce_anomaly_monitor
#
# Provider Version: 6.28.0
# Generated: 2026-02-11
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ce_anomaly_monitor" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: モニターの名前を指定します。
  # 設定可能な値: 1文字以上の文字列
  name = "example-anomaly-monitor"

  # monitor_type (Required)
  # 設定内容: モニターのタイプを指定します。
  # 設定可能な値:
  #   - "DIMENSIONAL": ディメンション別の異常検知（サービス別など）
  #   - "CUSTOM": カスタム式による異常検知（タグやコストカテゴリで絞り込み）
  # 注意: monitor_typeに応じて、monitor_dimensionまたはmonitor_specificationを設定します
  monitor_type = "DIMENSIONAL"

  #-------------------------------------------------------------
  # ディメンション別モニター設定
  #-------------------------------------------------------------

  # monitor_dimension (Optional)
  # 設定内容: 評価するディメンションを指定します。
  # 設定可能な値: "SERVICE" - AWSサービス別にコストを分析
  # 注意: monitor_typeが "DIMENSIONAL" の場合に必須です
  # 省略時: 設定なし（CUSTOMタイプの場合は不要）
  monitor_dimension = "SERVICE"

  #-------------------------------------------------------------
  # カスタムモニター設定
  #-------------------------------------------------------------

  # monitor_specification (Optional)
  # 設定内容: カスタム異常検知のためのフィルタ式をJSON形式で指定します。
  # 設定可能な値: Expressionオブジェクトの有効なJSON表現
  # 注意: monitor_typeが "CUSTOM" の場合に必須です
  # 省略時: 設定なし（DIMENSIONALタイプの場合は不要）
  # 関連機能: Cost Explorer Expression API
  #   And, Or, Not, Tags, CostCategories, Dimensionsなどの条件を組み合わせて
  #   特定のリソースやタグに絞り込んだ異常検知が可能です。
  #   - https://docs.aws.amazon.com/aws-cost-management/latest/APIReference/API_Expression.html
  monitor_specification = null
  # monitor_specification = jsonencode({
  #   And            = null
  #   CostCategories = null
  #   Dimensions     = null
  #   Not            = null
  #   Or             = null
  #
  #   Tags = {
  #     Key          = "CostCenter"
  #     MatchOptions = null
  #     Values = [
  #       "10000"
  #     ]
  #   }
  # })

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "example-anomaly-monitor"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: 異常検知モニターのARN
#
# - id: 異常検知モニターの一意のID（arnと同じ値）
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
