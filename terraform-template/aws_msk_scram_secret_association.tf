#---------------------------------------------------------------
# AWS MSK SCRAM Secret Association
#---------------------------------------------------------------
#
# Amazon MSK (Managed Streaming for Apache Kafka) クラスターに
# 複数の SCRAM シークレットを一括で関連付けるリソースです。
# SASL/SCRAM (Simple Authentication and Security Layer / Salted Challenge
# Response Mechanism) 認証を使用して、Kafka クライアントの認証を行います。
#
# SCRAM 認証の特徴:
#   - AWS Secrets Manager にユーザー認証情報を保存
#   - SCRAM-SHA-512 ハッシュアルゴリズムを使用
#   - プレーンテキストでの認証情報送信を回避
#   - MSK は自動的にすべてのクライアント・ブローカー間通信で TLS 暗号化を有効化
#
# aws_msk_single_scram_secret_association との違い:
#   - 本リソースは複数のシークレットをセットで管理します。
#   - secret_arn_list に記載されていないシークレットはクラスターから切り離されます。
#   - 単一シークレットのみ管理する場合は aws_msk_single_scram_secret_association を推奨します。
#
# 制限事項:
#   - シークレット名は "AmazonMSK_" プレフィックスが必須
#   - 1 クラスターあたり最大 1000 ユーザー
#   - カスタム AWS KMS キーが必要（デフォルトの Secrets Manager キーは不可）
#   - 非対称 KMS キーは非サポート
#   - シークレットはクラスターと同じ AWS アカウント・リージョンに存在する必要がある
#
# AWS公式ドキュメント:
#   - SCRAM 認証の概要: https://docs.aws.amazon.com/msk/latest/developerguide/msk-password.html
#   - SCRAM 認証の仕組み: https://docs.aws.amazon.com/msk/latest/developerguide/msk-password-howitworks.html
#   - SCRAM シークレットの制限: https://docs.aws.amazon.com/msk/latest/developerguide/msk-password-limitations.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/msk_scram_secret_association
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_msk_scram_secret_association" "example" {
  #-------------------------------------------------------------
  # MSK クラスター設定
  #-------------------------------------------------------------

  # cluster_arn (Required)
  # 設定内容: SCRAM シークレットを関連付ける MSK クラスターの Amazon Resource Name (ARN) を指定します。
  # 設定可能な値: 有効な MSK クラスター ARN
  # 省略時: 省略不可
  # 形式: arn:aws:kafka:region:account-id:cluster/cluster-name/cluster-uuid
  # 注意:
  #   - クラスターは事前に作成されている必要があります。
  #   - SCRAM 認証を有効にするには、クラスター作成時に client_authentication.sasl.scram = true の設定が必要です。
  # 関連リソース: aws_msk_cluster
  cluster_arn = "arn:aws:kafka:ap-northeast-1:123456789012:cluster/my-msk-cluster/12345678-1234-1234-1234-123456789012"

  #-------------------------------------------------------------
  # SCRAM シークレット設定
  #-------------------------------------------------------------

  # secret_arn_list (Required)
  # 設定内容: MSK クラスターに関連付ける AWS Secrets Manager シークレット ARN のセットを指定します。
  # 設定可能な値: 有効な Secrets Manager シークレット ARN の集合（set 型）
  # 省略時: 省略不可
  # 必須条件:
  #   - シークレット名は "AmazonMSK_" プレフィックスで始まる必要があります
  #   - カスタム AWS KMS キーで暗号化されている必要があります（対称キーのみ）
  #   - シークレットはクラスターと同じアカウント・リージョンに存在する必要があります
  # シークレットの形式 (JSON):
  #   { "username": "Kafka ユーザー名", "password": "Kafka ユーザーのパスワード" }
  # 注意:
  #   - このリストに含まれないシークレットはクラスターから自動的に切り離されます。
  #   - 複数ユーザーを管理する場合、全シークレット ARN をこのリストで一元管理してください。
  # 関連リソース: aws_secretsmanager_secret, aws_secretsmanager_secret_version
  secret_arn_list = [
    "arn:aws:secretsmanager:ap-northeast-1:123456789012:secret:AmazonMSK_kafka_user1-AbCdEf",
    "arn:aws:secretsmanager:ap-northeast-1:123456789012:secret:AmazonMSK_kafka_user2-GhIjKl",
  ]

  #-------------------------------------------------------------
  # リージョン設定
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
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: MSK クラスターの ARN
#        形式: arn:aws:kafka:region:account-id:cluster/cluster-name/cluster-uuid
#---------------------------------------------------------------

#---------------------------------------------------------------
# Import
#---------------------------------------------------------------
# 既存の SCRAM シークレット関連付けをインポートできます。
# インポート ID は MSK クラスターの ARN を使用します。
#
# terraform import aws_msk_scram_secret_association.example \
#   arn:aws:kafka:ap-northeast-1:123456789012:cluster/my-cluster/uuid
#---------------------------------------------------------------
