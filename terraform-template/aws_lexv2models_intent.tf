#---------------------------------------------------------------
# Amazon Lex V2 Models Intent
#---------------------------------------------------------------
#
# Amazon Lex V2 Models Intentは、会話型ボット（チャットボット）における
# ユーザーの意図を定義するリソースです。インテントは、ユーザーが達成したい
# アクション（例：ピザの注文、予約の取得など）を表し、それを実現するための
# サンプル発話、スロット、確認設定、フルフィルメントコードフックなどを
# 構成できます。
#
# AWS公式ドキュメント:
#   - Amazon Lex V2 core concepts: https://docs.aws.amazon.com/lexv2/latest/dg/how-it-works.html
#   - Setting intent context: https://docs.aws.amazon.com/lexv2/latest/dg/context-mgmt-active-context.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lexv2models_intent
#
# Provider Version: 6.28.0
# Generated: 2026-01-28
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lexv2models_intent" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # ボットID
  # このインテントが関連付けられるボットの識別子
  bot_id = "BTID12345EXAMPLE"

  # ボットバージョン
  # このインテントが関連付けられるボットのバージョン
  # 通常は "DRAFT" を指定して開発中のボットに追加します
  bot_version = "DRAFT"

  # ロケールID
  # このインテントが使用される言語とロケールの識別子
  # インテントで使用される全てのボット、スロットタイプ、スロットは
  # 同じロケールである必要があります
  # 例: "en_US", "ja_JP", "es_ES" など
  locale_id = "en_US"

  # インテント名
  # インテントの名前。インテント名はロケール内で一意である必要があり、
  # 組み込みインテントの名前と重複してはいけません
  # 例: "OrderPizza", "BookAppointment", "CheckOrderStatus"
  name = "OrderPizza"

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # 説明
  # インテントの説明。リスト内でインテントを識別するのに役立ちます
  description = "Intent for ordering pizza"

  # 親インテントシグネチャ
  # このインテントのベースとなる組み込みインテントの識別子
  # 組み込みインテントを拡張する場合に使用します
  # parent_intent_signature = "AMAZON.FallbackIntent"

  # リージョン
  # このリソースが管理されるリージョン
  # 指定しない場合、プロバイダー設定のリージョンがデフォルトで使用されます
  # region = "us-west-2"

  #---------------------------------------------------------------
  # Closing Setting (クロージング設定)
  #---------------------------------------------------------------
  # インテントが完了した際にAmazon Lexがユーザーに送信する応答の設定
  # ユーザーが "no" と答えた場合、この設定にはインテントを終了するための
  # ステートメントが含まれます

  # closing_setting {
  #   # アクティブフラグ
  #   # インテントのクロージング応答が使用されるかどうか
  #   # false の場合、クロージング応答はユーザーに送信されません
  #   active = true
  #
  #   # クロージング応答
  #   # インテントが完了した際にAmazon Lexが送信する応答
  #   closing_response {
  #     # メッセージグループ（必須）
  #     # Amazon Lexがユーザーに送信できる応答のリスト
  #     # 実行時に実際に送信する応答を選択します
  #     message_group {
  #       # メッセージ（必須）
  #       # Amazon Lexがユーザーに送信するプライマリメッセージ
  #       message {
  #         # プレーンテキストメッセージ
  #         plain_text_message {
  #           value = "Thank you for your order. Goodbye!"
  #         }
  #       }
  #     }
  #
  #     # 割り込み許可
  #     # ユーザーがAmazon Lexの音声応答を割り込むことができるか
  #     allow_interrupt = false
  #   }
  #
  #   # 条件分岐
  #   # インテントのクロージング応答に関連する条件分岐のリスト
  #   # next_stepが "EvalutateConditional" に設定されている場合に実行されます
  #   # conditional {
  #   #   active = true
  #   #   conditional_branch {
  #   #     condition {
  #   #       expression_string = "$session.orderTotal > 50"
  #   #     }
  #   #     name = "HighValueOrder"
  #   #     next_step {
  #   #       dialog_action {
  #   #         type = "EndConversation"
  #   #       }
  #   #     }
  #   #   }
  #   #   default_branch {
  #   #     next_step {
  #   #       dialog_action {
  #   #         type = "EndConversation"
  #   #       }
  #   #     }
  #   #   }
  #   # }
  #
  #   # ネクストステップ
  #   # インテントのクロージング応答を再生した後にボットが実行する次のステップ
  #   # next_step {
  #   #   dialog_action {
  #   #     type = "EndConversation"
  #   #   }
  #   # }
  # }

  #---------------------------------------------------------------
  # Confirmation Setting (確認設定)
  #---------------------------------------------------------------
  # インテントの完了を確認するためにAmazon Lexがユーザーに送信するプロンプト設定
  # ユーザーが "no" と答えた場合の処理も含まれます

  # confirmation_setting {
  #   # アクティブフラグ
  #   # インテントの確認がユーザーに送信されるかどうか
  #   # false の場合、確認と拒否の応答は送信されません
  #   active = true
  #
  #   # プロンプト仕様（必須）
  #   # インテントを確認するようユーザーに促すプロンプト設定
  #   prompt_specification {
  #     # 最大リトライ回数（必須）
  #     # このプロンプトを使用してユーザーから応答を引き出そうとする最大回数
  #     max_retries = 2
  #
  #     # メッセージグループ（必須）
  #     message_group {
  #       message {
  #         plain_text_message {
  #           value = "Would you like to proceed with your order?"
  #         }
  #       }
  #     }
  #
  #     # 割り込み許可
  #     # ユーザーがボットからの音声プロンプトを割り込むことができるか
  #     allow_interrupt = true
  #
  #     # メッセージ選択戦略
  #     # リトライ間でメッセージグループからメッセージを選択する方法
  #     # 有効な値: "Random", "Ordered"
  #     message_selection_strategy = "Ordered"
  #
  #     # プロンプト試行仕様
  #     # プロンプトの各試行に関する詳細設定
  #     # prompt_attempts_specification {
  #     #   map_block_key = "Initial"
  #     #   allow_interrupt = true
  #     #   allowed_input_types {
  #     #     allow_audio_input = true
  #     #     allow_dtmf_input = true
  #     #   }
  #     # }
  #   }
  #
  #   # 確認条件分岐
  #   # インテントが確認された後に評価する条件分岐
  #   # confirmation_conditional {
  #   #   active = true
  #   #   conditional_branch {
  #   #     condition {
  #   #       expression_string = "$session.orderType == 'express'"
  #   #     }
  #   #     name = "ExpressOrder"
  #   #     next_step {
  #   #       dialog_action {
  #   #         type = "FulfillIntent"
  #   #       }
  #   #     }
  #   #   }
  #   #   default_branch {
  #   #     next_step {
  #   #       dialog_action {
  #   #         type = "FulfillIntent"
  #   #       }
  #   #     }
  #   #   }
  #   # }
  #
  #   # 確認次ステップ
  #   # 顧客がインテントを確認した後にボットが実行する次のステップ
  #   # confirmation_next_step {
  #   #   dialog_action {
  #   #     type = "FulfillIntent"
  #   #   }
  #   # }
  #
  #   # 確認応答
  #   # Amazon Lexがユーザー入力に応答するために使用するメッセージグループ
  #   # confirmation_response {
  #   #   message_group {
  #   #     message {
  #   #       plain_text_message {
  #   #         value = "Great! I'll process your order now."
  #   #       }
  #   #     }
  #   #   }
  #   #   allow_interrupt = false
  #   # }
  #
  #   # 拒否条件分岐
  #   # インテントが拒否された後に評価する条件分岐
  #   # declination_conditional {
  #   #   active = true
  #   #   conditional_branch {
  #   #     condition {
  #   #       expression_string = "$session.retryCount < 3"
  #   #     }
  #   #     name = "RetryOrder"
  #   #     next_step {
  #   #       dialog_action {
  #   #         type = "ElicitIntent"
  #   #       }
  #   #     }
  #   #   }
  #   #   default_branch {
  #   #     next_step {
  #   #       dialog_action {
  #   #         type = "EndConversation"
  #   #       }
  #   #     }
  #   #   }
  #   # }
  #
  #   # 拒否次ステップ
  #   # 顧客がインテントを拒否した後にボットが実行する次のステップ
  #   # declination_next_step {
  #   #   dialog_action {
  #   #     type = "EndConversation"
  #   #   }
  #   # }
  #
  #   # 拒否応答
  #   # 確認の質問に対してユーザーが "no" と答えた際のAmazon Lexの応答
  #   # declination_response {
  #   #   message_group {
  #   #     message {
  #   #       plain_text_message {
  #   #         value = "Okay, your order has been cancelled."
  #   #       }
  #   #     }
  #   #   }
  #   #   allow_interrupt = false
  #   # }
  #
  #   # コードフック
  #   # インテントの確認ステップに関する設定
  #   # 確認、拒否、失敗の各次ステップが "invoke_dialog_code_hook" の場合に
  #   # この設定に基づいてダイアログコードフックがトリガーされます
  #   # code_hook {
  #   #   active = true
  #   #   enable_code_hook_invocation = true
  #   #   invocation_label = "ConfirmOrder"
  #   #   post_code_hook_specification {
  #   #     success_next_step {
  #   #       dialog_action {
  #   #         type = "FulfillIntent"
  #   #       }
  #   #     }
  #   #   }
  #   # }
  #
  #   # 引き出しコードフック
  #   # 確認プロンプトのリトライ時にコードフックが呼び出される際の設定
  #   # elicitation_code_hook {
  #   #   enable_code_hook_invocation = true
  #   #   invocation_label = "ValidateConfirmation"
  #   # }
  #
  #   # 失敗条件分岐
  #   # 確認ステップが失敗した場合に評価する条件分岐
  #   # failure_conditional {
  #   #   active = true
  #   #   conditional_branch {
  #   #     condition {
  #   #       expression_string = "$session.errorCount < 3"
  #   #     }
  #   #     name = "RetryConfirmation"
  #   #     next_step {
  #   #       dialog_action {
  #   #         type = "ElicitIntent"
  #   #       }
  #   #     }
  #   #   }
  #   #   default_branch {
  #   #     next_step {
  #   #       dialog_action {
  #   #         type = "EndConversation"
  #   #       }
  #   #     }
  #   #   }
  #   # }
  #
  #   # 失敗次ステップ
  #   # 確認ステップが失敗した場合の会話の次のステップ
  #   # failure_next_step {
  #   #   dialog_action {
  #   #     type = "ElicitIntent"
  #   #   }
  #   # }
  #
  #   # 失敗応答
  #   # Amazon Lexがユーザー入力に応答するために使用するメッセージグループ
  #   # failure_response {
  #   #   message_group {
  #   #     message {
  #   #       plain_text_message {
  #   #         value = "I'm sorry, I couldn't confirm your order. Let's try again."
  #   #       }
  #   #     }
  #   #   }
  #   #   allow_interrupt = false
  #   # }
  # }

  #---------------------------------------------------------------
  # Dialog Code Hook (ダイアログコードフック)
  #---------------------------------------------------------------
  # ユーザー入力ごとにエイリアスLambda関数を呼び出すための設定
  # この Lambda 関数を呼び出してユーザーとのやり取りをパーソナライズできます

  # dialog_code_hook {
  #   # 有効化（必須）
  #   # ダイアログコードフックを有効にして、ユーザーリクエストを処理します
  #   enabled = true
  # }

  #---------------------------------------------------------------
  # Fulfillment Code Hook (フルフィルメントコードフック)
  #---------------------------------------------------------------
  # インテントがフルフィルメントの準備ができた際にエイリアスLambda関数を
  # 呼び出すための設定。この関数を呼び出してボットのトランザクションを完了できます

  # fulfillment_code_hook {
  #   # 有効化（必須）
  #   # 特定のインテントをフルフィルするためにLambda関数を呼び出すかどうか
  #   enabled = true
  #
  #   # アクティブフラグ
  #   # フルフィルメントコードフックが使用されるかどうか
  #   # active が false の場合、コードフックは実行されません
  #   active = true
  #
  #   # フルフィルメント更新仕様
  #   # 長時間実行されるLambdaフルフィルメント関数のための更新メッセージ設定
  #   # フルフィルメント更新はストリーミング会話でのみ使用できます
  #   # fulfillment_updates_specification {
  #   #   active = true
  #   #   timeout_in_seconds = 300
  #   #   start_response {
  #   #     delay_in_seconds = 5
  #   #     message_group {
  #   #       message {
  #   #         plain_text_message {
  #   #           value = "Processing your order..."
  #   #         }
  #   #       }
  #   #     }
  #   #   }
  #   #   update_response {
  #   #     frequency_in_seconds = 30
  #   #     message_group {
  #   #       message {
  #   #         plain_text_message {
  #   #           value = "Still processing..."
  #   #         }
  #   #       }
  #   #     }
  #   #   }
  #   # }
  #
  #   # フルフィルメント後ステータス仕様
  #   # Lambdaフルフィルメント関数完了後にユーザーに送信されるメッセージ設定
  #   # ストリーミング/非ストリーミング両方の会話で使用可能
  #   # post_fulfillment_status_specification {
  #   #   success_response {
  #   #     message_group {
  #   #       message {
  #   #         plain_text_message {
  #   #           value = "Your order has been successfully placed!"
  #   #         }
  #   #       }
  #   #     }
  #   #   }
  #   #   failure_response {
  #   #     message_group {
  #   #       message {
  #   #         plain_text_message {
  #   #           value = "Sorry, there was an error processing your order."
  #   #         }
  #   #       }
  #   #     }
  #   #   }
  #   # }
  # }

  #---------------------------------------------------------------
  # Initial Response Setting (初期応答設定)
  #---------------------------------------------------------------
  # スロット値を引き出す前に、会話の開始時にユーザーに送信される応答の設定

  # initial_response_setting {
  #   # 初期応答
  #   # Amazon Lexがユーザー入力に応答するために使用するメッセージグループ
  #   initial_response {
  #     message_group {
  #       message {
  #         plain_text_message {
  #           value = "I'll help you order a pizza."
  #         }
  #       }
  #     }
  #     allow_interrupt = true
  #   }
  #
  #   # コードフック
  #   # Amazon Lexが会話のステップで呼び出すダイアログコードフック設定
  #   # code_hook {
  #   #   active = true
  #   #   enable_code_hook_invocation = true
  #   #   invocation_label = "InitializeOrder"
  #   #   post_code_hook_specification {
  #   #     success_next_step {
  #   #       dialog_action {
  #   #         type = "ElicitSlot"
  #   #         slot_to_elicit = "pizzaSize"
  #   #       }
  #   #     }
  #   #   }
  #   # }
  #
  #   # 条件分岐
  #   # リスト内で評価される条件分岐
  #   # 最初に条件がtrueになった分岐が実行されます
  #   # conditional {
  #   #   active = true
  #   #   conditional_branch {
  #   #     condition {
  #   #       expression_string = "$session.returningCustomer == true"
  #   #     }
  #   #     name = "ReturningCustomer"
  #   #     next_step {
  #   #       dialog_action {
  #   #         type = "ElicitSlot"
  #   #         slot_to_elicit = "pizzaSize"
  #   #       }
  #   #     }
  #   #   }
  #   #   default_branch {
  #   #     next_step {
  #   #       dialog_action {
  #   #         type = "ElicitSlot"
  #   #         slot_to_elicit = "customerName"
  #   #       }
  #   #     }
  #   #   }
  #   # }
  #
  #   # ネクストステップ
  #   # 会話の次のステップ
  #   # next_step {
  #   #   dialog_action {
  #   #     type = "ElicitSlot"
  #   #     slot_to_elicit = "pizzaSize"
  #   #   }
  #   # }
  # }

  #---------------------------------------------------------------
  # Input Context (入力コンテキスト)
  #---------------------------------------------------------------
  # このインテントがAmazon Lexによって考慮されるためにアクティブである必要がある
  # コンテキストの設定。インテントが入力コンテキストリストを持つ場合、
  # Amazon Lexは指定されたコンテキストがセッションのアクティブコンテキスト
  # リストに含まれている場合にのみインテントを使用します

  # input_context {
  #   # コンテキスト名（必須）
  #   # コンテキストの名前
  #   name = "orderContext"
  # }

  #---------------------------------------------------------------
  # Kendra Configuration (Kendra設定)
  #---------------------------------------------------------------
  # AMAZON.KendraSearchIntentインテントを使用してAmazon Kendraインデックスに
  # 接続するために必要な情報の設定

  # kendra_configuration {
  #   # Kendraインデックス（必須）
  #   # AMAZON.KendraSearchIntentインテントが検索するAmazon KendraインデックスのARN
  #   # インデックスはAmazon Lexボットと同じアカウントおよびリージョンにある必要があります
  #   kendra_index = "arn:aws:kendra:us-east-1:123456789012:index/12345678-1234-1234-1234-123456789012"
  #
  #   # クエリフィルタ文字列
  #   # Amazon LexがAmazon Kendraに送信してクエリからの応答をフィルタリングする
  #   # クエリフィルタ。フィルタはAmazon Kendraで定義された形式です
  #   query_filter_string = "{ \"equalsTo\": { \"key\": \"department\", \"value\": { \"stringValue\": \"sales\" } } }"
  #
  #   # クエリフィルタ文字列有効化
  #   # AMAZON.KendraSearchIntentインテントがカスタムクエリ文字列を使用して
  #   # Amazon Kendraインデックスをクエリするかどうか
  #   query_filter_string_enabled = true
  # }

  #---------------------------------------------------------------
  # Output Context (出力コンテキスト)
  #---------------------------------------------------------------
  # インテントがフルフィルされた際にアクティブになるコンテキストの設定
  # 出力コンテキストを使用して、Amazon Lexが顧客との会話の次のターンで
  # 考慮すべきインテントを示すことができます

  # output_context {
  #   # 出力コンテキスト名（必須）
  #   # 出力コンテキストの名前
  #   name = "orderCompleted"
  #
  #   # 存続時間（秒）（必須）
  #   # 出力コンテキストがアクティブのままである秒数
  #   # 時間は、コンテキストが最初にユーザーに送信された時点から計算されます
  #   time_to_live_in_seconds = 300
  #
  #   # 存続ターン数（必須）
  #   # 出力コンテキストがアクティブのままである会話ターン数
  #   # ターン数は、コンテキストが最初にユーザーに送信された時点から計算されます
  #   turns_to_live = 5
  # }

  #---------------------------------------------------------------
  # Sample Utterance (サンプル発話)
  #---------------------------------------------------------------
  # ユーザーがインテントを示すために言う可能性のある文字列の設定

  # sample_utterance {
  #   # 発話（必須）
  #   # Amazon Lexが機械学習モデルを構築してインテントを認識するために使用する
  #   # サンプル発話
  #   utterance = "I want to order a pizza"
  # }
  #
  # sample_utterance {
  #   utterance = "Can I order a pizza"
  # }
  #
  # sample_utterance {
  #   utterance = "Order pizza"
  # }

  #---------------------------------------------------------------
  # Slot Priority (スロット優先順位)
  #---------------------------------------------------------------
  # インテントに含まれるスロットとその優先順位の新しいリストの設定
  # これは作成時には無視され、更新時のみ有効です

  # slot_priority {
  #   # 優先順位（必須）
  #   # Amazon Lexがスロットに適用する優先順位
  #   priority = 1
  #
  #   # スロットID（必須）
  #   # スロットの一意の識別子
  #   slot_id = "SLOTID12345EXAMPLE"
  # }

  #---------------------------------------------------------------
  # Timeouts
  #---------------------------------------------------------------
  # タイムアウト設定

  # timeouts {
  #   create = "30m"
  #   update = "30m"
  #   delete = "30m"
  # }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします（computed only）:
#
# - creation_date_time: インテントが作成された日時のタイムスタンプ
# - id: intent_id:bot_id:bot_version:locale_id の複合識別子
# - intent_id: インテントの一意の識別子
# - last_updated_date_time: インテントが最後に変更された日時のタイムスタンプ
#
# これらの属性は参照用であり、リソース定義には含めません。
# 他のリソースから参照する場合: aws_lexv2models_intent.example.intent_id
#---------------------------------------------------------------
