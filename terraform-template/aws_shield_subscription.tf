#---------------------------------------------------------------
# AWS Shield Advanced Subscription
#---------------------------------------------------------------
#
# AWS Shield Advancedのサブスクリプションをプロビジョニングするリソースです。
# Shield Advancedは、Amazon EC2インスタンス、Elastic Load Balancing、
# Amazon CloudFront、Amazon Route 53、AWS Global Acceleratorなどの
# AWSリソースに対する高度なDDoS攻撃保護を提供するマネージドサービスです。
#
# 重要: このリソースはAWS Shield Advancedへのサブスクリプションを作成します。
# 1年間のサブスクリプション契約と月額料金が必要です。
# 詳細はAWS Shield料金ページを参照してください。
#
# AWS公式ドキュメント:
#   - AWS Shield概要: https://docs.aws.amazon.com/waf/latest/developerguide/shield-chapter.html
#   - Shield Advancedのサブスクリプション判断基準: https://docs.aws.amazon.com/waf/latest/developerguide/ddos-advanced-summary-deciding.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/shield_subscription
#
# Provider Version: 6.28.0
# Generated: 2026-02-08
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_shield_subscription" "example" {
  #-------------------------------------------------------------
  # 自動更新設定
  #-------------------------------------------------------------

  # auto_renew (Optional)
  # 設定内容: サブスクリプションの有効期限到来時に自動更新するかどうかを指定します。
  # 設定可能な値:
  #   - "ENABLED" (デフォルト): サブスクリプションを自動的に更新します
  #   - "DISABLED": サブスクリプションの自動更新を無効にします
  # 省略時: "ENABLED"（自動更新が有効）
  # 関連機能: AWS Shield Advancedサブスクリプション管理
  #   Shield Advancedは1年間のサブスクリプション契約です。自動更新を有効にすると、
  #   契約期間終了時に自動的に更新されます。自動更新の無効化はサブスクリプション期間の
  #   最後の30日間のみ可能です。それ以外の期間で解約するにはAWSサポートへの連絡が必要です。
  #   - https://docs.aws.amazon.com/waf/latest/developerguide/ddos-advanced-summary-deciding.html
  # 注意: Terraform destroy時にはauto_renewが"DISABLED"に設定されます。
  #       サブスクリプション期間の最後の30日間以外にdestroy実行するとエラーになります。
  auto_renew = "ENABLED"

  #-------------------------------------------------------------
  # ライフサイクル設定
  #-------------------------------------------------------------

  # skip_destroy (Optional)
  # 設定内容: Terraform destroy時にauto_renewの無効化をスキップするかどうかを指定します。
  # 設定可能な値:
  #   - true: destroy時にauto_renewの変更を行わず、Terraform stateからの削除のみ実施します
  #   - false (デフォルト): destroy時にauto_renewを"DISABLED"に設定しようとします
  # 省略時: false
  # 注意: auto_renewの無効化はサブスクリプション期間の最後の30日間のみ可能なため、
  #       それ以外の期間でdestroyする場合はtrueに設定する必要があります。
  #       trueに設定した場合、サブスクリプションは引き続きアクティブなままとなり、
  #       料金が発生し続けます。実際の解約にはAWSサポートへの連絡が必要です。
  skip_destroy = false
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: AWS アカウントID。Shield Subscriptionが有効化されている
#        AWSアカウントの識別子です。
#---------------------------------------------------------------
