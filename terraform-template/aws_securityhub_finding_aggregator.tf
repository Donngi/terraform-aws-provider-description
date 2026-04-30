#---------------------------------------------------------------
# AWS Security Hub Finding Aggregator
#---------------------------------------------------------------
#
# AWS Security Hubのクロスリージョン集約設定をプロビジョニングするリソースです。
# ホームリージョンに対して、リンクされたリージョンのファインディング・インサイト・
# コントロールコンプライアンスステータス・セキュリティスコアを集約します。
# このリソースを作成する前に、aws_securityhub_accountで対象アカウントの
# Security Hubを有効化しておく必要があります。
#
# AWS公式ドキュメント:
#   - クロスリージョン集約の概要: https://docs.aws.amazon.com/securityhub/latest/userguide/finding-aggregation.html
#   - クロスリージョン集約の有効化: https://docs.aws.amazon.com/securityhub/latest/userguide/finding-aggregation-enable.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/securityhub_finding_aggregator
#
# Provider Version: 6.43.0
# Generated: 2026-04-30
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_securityhub_finding_aggregator" "example" {
  #-------------------------------------------------------------
  # リンクモード設定
  #-------------------------------------------------------------

  # linking_mode (Required)
  # 設定内容: クロスリージョン集約のリンクモードを指定します。
  #           ホームリージョンに集約するリージョンの範囲を決定します。
  # 設定可能な値:
  #   - "ALL_REGIONS": Security Hubが有効なすべてのリージョンから集約します。
  #                    新たにサポートされたリージョンも自動的に集約対象に含まれます。
  #   - "ALL_REGIONS_EXCEPT_SPECIFIED": Security Hubが有効なすべてのリージョンから集約しますが、
  #                                     specified_regionsで指定したリージョンを除外します。
  #                                     新たにサポートされたリージョンも自動的に集約対象に含まれます。
  #   - "SPECIFIED_REGIONS": specified_regionsで指定したリージョンのみから集約します。
  #                          新たにサポートされたリージョンは自動的には含まれません。
  #   - "NO_REGIONS": リンクリージョンを選択しないため、データを集約しません。
  # 参考: https://docs.aws.amazon.com/securityhub/latest/userguide/finding-aggregation-enable.html
  linking_mode = "ALL_REGIONS"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # specified_regions (Optional)
  # 設定内容: 集約対象または除外対象のリージョンセットを指定します。
  # 設定可能な値: 有効なAWSリージョンコードのセット（例: ["ap-northeast-1", "us-east-1"]）
  # 省略時: 集約対象リージョンは linking_mode の設定に従います。
  # 注意: linking_mode が "ALL_REGIONS_EXCEPT_SPECIFIED" の場合は除外するリージョンを指定します。
  #       linking_mode が "SPECIFIED_REGIONS" の場合は集約するリージョンを指定します。
  #       linking_mode が "NO_REGIONS" の場合はこのフィールドを指定するとエラーになります。
  #       linking_mode が "ALL_REGIONS" の場合はこのフィールドは無視されます。
  # 参考: https://docs.aws.amazon.com/securityhub/latest/userguide/finding-aggregation-enable.html
  specified_regions = null

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 注意: Security Hubのクロスリージョン集約はホームリージョンから設定する必要があります。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: Security Hub Finding AggregatorのAmazon Resource Name (ARN)
#---------------------------------------------------------------
