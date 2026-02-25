#---------------------------------------------------------------
# AWS IAM Roles Anywhere Trust Anchor
#---------------------------------------------------------------
#
# IAM Roles AnywhereのTrust Anchor（信頼アンカー）をプロビジョニングするリソースです。
# Trust AnchorはIAM Roles AnywhereとCA（証明書認証局）の間の信頼を確立するリソースで、
# AWSの外部ワークロードがX.509証明書を使用して一時的なAWS認証情報を取得するために使用します。
# CAの参照先としてAWS Private CA（ACM PCA）またはCA証明書バンドルのアップロードを指定できます。
#
# AWS公式ドキュメント:
#   - IAM Roles Anywhere ユーザーガイド: https://docs.aws.amazon.com/rolesanywhere/latest/userguide/introduction.html
#   - CreateTrustAnchor API: https://docs.aws.amazon.com/rolesanywhere/latest/APIReference/API_CreateTrustAnchor.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rolesanywhere_trust_anchor
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_rolesanywhere_trust_anchor" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: Trust Anchorの名前を指定します。
  # 設定可能な値: 1〜255文字の文字列。半角英数字・ハイフン・アンダースコア・スペースが使用可能
  name = "example-trust-anchor"

  # enabled (Optional)
  # 設定内容: Trust Anchorを有効にするかどうかを指定します。
  # 設定可能な値:
  #   - true: Trust Anchorを有効化。ワークロードが証明書を使用して認証情報を取得できます
  #   - false: Trust Anchorを無効化。認証情報の取得が拒否されます
  # 省略時: true（有効）
  enabled = true

  #-------------------------------------------------------------
  # 信頼ソース設定
  #-------------------------------------------------------------

  # source (Required)
  # 設定内容: Trust Anchorの信頼ソースを定義するブロックです。
  # 注意: ブロックは必ず1つ指定する必要があります（min_items=1, max_items=1）
  source {

    # source_type (Required)
    # 設定内容: 信頼ソースのタイプを指定します。
    # 設定可能な値:
    #   - "AWS_ACM_PCA": AWS Private CA（ACM PCA）を信頼ソースとして使用
    #   - "CERTIFICATE_BUNDLE": PEM形式のCA証明書バンドルをアップロードして使用
    source_type = "AWS_ACM_PCA"

    # source_data (Required)
    # 設定内容: 信頼ソースのデータを定義するブロックです。source_typeに応じて指定内容が変わります。
    # 注意: ブロックは必ず1つ指定する必要があります（min_items=1, max_items=1）
    source_data {

      # acm_pca_arn (Optional)
      # 設定内容: ACM Private CAのARNを指定します。
      # 設定可能な値: 有効なACM PCA ARN
      # 省略時: source_typeが"AWS_ACM_PCA"の場合は必須
      # 注意: source_typeが"AWS_ACM_PCA"の場合のみ使用します。"CERTIFICATE_BUNDLE"の場合はx509_certificate_dataを使用してください
      acm_pca_arn = "arn:aws:acm-pca:ap-northeast-1:123456789012:certificate-authority/12345678-1234-1234-1234-123456789012"

      # x509_certificate_data (Optional)
      # 設定内容: PEM形式のCA証明書データを指定します。
      # 設定可能な値: PEM形式のCA証明書文字列
      # 省略時: source_typeが"CERTIFICATE_BUNDLE"の場合は必須
      # 注意: source_typeが"CERTIFICATE_BUNDLE"の場合のみ使用します。"AWS_ACM_PCA"の場合はacm_pca_arnを使用してください
      # x509_certificate_data = "-----BEGIN CERTIFICATE-----\n...\n-----END CERTIFICATE-----"
    }
  }

  #-------------------------------------------------------------
  # 通知設定
  #-------------------------------------------------------------

  # notification_settings (Optional)
  # 設定内容: Trust Anchorに関連する通知設定のブロックです。証明書の有効期限などのイベントを
  #           CloudWatch Metrics・EventBridge・Health Dashboardを通じて通知します。
  # 設定可能な値: 最大50件まで指定可能
  # 関連機能: IAM Roles Anywhere 通知
  #   証明書の有効期限切れ前に通知を受け取ることができます。
  #   - https://docs.aws.amazon.com/rolesanywhere/latest/APIReference/API_NotificationSetting.html
  notification_settings {

    # event (Optional)
    # 設定内容: 通知対象のイベントを指定します。
    # 設定可能な値:
    #   - "CA_CERTIFICATE_EXPIRY": CA証明書の有効期限切れイベント
    #   - "END_ENTITY_CERTIFICATE_EXPIRY": エンドエンティティ証明書の有効期限切れイベント
    # 省略時: computed（APIから取得）
    event = "CA_CERTIFICATE_EXPIRY"

    # enabled (Optional)
    # 設定内容: この通知設定を有効にするかどうかを指定します。
    # 設定可能な値:
    #   - true: 通知を有効化
    #   - false: 通知を無効化
    # 省略時: computed（APIから取得）
    enabled = true

    # threshold (Optional)
    # 設定内容: 通知を発火する証明書有効期限の何日前かを指定します。
    # 設定可能な値: 1〜360の整数（日数）
    # 省略時: computed（APIから取得）
    # 注意: 通知設定が有効（enabled=true）の場合に必要です
    threshold = 30

    # channel (Optional)
    # 設定内容: 通知のチャンネルを指定します。
    # 設定可能な値:
    #   - "ALL": CloudWatch Metrics・EventBridge・Health Dashboardすべてのチャンネルで通知
    # 省略時: "ALL"（すべてのチャンネルに通知）
    channel = "ALL"
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-trust-anchor"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: Trust AnchorのAmazon Resource Name (ARN)
# - id: Trust AnchorのID
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
