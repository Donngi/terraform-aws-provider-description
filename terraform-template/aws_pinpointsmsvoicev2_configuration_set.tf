#---------------------------------------------------------------
# AWS End User Messaging SMS Configuration Set
#---------------------------------------------------------------
#
# AWS End User Messaging SMS Configuration Set を管理するリソースです。
# Configuration Set は、SMSメッセージングの送信設定をグループ化し、
# デフォルトの送信者ID、メッセージタイプなどを一元管理できます。
#
# Configuration Set の主な用途:
#   - SMS送信時のデフォルト設定を一元管理
#   - 送信者ID (Sender ID) の管理
#   - メッセージタイプ (トランザクション/プロモーション) の設定
#   - 複数のSMS設定の論理的なグループ化
#
# AWS公式ドキュメント:
#   - End User Messaging SMS 概要: https://docs.aws.amazon.com/pinpoint/latest/userguide/channels-sms.html
#   - SMS Configuration Set: https://docs.aws.amazon.com/pinpoint/latest/userguide/settings-sms.html
#   - SMS ベストプラクティス: https://docs.aws.amazon.com/pinpoint/latest/userguide/channels-sms-best-practices.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/pinpointsmsvoicev2_configuration_set
#
# Provider Version: 6.28.0
# Generated: 2026-02-02
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_pinpointsmsvoicev2_configuration_set" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: Configuration Set の名前を指定します。
  # 設定可能な値: 英数字、ハイフン、アンダースコアを含む文字列
  # 用途: Configuration Set を識別するための一意の名前
  # 制約:
  #   - アカウント内で一意である必要があります
  #   - 作成後の変更は新しいリソースを作成します
  # 関連機能: SMS Configuration Management
  #   設定セットの識別子として使用され、SMS送信時に参照されます。
  #   - https://docs.aws.amazon.com/pinpoint/latest/userguide/settings-sms.html
  name = "example-configuration-set"

  #-------------------------------------------------------------
  # デフォルト送信者設定
  #-------------------------------------------------------------

  # default_sender_id (Optional)
  # 設定内容: このConfiguration Setで使用するデフォルトの送信者IDを指定します。
  # 設定可能な値: 送信者IDとして使用する文字列
  # 省略時: 送信者IDは設定されません
  # 用途: SMS受信者に表示される送信者名を設定
  # 注意:
  #   - 送信者IDは一部の国でのみサポートされています
  #   - 国によっては事前登録が必要な場合があります
  #   - 米国では送信者IDはサポートされていません
  # 関連機能: SMS Sender ID
  #   受信者のデバイスに表示される送信者の識別情報。ブランド認知に役立ちます。
  #   - https://docs.aws.amazon.com/pinpoint/latest/userguide/channels-sms-senderid.html
  default_sender_id = "example"

  #-------------------------------------------------------------
  # メッセージタイプ設定
  #-------------------------------------------------------------

  # default_message_type (Optional)
  # 設定内容: このConfiguration Setで送信するメッセージのデフォルトタイプを指定します。
  # 設定可能な値:
  #   - "TRANSACTIONAL": トランザクションメッセージ (OTP、確認コードなど)
  #   - "PROMOTIONAL": プロモーションメッセージ (マーケティング、広告など)
  # 省略時: メッセージタイプは設定されません
  # 用途: メッセージの性質を分類し、配信最適化とコンプライアンスを向上
  # 違い:
  #   TRANSACTIONAL:
  #     - 高優先度で配信
  #     - オプトアウト済みのユーザーにも送信可能（法規制に準拠する場合）
  #     - 認証コード、注文確認など重要な通知に使用
  #   PROMOTIONAL:
  #     - 標準優先度で配信
  #     - オプトアウトしたユーザーには送信不可
  #     - マーケティングメッセージやキャンペーン情報に使用
  # 関連機能: SMS Message Types
  #   メッセージタイプにより配信方法とコンプライアンス要件が異なります。
  #   - https://docs.aws.amazon.com/pinpoint/latest/userguide/channels-sms-best-practices.html
  default_message_type = "TRANSACTIONAL"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード (例: us-east-1, ap-northeast-1)
  # 省略時: プロバイダー設定のリージョンを使用
  # 用途: マルチリージョン構成でリソースの配置を制御
  # 注意: SMS サービスは一部のリージョンでのみ利用可能です
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 用途: リソースの分類、コスト配分、アクセス制御などに使用
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://docs.aws.amazon.com/general/latest/gr/aws_tagging.html
  tags = {
    Name        = "example-sms-configuration-set"
    Environment = "production"
    Service     = "sms-messaging"
  }

  # tags_all (Optional, Computed)
  # 設定内容: プロバイダーのdefault_tagsから継承されるタグを含む全タグのマップ
  # 注意: 通常は明示的に設定する必要はありません。Terraformが自動管理します
  tags_all = null

  # id (Optional, Computed)
  # 設定内容: リソースのID
  # 注意: 通常は明示的に設定する必要はありません。Terraformが自動管理します
  id = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: Configuration Set のAmazon Resource Name (ARN)
#   フォーマット: arn:aws:sms-voice:region:account-id:configuration-set/name
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#   リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------

#---------------------------------------------------------------
# 1. トランザクションメッセージ用の設定:
#    - default_message_type = "TRANSACTIONAL"
#    - 認証コード、注文確認、アラートなどに使用
#
# 2. プロモーションメッセージ用の設定:
#    - default_message_type = "PROMOTIONAL"
#    - マーケティングキャンペーン、特別オファーに使用
#
# 3. 送信者ID使用時の注意点:
#    - 送信先の国が送信者IDをサポートしているか確認
#    - 一部の国では事前登録が必要
#    - 米国では使用不可
#---------------------------------------------------------------
