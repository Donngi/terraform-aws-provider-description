#---------------------------------------------------------------
# Amazon Lex Bot
#---------------------------------------------------------------
#
# Amazon Lex Botは、音声とテキストによる会話型インターフェースを
# アプリケーションに追加するためのAWSサービスです。
# Alexaと同じ技術を使用し、高度なチャットボットを構築できます。
#
# AWS公式ドキュメント:
#   - What Is Amazon Lex?: https://docs.aws.amazon.com/lex/latest/dg/what-is.html
#   - How It Works: https://docs.aws.amazon.com/lex/latest/dg/how-it-works.html
#   - Amazon Lex Features: https://aws.amazon.com/lex/features/
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lex_bot
#
# Provider Version: 6.28.0
# Generated: 2026-01-28
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lex_bot" "example" {
  #---------------------------------------------------------------
  # Required Arguments
  #---------------------------------------------------------------

  # ボット名（2〜50文字、大文字小文字を区別）
  name = "OrderFlowers"

  # 子供向けコンテンツかどうか（COPPA準拠）
  # true を指定することで、13歳未満の子供を対象とした使用であることを確認します
  # 詳細: https://aws.amazon.com/lex/faqs#data-security
  child_directed = false

  #---------------------------------------------------------------
  # Optional Arguments
  #---------------------------------------------------------------

  # ボットの説明（200文字以内）
  description = "Bot to order flowers on the behalf of a user"

  # 新しいボットバージョンの自動作成（デフォルト: false）
  # trueの場合、初回作成時および更新時に新しいバージョンが作成されます
  create_version = false

  # センチメント分析の有効化（デフォルト: false）
  # trueの場合、ユーザーの発話がAmazon Comprehendに送信され、感情分析が行われます
  detect_sentiment = false

  # 自然言語理解の改善機能を有効化（デフォルト: false）
  # trueにすると、nlu_intent_confidence_thresholdを設定して信頼度スコアを構成できます
  # 特定のリージョンでのみ設定可能
  # 詳細: https://docs.aws.amazon.com/lex/latest/dg/confidence-scores.html
  enable_model_improvements = false

  # アイドルセッションのタイムアウト時間（秒）
  # 60〜86400の範囲で指定（デフォルト: 300）
  # 会話データが保持される最大時間を定義します
  idle_session_ttl_in_seconds = 600

  # ボットのロケール（デフォルト: en-US）
  # 使用するすべてのIntentはこのロケールと互換性がある必要があります
  # 利用可能なロケール: https://docs.aws.amazon.com/lex/latest/dg/API_PutBot.html#lex-PutBot-request-locale
  locale = "en-US"

  # Intent信頼度の閾値（0〜1の範囲）
  # AMAZON.FallbackIntentやAMAZON.KendraSearchIntentを挿入する閾値
  # enable_model_improvementsがtrueの場合に使用可能（デフォルト: 0）
  nlu_intent_confidence_threshold = 0.0

  # 処理動作（BUILD または SAVE）
  # BUILD: ボットをビルドして実行可能にする
  # SAVE: ボットを保存するがビルドしない（デフォルト: SAVE）
  process_behavior = "BUILD"

  # Amazon Pollyの音声ID
  # 音声インタラクションで使用する音声を指定
  # ボットのロケールと一致する必要があります
  # 利用可能な音声: https://docs.aws.amazon.com/polly/latest/dg/voicelist.html
  voice_id = "Salli"

  # このリソースが管理されるAWSリージョン
  # 未指定の場合、プロバイダー設定のリージョンが使用されます
  # region = "us-east-1"

  #---------------------------------------------------------------
  # Nested Blocks
  #---------------------------------------------------------------

  # 会話を中断する際のメッセージ（必須）
  abort_statement {
    # 応答カード（オプション）
    # セッション属性とスロット値が置換されます
    # 詳細: https://docs.aws.amazon.com/lex/latest/dg/ex-resp-card.html
    # response_card = "string"

    # メッセージセット（1〜15個、必須）
    message {
      # メッセージの内容（必須）
      content = "Sorry, I am not able to assist at this time"

      # コンテンツタイプ（必須）
      # PlainText または SSML（Speech Synthesis Markup Language）
      content_type = "PlainText"

      # メッセージグループ番号（オプション）
      # Amazon Lexは各グループから1つのメッセージを返します
      # group_number = 1
    }
  }

  # ユーザーの意図が不明な場合の確認プロンプト（オプション）
  clarification_prompt {
    # プロンプトの最大試行回数（必須）
    max_attempts = 2

    # 応答カード（オプション）
    # セッション属性とスロット値が置換されます
    # 詳細: https://docs.aws.amazon.com/lex/latest/dg/ex-resp-card.html
    # response_card = "string"

    # メッセージセット（1〜15個、必須）
    message {
      # メッセージの内容（必須）
      content = "I didn't understand you, what would you like to do?"

      # コンテンツタイプ（必須）
      # PlainText または SSML
      content_type = "PlainText"

      # メッセージグループ番号（オプション）
      # group_number = 1
    }
  }

  # Intentオブジェクトのセット（1〜250個、必須）
  # 各Intentはユーザーが表現できるコマンドを表します
  intent {
    # Intent名（100文字以内、必須）
    intent_name = "OrderFlowers"

    # Intentのバージョン（64文字以内、必須）
    intent_version = "1"
  }

  # タイムアウト設定（オプション）
  # timeouts {
  #   # 作成時のタイムアウト
  #   create = "5m"
  #
  #   # 更新時のタイムアウト
  #   update = "5m"
  #
  #   # 削除時のタイムアウト
  #   delete = "5m"
  # }
}

#---------------------------------------------------------------
# Attributes Reference (Computed Only)
#---------------------------------------------------------------
# 以下の属性は、リソース作成後に参照可能です（入力不可）
#
# - arn                  : ボットのARN
# - checksum             : ボットバージョンを識別するチェックサム
# - created_date         : ボットバージョンが作成された日時
# - failure_reason       : ステータスがFAILEDの場合、失敗理由
# - id                   : ボット名
# - last_updated_date    : $LATESTバージョンが更新された日時
# - status               : ボットのステータス（BUILDING, READY, FAILED）
# - version              : ボットのバージョン
#
#---------------------------------------------------------------

# 使用例:
# output "lex_bot_arn" {
#   description = "The ARN of the Lex Bot"
#   value       = aws_lex_bot.example.arn
# }
#
# output "lex_bot_checksum" {
#   description = "The checksum of the Lex Bot"
#   value       = aws_lex_bot.example.checksum
# }
#
# output "lex_bot_version" {
#   description = "The version of the Lex Bot"
#   value       = aws_lex_bot.example.version
# }
