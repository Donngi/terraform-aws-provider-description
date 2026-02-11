#---------------------------------------------------------------
# EC2 Transit Gateway Connect
#---------------------------------------------------------------
#
# EC2 Transit Gateway Connect アタッチメントを管理するリソースです。
# Transit Gateway Connect は、GRE (Generic Routing Encapsulation) トンネルプロトコルと
# BGP (Border Gateway Protocol) を使用して、Transit Gateway とサードパーティの仮想アプライアンス
# (SD-WAN アプライアンスなど) 間の接続を確立します。
#
# Connect アタッチメントは、既存の VPC アタッチメントまたは Direct Connect アタッチメントを
# 基盤となるトランスポート機構として使用します。この接続により、SD-WAN インフラストラクチャと
# AWS をネイティブに統合でき、ネットワーク設計を簡素化し、運用コストを削減できます。
#
# 主な特徴:
#   - GRE トンネルによる高帯域幅パフォーマンス (最大 5 Gbps/トンネル)
#   - BGP による動的ルーティングとヘルスチェック
#   - 1つの Connect アタッチメントあたり最大 4 つの Connect ピア
#   - IPv6 サポートと Multiprotocol Extensions for BGP による動的ルート広告
#
# AWS公式ドキュメント:
#   - Transit Gateway Connect 概要: https://docs.aws.amazon.com/vpc/latest/tgw/tgw-connect.html
#   - Transit Gateway Connect と SD-WAN: https://docs.aws.amazon.com/whitepapers/latest/aws-vpc-connectivity-options/aws-transit-gateway-sd-wan.html
#   - Transit Gateway ルートテーブル: https://docs.aws.amazon.com/vpc/latest/tgw/tgw-route-tables.html
#   - Transit Gateway API リファレンス: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_CreateTransitGatewayConnect.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_connect
#
# Provider Version: 6.28.0
# Generated: 2026-01-28
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ec2_transit_gateway_connect" "example" {
  #-------------------------------------------------------------
  # 必須パラメータ
  #-------------------------------------------------------------

  # transit_gateway_id (Required)
  # 設定内容: EC2 Transit Gateway の識別子を指定します。
  # 設定可能な値: Transit Gateway の ID (形式: tgw-xxxxxxxxxxxxxxxxx)
  # 用途: Connect アタッチメントを作成する対象の Transit Gateway を指定
  # 関連機能: Transit Gateway
  #   リージョナルなネットワーク中継ハブとして機能し、VPC と SD-WAN ネットワークを相互接続します。
  #   Connect アタッチメントはこの Transit Gateway に紐づけられます。
  #   - https://docs.aws.amazon.com/vpc/latest/tgw/what-is-transit-gateway.html
  transit_gateway_id = "tgw-0123456789abcdef0"

  # transport_attachment_id (Required)
  # 設定内容: 基盤となる VPC アタッチメントまたは Direct Connect アタッチメントの ID を指定します。
  # 設定可能な値: Transit Gateway VPC アタッチメント ID (tgw-attach-xxx) または Direct Connect アタッチメント ID
  # 用途: Connect アタッチメントの下層トランスポートとして使用する既存のアタッチメントを指定
  # 関連機能: Transit Gateway アタッチメント
  #   Connect アタッチメントは既存の VPC または Direct Connect アタッチメント上に作成されます。
  #   このアタッチメントが GRE トンネルトラフィックの実際の転送パスとなります。
  #   - https://docs.aws.amazon.com/vpc/latest/tgw/tgw-connect.html
  transport_attachment_id = "tgw-attach-0123456789abcdef0"

  #-------------------------------------------------------------
  # オプションパラメータ
  #-------------------------------------------------------------

  # protocol (Optional)
  # 設定内容: トンネルプロトコルを指定します。
  # 設定可能な値: "gre" (現在のところ GRE のみサポート)
  # デフォルト値: "gre"
  # 用途: Connect アタッチメントで使用するカプセル化プロトコルを指定
  # 関連機能: Generic Routing Encapsulation (GRE)
  #   GRE は IP パケットを別の IP パケット内にカプセル化するトンネリングプロトコルです。
  #   Transit Gateway Connect では GRE を使用してサードパーティアプライアンスとの接続を確立します。
  #   各 GRE トンネルは最大 5 Gbps の帯域幅をサポートします。
  #   - https://docs.aws.amazon.com/whitepapers/latest/aws-vpc-connectivity-options/aws-transit-gateway-sd-wan.html
  protocol = "gre"

  # transit_gateway_default_route_table_association (Optional)
  # 設定内容: Connect アタッチメントを Transit Gateway のデフォルト関連付けルートテーブルに
  #           自動的に関連付けるかどうかを指定します。
  # 設定可能な値: true または false
  # デフォルト値: true
  # 用途: アタッチメントからのトラフィックがどのルートテーブルを使用するかを制御
  # 注意: Resource Access Manager で共有された Transit Gateway では設定不可、
  #       ドリフト検出も実行されません
  # 関連機能: Transit Gateway ルートテーブル関連付け
  #   関連付けは、アタッチメントからのトラフィックがどのルートテーブルを使用してルーティングされるかを決定します。
  #   デフォルトルートテーブルを使用しない場合は false に設定し、別途カスタムルートテーブルに関連付けます。
  #   - https://docs.aws.amazon.com/vpc/latest/tgw/tgw-route-tables.html
  transit_gateway_default_route_table_association = true

  # transit_gateway_default_route_table_propagation (Optional)
  # 設定内容: Connect アタッチメントのルートを Transit Gateway のデフォルト伝播ルートテーブルに
  #           自動的に伝播するかどうかを指定します。
  # 設定可能な値: true または false
  # デフォルト値: true
  # 用途: アタッチメントで学習したルート (BGP 経由) を他のアタッチメントに伝播するかを制御
  # 注意: Resource Access Manager で共有された Transit Gateway では設定不可、
  #       ドリフト検出も実行されません
  # 関連機能: Transit Gateway ルートテーブル伝播
  #   伝播は、アタッチメントからのルートが対象のルートテーブルに自動的に追加されることを意味します。
  #   Connect ピアで学習した BGP ルートが、他のアタッチメントに伝播されます。
  #   デフォルトルートテーブルを使用しない場合は false に設定し、別途カスタムルートテーブルに伝播設定を行います。
  #   - https://docs.aws.amazon.com/vpc/latest/tgw/tgw-route-tables.html
  transit_gateway_default_route_table_propagation = true

  # region (Optional, Computed)
  # 設定内容: このリソースが管理されるリージョンを指定します。
  # 設定可能な値: AWS リージョンコード (例: us-east-1, ap-northeast-1)
  # デフォルト値: プロバイダー設定で指定されたリージョン
  # 用途: マルチリージョン構成でリソースのリージョンを明示的に制御する場合に使用
  # 関連機能: AWS リージョナルエンドポイント
  #   Transit Gateway はリージョナルリソースです。異なるリージョン間の接続には Transit Gateway ピアリングを使用します。
  #   - https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#region
  # region = "ap-northeast-1"

  # tags (Optional)
  # 設定内容: EC2 Transit Gateway Connect に適用するキー・バリューペアのタグを指定します。
  # 設定可能な値: 任意の文字列のキー・バリューマップ
  # 用途: リソースの識別、分類、コスト配分、アクセス制御などに使用
  # 関連機能: AWS タグ
  #   リソースの管理、検索、フィルタリング、コスト配分に使用できます。
  #   プロバイダーレベルで default_tags を設定している場合、それらのタグと統合されます。
  #   - https://docs.aws.amazon.com/general/latest/gr/aws_tagging.html
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "example-tgw-connect"
    Environment = "production"
    ManagedBy   = "terraform"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts
  # 設定内容: リソースの作成、更新、削除操作のタイムアウト時間を指定します。
  # 設定可能な値: 時間文字列 (例: "10m", "1h")
  # 用途: デフォルトのタイムアウト時間では不足する場合に調整
  # 注意: 通常はデフォルト値で十分ですが、大規模な環境やネットワーク遅延が大きい場合は調整が必要な場合があります
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成操作のタイムアウト時間
    # デフォルト値: 10分
    create = "10m"

    # update (Optional)
    # 設定内容: リソース更新操作のタイムアウト時間
    # デフォルト値: 10分
    update = "10m"

    # delete (Optional)
    # 設定内容: リソース削除操作のタイムアウト時間
    # デフォルト値: 10分
    delete = "10m"
  }
}

#---------------------------------------------------------------
# 出力値 (Computed Attributes)
#---------------------------------------------------------------
# 以下の属性は Terraform によって自動的に計算され、他のリソースで参照可能です:
#
# id (Computed)
#   説明: EC2 Transit Gateway アタッチメントの識別子
#   形式: tgw-attach-xxxxxxxxxxxxxxxxx
#   用途: 他のリソース (aws_ec2_transit_gateway_connect_peer など) で参照
#   例: aws_ec2_transit_gateway_connect.example.id
#
# tags_all (Computed)
#   説明: リソースに割り当てられたすべてのタグのマップ
#   内容: 明示的に設定したタグとプロバイダーの default_tags から継承したタグを含む
#   用途: 実際に適用されているすべてのタグを確認、他のリソースで参照
#   例: aws_ec2_transit_gateway_connect.example.tags_all
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例: Connect Peer との組み合わせ
#---------------------------------------------------------------
#
# Connect アタッチメントを作成した後、Connect Peer を作成して
# 実際の GRE トンネルと BGP セッションを確立します:
#
# resource "aws_ec2_transit_gateway_connect_peer" "example" {
#   transit_gateway_attachment_id   = aws_ec2_transit_gateway_connect.example.id
#   peer_address                    = "10.0.1.10"
#   inside_cidr_blocks              = ["169.254.100.0/29"]
#   bgp_asn                         = 65000
#   transit_gateway_address         = "10.0.1.1"
#
#   tags = {
#     Name = "example-tgw-connect-peer"
#   }
# }
#
# 詳細: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_connect_peer
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# ベストプラクティスと考慮事項
#---------------------------------------------------------------
#
# 1. トランスポートアタッチメントの選択:
#    - VPC アタッチメント: AWS 内のサードパーティアプライアンス (VPC 内の SD-WAN) に接続
#    - Direct Connect アタッチメント: オンプレミスの SD-WAN インフラストラクチャに接続
#
# 2. 帯域幅とスケーリング:
#    - 各 GRE トンネルは最大 5 Gbps をサポート
#    - 1つの Connect アタッチメントあたり最大 4 つの Connect ピアを作成可能
#    - より高い帯域幅が必要な場合は、複数の Connect ピアを使用
#
# 3. ルーティング設計:
#    - BGP による動的ルーティングが必須 (静的ルートは非サポート)
#    - サードパーティアプライアンスで BGP を設定する必要があります
#    - ECMP (Equal Cost Multi-Path) により複数の Connect ピア間で負荷分散可能
#
# 4. セキュリティ:
#    - Connect アタッチメント自体は暗号化を提供しません
#    - トラフィックの暗号化が必要な場合は、SD-WAN アプライアンスレベルで実装
#
# 5. 高可用性:
#    - 複数の Connect ピアを異なる AZ に配置してフェイルオーバーを実現
#    - BGP ヘルスチェックによる自動フェイルオーバー
#
# 6. 制限事項:
#    - BGP Graceful Restart は非サポート
#    - Bidirectional Forwarding Detection (BFD) は非サポート
#    - IPv4 と IPv6 の両方をサポートしますが、設定は個別に行う必要があります
#
# 7. コスト最適化:
#    - Connect アタッチメント自体は追加料金が発生しません (Transit Gateway の通常料金のみ)
#    - データ転送料金は通常の Transit Gateway の料金体系に従います
#
# 8. モニタリングとトラブルシューティング:
#    - CloudWatch メトリクスで GRE トンネルの状態を監視
#    - VPC Flow Logs で GRE トラフィックを確認
#    - BGP セッションの状態を定期的に確認
#
#---------------------------------------------------------------
