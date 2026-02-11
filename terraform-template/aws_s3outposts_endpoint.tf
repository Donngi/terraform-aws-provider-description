################################################################################
# AWS S3 Outposts Endpoint
# Provider Version: 6.28.0
# Resource: aws_s3outposts_endpoint
################################################################################
# S3 Outposts Endpointは、AWS Outposts上のS3バケットへのアクセスを提供する
# ネットワークエンドポイントです。VPC内のリソースがOutposts上のS3ストレージに
# アクセスするために必要となります。
#
# 主な用途:
# - Outposts上のS3バケットへのVPCアクセスポイントの作成
# - オンプレミスネットワークからのS3 Outpostsへのアクセス設定
# - 顧客所有IPアドレスプール(CoIP)を使用したアクセス制御
#
# 重要な考慮事項:
# - 各VPCにつき1つのエンドポイントのみ作成可能
# - エンドポイント作成には最大5分かかる場合あり
# - Outpostsとホームリージョン間のアクティブな接続が必要
# - S3 on Outpostsサービスリンクロールが自動的に作成される
#
# 参考資料:
# - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3outposts_endpoint
# - https://docs.aws.amazon.com/AmazonS3/latest/s3-outposts/S3OutpostsNetworking.html
################################################################################

resource "aws_s3outposts_endpoint" "example" {
  ################################################################################
  # 必須パラメータ
  ################################################################################

  # outpost_id - (必須) エンドポイントを作成するOutpostsのID
  #
  # このOutpost IDは、S3 on Outpostsサービスを含むOutpostsインスタンスを
  # 指定します。data sourceの aws_outposts_outpost を使用して取得可能です。
  #
  # 注意事項:
  # - Outpostsとホームリージョン間のアクティブな接続が必要
  # - 各VPCに対して1つのエンドポイントのみ作成可能
  #
  # 例: "op-1234567890abcdef0"
  outpost_id = data.aws_outposts_outpost.example.id

  # security_group_id - (必須) エンドポイントに関連付けるセキュリティグループID
  #
  # このセキュリティグループは、S3 Outpostsエンドポイントへのネットワーク
  # トラフィックを制御します。cross-accountの elastic network interface (ENI)
  # に適用されます。
  #
  # セキュリティグループの推奨設定:
  # - インバウンド: VPC CIDRからのHTTPS (443) アクセスを許可
  # - アウトバウンド: 必要に応じてOutpostsへの通信を許可
  #
  # 例: "sg-0123456789abcdef0"
  security_group_id = aws_security_group.example.id

  # subnet_id - (必須) エンドポイントを配置するサブネットID
  #
  # エンドポイントのcross-account ENIが作成されるサブネットを指定します。
  # このサブネットはOutpostsに関連付けられたVPC内に存在する必要があります。
  #
  # 推奨事項:
  # - 十分なIPアドレス空間を持つサブネットを選択
  # - S3 on OutpostsのDNSが複数のENIに負荷分散を行うため、
  #   複数のENIが作成される可能性を考慮
  #
  # 例: "subnet-0123456789abcdef0"
  subnet_id = aws_subnet.example.id

  ################################################################################
  # オプションパラメータ
  ################################################################################

  # access_type - (オプション) ネットワーク接続のアクセスタイプ
  #
  # 有効な値:
  # - "Private" (デフォルト): VPC内からのプライベートアクセス
  #   - VPC内のインスタンスはパブリックIPなしでS3 Outpostsと通信可能
  #   - トラフィックはAWSネットワーク内に留まる
  #   - 最も一般的で安全な設定
  #
  # - "CustomerOwnedIp": 顧客所有IPアドレスプール(CoIP)を使用
  #   - オンプレミスネットワークとVPCの両方からアクセス可能
  #   - customer_owned_ipv4_pool パラメータの指定が必須
  #   - VPC内からのアクセス時はローカルゲートウェイの帯域幅に制限される
  #   - Local Gateway Route Table(LGRT)経由でオンプレミスからアクセス可能
  #
  # ユースケース別推奨:
  # - VPCからのみアクセス: "Private"
  # - オンプレミスからもアクセス必要: "CustomerOwnedIp"
  #
  # デフォルト: "Private"
  # 例: "Private" または "CustomerOwnedIp"
  access_type = "Private"

  # customer_owned_ipv4_pool - (オプション) 顧客所有IPv4プールのID
  #
  # access_type = "CustomerOwnedIp" の場合に必須となるパラメータです。
  # S3 on OutpostsはこのCoIPプールからIPアドレスを割り当て、
  # cross-account ENIに関連付けます。
  #
  # 使用条件:
  # - access_type が "CustomerOwnedIp" の場合のみ有効
  # - Outpostsに関連付けられたCoIPプールを指定
  #
  # 注意事項:
  # - オンプレミスネットワークからのアクセスを可能にする
  # - Local Gateway経由でのトラフィックルーティングが設定される
  #
  # 例: "ipv4pool-coip-0123456789abcdef0"
  # customer_owned_ipv4_pool = aws_ec2_coip_pool.example.id

  # region - (オプション) リソースを管理するAWSリージョン
  #
  # 指定しない場合、プロバイダー設定のリージョンが使用されます。
  # Outpostsのホームリージョンを指定することが推奨されます。
  #
  # デフォルト: プロバイダーのリージョン設定
  # 例: "us-west-2"
  # region = "us-west-2"

  ################################################################################
  # タグ設定
  ################################################################################
  # 注意: aws_s3outposts_endpoint リソースは現在タグをサポートしていません
}

################################################################################
# 出力属性 (Computed Attributes)
################################################################################
# 以下の属性はリソース作成後に参照可能です:
#
# - arn
#   エンドポイントのAmazon Resource Name (ARN)
#   形式: arn:aws:s3-outposts:<region>:<account-id>:outpost/<outpost-id>/endpoint/<endpoint-id>
#   例: aws_s3outposts_endpoint.example.arn
#
# - cidr_block
#   エンドポイントのVPC CIDRブロック
#   例: "10.0.0.0/16"
#   例: aws_s3outposts_endpoint.example.cidr_block
#
# - creation_time
#   エンドポイントの作成時刻 (RFC3339形式のUTC)
#   例: "2023-01-15T10:30:00Z"
#   例: aws_s3outposts_endpoint.example.creation_time
#
# - id
#   エンドポイントのID (ARNと同じ)
#   例: aws_s3outposts_endpoint.example.id
#
# - network_interfaces
#   関連付けられたElastic Network Interfaces (ENI) のセット
#   S3 on OutpostsはDNS負荷分散のために複数のcross-account ENIを作成
#   各ENIには以下の属性が含まれる:
#     - network_interface_id: ENIの識別子
#   例: aws_s3outposts_endpoint.example.network_interfaces[*].network_interface_id

################################################################################
# 使用例 1: 基本的なPrivateアクセスタイプのエンドポイント
################################################################################
# resource "aws_s3outposts_endpoint" "private" {
#   outpost_id        = data.aws_outposts_outpost.example.id
#   security_group_id = aws_security_group.s3_outposts.id
#   subnet_id         = aws_subnet.outposts.id
#   access_type       = "Private"
# }
#
# # エンドポイント用のセキュリティグループ
# resource "aws_security_group" "s3_outposts" {
#   name        = "s3-outposts-endpoint-sg"
#   description = "Security group for S3 Outposts endpoint"
#   vpc_id      = aws_vpc.outposts.id
#
#   ingress {
#     description = "HTTPS from VPC"
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = [aws_vpc.outposts.cidr_block]
#   }
#
#   egress {
#     description = "All outbound traffic"
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

################################################################################
# 使用例 2: CustomerOwnedIpアクセスタイプのエンドポイント
################################################################################
# resource "aws_s3outposts_endpoint" "coip" {
#   outpost_id                  = data.aws_outposts_outpost.example.id
#   security_group_id           = aws_security_group.s3_outposts.id
#   subnet_id                   = aws_subnet.outposts.id
#   access_type                 = "CustomerOwnedIp"
#   customer_owned_ipv4_pool    = data.aws_ec2_coip_pool.example.id
# }
#
# # 顧客所有IPプールの取得
# data "aws_ec2_coip_pool" "example" {
#   filter {
#     name   = "coip-pool.pool-id"
#     values = ["ipv4pool-coip-0123456789abcdef0"]
#   }
# }

################################################################################
# 使用例 3: 完全な構成例（VPC、サブネット、Outpostsデータソース含む）
################################################################################
# # Outpostsインスタンスの取得
# data "aws_outposts_outpost" "example" {
#   name = "my-outpost"
# }
#
# # VPCの作成
# resource "aws_vpc" "outposts" {
#   cidr_block           = "10.0.0.0/16"
#   enable_dns_hostnames = true
#   enable_dns_support   = true
#
#   tags = {
#     Name = "outposts-vpc"
#   }
# }
#
# # サブネットの作成
# resource "aws_subnet" "outposts" {
#   vpc_id            = aws_vpc.outposts.id
#   cidr_block        = "10.0.1.0/24"
#   availability_zone = data.aws_outposts_outpost.example.availability_zone
#   outpost_arn       = data.aws_outposts_outpost.example.arn
#
#   tags = {
#     Name = "outposts-subnet"
#   }
# }
#
# # セキュリティグループの作成
# resource "aws_security_group" "s3_outposts" {
#   name        = "s3-outposts-endpoint-sg"
#   description = "Security group for S3 Outposts endpoint"
#   vpc_id      = aws_vpc.outposts.id
#
#   ingress {
#     description = "HTTPS from VPC"
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = [aws_vpc.outposts.cidr_block]
#   }
#
#   egress {
#     description = "All outbound traffic"
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#
#   tags = {
#     Name = "s3-outposts-endpoint-sg"
#   }
# }
#
# # S3 Outpostsエンドポイントの作成
# resource "aws_s3outposts_endpoint" "example" {
#   outpost_id        = data.aws_outposts_outpost.example.id
#   security_group_id = aws_security_group.s3_outposts.id
#   subnet_id         = aws_subnet.outposts.id
#   access_type       = "Private"
# }
#
# # エンドポイント情報の出力
# output "endpoint_arn" {
#   description = "The ARN of the S3 Outposts endpoint"
#   value       = aws_s3outposts_endpoint.example.arn
# }
#
# output "endpoint_id" {
#   description = "The ID of the S3 Outposts endpoint"
#   value       = aws_s3outposts_endpoint.example.id
# }
#
# output "endpoint_cidr_block" {
#   description = "The VPC CIDR block of the endpoint"
#   value       = aws_s3outposts_endpoint.example.cidr_block
# }
#
# output "endpoint_network_interfaces" {
#   description = "The network interfaces associated with the endpoint"
#   value       = aws_s3outposts_endpoint.example.network_interfaces
# }

################################################################################
# ベストプラクティスと運用上の注意事項
################################################################################
# 1. エンドポイント作成の前提条件
#    - Outpostsとホームリージョン間のアクティブな接続を確認
#    - VPCとサブネットが正しく設定されていることを確認
#    - 十分なIPアドレス空間がサブネットに存在することを確認
#
# 2. セキュリティグループの設計
#    - 最小権限の原則に従い、必要なトラフィックのみ許可
#    - VPC CIDRからのHTTPS (443) アクセスを許可
#    - 定期的にセキュリティグループルールを見直し
#
# 3. アクセスタイプの選択
#    - VPC内からのみアクセス: "Private" を使用（推奨）
#    - オンプレミスからのアクセスが必要: "CustomerOwnedIp" を使用
#    - CoIPを使用する場合、Local Gateway Route Tableの設定も必要
#
# 4. パフォーマンスとスケーラビリティ
#    - S3 on OutpostsのDNSが複数のENIに負荷分散を実施
#    - CoIPアクセスタイプの場合、ローカルゲートウェイの帯域幅制限を考慮
#    - 高トラフィックが予想される場合、ネットワーク容量を事前に確認
#
# 5. 可用性と耐障害性
#    - エンドポイント作成には最大5分かかる場合があるため、自動化時に考慮
#    - Outpostsとリージョン間の接続断絶時の影響を理解
#    - S3 on Outpostsのバックアップと災害復旧計画を策定
#
# 6. モニタリングとロギング
#    - VPC Flow Logsを有効化してトラフィックを監視
#    - CloudWatch Logsで S3 Outposts API 呼び出しを追跡
#    - エンドポイントのヘルスチェックを定期的に実施
#
# 7. コスト最適化
#    - 不要なエンドポイントは削除してコストを削減
#    - データ転送コストを考慮した設計
#    - Outpostsの容量とコストを定期的に見直し
#
# 8. 依存リソースの管理
#    - エンドポイント削除前に、依存するアクセスポイントを確認
#    - Terraformのlifecycleルールを活用して削除保護を実装
#    - 関連するIAMポリシーとサービスリンクロールを適切に管理
#
# 9. アップグレードとメンテナンス
#    - Outpostsソフトウェアのアップデート時の影響を確認
#    - Terraformプロバイダーのバージョンを定期的に更新
#    - 新機能や変更点を継続的にチェック
#
# 10. トラブルシューティング
#     - エンドポイント作成失敗時は、Outposts接続状態を確認
#     - セキュリティグループとネットワークACLを検証
#     - IAM権限とサービスリンクロールの設定を確認
#     - AWS Supportに連絡する前に、CloudWatch Logsを収集

################################################################################
# 関連リソース
################################################################################
# - aws_s3outposts_bucket: Outposts上のS3バケット
# - aws_s3outposts_bucket_policy: Outposts S3バケットのポリシー
# - aws_outposts_outpost: Outpostsインスタンスのデータソース
# - aws_vpc: Virtual Private Cloud
# - aws_subnet: VPCサブネット
# - aws_security_group: セキュリティグループ
# - aws_ec2_coip_pool: 顧客所有IPアドレスプール（CoIP）

################################################################################
# 参考ドキュメント
################################################################################
# - Terraform AWS Provider Documentation:
#   https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3outposts_endpoint
#
# - AWS S3 on Outposts Networking:
#   https://docs.aws.amazon.com/AmazonS3/latest/s3-outposts/S3OutpostsNetworking.html
#
# - Creating an endpoint on an Outpost:
#   https://docs.aws.amazon.com/AmazonS3/latest/s3-outposts/S3OutpostsCreateEndpoint.html
#
# - AWS S3 on Outposts API Reference - CreateEndpoint:
#   https://docs.aws.amazon.com/AmazonS3/latest/API/API_s3outposts_CreateEndpoint.html
#
# - AWS Outposts User Guide - Local Gateway:
#   https://docs.aws.amazon.com/outposts/latest/userguide/local-rack.html#local-gateway-subnet
