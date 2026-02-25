#---------------------------------------------------------------
# AWS SESv2 Email Identity
#---------------------------------------------------------------
#
# Amazon SES (Simple Email Service) v2 のメールアイデンティティを作成・管理するリソースです。
# SESからメールを送信するには、送信元となるドメインまたはメールアドレスの所有権を
# 検証する必要があります。このリソースでドメインまたは個別メールアドレスを
# アイデンティティとして登録し、DKIM署名やメール送信の信頼性を確保できます。
#
# 主な機能:
#   - ドメインアイデンティティの登録（ドメイン全体からのメール送信を許可）
#   - メールアドレスアイデンティティの登録（個別アドレスからのメール送信を許可）
#   - DKIM署名設定（Easy DKIM または BYODKIM）
#   - コンフィグレーションセットとの関連付け
#
# AWS公式ドキュメント:
#   - メールアイデンティティの作成: https://docs.aws.amazon.com/ses/latest/dg/creating-identities.html
#   - DKIM署名の設定: https://docs.aws.amazon.com/ses/latest/dg/send-email-authentication-dkim.html
#   - CreateEmailIdentity API: https://docs.aws.amazon.com/ses/latest/APIReference-V2/API_CreateEmailIdentity.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sesv2_email_identity
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_sesv2_email_identity" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # email_identity (Required)
  # 設定内容: SESに登録するメールアイデンティティを指定します。
  # 設定可能な値:
  #   - ドメイン名: "example.com"（ドメインアイデンティティ）
  #   - メールアドレス: "user@example.com"（メールアドレスアイデンティティ）
  # 用途: SESでメールを送信する際の送信元として使用するドメインまたはアドレスを指定
  # 注意事項:
  #   - ドメインの場合、DNS検証のためのDKIMトークンが生成されます
  #   - メールアドレスの場合、その宛先に検証メールが送信されます
  #   - 変更時はリソースの再作成が必要です
  email_identity = "example.com"

  #-------------------------------------------------------------
  # コンフィグレーションセット設定
  #-------------------------------------------------------------

  # configuration_set_name (Optional)
  # 設定内容: このメールアイデンティティに関連付けるコンフィグレーションセット名を指定します。
  # 設定可能な値: 既存のaws_sesv2_configuration_setリソースの名前
  # 省略時: デフォルトコンフィグレーションセットが使用されます（または設定なし）
  # 関連機能: コンフィグレーションセット
  #   コンフィグレーションセットを使用すると、イベント通知（送信、バウンス、苦情等）の
  #   追跡設定や送信オプションをまとめて管理できます。
  #   - https://docs.aws.amazon.com/ses/latest/dg/using-configuration-sets.html
  configuration_set_name = null

  #-------------------------------------------------------------
  # DKIM署名設定
  #-------------------------------------------------------------

  # dkim_signing_attributes (Optional)
  # 設定内容: メールのDKIM（DomainKeys Identified Mail）署名設定を指定します。
  # 省略時: Easy DKIMが自動的に設定されます
  # 関連機能: DKIM署名
  #   DKIMを使用することでメールの真正性を証明でき、迷惑メールとして
  #   判定されるリスクを低減できます。Easy DKIMとBYODKIM（独自DKIMキー）を選択可能です。
  #   - https://docs.aws.amazon.com/ses/latest/dg/send-email-authentication-dkim.html
  dkim_signing_attributes {
    # domain_signing_private_key (Optional, Sensitive)
    # 設定内容: BYODKIM（独自DKIMキー）使用時のRSA秘密鍵をBase64エンコードで指定します。
    # 設定可能な値: Base64エンコードされたRSA秘密鍵（2048ビット以上）
    # 省略時: Easy DKIMが使用されます
    # 注意: domain_signing_selectorと同時に設定する必要があります。
    #       この値はTerraformのstateにsensitiveとして保存されます。
    domain_signing_private_key = null

    # domain_signing_selector (Optional)
    # 設定内容: BYODKIM使用時のDKIMセレクター名を指定します。
    # 設定可能な値: 英数字とハイフンからなる文字列（例: "my-selector"）
    # 省略時: Easy DKIMが使用されます
    # 注意: domain_signing_private_keyと同時に設定する必要があります。
    #       セレクター名は公開鍵のDNSレコード名に使用されます（例: my-selector._domainkey.example.com）
    domain_signing_selector = null

    # next_signing_key_length (Optional, Computed)
    # 設定内容: Easy DKIM使用時の次回キーローテーションで使用するRSAキー長を指定します。
    # 設定可能な値:
    #   - "RSA_1024_BIT": 1024ビットのRSAキー
    #   - "RSA_2048_BIT": 2048ビットのRSAキー（推奨）
    # 省略時: AWSがデフォルト値を設定します
    # 注意: BYODKIMを使用する場合、この設定は無視されます。
    next_signing_key_length = "RSA_2048_BIT"
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに付与するタグをキーと値のマップで指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  tags = {
    Name        = "example-sesv2-email-identity"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 注意: SESはリージョンサービスのため、アイデンティティはリージョンごとに管理されます。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: メールアイデンティティのARN
# - identity_type: アイデンティティ種別（"EMAIL_ADDRESS" または "DOMAIN"）
# - verification_status: 検証状態（"PENDING"、"SUCCESS"、"FAILED" 等）
# - verified_for_sending_status: メール送信が有効かどうかを示すブール値
# - dkim_signing_attributes.current_signing_key_length: 現在のDKIMキー長
# - dkim_signing_attributes.last_key_generation_timestamp: 最後のDKIMキー生成日時
# - dkim_signing_attributes.signing_attributes_origin: DKIM署名方式
#   "AWS_SES"（Easy DKIM）または "EXTERNAL"（BYODKIM）
# - dkim_signing_attributes.status: DKIMのステータス
# - dkim_signing_attributes.tokens: Easy DKIM用CNAMEレコードのトークンリスト
#   DNSのCNAMEレコードとして追加することでDKIM検証が完了します。
#---------------------------------------------------------------
