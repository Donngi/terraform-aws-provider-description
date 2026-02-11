#---------------------------------------------------------------
# AWS Quantum Ledger Database (QLDB) Ledger
#---------------------------------------------------------------
#
# Amazon Quantum Ledger Database (QLDB) の台帳リソースをプロビジョニングします。
# QLDBは、透過的で不変、かつ暗号的に検証可能なトランザクションログを
# 中央の信頼された機関によって管理される完全マネージド型の台帳データベースです。
#
# AWS公式ドキュメント:
#   - Amazon QLDB とは: https://docs.aws.amazon.com/qldb/latest/developerguide/what-is.html
#   - Amazon QLDB の機能: https://aws.amazon.com/qldb/features/
#   - QLDB の暗号化: https://docs.aws.amazon.com/qldb/latest/developerguide/encryption-at-rest.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/qldb_ledger
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_qldb_ledger" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # 台帳のアクセス許可モード
  # 有効な値: "ALLOW_ALL" または "STANDARD"
  # - ALLOW_ALL: すべてのユーザーに完全なアクセス権限を付与（開発/テスト用）
  # - STANDARD: IAMポリシーによる詳細なアクセス制御を使用（本番環境推奨）
  permissions_mode = "STANDARD"

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # 台帳の名前
  # 指定しない場合はTerraformによって自動生成されます
  # 命名規則: 1-32文字、英数字とハイフンのみ使用可能
  name = "example-ledger"

  # 削除保護の有効化
  # デフォルト: true
  # trueの場合、Terraformで削除する前にfalseに設定する必要があります
  # 本番環境では削除保護を有効にしておくことを強く推奨します
  deletion_protection = true

  # 保管データの暗号化に使用するKMSキー
  # 有効な値:
  # - "AWS_OWNED_KMS_KEY": AWSが所有・管理するKMSキーを使用（デフォルト）
  # - カスタマーマネージドKMSキーのARN: 対称キーのみサポート
  # 例: "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
  kms_key = "AWS_OWNED_KMS_KEY"

  # リソースのリージョン
  # 指定しない場合、プロバイダー設定のリージョンが使用されます
  # このパラメータはリソースが作成されるリージョンを明示的に指定します
  # region = "us-east-1"

  # リソースタグ
  # プロバイダーのdefault_tagsと組み合わせて使用されます
  tags = {
    Environment = "production"
    Application = "ledger-system"
    ManagedBy   = "terraform"
  }

  #---------------------------------------------------------------
  # タイムアウト設定
  #---------------------------------------------------------------

  timeouts {
    # 台帳の作成タイムアウト
    # デフォルト: なし（タイムアウトなし）
    # 例: "10m" (10分)
    create = "10m"

    # 台帳の削除タイムアウト
    # デフォルト: なし（タイムアウトなし）
    # 例: "10m" (10分)
    delete = "10m"
  }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします（読み取り専用）:
#
# - id: 台帳の名前
# - arn: 台帳のAmazon Resource Name (ARN)
# - tags_all: リソースに割り当てられたタグのマップ
#             プロバイダーのdefault_tagsから継承されたタグを含む
#
# 使用例:
# output "ledger_arn" {
#   value = aws_qldb_ledger.example.arn
# }
#---------------------------------------------------------------
