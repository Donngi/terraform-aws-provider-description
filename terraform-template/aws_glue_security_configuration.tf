#---------------------------------------------------------------
# AWS Glue Security Configuration
#---------------------------------------------------------------
#
# AWS Glue のセキュリティ設定をプロビジョニングするリソースです。
# CloudWatch ログ、ジョブブックマーク、S3 データのそれぞれに対して
# 暗号化方式を設定し、Glue ジョブ・クローラー・開発エンドポイントに
# アタッチすることでデータ保護を実現します。
#
# AWS公式ドキュメント:
#   - セキュリティ設定の概要: https://docs.aws.amazon.com/glue/latest/dg/console-security-configurations.html
#   - 暗号化オプション: https://docs.aws.amazon.com/glue/latest/dg/encryption-security-configuration.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_security_configuration
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_glue_security_configuration" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: セキュリティ設定の名前を指定します。
  # 設定可能な値: 任意の文字列
  name = "my-glue-security-configuration"

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # 暗号化設定
  #-------------------------------------------------------------

  # encryption_configuration (Required)
  # 設定内容: CloudWatch ログ・ジョブブックマーク・S3 データの暗号化設定ブロックです。
  # 関連機能: AWS KMS との統合によりデータの保存時暗号化を実現します。
  #   - https://docs.aws.amazon.com/glue/latest/dg/encryption-security-configuration.html
  encryption_configuration {

    # cloudwatch_encryption (Required)
    # 設定内容: CloudWatch ログの暗号化設定ブロックです。
    cloudwatch_encryption {

      # cloudwatch_encryption_mode (Optional)
      # 設定内容: CloudWatch ログデータの暗号化モードを指定します。
      # 設定可能な値:
      #   - "DISABLED": 暗号化しない（デフォルト）
      #   - "SSE-KMS": AWS KMS を使用したサーバーサイド暗号化
      # 省略時: "DISABLED" が使用されます
      cloudwatch_encryption_mode = "DISABLED"

      # kms_key_arn (Optional)
      # 設定内容: CloudWatch ログの暗号化に使用する KMS キーの ARN を指定します。
      # 設定可能な値: 有効な KMS キー ARN（例: arn:aws:kms:ap-northeast-1:123456789012:key/...）
      # 省略時: cloudwatch_encryption_mode が SSE-KMS の場合は必須、DISABLED の場合は不要
      kms_key_arn = null
    }

    # job_bookmarks_encryption (Required)
    # 設定内容: ジョブブックマークデータの暗号化設定ブロックです。
    job_bookmarks_encryption {

      # job_bookmarks_encryption_mode (Optional)
      # 設定内容: ジョブブックマークデータの暗号化モードを指定します。
      # 設定可能な値:
      #   - "DISABLED": 暗号化しない（デフォルト）
      #   - "CSE-KMS": AWS KMS を使用したクライアントサイド暗号化
      # 省略時: "DISABLED" が使用されます
      job_bookmarks_encryption_mode = "DISABLED"

      # kms_key_arn (Optional)
      # 設定内容: ジョブブックマークの暗号化に使用する KMS キーの ARN を指定します。
      # 設定可能な値: 有効な KMS キー ARN（例: arn:aws:kms:ap-northeast-1:123456789012:key/...）
      # 省略時: job_bookmarks_encryption_mode が CSE-KMS の場合は必須、DISABLED の場合は不要
      kms_key_arn = null
    }

    # s3_encryption (Required)
    # 設定内容: S3 に保存されるデータの暗号化設定ブロックです。
    s3_encryption {

      # s3_encryption_mode (Optional)
      # 設定内容: S3 データの暗号化モードを指定します。
      # 設定可能な値:
      #   - "DISABLED": 暗号化しない（デフォルト）
      #   - "SSE-KMS": AWS KMS を使用したサーバーサイド暗号化
      #   - "SSE-S3": S3 マネージドキーを使用したサーバーサイド暗号化
      # 省略時: "DISABLED" が使用されます
      s3_encryption_mode = "SSE-KMS"

      # kms_key_arn (Optional)
      # 設定内容: S3 データの暗号化に使用する KMS キーの ARN を指定します。
      # 設定可能な値: 有効な KMS キー ARN（例: arn:aws:kms:ap-northeast-1:123456789012:key/...）
      # 省略時: s3_encryption_mode が SSE-KMS の場合は必須、DISABLED/SSE-S3 の場合は不要
      kms_key_arn = null
    }
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: Glue セキュリティ設定の名前
#---------------------------------------------------------------
