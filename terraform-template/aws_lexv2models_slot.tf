#---------------------------------------------------------------
# Amazon Lex V2 Models Slot
#---------------------------------------------------------------
#
# Amazon Lex V2のスロット（Slot）を定義するリソースです。
# スロットは、ユーザーのリクエストを満たすために必要な情報を示すパラメータです。
# 例えば、ピザ注文ボットでは「サイズ」「トッピング」「配達時間」などがスロットになります。
#
# AWS公式ドキュメント:
#   - Custom slot types: https://docs.aws.amazon.com/lexv2/latest/dg/custom-slot-types.html
#   - Slot Value Elicitation Setting API: https://docs.aws.amazon.com/lexv2/latest/APIReference/API_SlotValueElicitationSetting.html
#   - Using multiple values in a slot: https://docs.aws.amazon.com/lexv2/latest/dg/multi-valued-slots.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lexv2models_slot
#
# Provider Version: 6.28.0
# Generated: 2026-01-28
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lexv2models_slot" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # ボットID
  # スロットが関連付けられているボットの識別子
  bot_id = "your-bot-id"

  # ボットバージョン
  # スロットが関連付けられているボットのバージョン
  bot_version = "DRAFT"

  # インテントID
  # このスロットを含むインテントの識別子
  intent_id = "your-intent-id"

  # ロケールID
  # スロットが使用される言語とロケールの識別子
  # 例: "en_US", "ja_JP"
  locale_id = "en_US"

  # スロット名
  # スロットの名前（一意である必要があります）
  name = "example_slot"

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # 説明
  # スロットの説明（最大200文字）
  description = "An example slot for demonstration purposes"

  # リージョン
  # このリソースが管理されるAWSリージョン
  # 指定しない場合、プロバイダー設定のリージョンがデフォルトで使用されます
  # region = "us-east-1"

  # スロットタイプID
  # このスロットに関連付けられたスロットタイプの一意の識別子
  # AMAZON.Numberなどの組み込みスロットタイプ、またはカスタムスロットタイプのIDを指定
  # slot_type_id = "AMAZON.Number"

  #---------------------------------------------------------------
  # 複数値設定（Multiple Values Setting）
  #---------------------------------------------------------------
  # スロットが1つの応答で複数の値を返すかどうかを設定します。
  # 注意: 複数値スロットは英語（en-US）ロケールでのみサポートされています
  # 例: ピザのトッピングを複数選択する場合など

  # multiple_values_setting {
  #   # 複数値を許可するかどうか
  #   # true: スロットは複数の値を返すことができます
  #   # false: スロットは単一の値のみを返します
  #   allow_multiple_values = false
  # }

  #---------------------------------------------------------------
  # 難読化設定（Obfuscation Setting）
  #---------------------------------------------------------------
  # Amazon CloudWatchログでスロット値をどのように扱うかを決定します。
  # 機密情報（クレジットカード番号、個人情報など）を保護するために使用します。

  # obfuscation_setting {
  #   # 難読化設定タイプ（必須）
  #   # "DefaultObfuscation": Amazon Lexが会話ログでスロット値を難読化します
  #   # "None": スロット値を難読化しません
  #   obfuscation_setting_type = "None"
  # }

  #---------------------------------------------------------------
  # サブスロット設定（Sub Slot Setting）
  #---------------------------------------------------------------
  # 複合スロットの構成要素となるサブスロットの仕様を定義します。
  # 複合スロットは、複数のサブスロットを論理演算子（AND/OR）で組み合わせたものです。

  # sub_slot_setting {
  #   # 式（Expression）
  #   # 論理AND/OR演算子を使用して複合スロット内のサブスロットを定義する式
  #   # 例: "(sub_slot_1 AND sub_slot_2) OR sub_slot_3"
  #   expression = null
  #
  #   # スロット仕様（Slot Specification）
  #   # 複合スロットの構成要素となるサブスロットの仕様
  #   slot_specification {
  #     # スロットタイプID（必須）
  #     # サブスロットに割り当てられたスロットタイプの一意の識別子
  #     slot_type_id = "your-slot-type-id"
  #
  #     # 値引き出し設定（必須）
  #     # サブスロットの値引き出し設定の詳細
  #     value_elicitation_setting {
  #       # スロット制約（必須）
  #       # サブスロットが必須かオプションかを指定
  #       # "Required" または "Optional"
  #       slot_constraint = "Required"
  #
  #       # プロンプト仕様、デフォルト値、サンプル発話などを設定可能
  #       # （詳細は value_elicitation_setting ブロックを参照）
  #     }
  #   }
  # }

  #---------------------------------------------------------------
  # 値引き出し設定（Value Elicitation Setting）
  #---------------------------------------------------------------
  # Amazon Lexがスロットの値を引き出すためにユーザーに送信するプロンプトを定義します。
  # このブロックは必須です。

  value_elicitation_setting {
    # スロット制約（必須）
    # スロットが必須かオプションかを指定します
    # "Required": ユーザーはこのスロットの値を提供する必要があります
    # "Optional": スロットの値は任意です
    slot_constraint = "Required"

    #---------------------------------------------------------------
    # デフォルト値仕様（Default Value Specification）
    #---------------------------------------------------------------
    # Amazon Lexがスロットの値を決定できなかった場合に使用するデフォルト値のリストを定義します。

    # default_value_specification {
    #   # デフォルト値リスト（必須）
    #   # Amazon Lexは、リストに表示された順序でデフォルト値を選択します
    #   default_value_list {
    #     # デフォルト値（必須）
    #     # ユーザーがスロットの値を提供しない場合に使用するデフォルト値
    #     # セッション属性やコンテキスト変数を参照可能
    #     default_value = "default_value_here"
    #   }
    # }

    #---------------------------------------------------------------
    # プロンプト仕様（Prompt Specification）
    #---------------------------------------------------------------
    # Amazon Lexがユーザーからスロット値を引き出すために使用するプロンプトを定義します。
    # 注意: prompt_attempts_specification を設定しない場合、AWSはデフォルトで
    #       Initial, Retry1, Retry2 などのプロンプト試行仕様を提供しますが、
    #       これによりTerraformが差分を検出します。差分を避けるには明示的に設定してください。

    # prompt_specification {
    #   # 中断を許可するか（オプション）
    #   # ユーザーが音声応答を中断できるかどうか
    #   allow_interrupt = true
    #
    #   # 最大再試行回数（必須）
    #   # Amazon Lexがスロット値を引き出すために再試行する最大回数
    #   max_retries = 2
    #
    #   # メッセージ選択戦略
    #   # メッセージグループから使用するメッセージを選択する方法
    #   # "Random": ランダムに選択
    #   # "Ordered": 順番に選択
    #   message_selection_strategy = "Random"
    #
    #   # メッセージグループ（必須）
    #   # Amazon Lexがユーザーに送信できる応答の設定ブロック
    #   # Amazon Lexは実行時に実際に送信する応答を選択します
    #   message_group {
    #     # メッセージ（必須）
    #     # Amazon Lexがユーザーに送信する主要メッセージの設定
    #     message {
    #       # プレーンテキストメッセージ
    #       plain_text_message {
    #         value = "What is your preferred option?"
    #       }
    #
    #       # または カスタムペイロード
    #       # custom_payload {
    #       #   value = "{\"custom\": \"payload\"}"
    #       # }
    #
    #       # または 画像応答カード
    #       # image_response_card {
    #       #   title = "Choose an option"
    #       #   subtitle = "Please select one"
    #       #   image_url = "https://example.com/image.png"
    #       #
    #       #   button {
    #       #     text = "Option 1"
    #       #     value = "option1"
    #       #   }
    #       # }
    #
    #       # または SSML メッセージ
    #       # ssml_message {
    #       #   value = "<speak>What is your preferred option?</speak>"
    #       # }
    #     }
    #
    #     # バリエーション（オプション）
    #     # ユーザーに送信するメッセージのバリエーション
    #     # バリエーションが定義されている場合、Amazon Lexは主要メッセージまたは
    #     # バリエーションの1つを選択してユーザーに送信します
    #     # variation {
    #     #   plain_text_message {
    #     #     value = "Please choose your option"
    #     #   }
    #     # }
    #   }
    #
    #   # プロンプト試行仕様（オプションだが推奨）
    #   # 特定のプロンプト試行（初回、再試行1回目、2回目など）の設定
    #   # AWSがデフォルト設定を追加することによる差分を避けるため、明示的に設定することを推奨
    #   prompt_attempts_specification {
    #     # マップブロックキー（必須）
    #     # プロンプト試行のタイプ: "Initial", "Retry1", "Retry2", "Retry3", "Retry4"
    #     map_block_key = "Initial"
    #
    #     # 中断を許可するか
    #     allow_interrupt = true
    #
    #     # 許可される入力タイプ（必須）
    #     allowed_input_types {
    #       # 音声入力を許可するか
    #       allow_audio_input = true
    #
    #       # DTMF（タッチトーン）入力を許可するか
    #       allow_dtmf_input = true
    #     }
    #
    #     # 音声とDTMF入力の仕様（オプション）
    #     audio_and_dtmf_input_specification {
    #       # 開始タイムアウト（ミリ秒）
    #       # ユーザーが応答を開始するまでの待機時間
    #       start_timeout_ms = 4000
    #
    #       # 音声仕様
    #       audio_specification {
    #         # 終了タイムアウト（ミリ秒）
    #         # ユーザーが発話を終了するまでの無音時間
    #         end_timeout_ms = 640
    #
    #         # 最大長（ミリ秒）
    #         # 音声入力の最大長
    #         max_length_ms = 15000
    #       }
    #
    #       # DTMF仕様
    #       dtmf_specification {
    #         # 削除文字
    #         # 最後に入力された文字を削除するために使用される文字
    #         deletion_character = "*"
    #
    #         # 終了文字
    #         # 入力の終了を示す文字
    #         end_character = "#"
    #
    #         # 終了タイムアウト（ミリ秒）
    #         # 終了文字が押されるまでの待機時間
    #         end_timeout_ms = 5000
    #
    #         # 最大長
    #         # DTMF入力の最大文字数
    #         max_length = 513
    #       }
    #     }
    #
    #     # テキスト入力仕様（オプション）
    #     text_input_specification {
    #       # 開始タイムアウト（ミリ秒）
    #       # ユーザーがテキスト応答を開始するまでの待機時間
    #       start_timeout_ms = 30000
    #     }
    #   }
    # }

    #---------------------------------------------------------------
    # サンプル発話（Sample Utterances）
    #---------------------------------------------------------------
    # ユーザーがスロット値に対してどのように応答するかの特定のパターンを提供します。
    # これにより、Amazon Lexの機械学習モデルの精度が向上します。

    # sample_utterance {
    #   # 発話（必須）
    #   # Amazon Lexが機械学習モデルを構築するために使用するサンプル発話
    #   utterance = "I would like {SlotName}"
    # }

    #---------------------------------------------------------------
    # スロット解決設定（Slot Resolution Setting）
    #---------------------------------------------------------------
    # アシスト付きスロット解決がオンになっているかどうかを決定します。
    # アシスト付きスロット解決は、Amazon Lexがフォールバックインテントにデフォルト設定された場合に
    # スロット値の解決を支援する機能です。

    # slot_resolution_setting {
    #   # スロット解決戦略（必須）
    #   # アシスト付きスロット解決がオンかオフかを指定
    #   # "EnhancedFallback": Amazon LexがAMAZON.FallbackIntentにデフォルト設定された場合、
    #   #                     アシスト付きスロット解決が有効化されます
    #   # "Default": アシスト付きスロット解決はオフになります
    #   slot_resolution_strategy = "Default"
    # }

    #---------------------------------------------------------------
    # 待機と継続の仕様（Wait and Continue Specification）
    #---------------------------------------------------------------
    # ボットがユーザー入力を待機している間にAmazon Lexが使用するプロンプトを指定します。
    # 例: ユーザーがフォームに入力している間など

    # wait_and_continue_specification {
    #   # アクティブ（オプション）
    #   # ボットがユーザーの応答を待つかどうかを指定
    #   # false: 待機と継続の応答は使用されません
    #   # デフォルトはtrue
    #   active = true
    #
    #   # 継続応答（必須）
    #   # ボットが会話を続ける準備ができていることを示すためにAmazon Lexが送信する応答
    #   continue_response {
    #     # 中断を許可するか
    #     allow_interrupt = true
    #
    #     # メッセージグループ（必須）
    #     message_group {
    #       message {
    #         plain_text_message {
    #           value = "Ready to continue?"
    #         }
    #       }
    #     }
    #   }
    #
    #   # 待機応答（必須）
    #   # ボットが会話を続けるのを待っていることを示すためにAmazon Lexが送信する応答
    #   waiting_response {
    #     # 中断を許可するか
    #     allow_interrupt = true
    #
    #     # メッセージグループ（必須）
    #     message_group {
    #       message {
    #         plain_text_message {
    #           value = "Waiting for your input..."
    #         }
    #       }
    #     }
    #   }
    #
    #   # まだ待機中の応答（オプション）
    #   # Amazon Lexが定期的にユーザーに送信する応答で、ボットがまだユーザーからの入力を待っていることを示します
    #   still_waiting_response {
    #     # 頻度（秒）（必須）
    #     # メッセージをユーザーに送信する頻度
    #     frequency_in_seconds = 30
    #
    #     # タイムアウト（秒）（必須）
    #     # Amazon Lexがこの時間より長く応答を待った場合、メッセージの送信を停止します
    #     timeout_in_seconds = 120
    #
    #     # 中断を許可するか
    #     allow_interrupt = true
    #
    #     # メッセージグループ（必須）
    #     # 1つ以上のメッセージグループで、プロンプトを定義します
    #     message_group {
    #       message {
    #         plain_text_message {
    #           value = "Are you still there?"
    #         }
    #       }
    #     }
    #   }
    # }
  }

  #---------------------------------------------------------------
  # タイムアウト設定
  #---------------------------------------------------------------
  # Terraformの操作タイムアウトを設定します

  # timeouts {
  #   # 作成時のタイムアウト（デフォルト: 30m）
  #   create = "30m"
  #
  #   # 更新時のタイムアウト（デフォルト: 30m）
  #   update = "30m"
  #
  #   # 削除時のタイムアウト（デフォルト: 30m）
  #   delete = "30m"
  # }
}

#---------------------------------------------------------------
# Attributes Reference（参照専用属性）
#---------------------------------------------------------------
# 以下の属性はリソース作成後に参照可能ですが、設定することはできません。
#
# - id: ボットID、ボットバージョン、インテントID、ロケールID、スロットIDを
#       カンマ区切りで連結した文字列
#
# - slot_id: スロットに関連付けられた一意の識別子
#
# 使用例:
#   output "slot_id" {
#     value = aws_lexv2models_slot.example.slot_id
#   }
#---------------------------------------------------------------
