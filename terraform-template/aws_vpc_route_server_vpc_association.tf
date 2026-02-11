#---------------------------------------------------------------
# AWS VPC Route Server VPC Association
#---------------------------------------------------------------
#
# Amazon VPC Route ServerとVPCの関連付けをプロビジョニングするリソースです。
# Route Server AssociationはRoute ServerとVPC間の接続を確立し、
# Route ServerがVPC内のルートテーブルと連携してルートを管理できるようにします。
#
# AWS公式ドキュメント:
#   - VPC Route Server概要: https://docs.aws.amazon.com/vpc/latest/userguide/route-server.html
#   - Route Serverの関連付け: https://docs.aws.amazon.com/vpc/latest/userguide/route-server-tutorial-associate.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_route_server_vpc_association
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_vpc_route_server_vpc_association" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # route_server_id (Required)
  # 設定内容: 関連付けるRoute ServerのIDを指定します。
  # 設定可能な値: 有効なRoute Server ID（例: rs-xxxxxxxxxxxxxxxxx）
  # 関連機能: Amazon VPC Route Server
  #   VPC Route Serverは、VPC内のワークロードとインターネットゲートウェイ間の
  #   トラフィックのルーティングを簡素化します。BGPを使用して仮想アプライアンスから
  #   ルーティング情報を受信し、VPCルートテーブルを動的に更新します。
  #   - https://docs.aws.amazon.com/vpc/latest/userguide/route-server.html
  route_server_id = aws_vpc_route_server.example.route_server_id

  # vpc_id (Required)
  # 設定内容: Route Serverと関連付けるVPCのIDを指定します。
  # 設定可能な値: 有効なVPC ID（例: vpc-xxxxxxxxxxxxxxxxx）
  # 関連機能: Route Server Association
  #   Route Server Associationは、Route ServerとVPC間の接続を確立します。
  #   この関連付けにより、Route ServerはVPC内のサブネットのルートテーブルと
  #   連携してルートを管理できるようになります。
  #   各Route Serverは1つのVPCに関連付け可能で、各VPCはデフォルトで
  #   最大5つのRoute Server関連付けを持つことができます。
  #   - https://docs.aws.amazon.com/vpc/latest/userguide/route-server-tutorial-associate.html
  vpc_id = aws_vpc.example.id

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # 注意: VPC Route Serverは現在、限定されたリージョンで利用可能です。
  #       利用可能なリージョン: US East (Virginia), US East (Ohio), US West (Oregon),
  #       Europe (Ireland), Europe (Frankfurt), Asia Pacific (Tokyo)
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
    # 省略時: デフォルトのタイムアウト値を使用
    # 用途: Route Server関連付けの作成に時間がかかる場合に延長
    create = "5m"

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "30s", "5m", "1h"）
    #   - "s": 秒
    #   - "m": 分
    #   - "h": 時間
    # 省略時: デフォルトのタイムアウト値を使用
    # 用途: Route Server関連付けの削除に時間がかかる場合に延長
    delete = "5m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは明示的にエクスポートされる属性を持ちません。
# リソースのIDは暗黙的に利用可能です。
#---------------------------------------------------------------
