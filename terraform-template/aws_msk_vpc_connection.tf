#---------------------------------------------------------------
# AWS MSK VPC Connection (aws_msk_vpc_connection)
#---------------------------------------------------------------
#
# Amazon MSK（Managed Streaming for Apache Kafka）のVPCコネクションを
# プロビジョニングするリソース。
#
# MSK VPCコネクションは、異なるVPCやAWSアカウントにあるApache Kafkaクライアントが
# AWS PrivateLinkを使用してMSKクラスターにプライベート接続するための機能。
# これにより、すべてのトラフィックをAWSネットワーク内に保持したまま、
# マルチVPCおよびクロスアカウント接続を実現できる。
#
# 主な要件:
#   - MSKクラスターはApache Kafka 2.7.1以降を実行している必要がある
#   - IAM、TLS、またはSASL/SCRAM認証をサポートしている必要がある
#   - クライアントサブネットとクラスターサブネットの数が同じで、
#     同一のアベイラビリティゾーンIDを持つ必要がある
#
# 制限事項:
#   - t3.smallインスタンスタイプはサポートされない
#   - AWSリージョン間のマルチVPC接続はサポートされない
#   - ZooKeeperノードへのマルチVPC接続はサポートされない
#
# AWS公式ドキュメント:
#   - Amazon MSK multi-VPC private connectivity: https://docs.aws.amazon.com/msk/latest/developerguide/aws-access-mult-vpc.html
#   - Get started using multi-VPC private connectivity: https://docs.aws.amazon.com/msk/latest/developerguide/mvpc-getting-started.html
#   - Permissions for multi-VPC private connectivity: https://docs.aws.amazon.com/msk/latest/developerguide/mvpc-cross-account-permissions.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/msk_vpc_connection
#
# Provider Version: 6.28.0
# Generated: 2026-01-29
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_msk_vpc_connection" "example" {
  #---------------------------------------------------------------
  # 必須引数 (Required Arguments)
  #---------------------------------------------------------------

  # authentication - クライアントVPCコネクションの認証タイプ
  #
  # 説明:
  #   VPCコネクションで使用する認証メカニズムを指定する。
  #   MSKクラスター側で有効化されている認証スキームと一致させる必要がある。
  #
  # 有効な値:
  #   - "SASL_IAM"   : AWS IAMを使用した認証
  #   - "SASL_SCRAM" : SASL/SCRAM（Simple Authentication and Security Layer /
  #                    Salted Challenge Response Authentication Mechanism）認証
  #   - "TLS"        : TLS（Transport Layer Security）クライアント認証
  #
  # 注意:
  #   - IAM認証を使用する場合、クライアントに適切なIAMポリシーが必要
  #   - SASL/SCRAM認証を使用する場合、Apache Kafka ACLの設定が必要
  #   - TLS認証を使用する場合、クライアント証明書の設定が必要
  #
  # 型: string
  # 必須: はい
  authentication = "SASL_IAM"

  # target_cluster_arn - ターゲットMSKクラスターのARN
  #
  # 説明:
  #   接続先となるMSKクラスターのAmazon Resource Name（ARN）を指定する。
  #   クロスアカウント接続の場合、クラスターオーナーがクラスターポリシーで
  #   接続元アカウントに適切な権限を付与している必要がある。
  #
  # 形式:
  #   arn:aws:kafka:<region>:<account-id>:cluster/<cluster-name>/<cluster-id>
  #
  # 前提条件:
  #   - クラスターはACTIVE状態である必要がある
  #   - クラスターはApache Kafka 2.7.1以降を実行している必要がある
  #   - クラスターでマルチVPC接続が有効化されている必要がある
  #
  # 型: string
  # 必須: はい
  target_cluster_arn = aws_msk_cluster.example.arn

  # vpc_id - クライアントVPCのID
  #
  # 説明:
  #   VPCコネクションを作成するクライアント側のVPC IDを指定する。
  #   このVPCからMSKクラスターへのプライベート接続が確立される。
  #
  # 形式:
  #   vpc-xxxxxxxxxxxxxxxxx
  #
  # 注意:
  #   - 指定するVPCはMSKクラスターのVPCとは異なるVPCである必要がある
  #   - 同一VPC内のクライアントはVPCコネクションを使用せずに直接接続可能
  #
  # 型: string
  # 必須: はい
  vpc_id = aws_vpc.client.id

  # client_subnets - クライアントVPCのサブネットリスト
  #
  # 説明:
  #   VPCコネクションに使用するクライアントVPC内のサブネットIDのリストを指定する。
  #   これらのサブネットにVPCエンドポイントが作成される。
  #
  # 要件:
  #   - クラスターサブネットと同じ数のサブネットを指定する必要がある
  #   - 各サブネットのアベイラビリティゾーンIDが、
  #     クラスターサブネットのアベイラビリティゾーンIDと一致する必要がある
  #
  # 注意:
  #   - アベイラビリティゾーン名ではなくアベイラビリティゾーンIDで一致させる
  #   - 例: us-east-1a（名前）ではなく use1-az1（ID）で一致
  #
  # 型: set(string)
  # 必須: はい
  client_subnets = [
    aws_subnet.client_az1.id,
    aws_subnet.client_az2.id,
    aws_subnet.client_az3.id,
  ]

  # security_groups - セキュリティグループのリスト
  #
  # 説明:
  #   VPCエンドポイントのENI（Elastic Network Interface）に
  #   アタッチするセキュリティグループのIDリストを指定する。
  #
  # 要件:
  #   - Kafkaブローカーポートへのアウトバウンドトラフィックを許可する必要がある
  #   - クライアントネットワークからのインバウンドトラフィックを許可する必要がある
  #
  # ポート情報（認証タイプ別）:
  #   - IAM認証: 9098
  #   - SASL/SCRAM認証: 9096
  #   - TLS認証: 9094
  #   - 非認証: 9092（マルチVPC接続では非推奨）
  #
  # 型: set(string)
  # 必須: はい
  security_groups = [
    aws_security_group.msk_client.id,
  ]

  #---------------------------------------------------------------
  # オプション引数 (Optional Arguments)
  #---------------------------------------------------------------

  # region - リソースを管理するリージョン
  #
  # 説明:
  #   このリソースを管理するAWSリージョンを指定する。
  #   指定しない場合、プロバイダー設定のリージョンが使用される。
  #
  # 参照:
  #   - AWSリージョナルエンドポイント: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  #   - プロバイダー設定: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#aws-configuration-reference
  #
  # 型: string
  # 必須: いいえ
  # デフォルト: プロバイダー設定のリージョン
  # region = "ap-northeast-1"

  # tags - リソースに割り当てるタグ
  #
  # 説明:
  #   リソースに割り当てるタグのマップを指定する。
  #   プロバイダーレベルで default_tags が設定されている場合、
  #   同じキーを持つタグはこちらの設定で上書きされる。
  #
  # 参照:
  #   - default_tags設定: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  #
  # 型: map(string)
  # 必須: いいえ
  # デフォルト: null
  tags = {
    Name        = "example-msk-vpc-connection"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference（参照専用属性）
#---------------------------------------------------------------
#
# 以下の属性はリソース作成後にTerraformによって自動的に設定され、
# 他のリソースから参照可能。これらは直接設定することはできない。
#
# arn - VPCコネクションのARN
#   説明: 作成されたVPCコネクションのAmazon Resource Name
#   形式: arn:aws:kafka:<region>:<account-id>:vpc-connection/<connection-id>
#   参照例: aws_msk_vpc_connection.example.arn
#
# id - リソースID
#   説明: VPCコネクションの一意識別子（ARNと同値）
#   参照例: aws_msk_vpc_connection.example.id
#
# tags_all - 全てのタグ
#   説明: リソースに割り当てられた全タグのマップ
#         プロバイダーの default_tags で設定されたタグを含む
#   参照例: aws_msk_vpc_connection.example.tags_all
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例: クロスアカウントVPCコネクションの設定
#---------------------------------------------------------------
#
# # クライアント側のVPC
# resource "aws_vpc" "client" {
#   cidr_block = "10.1.0.0/16"
#
#   tags = {
#     Name = "msk-client-vpc"
#   }
# }
#
# # クライアント側のサブネット（3つのAZ）
# resource "aws_subnet" "client_az1" {
#   vpc_id            = aws_vpc.client.id
#   cidr_block        = "10.1.1.0/24"
#   availability_zone = "ap-northeast-1a"
#
#   tags = {
#     Name = "msk-client-subnet-az1"
#   }
# }
#
# resource "aws_subnet" "client_az2" {
#   vpc_id            = aws_vpc.client.id
#   cidr_block        = "10.1.2.0/24"
#   availability_zone = "ap-northeast-1c"
#
#   tags = {
#     Name = "msk-client-subnet-az2"
#   }
# }
#
# resource "aws_subnet" "client_az3" {
#   vpc_id            = aws_vpc.client.id
#   cidr_block        = "10.1.3.0/24"
#   availability_zone = "ap-northeast-1d"
#
#   tags = {
#     Name = "msk-client-subnet-az3"
#   }
# }
#
# # MSKクライアント用セキュリティグループ
# resource "aws_security_group" "msk_client" {
#   name        = "msk-client-sg"
#   description = "Security group for MSK VPC connection"
#   vpc_id      = aws_vpc.client.id
#
#   # IAM認証用のアウトバウンドルール（ポート9098）
#   egress {
#     from_port   = 9098
#     to_port     = 9098
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#     description = "MSK broker IAM auth port"
#   }
#
#   # クライアントからのインバウンドルール
#   ingress {
#     from_port   = 9098
#     to_port     = 9098
#     protocol    = "tcp"
#     cidr_blocks = [aws_vpc.client.cidr_block]
#     description = "Allow Kafka clients from VPC"
#   }
#
#   tags = {
#     Name = "msk-client-sg"
#   }
# }
#
# # VPCコネクション
# resource "aws_msk_vpc_connection" "cross_account" {
#   authentication     = "SASL_IAM"
#   target_cluster_arn = "arn:aws:kafka:ap-northeast-1:123456789012:cluster/my-cluster/abc123"
#   vpc_id             = aws_vpc.client.id
#   client_subnets = [
#     aws_subnet.client_az1.id,
#     aws_subnet.client_az2.id,
#     aws_subnet.client_az3.id,
#   ]
#   security_groups = [aws_security_group.msk_client.id]
#
#   tags = {
#     Name = "cross-account-msk-connection"
#   }
# }
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 関連リソース
#---------------------------------------------------------------
#
# aws_msk_cluster
#   - VPCコネクションのターゲットとなるMSKクラスター
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/msk_cluster
#
# aws_msk_cluster_policy
#   - クロスアカウント接続に必要なクラスターポリシー
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/msk_cluster_policy
#
# aws_msk_serverless_cluster
#   - MSK Serverlessクラスター（VPCコネクションのターゲットとして使用可能）
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/msk_serverless_cluster
#
# aws_vpc
#   - VPCコネクションを作成するVPC
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc
#
# aws_subnet
#   - VPCコネクション用のサブネット
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
#
# aws_security_group
#   - VPCエンドポイント用のセキュリティグループ
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
#
#---------------------------------------------------------------
