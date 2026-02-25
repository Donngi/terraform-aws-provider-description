#---------------------------------------------------------------
# AWS SESv2 Account VDM Attributes
#---------------------------------------------------------------
#
# Amazon SES (Simple Email Service) v2のアカウントレベルVDM（Virtual Deliverability Manager）
# 属性を管理するリソースです。VDMはメール配信率の改善、エンゲージメント指標の収集、
# および最適化された共有配信などの機能を提供します。
# このリソースはAWSアカウント単位で一つのみ存在します。
#
# AWS公式ドキュメント:
#   - Virtual Deliverability Manager: https://docs.aws.amazon.com/ses/latest/dg/vdm-get-started.html
#   - PutAccountVdmAttributes API: https://docs.aws.amazon.com/ses/latest/APIReference-V2/API_PutAccountVdmAttributes.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sesv2_account_vdm_attributes
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_sesv2_account_vdm_attributes" "example" {
  #-------------------------------------------------------------
  # VDM基本設定
  #-------------------------------------------------------------

  # vdm_enabled (Required)
  # 設定内容: アカウントレベルのVDM（Virtual Deliverability Manager）機能の有効・無効を指定します。
  # 設定可能な値: "ENABLED"（有効）, "DISABLED"（無効）
  # 省略時: 省略不可（必須）
  vdm_enabled = "ENABLED"

  #-------------------------------------------------------------
  # ダッシュボード属性設定
  #-------------------------------------------------------------

  # dashboard_attributes (Optional)
  # 設定内容: VDMダッシュボードに関する追加設定を指定します。
  # 省略時: ブロック全体を省略可能
  dashboard_attributes {

    # engagement_metrics (Optional)
    # 設定内容: VDMエンゲージメント指標収集の有効・無効を指定します。
    #           有効にするとメール開封率やクリック率などの指標が収集されます。
    # 設定可能な値: "ENABLED"（有効）, "DISABLED"（無効）
    # 省略時: 省略可能
    engagement_metrics = "ENABLED"
  }

  #-------------------------------------------------------------
  # ガーディアン属性設定
  #-------------------------------------------------------------

  # guardian_attributes (Optional)
  # 設定内容: VDMガーディアンに関する追加設定を指定します。
  # 省略時: ブロック全体を省略可能
  guardian_attributes {

    # optimized_shared_delivery (Optional)
    # 設定内容: VDM最適化共有配信の有効・無効を指定します。
    #           有効にするとAWSが共有IPアドレスからの送信を最適化します。
    # 設定可能な値: "ENABLED"（有効）, "DISABLED"（無効）
    # 省略時: 省略可能
    optimized_shared_delivery = "ENABLED"
  }

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: リソースの識別子（Terraform内部管理用）
# - vdm_enabled: VDM機能の有効状態
# - dashboard_attributes.engagement_metrics: エンゲージメント指標収集の状態
# - guardian_attributes.optimized_shared_delivery: 最適化共有配信の状態
#---------------------------------------------------------------
