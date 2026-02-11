#---------------------------------------------------------------
# AWS Bedrock AgentCore Gateway
#---------------------------------------------------------------
#
# Amazon Bedrock AgentCore Gatewayをプロビジョニングするリソースです。
# Gatewayは、API、Lambda関数、既存のサービスをModel Context Protocol (MCP)
# 互換のツールに変換し、AIエージェントがツールを発見・アクセス・呼び出しできる
# 統一されたインターフェースを提供します。
#
# AWS公式ドキュメント:
#   - Amazon Bedrock AgentCore Gateway概要: https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/gateway.html
#   - Gateway作成ガイド: https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/gateway-create.html
#   - Gatewayコアコンセプト: https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/gateway-core-concepts.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/bedrockagentcore_gateway
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_bedrockagentcore_gateway" "example" {
  #-------------------------------------------------------------
  # 基本設定（必須）
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: Gatewayの名前を指定します。
  # 設定可能な値: 文字列
  name = "example-gateway"

  # authorizer_type (Required)
  # 設定内容: 使用する認証タイプを指定します。
  # 設定可能な値:
  #   - "CUSTOM_JWT": カスタムJWT認証。authorizer_configurationブロックが必須となります
  #   - "AWS_IAM": AWS IAM認証
  # 関連機能: Gateway認証
  #   MCPはOAuthのみをサポートするため、各GatewayにはOAuth認証が必要です。
  #   CUSTOM_JWTを選択した場合、JWTトークン検証のための設定が必要です。
  authorizer_type = "CUSTOM_JWT"

  # protocol_type (Required)
  # 設定内容: Gatewayのプロトコルタイプを指定します。
  # 設定可能な値:
  #   - "MCP": Model Context Protocol
  # 関連機能: Model Context Protocol (MCP)
  #   MCPは、AIエージェントとツール間の標準化された通信プロトコルです。
  protocol_type = "MCP"

  # role_arn (Required)
  # 設定内容: GatewayがAWSサービスにアクセスする際に引き受けるIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  # 注意: ロールの信頼ポリシーでbedrock-agentcore.amazonaws.comを許可する必要があります。
  role_arn = "arn:aws:iam::123456789012:role/bedrock-agentcore-gateway-role"

  #-------------------------------------------------------------
  # オプション設定
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: Gatewayの説明を指定します。
  # 設定可能な値: 文字列
  description = "Gateway for MCP communication"

  # exception_level (Optional)
  # 設定内容: Gatewayの例外レベルを指定します。
  # 設定可能な値:
  #   - "INFO": 情報レベル
  #   - "WARN": 警告レベル
  #   - "ERROR": エラーレベル
  # 用途: デバッグ時に詳細なエラーメッセージを取得するために使用
  # 注意: 本番環境にデプロイする前に適切なレベルに設定してください。
  exception_level = "ERROR"

  # kms_key_arn (Optional)
  # 設定内容: Gatewayデータの暗号化に使用するKMSキーのARNを指定します。
  # 設定可能な値: 有効なKMSキーARN
  # 関連機能: カスタム暗号化
  #   AWS管理キーの代わりにカスタムAWS KMSキーでGatewayを暗号化します。
  #   - https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/gateway-features.html
  kms_key_arn = "arn:aws:kms:ap-northeast-1:123456789012:key/12345678-1234-1234-1234-123456789012"

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
  # 認証設定
  #-------------------------------------------------------------

  # authorizer_configuration (Optional)
  # 設定内容: リクエスト認証の設定を指定します。
  # 注意: authorizer_typeが"CUSTOM_JWT"の場合は必須
  authorizer_configuration {
    # custom_jwt_authorizer (Required within authorizer_configuration)
    # 設定内容: JWTベースの認証設定を指定します。
    custom_jwt_authorizer {
      # discovery_url (Required)
      # 設定内容: OpenID Connect設定または認証サーバーメタデータを取得するURLを指定します。
      # 設定可能な値: .well-known/openid-configurationで終わるURL
      # 例: Google認証の場合 "https://accounts.google.com/.well-known/openid-configuration"
      discovery_url = "https://accounts.google.com/.well-known/openid-configuration"

      # allowed_audience (Optional)
      # 設定内容: JWTトークン検証で許可されるaudience値のセットを指定します。
      # 設定可能な値: 文字列のセット
      allowed_audience = ["app-client", "web-client"]

      # allowed_clients (Optional)
      # 設定内容: JWTトークン検証で許可されるクライアントIDのセットを指定します。
      # 設定可能な値: 文字列のセット
      allowed_clients = ["client-123", "client-456"]
    }
  }

  #-------------------------------------------------------------
  # プロトコル設定
  #-------------------------------------------------------------

  # protocol_configuration (Optional)
  # 設定内容: プロトコル固有の設定を指定します。
  protocol_configuration {
    # mcp (Optional)
    # 設定内容: Model Context Protocol (MCP) の設定を指定します。
    mcp {
      # instructions (Optional)
      # 設定内容: MCPプロトコル設定の指示を指定します。
      # 設定可能な値: 文字列
      instructions = "Gateway for handling MCP requests"

      # search_type (Optional)
      # 設定内容: MCPの検索タイプを指定します。
      # 設定可能な値:
      #   - "SEMANTIC": セマンティック検索。自然言語クエリでツールを検索可能
      #   - "HYBRID": ハイブリッド検索
      # 関連機能: ツールのセマンティック検索
      #   自然言語クエリを使用してGateway内のツールを検索できます。
      #   Gateway作成時にのみ有効化可能で、作成者にはbedrock-agentcore:SynchronizeGatewayTargets
      #   IAMアクションが必要です。
      #   - https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/gateway-features.html
      search_type = "SEMANTIC"

      # supported_versions (Optional)
      # 設定内容: サポートするMCPプロトコルバージョンのセットを指定します。
      # 設定可能な値: バージョン文字列のセット
      supported_versions = ["2025-03-26", "2025-06-18"]
    }
  }

  #-------------------------------------------------------------
  # インターセプター設定
  #-------------------------------------------------------------

  # interceptor_configuration (Optional)
  # 設定内容: Gatewayのインターセプター設定を指定します。
  # 関連機能: Gatewayインターセプター
  #   Gatewayの各呼び出し時にカスタムコードを実行できます。
  #   最小1、最大2のインターセプター設定が可能です。
  interceptor_configuration {
    # interception_points (Required)
    # 設定内容: インターセプトするポイントを指定します。
    # 設定可能な値:
    #   - "REQUEST": リクエスト時にインターセプト
    #   - "RESPONSE": レスポンス時にインターセプト
    interception_points = ["REQUEST", "RESPONSE"]

    # interceptor (Required)
    # 設定内容: インターセプターのインフラストラクチャ設定を指定します。
    interceptor {
      # lambda (Required within interceptor)
      # 設定内容: インターセプター用のLambda関数設定を指定します。
      lambda {
        # arn (Required)
        # 設定内容: インターセプターとして呼び出すLambda関数のARNを指定します。
        # 設定可能な値: 有効なLambda関数ARN
        arn = "arn:aws:lambda:ap-northeast-1:123456789012:function:gateway-interceptor"
      }
    }

    # input_configuration (Optional)
    # 設定内容: インターセプターの入力設定を指定します。
    input_configuration {
      # pass_request_headers (Required)
      # 設定内容: リクエストヘッダーをインターセプターに渡すかどうかを指定します。
      # 設定可能な値:
      #   - true: リクエストヘッダーを渡す
      #   - false: リクエストヘッダーを渡さない
      pass_request_headers = true
    }
  }

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
    Name        = "example-gateway"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウトを指定します。
  timeouts {
    # create (Optional)
    # 設定内容: 作成操作のタイムアウトを指定します。
    # 設定可能な値: 時間を表す文字列（例: "30s", "2h45m"）
    # 使用可能な単位: "s"（秒）, "m"（分）, "h"（時間）
    create = "30m"

    # update (Optional)
    # 設定内容: 更新操作のタイムアウトを指定します。
    # 設定可能な値: 時間を表す文字列（例: "30s", "2h45m"）
    # 使用可能な単位: "s"（秒）, "m"（分）, "h"（時間）
    update = "30m"

    # delete (Optional)
    # 設定内容: 削除操作のタイムアウトを指定します。
    # 設定可能な値: 時間を表す文字列（例: "30s", "2h45m"）
    # 使用可能な単位: "s"（秒）, "m"（分）, "h"（時間）
    delete = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - gateway_arn: GatewayのARN
#
# - gateway_id: Gatewayの一意識別子
#
# - gateway_url: GatewayのURLエンドポイント
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#
# - workload_identity_details: Gatewayのワークロードアイデンティティ詳細
#   - workload_identity_arn: ワークロードアイデンティティのARN
#
#---------------------------------------------------------------
