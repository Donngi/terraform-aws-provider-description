#---------------------------------------------------------------
# Amazon Lex V2 インテント
#---------------------------------------------------------------
#
# Amazon Lex V2 ボットのインテント（意図）を定義するリソースです。
# インテントは会話フローにおいてユーザーが達成しようとする目標を
# 表すコアコンポーネントです。サンプル発話、スロット、確認・終了
# 応答、コードフック連携などを組み合わせて会話体験を構築します。
#
# AWS公式ドキュメント:
#   - Amazon Lex V2 インテント: https://docs.aws.amazon.com/lexv2/latest/dg/build-intents.html
#   - インテントの設定: https://docs.aws.amazon.com/lexv2/latest/dg/intent-overview.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lexv2models_intent
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lexv2models_intent" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # bot_id (Required)
  # 設定内容: インテントを作成する Lex V2 ボットの ID を指定します。
  # 設定可能な値: 有効な Lex V2 ボット ID（aws_lexv2models_bot リソースから取得可能）
  # 省略時: 省略不可
  bot_id = aws_lexv2models_bot.example.id

  # bot_version (Required)
  # 設定内容: インテントを関連付けるボットのバージョンを指定します。
  # 設定可能な値:
  #   - "DRAFT": ドラフトバージョン（開発中）
  #   - 特定のバージョン番号（例: "1", "2"）
  # 省略時: 省略不可
  bot_version = "DRAFT"

  # locale_id (Required)
  # 設定内容: インテントを作成するボットロケールの ID を指定します。
  # 設定可能な値: 有効なロケール ID（例: "en_US", "ja_JP", "de_DE"）
  # 省略時: 省略不可
  locale_id = "en_US"

  # name (Required)
  # 設定内容: インテントの名前を指定します。
  # 設定可能な値: 英数字、アンダースコアのみ使用可（最大100文字）
  # 省略時: 省略不可
  name = "ExampleIntent"

  # description (Optional)
  # 設定内容: インテントの説明を指定します。
  # 設定可能な値: 最大200文字の文字列
  # 省略時: 説明なし
  description = "Amazon Lex V2 インテントのサンプルテンプレートです。"

  # parent_intent_signature (Optional)
  # 設定内容: 組み込みインテントの識別子を指定して親インテントを継承します。
  # 設定可能な値:
  #   - "AMAZON.FallbackIntent": フォールバックインテント
  #   - "AMAZON.CancelIntent": キャンセルインテント
  #   - "AMAZON.HelpIntent": ヘルプインテント
  #   - "AMAZON.StopIntent": 停止インテント
  #   - "AMAZON.YesIntent": 肯定インテント
  #   - "AMAZON.NoIntent": 否定インテント
  # 省略時: 組み込みインテントを継承しない（カスタムインテント）
  parent_intent_signature = null

  #-------------------------------------------------------------
  # サンプル発話設定
  #-------------------------------------------------------------

  # sample_utterance (Optional, 複数指定可)
  # 設定内容: インテントを起動するためのサンプル発話を設定するブロックです。
  # 省略時: サンプル発話なし
  sample_utterance {

    # utterance (Required)
    # 設定内容: サンプル発話のテキストを指定します。
    # 設定可能な値: 発話テキスト（スロット参照は {スロット名} 形式）
    # 省略時: 省略不可
    utterance = "予約をしたいです"
  }

  sample_utterance {
    utterance = "{date} に予約をお願いします"
  }

  #-------------------------------------------------------------
  # 入力コンテキスト設定
  #-------------------------------------------------------------

  # input_context (Optional, 複数指定可)
  # 設定内容: インテントを有効にするための入力コンテキストを設定するブロックです。
  #           指定されたコンテキストがアクティブな場合のみ本インテントが候補となります。
  # 省略時: コンテキスト制限なし
  # input_context {

  #   # name (Required)
  #   # 設定内容: 入力コンテキストの名前を指定します。
  #   # 設定可能な値: コンテキスト名の文字列
  #   # 省略時: 省略不可
  #   name = "PreviousIntentContext"
  # }

  #-------------------------------------------------------------
  # 出力コンテキスト設定
  #-------------------------------------------------------------

  # output_context (Optional, 複数指定可)
  # 設定内容: インテント完了時にアクティブになるコンテキストを設定するブロックです。
  # 省略時: 出力コンテキストなし
  # output_context {

  #   # name (Required)
  #   # 設定内容: 出力コンテキストの名前を指定します。
  #   # 設定可能な値: コンテキスト名の文字列
  #   # 省略時: 省略不可
  #   name = "ReservationContext"

  #   # time_to_live_in_seconds (Required)
  #   # 設定内容: コンテキストが有効な秒数を指定します。
  #   # 設定可能な値: 5〜86400 の整数
  #   # 省略時: 省略不可
  #   time_to_live_in_seconds = 90

  #   # turns_to_live (Required)
  #   # 設定内容: コンテキストが有効な会話ターン数を指定します。
  #   # 設定可能な値: 1〜20 の整数
  #   # 省略時: 省略不可
  #   turns_to_live = 5
  # }

  #-------------------------------------------------------------
  # 初期応答設定
  #-------------------------------------------------------------

  # initial_response_setting (Optional)
  # 設定内容: インテント開始時の初期応答とコードフック設定を行うブロックです。
  # 省略時: 初期応答なし
  # initial_response_setting {

  #   # code_hook (Optional)
  #   # 設定内容: 初期応答フェーズでのコードフック設定を行うブロックです。
  #   # code_hook {

  #   #   # active (Required)
  #   #   # 設定内容: コードフックを有効にするかを指定します。
  #   #   # 設定可能な値: true / false
  #   #   # 省略時: 省略不可
  #   #   active = true

  #   #   # enable_code_hook_invocation (Required)
  #   #   # 設定内容: コードフックの呼び出しを有効にするかを指定します。
  #   #   # 設定可能な値: true / false
  #   #   # 省略時: 省略不可
  #   #   enable_code_hook_invocation = true

  #   #   # invocation_label (Optional)
  #   #   # 設定内容: コードフック呼び出しのラベルを指定します。
  #   #   # 設定可能な値: 任意の文字列
  #   #   # 省略時: ラベルなし
  #   #   invocation_label = "initial_hook"

  #   #   # post_code_hook_specification (Required)
  #   #   # 設定内容: コードフック実行後の処理を指定するブロックです。
  #   #   post_code_hook_specification {}
  #   # }

  #   # conditional (Optional)
  #   # 設定内容: 初期応答での条件分岐を設定するブロックです。
  #   # conditional {}

  #   # next_step (Optional)
  #   # 設定内容: 初期応答後の次のステップを指定するブロックです。
  #   # next_step {}

  #   # voice_over (Optional)
  #   # 設定内容: 初期応答のボイスオーバーを設定するブロックです。
  #   # voice_over {}
  # }

  #-------------------------------------------------------------
  # 確認設定
  #-------------------------------------------------------------

  # confirmation_setting (Optional)
  # 設定内容: インテントのスロット収集完了後、実行前の確認プロンプトを設定するブロックです。
  # 省略時: 確認ステップなし
  confirmation_setting {

    # active (Optional)
    # 設定内容: 確認ステップを有効にするかを指定します。
    # 設定可能な値: true / false
    # 省略時: true
    active = true

    # code_hook (Optional)
    # 設定内容: 確認フェーズでのコードフック設定を行うブロックです。
    # 省略時: コードフックなし
    code_hook {

      # active (Required)
      # 設定内容: コードフックを有効にするかを指定します。
      # 設定可能な値: true / false
      # 省略時: 省略不可
      active = true

      # enable_code_hook_invocation (Required)
      # 設定内容: コードフックの呼び出しを有効にするかを指定します。
      # 設定可能な値: true / false
      # 省略時: 省略不可
      enable_code_hook_invocation = true

      # invocation_label (Optional)
      # 設定内容: コードフック呼び出しのラベルを指定します。
      # 設定可能な値: 任意の文字列
      # 省略時: ラベルなし
      invocation_label = "confirmation_hook"

      # post_code_hook_specification (Required)
      # 設定内容: コードフック実行後の処理を指定するブロックです。
      post_code_hook_specification {}
    }

    # confirmation_response (Optional)
    # 設定内容: ユーザーへの確認プロンプトメッセージを設定するブロックです。
    confirmation_response {

      # allow_interrupt (Optional)
      # 設定内容: ユーザーが応答の途中で割り込めるかを指定します。
      # 設定可能な値: true / false
      # 省略時: true
      allow_interrupt = true

      # message_group (Required, 1件以上)
      # 設定内容: 確認プロンプトのメッセージグループを設定するブロックです。
      message_group {

        # message (Required)
        # 設定内容: 送信するメッセージを設定するブロックです。
        message {

          # plain_text_message (Optional)
          # 設定内容: プレーンテキストメッセージを設定するブロックです。
          plain_text_message {

            # value (Required)
            # 設定内容: メッセージテキストを指定します。
            # 設定可能な値: 任意の文字列
            # 省略時: 省略不可
            value = "よろしいですか？"
          }
        }
      }
    }

    # declination_response (Optional)
    # 設定内容: ユーザーが確認を拒否した際のメッセージを設定するブロックです。
    declination_response {

      # allow_interrupt (Optional)
      # 設定内容: ユーザーが応答の途中で割り込めるかを指定します。
      # 設定可能な値: true / false
      # 省略時: true
      allow_interrupt = true

      # message_group (Required, 1件以上)
      # 設定内容: 拒否時のメッセージグループを設定するブロックです。
      message_group {

        # message (Required)
        # 設定内容: 送信するメッセージを設定するブロックです。
        message {
          plain_text_message {
            value = "キャンセルしました。"
          }
        }
      }
    }

    # confirmation_conditional (Optional)
    # 設定内容: 確認フェーズでの条件分岐を設定するブロックです。
    # confirmation_conditional {}

    # declination_conditional (Optional)
    # 設定内容: 拒否フェーズでの条件分岐を設定するブロックです。
    # declination_conditional {}

    # declination_next_step (Optional)
    # 設定内容: 拒否後の次のステップを指定するブロックです。
    # declination_next_step {}

    # elicitation_code_hook (Optional)
    # 設定内容: 確認引き出しフェーズのコードフックを設定するブロックです。
    # elicitation_code_hook {}

    # failure_response (Optional)
    # 設定内容: 確認フェーズの失敗時メッセージを設定するブロックです。
    # failure_response {}

    # failure_conditional (Optional)
    # 設定内容: 失敗フェーズでの条件分岐を設定するブロックです。
    # failure_conditional {}

    # failure_next_step (Optional)
    # 設定内容: 失敗後の次のステップを指定するブロックです。
    # failure_next_step {}

    # prompt_specification (Optional)
    # 設定内容: 確認プロンプトの詳細設定を行うブロックです。
    # prompt_specification {}
  }

  #-------------------------------------------------------------
  # 終了設定
  #-------------------------------------------------------------

  # closing_setting (Optional)
  # 設定内容: インテントのフルフィルメント完了後の終了応答を設定するブロックです。
  # 省略時: 終了応答なし
  closing_setting {

    # active (Optional)
    # 設定内容: 終了応答ステップを有効にするかを指定します。
    # 設定可能な値: true / false
    # 省略時: true
    active = true

    # closing_response (Optional)
    # 設定内容: インテント完了時にユーザーに送信する終了メッセージを設定するブロックです。
    closing_response {

      # allow_interrupt (Optional)
      # 設定内容: ユーザーが応答の途中で割り込めるかを指定します。
      # 設定可能な値: true / false
      # 省略時: true
      allow_interrupt = false

      # message_group (Required, 1件以上)
      # 設定内容: 終了メッセージのグループを設定するブロックです。
      message_group {

        # message (Required)
        # 設定内容: 送信するメッセージを設定するブロックです。
        message {
          plain_text_message {
            value = "ご予約を承りました。ありがとうございます。"
          }
        }
      }
    }

    # conditional (Optional)
    # 設定内容: 終了フェーズでの条件分岐を設定するブロックです。
    # conditional {}

    # next_step (Optional)
    # 設定内容: 終了フェーズ後の次のステップを指定するブロックです。
    # next_step {}
  }

  #-------------------------------------------------------------
  # ダイアログコードフック設定
  #-------------------------------------------------------------

  # dialog_code_hook (Optional)
  # 設定内容: 各会話ターンでの Lambda 関数によるダイアログ管理を設定するブロックです。
  #           スロット検証や動的なダイアログ制御に使用します。
  # 省略時: ダイアログコードフックなし
  dialog_code_hook {

    # enabled (Required)
    # 設定内容: ダイアログコードフックを有効にするかを指定します。
    # 設定可能な値: true / false
    # 省略時: 省略不可
    enabled = false
  }

  #-------------------------------------------------------------
  # フルフィルメントコードフック設定
  #-------------------------------------------------------------

  # fulfillment_code_hook (Optional)
  # 設定内容: インテントのフルフィルメント（実行）フェーズで呼び出す
  #           Lambda 関数を設定するブロックです。
  # 省略時: フルフィルメントコードフックなし
  fulfillment_code_hook {

    # enabled (Required)
    # 設定内容: フルフィルメントコードフックを有効にするかを指定します。
    # 設定可能な値: true / false
    # 省略時: 省略不可
    enabled = true

    # active (Optional)
    # 設定内容: フルフィルメントコードフックをアクティブ状態にするかを指定します。
    # 設定可能な値: true / false
    # 省略時: デフォルト動作
    active = true

    # fulfillment_updates_specification (Optional)
    # 設定内容: フルフィルメント中の状況更新メッセージを設定するブロックです。
    fulfillment_updates_specification {

      # active (Required)
      # 設定内容: フルフィルメント更新を有効にするかを指定します。
      # 設定可能な値: true / false
      # 省略時: 省略不可
      active = false

      # timeout_in_seconds (Optional)
      # 設定内容: フルフィルメントのタイムアウト秒数を指定します。
      # 設定可能な値: 1〜900 の整数
      # 省略時: タイムアウトなし
      timeout_in_seconds = 30

      # start_response (Optional)
      # 設定内容: フルフィルメント開始時の更新メッセージを設定するブロックです。
      # start_response {}

      # update_response (Optional)
      # 設定内容: フルフィルメント進行中の更新メッセージを設定するブロックです。
      # update_response {}
    }

    # post_fulfillment_status_specification (Optional)
    # 設定内容: フルフィルメント後のステータス（成功・失敗・タイムアウト）に応じた
    #           応答を設定するブロックです。
    # post_fulfillment_status_specification {}
  }

  #-------------------------------------------------------------
  # Kendra 連携設定
  #-------------------------------------------------------------

  # kendra_configuration (Optional)
  # 設定内容: Amazon Kendra を使用してドキュメント検索を行う設定のブロックです。
  # 省略時: Kendra 連携なし
  # kendra_configuration {

  #   # kendra_index (Required)
  #   # 設定内容: 使用する Amazon Kendra インデックスの ARN を指定します。
  #   # 設定可能な値: 有効な Kendra インデックスの ARN
  #   # 省略時: 省略不可
  #   kendra_index = aws_kendra_index.example.arn

  #   # query_filter_string_enabled (Optional)
  #   # 設定内容: Kendra クエリフィルター文字列を有効にするかを指定します。
  #   # 設定可能な値: true / false
  #   # 省略時: false
  #   query_filter_string_enabled = false

  #   # query_filter_string (Optional)
  #   # 設定内容: Kendra クエリに適用するフィルター文字列を指定します。
  #   # 設定可能な値: Kendra クエリフィルター JSON 文字列
  #   # 省略時: フィルターなし
  #   # 注意: query_filter_string_enabled = true の場合に有効
  #   # query_filter_string = jsonencode({ ... })
  # }

  #-------------------------------------------------------------
  # スロット優先順位設定
  #-------------------------------------------------------------

  # slot_priority (Optional, 複数指定可)
  # 設定内容: インテントのスロット収集順序を設定するブロックです。
  # 省略時: スロット優先順位なし
  # slot_priority {

  #   # priority (Required)
  #   # 設定内容: スロットの収集優先順位を指定します（数値が小さいほど先に収集）。
  #   # 設定可能な値: 1〜100 の整数
  #   # 省略時: 省略不可
  #   priority = 1

  #   # slot_id (Required)
  #   # 設定内容: 優先順位を設定するスロットの ID を指定します。
  #   # 設定可能な値: 有効なスロット ID（aws_lexv2models_slot リソースから取得可能）
  #   # 省略時: 省略不可
  #   slot_id = aws_lexv2models_slot.example.slot_id
  # }

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
    # 設定可能な値: Go の time.Duration 形式の文字列（例: "5m", "1h"）
    # 省略時: デフォルトタイムアウト
    create = "5m"

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウト時間を指定します。
    # 設定可能な値: Go の time.Duration 形式の文字列（例: "5m", "1h"）
    # 省略時: デフォルトタイムアウト
    update = "5m"

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: Go の time.Duration 形式の文字列（例: "5m", "1h"）
    # 省略時: デフォルトタイムアウト
    delete = "5m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: リソース ID（{bot_id},{bot_version},{locale_id},{intent_id} の複合）
# - intent_id: 生成されたインテントの ID
# - creation_date_time: インテントが作成された日時（ISO 8601形式）
# - last_updated_date_time: インテントが最後に更新された日時（ISO 8601形式）
#---------------------------------------------------------------
