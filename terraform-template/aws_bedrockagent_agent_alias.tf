#---------------------------------------------------------------
# AWS Bedrock Agent Alias
#---------------------------------------------------------------
#
# Amazon Bedrock Agentsのエージェントエイリアスをプロビジョニングするリソースです。
# エイリアスは、エージェントの特定バージョンへのポインターとして機能し、
# アプリケーションからエージェントを呼び出す際の安定したエンドポイントを提供します。
# エイリアスを使用することで、基盤となる実装を更新しながらも、
# アプリケーション側のエンドポイントを維持できます。
#
# AWS公式ドキュメント:
#   - Bedrock Agents概要: https://docs.aws.amazon.com/bedrock/latest/userguide/agents.html
#   - エージェントのデプロイ: https://docs.aws.amazon.com/bedrock/latest/userguide/deploy-agent.html
#   - エイリアスの作成: https://docs.aws.amazon.com/bedrock/latest/userguide/deploy-agent-proc.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/bedrockagent_agent_alias
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_bedrockagent_agent_alias" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # agent_alias_name (Required)
  # 設定内容: エイリアスの名前を指定します。
  # 設定可能な値: 一意の文字列
  # 用途: アプリケーションからエージェントを呼び出す際の識別子として使用
  agent_alias_name = "my-agent-alias"

  # agent_id (Required, Forces new resource)
  # 設定内容: エイリアスを作成する対象のエージェントIDを指定します。
  # 設定可能な値: 有効なBedrock AgentのID
  # 注意: 変更すると新しいリソースが作成されます
  agent_id = "XXXXXXXXXX"

  #-------------------------------------------------------------
  # オプション設定
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: エイリアスの説明を指定します。
  # 設定可能な値: 任意の文字列
  # 用途: エイリアスの目的や用途を記録するために使用
  description = "Production alias for my agent"

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # ルーティング設定
  #-------------------------------------------------------------

  # routing_configuration (Optional)
  # 設定内容: エイリアスのルーティング設定を指定します。
  # 用途: エイリアスが指すエージェントバージョンとプロビジョニングスループットを設定
  # 関連機能: Bedrock Agents バージョニングとプロビジョニングスループット
  #   エイリアスを特定のバージョンに関連付け、推論のスループットを制御できます。
  #   - https://docs.aws.amazon.com/bedrock/latest/userguide/prov-throughput.html
  routing_configuration = [
    {
      # agent_version (Optional)
      # 設定内容: エイリアスに関連付けるエージェントのバージョンを指定します。
      # 設定可能な値: エージェントのバージョン番号（例: "1", "2"）
      # 省略時: 新しいバージョンが自動的に作成されます
      agent_version = "1"

      # provisioned_throughput (Optional)
      # 設定内容: エイリアスに割り当てるプロビジョンドスループットのARNを指定します。
      # 設定可能な値: 有効なプロビジョンドスループットのARN
      # 省略時: オンデマンドスループット（ODT）が使用されます
      # 関連機能: Bedrock プロビジョンドスループット
      #   事前に購入したプロビジョンドスループットを使用して、
      #   モデル推論のレートを向上させることができます。
      #   - https://docs.aws.amazon.com/bedrock/latest/userguide/prov-throughput.html
      provisioned_throughput = null
    }
  ]

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
    Name        = "my-agent-alias"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定します。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "30s", "5m", "2h45m"）
    # 有効な時間単位: "s" (秒), "m" (分), "h" (時間)
    create = null

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "30s", "5m", "2h45m"）
    # 有効な時間単位: "s" (秒), "m" (分), "h" (時間)
    update = null

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "30s", "5m", "2h45m"）
    # 有効な時間単位: "s" (秒), "m" (分), "h" (時間)
    # 注意: 削除操作のタイムアウトは、destroy操作の前に状態が保存される場合にのみ適用されます
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - agent_alias_arn: エイリアスのAmazon Resource Name (ARN)
#
# - agent_alias_id: エイリアスの一意な識別子
#
# - id: エイリアスIDとエージェントIDをカンマで区切った値
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
