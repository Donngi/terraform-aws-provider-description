#---------------------------------------------------------------
# AWS VPC Route Server Endpoint
#---------------------------------------------------------------
#
# Amazon VPC Route Serverのエンドポイントをプロビジョニングするリソースです。
# Route Serverエンドポイントは、Route ServerとBGPピア間のBGP接続を
# 促進するAWSマネージドコンポーネントです。VPC内のネットワークアプライアンス
# （ファイアウォール、ルーターなど）とBGPセッションを確立し、動的ルーティングを
# 実現するための接点として機能します。
#
# AWS公式ドキュメント:
#   - VPC Route Server概要: https://docs.aws.amazon.com/vpc/latest/userguide/dynamic-routing-route-server.html
#   - Route Server用語集: https://docs.aws.amazon.com/vpc/latest/userguide/route-server-terms.html
#   - Route Serverエンドポイント作成: https://docs.aws.amazon.com/vpc/latest/userguide/route-server-tutorial-create-endpoints.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_route_server_endpoint
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_vpc_route_server_endpoint" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # route_server_id (Required)
  # 設定内容: エンドポイントを作成するRoute ServerのIDを指定します。
  # 設定可能な値: 有効なRoute Server ID（例: rs-xxxxxxxxxxxxxxxxx）
  # 関連機能: VPC Route Server
  #   VPC Route Serverは、VPC内のワークロード間およびインターネットゲートウェイとの
  #   トラフィックのルーティングを簡素化する機能です。BGPを使用してルーティング情報を
  #   アドバタイズし、VPCルートテーブルを動的に更新します。
  #   - https://docs.aws.amazon.com/vpc/latest/userguide/dynamic-routing-route-server.html
  route_server_id = aws_vpc_route_server.example.route_server_id

  # subnet_id (Required)
  # 設定内容: Route Serverエンドポイントを作成するサブネットのIDを指定します。
  # 設定可能な値: 有効なサブネットID（例: subnet-xxxxxxxxxxxxxxxxx）
  # 注意: エンドポイントはこのサブネット内にElastic Network Interface (ENI)を作成します。
  #       BGPピアと通信するため、サブネットのセキュリティグループとネットワークACLで
  #       BGPトラフィック（TCPポート179）を許可する必要があります。
  subnet_id = aws_subnet.example.id

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # 注意: VPC Route Serverは現在、US East (Virginia)、US East (Ohio)、US West (Oregon)、
  #       Europe (Ireland)、Europe (Frankfurt)、Asia Pacific (Tokyo)リージョンで利用可能です。
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
  tags = {
    Name        = "example-route-server-endpoint"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソースの作成・削除操作のタイムアウト時間を指定します。
  # 関連機能: Terraformタイムアウト設定
  #   特定の操作が完了するまでの待機時間を制御します。
  #   ネットワークリソースの作成には時間がかかる場合があるため、
  #   必要に応じてタイムアウト値を調整できます。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: 時間単位を含む文字列（例: "30s", "5m", "1h"）
    #   - "s": 秒
    #   - "m": 分
    #   - "h": 時間
    # 省略時: Terraformのデフォルトタイムアウトを使用
    create = "10m"

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: 時間単位を含む文字列（例: "30s", "5m", "1h"）
    #   - "s": 秒
    #   - "m": 分
    #   - "h": 時間
    # 省略時: Terraformのデフォルトタイムアウトを使用
    # 注意: 削除操作のタイムアウト設定は、destroy操作の前に
    #       変更がstateに保存される場合にのみ適用されます。
    delete = "10m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: Route ServerエンドポイントのAmazon Resource Name (ARN)
#
# - route_server_endpoint_id: Route Serverエンドポイントの一意の識別子
#
# - eni_id: エンドポイント用に作成されたElastic Network InterfaceのID
#
# - eni_address: エンドポイント用Elastic Network InterfaceのIPアドレス
#        BGPピアがセッションを確立する際のRoute Server側のIPアドレスとして使用されます。
#
# - vpc_id: エンドポイントが存在するVPCのID
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
