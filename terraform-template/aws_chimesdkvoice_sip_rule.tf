# ================================================================================
# Terraform AWS Resource Template: aws_chimesdkvoice_sip_rule
# ================================================================================
# Generated: 2026-01-18
# Provider Version: hashicorp/aws 6.28.0
#
# このテンプレートは生成時点(2026-01-18)の情報に基づいています。
# 最新の仕様や利用可能なオプションについては、必ず公式ドキュメントをご確認ください。
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/chimesdkvoice_sip_rule
# ================================================================================

# Amazon Chime SDK Voice SIPルール
# SIPルールは、SIPメディアアプリケーションを電話番号またはRequest URIホスト名に関連付けます。
# 1つのSIPルールに複数のSIPメディアアプリケーションを関連付けることができますが、
# 各アプリケーションはそのルールのみを実行します。
#
# AWS公式ドキュメント:
# - SIPルールの作成: https://docs.aws.amazon.com/chime-sdk/latest/ag/create-sip-rule.html
# - CreateSipRule API: https://docs.aws.amazon.com/chime-sdk/latest/APIReference/API_voice-chime_CreateSipRule.html
# - SIPルールの管理: https://docs.aws.amazon.com/chime-sdk/latest/ag/use-sip-rules.html

resource "aws_chimesdkvoice_sip_rule" "example" {
  # ==============================================================================
  # 必須パラメータ
  # ==============================================================================

  # name - SIPルールの名前
  # タイプ: string (必須)
  # 説明: SIPルールを識別するための名前を指定します。
  name = "example-sip-rule"

  # trigger_type - SIPルールのトリガータイプ
  # タイプ: string (必須)
  # 有効な値:
  #   - "RequestUriHostname": リクエストURIホスト名に基づいてトリガー
  #   - "ToPhoneNumber": 着信電話番号に基づいてトリガー
  # 説明: trigger_valueに割り当てられたトリガーのタイプを指定します。
  # RequestUriHostnameの場合は、Amazon Chime Voice Connectorのアウトバウンドホスト名を使用します。
  # ToPhoneNumberの場合は、E164形式の顧客所有の電話番号を使用します。
  trigger_type = "RequestUriHostname"

  # trigger_value - SIPルールのトリガー値
  # タイプ: string (必須)
  # 説明: trigger_typeに応じた値を指定します。
  #   - trigger_type が "RequestUriHostname" の場合:
  #     Amazon Chime Voice Connectorのアウトバウンドホスト名を指定します。
  #     着信SIPリクエストのリクエストURIがこの値と一致する場合にトリガーされます。
  #   - trigger_type が "ToPhoneNumber" の場合:
  #     E164形式の顧客所有電話番号を指定します。
  #     着信SIPリクエストの"To"ヘッダーがこの値と一致する場合にトリガーされます。
  trigger_value = "example.voiceconnector.chime.aws"

  # ==============================================================================
  # オプションパラメータ
  # ==============================================================================

  # disabled - ルールの有効/無効状態
  # タイプ: bool (オプション)
  # デフォルト: false
  # 説明: ルールを有効または無効にします。
  # ルールを削除する前に、必ず無効にする必要があります。
  # true: ルールを無効化
  # false: ルールを有効化
  disabled = false

  # id - SIPルールのID
  # タイプ: string (オプション・Computed)
  # 説明: SIPルールの一意の識別子です。
  # 通常は自動生成されるため、明示的に指定する必要はありません。
  # Terraformによる管理のために使用されます。
  # id = "sip-rule-id"

  # region - リソースが管理されるAWSリージョン
  # タイプ: string (オプション・Computed)
  # 説明: このリソースが管理されるAWSリージョンを指定します。
  # 指定しない場合は、プロバイダー設定で指定されたリージョンがデフォルトで使用されます。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  # ==============================================================================
  # ネストブロック: target_applications
  # ==============================================================================
  # 優先度とAWSリージョンを持つSIPメディアアプリケーションのリスト
  # 1つのAWSリージョンにつき1つのSIPアプリケーションのみ使用できます。
  # 最小: 1, 最大: 25
  #
  # 複数のアプリケーションを優先度順に設定することで、冗長性とフェイルオーバーを実現できます。
  # PSTN AudioサービスはSIPルールを評価し、最も優先度の高いSIPメディアアプリケーションに
  # 関連付けられたAWS Lambda関数を呼び出します。最高優先度の関数を呼び出せない場合は、
  # 次に高い優先度の関数を実行しようとします。

  target_applications {
    # aws_region - ターゲットアプリケーションのAWSリージョン
    # タイプ: string (必須)
    # 説明: SIPメディアアプリケーションが配置されているAWSリージョンを指定します。
    aws_region = "us-east-1"

    # priority - SIPメディアアプリケーションの優先度
    # タイプ: number (必須)
    # 説明: ターゲットリスト内でのSIPメディアアプリケーションの優先度を指定します。
    # 数値が小さいほど優先度が高くなります。
    # フェイルオーバーのために複数のアプリケーションを設定する場合に使用します。
    priority = 1

    # sip_media_application_id - SIPメディアアプリケーションのID
    # タイプ: string (必須)
    # 説明: 関連付けるSIPメディアアプリケーションのIDを指定します。
    # aws_chimesdkvoice_sip_media_application リソースのIDを参照します。
    sip_media_application_id = "sip-media-app-id"
  }

  # 追加のターゲットアプリケーション（フェイルオーバー用）
  # target_applications {
  #   aws_region               = "us-west-2"
  #   priority                 = 2
  #   sip_media_application_id = "sip-media-app-id-2"
  # }
}

# ==============================================================================
# Computed Attributes (読み取り専用)
# ==============================================================================
# 以下の属性はTerraformによって自動的に設定され、参照のみ可能です:
#
# - id: SIPルールの一意のID
#
# 参照例:
# output "sip_rule_id" {
#   value = aws_chimesdkvoice_sip_rule.example.id
# }
# ==============================================================================
