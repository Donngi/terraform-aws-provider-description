#---------------------------------------------------------------
# Amazon Lex Intent
#---------------------------------------------------------------
#
# Amazon Lex Intentリソースを作成します。
# Intentは、ユーザーが達成したい目標（例：花の注文、ホテルの予約など）を表します。
# 各Intentには、スロット（パラメータ）、確認プロンプト、フルフィルメントアクティビティなどが含まれます。
#
# AWS公式ドキュメント:
#   - Amazon Lex: How It Works: https://docs.aws.amazon.com/lex/latest/dg/how-it-works.html
#   - Intent structure: https://docs.aws.amazon.com/lexv2/latest/dg/intent-structure.html
#   - Setting Intent Context: https://docs.aws.amazon.com/lex/latest/dg/context-mgmt-active-context.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lex_intent
#
# Provider Version: 6.28.0
# Generated: 2026-01-28
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lex_intent" "example" {
  #---------------------------------------------------------------
  # Required Arguments
  #---------------------------------------------------------------

  # Intentの名前（大文字小文字を区別しない）
  # 100文字以内である必要があります
  name = "OrderFlowers"

  # Intentが正常にフルフィルされた後の動作を定義します
  # typeは"ReturnIntent"または"CodeHook"のいずれかを指定
  # - ReturnIntent: スロットデータをクライアントアプリケーションに返す
  # - CodeHook: Lambda関数を実行してIntentをフルフィルする
  fulfillment_activity {
    type = "ReturnIntent"

    # typeが"CodeHook"の場合に必須
    # Intentをフルフィルするために実行されるLambda関数の設定
    # code_hook {
    #   # Lambda関数の呼び出しに使用するリクエスト-レスポンスのバージョン
    #   # 5文字以内である必要があります
    #   # 詳細: https://docs.aws.amazon.com/lex/latest/dg/using-lambda.html
    #   message_version = "1.0"
    #
    #   # Lambda関数のARN
    #   uri = "arn:aws:lambda:us-east-1:123456789012:function:my-function"
    # }
  }

  #---------------------------------------------------------------
  # Optional Arguments
  #---------------------------------------------------------------

  # Intentの説明
  # 200文字以内である必要があります
  description = "Intent to order a bouquet of flowers for pick up"

  # 新しいバージョンを作成するかどうかを決定します
  # trueの場合、初回作成時と更新時に新しいバージョンが作成されます
  # デフォルト: false
  create_version = false

  # 組み込みIntentの署名（シグネチャ）
  # このIntentをベースにする組み込みIntentの一意の識別子
  # Alexaスキルキットの標準組み込みIntentを参照:
  # https://developer.amazon.com/public/solutions/alexa/alexa-skills-kit/docs/built-in-intent-ref/standard-intents
  # parent_intent_signature = "AMAZON.HelpIntent"

  # ユーザーがIntentを示すために使用する可能性のある発話の配列
  # 例: "I want {PizzaSize} pizza", "Order {Quantity} {PizzaSize} pizzas"
  # 各発話内で、スロット名は中括弧で囲みます
  # 1〜10個のアイテムが必要で、各アイテムは200文字以内である必要があります
  sample_utterances = [
    "I would like to order some flowers",
    "I would like to pick up flowers",
  ]

  # リソースが管理されるリージョン
  # デフォルトはプロバイダー設定のリージョン
  # 詳細: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  #---------------------------------------------------------------
  # Confirmation and Rejection
  #---------------------------------------------------------------

  # ユーザーにIntentを確認するように促すプロンプト
  # このプロンプトにはyes/noの回答が必要です
  # rejection_statementと両方を指定するか、どちらも指定しないかのいずれかです
  confirmation_prompt {
    # ユーザーに情報を求めるプロンプトの試行回数
    # 1〜5の範囲内である必要があります
    max_attempts = 2

    # プロンプトメッセージのセット（1〜15個のメッセージが必要）
    # プレーンテキストまたはSSML（Speech Synthesis Markup Language）で指定可能
    message {
      # メッセージのテキスト（1000文字以内）
      content = "Okay, your {FlowerType} will be ready for pickup by {PickupTime} on {PickupDate}. Does this sound okay?"

      # メッセージのコンテンツタイプ（PlainTextまたはSSML）
      content_type = "PlainText"

      # メッセージが属するメッセージグループの識別子（オプション）
      # グループが割り当てられると、Amazon Lexは各グループから1つのメッセージを返します
      # 1〜5の範囲内である必要があります
      # group_number = 1
    }

    # レスポンスカード（オプション）
    # Amazon Lexはセッション属性とスロット値をレスポンスカードに置き換えます
    # 詳細: https://docs.aws.amazon.com/lex/latest/dg/ex-resp-card.html
    # 50000文字以内である必要があります
    # response_card = "string"
  }

  # ユーザーがconfirmation_promptで定義された質問に「no」と答えた場合のステートメント
  # Intentがキャンセルされたことを確認するために応答します
  # confirmation_promptと両方を指定するか、どちらも指定しないかのいずれかです
  rejection_statement {
    # ステートメントメッセージのセット（1〜15個のメッセージが必要）
    message {
      content      = "Okay, I will not place your order."
      content_type = "PlainText"
      # group_number = 1
    }

    # レスポンスカード（オプション）
    # response_card = "string"
  }

  #---------------------------------------------------------------
  # Conclusion Statement
  #---------------------------------------------------------------

  # Lambda関数によってIntentが正常にフルフィルされた後にユーザーに伝えるステートメント
  # fulfillment_activityでLambda関数を指定した場合にのみ関連します
  # Intentをクライアントアプリケーションに返す場合、この要素は指定できません
  # follow_up_promptとは相互排他的です（どちらか一方のみを指定）
  # conclusion_statement {
  #   message {
  #     content      = "Your order has been placed."
  #     content_type = "PlainText"
  #     # group_number = 1
  #   }
  #
  #   # response_card = "string"
  # }

  #---------------------------------------------------------------
  # Follow-up Prompt
  #---------------------------------------------------------------

  # Intentをフルフィルした後に追加のアクティビティを促すためのプロンプト
  # 例: OrderPizza Intentがフルフィルされた後、飲み物を注文するように促す
  # conclusion_statementとは相互排他的です（どちらか一方のみを指定）
  # follow_up_prompt {
  #   # 情報を求めるプロンプト
  #   prompt {
  #     max_attempts = 2
  #
  #     message {
  #       content      = "Would you like to order a drink with that?"
  #       content_type = "PlainText"
  #       # group_number = 1
  #     }
  #
  #     # response_card = "string"
  #   }
  #
  #   # プロンプトフィールドで定義された質問に対してユーザーが「no」と答えた場合のステートメント
  #   rejection_statement {
  #     message {
  #       content      = "Okay, no problem."
  #       content_type = "PlainText"
  #       # group_number = 1
  #     }
  #
  #     # response_card = "string"
  #   }
  # }

  #---------------------------------------------------------------
  # Dialog Code Hook
  #---------------------------------------------------------------

  # 各ユーザー入力に対して呼び出すLambda関数を指定します
  # このLambda関数を呼び出してユーザーインタラクションをパーソナライズできます
  # dialog_code_hook {
  #   # Lambda関数の呼び出しに使用するリクエスト-レスポンスのバージョン
  #   # 5文字以内である必要があります
  #   message_version = "1.0"
  #
  #   # Lambda関数のARN
  #   uri = "arn:aws:lambda:us-east-1:123456789012:function:my-dialog-function"
  # }

  #---------------------------------------------------------------
  # Slots
  #---------------------------------------------------------------

  # Intentスロットのリスト
  # 実行時に、Amazon Lexはスロットで定義されたプロンプトを使用して
  # 必要なスロット値をユーザーから引き出します
  # 最大100個のスロットを定義可能

  # スロット1: 花の種類
  slot {
    # スロットの名前（大文字小文字を区別、100文字以内）
    name = "FlowerType"

    # スロットが必須かオプションかを指定
    # 有効な値: "Required" または "Optional"
    slot_constraint = "Required"

    # スロットのタイプ
    # カスタムスロットタイプまたは組み込みスロットタイプのいずれか
    # 100文字以内である必要があります
    slot_type = "FlowerTypes"

    # スロットタイプのバージョン（64文字以内）
    # $$LATESTを指定すると最新バージョンを使用
    slot_type_version = "$$LATEST"

    # スロットの説明（200文字以内）
    description = "The type of flowers to pick up"

    # Amazon Lexがこのスロット値をユーザーから引き出す順序を指定
    # 例: 優先度1と2の2つのスロットがある場合、まず優先度1のスロットから値を引き出します
    # 同じ優先度の複数のスロットがある場合、順序は任意です
    # 1〜100の範囲内である必要があります
    priority = 1

    # ユーザーがAmazon Lexのスロット値要求に応答する可能性のある特定のパターンがわかっている場合の発話
    # 精度を向上させるためにこれらの発話を提供できます（オプション）
    # ほとんどの場合、Amazon Lexはユーザーの発話を理解できます
    # 1〜10個のアイテム、各アイテムは200文字以内
    sample_utterances = [
      "I would like to order {FlowerType}",
    ]

    # Amazon Lexがユーザーからスロット値を引き出すために使用するプロンプト
    value_elicitation_prompt {
      max_attempts = 2

      message {
        content      = "What type of flowers would you like to order?"
        content_type = "PlainText"
        # group_number = 1
      }

      # response_card = "string"
    }

    # レスポンスカード（オプション、50000文字以内）
    # response_card = "string"
  }

  # スロット2: ピックアップ日
  slot {
    name              = "PickupDate"
    slot_constraint   = "Required"
    slot_type         = "AMAZON.DATE"
    slot_type_version = "$$LATEST"
    description       = "The date to pick up the flowers"
    priority          = 2

    sample_utterances = [
      "I would like to pick up on {PickupDate}",
    ]

    value_elicitation_prompt {
      max_attempts = 2

      message {
        content      = "What day do you want the {FlowerType} to be picked up?"
        content_type = "PlainText"
      }
    }
  }

  # スロット3: ピックアップ時刻
  slot {
    name              = "PickupTime"
    slot_constraint   = "Required"
    slot_type         = "AMAZON.TIME"
    slot_type_version = "$$LATEST"
    description       = "The time to pick up the flowers"
    priority          = 3

    sample_utterances = [
      "I would like to pick up at {PickupTime}",
    ]

    value_elicitation_prompt {
      max_attempts = 2

      message {
        content      = "Pick up the {FlowerType} at what time on {PickupDate}?"
        content_type = "PlainText"
      }
    }
  }

  #---------------------------------------------------------------
  # Timeouts
  #---------------------------------------------------------------

  # リソース操作のタイムアウト設定
  # timeouts {
  #   # 作成操作のタイムアウト（デフォルト: 1m）
  #   create = "5m"
  #
  #   # 更新操作のタイムアウト（デフォルト: 1m）
  #   update = "5m"
  #
  #   # 削除操作のタイムアウト（デフォルト: 5m）
  #   delete = "5m"
  # }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
#
# このリソースは以下の属性をエクスポートします（computed only）:
#
# - arn: Lex IntentのARN
# - checksum: 作成されたIntentのバージョンを識別するチェックサム
#   チェックサムはリソースが自動的に追加するため、引数として含まれません
# - created_date: Intentバージョンが作成された日時
# - last_updated_date: この Intentの$LATESTバージョンが最後に更新された日時
# - version: Intentのバージョン
#
#---------------------------------------------------------------
