#---------------------------------------------------------------
# AWS Security Hub Action Target
#---------------------------------------------------------------
#
# AWS Security Hubのカスタムアクションターゲットを作成するリソースです。
# カスタムアクションを使用すると、Security Hubで検出した特定のfindingsに対して
# カスタムアクションを実行できます。例えば、重要な検出結果をチャットシステムに
# 通知したり、チケット管理システムに自動登録したりできます。
#
# カスタムアクションは、Security Hubのコンソールやアクションリストから
# 選択した検出結果に対して実行されます。アクションが実行されると、
# EventBridge経由でイベントが発行され、Lambda関数や他のAWSサービスを
# トリガーできます。
#
# AWS公式ドキュメント:
#   - Security Hub カスタムアクション: https://docs.aws.amazon.com/securityhub/latest/userguide/securityhub-custom-actions.html
#   - Security Hub API リファレンス: https://docs.aws.amazon.com/securityhub/latest/APIReference/Welcome.html
#   - Security Hub ユーザーガイド: https://docs.aws.amazon.com/securityhub/latest/userguide/what-is-securityhub.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/securityhub_action_target
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_securityhub_action_target" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: カスタムアクションターゲットの名前を指定します。
  # 設定可能な値: 人間が読める形式の文字列
  # 用途: Security Hubのコンソールやアクションリストに表示される名前
  # 例: "Send notification to chat", "Create support ticket"
  # 関連機能: Security Hub カスタムアクション
  #   Security Hubのコンソールで検出結果を選択した際に表示されるアクション名。
  #   ユーザーがアクションを識別するために使用します。
  #   - https://docs.aws.amazon.com/securityhub/latest/userguide/securityhub-custom-actions.html
  name = "Send notification to chat"

  # identifier (Required)
  # 設定内容: カスタムアクションターゲットの一意の識別子を指定します。
  # 設定可能な値: 英数字とアンダースコアのみを含む文字列
  # 用途: EventBridgeルールやAPIで参照する際の識別子
  # 例: "SendToChat", "CreateTicket", "EscalateToSOC"
  # 注意: この値は作成後に変更できません。変更する場合はリソースの再作成が必要です
  # 関連機能: Security Hub アクション識別子
  #   EventBridgeルールのイベントパターンやAPIコールで使用する一意の識別子。
  #   ARNの一部として使用されます。
  #   - https://docs.aws.amazon.com/securityhub/latest/userguide/securityhub-cloudwatch-events.html
  identifier = "SendToChat"

  # description (Required)
  # 設定内容: カスタムアクションターゲットの説明を指定します。
  # 設定可能な値: アクションの目的を説明する文字列
  # 用途: アクションの目的や動作を明確にするための説明文
  # 例: "This custom action sends selected findings to chat system"
  # 関連機能: Security Hub アクションの説明
  #   コンソールやAPIで表示される説明。アクションの目的や効果を明確に伝えます。
  #   - https://docs.aws.amazon.com/securityhub/latest/userguide/securityhub-custom-actions.html
  description = "This is custom action sends selected findings to chat"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード (例: us-east-1, ap-northeast-1)
  # 省略時: プロバイダー設定のリージョンを使用
  # 注意: Security Hubはリージョナルサービスです。各リージョンで個別に設定が必要です
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # 依存関係の設定
  #-------------------------------------------------------------
  # Security Hubアカウントが有効化されている必要があります。
  # 通常は aws_securityhub_account リソースに依存します:
  #
  # depends_on = [aws_securityhub_account.example]
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: カスタムアクションターゲットのAmazon Resource Name (ARN)
#   形式: arn:aws:securityhub:<region>:<account-id>:action/custom/<identifier>
#   用途: EventBridgeルールでこのアクションをターゲットとする際に使用
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# カスタムアクションが実行されると、EventBridge経由でイベントが発行されます。
# 以下のようなEventBridgeルールを設定して、Lambda関数などをトリガーできます:
#
# resource "aws_cloudwatch_event_rule" "custom_action" {
#   name        = "securityhub-custom-action"
#   description = "Capture Security Hub custom action events"
#
#   event_pattern = jsonencode({
#     source      = ["aws.securityhub"]
#     detail-type = ["Security Hub Findings - Custom Action"]
#     resources   = [aws_securityhub_action_target.example.arn]
#   })
# }
#---------------------------------------------------------------
