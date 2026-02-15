#---------------------------------------
# aws_connect_bot_association
#---------------------------------------
# Provider Version: 6.28.0
# Generated: 2026-02-13
# NOTE: このリソースは現在 Amazon Lex V1 のみサポート（V2 は非対応）
#
# Amazon Connect インスタンスと Amazon Lex (V1) ボットの関連付けリソース
#
# 用途:
#   - Amazon Connect コンタクトセンターに Amazon Lex ボットを統合
#   - 音声・チャット対話フローでの会話AIボット利用
#   - IVRシステムへの自然言語処理機能追加
#
# 主な機能:
#   - Lex V1 ボットのConnect インスタンスへの関連付け
#   - リージョン間のボット統合サポート
#   - フローブロックでの顧客入力処理
#
# 制限事項:
#   - 現在は Amazon Lex V1 のみサポート（V2は非対応）
#   - 1つのインスタンスに複数のボットを関連付け可能
#   - ボット側のリソースベースポリシーは自動更新される
#
# 前提条件:
#   - Amazon Connect インスタンスが存在すること
#   - Amazon Lex V1 ボットが作成済みであること
#   - Connect インスタンスに適切な IAM 権限が設定されていること
#
# 注意事項:
#   - ボット削除前に関連付けを解除する必要がある
#   - Lex V2 ボットを使用する場合は AWS CLI/SDK で手動設定が必要
#   - リージョンをまたぐ構成では lex_region の明示的指定が推奨される
#
# 参考リンク:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/connect_bot_association
#   - https://docs.aws.amazon.com/connect/latest/adminguide/amazon-lex.html
#   - https://docs.aws.amazon.com/connect/latest/APIReference/API_AssociateLexBot.html

#---------------------------------------
# リソース定義
#---------------------------------------
resource "aws_connect_bot_association" "example" {
  #---------------------------------------
  # Connect インスタンス設定
  #---------------------------------------
  # 設定内容: Amazon Connect インスタンスの識別子
  # 設定可能な値: インスタンス ARN から取得可能な UUID 形式の ID
  # 省略時: エラー（必須項目）
  instance_id = "aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee"

  #---------------------------------------
  # リージョン管理設定
  #---------------------------------------
  # 設定内容: このリソースを管理するリージョン
  # 設定可能な値: AWS リージョンコード (例: us-east-1, ap-northeast-1)
  # 省略時: プロバイダー設定のリージョンを使用
  region = "us-east-1"

  #---------------------------------------
  # Lex ボット設定
  #---------------------------------------
  lex_bot {
    # 設定内容: Amazon Lex V1 ボットの名前
    # 設定可能な値: 既存の Lex V1 ボット名（文字列）
    # 省略時: エラー（必須項目）
    name = "example-bot"

    # 設定内容: Lex ボットが作成されたリージョン
    # 設定可能な値: AWS リージョンコード (例: us-west-2)
    # 省略時: 現在のリージョンを使用
    # lex_region = "us-west-2"
  }

  #---------------------------------------
  # 追加設定例
  #---------------------------------------
  # タグ設定はこのリソースではサポートされていません
}

#---------------------------------------
# Attributes Reference
#---------------------------------------
# id = "<instance_id>:<lex_bot_name>:<lex_region>" 形式の識別子が自動生成される
