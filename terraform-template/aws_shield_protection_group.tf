#---------------------------------------------------------------
# AWS Shield Advanced Protection Group
#---------------------------------------------------------------
#
# AWS Shield Advancedのプロテクショングループをプロビジョニングするリソースです。
# プロテクショングループは、保護対象リソースの論理的なコレクションを作成し、
# グループとして検出・緩和・レポートを管理することで、検出精度の向上と
# 誤検知の削減を実現します。
#
# AWS公式ドキュメント:
#   - Shield Advancedプロテクショングループ: https://docs.aws.amazon.com/waf/latest/developerguide/ddos-protection-groups.html
#   - 複数リソースの検出ロジック: https://docs.aws.amazon.com/waf/latest/developerguide/ddos-event-detection-multiple-resources.html
#   - CreateProtectionGroup API: https://docs.aws.amazon.com/waf/latest/DDOSAPIReference/API_CreateProtectionGroup.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/shield_protection_group
#
# Provider Version: 6.28.0
# Generated: 2026-02-08
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_shield_protection_group" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # protection_group_id (Required, Forces new resource)
  # 設定内容: プロテクショングループの名前（ID）を指定します。
  # 設定可能な値: 1-36文字の英数字およびハイフン（パターン: [a-zA-Z0-9\\-]*）
  # 用途: リストでの識別や、グループの更新・削除・参照時に使用されます。
  # 参考: https://docs.aws.amazon.com/waf/latest/DDOSAPIReference/API_CreateProtectionGroup.html
  protection_group_id = "my-protection-group"

  #-------------------------------------------------------------
  # パターン設定
  #-------------------------------------------------------------

  # pattern (Required)
  # 設定内容: グループに含める保護対象リソースの選択基準を指定します。
  # 設定可能な値:
  #   - "ALL": Shield Advancedで保護されている全リソースを含めます
  #   - "ARBITRARY": membersで指定した任意のリソースを含めます（members設定が必須）
  #   - "BY_RESOURCE_TYPE": resource_typeで指定した種類の全保護対象リソースを含めます
  #                         （resource_type設定が必須）
  # 注意: 選択したパターンに応じて、membersまたはresource_typeの設定要否が変わります。
  #        "ARBITRARY"の場合はmembersが必須、"BY_RESOURCE_TYPE"の場合はresource_typeが必須です。
  # 参考: https://docs.aws.amazon.com/waf/latest/DDOSAPIReference/API_CreateProtectionGroup.html
  pattern = "ALL"

  #-------------------------------------------------------------
  # 集約設定
  #-------------------------------------------------------------

  # aggregation (Required)
  # 設定内容: AWS Shieldがグループ内のリソースデータを結合してイベントの検出・緩和・
  #           レポートを行う方法を指定します。
  # 設定可能な値:
  #   - "SUM": グループ内の全リソースのトラフィック合計を使用します。
  #            手動・自動でスケールするEC2インスタンスのElastic IPアドレスなど、
  #            ほとんどのケースに適しています。新規リソースに既存のベースラインを
  #            適用し、検出感度を下げて誤検知を防止します。
  #   - "MEAN": グループ内の全リソースのトラフィック平均を使用します。
  #             ロードバランサーやアクセラレーターなど、トラフィックが均一に
  #             分散されるリソースに適しています。
  #   - "MAX": グループ内の各リソースの最大トラフィックを使用します。
  #            CloudFrontとそのオリジンリソースなど、トラフィックを共有しない
  #            リソースや不均一に共有するリソースに適しています。
  # 関連機能: Shield Advanced 複数リソースの検出ロジック
  #   トラフィック集約方法により、脅威の検出と対応の精度が向上します。
  #   - https://docs.aws.amazon.com/waf/latest/developerguide/ddos-event-detection-multiple-resources.html
  aggregation = "MAX"

  #-------------------------------------------------------------
  # メンバー設定
  #-------------------------------------------------------------

  # members (Optional)
  # 設定内容: プロテクショングループに含めるリソースのAmazon Resource Name (ARN)の
  #           リストを指定します。
  # 設定可能な値: 有効なAWSリソースARNのリスト（最小0件、最大10,000件。各ARNは1-2048文字）
  # 省略時: 空のリスト
  # 注意: patternが"ARBITRARY"の場合のみ設定が必須です。
  #        それ以外のpattern設定では指定してはいけません。
  # リソースタイプ設定
  #-------------------------------------------------------------

  # resource_type (Optional)
  # 設定内容: プロテクショングループに含めるリソースタイプを指定します。
  #           指定したタイプの全保護対象リソースがグループに含まれ、
  #           新たに保護対象となったリソースも自動的に追加されます。
  # 設定可能な値:
  #   - "CLOUDFRONT_DISTRIBUTION": Amazon CloudFrontディストリビューション
  #   - "ROUTE_53_HOSTED_ZONE": Amazon Route 53ホストゾーン
  #   - "ELASTIC_IP_ALLOCATION": Elastic IPアドレス
  #   - "CLASSIC_LOAD_BALANCER": Classic Load Balancer
  #   - "APPLICATION_LOAD_BALANCER": Application Load Balancer
  #   - "GLOBAL_ACCELERATOR": AWS Global Accelerator
  # 省略時: null（未設定）
  # 注意: patternが"BY_RESOURCE_TYPE"の場合のみ設定が必須です。
  #        それ以外のpattern設定では指定してはいけません。
  # 参考: https://docs.aws.amazon.com/waf/latest/DDOSAPIReference/API_CreateProtectionGroup.html
  resource_type = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ（最大200件）
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "my-protection-group"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - protection_group_arn: プロテクショングループのAmazon Resource Name (ARN)
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
