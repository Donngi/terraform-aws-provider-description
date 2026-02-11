#---------------------------------------------------------------
# AWS CloudWatch Event Permission (EventBridge Permission)
#---------------------------------------------------------------
#
# EventBridgeのパーミッションを作成し、クロスアカウントイベントをサポートするリソースです。
# 他のAWSアカウントがデフォルトイベントバス（またはカスタムイベントバス）にイベントを
# 送信することを許可します。
#
# 注意: EventBridgeは以前CloudWatch Eventsと呼ばれていました。機能は同一です。
#
# 注意: EventBridgeバスポリシーリソース（aws_cloudwatch_event_bus_policy）は
#       EventBridgeパーミッションリソース（aws_cloudwatch_event_permission）と
#       互換性がなく、パーミッションを上書きします。
#
# AWS公式ドキュメント:
#   - Amazon EventBridge permissions: https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-event-bus-perms.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_permission
#
# Provider Version: 6.28.0
# Generated: 2026-01-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_cloudwatch_event_permission" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # principal (Required)
  # 設定内容: デフォルトイベントバスにイベントを送信することを許可する12桁のAWSアカウントIDを指定します。
  # 設定可能な値:
  #   - 12桁のAWSアカウントID（例: "123456789012"）
  #   - "*": 任意のアカウントにイベントの送信を許可（conditionで制限することを推奨）
  # 注意: "*"を指定する場合は、conditionブロックでアクセスを制限することを強く推奨します。
  principal = "123456789012"

  # statement_id (Required)
  # 設定内容: パーミッションを付与する外部アカウントの識別子文字列を指定します。
  # 設定可能な値: 一意の識別子文字列
  # 注意: このIDはEventBridgeのリソースベースポリシー内でステートメントを識別するために使用されます。
  statement_id = "DevAccountAccess"

  #-------------------------------------------------------------
  # オプション設定
  #-------------------------------------------------------------

  # action (Optional)
  # 設定内容: 他のアカウントに許可するアクションを指定します。
  # 設定可能な値: EventBridgeのアクション（例: "events:PutEvents"）
  # 省略時: "events:PutEvents"
  action = "events:PutEvents"

  # event_bus_name (Optional)
  # 設定内容: パーミッションを設定するイベントバスの名前を指定します。
  # 設定可能な値: 有効なイベントバス名
  # 省略時: "default"（デフォルトイベントバス）
  event_bus_name = "default"

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # 条件設定（オプション）
  #-------------------------------------------------------------

  # condition (Optional, max 1 block)
  # 設定内容: イベントバスパーミッションを特定の条件を満たすアカウントのみに制限する設定です。
  # 用途: principalに"*"を指定した場合、特定のOrganization内のアカウントのみに制限するなど
  condition {
    # key (Required)
    # 設定内容: 条件のキーを指定します。
    # 設定可能な値: "aws:PrincipalOrgID"
    key = "aws:PrincipalOrgID"

    # type (Required)
    # 設定内容: 条件のタイプを指定します。
    # 設定可能な値: "StringEquals"
    type = "StringEquals"

    # value (Required)
    # 設定内容: キーに対する値を指定します。
    # 設定可能な値: Organization IDなど、keyに対応する値
    value = "o-xxxxxxxxxx"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: EventBridgeパーミッションのステートメントID
#---------------------------------------------------------------
