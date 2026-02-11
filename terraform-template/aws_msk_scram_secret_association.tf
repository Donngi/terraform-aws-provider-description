#---------------------------------------------------------------
# aws_msk_scram_secret_association
#---------------------------------------------------------------
#
# Amazon MSK (Managed Streaming for Apache Kafka) クラスターと
# AWS Secrets Manager に保存された SCRAM シークレットを関連付けるリソース。
#
# SASL/SCRAM 認証を使用することで、ユーザー名とパスワードによる
# クライアント認証が可能になる。MSK クラスターで SASL/SCRAM 認証を
# 有効にし、Secrets Manager にシークレットを作成した後、
# このリソースで関連付けを行う。
#
# 重要: このリソースは MSK クラスターに関連付けられた SCRAM シークレットの
# 排他的な所有権を持つ。明示的に設定されていない SCRAM シークレットは
# 削除される。aws_msk_single_scram_secret_association と併用する場合は、
# secret_arn_list にそれらのシークレットも含める必要がある。
#
# AWS公式ドキュメント:
#   - Sign-in credentials authentication with AWS Secrets Manager: https://docs.aws.amazon.com/msk/latest/developerguide/msk-password.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/msk_scram_secret_association
#
# Provider Version: 6.28.0
# Generated: 2026-01-29
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_msk_scram_secret_association" "this" {
  #---------------------------------------------------------------
  # 必須引数 (Required Arguments)
  #---------------------------------------------------------------

  # cluster_arn (Required, Forces new resource)
  # MSK クラスターの Amazon Resource Name (ARN)。
  # SCRAM シークレットを関連付ける対象の MSK クラスターを指定する。
  # この属性を変更すると、リソースは再作成される。
  #
  # 前提条件:
  #   - MSK クラスターで SASL/SCRAM 認証が有効になっている必要がある
  #     (client_authentication.sasl.scram = true)
  #
  # 型: string
  cluster_arn = null # 例: aws_msk_cluster.example.arn

  # secret_arn_list (Required)
  # AWS Secrets Manager シークレットの ARN のリスト。
  # MSK クラスターに関連付けるシークレットを指定する。
  #
  # シークレットの要件:
  #   - シークレット名は "AmazonMSK_" プレフィックスで始まる必要がある
  #   - カスタム AWS KMS キーで暗号化されている必要がある
  #     (AWS マネージドキーは使用不可)
  #   - シークレット値は {"username": "xxx", "password": "xxx"} 形式の JSON
  #   - MSK がシークレットを読み取れるように、Secrets Manager シークレット
  #     ポリシーで kafka.amazonaws.com サービスプリンシパルへの
  #     secretsmanager:getSecretValue アクションを許可する必要がある
  #
  # 注意:
  #   - このリソースは SCRAM シークレットの排他的所有権を持つため、
  #     このリストに含まれないシークレットは関連付けから削除される
  #   - aws_msk_single_scram_secret_association と併用する場合は、
  #     それらのシークレットもこのリストに含める必要がある
  #
  # 型: set(string)
  secret_arn_list = null # 例: [aws_secretsmanager_secret.example.arn]

  #---------------------------------------------------------------
  # オプション引数 (Optional Arguments)
  #---------------------------------------------------------------

  # region (Optional)
  # このリソースを管理する AWS リージョン。
  # 指定しない場合、プロバイダー設定のリージョンが使用される。
  #
  # 参照: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  #
  # 型: string
  # デフォルト: プロバイダー設定のリージョン
  # region = null # 例: "ap-northeast-1"
}

#---------------------------------------------------------------
# Attributes Reference (実行後に参照可能な属性)
#---------------------------------------------------------------
#
# id
#   - MSK クラスターの Amazon Resource Name (ARN)
#   - cluster_arn と同じ値
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例
#---------------------------------------------------------------
#
# # 基本的な使用例
# resource "aws_msk_scram_secret_association" "example" {
#   cluster_arn     = aws_msk_cluster.example.arn
#   secret_arn_list = [aws_secretsmanager_secret.example.arn]
#
#   depends_on = [aws_secretsmanager_secret_version.example]
# }
#
# # MSK クラスター (SASL/SCRAM 認証を有効化)
# resource "aws_msk_cluster" "example" {
#   cluster_name = "example"
#   # ... その他の設定 ...
#   client_authentication {
#     sasl {
#       scram = true
#     }
#   }
# }
#
# # KMS キー (シークレットの暗号化用)
# resource "aws_kms_key" "example" {
#   description = "KMS key for MSK SCRAM secret"
# }
#
# # Secrets Manager シークレット
# resource "aws_secretsmanager_secret" "example" {
#   name       = "AmazonMSK_example"
#   kms_key_id = aws_kms_key.example.key_id
# }
#
# # シークレット値
# resource "aws_secretsmanager_secret_version" "example" {
#   secret_id     = aws_secretsmanager_secret.example.id
#   secret_string = jsonencode({ username = "user", password = "pass" })
# }
#
# # MSK がシークレットを読み取るためのポリシー
# data "aws_iam_policy_document" "example" {
#   statement {
#     sid    = "AWSKafkaResourcePolicy"
#     effect = "Allow"
#
#     principals {
#       type        = "Service"
#       identifiers = ["kafka.amazonaws.com"]
#     }
#
#     actions   = ["secretsmanager:getSecretValue"]
#     resources = [aws_secretsmanager_secret.example.arn]
#   }
# }
#
# resource "aws_secretsmanager_secret_policy" "example" {
#   secret_arn = aws_secretsmanager_secret.example.arn
#   policy     = data.aws_iam_policy_document.example.json
# }
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# Import
#---------------------------------------------------------------
#
# terraform import aws_msk_scram_secret_association.example arn:aws:kafka:us-west-2:123456789012:cluster/example/4bc7a0da-0000-0000-0000-000000000000-1
#
#---------------------------------------------------------------
