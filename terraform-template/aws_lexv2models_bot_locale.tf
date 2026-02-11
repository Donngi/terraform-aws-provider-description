#---------------------------------------------------------------
# Amazon Lex V2 Bot Locale
#---------------------------------------------------------------
#
# Amazon Lex V2ボットのロケール（言語と地域）を設定するリソース。
# ボットが特定の言語でユーザーと対話できるようにするための設定を行います。
# 各ロケールごとに、インテント、スロット、スロットタイプを個別に定義します。
#
# AWS公式ドキュメント:
#   - Adding a new language to an Amazon Lex V2 bot: https://docs.aws.amazon.com/lexv2/latest/dg/add-language.html
#   - Languages and locales supported: https://docs.aws.amazon.com/lexv2/latest/dg/how-languages.html
#   - Using intent confidence scores: https://docs.aws.amazon.com/lexv2/latest/dg/using-intent-confidence-scores.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lexv2models_bot_locale
#
# Provider Version: 6.28.0
# Generated: 2026-01-28
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lexv2models_bot_locale" "example" {
  #---------------------------------------------------------------
  # Required Parameters
  #---------------------------------------------------------------

  # ロケールを作成する対象のボットの識別子
  # 既存のLex V2ボットのIDを指定します
  bot_id = "example-bot-id"

  # ロケールを作成する対象のボットのバージョン
  # 通常は "DRAFT" を指定します（ドラフト版のボットのみロケール作成が可能）
  bot_version = "DRAFT"

  # ボットで使用する言語とロケールの識別子
  # 形式: 言語コード_国コード (例: en_US, ja_JP, es_ES)
  # サポートされるロケールの一覧:
  # https://docs.aws.amazon.com/lexv2/latest/dg/how-languages.html
  # ボット内の全てのインテント、スロットタイプ、スロットは同じロケールである必要があります
  locale_id = "en_US"

  # NLU（自然言語理解）のインテント信頼度のしきい値
  # 値の範囲: 0.00 ～ 1.00
  # この値は、Amazon LexがAMAZON.FallbackIntentやAMAZON.KendraSearchIntentを
  # 挿入するかどうかの判断基準となります
  # 全てのインテントの信頼スコアがこのしきい値未満の場合、FallbackIntentが返されます
  # 例: 0.70に設定すると、70%未満の信頼度のインテントは不確実と判断されます
  n_lu_intent_confidence_threshold = 0.70

  #---------------------------------------------------------------
  # Optional Parameters
  #---------------------------------------------------------------

  # ボットロケールの説明
  # ロケールをリストで識別する際に役立つ説明文を設定します
  description = "English (US) locale for example bot"

  # ボットロケールの名前
  # 指定しない場合は自動的に設定されます（computed）
  # name = "en_US"

  # このリソースが管理されるAWSリージョン
  # 指定しない場合は、プロバイダー設定で指定されたリージョンがデフォルトで使用されます
  # 詳細: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-west-2"

  #---------------------------------------------------------------
  # Nested Blocks
  #---------------------------------------------------------------

  # voice_settings - 音声対話時の設定
  # Amazon Pollyの音声IDと音声エンジンを設定します
  # ボットが音声対話をサポートする場合に使用します
  voice_settings {
    # Amazon Pollyの音声識別子（必須）
    # 利用可能な音声IDの一覧は以下を参照:
    # https://docs.aws.amazon.com/polly/latest/dg/voicelist.html
    # 例: "Joanna", "Matthew", "Kendra" (英語)
    #     "Mizuki", "Takumi" (日本語)
    voice_id = "Joanna"

    # Amazon Polly音声エンジンのタイプ（オプション）
    # 有効な値: "standard" または "neural"
    # 指定しない場合のデフォルト: "standard"
    # neural エンジンはより自然な音声を提供しますが、
    # 一部の音声とリージョンでのみ利用可能です
    engine = "standard"
  }

  #---------------------------------------------------------------
  # Timeouts
  #---------------------------------------------------------------

  # リソース操作のタイムアウト設定
  # 時間の形式: "30s"（秒）、"5m"（分）、"2h"（時間）など
  timeouts {
    # 作成時のタイムアウト
    # create = "30m"

    # 更新時のタイムアウト
    # update = "30m"

    # 削除時のタイムアウト
    # delete = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用)
#---------------------------------------------------------------
#
# このリソースをapply後、以下の属性が参照可能になります:
#
# - id: リソースの識別子
#   形式: "locale_id,bot_id,bot_version" のカンマ区切り文字列
#   例: "en_US,ABCD123456,DRAFT"
#
# - name: 指定されたロケール名
#   例: "en_US"
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例
#---------------------------------------------------------------
#
# 基本的な使用例:
#
# resource "aws_lexv2models_bot_locale" "example" {
#   bot_id                           = aws_lexv2models_bot.example.id
#   bot_version                      = "DRAFT"
#   locale_id                        = "en_US"
#   n_lu_intent_confidence_threshold = 0.70
# }
#
# 音声設定を含む使用例:
#
# resource "aws_lexv2models_bot_locale" "example_with_voice" {
#   bot_id                           = aws_lexv2models_bot.example.id
#   bot_version                      = "DRAFT"
#   locale_id                        = "en_US"
#   n_lu_intent_confidence_threshold = 0.70
#   description                      = "US English locale with voice settings"
#
#   voice_settings {
#     voice_id = "Kendra"
#     engine   = "standard"
#   }
# }
#
# 日本語ロケールの例:
#
# resource "aws_lexv2models_bot_locale" "japanese" {
#   bot_id                           = aws_lexv2models_bot.example.id
#   bot_version                      = "DRAFT"
#   locale_id                        = "ja_JP"
#   n_lu_intent_confidence_threshold = 0.70
#   description                      = "Japanese locale"
#
#   voice_settings {
#     voice_id = "Mizuki"
#     engine   = "neural"
#   }
# }
#
#---------------------------------------------------------------
