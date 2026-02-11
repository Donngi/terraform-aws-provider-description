#---------------------------------------------------------------
# AWS CloudWatch Event Bus Policy (EventBridge Resource Policy)
#---------------------------------------------------------------
#
# Amazon EventBridgeのイベントバスにリソースベースポリシーをアタッチするリソースです。
# クロスアカウントでのイベント送信・受信を可能にするためのアクセス制御を提供します。
#
# 注意事項:
#   - EventBridgeは以前CloudWatch Eventsとして知られていました。機能は同一です。
#   - aws_cloudwatch_event_bus_policyリソースはaws_cloudwatch_event_permissionリソースと
#     互換性がなく、既存のpermissionsを上書きします。
#
# AWS公式ドキュメント:
#   - EventBridgeイベントバスの権限: https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-event-bus-perms.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_bus_policy
#
# Provider Version: 6.28.0
# Generated: 2026-01-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# IAMポリシードキュメント（ポリシー定義用）
#---------------------------------------------------------------
# EventBusのリソースポリシーは、aws_iam_policy_documentデータソースを
# 使用して定義することが推奨されます。
#---------------------------------------------------------------

data "aws_iam_policy_document" "eventbridge_policy" {
  # アカウントアクセスの例
  statement {
    sid    = "AllowCrossAccountPutEvents"
    effect = "Allow"

    actions = [
      "events:PutEvents",
    ]

    resources = [
      "arn:aws:events:ap-northeast-1:123456789012:event-bus/my-event-bus"
    ]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::987654321098:root"]
    }
  }

  # Organizations全体へのアクセス許可の例（コメントアウト）
  # statement {
  #   sid    = "AllowOrganizationAccess"
  #   effect = "Allow"
  #
  #   actions = [
  #     "events:DescribeRule",
  #     "events:ListRules",
  #     "events:ListTargetsByRule",
  #     "events:ListTagsForResource",
  #   ]
  #
  #   resources = [
  #     "arn:aws:events:ap-northeast-1:123456789012:rule/*",
  #     "arn:aws:events:ap-northeast-1:123456789012:event-bus/my-event-bus"
  #   ]
  #
  #   principals {
  #     type        = "AWS"
  #     identifiers = ["*"]
  #   }
  #
  #   condition {
  #     test     = "StringEquals"
  #     variable = "aws:PrincipalOrgID"
  #     values   = ["o-xxxxxxxxxx"]
  #   }
  # }
}

resource "aws_cloudwatch_event_bus_policy" "example" {
  #-------------------------------------------------------------
  # ポリシー設定
  #-------------------------------------------------------------

  # policy (Required)
  # 設定内容: イベントバスにアタッチするIAMポリシーをJSON形式で指定します。
  # 設定可能な値: 有効なIAMポリシーのJSON文字列
  # 関連機能: EventBridgeリソースベースポリシー
  #   クロスアカウントでのイベント送信を許可するためのポリシー。
  #   PutEvents、PutRule、PutTargetsなどのアクションを制御できます。
  #   - https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-event-bus-perms.html
  # 注意: aws_iam_policy_documentデータソースを使用してポリシーを構築することを推奨
  #   - https://learn.hashicorp.com/terraform/aws/iam-policy
  policy = data.aws_iam_policy_document.eventbridge_policy.json

  #-------------------------------------------------------------
  # イベントバス設定
  #-------------------------------------------------------------

  # event_bus_name (Optional)
  # 設定内容: ポリシーを設定するイベントバスの名前を指定します。
  # 設定可能な値: 既存のイベントバス名（文字列）
  # 省略時: "default"イベントバスにポリシーが設定されます
  # 関連機能: EventBridgeイベントバス
  #   カスタムイベントバスを作成して、アプリケーション固有のイベントを
  #   分離して管理できます。
  #   - https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-event-bus.html
  event_bus_name = aws_cloudwatch_event_bus.example.name

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# 関連リソース: カスタムイベントバス（参考）
#---------------------------------------------------------------
# カスタムイベントバスを使用する場合は、以下のようにイベントバスを
# 作成してからポリシーをアタッチします。
#---------------------------------------------------------------

resource "aws_cloudwatch_event_bus" "example" {
  name = "my-event-bus"

  tags = {
    Name        = "my-event-bus"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: EventBridgeイベントバスの名前
#       event_bus_nameを指定した場合はその値、省略した場合は"default"
#---------------------------------------------------------------
