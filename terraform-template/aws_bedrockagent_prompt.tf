#---------------------------------------------------------------
# AWS Bedrock Agents Prompt
#---------------------------------------------------------------
#
# Amazon Bedrockのプロンプト管理機能でプロンプトを作成・管理するための
# リソースです。プロンプトは基盤モデル（FM）への入力として使用され、
# 変数を含めることで異なるユースケースに対応できます。
# バリアントを使用して同じプロンプトの異なる設定を比較・テストできます。
#
# AWS公式ドキュメント:
#   - Prompt management概要: https://docs.aws.amazon.com/bedrock/latest/userguide/prompt-management.html
#   - プロンプトの作成: https://docs.aws.amazon.com/bedrock/latest/userguide/prompt-management-create.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/bedrockagent_prompt
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_bedrockagent_prompt" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: プロンプトの名前を指定します。
  # 設定可能な値: 文字列
  name = "MyPrompt"

  # description (Optional)
  # 設定内容: プロンプトの説明を指定します。
  # 設定可能な値: 文字列
  description = "My prompt description."

  # default_variant (Optional)
  # 設定内容: デフォルトで使用するバリアントの名前を指定します。
  # 設定可能な値: 定義されたバリアントの名前
  # 注意: variantブロックで定義したバリアント名と一致させる必要があります。
  default_variant = "Variant1"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # 暗号化設定
  #-------------------------------------------------------------

  # customer_encryption_key_arn (Optional)
  # 設定内容: プロンプトを暗号化するKMSキーのARNを指定します。
  # 設定可能な値: 有効なKMSキーARN
  # 省略時: AWS管理キーで暗号化されます。
  # 関連機能: AWS KMS カスタマー管理キー
  #   カスタマー管理キーを使用してプロンプトデータを暗号化できます。
  #   - https://docs.aws.amazon.com/kms/latest/developerguide/concepts.html
  customer_encryption_key_arn = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  tags = {
    Name        = "my-prompt"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # バリアント設定
  #-------------------------------------------------------------
  # プロンプトの異なる設定（モデル、推論パラメータ、テンプレート等）を
  # 定義します。複数のバリアントを作成して比較・テストできます。

  variant {
    # name (Required)
    # 設定内容: バリアントの名前を指定します。
    # 設定可能な値: 文字列
    name = "Variant1"

    # model_id (Optional)
    # 設定内容: プロンプトで推論を実行するモデルまたは推論プロファイルのIDを指定します。
    # 設定可能な値: 基盤モデルID（例: amazon.titan-text-express-v1, anthropic.claude-3-sonnet-20240229-v1:0）
    #               または推論プロファイルのARN
    # 注意: model_idを指定しない場合は、gen_ai_resourceでエージェントを指定する必要があります。
    # 参考: https://docs.aws.amazon.com/bedrock/latest/userguide/cross-region-inference.html
    model_id = "amazon.titan-text-express-v1"

    # template_type (Required)
    # 設定内容: 使用するプロンプトテンプレートのタイプを指定します。
    # 設定可能な値:
    #   - "TEXT": テキストベースのプロンプト。シンプルなテキスト入力に使用。
    #   - "CHAT": 会話形式のプロンプト。システムプロンプト、メッセージ履歴、ツール設定が可能。
    #             Converse APIをサポートするモデルでのみ使用可能。
    template_type = "TEXT"

    # additional_model_request_fields (Optional)
    # 設定内容: 標準の推論パラメータに含まれないモデル固有の設定をJSON形式で指定します。
    # 設定可能な値: JSON文字列
    # 用途: top_k（Anthropic Claudeモデル）など、モデル固有のパラメータを設定する場合に使用。
    # 参考: https://docs.aws.amazon.com/bedrock/latest/userguide/model-parameters.html
    additional_model_request_fields = null

    #-----------------------------------------------------------
    # メタデータ設定
    #-----------------------------------------------------------
    # バリアントに関連付けるメタデータタグを定義します。

    metadata {
      # key (Required)
      # 設定内容: メタデータタグのキーを指定します。
      key = "purpose"

      # value (Required)
      # 設定内容: メタデータタグの値を指定します。
      value = "playlist-generation"
    }

    #-----------------------------------------------------------
    # 推論設定
    #-----------------------------------------------------------
    # モデルの推論パラメータを設定します。

    inference_configuration {
      text {
        # max_tokens (Optional)
        # 設定内容: 生成されるレスポンスの最大トークン数を指定します。
        # 設定可能な値: 正の整数
        max_tokens = 1024

        # stop_sequences (Optional)
        # 設定内容: モデルが生成を停止する文字シーケンスのリストを指定します。
        # 設定可能な値: 文字列のリスト
        stop_sequences = ["END", "STOP"]

        # temperature (Optional)
        # 設定内容: 応答のランダム性を制御します。
        # 設定可能な値: 0.0〜1.0の浮動小数点数
        #   - 低い値: より予測可能で一貫した出力
        #   - 高い値: より創造的で多様な出力
        temperature = 0.8

        # top_p (Optional)
        # 設定内容: 次のトークンを選択する際に考慮する確率の累積閾値を指定します。
        # 設定可能な値: 0.0〜1.0の浮動小数点数
        # 用途: 出力の多様性を制御（nucleus sampling）
        top_p = 0.9
      }
    }

    #-----------------------------------------------------------
    # Generative AI リソース設定
    #-----------------------------------------------------------
    # model_idの代わりにエージェントを指定する場合に使用します。
    # model_idとgen_ai_resourceは排他的です。

    # gen_ai_resource {
    #   agent {
    #     # agent_identifier (Required)
    #     # 設定内容: プロンプトで使用するエージェントのARNを指定します。
    #     # 設定可能な値: 有効なBedrock AgentのARN
    #     agent_identifier = "arn:aws:bedrock:us-east-1:123456789012:agent/XXXXXXXXXX"
    #   }
    # }

    #-----------------------------------------------------------
    # テンプレート設定 (TEXT形式)
    #-----------------------------------------------------------
    # template_type = "TEXT" の場合に使用します。

    template_configuration {
      text {
        # text (Required)
        # 設定内容: プロンプトのメッセージテキストを指定します。
        # 設定可能な値: 文字列。変数は {{variable}} 形式で埋め込み可能。
        text = "Make me a {{genre}} playlist consisting of the following number of songs: {{number}}."

        # 入力変数の定義
        input_variable {
          # name (Required)
          # 設定内容: 変数の名前を指定します。
          # 注意: テンプレート内の {{variable}} と一致させる必要があります。
          name = "genre"
        }

        input_variable {
          name = "number"
        }

        # cache_point (Optional)
        # プロンプトキャッシュのチェックポイントを設定します。
        # キャッシュを使用することで、大きなプロンプトや頻繁に使用する
        # プロンプトのコストを削減できます。
        # 参考: https://docs.aws.amazon.com/bedrock/latest/userguide/prompt-caching.html

        # cache_point {
        #   # type (Required)
        #   # 設定内容: キャッシュポイントのタイプを指定します。
        #   # 設定可能な値:
        #   #   - "default": デフォルトのキャッシュポイント
        #   type = "default"
        # }
      }
    }
  }

  #-------------------------------------------------------------
  # バリアント設定 (CHAT形式の例)
  #-------------------------------------------------------------
  # template_type = "CHAT" の場合の設定例です。
  # Converse APIをサポートするモデルで使用できます。

  # variant {
  #   name          = "ChatVariant"
  #   model_id      = "anthropic.claude-3-sonnet-20240229-v1:0"
  #   template_type = "CHAT"
  #
  #   inference_configuration {
  #     text {
  #       max_tokens  = 2048
  #       temperature = 0.7
  #     }
  #   }
  #
  #   template_configuration {
  #     chat {
  #       #---------------------------------------------------------
  #       # 入力変数
  #       #---------------------------------------------------------
  #       input_variable {
  #         # name (Required)
  #         # 設定内容: 変数の名前を指定します。
  #         name = "topic"
  #       }
  #
  #       #---------------------------------------------------------
  #       # システムプロンプト
  #       #---------------------------------------------------------
  #       # モデルにコンテキストや振る舞いの指示を提供します。
  #
  #       system {
  #         # text (Optional)
  #         # 設定内容: システムプロンプトのテキストを指定します。
  #         text = "You are a helpful assistant that provides detailed explanations."
  #
  #         # cache_point (Optional)
  #         # システムプロンプトのキャッシュポイントを設定します。
  #         # cache_point {
  #         #   type = "default"
  #         # }
  #       }
  #
  #       #---------------------------------------------------------
  #       # メッセージ
  #       #---------------------------------------------------------
  #       # 会話履歴を構成するメッセージを定義します。
  #
  #       message {
  #         # role (Required)
  #         # 設定内容: メッセージの役割を指定します。
  #         # 設定可能な値:
  #         #   - "user": ユーザーからのメッセージ
  #         #   - "assistant": アシスタント（モデル）からのメッセージ
  #         role = "user"
  #
  #         content {
  #           # text (Optional)
  #           # 設定内容: メッセージのテキスト内容を指定します。
  #           text = "Please explain {{topic}} in detail."
  #
  #           # cache_point (Optional)
  #           # メッセージコンテンツのキャッシュポイントを設定します。
  #           # cache_point {
  #           #   type = "default"
  #           # }
  #         }
  #       }
  #
  #       #---------------------------------------------------------
  #       # ツール設定
  #       #---------------------------------------------------------
  #       # モデルが応答生成時に使用できるツールを定義します。
  #       # tool_configuration {
  #       #   #-------------------------------------------------------
  #       #   # ツール選択
  #       #   #-------------------------------------------------------
  #       #   # モデルがどのようにツールを選択するかを指定します。
  #       #
  #       #   tool_choice {
  #       #     # auto (Optional)
  #       #     # モデルが自動的にツールを呼び出すか、テキストを生成するか決定します。
  #       #     # 空のブロックとして指定します。
  #       #     auto {}
  #       #
  #       #     # any (Optional)
  #       #     # モデルに少なくとも1つのツールをリクエストさせます。
  #       #     # テキストは生成されず、ツール使用結果がモデルに返されます。
  #       #     # any {}
  #       #
  #       #     # tool (Optional)
  #       #     # 特定のツールをモデルにリクエストさせます。
  #       #     # tool {
  #       #     #   # name (Required)
  #       #     #   # 設定内容: リクエストするツールの名前を指定します。
  #       #     #   name = "get_weather"
  #       #     # }
  #       #   }
  #       #
  #       #   #-------------------------------------------------------
  #       #   # ツール定義
  #       #   #-------------------------------------------------------
  #       #   tool {
  #       #     # cache_point (Optional)
  #       #     # ツールのキャッシュポイントを設定します。
  #       #     # cache_point {
  #       #     #   type = "default"
  #       #     # }
  #       #
  #       #     tool_spec {
  #       #       # name (Required)
  #       #       # 設定内容: ツールの名前を指定します。
  #       #       name = "get_weather"
  #       #
  #       #       # description (Optional)
  #       #       # 設定内容: ツールの説明を指定します。
  #       #       description = "Get the current weather for a location"
  #       #
  #       #       # input_schema (Optional)
  #       #       # ツールの入力スキーマをJSON形式で定義します。
  #       #       input_schema {
  #       #         # json (Optional)
  #       #         # 設定内容: JSON Schema形式で入力スキーマを指定します。
  #       #         json = jsonencode({
  #       #           type = "object"
  #       #           properties = {
  #       #             location = {
  #       #               type        = "string"
  #       #               description = "The city and state, e.g. San Francisco, CA"
  #       #             }
  #       #           }
  #       #           required = ["location"]
  #       #         })
  #       #       }
  #       #     }
  #       #   }
  #       # }
  #     }
  #   }
  # }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: プロンプトのAmazon Resource Name (ARN)
#
# - id: プロンプトの一意の識別子
#
# - version: プロンプトのバージョン。作成時は "DRAFT" バージョンが作成されます。
#
# - created_at: プロンプトが作成された日時
#
# - updated_at: プロンプトが最後に更新された日時
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
