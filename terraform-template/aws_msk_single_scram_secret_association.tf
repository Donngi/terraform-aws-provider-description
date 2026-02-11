#---------------------------------------------------------------
# AWS MSK Single SCRAM Secret Association
#---------------------------------------------------------------
#
# Amazon MSK (Managed Streaming for Apache Kafka) クラスターに
# 単一の SCRAM シークレットを関連付けるリソースです。
# SASL/SCRAM (Simple Authentication and Security Layer/ Salted Challenge
# Response Mechanism) 認証を使用して、Kafka クライアントの認証を行います。
#
# SCRAM 認証の特徴:
#   - AWS Secrets Manager にユーザー認証情報を保存
#   - SCRAM-SHA-512 ハッシュアルゴリズムを使用
#   - プレーンテキストでの認証情報送信を回避
#   - MSK は自動的にすべてのクライアント・ブローカー間通信で TLS 暗号化を有効化
#
# 制限事項:
#   - シークレット名は "AmazonMSK_" プレフィックスが必須
#   - 1 クラスターあたり最大 1000 ユーザー
#   - カスタム AWS KMS キーが必要（デフォルトの Secrets Manager キーは不可）
#   - 非対称 KMS キーは非サポート
#   - シークレットはクラスターと同じ AWS アカウント・リージョンに存在する必要がある
#
# 注意:
#   - 本リソースは単一のシークレットを関連付けます。
#   - 複数のシークレットを一度に関連付ける場合は aws_msk_scram_secret_association を使用してください。
#   - MSK は関連付けられたシークレットの認証情報を定期的に同期します。
#
# AWS公式ドキュメント:
#   - SCRAM 認証の概要: https://docs.aws.amazon.com/msk/latest/developerguide/msk-password.html
#   - SCRAM 認証の仕組み: https://docs.aws.amazon.com/msk/latest/developerguide/msk-password-howitworks.html
#   - SCRAM シークレットの制限: https://docs.aws.amazon.com/msk/latest/developerguide/msk-password-limitations.html
#   - SCRAM 認証セットアップチュートリアル: https://docs.aws.amazon.com/msk/latest/developerguide/msk-password-tutorial.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/msk_single_scram_secret_association
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_msk_single_scram_secret_association" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # cluster_arn (Required, Forces new resource)
  # 設定内容: SCRAM シークレットを関連付ける MSK クラスターの Amazon Resource Name (ARN) を指定します。
  # 設定可能な値: 有効な MSK クラスター ARN
  # 形式: arn:aws:kafka:region:account-id:cluster/cluster-name/cluster-uuid
  # 注意:
  #   - この値を変更するとリソースが再作成されます。
  #   - クラスターは事前に作成されている必要があります。
  #   - SCRAM 認証を有効にするには、クラスター作成時に authentication_info で設定が必要です。
  # 関連リソース: aws_msk_cluster
  cluster_arn = "arn:aws:kafka:ap-northeast-1:123456789012:cluster/my-msk-cluster/12345678-1234-1234-1234-123456789012"

  # secret_arn (Required, Forces new resource)
  # 設定内容: MSK クラスターに関連付ける AWS Secrets Manager シークレットの ARN を指定します。
  # 設定可能な値: 有効な Secrets Manager シークレット ARN
  # 形式: arn:aws:secretsmanager:region:account-id:secret:secret-name-suffix
  # 必須条件:
  #   - シークレット名は "AmazonMSK_" プレフィックスで始まる必要があります
  #   - カスタム AWS KMS キーで暗号化されている必要があります
  #   - 対称 KMS キーのみサポート（非対称キーは不可）
  #   - シークレットはクラスターと同じアカウント・リージョンに存在する必要があります
  # シークレットの形式:
  #   キー: username (Kafka ユーザー名)
  #   キー: password (Kafka ユーザーのパスワード)
  # 注意:
  #   - この値を変更するとリソースが再作成されます。
  #   - シークレットの KMS キーやリソースポリシーを変更しないでください。
  #   - MSK は関連付け後、認証情報を定期的に同期します。
  # 関連リソース: aws_secretsmanager_secret, aws_secretsmanager_secret_version
  # 参考: https://docs.aws.amazon.com/msk/latest/developerguide/msk-password-tutorial.html
  secret_arn = "arn:aws:secretsmanager:ap-northeast-1:123456789012:secret:AmazonMSK_kafka_user1-AbCdEf"

  #-------------------------------------------------------------
  # オプション設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 注意:
  #   - シークレットと MSK クラスターは同じリージョンに存在する必要があります。
  #   - 通常は省略してプロバイダーのリージョンを使用することを推奨します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# 以下は、MSK クラスターに SCRAM 認証を設定する完全な例です。
#
# # 1. カスタム KMS キーの作成
# resource "aws_kms_key" "msk_scram" {
#   description = "KMS key for MSK SCRAM authentication"
# }
#
# # 2. Secrets Manager シークレットの作成
# resource "aws_secretsmanager_secret" "msk_user" {
#   name       = "AmazonMSK_kafka_user1"
#   kms_key_id = aws_kms_key.msk_scram.id
# }
#
# # 3. シークレットのバージョン（認証情報）の設定
# resource "aws_secretsmanager_secret_version" "msk_user" {
#   secret_id = aws_secretsmanager_secret.msk_user.id
#   secret_string = jsonencode({
#     username = "kafka_user1"
#     password = "YourSecurePassword123!"
#   })
# }
#
# # 4. MSK クラスターの作成（SCRAM 認証を有効化）
# resource "aws_msk_cluster" "example" {
#   cluster_name           = "my-msk-cluster"
#   kafka_version          = "3.5.1"
#   number_of_broker_nodes = 3
#
#   broker_node_group_info {
#     instance_type   = "kafka.m5.large"
#     client_subnets  = ["subnet-xxx", "subnet-yyy", "subnet-zzz"]
#     security_groups = ["sg-xxx"]
#   }
#
#   client_authentication {
#     sasl {
#       scram = true
#     }
#   }
#
#   encryption_info {
#     encryption_in_transit {
#       client_broker = "TLS"
#       in_cluster    = true
#     }
#   }
# }
#
# # 5. SCRAM シークレットの関連付け
# resource "aws_msk_single_scram_secret_association" "example" {
#   cluster_arn = aws_msk_cluster.example.arn
#   secret_arn  = aws_secretsmanager_secret.msk_user.arn
#
#   depends_on = [aws_secretsmanager_secret_version.msk_user]
# }
#---------------------------------------------------------------

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: MSK クラスター ARN とシークレット ARN の組み合わせ
#       形式: cluster_arn,secret_arn
#---------------------------------------------------------------

#---------------------------------------------------------------
# Import
#---------------------------------------------------------------
# 既存の SCRAM シークレット関連付けをインポートできます。
# インポート ID は以下の形式を使用します:
#
# terraform import aws_msk_single_scram_secret_association.example \
#   arn:aws:kafka:ap-northeast-1:123456789012:cluster/my-cluster/uuid,arn:aws:secretsmanager:ap-northeast-1:123456789012:secret:AmazonMSK_user-xxx
#---------------------------------------------------------------
