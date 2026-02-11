#---------------------------------------------------------------
# AWS Bedrock Agents Agent Collaborator
#---------------------------------------------------------------
#
# Amazon Bedrock Agentsのマルチエージェントコラボレーション機能における
# コラボレーターエージェントを管理するリソースです。
# マルチエージェントコラボレーションでは、スーパーバイザーエージェントが
# 複数のコラボレーターエージェントを調整し、複雑なタスクを効率的に処理します。
#
# AWS公式ドキュメント:
#   - マルチエージェントコラボレーション概要: https://docs.aws.amazon.com/bedrock/latest/userguide/agents-multi-agent-collaboration.html
#   - マルチエージェントコラボレーションの作成: https://docs.aws.amazon.com/bedrock/latest/userguide/create-multi-agent-collaboration.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/bedrockagent_agent_collaborator
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_bedrockagent_agent_collaborator" "example" {
  #-------------------------------------------------------------
  # 基本設定（必須）
  #-------------------------------------------------------------

  # agent_id (Required)
  # 設定内容: コラボレーターを関連付けるスーパーバイザーエージェントのIDを指定します。
  # 設定可能な値: 既存のBedrock AgentのID（例: "ABCD1234EF"）
  # 注意: agent_collaborationが"SUPERVISOR"または"SUPERVISOR_ROUTER"に設定された
  #       エージェントのIDである必要があります。
  agent_id = aws_bedrockagent_agent.supervisor.agent_id

  # collaborator_name (Required)
  # 設定内容: コラボレーターの名前を指定します。
  # 設定可能な値: 任意の文字列
  # 用途: スーパーバイザーエージェントがコラボレーターを識別するために使用します。
  collaborator_name = "my-collaborator-agent"

  # collaboration_instruction (Required)
  # 設定内容: コラボレーターへの指示を指定します。
  # 設定可能な値: 任意の文字列
  # 用途: スーパーバイザーエージェントがこのコラボレーターにタスクを委任する際の
  #       ガイダンスとして使用されます。コラボレーターの役割と責任を明確に記述します。
  collaboration_instruction = "Handle customer inquiries about existing mortgages and provide account information."

  #-------------------------------------------------------------
  # コラボレーター設定（オプション）
  #-------------------------------------------------------------

  # agent_version (Optional)
  # 設定内容: コラボレーターとして使用するエージェントのバージョンを指定します。
  # 設定可能な値: エージェントのバージョン番号（例: "1", "DRAFT"）
  # 省略時: 最新のバージョンが使用されます。
  agent_version = null

  # prepare_agent (Optional)
  # 設定内容: コラボレーター作成後にスーパーバイザーエージェントを準備するかを指定します。
  # 設定可能な値:
  #   - true: コラボレーター作成後にエージェントを自動的に準備（PrepareAgent APIを呼び出し）
  #   - false: エージェントを準備しない
  # 省略時: 自動的に決定されます。
  # 注意: エージェントを準備すると、変更が反映されテスト可能な状態になります。
  prepare_agent = true

  # relay_conversation_history (Optional)
  # 設定内容: 会話履歴をコラボレーターに中継するかを設定します。
  # 設定可能な値:
  #   - "TO_COLLABORATOR": スーパーバイザーからコラボレーターへ会話履歴を中継
  #   - "DISABLED": 会話履歴を中継しない
  # 省略時: デフォルト値が適用されます。
  # 関連機能: マルチエージェントコラボレーション
  #   会話履歴の中継により、コラボレーターはコンテキストを理解した上で
  #   タスクを実行できます。
  relay_conversation_history = "TO_COLLABORATOR"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, us-west-2, eu-west-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 注意: マルチエージェントコラボレーションは特定のリージョンでのみ利用可能です。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # エージェント記述子設定
  #-------------------------------------------------------------

  # agent_descriptor (Required Block)
  # 設定内容: コラボレーターとして使用するエージェントの情報を指定します。
  agent_descriptor {
    # alias_arn (Required)
    # 設定内容: コラボレーターとして使用するエージェントエイリアスのARNを指定します。
    # 設定可能な値: 有効なBedrock Agent Alias ARN
    #   フォーマット: arn:aws:bedrock:{region}:{account-id}:agent-alias/{agent-id}/{alias-id}
    # 注意: エージェントエイリアスは事前に作成しておく必要があります。
    alias_arn = aws_bedrockagent_agent_alias.collaborator.agent_alias_arn
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional Block)
  # 設定内容: リソース操作のタイムアウト時間を指定します。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "30s", "5m", "1h"）
    # 省略時: デフォルトのタイムアウト値が使用されます。
    create = "5m"

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "30s", "5m", "1h"）
    # 省略時: デフォルトのタイムアウト値が使用されます。
    update = "5m"

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "30s", "5m", "1h"）
    # 省略時: デフォルトのタイムアウト値が使用されます。
    # 注意: 削除操作のタイムアウトは、destroy操作前に状態が保存された場合のみ適用されます。
    delete = "5m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: リソースの識別子
#       フォーマット: {agent_id},{agent_version},{collaborator_id}
#
# - collaborator_id: エージェントコラボレーターのID
#
#---------------------------------------------------------------
