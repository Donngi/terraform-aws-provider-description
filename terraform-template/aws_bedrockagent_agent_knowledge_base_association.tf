#---------------------------------------------------------------
# AWS Bedrock Agent Knowledge Base Association
#---------------------------------------------------------------
#
# Amazon Bedrock AgentとKnowledge Baseの関連付けを管理するリソースです。
# この関連付けにより、AgentはKnowledge Baseに格納された情報を使用して
# RAG（Retrieval Augmented Generation）によるレスポンス生成を行うことができます。
#
# AWS公式ドキュメント:
#   - Knowledge Baseの追加: https://docs.aws.amazon.com/bedrock/latest/userguide/agents-kb-add.html
#   - AssociateAgentKnowledgeBase API: https://docs.aws.amazon.com/bedrock/latest/APIReference/API_agent_AssociateAgentKnowledgeBase.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/bedrockagent_agent_knowledge_base_association
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_bedrockagent_agent_knowledge_base_association" "example" {
  #-------------------------------------------------------------
  # Agent設定
  #-------------------------------------------------------------

  # agent_id (Required, Forces new resource)
  # 設定内容: Knowledge Baseを関連付けるAgentの一意識別子を指定します。
  # 設定可能な値: 10文字の英数字文字列（例: "GGRRAED6JP"）
  # 関連機能: Amazon Bedrock Agents
  #   Agentは、ユーザーのリクエストを理解し、適切なアクションを実行する
  #   自律型AIアシスタントです。Knowledge Baseと連携することで、
  #   カスタムデータソースからの情報を活用した回答が可能になります。
  #   - https://docs.aws.amazon.com/bedrock/latest/userguide/agents.html
  agent_id = "GGRRAED6JP"

  # agent_version (Optional, Forces new resource)
  # 設定内容: Knowledge Baseを関連付けるAgentのバージョンを指定します。
  # 設定可能な値:
  #   - "DRAFT": ドラフトバージョン（編集可能な作業中のバージョン）
  # 省略時: DRAFTバージョンが使用されます
  # 注意: 現時点で有効な値は "DRAFT" のみです。
  agent_version = "DRAFT"

  #-------------------------------------------------------------
  # Knowledge Base設定
  #-------------------------------------------------------------

  # knowledge_base_id (Required, Forces new resource)
  # 設定内容: Agentに関連付けるKnowledge Baseの一意識別子を指定します。
  # 設定可能な値: 10文字の英数字文字列（例: "EMDPPAYPZI"）
  # 関連機能: Amazon Bedrock Knowledge Bases
  #   Knowledge Baseは、RAG（Retrieval Augmented Generation）を実現するための
  #   データストアです。S3などのデータソースと連携し、ベクトル検索により
  #   関連情報を取得してLLMの回答を強化します。
  #   - https://docs.aws.amazon.com/bedrock/latest/userguide/knowledge-base.html
  knowledge_base_id = "EMDPPAYPZI"

  # knowledge_base_state (Required)
  # 設定内容: InvokeAgentリクエスト時にKnowledge Baseを使用するかどうかを指定します。
  # 設定可能な値:
  #   - "ENABLED": Knowledge Baseを有効化し、エージェントの回答生成に使用します
  #   - "DISABLED": Knowledge Baseを無効化し、一時的に使用を停止します
  # 関連機能: InvokeAgent API
  #   エージェントを呼び出す際に、関連付けられたKnowledge Baseの状態に基づいて
  #   RAGによる情報取得が実行されます。
  #   - https://docs.aws.amazon.com/bedrock/latest/APIReference/API_agent-runtime_InvokeAgent.html
  knowledge_base_state = "ENABLED"

  # description (Required)
  # 設定内容: AgentがKnowledge Baseをどのように使用すべきかの説明を指定します。
  # 設定可能な値: 1-200文字の文字列
  # 用途: この説明は、Agentがユーザーからの質問に対してKnowledge Baseを
  #       参照すべきかどうかを判断する際の指針として使用されます。
  #       明確で具体的な説明を記載することで、適切なタイミングでの
  #       Knowledge Base活用が促進されます。
  description = "Example Knowledge base for retrieving product documentation"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, us-west-2, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 注意: Amazon Bedrock Agentsは一部のリージョンでのみ利用可能です。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "30s", "5m", "1h"）
    #   - "s": 秒
    #   - "m": 分
    #   - "h": 時間
    # 省略時: デフォルトのタイムアウト値が使用されます
    create = "5m"

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "30s", "5m", "1h"）
    #   - "s": 秒
    #   - "m": 分
    #   - "h": 時間
    # 省略時: デフォルトのタイムアウト値が使用されます
    update = "5m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: Agent ID、Agentバージョン、Knowledge Base IDをカンマ区切りで
#       連結した文字列（例: "GGRRAED6JP,DRAFT,EMDPPAYPZI"）
#---------------------------------------------------------------
