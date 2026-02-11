#---------------------------------------------------------------
# AWS VPC Route Server Propagation
#---------------------------------------------------------------
#
# VPC Route ServerとRoute Table間のルート伝播を管理するリソースです。
# Route Serverが学習したルート（BGPピアから受信したルート）を指定した
# Route TableのFIB（Forwarding Information Base）にインストールします。
# IPv4およびIPv6のルート伝播をサポートしています。
#
# AWS公式ドキュメント:
#   - VPC Route Serverルート伝播: https://docs.aws.amazon.com/vpc/latest/userguide/route-server-tutorial-enable-prop.html
#   - EnableRouteServerPropagation API: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_EnableRouteServerPropagation.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_route_server_propagation
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_vpc_route_server_propagation" "example" {
  #-------------------------------------------------------------
  # Route Server設定
  #-------------------------------------------------------------

  # route_server_id (Required)
  # 設定内容: ルート伝播に関連付けるRoute ServerのIDを指定します。
  # 設定可能な値: 有効なRoute Server ID
  # 関連機能: VPC Route Server
  #   VPC Route Serverは、VPC内のワークロードとインターネットゲートウェイ間の
  #   ルーティングを簡素化し、VPCおよびインターネットゲートウェイのルートテーブルを
  #   優先ルートで動的に更新します。
  #   - https://docs.aws.amazon.com/vpc/latest/userguide/route-server.html
  route_server_id = aws_vpc_route_server.example.route_server_id

  #-------------------------------------------------------------
  # Route Table設定
  #-------------------------------------------------------------

  # route_table_id (Required)
  # 設定内容: Route Serverがルートを伝播するRoute TableのIDを指定します。
  # 設定可能な値: 有効なRoute Table ID
  # 関連機能: ルート伝播
  #   Route ServerはBGPピアから学習したルートをRoute Tableに自動的に伝播します。
  #   サポートされるRoute Tableの種類:
  #   - サブネットに関連付けられていないVPCルートテーブル
  #   - サブネットルートテーブル
  #   - インターネットゲートウェイルートテーブル
  #   注意: 仮想プライベートゲートウェイに関連付けられたルートテーブルはサポートされません。
  #   Transit Gatewayルートテーブルへの伝播にはTransit Gateway Connectを使用してください。
  #   - https://docs.aws.amazon.com/vpc/latest/userguide/route-server-tutorial-enable-prop.html
  route_table_id = aws_route_table.example.id

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
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソースの作成・削除操作のタイムアウト時間を指定します。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "30s", "5m", "1h"）
    # 省略時: デフォルトのタイムアウト時間を使用
    create = "5m"

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "30s", "5m", "1h"）
    # 省略時: デフォルトのタイムアウト時間を使用
    delete = "5m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースはArgument Reference以外に追加の属性をエクスポートしません。
#---------------------------------------------------------------
