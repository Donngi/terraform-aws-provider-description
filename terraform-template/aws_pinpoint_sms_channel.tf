#---------------------------------------------------------------
# AWS Pinpoint SMS Channel
#---------------------------------------------------------------
#
# Amazon PinpointアプリケーションにSMSチャネルを追加するためのリソースです。
# SMSチャネルを有効化することで、Pinpointキャンペーンやジャーニーから
# SMS（ショートメッセージサービス）メッセージを送信できるようにします。
#
# AWS公式ドキュメント:
#   - Amazon Pinpoint概要: https://docs.aws.amazon.com/pinpoint/latest/userguide/welcome.html
#   - SMSチャネル設定: https://docs.aws.amazon.com/pinpoint/latest/userguide/channels-sms.html
#   - 送信者ID: https://docs.aws.amazon.com/pinpoint/latest/userguide/channels-sms-originating-identities-sender-ids.html
#   - ショートコード: https://docs.aws.amazon.com/pinpoint/latest/userguide/channels-sms-originating-identities-short-codes.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/pinpoint_sms_channel
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_pinpoint_sms_channel" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # application_id (Required)
  # 設定内容: SMSチャネルを追加するPinpointアプリケーションIDを指定します。
  # 設定可能な値: 有効なPinpointアプリケーションID
  # 注意: aws_pinpoint_appリソースのapplication_id属性を参照
  # 関連リソース: aws_pinpoint_app
  application_id = "your-pinpoint-app-id"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # チャネル有効化設定
  #-------------------------------------------------------------

  # enabled (Optional)
  # 設定内容: SMSチャネルの有効/無効を指定します。
  # 設定可能な値:
  #   - true: SMSチャネルを有効化（デフォルト）
  #   - false: SMSチャネルを無効化
  # 用途: チャネルを一時的に無効化する場合に使用
  # 注意: 無効化すると、このチャネルを使用したSMS送信ができなくなります
  enabled = true

  #-------------------------------------------------------------
  # 送信者識別情報
  #-------------------------------------------------------------

  # sender_id (Optional)
  # 設定内容: SMS送信時に表示される送信者IDを指定します。
  # 設定可能な値: 英数字の文字列（最大11文字）
  # 用途:
  #   - 受信者に表示されるSMS送信元の識別子
  #   - ブランド名や会社名を設定することが一般的
  # 注意:
  #   - 送信者IDのサポートは国によって異なります
  #   - 一部の国では事前登録が必要です
  #   - short_codeと同時に使用する場合、short_codeが優先されます
  # 参考: https://docs.aws.amazon.com/pinpoint/latest/userguide/channels-sms-originating-identities-sender-ids.html
  sender_id = null

  # short_code (Optional)
  # 設定内容: SMS送信に使用するショートコードを指定します。
  # 設定可能な値: 数字の文字列（通常5〜6桁）
  # 用途:
  #   - 大量のSMSメッセージを高スループットで送信する際に使用
  #   - トランザクション系および宣伝系の両方のメッセージに対応
  # 注意:
  #   - AWSからショートコードを取得するには事前申請が必要です
  #   - ショートコードは国別に管理されます
  # 参考: https://docs.aws.amazon.com/pinpoint/latest/userguide/channels-sms-originating-identities-short-codes.html
  short_code = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: PinpointアプリケーションID（application_idと同じ）
#
# - promotional_messages_per_second: プロモーションメッセージの1秒あたり最大送信数
#   注意: AWSによって自動的に決定されます
#
# - transactional_messages_per_second: トランザクションメッセージの1秒あたり最大送信数
#   注意: AWSによって自動的に決定されます
#
#---------------------------------------------------------------
