#---------------------------------------------------------------
# AWS Cost Explorer Anomaly Monitor
#---------------------------------------------------------------
#
# AWS Cost Explorerの異常検出モニターをプロビジョニングするリソースです。
# コスト異常検出は機械学習を使用してAWSコストの異常なパターンを監視し、
# 予期しない支出を早期に検出するためのサービスです。
#
# AWS公式ドキュメント:
#   - Cost Anomaly Detection概要: https://docs.aws.amazon.com/cost-management/latest/userguide/manage-ad.html
#   - Expression API Reference: https://docs.aws.amazon.com/aws-cost-management/latest/APIReference/API_Expression.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ce_anomaly_monitor
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
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
  # 設定内容: 異常検出モニターの名前を指定します。
  # 設定可能な値: 文字列
  name = "my-anomaly-monitor"

  # monitor_type (Required)
  # 設定内容: モニターのタイプを指定します。
  # 設定可能な値:
  #   - "DIMENSIONAL": ディメンション別監視。AWSサービス単位でコスト異常を検出
  #   - "CUSTOM": カスタム監視。任意の条件（タグ、コストカテゴリ等）でコスト異常を検出
  # 注意: monitor_typeによって追加で必要な引数が異なります。
  #   - DIMENSIONAL: monitor_dimensionが必須
  #   - CUSTOM: monitor_specificationが必須
  monitor_type = "DIMENSIONAL"

  #-------------------------------------------------------------
  # ディメンション設定 (monitor_type = "DIMENSIONAL" の場合)
  #-------------------------------------------------------------

  # monitor_dimension (Required if monitor_type is DIMENSIONAL)
  # 設定内容: 評価するディメンションを指定します。
  # 設定可能な値:
  #   - "SERVICE": AWSサービス単位で異常を検出
  # 注意: monitor_type = "DIMENSIONAL" の場合のみ指定可能
  monitor_dimension = "SERVICE"

  #-------------------------------------------------------------
  # カスタムモニター設定 (monitor_type = "CUSTOM" の場合)
  #-------------------------------------------------------------

  # monitor_specification (Required if monitor_type is CUSTOM)
  # 設定内容: Expression オブジェクトのJSON表現を指定します。
  # 設定可能な値: 有効なJSON形式の文字列
  # Expression オブジェクトで使用可能なフィルター:
  #   - Dimensions: ディメンションによるフィルタリング
  #   - Tags: タグによるフィルタリング
  #   - CostCategories: コストカテゴリによるフィルタリング
  #   - And, Or, Not: 論理演算子で複数条件を組み合わせ
  # 参考: https://docs.aws.amazon.com/aws-cost-management/latest/APIReference/API_Expression.html
  # 注意: monitor_type = "CUSTOM" の場合のみ指定可能
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "my-anomaly-monitor"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: 異常検出モニターのAmazon Resource Name (ARN)
#
# - id: 異常検出モニターの一意のID。arnと同じ値です。
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
