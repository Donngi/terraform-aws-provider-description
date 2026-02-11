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
#   - Chime SDK SIP Rules: https://docs.aws.amazon.com/chime-sdk/latest/ag/sip-rules.html
#   - Chime SDK Voice: https://docs.aws.amazon.com/chime-sdk/latest/dg/what-is-chime-sdk.html
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
  # 基本設定 (必須)
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: SIPルールの名前を指定します。
  # 設定可能な値: 任意の文字列
  # 注意: ルールを識別するための名前として使用されます。
  name = "example-sip-rule"

  # trigger_type (Required)
  # 設定内容: SIPルールがトリガーされる条件のタイプを指定します。
  # 設定可能な値:
  #   - RequestUriHostname: リクエストURIホスト名に基づくトリガー
  #   - ToPhoneNumber: 着信先電話番号に基づくトリガー
  # 注意: trigger_valueの値はこのタイプに対応している必要があります。
  trigger_type = "RequestUriHostname"

  # trigger_value (Required)
  # 設定内容: トリガータイプに対応する具体的な値を指定します。
  # 設定可能な値:
  #   - trigger_typeがRequestUriHostnameの場合: Amazon Chime Voice Connectorのアウトバウンドホスト名
  #   - trigger_typeがToPhoneNumberの場合: E164形式の電話番号（例: +819012345678）
  # 動作: 着信SIPリクエストのRequest URIまたは"To"ヘッダーがこの値と一致した場合、
  #       SIPルールに指定されたSIPメディアアプリケーションがトリガーされます。
  trigger_value = "example-hostname.voiceconnector.chime.aws"

  #-------------------------------------------------------------
  # ターゲットアプリケーション設定 (必須)
  #-------------------------------------------------------------

  # target_applications (Required)
  # 設定内容: 着信SIPリクエストをルーティングするSIPメディアアプリケーションのリストを指定します。
  # 注意: 各AWSリージョンごとに1つのSIPアプリケーションのみ使用可能です。
  #       最小1個、最大25個まで設定できます。
  target_applications {
    # sip_media_application_id (Required)
    # 設定内容: ルーティング先のSIPメディアアプリケーションIDを指定します。
    # 設定可能な値: 有効なSIPメディアアプリケーションのID
    sip_media_application_id = "example-sma-id"

    # aws_region (Required)
    # 設定内容: ターゲットアプリケーションが存在するAWSリージョンを指定します。
    # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, us-west-2）
    # 注意: 各リージョンごとに1つのアプリケーションのみ指定可能です。
    aws_region = "us-east-1"

    # priority (Required)
    # 設定内容: ターゲットリスト内でのSIPメディアアプリケーションの優先順位を指定します。
    # 設定可能な値: 数値（整数）
    # 注意: 数値が小さいほど優先度が高くなります。
    priority = 1
  }

  # 複数のターゲットアプリケーションを設定する例（コメントアウト）
  # target_applications {
  #   sip_media_application_id = "example-sma-id-2"
  #   aws_region               = "us-west-2"
  #   priority                 = 2
  # }

  #-------------------------------------------------------------
  # オプション設定
  #-------------------------------------------------------------

  # disabled (Optional)
  # 設定内容: SIPルールを無効化するかどうかを指定します。
  # 設定可能な値:
  #   - true: ルールを無効化
  #   - false: ルールを有効化（デフォルト）
  # 省略時: false（ルールは有効）
  # 注意: ルールを削除する前に、必ずtrueに設定して無効化する必要があります。
  disabled = null

  # region (Optional)
  # 設定内容: このリソースが管理されるAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード
  # 省略時: プロバイダー設定のリージョンが使用されます
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: SIPルールの一意識別子
#
# これらの属性は他のリソースから参照可能:
#   aws_chimesdkvoice_sip_rule.example.id
#---------------------------------------------------------------
