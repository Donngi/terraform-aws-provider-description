#---------------------------------------------------------------
# AWS Bedrock AgentCore Agent Runtime Endpoint
#---------------------------------------------------------------
#
# Amazon Bedrock AgentCore Agent Runtime Endpointをプロビジョニングする
# リソースです。Agent Runtime Endpointは、Agent Runtimeに対する
# ネットワークアクセス可能なインターフェースを提供し、外部システムが
# エージェントの機能を呼び出して通信することを可能にします。
#
# AWS公式ドキュメント:
#   - Amazon Bedrock AgentCore概要: https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/what-is-bedrock-agentcore.html
#   - Agent Runtime Endpoint API: https://docs.aws.amazon.com/bedrock-agentcore-control/latest/APIReference/API_AgentRuntimeEndpoint.html
#   - CreateAgentRuntimeEndpoint API: https://docs.aws.amazon.com/bedrock-agentcore-control/latest/APIReference/API_CreateAgentRuntimeEndpoint.html
#   - Agent Runtimeの呼び出し: https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/runtime-invoke-agent.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/bedrockagentcore_agent_runtime_endpoint
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_bedrockagentcore_agent_runtime_endpoint" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: Agent Runtime Endpointの名前を指定します。
  # 設定可能な値: 文字列
  # 用途: エンドポイントを識別するための名前
  name = "example-endpoint"

  # agent_runtime_id (Required)
  # 設定内容: このエンドポイントが属するAgent RuntimeのIDを指定します。
  # 設定可能な値: 有効なAgent Runtime ID
  # 用途: エンドポイントを特定のAgent Runtimeに関連付けます
  # 参照: aws_bedrockagentcore_agent_runtime リソースの agent_runtime_id 属性
  agent_runtime_id = aws_bedrockagentcore_agent_runtime.example.agent_runtime_id

  #-------------------------------------------------------------
  # オプション設定
  #-------------------------------------------------------------

  # agent_runtime_version (Optional)
  # 設定内容: このエンドポイントで使用するAgent Runtimeのバージョンを指定します。
  # 設定可能な値: 有効なバージョン文字列
  # 省略時: Agent Runtimeのデフォルトバージョンが使用されます
  # 用途: 特定のバージョンのAgent Runtimeにエンドポイントを固定する場合に指定
  agent_runtime_version = null

  # description (Optional)
  # 設定内容: Agent Runtime Endpointの説明を指定します。
  # 設定可能な値: 文字列
  # 省略時: 説明なし
  # 用途: エンドポイントの目的や用途を説明するテキスト
  description = "Endpoint for agent runtime communication"

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
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "example-agent-runtime-endpoint"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "30s", "5m", "1h"）
    # 省略時: デフォルトのタイムアウト値が適用されます
    # 参考: https://pkg.go.dev/time#ParseDuration
    create = null

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "30s", "5m", "1h"）
    # 省略時: デフォルトのタイムアウト値が適用されます
    # 参考: https://pkg.go.dev/time#ParseDuration
    update = null

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "30s", "5m", "1h"）
    # 省略時: デフォルトのタイムアウト値が適用されます
    # 参考: https://pkg.go.dev/time#ParseDuration
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - agent_runtime_endpoint_arn: Agent Runtime EndpointのARN
#
# - agent_runtime_arn: 関連付けられたAgent RuntimeのARN
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
