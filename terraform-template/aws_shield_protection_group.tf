#---------------------------------------------------------------
# AWS Shield Advanced Protection Group
#---------------------------------------------------------------
#
# AWS Shield Advancedの保護グループをプロビジョニングするリソースです。
# 複数のAWSリソースを論理的にグループ化し、グループ全体に対して
# DDoS攻撃の集約検出と保護を行う機能を提供します。
# 個別リソースへの保護と組み合わせて使用することで、
# グループ単位での攻撃パターン検出が可能になります。
#
# AWS公式ドキュメント:
#   - Shield Advancedの保護グループ: https://docs.aws.amazon.com/waf/latest/developerguide/ddos-advanced-protection-groups.html
#   - 保護グループの集約設定: https://docs.aws.amazon.com/waf/latest/developerguide/ddos-advanced-protection-groups-settings.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/shield_protection_group
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_shield_protection_group" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # protection_group_id (Required)
  # 設定内容: 保護グループを一意に識別するIDを指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: 設定必須のため省略不可
  protection_group_id = "example-protection-group"

  # aggregation (Required)
  # 設定内容: グループ内リソースへの攻撃をどのように集約して判定するかを指定します。
  # 設定可能な値:
  #   - "SUM"  : グループ内の全リソースに対するトラフィック合計で攻撃を判定します
  #   - "MEAN" : グループ内の全リソースに対するトラフィック平均で攻撃を判定します
  #   - "MAX"  : グループ内の最も高いトラフィックを持つリソースを基準に攻撃を判定します
  # 省略時: 設定必須のため省略不可
  aggregation = "SUM"

  # pattern (Required)
  # 設定内容: 保護グループにどのリソースを含めるかのパターンを指定します。
  # 設定可能な値:
  #   - "ALL"          : Shield Advancedで保護されている全リソースを含めます
  #   - "ARBITRARY"    : membersで指定した特定リソースのみを含めます
  #   - "BY_RESOURCE_TYPE" : resource_typeで指定したリソースタイプの全リソースを含めます
  # 省略時: 設定必須のため省略不可
  # 注意: "ARBITRARY"を指定した場合はmembersの設定が必須です。
  #       "BY_RESOURCE_TYPE"を指定した場合はresource_typeの設定が必須です。
  pattern = "BY_RESOURCE_TYPE"

  #-------------------------------------------------------------
  # メンバー設定
  #-------------------------------------------------------------

  # resource_type (Optional)
  # 設定内容: patternが"BY_RESOURCE_TYPE"の場合に含めるリソースタイプを指定します。
  # 設定可能な値:
  #   - "CLOUDFRONT_DISTRIBUTION"  : Amazon CloudFrontディストリビューション
  #   - "ROUTE_53_HOSTED_ZONE"     : Amazon Route 53ホストゾーン
  #   - "ELASTIC_IP_ALLOCATION"    : Amazon EC2 Elastic IPアドレス
  #   - "CLASSIC_LOAD_BALANCER"    : Classic Load Balancer
  #   - "APPLICATION_LOAD_BALANCER": Application Load Balancer
  #   - "GLOBAL_ACCELERATOR"       : AWS Global Accelerator標準アクセラレーター
  # 省略時: patternが"BY_RESOURCE_TYPE"の場合は設定必須
  resource_type = "APPLICATION_LOAD_BALANCER"

  # members (Optional)
  # 設定内容: patternが"ARBITRARY"の場合に保護グループに含める
  #           リソースのARNリストを指定します。
  # 設定可能な値: Shield Advancedで保護されているリソースのARNのリスト（最大10000件）
  # 省略時: patternが"ARBITRARY"以外の場合は省略可能
  # 注意: 各ARNはaws_shield_protectionリソースで保護が有効になっている必要があります。
  members = []

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-protection-group"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: 保護グループの一意の識別子（protection_group_idと同値）
#
# - protection_group_arn: 保護グループのAmazon Resource Name (ARN)
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
