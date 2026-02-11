#---------------------------------------------------------------
# AWS Bedrock Agent
#---------------------------------------------------------------
#
# Amazon Bedrock Agentsのエージェントをプロビジョニングするリソースです。
# エージェントは、基盤モデル（Foundation Model）を使用してユーザーのリクエストを
# 理解し、アクショングループやナレッジベースと連携してタスクを自動化します。
#
# AWS公式ドキュメント:
#   - Amazon Bedrock Agents概要: https://docs.aws.amazon.com/bedrock/latest/userguide/agents.html
#   - エージェントの作成と設定: https://docs.aws.amazon.com/bedrock/latest/userguide/agents-create.html
#   - マルチエージェントコラボレーション: https://docs.aws.amazon.com/bedrock/latest/userguide/agents-multi-agent-collaboration.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/bedrockagent_agent
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_bedrockagent_agent" "example" {
  #-------------------------------------------------------------
  # 基本設定（必須）
  #-------------------------------------------------------------

  # agent_name (Required)
  # 設定内容: エージェントの名前を指定します。
  # 設定可能な値: 文字列
  agent_name = "my-bedrock-agent"

  # agent_resource_role_arn (Required)
  # 設定内容: エージェントがAPI操作を呼び出すための権限を持つIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  # 関連機能: エージェントサービスロール
  #   bedrock.amazonaws.comサービスプリンシパルからの信頼関係が必要です。
  #   基盤モデルのInvokeModel権限、ナレッジベースやアクショングループへのアクセス権限を含める必要があります。
  #   - https://docs.aws.amazon.com/bedrock/latest/userguide/agents-permissions.html
  agent_resource_role_arn = "arn:aws:iam::123456789012:role/AmazonBedrockExecutionRoleForAgents_example"

  # foundation_model (Required)
  # 設定内容: エージェントのオーケストレーションに使用する基盤モデルを指定します。
  # 設定可能な値: モデルID（例: "anthropic.claude-v2", "anthropic.claude-3-sonnet-20240229-v1:0"）
  # 関連機能: Amazon Bedrock基盤モデル
  #   エージェントはこのモデルを使用してユーザー入力を解析し、
  #   アクショングループやナレッジベースの呼び出しを判断します。
  #   - https://docs.aws.amazon.com/bedrock/latest/userguide/models-supported.html
  foundation_model = "anthropic.claude-v2"

  #-------------------------------------------------------------
  # エージェント説明・指示設定
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: エージェントの説明を指定します。
  # 設定可能な値: 文字列
  description = "Example Bedrock Agent for demonstration purposes"

  # instruction (Optional)
  # 設定内容: エージェントが何をすべきか、ユーザーとどのように対話すべきかを説明する指示を指定します。
  # 設定可能な値: 40〜20,000文字の文字列
  # 注意: prepare_agentがtrueの場合、この引数は必須です。
  # 関連機能: エージェント指示
  #   指示はオーケストレーションプロンプトテンプレートの$instructions$プレースホルダーに置換されます。
  #   - https://docs.aws.amazon.com/bedrock/latest/userguide/agents-create.html
  instruction = "You are a friendly assistant who helps answer questions. Be polite and provide accurate information."

  #-------------------------------------------------------------
  # セッション・タイムアウト設定
  #-------------------------------------------------------------

  # idle_session_ttl_in_seconds (Optional)
  # 設定内容: Amazon Bedrockがユーザーとエージェントの会話情報を保持する秒数を指定します。
  # 設定可能な値: 60〜3600の整数（デフォルト: 1800秒 = 30分）
  # 関連機能: セッションタイムアウト
  #   この時間内に会話がない場合、セッションは終了し、タイムアウト前に提供されたデータは削除されます。
  #   - https://docs.aws.amazon.com/bedrock/latest/userguide/agents-create.html
  idle_session_ttl_in_seconds = 1800

  #-------------------------------------------------------------
  # マルチエージェントコラボレーション設定
  #-------------------------------------------------------------

  # agent_collaboration (Optional)
  # 設定内容: エージェントのコラボレーションロールを指定します。
  # 設定可能な値:
  #   - "SUPERVISOR": スーパーバイザーエージェントとして動作。複雑なリクエストを分解し、サブエージェントにタスクを委任
  #   - "SUPERVISOR_ROUTER": スーパーバイザー+ルーティングモード。単純なクエリは関連サブエージェントに直接ルーティング
  #   - "DISABLED": マルチエージェントコラボレーションを無効化
  # 関連機能: マルチエージェントコラボレーション
  #   複数のAmazon Bedrockエージェントが連携して複雑なタスクを効率的に解決できます。
  #   - https://docs.aws.amazon.com/bedrock/latest/userguide/agents-multi-agent-collaboration.html
  agent_collaboration = "DISABLED"

  #-------------------------------------------------------------
  # 暗号化設定
  #-------------------------------------------------------------

  # customer_encryption_key_arn (Optional)
  # 設定内容: エージェントリソースを暗号化するAWS KMSキーのARNを指定します。
  # 設定可能な値: 有効なKMSキーARN
  # 省略時: AWSマネージドキーで暗号化
  # 関連機能: カスタマーマネージドキーによる暗号化
  #   エージェントリソースをカスタマーマネージドキーで暗号化できます。
  customer_encryption_key_arn = null

  #-------------------------------------------------------------
  # ガードレール設定
  #-------------------------------------------------------------

  # guardrail_configuration (Optional)
  # 設定内容: エージェントに関連付けるガードレールの詳細を指定します。
  # 関連機能: Amazon Bedrockガードレール
  #   有害コンテンツのブロックとフィルタリングを行います。
  #   - https://docs.aws.amazon.com/bedrock/latest/userguide/guardrails.html
  guardrail_configuration = [
    {
      # guardrail_identifier (Optional)
      # 設定内容: ガードレールの一意の識別子（IDまたはARN）を指定します。
      guardrail_identifier = "abc123def456"

      # guardrail_version (Optional)
      # 設定内容: ガードレールのバージョンを指定します。
      # 設定可能な値: バージョン番号の文字列（例: "1", "DRAFT"）
      guardrail_version = "1"
    }
  ]

  #-------------------------------------------------------------
  # メモリ設定
  #-------------------------------------------------------------

  # memory_configuration (Optional)
  # 設定内容: エージェントのメモリ設定を指定します。
  # 関連機能: エージェントメモリ
  #   複数セッション間で会話コンテキストを保持し、過去のアクションや動作を呼び出すことができます。
  #   - https://docs.aws.amazon.com/bedrock/latest/userguide/agents-memory.html
  memory_configuration = [
    {
      # enabled_memory_types (Required in block)
      # 設定内容: エージェントが保存するメモリのタイプを指定します。
      # 設定可能な値: ["SESSION_SUMMARY"]
      # 関連機能: セッションサマリーメモリ
      #   セッション終了後、エージェントは会話の要約版を生成して保存します。
      enabled_memory_types = ["SESSION_SUMMARY"]

      # storage_days (Optional)
      # 設定内容: エージェントが会話コンテキストを保持する日数を指定します。
      # 設定可能な値: 0〜30の整数
      storage_days = 30

      # session_summary_configuration (Optional)
      # 設定内容: SESSION_SUMMARYメモリタイプの設定ブロックです。
      session_summary_configuration = [
        {
          # max_recent_sessions (Optional)
          # 設定内容: エージェントのプロンプトコンテキストに含める最近のセッションサマリーの最大数を指定します。
          max_recent_sessions = 5
        }
      ]
    }
  ]

  #-------------------------------------------------------------
  # プロンプトオーバーライド設定
  #-------------------------------------------------------------

  # prompt_override_configuration (Optional)
  # 設定内容: エージェントシーケンスの各パートでプロンプトテンプレートをオーバーライドする設定を指定します。
  # 関連機能: 高度なプロンプト
  #   エージェントの精度を向上させるためにプロンプトテンプレートを変更できます。
  #   - https://docs.aws.amazon.com/bedrock/latest/userguide/advanced-prompts.html
  prompt_override_configuration = [
    {
      # override_lambda (Optional)
      # 設定内容: エージェントシーケンスの一部で生のFM出力をパースするために使用するLambda関数のARNを指定します。
      # 注意: このフィールドを指定する場合、少なくとも1つのprompt_configurationsでparser_modeを"OVERRIDDEN"に設定する必要があります。
      override_lambda = null

      # prompt_configurations (Required in block)
      # 設定内容: エージェントシーケンスの各パートでプロンプトテンプレートをオーバーライドする設定の配列です。
      prompt_configurations = [
        {
          # prompt_type (Required)
          # 設定内容: このプロンプト設定が適用されるエージェントシーケンスのステップを指定します。
          # 設定可能な値:
          #   - "PRE_PROCESSING": 前処理ステップ
          #   - "ORCHESTRATION": オーケストレーションステップ
          #   - "POST_PROCESSING": 後処理ステップ
          #   - "KNOWLEDGE_BASE_RESPONSE_GENERATION": ナレッジベースレスポンス生成ステップ
          prompt_type = "ORCHESTRATION"

          # prompt_creation_mode (Required)
          # 設定内容: このprompt_typeのデフォルトプロンプトテンプレートをオーバーライドするかを指定します。
          # 設定可能な値:
          #   - "DEFAULT": デフォルトのプロンプトテンプレートを使用
          #   - "OVERRIDDEN": base_prompt_templateで提供したプロンプトを使用
          prompt_creation_mode = "DEFAULT"

          # prompt_state (Required)
          # 設定内容: エージェントがprompt_typeで指定されたステップを実行するかを指定します。
          # 設定可能な値:
          #   - "ENABLED": ステップを実行
          #   - "DISABLED": ステップをスキップ
          prompt_state = "ENABLED"

          # parser_mode (Required)
          # 設定内容: エージェントシーケンスの該当部分でデフォルトのパーサーLambda関数をオーバーライドするかを指定します。
          # 設定可能な値:
          #   - "DEFAULT": デフォルトのパーサーを使用
          #   - "OVERRIDDEN": override_lambdaで指定したLambda関数を使用
          parser_mode = "DEFAULT"

          # base_prompt_template (Required)
          # 設定内容: デフォルトのプロンプトテンプレートを置き換えるプロンプトテンプレートを指定します。
          # 関連機能: プレースホルダー変数
          #   $instructions$、$agent_scratchpad$などのプレースホルダー変数を使用してプロンプトをカスタマイズできます。
          #   - https://docs.aws.amazon.com/bedrock/latest/userguide/prompt-placeholders.html
          base_prompt_template = "You are an AI assistant. $instructions$"

          # inference_configuration (Required)
          # 設定内容: エージェントがこのステップでFMを呼び出す際に使用する推論パラメータを指定します。
          # 関連機能: 基盤モデルの推論パラメータ
          #   - https://docs.aws.amazon.com/bedrock/latest/userguide/model-parameters.html
          inference_configuration = [
            {
              # max_length (Required)
              # 設定内容: 生成されるレスポンスで許可される最大トークン数を指定します。
              max_length = 2048

              # temperature (Required)
              # 設定内容: モデルがレスポンスを生成する際に高確率オプションを選択する可能性を指定します。
              # 設定可能な値: 0〜1の小数
              # 低い値: より予測可能なレスポンス
              # 高い値: より創造的なレスポンス
              temperature = 0.7

              # top_p (Required)
              # 設定内容: モデルが次のトークンを選択する確率分布の上位パーセンテージを指定します。
              # 設定可能な値: 0〜1の小数（0%〜100%を表す）
              top_p = 0.9

              # top_k (Required)
              # 設定内容: モデルがシーケンス内の次のトークンを選択する際の最も可能性の高い候補の数を指定します。
              # 設定可能な値: 0〜500の整数
              top_k = 250

              # stop_sequences (Required)
              # 設定内容: ストップシーケンスのリストを指定します。
              # 関連機能: ストップシーケンス
              #   モデルがレスポンスの生成を停止する原因となる文字列のシーケンスです。
              stop_sequences = []
            }
          ]
        }
      ]
    }
  ]

  #-------------------------------------------------------------
  # エージェント準備設定
  #-------------------------------------------------------------

  # prepare_agent (Optional)
  # 設定内容: エージェントの作成または更新後に自動的に準備（Prepare）するかを指定します。
  # 設定可能な値:
  #   - true: エージェントを自動的に準備
  #   - false (デフォルト): 手動で準備が必要
  # 関連機能: エージェントの準備
  #   エージェントをテストまたはデプロイする前に準備が必要です。
  #   準備により、エージェントの設定が検証され、使用可能な状態になります。
  prepare_agent = true

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
  # 削除設定
  #-------------------------------------------------------------

  # skip_resource_in_use_check (Optional)
  # 設定内容: エージェント削除時に使用中チェックをスキップするかを指定します。
  # 設定可能な値:
  #   - true: 使用中チェックをスキップして削除
  #   - false (デフォルト): 使用中の場合は削除をブロック
  skip_resource_in_use_check = false

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "my-bedrock-agent"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "30s", "5m", "1h"）
    create = "5m"

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "30s", "5m", "1h"）
    update = "5m"

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "30s", "5m", "1h"）
    delete = "5m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - agent_arn: エージェントのAmazon Resource Name (ARN)
#
# - agent_id: エージェントの一意の識別子
#
# - agent_version: エージェントのバージョン
#
# - id: エージェントの一意の識別子（agent_idと同じ）
#
# - prepared_at: エージェントが最後に準備されたタイムスタンプ
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
