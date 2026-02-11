#---------------------------------------------------------------
# AWS MSK Cluster Policy（クラスターポリシー）
#---------------------------------------------------------------
#
# Amazon Managed Streaming for Apache Kafka（MSK）クラスターに対する
# リソースベースのポリシー（クラスターポリシー）を管理します。
#
# クラスターポリシーは以下の目的で使用されます：
# - クロスアカウントでのプライベート接続（Multi-VPC Private Connectivity）の許可
# - IAMクライアント認証を使用する場合のKafkaデータプレーン権限の詳細な制御
#
# 最大ポリシーサイズは20KBです。
#
# AWS公式ドキュメント:
#   - Amazon MSK resource-based policies: https://docs.aws.amazon.com/msk/latest/developerguide/security_iam_service-with-iam-resource-based-policies.html
#   - Amazon MSK multi-VPC private connectivity: https://docs.aws.amazon.com/msk/latest/developerguide/aws-access-mult-vpc.html
#   - Step 2: Attach a cluster policy to the MSK cluster: https://docs.aws.amazon.com/msk/latest/developerguide/mvpc-cluster-owner-action-policy.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/msk_cluster_policy
#
# Provider Version: 6.28.0
# Generated: 2026-01-29
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_msk_cluster_policy" "example" {

  #---------------------------------------------------------------
  # 必須引数（Required Arguments）
  #---------------------------------------------------------------

  # cluster_arn - (必須) MSKクラスターのARN
  #
  # クラスターポリシーを適用するMSKクラスターを一意に識別するAmazon Resource Name（ARN）。
  # Multi-VPC Private Connectivityを使用する場合、クラスターは以下の要件を満たす必要があります：
  # - Apache Kafka 2.7.1以降を実行していること
  # - IAM、TLS、またはSASL/SCRAM認証をサポートしていること
  #
  # 型: string
  cluster_arn = aws_msk_cluster.example.arn

  # policy - (必須) クラスターのリソースポリシー
  #
  # クラスターに適用するIAMポリシードキュメント（JSON形式）。
  # このポリシーで以下の権限を制御できます：
  # - kafka:Describe* - クラスター、トピック、グループ情報の取得
  # - kafka:Get* - 設定情報の取得
  # - kafka:CreateVpcConnection - VPC接続の作成（Multi-VPC用）
  # - kafka:GetBootstrapBrokers - ブートストラップブローカー情報の取得
  #
  # クロスアカウントアクセスの場合、Principal には対象アカウントのIAMプリンシパルを指定します。
  # 最大サイズは20KBです。
  #
  # 型: string（JSON形式）
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Sid    = "ExampleMskClusterPolicy"
      Effect = "Allow"
      Principal = {
        "AWS" = "arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:root"
      }
      Action = [
        "kafka:Describe*",
        "kafka:Get*",
        "kafka:CreateVpcConnection",
        "kafka:GetBootstrapBrokers",
      ]
      Resource = aws_msk_cluster.example.arn
    }]
  })

  #---------------------------------------------------------------
  # 任意引数（Optional Arguments）
  #---------------------------------------------------------------

  # id - (任意) リソースのID
  #
  # リソースの一意な識別子。指定しない場合は cluster_arn と同じ値が使用されます。
  # 通常は指定する必要はありません。
  #
  # 型: string
  # デフォルト: cluster_arn の値
  # id = null

  # region - (任意) このリソースを管理するAWSリージョン
  #
  # リソースを管理するAWSリージョンを指定します。
  # 指定しない場合はプロバイダー設定で指定されたリージョンが使用されます。
  #
  # 参照: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  #
  # 型: string
  # デフォルト: プロバイダー設定のリージョン
  # region = null
}

#---------------------------------------------------------------
# Attributes Reference（参照専用属性）
#
# 以下の属性はリソース作成後に参照可能です（terraform outputやリソース参照で使用）。
#---------------------------------------------------------------
#
# current_version - クラスターポリシーの現在のバージョン
#                   ポリシーを更新する際の楽観的ロックに使用されます。
#
# id - リソースのID（cluster_arn と同じ値）
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例：クロスアカウントでのMulti-VPC Private Connectivity
#---------------------------------------------------------------
#
# # 現在のAWSアカウント情報を取得
# data "aws_caller_identity" "current" {}
# data "aws_partition" "current" {}
#
# # 別アカウントからのVPC接続を許可するクラスターポリシー
# resource "aws_msk_cluster_policy" "cross_account" {
#   cluster_arn = aws_msk_cluster.example.arn
#
#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [{
#       Sid    = "AllowCrossAccountVpcConnection"
#       Effect = "Allow"
#       Principal = {
#         "AWS" = "arn:aws:iam::123456789012:root"  # 接続を許可するアカウントID
#       }
#       Action = [
#         "kafka:CreateVpcConnection",
#         "kafka:GetBootstrapBrokers",
#         "kafka:DescribeCluster",
#         "kafka:DescribeClusterV2",
#       ]
#       Resource = aws_msk_cluster.example.arn
#     }]
#   })
# }
#
#---------------------------------------------------------------
