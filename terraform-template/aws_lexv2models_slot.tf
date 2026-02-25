#---------------------------------------------------------------
# Amazon Lex V2 スロット
#---------------------------------------------------------------
#
# Amazon Lex V2 ボットのインテントに対してスロットをプロビジョニングします。
# スロットはインテントを実行するために必要な情報をユーザーから収集する
# コンポーネントです。例えば、フライト予約ボットでは出発地・目的地・
# 搭乗日などがスロットに相当します。
# 各スロットにはスロットタイプ（組み込み型またはカスタム型）を関連付けて、
# 入力値の検証と正規化を行います。
#
# AWS公式ドキュメント:
#   - Amazon Lex V2 スロット: https://docs.aws.amazon.com/lexv2/latest/dg/build-conv-flows-add-slot.html
#   - スロットタイプ: https://docs.aws.amazon.com/lexv2/latest/dg/build-conv-design.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lexv2models_slot
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lexv2models_slot" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # bot_id (Required)
  # 設定内容: スロットを作成するボットのIDを指定します。
  # 設定可能な値: 既存の aws_lexv2models_bot リソースの bot_id
  # 省略時: 省略不可
  bot_id = aws_lexv2models_bot.example.id

  # bot_version (Required)
  # 設定内容: スロットを作成するボットのバージョンを指定します。
  # 設定可能な値:
  #   - "DRAFT": ドラフト（開発中）バージョン
  #   - 特定バージョン番号（例: "1", "2"）
  # 省略時: 省略不可
  bot_version = "DRAFT"

  # intent_id (Required)
  # 設定内容: スロットを関連付けるインテントのIDを指定します。
  # 設定可能な値: 既存の aws_lexv2models_intent リソースの intent_id
  # 省略時: 省略不可
  intent_id = aws_lexv2models_intent.example.intent_id

  # locale_id (Required)
  # 設定内容: スロットを作成するロケールIDを指定します。
  # 設定可能な値:
  #   - "en_US": 英語（米国）
  #   - "en_GB": 英語（英国）
  #   - "de_DE": ドイツ語（ドイツ）
  #   - "es_ES": スペイン語（スペイン）
  #   - "es_US": スペイン語（米国）
  #   - "fr_FR": フランス語（フランス）
  #   - "fr_CA": フランス語（カナダ）
  #   - "it_IT": イタリア語（イタリア）
  #   - "ja_JP": 日本語（日本）
  #   - "ko_KR": 韓国語（韓国）
  #   - "pt_BR": ポルトガル語（ブラジル）
  #   - "pt_PT": ポルトガル語（ポルトガル）
  #   - "zh_CN": 中国語（中国）
  # 省略時: 省略不可
  locale_id = "ja_JP"

  # name (Required)
  # 設定内容: スロットの名前を指定します。
  # 設定可能な値: 英数字とアンダースコアのみ使用可能な文字列
  # 省略時: 省略不可
  name = "example_slot"

  # description (Optional)
  # 設定内容: スロットの説明を指定します。
  # 設定可能な値: 最大200文字の文字列
  # 省略時: 説明なし
  description = "Amazon Lex V2 スロットのサンプルテンプレートです。"

  # slot_type_id (Optional)
  # 設定内容: スロットに関連付けるスロットタイプのIDを指定します。
  # 設定可能な値:
  #   - 既存の aws_lexv2models_slot_type リソースの slot_type_id
  #   - 組み込みスロットタイプのARN（例: "AMAZON.AlphaNumeric", "AMAZON.Date"）
  # 省略時: Terraform が自動的に設定
  slot_type_id = aws_lexv2models_slot_type.example.slot_type_id

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # 値取得設定
  #-------------------------------------------------------------

  # value_elicitation_setting (Required)
  # 設定内容: スロットの値をユーザーから取得するための設定を行うブロックです。
  # 省略時: 省略不可
  value_elicitation_setting {

    # slot_constraint (Required)
    # 設定内容: スロットの制約タイプを指定します。
    # 設定可能な値:
    #   - "Required": スロットの値はインテント実行に必須
    #   - "Optional": スロットの値は任意
    # 省略時: 省略不可
    slot_constraint = "Required"

    #-----------------------------------------------------------
    # デフォルト値設定
    #-----------------------------------------------------------

    # default_value_specification (Optional)
    # 設定内容: スロットのデフォルト値リストを設定するブロックです。
    # 省略時: デフォルト値なし
    default_value_specification {

      # default_value_list (Required, 1件以上)
      # 設定内容: デフォルト値のリストを設定するブロックです。
      # Lex は順番に評価して最初に有効な値を使用します。
      default_value_list {

        # default_value (Required)
        # 設定内容: デフォルト値を指定します。セッション属性や
        #           コンテキスト属性を参照する場合は {SessionAttribute.xxx} 形式を使用します。
        # 設定可能な値: 最大202文字の文字列
        # 省略時: 省略不可
        default_value = "{Session.OrderDate}"
      }
    }

    #-----------------------------------------------------------
    # プロンプト設定
    #-----------------------------------------------------------

    # prompt_specification (Optional)
    # 設定内容: スロット値をユーザーに問い合わせるプロンプトを設定するブロックです。
    # 省略時: プロンプトなし
    prompt_specification {

      # max_retries (Required)
      # 設定内容: プロンプトの最大再試行回数を指定します。
      # 設定可能な値: 0〜5 の整数
      # 省略時: 省略不可
      max_retries = 2

      # allow_interrupt (Optional)
      # 設定内容: ユーザーがボットの発話中に割り込むことを許可するかを指定します。
      # 設定可能な値:
      #   - true: 割り込みを許可
      #   - false: 割り込みを許可しない
      # 省略時: Lex のデフォルト動作に従う
      allow_interrupt = true

      # message_selection_strategy (Optional)
      # 設定内容: 複数のメッセージグループがある場合のメッセージ選択方法を指定します。
      # 設定可能な値:
      #   - "Random": グループからランダムに選択
      #   - "Ordered": グループを順番に使用
      # 省略時: Random
      message_selection_strategy = "Ordered"

      # message_group (Required, 1件以上)
      # 設定内容: プロンプトメッセージのグループを設定するブロックです。
      message_group {

        # message (Required)
        # 設定内容: プロンプトのメッセージ内容を設定するブロックです。
        message {

          # plain_text_message (Optional)
          # 設定内容: プレーンテキスト形式のメッセージを設定するブロックです。
          plain_text_message {

            # value (Required)
            # 設定内容: メッセージのテキスト内容を指定します。
            # 設定可能な値: 最大1000文字の文字列
            # 省略時: 省略不可
            value = "ご注文の日時を教えてください。"
          }

          # ssml_message (Optional)
          # 設定内容: SSML 形式のメッセージを設定するブロックです。
          # ssml_message {
          #   # value (Required)
          #   # 設定内容: SSML 形式のメッセージ内容を指定します。
          #   # 設定可能な値: 有効な SSML マークアップ文字列（最大1000文字）
          #   # 省略時: 省略不可
          #   value = "<speak>ご注文の日時を教えてください。</speak>"
          # }

          # custom_payload (Optional)
          # 設定内容: カスタムペイロード形式のメッセージを設定するブロックです。
          # custom_payload {
          #   # value (Required)
          #   # 設定内容: カスタムペイロードの内容を指定します。
          #   # 設定可能な値: 最大1000文字の文字列
          #   # 省略時: 省略不可
          #   value = "{\"type\": \"date_picker\"}"
          # }

          # image_response_card (Optional)
          # 設定内容: 画像付きレスポンスカードを設定するブロックです。
          # image_response_card {
          #   # title (Required)
          #   # 設定内容: カードのタイトルを指定します。
          #   # 設定可能な値: 最大250文字の文字列
          #   # 省略時: 省略不可
          #   title = "日時を選択してください"

          #   # subtitle (Optional)
          #   # 設定内容: カードのサブタイトルを指定します。
          #   # 設定可能な値: 最大250文字の文字列
          #   # 省略時: サブタイトルなし
          #   subtitle = "ご希望の日時を選択してください"

          #   # image_url (Optional)
          #   # 設定内容: カードに表示する画像の URL を指定します。
          #   # 設定可能な値: 有効な HTTPS URL
          #   # 省略時: 画像なし
          #   image_url = "https://example.com/calendar.png"

          #   # button (Optional, 最大5件)
          #   # 設定内容: カードに表示するボタンを設定するブロックです。
          #   button {
          #     # text (Required)
          #     # 設定内容: ボタンに表示するテキストを指定します。
          #     # 設定可能な値: 最大50文字の文字列
          #     # 省略時: 省略不可
          #     text = "今日"

          #     # value (Required)
          #     # 設定内容: ボタンが選択された場合にスロットに設定される値を指定します。
          #     # 設定可能な値: 最大50文字の文字列
          #     # 省略時: 省略不可
          #     value = "today"
          #   }
          # }
        }

        # variation (Optional, 複数件)
        # 設定内容: メッセージのバリエーションを設定するブロックです。
        # variation {
        #   plain_text_message {
        #     value = "ご希望の日時はいつですか？"
        #   }
        # }
      }

      # prompt_attempts_specification (Optional)
      # 設定内容: プロンプト試行ごとの入力設定を行うブロックです（set形式）。
      # map_block_key で試行を識別します。
      # prompt_attempts_specification {
      #   # map_block_key (Required)
      #   # 設定内容: 試行の識別キーを指定します。
      #   # 設定可能な値:
      #   #   - "Initial": 最初のプロンプト試行
      #   #   - "Retry1" 〜 "Retry4": 再試行（Retry1 が1回目の再試行）
      #   # 省略時: 省略不可
      #   map_block_key = "Initial"

      #   # allow_interrupt (Optional)
      #   # 設定内容: この試行でのユーザー割り込みを許可するかを指定します。
      #   # 設定可能な値: true / false
      #   # 省略時: プロンプト全体の allow_interrupt 設定に従う
      #   allow_interrupt = true

      #   # allowed_input_types (Required)
      #   # 設定内容: 許可する入力タイプを設定するブロックです。
      #   allowed_input_types {
      #     # allow_audio_input (Required)
      #     # 設定内容: 音声入力を許可するかを指定します。
      #     # 設定可能な値: true / false
      #     # 省略時: 省略不可
      #     allow_audio_input = true

      #     # allow_dtmf_input (Required)
      #     # 設定内容: DTMF（プッシュトーン）入力を許可するかを指定します。
      #     # 設定可能な値: true / false
      #     # 省略時: 省略不可
      #     allow_dtmf_input = true
      #   }

      #   # audio_and_dtmf_input_specification (Optional)
      #   # 設定内容: 音声・DTMF入力の詳細設定を行うブロックです。
      #   audio_and_dtmf_input_specification {
      #     # start_timeout_ms (Required)
      #     # 設定内容: 入力開始までのタイムアウト時間（ミリ秒）を指定します。
      #     # 設定可能な値: 1 以上の整数
      #     # 省略時: 省略不可
      #     start_timeout_ms = 4000

      #     # audio_specification (Optional)
      #     # 設定内容: 音声入力の詳細設定を行うブロックです。
      #     audio_specification {
      #       # end_timeout_ms (Required)
      #       # 設定内容: 音声終了検出のタイムアウト時間（ミリ秒）を指定します。
      #       # 設定可能な値: 1 以上の整数
      #       # 省略時: 省略不可
      #       end_timeout_ms = 640

      #       # max_length_ms (Required)
      #       # 設定内容: 最大音声入力時間（ミリ秒）を指定します。
      #       # 設定可能な値: 1 以上の整数
      #       # 省略時: 省略不可
      #       max_length_ms = 15000
      #     }

      #     # dtmf_specification (Optional)
      #     # 設定内容: DTMF入力の詳細設定を行うブロックです。
      #     dtmf_specification {
      #       # deletion_character (Required)
      #       # 設定内容: DTMF 入力の削除文字を指定します。
      #       # 設定可能な値: 0〜9, *, # のいずれか
      #       # 省略時: 省略不可
      #       deletion_character = "*"

      #       # end_character (Required)
      #       # 設定内容: DTMF 入力の終了文字を指定します。
      #       # 設定可能な値: 0〜9, *, # のいずれか
      #       # 省略時: 省略不可
      #       end_character = "#"

      #       # end_timeout_ms (Required)
      #       # 設定内容: DTMF 入力終了のタイムアウト時間（ミリ秒）を指定します。
      #       # 設定可能な値: 1 以上の整数
      #       # 省略時: 省略不可
      #       end_timeout_ms = 5000

      #       # max_length (Required)
      #       # 設定内容: DTMF 入力の最大文字数を指定します。
      #       # 設定可能な値: 1〜1024 の整数
      #       # 省略時: 省略不可
      #       max_length = 513
      #     }
      #   }

      #   # text_input_specification (Optional)
      #   # 設定内容: テキスト入力の詳細設定を行うブロックです。
      #   text_input_specification {
      #     # start_timeout_ms (Required)
      #     # 設定内容: テキスト入力開始までのタイムアウト時間（ミリ秒）を指定します。
      #     # 設定可能な値: 1 以上の整数
      #     # 省略時: 省略不可
      #     start_timeout_ms = 30000
      #   }
      # }
    }

    #-----------------------------------------------------------
    # サンプル発話設定
    #-----------------------------------------------------------

    # sample_utterance (Optional, 複数件)
    # 設定内容: スロット値取得を開始するトリガーとなるサンプル発話を設定するブロックです。
    # 省略時: サンプル発話なし
    sample_utterance {

      # utterance (Required)
      # 設定内容: サンプル発話のテキストを指定します。
      # 設定可能な値: 最大10000文字の文字列（{スロット名} 形式でスロット参照可能）
      # 省略時: 省略不可
      utterance = "{example_slot} でお願いします"
    }

    #-----------------------------------------------------------
    # スロット解決設定
    #-----------------------------------------------------------

    # slot_resolution_setting (Optional)
    # 設定内容: スロット値の解決方法を設定するブロックです。
    # 省略時: デフォルトの解決方法を使用
    slot_resolution_setting {

      # slot_resolution_strategy (Required)
      # 設定内容: スロット値の解決戦略を指定します。
      # 設定可能な値:
      #   - "Default": Lex のデフォルト解決方法を使用
      #   - "EnhancedFallback": 拡張フォールバック解決を使用
      # 省略時: 省略不可
      slot_resolution_strategy = "Default"
    }

    #-----------------------------------------------------------
    # 待機と継続設定
    #-----------------------------------------------------------

    # wait_and_continue_specification (Optional)
    # 設定内容: スロット値の処理中に表示する待機メッセージと継続メッセージを
    #           設定するブロックです。
    # 省略時: 待機・継続メッセージなし
    wait_and_continue_specification {

      # active (Optional)
      # 設定内容: 待機と継続の機能を有効にするかを指定します。
      # 設定可能な値: true / false
      # 省略時: false
      active = true

      # continue_response (Required)
      # 設定内容: 待機後に処理を継続する際のメッセージを設定するブロックです。
      continue_response {

        # allow_interrupt (Optional)
        # 設定内容: ユーザーがボットの発話中に割り込むことを許可するかを指定します。
        # 設定可能な値: true / false
        # 省略時: Lex のデフォルト動作に従う
        allow_interrupt = true

        # message_group (Required, 1件以上)
        # 設定内容: 継続メッセージのグループを設定するブロックです。
        message_group {
          message {
            plain_text_message {
              value = "処理を続けます。少しお待ちください。"
            }
          }
        }
      }

      # waiting_response (Required)
      # 設定内容: 処理の待機中にユーザーに返すメッセージを設定するブロックです。
      waiting_response {

        # allow_interrupt (Optional)
        # 設定内容: ユーザーがボットの発話中に割り込むことを許可するかを指定します。
        # 設定可能な値: true / false
        # 省略時: Lex のデフォルト動作に従う
        allow_interrupt = true

        # message_group (Required, 1件以上)
        # 設定内容: 待機中メッセージのグループを設定するブロックです。
        message_group {
          message {
            plain_text_message {
              value = "ただいま処理中です。しばらくお待ちください。"
            }
          }
        }
      }

      # still_waiting_response (Optional)
      # 設定内容: まだ処理中であることをユーザーに定期的に通知する
      #           メッセージを設定するブロックです。
      still_waiting_response {

        # frequency_in_seconds (Required)
        # 設定内容: still_waiting メッセージを送信する間隔（秒）を指定します。
        # 設定可能な値: 1〜300 の整数
        # 省略時: 省略不可
        frequency_in_seconds = 20

        # timeout_in_seconds (Required)
        # 設定内容: still_waiting メッセージを送信し続ける最大時間（秒）を指定します。
        # 設定可能な値: 1〜900 の整数
        # 省略時: 省略不可
        timeout_in_seconds = 200

        # allow_interrupt (Optional)
        # 設定内容: ユーザーがボットの発話中に割り込むことを許可するかを指定します。
        # 設定可能な値: true / false
        # 省略時: Lex のデフォルト動作に従う
        allow_interrupt = true

        # message_group (Required, 1件以上)
        # 設定内容: 待機継続メッセージのグループを設定するブロックです。
        message_group {
          message {
            plain_text_message {
              value = "もうしばらくお待ちください。"
            }
          }
        }
      }
    }
  }

  #-------------------------------------------------------------
  # 複数値設定
  #-------------------------------------------------------------

  # multiple_values_setting (Optional)
  # 設定内容: スロットが複数の値を受け付けるかどうかの設定を行うブロックです。
  # 省略時: 複数値を受け付けない
  multiple_values_setting {

    # allow_multiple_values (Optional)
    # 設定内容: スロットが複数の値を受け付けるかを指定します。
    # 設定可能な値:
    #   - true: 複数の値を受け付ける
    #   - false: 単一の値のみ受け付ける
    # 省略時: false
    allow_multiple_values = false
  }

  #-------------------------------------------------------------
  # 難読化設定
  #-------------------------------------------------------------

  # obfuscation_setting (Optional)
  # 設定内容: スロット値の難読化（マスキング）設定を行うブロックです。
  # 機密情報（クレジットカード番号など）を保護する場合に使用します。
  # 省略時: 難読化なし
  obfuscation_setting {

    # obfuscation_setting_type (Required)
    # 設定内容: 難読化の種類を指定します。
    # 設定可能な値:
    #   - "None": 難読化しない（値をそのまま保存）
    #   - "DefaultObfuscation": デフォルトの難読化を適用（値をマスク）
    # 省略時: 省略不可
    obfuscation_setting_type = "None"
  }

  #-------------------------------------------------------------
  # サブスロット設定
  #-------------------------------------------------------------

  # sub_slot_setting (Optional)
  # 設定内容: 複合スロットのサブスロット設定を行うブロックです。
  # カスタムスロットタイプが複合型の場合に使用します。
  # 省略時: サブスロットなし
  sub_slot_setting {

    # expression (Optional)
    # 設定内容: サブスロットのマッピング式を指定します。
    # 設定可能な値: 有効なサブスロット式の文字列
    # 省略時: 式なし
    expression = null

    # slot_specification (Optional, set形式)
    # 設定内容: サブスロットの仕様を設定するブロックです。
    # slot_specification {
    #   # map_block_key (Required)
    #   # 設定内容: サブスロットの識別キーを指定します。
    #   # 設定可能な値: サブスロットの名前文字列
    #   # 省略時: 省略不可
    #   map_block_key = "departure_city"

    #   # slot_type_id (Required)
    #   # 設定内容: サブスロットのスロットタイプIDを指定します。
    #   # 設定可能な値: 有効なスロットタイプIDまたは組み込みスロットタイプのARN
    #   # 省略時: 省略不可
    #   slot_type_id = "AMAZON.City"

    #   # value_elicitation_setting (Required)
    #   # 設定内容: サブスロットの値取得設定を行うブロックです。
    #   value_elicitation_setting {

    #     # default_value_specification (Optional)
    #     default_value_specification {
    #       default_value_list {
    #         default_value = "{Session.DepartureCity}"
    #       }
    #     }

    #     # prompt_specification (Optional)
    #     prompt_specification {
    #       max_retries = 2
    #       allow_interrupt = true
    #       message_selection_strategy = "Ordered"
    #       message_group {
    #         message {
    #           plain_text_message {
    #             value = "出発地を教えてください。"
    #           }
    #         }
    #       }
    #     }

    #     # sample_utterance (Optional)
    #     sample_utterance {
    #       utterance = "{departure_city} から出発します"
    #     }

    #     # wait_and_continue_specification (Optional)
    #     wait_and_continue_specification {
    #       active = false
    #       continue_response {
    #         message_group {
    #           message {
    #             plain_text_message {
    #               value = "承知しました。"
    #             }
    #           }
    #         }
    #       }
    #       waiting_response {
    #         message_group {
    #           message {
    #             plain_text_message {
    #               value = "お待ちください。"
    #             }
    #           }
    #         }
    #       }
    #     }
    #   }
    # }
  }

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
# - id: スロットの識別子（bot_id, bot_version, locale_id, intent_id, slot_id をカンマ区切りで連結した値）
# - slot_id: スロットの固有識別子
# - region: リソースが管理されるリージョン
#---------------------------------------------------------------
