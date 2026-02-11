#---------------------------------------------------------------
# AWS Bedrock Agents Flow
#---------------------------------------------------------------
#
# Amazon Bedrock Agents Flowをプロビジョニングするリソースです。
# Flowは、ノードとコネクションで構成されるワークフローで、
# プロンプト、Lambda関数、Knowledge Base、Lexボットなどを
# 組み合わせて生成AIアプリケーションを構築できます。
#
# AWS公式ドキュメント:
#   - Amazon Bedrock Flows概要: https://docs.aws.amazon.com/bedrock/latest/userguide/flows.html
#   - Flowのノードタイプ: https://docs.aws.amazon.com/bedrock/latest/userguide/flows-nodes.html
#   - Flowのキー定義: https://docs.aws.amazon.com/bedrock/latest/userguide/key-definitions-flow.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/bedrockagent_flow
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_bedrockagent_flow" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: Flowの名前を指定します。
  # 設定可能な値: 文字列
  name = "my-bedrock-flow"

  # execution_role_arn (Required)
  # 設定内容: Flowの作成と管理に必要な権限を持つサービスロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  # 関連機能: Bedrock Flowsサービスロール
  #   Flowの作成・管理に必要な権限を付与するロール。
  #   - https://docs.aws.amazon.com/bedrock/latest/userguide/flows-permissions.html
  execution_role_arn = "arn:aws:iam::123456789012:role/BedrockFlowExecutionRole"

  # description (Optional)
  # 設定内容: Flowの説明を指定します。
  # 設定可能な値: 文字列
  description = "My Bedrock Flow for text generation"

  # customer_encryption_key_arn (Optional)
  # 設定内容: Flowを暗号化するためのKMSキーのARNを指定します。
  # 設定可能な値: 有効なKMSキーARN
  # 関連機能: Bedrock データ暗号化
  #   カスタマーマネージドキーを使用してFlow実行データを暗号化。
  customer_encryption_key_arn = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  tags = {
    Name        = "my-bedrock-flow"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # Flow定義
  #-------------------------------------------------------------

  # definition (Optional)
  # 設定内容: Flow内のノードとノード間のコネクションを定義します。
  # Flowが機能するためには必須のブロックです。
  definition {

    #-----------------------------------------------------------
    # コネクション定義
    #-----------------------------------------------------------
    # ノード間のデータフローを定義します。
    # sourceノードからtargetノードへデータを送信します。

    # コネクション1: FlowInputNode -> Prompt_1
    connection {
      # name (Required)
      # 設定内容: 参照可能なコネクション名を指定します。
      # 設定可能な値: 文字列
      name = "FlowInputNodeToPrompt"

      # source (Required)
      # 設定内容: コネクションの開始ノードを指定します。
      # 設定可能な値: ノード名
      source = "FlowInputNode"

      # target (Required)
      # 設定内容: コネクションの終了ノードを指定します。
      # 設定可能な値: ノード名
      target = "Prompt_1"

      # type (Required)
      # 設定内容: コネクションのタイプを指定します。
      # 設定可能な値:
      #   - "Data": Conditionノード以外からのデータコネクション
      #   - "Conditional": Conditionノードからの条件付きコネクション
      type = "Data"

      # configuration (Required)
      # 設定内容: コネクションの設定を指定します。
      configuration {

        # data (Optional)
        # 設定内容: Conditionノード以外からのコネクション設定を指定します。
        # typeが"Data"の場合に使用します。
        data {
          # source_output (Required)
          # 設定内容: コネクション開始元のノードの出力名を指定します。
          # 設定可能な値: ソースノードで定義された出力名
          source_output = "document"

          # target_input (Required)
          # 設定内容: コネクション終了先のノードの入力名を指定します。
          # 設定可能な値: ターゲットノードで定義された入力名
          target_input = "topic"
        }

        # conditional (Optional)
        # 設定内容: Conditionノードからのコネクション設定を指定します。
        # typeが"Conditional"の場合に使用します。
        # conditional {
        #   # condition (Required)
        #   # 設定内容: このコネクションをトリガーする条件を指定します。
        #   # 参考: https://docs.aws.amazon.com/bedrock/latest/userguide/node-types.html
        #   condition = "condition_name"
        # }
      }
    }

    # コネクション2: Prompt_1 -> FlowOutputNode
    connection {
      name   = "PromptToFlowOutputNode"
      source = "Prompt_1"
      target = "FlowOutputNode"
      type   = "Data"

      configuration {
        data {
          source_output = "modelCompletion"
          target_input  = "document"
        }
      }
    }

    #-----------------------------------------------------------
    # ノード定義
    #-----------------------------------------------------------
    # Flow内の各処理ユニットを定義します。

    #----- Input Node -----
    # フローの開始点。InvokeFlowリクエストからコンテンツを受け取ります。
    node {
      # name (Required)
      # 設定内容: ノードの名前を指定します。
      # 設定可能な値: 文字列
      name = "FlowInputNode"

      # type (Required)
      # 設定内容: ノードのタイプを指定します。
      # 設定可能な値:
      #   - "Input": フロー入力ノード
      #   - "Output": フロー出力ノード
      #   - "Prompt": プロンプトノード
      #   - "Condition": 条件分岐ノード
      #   - "Agent": エージェントノード
      #   - "KnowledgeBase": Knowledge Baseノード
      #   - "LambdaFunction": Lambda関数ノード
      #   - "Lex": Lexボットノード
      #   - "Iterator": イテレーターノード
      #   - "Collector": コレクターノード
      #   - "Retrieval": S3取得ノード
      #   - "Storage": S3ストレージノード
      type = "Input"

      # configuration (Required)
      # 設定内容: ノードタイプに応じた設定を指定します。
      configuration {
        # input (Optional)
        # 設定内容: 入力フローノードの設定。フィールドはありません。
        input {}
      }

      # output (Optional)
      # 設定内容: ノードからの出力を定義します。
      output {
        # name (Required)
        # 設定内容: 参照可能な出力名を指定します。
        name = "document"

        # type (Required)
        # 設定内容: 出力のデータ型を指定します。
        # 設定可能な値: String, Number, Boolean, Object, Array など
        type = "String"
      }
    }

    #----- Prompt Node -----
    # プロンプトを実行し、モデルのレスポンスを出力します。
    node {
      name = "Prompt_1"
      type = "Prompt"

      configuration {
        # prompt (Optional)
        # 設定内容: プロンプトノードの設定を指定します。
        prompt {

          # guardrail_configuration (Optional)
          # 設定内容: ガードレールの設定を指定します。
          # guardrail_configuration {
          #   # guardrail_identifier (Required)
          #   # 設定内容: ガードレールの一意識別子を指定します。
          #   guardrail_identifier = "guardrail-id"
          #
          #   # guardrail_version (Required)
          #   # 設定内容: ガードレールのバージョンを指定します。
          #   guardrail_version = "1"
          # }

          # source_configuration (Required)
          # 設定内容: プロンプトのソース設定を指定します。
          source_configuration {

            # inline (Optional)
            # 設定内容: インラインでプロンプトを定義します。
            inline {
              # model_id (Required)
              # 設定内容: 推論を実行するモデルまたは推論プロファイルのIDを指定します。
              # 設定可能な値: BedrockでサポートされるモデルID
              # 参考: https://docs.aws.amazon.com/bedrock/latest/userguide/cross-region-inference.html
              model_id = "amazon.titan-text-express-v1"

              # template_type (Required)
              # 設定内容: プロンプトテンプレートのタイプを指定します。
              # 設定可能な値:
              #   - "TEXT": テキストプロンプト
              #   - "CHAT": チャット形式のプロンプト
              template_type = "TEXT"

              # additional_model_request_fields (Optional)
              # 設定内容: モデルリクエストに追加するフィールドをJSON形式で指定します。
              # 設定可能な値: JSON文字列
              additional_model_request_fields = null

              # inference_configuration (Optional)
              # 設定内容: プロンプトの推論設定を指定します。
              inference_configuration {
                # text (Optional)
                # 設定内容: テキストプロンプトの推論設定を指定します。
                text {
                  # max_tokens (Optional)
                  # 設定内容: レスポンスで返す最大トークン数を指定します。
                  max_tokens = 2048

                  # temperature (Optional)
                  # 設定内容: レスポンスのランダム性を制御します。
                  # 設定可能な値: 0.0-1.0（低い値=予測可能、高い値=創造的）
                  temperature = 0

                  # top_p (Optional)
                  # 設定内容: 次のトークンとして考慮する最も可能性の高い候補の割合を指定します。
                  # 設定可能な値: 0.0-1.0
                  top_p = 0.9

                  # stop_sequences (Optional)
                  # 設定内容: モデルが生成を停止するシーケンスのリストを指定します。
                  # 設定可能な値: 文字列のリスト
                  stop_sequences = ["User:"]
                }
              }

              # template_configuration (Required)
              # 設定内容: プロンプトテンプレートの設定を指定します。
              template_configuration {

                # text (Optional)
                # 設定内容: テキスト形式のプロンプトテンプレートを指定します。
                # template_typeが"TEXT"の場合に使用します。
                text {
                  # text (Required)
                  # 設定内容: プロンプトのメッセージテキストを指定します。
                  # {{variable}}形式で変数を埋め込めます。
                  text = "Write a paragraph about {{topic}}."

                  # input_variable (Optional)
                  # 設定内容: プロンプトテンプレート内の変数を定義します。
                  input_variable {
                    # name (Required)
                    # 設定内容: 変数名を指定します。
                    name = "topic"
                  }

                  # cache_point (Optional)
                  # 設定内容: テンプレート設定内のキャッシュチェックポイントを作成します。
                  # cache_point {
                  #   # type (Required)
                  #   # 設定内容: キャッシュポイントのタイプを指定します。
                  #   # 設定可能な値: "default"
                  #   type = "default"
                  # }
                }

                # chat (Optional)
                # 設定内容: チャット形式のプロンプトテンプレートを指定します。
                # template_typeが"CHAT"の場合に使用します。
                # chat {
                #   # input_variable (Optional)
                #   # 設定内容: プロンプトテンプレート内の変数を定義します。
                #   input_variable {
                #     name = "user_input"
                #   }
                #
                #   # message (Optional)
                #   # 設定内容: チャット内のメッセージを定義します。
                #   message {
                #     # role (Required)
                #     # 設定内容: メッセージの役割を指定します。
                #     # 設定可能な値: "user", "assistant"
                #     role = "user"
                #
                #     # content (Required)
                #     # 設定内容: メッセージのコンテンツを定義します。
                #     content {
                #       # text (Optional)
                #       # 設定内容: メッセージのテキストを指定します。
                #       text = "Hello, how can you help me?"
                #
                #       # cache_point (Optional)
                #       # 設定内容: メッセージコンテンツ内のキャッシュチェックポイントを作成します。
                #       # cache_point {
                #       #   type = "default"
                #       # }
                #     }
                #   }
                #
                #   # system (Optional)
                #   # 設定内容: モデルにコンテキストを提供するシステムプロンプトを定義します。
                #   system {
                #     # text (Optional)
                #     # 設定内容: システムプロンプトのテキストを指定します。
                #     text = "You are a helpful assistant."
                #
                #     # cache_point (Optional)
                #     # 設定内容: システムプロンプト内のキャッシュチェックポイントを作成します。
                #     # cache_point {
                #     #   type = "default"
                #     # }
                #   }
                #
                #   # tool_configuration (Optional)
                #   # 設定内容: モデルが使用できるツールの設定を指定します。
                #   tool_configuration {
                #     # tool (Optional)
                #     # 設定内容: モデルに渡すツールのリストを定義します。
                #     tool {
                #       # cache_point (Optional)
                #       # 設定内容: ツール指定内のキャッシュチェックポイントを作成します。
                #       # cache_point {
                #       #   type = "default"
                #       # }
                #
                #       # tool_spec (Optional)
                #       # 設定内容: ツールの仕様を定義します。
                #       tool_spec {
                #         # name (Required)
                #         # 設定内容: ツールの名前を指定します。
                #         name = "get_weather"
                #
                #         # description (Optional)
                #         # 設定内容: ツールの説明を指定します。
                #         description = "Get current weather for a location"
                #
                #         # input_schema (Optional)
                #         # 設定内容: ツールの入力スキーマを定義します。
                #         input_schema {
                #           # json (Optional)
                #           # 設定内容: 入力スキーマをJSON形式で指定します。
                #           json = jsonencode({
                #             type = "object"
                #             properties = {
                #               location = {
                #                 type        = "string"
                #                 description = "City name"
                #               }
                #             }
                #             required = ["location"]
                #           })
                #         }
                #       }
                #     }
                #
                #     # tool_choice (Optional)
                #     # 設定内容: モデルが呼び出すべきツールを定義します。
                #     tool_choice {
                #       # any (Optional)
                #       # 設定内容: 少なくとも1つのツールをリクエストする必要があることを定義します。
                #       # フィールドはありません。
                #       # any {}
                #
                #       # auto (Optional)
                #       # 設定内容: モデルがツールを呼び出すかテキストを生成するか自動決定します。
                #       # フィールドはありません。
                #       # auto {}
                #
                #       # tool (Optional)
                #       # 設定内容: モデルがリクエストする特定のツールを指定します。
                #       # tool {
                #       #   # name (Required)
                #       #   # 設定内容: ツール名を指定します。
                #       #   name = "get_weather"
                #       # }
                #     }
                #   }
                # }
              }
            }

            # resource (Optional)
            # 設定内容: Prompt managementからのプロンプトを使用する場合に指定します。
            # resource {
            #   # prompt_arn (Required)
            #   # 設定内容: Prompt managementのプロンプトARNを指定します。
            #   prompt_arn = "arn:aws:bedrock:us-east-1:123456789012:prompt/prompt-id"
            # }
          }
        }
      }

      # input (Optional)
      # 設定内容: ノードへの入力を定義します。
      input {
        # name (Required)
        # 設定内容: 参照可能な入力名を指定します。
        name = "topic"

        # type (Required)
        # 設定内容: 入力のデータ型を指定します。
        type = "String"

        # expression (Required)
        # 設定内容: 入力をフォーマットする式を指定します。
        # 参考: https://docs.aws.amazon.com/bedrock/latest/userguide/flows-expressions.html
        expression = "$.data"

        # category (Optional)
        # 設定内容: DoWhileループ内のイテレーション間でのデータフローを指定します。
        # 設定可能な値: 文字列
        category = null
      }

      # output (Optional)
      # 設定内容: ノードからの出力を定義します。
      output {
        name = "modelCompletion"
        type = "String"
      }
    }

    #----- Output Node -----
    # フローの終了点。入力データを抽出してレスポンスとして返します。
    node {
      name = "FlowOutputNode"
      type = "Output"

      configuration {
        # output (Optional)
        # 設定内容: 出力フローノードの設定。フィールドはありません。
        output {}
      }

      input {
        name       = "document"
        type       = "String"
        expression = "$.data"
      }
    }

    #----- Agent Node (コメントアウト例) -----
    # エージェントのエイリアスを呼び出し、レスポンスを返します。
    # node {
    #   name = "AgentNode"
    #   type = "Agent"
    #
    #   configuration {
    #     agent {
    #       # agent_alias_arn (Required)
    #       # 設定内容: 呼び出すエージェントエイリアスのARNを指定します。
    #       agent_alias_arn = "arn:aws:bedrock:us-east-1:123456789012:agent-alias/agent-id/alias-id"
    #     }
    #   }
    #
    #   input {
    #     name       = "input"
    #     type       = "String"
    #     expression = "$.data"
    #   }
    #
    #   output {
    #     name = "response"
    #     type = "String"
    #   }
    # }

    #----- Condition Node (コメントアウト例) -----
    # 条件に基づいて異なるブランチにデータを送信します。
    # node {
    #   name = "ConditionNode"
    #   type = "Condition"
    #
    #   configuration {
    #     condition {
    #       # condition (Optional)
    #       # 設定内容: 条件のリストを定義します。
    #       condition {
    #         # name (Required)
    #         # 設定内容: 参照可能な条件名を指定します。
    #         name = "isPositive"
    #
    #         # expression (Optional)
    #         # 設定内容: 条件を定義する式を指定します。
    #         # 参考: https://docs.aws.amazon.com/bedrock/latest/userguide/flows-how-it-works.html#flows-nodes
    #         expression = "$.sentiment == 'positive'"
    #       }
    #
    #       condition {
    #         name       = "default"
    #         expression = null
    #       }
    #     }
    #   }
    #
    #   input {
    #     name       = "sentiment"
    #     type       = "String"
    #     expression = "$.data"
    #   }
    #
    #   output {
    #     name = "result"
    #     type = "String"
    #   }
    # }

    #----- Inline Code Node (コメントアウト例) -----
    # インラインコードを実行するノードです。
    # node {
    #   name = "InlineCodeNode"
    #   type = "InlineCode"
    #
    #   configuration {
    #     inline_code {
    #       # code (Required)
    #       # 設定内容: 実行するコードを指定します。
    #       code = <<-EOT
    #         def handler(event):
    #             return {"result": event["input"].upper()}
    #       EOT
    #
    #       # language (Required)
    #       # 設定内容: コードのプログラミング言語を指定します。
    #       # 設定可能な値: "python3.12" など
    #       language = "python3.12"
    #     }
    #   }
    #
    #   input {
    #     name       = "input"
    #     type       = "String"
    #     expression = "$.data"
    #   }
    #
    #   output {
    #     name = "result"
    #     type = "String"
    #   }
    # }

    #----- Knowledge Base Node (コメントアウト例) -----
    # Knowledge Baseをクエリし、取得結果または生成されたレスポンスを返します。
    # node {
    #   name = "KnowledgeBaseNode"
    #   type = "KnowledgeBase"
    #
    #   configuration {
    #     knowledge_base {
    #       # knowledge_base_id (Required)
    #       # 設定内容: クエリするKnowledge Baseの一意識別子を指定します。
    #       knowledge_base_id = "kb-12345678"
    #
    #       # model_id (Required)
    #       # 設定内容: クエリ結果からレスポンスを生成するモデルIDを指定します。
    #       # 省略すると取得結果を配列として返します。
    #       model_id = "amazon.titan-text-express-v1"
    #
    #       # number_of_results (Optional)
    #       # 設定内容: 取得する結果の数を指定します。
    #       number_of_results = 5
    #
    #       # guardrail_configuration (Optional)
    #       # 設定内容: Knowledge Baseのクエリとレスポンス生成時に適用するガードレールを設定します。
    #       # guardrail_configuration {
    #       #   guardrail_identifier = "guardrail-id"
    #       #   guardrail_version    = "1"
    #       # }
    #
    #       # inference_configuration (Optional)
    #       # 設定内容: 推論設定を指定します。
    #       # inference_configuration {
    #       #   text {
    #       #     max_tokens     = 2048
    #       #     temperature    = 0.5
    #       #     top_p          = 0.9
    #       #     stop_sequences = []
    #       #   }
    #       # }
    #     }
    #   }
    #
    #   input {
    #     name       = "query"
    #     type       = "String"
    #     expression = "$.data"
    #   }
    #
    #   output {
    #     name = "response"
    #     type = "String"
    #   }
    # }

    #----- Lambda Function Node (コメントアウト例) -----
    # Lambda関数を呼び出します。
    # node {
    #   name = "LambdaFunctionNode"
    #   type = "LambdaFunction"
    #
    #   configuration {
    #     lambda_function {
    #       # lambda_arn (Required)
    #       # 設定内容: 呼び出すLambda関数のARNを指定します。
    #       lambda_arn = "arn:aws:lambda:us-east-1:123456789012:function:my-function"
    #     }
    #   }
    #
    #   input {
    #     name       = "input"
    #     type       = "String"
    #     expression = "$.data"
    #   }
    #
    #   output {
    #     name = "result"
    #     type = "String"
    #   }
    # }

    #----- Lex Node (コメントアウト例) -----
    # Amazon Lexボットを呼び出してインテントを識別します。
    # node {
    #   name = "LexNode"
    #   type = "Lex"
    #
    #   configuration {
    #     lex {
    #       # bot_alias_arn (Required)
    #       # 設定内容: 呼び出すLexボットエイリアスのARNを指定します。
    #       bot_alias_arn = "arn:aws:lex:us-east-1:123456789012:bot-alias/bot-id/alias-id"
    #
    #       # locale_id (Required)
    #       # 設定内容: Lexボットを呼び出すリージョン/ロケールを指定します。
    #       locale_id = "en_US"
    #     }
    #   }
    #
    #   input {
    #     name       = "inputText"
    #     type       = "String"
    #     expression = "$.data"
    #   }
    #
    #   output {
    #     name = "predictedIntent"
    #     type = "String"
    #   }
    # }

    #----- Iterator Node (コメントアウト例) -----
    # 配列を受け取り、各アイテムを順番に下流ノードに出力します。
    # node {
    #   name = "IteratorNode"
    #   type = "Iterator"
    #
    #   configuration {
    #     iterator {}
    #   }
    #
    #   input {
    #     name       = "array"
    #     type       = "Array"
    #     expression = "$.data"
    #   }
    #
    #   output {
    #     name = "arrayItem"
    #     type = "String"
    #   }
    #
    #   output {
    #     name = "arraySize"
    #     type = "Number"
    #   }
    # }

    #----- Collector Node (コメントアウト例) -----
    # イテレーションの入力を収集し、配列として出力します。
    # node {
    #   name = "CollectorNode"
    #   type = "Collector"
    #
    #   configuration {
    #     collector {}
    #   }
    #
    #   input {
    #     name       = "iteration"
    #     type       = "String"
    #     expression = "$.data"
    #   }
    #
    #   output {
    #     name = "collectedArray"
    #     type = "Array"
    #   }
    # }

    #----- Retrieval Node (コメントアウト例) -----
    # Amazon S3からデータを取得して出力として返します。
    # node {
    #   name = "RetrievalNode"
    #   type = "Retrieval"
    #
    #   configuration {
    #     retrieval {
    #       # service_configuration (Required)
    #       # 設定内容: データ取得用のサービス設定を指定します。
    #       service_configuration {
    #         # s3 (Optional)
    #         # 設定内容: S3からデータを取得するための設定を指定します。
    #         s3 {
    #           # bucket_name (Required)
    #           # 設定内容: データを取得するS3バケット名を指定します。
    #           bucket_name = "my-data-bucket"
    #         }
    #       }
    #     }
    #   }
    #
    #   input {
    #     name       = "objectKey"
    #     type       = "String"
    #     expression = "$.data"
    #   }
    #
    #   output {
    #     name = "s3Content"
    #     type = "String"
    #   }
    # }

    #----- Storage Node (コメントアウト例) -----
    # Amazon S3に入力データを保存します。
    # node {
    #   name = "StorageNode"
    #   type = "Storage"
    #
    #   configuration {
    #     storage {
    #       # service_configuration (Required)
    #       # 設定内容: データ保存用のサービス設定を指定します。
    #       service_configuration {
    #         # s3 (Optional)
    #         # 設定内容: S3にデータを保存するための設定を指定します。
    #         s3 {
    #           # bucket_name (Required)
    #           # 設定内容: データを保存するS3バケット名を指定します。
    #           bucket_name = "my-storage-bucket"
    #         }
    #       }
    #     }
    #   }
    #
    #   input {
    #     name       = "content"
    #     type       = "String"
    #     expression = "$.data"
    #   }
    #
    #   output {
    #     name = "s3Uri"
    #     type = "String"
    #   }
    # }
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定します。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "5m", "2h45m" など（Go duration形式）
    create = "30m"

    # update (Optional)
    # 設定内容: リソース更新のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "5m", "2h45m" など（Go duration形式）
    update = "30m"

    # delete (Optional)
    # 設定内容: リソース削除のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "5m", "2h45m" など（Go duration形式）
    delete = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: FlowのAmazon Resource Name (ARN)
#
# - id: Flowの一意識別子
#
# - created_at: Flowが作成された日時
#
# - updated_at: Flowが最後に更新された日時
#
# - version: Flowのバージョン
#
# - status: Flowのステータス
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
