#---------------------------------------------------------------
# AWS Lex Intent
#---------------------------------------------------------------
#
# Amazon Lex V1 のインテントをプロビジョニングするリソースです。
# インテントは、ユーザーが何を達成しようとしているかを表すものであり、
# Amazon Lex ボットの会話フローの基本単位となります。
# インテントにはスロット（必要な情報）、確認プロンプト、履行アクティビティ
# などを定義し、自然言語対話を構成します。
#
# 主なユースケース:
#   - チャットボットの注文・予約などのアクション定義
#   - カスタマーサポートの問い合わせ分類
#   - Lambda 関数と連携した会話型インターフェース構築
#   - 複数スロットによる情報収集フローの設計
#
# 重要な注意事項:
#   - このリソースは Amazon Lex V1 用です。V2 は aws_lexv2models_* リソースを使用します。
#   - confirmation_prompt を指定する場合は rejection_statement も必須です。
#   - follow_up_prompt を使用する場合は conclusion_statement と同時使用できません。
#   - fulfillment_activity は必須ブロックです（type: ReturnIntent または CodeHook）。
#
# AWS公式ドキュメント:
#   - Lex インテント概要: https://docs.aws.amazon.com/lex/latest/dg/built-in-intent-help.html
#   - インテント定義: https://docs.aws.amazon.com/lex/latest/dg/API_PutIntent.html
#   - スロットタイプ: https://docs.aws.amazon.com/lex/latest/dg/howitworks-manage-prompts.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/lex_intent
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lex_intent" "example" {
  #---------------------------------------------------------------
  # 基本設定
  #---------------------------------------------------------------

  # name (Required)
  # 設定内容: インテントの名前を指定します。
  # 設定可能な値: 英数字とアンダースコアのみ使用可能。1〜100文字
  # 省略時: 省略不可
  name = "example_intent"

  # description (Optional)
  # 設定内容: インテントの説明文を指定します。
  # 設定可能な値: 最大200文字の文字列
  # 省略時: 説明なし
  description = "Example Lex intent"

  # parent_intent_signature (Optional)
  # 設定内容: このインテントが継承する組み込みインテントの識別子を指定します。
  # 設定可能な値: Amazon Lex 組み込みインテントの識別子文字列
  #               例: "AMAZON.HelpIntent", "AMAZON.CancelIntent", "AMAZON.StopIntent"
  # 省略時: 組み込みインテントを継承しない（カスタムインテント）
  parent_intent_signature = null

  # sample_utterances (Optional)
  # 設定内容: ユーザーがこのインテントを起動するために使用するサンプル発話のセットを指定します。
  # 設定可能な値: 文字列のセット。最大1,500文字/発話、最大1500個
  # 省略時: サンプル発話なし
  #
  # 用途: Lex が自然言語理解モデルをトレーニングするための発話例を提供します。
  #   多様な表現を含めることで認識精度が向上します。
  sample_utterances = [
    "I would like to order a pizza",
    "Order pizza",
    "I want a pizza",
  ]

  # create_version (Optional)
  # 設定内容: インテントの新しいバージョンを作成するかどうかを指定します。
  # 設定可能な値: true / false
  # 省略時: false（$LATEST バージョンのみ使用）
  #
  # 用途: true に設定すると変更時に番号付きバージョンが作成され、
  #   ボットのエイリアスでバージョン管理が可能になります。
  create_version = false

  # region (Optional)
  # 設定内容: このリソースを管理する AWS リージョンを指定します。
  # 設定可能な値: AWS リージョンコード文字列（例: "us-east-1", "ap-northeast-1"）
  # 省略時: プロバイダー設定で指定されたリージョンを使用
  region = null

  #---------------------------------------------------------------
  # 会話終了メッセージ設定
  #---------------------------------------------------------------

  # conclusion_statement ブロック (Optional)
  # 設定内容: インテントが正常に履行された後にユーザーへ送信するステートメントを指定します。
  # 設定可能な値: message ブロック（1〜15個）と response_card を持つブロック
  # 省略時: 履行後のステートメントなし
  #
  # 注意: follow_up_prompt ブロックと同時に使用できません。
  conclusion_statement {
    # response_card (Optional)
    # 設定内容: ユーザーに表示するレスポンスカードを JSON 形式で指定します。
    # 設定可能な値: JSON文字列（最大50,000文字）
    # 省略時: レスポンスカードなし
    response_card = null

    # message ブロック (Required, 1〜15個)
    # 設定内容: ステートメントで送信するメッセージを指定します。
    message {
      # content (Required)
      # 設定内容: メッセージの内容を指定します。
      # 設定可能な値: PlainText/SSML は最大1,000文字、CustomPayload は最大最大5,000文字
      content = "Your order has been placed."

      # content_type (Required)
      # 設定内容: メッセージのコンテンツタイプを指定します。
      # 設定可能な値: "PlainText" / "SSML" / "CustomPayload"
      content_type = "PlainText"

      # group_number (Optional)
      # 設定内容: メッセージグループ番号を指定します。同一グループのメッセージからランダムに1つ選択されます。
      # 設定可能な値: 1〜5 の整数
      # 省略時: グループなし
      group_number = null
    }
  }

  #---------------------------------------------------------------
  # 確認プロンプト設定
  #---------------------------------------------------------------

  # confirmation_prompt ブロック (Optional)
  # 設定内容: インテントを履行する前にユーザーへ送信する確認プロンプトを指定します。
  # 設定可能な値: message ブロック（1〜15個）、max_attempts、response_card を持つブロック
  # 省略時: 確認プロンプトなし
  #
  # 注意: このブロックを指定する場合、rejection_statement も必須になります。
  confirmation_prompt {
    # max_attempts (Required)
    # 設定内容: 確認の取得を試みる最大回数を指定します。
    # 設定可能な値: 1〜5 の整数
    max_attempts = 2

    # response_card (Optional)
    # 設定内容: ユーザーに表示するレスポンスカードを JSON 形式で指定します。
    # 設定可能な値: JSON文字列（最大50,000文字）
    # 省略時: レスポンスカードなし
    response_card = null

    message {
      content      = "Are you sure you want to order a pizza?"
      content_type = "PlainText"
      group_number = null
    }
  }

  #---------------------------------------------------------------
  # 拒否ステートメント設定
  #---------------------------------------------------------------

  # rejection_statement ブロック (Optional)
  # 設定内容: ユーザーがインテントの確認を拒否した場合に送信するステートメントを指定します。
  # 設定可能な値: message ブロック（1〜15個）と response_card を持つブロック
  # 省略時: 拒否ステートメントなし
  #
  # 注意: confirmation_prompt を指定する場合は必須です。
  rejection_statement {
    # response_card (Optional)
    # 設定内容: ユーザーに表示するレスポンスカードを JSON 形式で指定します。
    # 設定可能な値: JSON文字列（最大50,000文字）
    # 省略時: レスポンスカードなし
    response_card = null

    message {
      content      = "Okay, I have cancelled your order."
      content_type = "PlainText"
      group_number = null
    }
  }

  #---------------------------------------------------------------
  # ダイアログコードフック設定
  #---------------------------------------------------------------

  # dialog_code_hook ブロック (Optional)
  # 設定内容: 各ユーザーインタラクションの後に呼び出す Lambda 関数を指定します。
  # 設定可能な値: message_version と uri を持つブロック（最大1個）
  # 省略時: ダイアログコードフックなし
  #
  # 用途: スロット値の検証、動的プロンプトのカスタマイズ、会話フローの動的制御に使用します。
  dialog_code_hook {
    # message_version (Required)
    # 設定内容: Lambda 関数に送信するメッセージのバージョンを指定します。
    # 設定可能な値: "1.0"
    message_version = "1.0"

    # uri (Required)
    # 設定内容: Lambda 関数の ARN を指定します。
    # 設定可能な値: Lambda 関数の ARN 文字列
    uri = "arn:aws:lambda:us-east-1:123456789012:function:example-dialog-hook"
  }

  #---------------------------------------------------------------
  # フォローアッププロンプト設定
  #---------------------------------------------------------------

  # follow_up_prompt ブロック (Optional)
  # 設定内容: インテント完了後にユーザーへ送信するフォローアッププロンプトを指定します。
  # 設定可能な値: prompt ブロックと rejection_statement ブロックを持つブロック（最大1個）
  # 省略時: フォローアッププロンプトなし
  #
  # 注意: conclusion_statement ブロックと同時に使用できません。
  #
  # follow_up_prompt {
  #   prompt {
  #     max_attempts = 2
  #     response_card = null
  #     message {
  #       content      = "Would you like to order anything else?"
  #       content_type = "PlainText"
  #       group_number = null
  #     }
  #   }
  #   rejection_statement {
  #     response_card = null
  #     message {
  #       content      = "Thank you. Goodbye!"
  #       content_type = "PlainText"
  #       group_number = null
  #     }
  #   }
  # }

  #---------------------------------------------------------------
  # 履行アクティビティ設定
  #---------------------------------------------------------------

  # fulfillment_activity ブロック (Required)
  # 設定内容: インテントを履行する方法を指定します。
  # 設定可能な値: type と省略可能な code_hook ブロックを持つブロック（必須、1個）
  fulfillment_activity {
    # type (Required)
    # 設定内容: 履行アクティビティのタイプを指定します。
    # 設定可能な値:
    #   - "ReturnIntent": スロット値をクライアントアプリケーションに返す（クライアント側で処理）
    #   - "CodeHook": Lambda 関数を呼び出して履行する
    type = "ReturnIntent"

    # code_hook ブロック (Optional)
    # 設定内容: 履行に使用する Lambda 関数を指定します。
    # 設定可能な値: message_version と uri を持つブロック（最大1個）
    # 省略時: type が "ReturnIntent" の場合は不要
    #
    # 注意: type が "CodeHook" の場合は必須です。
    #
    # code_hook {
    #   message_version = "1.0"
    #   uri = "arn:aws:lambda:us-east-1:123456789012:function:example-fulfillment"
    # }
  }

  #---------------------------------------------------------------
  # スロット設定
  #---------------------------------------------------------------

  # slot ブロック (Optional)
  # 設定内容: インテントが必要とする情報（スロット）を指定します。
  # 設定可能な値: 各種属性と value_elicitation_prompt ブロックを持つブロック（最大100個）
  # 省略時: スロットなし
  slot {
    # name (Required)
    # 設定内容: スロットの名前を指定します。
    # 設定可能な値: 英数字とアンダースコア。1〜100文字
    name = "PizzaSize"

    # description (Optional)
    # 設定内容: スロットの説明文を指定します。
    # 設定可能な値: 最大200文字の文字列
    # 省略時: 説明なし
    description = "The size of the pizza"

    # slot_type (Required)
    # 設定内容: スロットに格納するデータのタイプを指定します。
    # 設定可能な値: Amazon Lex 組み込みスロットタイプ名（例: "AMAZON.AlphaNumeric"）
    #               またはカスタムスロットタイプ名
    slot_type = "AMAZON.AlphaNumeric"

    # slot_type_version (Optional)
    # 設定内容: スロットタイプのバージョンを指定します。
    # 設定可能な値: バージョン文字列（例: "$LATEST", "1"）
    # 省略時: $LATEST バージョンを使用
    slot_type_version = "$LATEST"

    # slot_constraint (Required)
    # 設定内容: このスロットが必須かどうかを指定します。
    # 設定可能な値: "Required" / "Optional"
    slot_constraint = "Required"

    # priority (Optional)
    # 設定内容: スロットを埋める優先順位を指定します。低い数値ほど先に埋められます。
    # 設定可能な値: 0〜100 の整数
    # 省略時: 優先順位なし（任意の順序）
    priority = 1

    # sample_utterances (Optional)
    # 設定内容: ユーザーがこのスロットの値を提供するためのサンプル発話リストを指定します。
    # 設定可能な値: 文字列のリスト（最大10個）。{スロット名} プレースホルダーを使用可能
    # 省略時: サンプル発話なし
    sample_utterances = [
      "I would like a {PizzaSize} pizza",
    ]

    # response_card (Optional)
    # 設定内容: スロット値の入力時にユーザーに表示するレスポンスカードを JSON 形式で指定します。
    # 設定可能な値: JSON文字列（最大50,000文字）
    # 省略時: レスポンスカードなし
    response_card = null

    # value_elicitation_prompt ブロック (Optional)
    # 設定内容: スロット値が未入力の場合にユーザーへ送信するプロンプトを指定します。
    # 設定可能な値: message ブロック（1〜15個）、max_attempts、response_card を持つブロック
    # 省略時: プロンプトなし（slot_constraint が Required の場合は必須）
    value_elicitation_prompt {
      # max_attempts (Required)
      # 設定内容: スロット値の取得を試みる最大回数を指定します。
      # 設定可能な値: 1〜5 の整数
      max_attempts = 2

      # response_card (Optional)
      # 設定内容: ユーザーに表示するレスポンスカードを JSON 形式で指定します。
      # 設定可能な値: JSON文字列（最大50,000文字）
      # 省略時: レスポンスカードなし
      response_card = null

      message {
        content      = "What size pizza would you like? Small, medium, or large?"
        content_type = "PlainText"
        group_number = null
      }
    }
  }

  #---------------------------------------------------------------
  # タイムアウト設定
  #---------------------------------------------------------------

  # timeouts ブロック (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定します。
  # 省略時: Terraform デフォルトのタイムアウト値を使用
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成操作のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "5m", "1h" などの時間文字列
    # 省略時: プロバイダーのデフォルト値
    create = null

    # update (Optional)
    # 設定内容: リソース更新操作のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "5m", "1h" などの時間文字列
    # 省略時: プロバイダーのデフォルト値
    update = null

    # delete (Optional)
    # 設定内容: リソース削除操作のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "5m", "1h" などの時間文字列
    # 省略時: プロバイダーのデフォルト値
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn
#     インテントの ARN
#
# - checksum
#     インテントのチェックサム（更新時の競合検出に使用）
#
# - created_date
#     インテントが作成された日時（ISO 8601形式）
#
# - last_updated_date
#     インテントが最後に更新された日時（ISO 8601形式）
#
# - version
#     作成されたインテントのバージョン（create_version=true 時に付与）
#
