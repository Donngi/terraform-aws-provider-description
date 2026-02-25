#---------------------------------------------------------------
# AWS Shield Advanced Proactive Engagement
#---------------------------------------------------------------
#
# AWS Shield AdvancedのProactive Engagement（プロアクティブエンゲージメント）を
# 設定するリソースです。Proactive Engagementを有効にすると、DDoS攻撃が検出された際に
# AWSシールドレスポンスチーム（SRT）が自動的に連絡し、緩和策を支援します。
#
# 重要: このリソースを使用するには、AWS Shield Advancedのサブスクリプションが
# 有効である必要があります。また、少なくとも1件の緊急連絡先（emergency_contact）を
# 設定する必要があります。Proactive Engagementを有効にするには事前に
# aws_shield_drt_access_role_arn_associationリソースでSRTのロールアクセスを
# 設定しておく必要があります。
#
# AWS公式ドキュメント:
#   - Proactive Engagement: https://docs.aws.amazon.com/waf/latest/developerguide/ddos-srt-proactive-engagement.html
#   - Shield Advancedの緊急連絡先: https://docs.aws.amazon.com/waf/latest/developerguide/ddos-srt-contacts.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/shield_proactive_engagement
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_shield_proactive_engagement" "example" {
  #-------------------------------------------------------------
  # Proactive Engagement 有効化設定
  #-------------------------------------------------------------

  # enabled (Required)
  # 設定内容: Proactive Engagementを有効にするかどうかを指定します。
  # 設定可能な値:
  #   - true: Proactive Engagementを有効にします。DDoS攻撃検出時にSRTが自動連絡します
  #   - false: Proactive Engagementを無効にします。緊急連絡先は保持されますが、SRTの自動連絡は行われません
  # 省略時: 省略不可（必須）
  # 注意: trueに設定するには、emergency_contactブロックで少なくとも1件の
  #       緊急連絡先が設定されている必要があります。
  #       また、SRTのアクセスロールがaws_shield_drt_access_role_arn_associationで
  #       設定されている必要があります。
  enabled = true

  #-------------------------------------------------------------
  # 緊急連絡先設定
  #-------------------------------------------------------------

  # emergency_contact ブロック (Optional)
  # 設定内容: DDoS攻撃発生時にSRTが連絡する緊急連絡先のリストを指定します。
  # 省略時: 緊急連絡先なし（ただしenabledがtrueの場合は必須）
  # 注意: 最大10件まで設定可能です。
  #       Proactive Engagementを有効にするには少なくとも1件必要です。
  emergency_contact {
    # email_address (Required)
    # 設定内容: 緊急連絡先のメールアドレスを指定します。
    # 設定可能な値: 有効なメールアドレス形式の文字列
    # 省略時: 省略不可（必須）
    email_address = "ops-team@example.com"

    # phone_number (Optional)
    # 設定内容: 緊急連絡先の電話番号を指定します。
    # 設定可能な値: 国際電話番号形式の文字列（例: +81312345678）
    # 省略時: 電話番号なし
    phone_number = "+81312345678"

    # contact_notes (Optional)
    # 設定内容: 緊急連絡先に関する補足メモを指定します。
    # 設定可能な値: 任意の文字列（最大1024文字）
    # 省略時: 補足メモなし
    contact_notes = "運用チームの緊急連絡先。平日9:00-18:00に対応可能"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: AWSアカウントIDと同一の識別子。Proactive Engagementの設定を識別します。
#---------------------------------------------------------------
