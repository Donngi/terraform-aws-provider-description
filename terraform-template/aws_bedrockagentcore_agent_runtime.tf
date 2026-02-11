#---------------------------------------------------------------
# AWS Bedrock AgentCore Agent Runtime
#---------------------------------------------------------------
#
# Amazon Bedrock AgentCore Agent Runtimeをプロビジョニングするリソースです。
# AgentCore Runtimeは、AIエージェントやツールをデプロイ・実行するための
# セキュアでサーバーレスなコンテナ実行環境を提供します。
# LangGraph、Strands、CrewAIなどのフレームワークに対応し、
# MCP（Model Context Protocol）やA2A（Agent to Agent）通信をサポートします。
#
# AWS公式ドキュメント:
#   - AgentCore Runtime概要: https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/agents-tools-runtime.html
#   - AgentCore概要: https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/what-is-bedrock-agentcore.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/bedrockagentcore_agent_runtime
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_bedrockagentcore_agent_runtime" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # agent_runtime_name (Required)
  # 設定内容: Agent Runtimeの名前を指定します。
  # 設定可能な値: 文字列
  agent_runtime_name = "example-agent-runtime"

  # role_arn (Required)
  # 設定内容: Agent RuntimeがAWSサービスにアクセスする際に使用するIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  # 注意: bedrock-agentcore.amazonaws.comをサービスプリンシパルとして信頼する必要があります。
  role_arn = "arn:aws:iam::123456789012:role/bedrock-agentcore-runtime-role"

  # description (Optional)
  # 設定内容: Agent Runtimeの説明を指定します。
  # 設定可能な値: 文字列
  description = "Example agent runtime for AI agent deployment"

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, us-west-2）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  # environment_variables (Optional)
  # 設定内容: コンテナに渡す環境変数のマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  environment_variables = {
    LOG_LEVEL = "INFO"
    ENV       = "production"
  }

  # lifecycle_configuration (Optional)
  # 設定内容: Agent Runtimeのセッションおよびリソースライフサイクル設定を指定します。
  # 形式: リストオブジェクト
  # 関連機能: AgentCore Runtimeライフサイクル設定
  #   アイドルセッションの自動クリーンアップやインスタンスの最大稼働時間を設定できます。
  #   - https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/runtime-lifecycle-settings.html
  # フィールド:
  #   - idle_runtime_session_timeout: アイドルセッションのタイムアウト（秒）。60〜28800秒。デフォルト: 900秒
  #   - max_lifetime: インスタンスの最大稼働時間（秒）。60〜28800秒。デフォルト: 28800秒
  # 注意: idle_runtime_session_timeoutはmax_lifetime以下である必要があります。
  lifecycle_configuration = [
    {
      idle_runtime_session_timeout = 900
      max_lifetime                 = 28800
    }
  ]

  #-------------------------------------------------------------
  # Agent Runtime Artifact設定（必須）
  #-------------------------------------------------------------
  # コンテナアーティファクトの設定を指定します。
  # code_configurationまたはcontainer_configurationのいずれか一方を指定します。

  agent_runtime_artifact {
    # コンテナイメージを使用する場合
    container_configuration {
      # container_uri (Required)
      # 設定内容: Amazon ECRのコンテナイメージURIを指定します。
      # 設定可能な値: 有効なECRイメージURI
      container_uri = "123456789012.dkr.ecr.us-east-1.amazonaws.com/my-agent:latest"
    }

    # S3からコードを取得する場合（container_configurationと排他）
    # code_configuration {
    #   # entry_point (Required)
    #   # 設定内容: コード実行のエントリーポイントを指定します。
    #   # 設定可能な値: 1〜2要素の文字列配列
    #   # 例: ["main.py"], ["opentelemetry-instrument", "main.py"]
    #   entry_point = ["main.py"]
    #
    #   # runtime (Required)
    #   # 設定内容: コードを実行するランタイム環境を指定します。
    #   # 設定可能な値:
    #   #   - "PYTHON_3_10": Python 3.10
    #   #   - "PYTHON_3_11": Python 3.11
    #   #   - "PYTHON_3_12": Python 3.12
    #   #   - "PYTHON_3_13": Python 3.13
    #   runtime = "PYTHON_3_13"
    #
    #   code {
    #     s3 {
    #       # bucket (Required)
    #       # 設定内容: ソースコードを格納するS3バケット名を指定します。
    #       bucket = "my-agent-code-bucket"
    #
    #       # prefix (Required)
    #       # 設定内容: ソースコードZIPファイルのS3オブジェクトキーを指定します。
    #       prefix = "agent-runtime-code.zip"
    #
    #       # version_id (Optional)
    #       # 設定内容: S3オブジェクトのバージョンIDを指定します。
    #       # 省略時: オブジェクトの最新バージョンを使用
    #       version_id = null
    #     }
    #   }
    # }
  }

  #-------------------------------------------------------------
  # Network Configuration設定（必須）
  #-------------------------------------------------------------

  network_configuration {
    # network_mode (Required)
    # 設定内容: Agent Runtimeのネットワークモードを指定します。
    # 設定可能な値:
    #   - "PUBLIC": パブリックネットワークモード。インターネットアクセス可能
    #   - "VPC": VPCネットワークモード。プライベートサブネットで実行
    network_mode = "PUBLIC"

    # network_mode_config (Optional)
    # 設定内容: VPCネットワークモード時の詳細設定を指定します。
    # 注意: network_modeが"VPC"の場合に必要
    # network_mode_config {
    #   # security_groups (Required)
    #   # 設定内容: VPC設定に関連付けるセキュリティグループを指定します。
    #   # 設定可能な値: セキュリティグループIDのセット
    #   security_groups = ["sg-0123456789abcdef0"]
    #
    #   # subnets (Required)
    #   # 設定内容: VPC設定に関連付けるサブネットを指定します。
    #   # 設定可能な値: サブネットIDのセット
    #   subnets = ["subnet-0123456789abcdef0", "subnet-0123456789abcdef1"]
    # }
  }

  #-------------------------------------------------------------
  # Authorizer Configuration設定（オプション）
  #-------------------------------------------------------------
  # 受信リクエストの認証設定を指定します。

  # authorizer_configuration {
  #   custom_jwt_authorizer {
  #     # discovery_url (Required)
  #     # 設定内容: OpenID Connect設定または認可サーバーメタデータを取得するURLを指定します。
  #     # 設定可能な値: .well-known/openid-configurationで終わるURL
  #     discovery_url = "https://accounts.google.com/.well-known/openid-configuration"
  #
  #     # allowed_audience (Optional)
  #     # 設定内容: JWTトークン検証で許可されるオーディエンス値のセットを指定します。
  #     # 設定可能な値: 文字列のセット
  #     allowed_audience = ["my-app", "mobile-app"]
  #
  #     # allowed_clients (Optional)
  #     # 設定内容: JWTトークン検証で許可されるクライアントIDのセットを指定します。
  #     # 設定可能な値: 文字列のセット
  #     allowed_clients = ["client-123", "client-456"]
  #   }
  # }

  #-------------------------------------------------------------
  # Protocol Configuration設定（オプション）
  #-------------------------------------------------------------

  # protocol_configuration {
  #   # server_protocol (Optional)
  #   # 設定内容: Agent Runtimeのサーバープロトコルを指定します。
  #   # 設定可能な値:
  #   #   - "HTTP": 標準HTTPプロトコル
  #   #   - "MCP": Model Context Protocol。エージェントとツール間の通信プロトコル
  #   #   - "A2A": Agent to Agent。エージェント間通信プロトコル
  #   # 関連機能: AgentCore Runtime プロトコルサポート
  #   #   MCPはエージェントをツールに接続し、A2Aは複数のエージェント間の
  #   #   コーディネーションを可能にします。
  #   server_protocol = "MCP"
  # }

  #-------------------------------------------------------------
  # Request Header Configuration設定（オプション）
  #-------------------------------------------------------------

  # request_header_configuration {
  #   # request_header_allowlist (Optional)
  #   # 設定内容: ランタイムにパススルーを許可するHTTPリクエストヘッダーのリストを指定します。
  #   # 設定可能な値: 文字列のセット
  #   request_header_allowlist = ["X-Custom-Header", "X-Request-ID"]
  # }

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
    Name        = "example-agent-runtime"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウトを指定します。
    # 設定可能な値: 時間を表す文字列（例: "30s", "2h45m"）
    # 有効な時間単位: "s"（秒）, "m"（分）, "h"（時間）
    create = "30m"

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウトを指定します。
    # 設定可能な値: 時間を表す文字列（例: "30s", "2h45m"）
    # 有効な時間単位: "s"（秒）, "m"（分）, "h"（時間）
    update = "30m"

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウトを指定します。
    # 設定可能な値: 時間を表す文字列（例: "30s", "2h45m"）
    # 有効な時間単位: "s"（秒）, "m"（分）, "h"（時間）
    delete = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - agent_runtime_arn: Agent RuntimeのAmazon Resource Name (ARN)
#
# - agent_runtime_id: Agent Runtimeの一意の識別子
#
# - agent_runtime_version: Agent Runtimeのバージョン
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#
# - workload_identity_details: Agent Runtimeのワークロードアイデンティティ詳細
#     - workload_identity_arn: ワークロードアイデンティティのARN
#---------------------------------------------------------------
