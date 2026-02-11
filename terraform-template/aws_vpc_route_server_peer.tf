#---------------------------------------------------------------
# AWS VPC Route Server Peer
#---------------------------------------------------------------
#
# VPC Route Serverピアをプロビジョニングするリソースです。
# VPC Route Serverは、VPC内の仮想アプライアンスとの動的ルーティングを
# 簡素化するサービスで、BGP（Border Gateway Protocol）を使用して
# ルーティング情報をアドバタイズし、VPCルートテーブルを動的に更新します。
# このリソースは、Route Serverエンドポイントと仮想アプライアンス間の
# BGPピアリング関係を設定します。
#
# AWS公式ドキュメント:
#   - VPC Route Serverの仕組み: https://docs.aws.amazon.com/vpc/latest/userguide/route-server-how-it-works.html
#   - VPC Route Serverを使用した動的ルーティング: https://docs.aws.amazon.com/vpc/latest/userguide/dynamic-routing-route-server.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_route_server_peer
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_vpc_route_server_peer" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # route_server_endpoint_id (Required)
  # 設定内容: ピアを作成するRoute Serverエンドポイントの識別子を指定します。
  # 設定可能な値: 有効なRoute ServerエンドポイントID
  # 注意: aws_vpc_route_server_endpointリソースから取得できます。
  route_server_endpoint_id = aws_vpc_route_server_endpoint.example.route_server_endpoint_id

  # peer_address (Required)
  # 設定内容: ピアデバイス（仮想アプライアンス）のIPv4アドレスを指定します。
  # 設定可能な値: 有効なIPv4アドレス
  # 注意: Route Serverエンドポイントと同じサブネット内のアドレスを指定します。
  peer_address = "10.0.1.250"

  #-------------------------------------------------------------
  # BGP設定
  #-------------------------------------------------------------

  # bgp_options (Required)
  # 設定内容: ピアのBGPオプションを指定します。ASN（自律システム番号）と
  #          BFD（Bidirectional Forwarding Detection）設定を含みます。
  bgp_options {
    # peer_asn (Required)
    # 設定内容: アプライアンスのBGP自律システム番号（ASN）を指定します。
    # 設定可能な値: 1〜4294967295
    # 推奨値: プライベートASNの使用を推奨
    #   - 16ビットASN: 64512〜65534
    #   - 32ビットASN: 4200000000〜4294967294
    # 関連機能: BGP（Border Gateway Protocol）
    #   BGPはインターネット上のルーティングに使用される標準プロトコルで、
    #   自律システム間でルーティング情報を交換します。
    peer_asn = 65200

    # peer_liveness_detection (Optional)
    # 設定内容: ピアの生存確認方式を指定します。
    # 設定可能な値:
    #   - "bgp-keepalive": BGPキープアライブメッセージを使用
    #   - "bfd": BFD（Bidirectional Forwarding Detection）を使用
    # 省略時: デフォルト値が適用されます。
    # 関連機能: BFD（Bidirectional Forwarding Detection）
    #   BFDは障害を迅速に検出するためのプロトコルで、BGPキープアライブより
    #   高速な障害検出が可能です。高可用性が要求される環境で推奨されます。
    peer_liveness_detection = "bgp-keepalive"
  }

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # 注意: VPC Route Serverは現在、限られたリージョンでのみ利用可能です。
  #       (US East (Virginia), US East (Ohio), US West (Oregon),
  #        Europe (Ireland), Europe (Frankfurt), Asia Pacific (Tokyo))
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
    Name        = "example-route-server-peer"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定します。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成のタイムアウト時間を指定します。
    # 設定可能な値: 期間を表す文字列（例: "30s", "5m", "2h45m"）
    #   - "s": 秒
    #   - "m": 分
    #   - "h": 時
    # 省略時: デフォルトのタイムアウト値が適用されます。
    create = "10m"

    # delete (Optional)
    # 設定内容: リソース削除のタイムアウト時間を指定します。
    # 設定可能な値: 期間を表す文字列（例: "30s", "5m", "2h45m"）
    #   - "s": 秒
    #   - "m": 分
    #   - "h": 時
    # 省略時: デフォルトのタイムアウト値が適用されます。
    # 注意: 削除操作のタイムアウト設定は、削除操作が発生する前に
    #       変更がstateに保存される場合にのみ適用されます。
    delete = "10m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: Route ServerピアのAmazon Resource Name (ARN)
#
# - route_server_peer_id: Route Serverピアの一意の識別子
#
# - route_server_id: このピアに関連付けられたRoute Serverの識別子
#
# - endpoint_eni_address: Route Serverエンドポイントの
#                         Elastic Network InterfaceのIPアドレス
#
# - endpoint_eni_id: Route Serverエンドポイントの
#                    Elastic Network Interfaceの識別子
#
# - subnet_id: Route Serverピアを含むサブネットの識別子
#
# - vpc_id: Route Serverピアを含むVPCの識別子
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
