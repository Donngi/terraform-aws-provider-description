#---------------------------------------------------------------
# AWS Chime SDK Voice SIP Rule
#---------------------------------------------------------------
#
# SIPメディアアプリケーションを電話番号またはRequest URIホスト名に関連付けるリソースです。
# SIPルールを使用することで、着信SIPリクエストを適切なSIPメディアアプリケーションに
# ルーティングできます。1つのSIPルールに複数のSIPメディアアプリケーションを関連付けることが
# 可能で、各アプリケーションはそのルールのみを実行します。
#
# AWS公式ドキュメント:
#   - Chime SDK SIP Rules: https://docs.aws.amazon.com/chime-sdk/latest/ag/create-sip-rule.html
#   - Chime SDK API Reference: https://docs.aws.amazon.com/chime-sdk/latest/APIReference/API_voice-chime_CreateSipRule.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/chimesdkvoice_sip_rule
#
# Provider Version: 6.28.0
# Generated: 2026-02-11
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_chimesdkvoice_sip_rule" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # 設定内容: SIPルールの名前
  # 設定可能な値: 任意の文字列
  # 省略時: 設定不可（必須）
  name = "my-sip-rule"

  # 設定内容: トリガータイプ
  # 設定可能な値:
  #   - ToPhoneNumber: 電話番号をトリガーとして使用
  #   - RequestUriHostname: Request URIホスト名をトリガーとして使用
  # 省略時: 設定不可（必須）
  trigger_type = "ToPhoneNumber"

  # 設定内容: トリガー値
  # 設定可能な値:
  #   - ToPhoneNumberの場合: E.164形式の電話番号（例: +819012345678）
  #   - RequestUriHostnameの場合: ホスト名（例: example.voiceconnector.chime.aws）
  # 省略時: 設定不可（必須）
  trigger_value = "+819012345678"

  #-------------------------------------------------------------
  # ルール制御
  #-------------------------------------------------------------

  # 設定内容: SIPルールを無効化するかどうか
  # 設定可能な値:
  #   - true: ルールを無効化（トリガーされない）
  #   - false: ルールを有効化（トリガーされる）
  # 省略時: false（ルールは有効）
  disabled = false

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # 設定内容: リソースが管理されるAWSリージョン
  # 設定可能な値: AWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  region = "us-east-1"

  #-------------------------------------------------------------
  # ターゲットアプリケーション設定
  #-------------------------------------------------------------

  # 設定内容: SIPメディアアプリケーションのルーティング設定
  # 設定可能な値: 1～25個のターゲットアプリケーション
  # 省略時: 設定不可（最低1個必須）
  target_applications {
    # 設定内容: SIPメディアアプリケーションが配置されているAWSリージョン
    # 設定可能な値: AWSリージョンコード（例: us-east-1, ap-northeast-1）
    # 省略時: 設定不可（必須）
    aws_region = "us-east-1"

    # 設定内容: SIPメディアアプリケーションID
    # 設定可能な値: aws_chimesdkvoice_sip_media_applicationのID
    # 省略時: 設定不可（必須）
    sip_media_application_id = "abcd1234-5678-90ab-cdef-1234567890ab"

    # 設定内容: アプリケーションの優先度（複数のアプリケーション設定時に使用）
    # 設定可能な値: 1以上の整数（小さい値ほど優先度が高い）
    # 省略時: 設定不可（必須）
    priority = 1
  }

  # 複数のターゲットアプリケーション設定例（冗長性確保）
  # target_applications {
  #   aws_region               = "us-west-2"
  #   sip_media_application_id = "efgh5678-90ab-cdef-1234-567890abcdef"
  #   priority                 = 2
  # }

  # target_applications {
  #   aws_region               = "ap-northeast-1"
  #   sip_media_application_id = "ijkl9012-3456-7890-abcd-ef1234567890"
  #   priority                 = 3
  # }
}

#---------------------------------------------------------------
# Attributes Reference（参照可能な属性）
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id
#   SIPルールのID（SipRuleIdと同じ値）
#
# - region
#   リソースが管理されているAWSリージョン
#---------------------------------------------------------------
