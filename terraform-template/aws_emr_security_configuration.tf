#---------------------------------------
# aws_emr_security_configuration
#---------------------------------------
# 用途: Amazon EMRクラスターのセキュリティ設定を管理
# 説明: EMRクラスターで使用する暗号化設定やKerberos認証設定などのセキュリティ構成を定義するリソースです。
#      保管時の暗号化（S3、EBSボリューム）、転送時の暗号化、Kerberos認証の設定をJSON形式で指定します。
# 公式ドキュメント: https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-security-configurations.html
# Terraformドキュメント: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/emr_security_configuration
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: このテンプレートは参照用です。実際の使用時は環境に応じて値を調整してください。

resource "aws_emr_security_configuration" "example" {
  #-------
  # 基本設定
  #-------

  # 設定内容: セキュリティ設定のJSON定義（必須）
  # 設定可能な値: 暗号化設定やKerberos認証設定を含むJSON形式の文字列
  # 補足: EncryptionConfiguration（保管時・転送時の暗号化）、AuthenticationConfiguration（Kerberos認証）などを含む
  configuration = <<EOF
{
  "EncryptionConfiguration": {
    "AtRestEncryptionConfiguration": {
      "S3EncryptionConfiguration": {
        "EncryptionMode": "SSE-S3"
      },
      "LocalDiskEncryptionConfiguration": {
        "EncryptionKeyProviderType": "AwsKms",
        "AwsKmsKey": "arn:aws:kms:us-west-2:123456789012:alias/emr-key"
      }
    },
    "EnableInTransitEncryption": false,
    "EnableAtRestEncryption": true
  }
}
EOF

  #-------
  # 識別子設定
  #-------

  # 設定内容: セキュリティ設定の名前
  # 設定可能な値: 64文字以内の任意の文字列
  # 省略時: Terraformが自動的に一意の名前を生成
  # 補足: name_prefixと同時には指定不可
  name = "emr-security-config"

  # 設定内容: セキュリティ設定名のプレフィックス
  # 設定可能な値: 任意の文字列（この後に乱数が付加される）
  # 省略時: なし
  # 補足: nameと同時には指定不可
  name_prefix = "emr-sc-"

  #-------
  # リージョン設定
  #-------

  # 設定内容: リソースを管理するAWSリージョン
  # 設定可能な値: AWSリージョンコード（例: us-east-1、ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 補足: リージョン間でのリソース管理を制御
  region = "ap-northeast-1"
}

#---------------------------------------
# Attributes Reference（参照専用属性）
#---------------------------------------
# このリソースでは以下の属性が参照可能です（computed）:
#
# - id: セキュリティ設定のID（nameと同値）
# - name: セキュリティ設定の名前
# - configuration: セキュリティ設定のJSON定義
# - creation_date: セキュリティ設定が作成された日時
# - region: リソースが管理されているリージョン
#
# 参照例:
#   aws_emr_security_configuration.example.id
#   aws_emr_security_configuration.example.creation_date
