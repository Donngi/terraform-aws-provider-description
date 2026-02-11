/*
 * Terraform Template: aws_connect_bot_association
 *
 * 生成日: 2026-01-19
 * Provider Version: 6.28.0
 *
 * 注意: このテンプレートは生成時点の情報に基づいています。
 * 最新の仕様については、必ず公式ドキュメントをご確認ください。
 * https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/connect_bot_association
 */

/*
 * aws_connect_bot_association
 *
 * 概要:
 *   Amazon Connect インスタンスが特定の Amazon Lex (V1) ボットにアクセスできるようにするリソース。
 *   Amazon Lex を使用することで、顧客との会話型インタラクション（ボット）を構築できます。
 *   音声入力だけでなく、顧客がキーパッドで数字を入力することもサポートします。
 *
 * 重要な注意事項:
 *   - このリソースは現在 Amazon Lex V1 のみをサポートしています
 *   - Amazon Lex V1 は 2025年9月15日にサポート終了予定です
 *   - Lex V2 への移行を検討してください
 *
 * 参考ドキュメント:
 *   - Amazon Connect Getting Started: https://docs.aws.amazon.com/connect/latest/adminguide/amazon-connect-get-started.html
 *   - Add an Amazon Lex bot: https://docs.aws.amazon.com/connect/latest/adminguide/amazon-lex.html
 *   - AssociateLexBot API: https://docs.aws.amazon.com/connect/latest/APIReference/API_AssociateLexBot.html
 */

resource "aws_connect_bot_association" "example" {
  # ========================================
  # 必須パラメータ
  # ========================================

  # instance_id (必須)
  # 説明: Amazon Connect インスタンスの識別子
  # 形式: Amazon Connect インスタンスの ARN から取得できる instanceId
  # 例: "aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee"
  # 参考: https://docs.aws.amazon.com/connect/latest/adminguide/find-instance-arn.html
  instance_id = "aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee"

  # ========================================
  # オプションパラメータ
  # ========================================

  # id (オプション、Computed)
  # 説明: リソースの一意識別子
  # 形式: Amazon Connect インスタンス ID、Lex (V1) ボット名、Lex (V1) ボットリージョンをコロン (:) で区切った文字列
  # 例: "aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee:TestBot:us-west-2"
  # 注意: 通常は Terraform が自動的に生成するため、明示的な指定は不要です
  # id = "aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee:TestBot:us-west-2"

  # region (オプション、Computed)
  # 説明: このリソースが管理されるリージョン
  # デフォルト: プロバイダー設定で指定されたリージョン
  # 例: "us-east-1"
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  # ========================================
  # ネストブロック: lex_bot (必須)
  # ========================================

  # lex_bot
  # 説明: Amazon Lex (V1) ボットの設定情報
  # 制約: 1つのみ指定可能（min_items=1, max_items=1）
  # 参考: https://docs.aws.amazon.com/lex/latest/dg/what-is.html
  lex_bot {
    # name (必須)
    # 説明: Amazon Lex (V1) ボットの名前
    # 例: "AccountBalance", "CustomerSupportBot"
    # 参考: Amazon Lex コンソールで作成したボット名を指定
    name = "AccountBalance"

    # lex_region (オプション、Computed)
    # 説明: Amazon Lex (V1) ボットが作成されたリージョン
    # デフォルト: 現在のリージョン（プロバイダー設定のリージョン）
    # 例: "us-west-2"
    # 注意: Connect インスタンスと異なるリージョンの Lex ボットも関連付け可能
    # lex_region = "us-west-2"
  }
}

# ========================================
# 出力例
# ========================================

# output "bot_association_id" {
#   description = "ボット関連付けの ID"
#   value       = aws_connect_bot_association.example.id
# }

# ========================================
# 使用例: サンプル Lex ボットを含む完全な構成
# ========================================

# data "aws_region" "current" {}
#
# resource "aws_lex_intent" "example" {
#   create_version = true
#   name           = "connect_lex_intent"
#   fulfillment_activity {
#     type = "ReturnIntent"
#   }
#   sample_utterances = [
#     "I would like to pick up flowers.",
#   ]
# }
#
# resource "aws_lex_bot" "example" {
#   abort_statement {
#     message {
#       content      = "Sorry, I am not able to assist at this time."
#       content_type = "PlainText"
#     }
#   }
#   clarification_prompt {
#     max_attempts = 2
#     message {
#       content      = "I didn't understand you, what would you like to do?"
#       content_type = "PlainText"
#     }
#   }
#   intent {
#     intent_name    = aws_lex_intent.example.name
#     intent_version = "1"
#   }
#
#   child_directed   = false
#   name             = "connect_lex_bot"
#   process_behavior = "BUILD"
# }
#
# resource "aws_connect_instance" "example" {
#   identity_management_type = "CONNECT_MANAGED"
#   inbound_calls_enabled    = true
#   instance_alias           = "example-connect-instance"
#   outbound_calls_enabled   = true
# }
#
# resource "aws_connect_bot_association" "example" {
#   instance_id = aws_connect_instance.example.id
#   lex_bot {
#     lex_region = data.aws_region.current.name
#     name       = aws_lex_bot.example.name
#   }
# }
