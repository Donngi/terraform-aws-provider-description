#---------------------------------------------------------------
# AWS Systems Manager Contacts Contact Channel
#---------------------------------------------------------------
#
# AWS Systems Manager Incident Managerのコンタクトチャネルをプロビジョニングするリソースです。
# コンタクトチャネルは、インシデント発生時にオンコール担当者へ通知を送信するための
# 配信手段（EMAIL、SMS、VOICE）を定義します。
#
# 注意: コンタクトチャネルは作成後にAWS Systems Managerコンソールで
#       アクティベーションを実行する必要があります。アクティベーションしない限り、
#       コンタクトのエンゲージメントに使用できません。
#
# AWS公式ドキュメント:
#   - Incident Manager連絡先: https://docs.aws.amazon.com/incident-manager/latest/userguide/contacts.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssmcontacts_contact_channel
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ssmcontacts_contact_channel" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # contact_id (Required)
  # 設定内容: このコンタクトチャネルを関連付けるコンタクトのARNを指定します。
  # 設定可能な値: 有効なSSM Contactsコンタクトの完全なARN
  #               形式: arn:aws:ssm-contacts:region:account-id:contact/contact-alias
  # 関連機能: SSM Contacts コンタクト管理
  #   コンタクトチャネルは必ずコンタクトに関連付けられ、
  #   インシデント発生時の通知配信に使用されます。
  #   - https://docs.aws.amazon.com/incident-manager/latest/userguide/contacts.html
  contact_id = "arn:aws:ssm-contacts:us-west-2:123456789012:contact/example-contact"

  # name (Required)
  # 設定内容: コンタクトチャネルの表示名を指定します。
  # 設定可能な値: 文字列（1-255文字）
  # 用途: コンソールやAPIレスポンスでチャネルを識別するための名前
  name = "example-contact-channel"

  # type (Required)
  # 設定内容: コンタクトチャネルのタイプを指定します。
  # 設定可能な値:
  #   - "EMAIL": メール通知を送信
  #   - "SMS": SMS（テキストメッセージ）通知を送信
  #   - "VOICE": 音声通話による通知
  # 関連機能: SSM Contacts 通知配信方法
  #   タイプによって配信先アドレスの形式が異なります。
  #   EMAILではメールアドレス、SMS/VOICEでは電話番号を指定します。
  #   - https://docs.aws.amazon.com/incident-manager/latest/userguide/contacts.html
  type = "EMAIL"

  #-------------------------------------------------------------
  # 配信先設定
  #-------------------------------------------------------------

  # delivery_address (Required)
  # 設定内容: 通知の配信先アドレスを指定するブロックです。
  # 注意: このブロックは必須で、min_items=1, max_items=1の制約があります。
  delivery_address {
    # simple_address (Required)
    # 設定内容: 通知を配信する宛先アドレスを指定します。
    # 設定可能な値:
    #   - type="EMAIL"の場合: 有効なメールアドレス（例: user@example.com）
    #   - type="SMS"の場合: E.164形式の電話番号（例: +81901234567）
    #   - type="VOICE"の場合: E.164形式の電話番号（例: +81901234567）
    # 注意: コンタクトチャネルは作成後にアクティベーションが必要です。
    #       アクティベーションコードがこのアドレスに送信されます。
    simple_address = "user@example.com"
  }

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-west-2, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # リソース管理設定
  #-------------------------------------------------------------

  # id (Optional)
  # 設定内容: Terraformのリソース識別子を指定します。
  # 省略時: AWSが自動的に生成したIDが使用されます。
  # 注意: 通常は明示的に指定する必要はありません。
  #       インポート時やstate管理の特殊なケースでのみ使用します。
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: コンタクトチャネルのAmazon Resource Name (ARN)
#        形式: arn:aws:ssm-contacts:region:account-id:contact-channel/channel-id
#
# - activation_status: コンタクトチャネルのアクティベーション状態
#        可能な値:
#          - "ACTIVATED": アクティベーション済み。エンゲージメントに使用可能
#          - "NOT_ACTIVATED": 未アクティベーション。まだ使用できません
#        注意: チャネルを使用するには、AWS Systems Managerコンソールまたは
#              CLIでアクティベーションを完了する必要があります。
#---------------------------------------------------------------
