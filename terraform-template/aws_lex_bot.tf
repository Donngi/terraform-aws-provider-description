#---------------------------------------------------------------
# Amazon Lex Bot
#---------------------------------------------------------------
#
# Amazon Lex V1 のボットをプロビジョニングするリソースです。
# Lex ボットは自然言語理解（NLU）を用いて、音声・テキストによる
# 会話型インターフェースを構築するためのコアコンポーネントです。
# インテント（意図）と組み合わせて、チャットボットや音声ボットを
# 実現します。
# 注意: 本リソースは Amazon Lex V1 のリソースです。
#       Amazon Lex V2 を使用する場合は aws_lexv2models_bot を
#       使用してください。
#
# AWS公式ドキュメント:
#   - Amazon Lex とは: https://docs.aws.amazon.com/lex/latest/dg/what-is.html
#   - ボットの作成: https://docs.aws.amazon.com/lex/latest/dg/gs-console.html
#   - ボットのロケール: https://docs.aws.amazon.com/lex/latest/dg/how-it-works.html#how-it-works-language
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lex_bot
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lex_bot" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: ボットの名前を指定します。
  # 設定可能な値: 2〜50文字の英数字、ハイフン、アンダースコア
  # 省略時: 省略不可
  name = "example-lex-bot"

  # child_directed (Required)
  # 設定内容: ボットが COPPA（児童オンラインプライバシー保護法）の対象かどうかを指定します。
  # 設定可能な値:
  #   - true: 13歳未満の子ども向けサービスに使用するボット
  #   - false: 子ども向けではないボット
  # 省略時: 省略不可
  # 注意: 誤った値を設定すると法的責任を負う場合があります。
  child_directed = false

  # description (Optional)
  # 設定内容: ボットの説明を指定します。
  # 設定可能な値: 最大200文字の文字列
  # 省略時: 説明なし
  description = "Amazon Lex ボットのサンプルテンプレートです。"

  # locale (Optional)
  # 設定内容: ボットのロケール（言語および地域）を指定します。
  # 設定可能な値:
  #   - "de-DE": ドイツ語（ドイツ）
  #   - "en-AU": 英語（オーストラリア）
  #   - "en-GB": 英語（イギリス）
  #   - "en-IN": 英語（インド）
  #   - "en-US": 英語（米国）
  #   - "es-419": スペイン語（ラテンアメリカ）
  #   - "es-ES": スペイン語（スペイン）
  #   - "es-US": スペイン語（米国）
  #   - "fr-FR": フランス語（フランス）
  #   - "fr-CA": フランス語（カナダ）
  #   - "it-IT": イタリア語（イタリア）
  #   - "ja-JP": 日本語（日本）
  #   - "ko-KR": 韓国語（韓国）
  #   - "pt-BR": ポルトガル語（ブラジル）
  #   - "pt-PT": ポルトガル語（ポルトガル）
  #   - "zh-CN": 中国語（中国）
  # 省略時: en-US
  locale = "en-US"

  # idle_session_ttl_in_seconds (Optional)
  # 設定内容: セッションのアイドルタイムアウト（秒）を指定します。
  # 設定可能な値: 60〜86400 の整数
  # 省略時: 300
  idle_session_ttl_in_seconds = 300

  # voice_id (Optional)
  # 設定内容: Amazon Polly が音声インタラクションに使用する音声の ID を指定します。
  # 設定可能な値: Amazon Polly で有効な音声 ID（例: "Joanna", "Salli", "Mizuki" など）
  # 省略時: ロケールに応じたデフォルト音声が自動設定
  # 参考: https://docs.aws.amazon.com/polly/latest/dg/voicelist.html
  voice_id = null

  # process_behavior (Optional)
  # 設定内容: ボットの保存時の動作を指定します。
  # 設定可能な値:
  #   - "SAVE": ボットを保存のみ（ビルドしない）
  #   - "BUILD": ボットを保存してビルドする
  # 省略時: "SAVE"
  process_behavior = "BUILD"

  # create_version (Optional)
  # 設定内容: 更新時に新しいボットバージョンを自動的に作成するかを指定します。
  # 設定可能な値:
  #   - true: 変更のたびに新しいバージョンを作成
  #   - false: バージョンを作成しない
  # 省略時: false
  create_version = false

  # detect_sentiment (Optional)
  # 設定内容: Amazon Comprehend を使用してユーザー発話のセンチメントを検出するかを指定します。
  # 設定可能な値:
  #   - true: センチメント検出を有効化
  #   - false: センチメント検出を無効化
  # 省略時: false
  detect_sentiment = false

  # enable_model_improvements (Optional)
  # 設定内容: 会話モデルの改善機能を有効にするかを指定します。
  # 設定可能な値:
  #   - true: モデル改善機能を有効化（nlu_intent_confidence_threshold の設定が必要）
  #   - false: モデル改善機能を無効化
  # 省略時: false
  enable_model_improvements = false

  # nlu_intent_confidence_threshold (Optional)
  # 設定内容: NLU がインテントを識別するための信頼スコアのしきい値を指定します。
  # 設定可能な値: 0〜1 の数値（例: 0.5）
  # 省略時: 省略可能（enable_model_improvements = true の場合に設定）
  # 注意: enable_model_improvements = true の場合のみ有効
  nlu_intent_confidence_threshold = null

  #-------------------------------------------------------------
  # 中断ステートメント設定
  #-------------------------------------------------------------

  # abort_statement (Required)
  # 設定内容: ボットが会話を中断する際にユーザーに返すメッセージを設定するブロックです。
  # 省略時: 省略不可
  abort_statement {

    # response_card (Optional)
    # 設定内容: レスポンスカードの JSON 文字列を指定します。
    # 設定可能な値: Amazon Lex レスポンスカード形式の JSON 文字列（最大50000文字）
    # 省略時: レスポンスカードなし
    # response_card = jsonencode({ ... })

    # message (Required, 1〜15件)
    # 設定内容: 中断時にユーザーに返すメッセージを設定するブロックです。
    message {

      # content (Required)
      # 設定内容: メッセージの内容を指定します。
      # 設定可能な値: 最大1000文字の文字列
      # 省略時: 省略不可
      content = "申し訳ございませんが、リクエストを処理できませんでした。"

      # content_type (Required)
      # 設定内容: メッセージコンテンツの形式を指定します。
      # 設定可能な値:
      #   - "PlainText": プレーンテキスト形式
      #   - "SSML": 音声合成マークアップ言語形式
      #   - "CustomPayload": カスタムペイロード形式
      # 省略時: 省略不可
      content_type = "PlainText"

      # group_number (Optional)
      # 設定内容: メッセージグループ番号を指定します。
      # 設定可能な値: 1〜5 の整数
      # 省略時: グループなし
      # 注意: 複数のメッセージに同じグループ番号を割り当てると、
      #       Lex はそのグループからランダムに1つのメッセージを選択します。
      # group_number = 1
    }
  }

  #-------------------------------------------------------------
  # 明確化プロンプト設定
  #-------------------------------------------------------------

  # clarification_prompt (Optional)
  # 設定内容: Lex がユーザーの意図を理解できない場合に送信するプロンプトを設定するブロックです。
  # 省略時: 明確化プロンプトなし
  clarification_prompt {

    # max_attempts (Required)
    # 設定内容: 明確化プロンプトを試みる最大回数を指定します。
    # 設定可能な値: 1〜5 の整数
    # 省略時: 省略不可
    max_attempts = 2

    # response_card (Optional)
    # 設定内容: レスポンスカードの JSON 文字列を指定します。
    # 設定可能な値: Amazon Lex レスポンスカード形式の JSON 文字列（最大50000文字）
    # 省略時: レスポンスカードなし
    # response_card = jsonencode({ ... })

    # message (Required, 1〜15件)
    # 設定内容: 明確化を求める際にユーザーに返すメッセージを設定するブロックです。
    message {

      # content (Required)
      # 設定内容: メッセージの内容を指定します。
      # 設定可能な値: 最大1000文字の文字列
      # 省略時: 省略不可
      content = "申し訳ございませんが、理解できませんでした。もう一度お試しください。"

      # content_type (Required)
      # 設定内容: メッセージコンテンツの形式を指定します。
      # 設定可能な値:
      #   - "PlainText": プレーンテキスト形式
      #   - "SSML": 音声合成マークアップ言語形式
      #   - "CustomPayload": カスタムペイロード形式
      # 省略時: 省略不可
      content_type = "PlainText"

      # group_number (Optional)
      # 設定内容: メッセージグループ番号を指定します。
      # 設定可能な値: 1〜5 の整数
      # 省略時: グループなし
      # group_number = 1
    }
  }

  #-------------------------------------------------------------
  # インテント設定
  #-------------------------------------------------------------

  # intent (Required, 1〜250件)
  # 設定内容: ボットに関連付けるインテントを設定するブロックです。
  # 省略時: 省略不可
  intent {

    # intent_name (Required)
    # 設定内容: インテントの名前を指定します。
    # 設定可能な値: 既存の aws_lex_intent リソースの名前
    # 省略時: 省略不可
    intent_name = aws_lex_intent.example.name

    # intent_version (Required)
    # 設定内容: インテントのバージョンを指定します。
    # 設定可能な値:
    #   - "$LATEST": 最新バージョン
    #   - 特定のバージョン番号（例: "1", "2"）
    # 省略時: 省略不可
    intent_version = aws_lex_intent.example.version
  }

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を設定するブロックです。
  timeouts {

    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: Goの time.Duration 形式の文字列（例: "5m", "1h"）
    # 省略時: デフォルトタイムアウト
    create = "5m"

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウト時間を指定します。
    # 設定可能な値: Goの time.Duration 形式の文字列（例: "5m", "1h"）
    # 省略時: デフォルトタイムアウト
    update = "5m"

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: Goの time.Duration 形式の文字列（例: "5m", "1h"）
    # 省略時: デフォルトタイムアウト
    delete = "5m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: ボットの Amazon Resource Name (ARN)
# - checksum: ボットのチェックサム（更新時の競合検出に使用）
# - created_date: ボットが作成された日時（ISO 8601形式）
# - failure_reason: ビルド失敗時の理由（status が FAILED の場合に設定）
# - id: ボットの名前（name 属性と同一）
# - last_updated_date: ボットが最後に更新された日時（ISO 8601形式）
# - status: ボットの現在のステータス
#           （BUILDING / READY / READY_BASIC_TESTING / FAILED / NOT_BUILT）
# - version: ボットの数値バージョン（$LATEST ではなく公開バージョン）
# - voice_id: Amazon Polly が使用する音声 ID（自動設定された場合も含む）
#---------------------------------------------------------------
