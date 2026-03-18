#-----------------------------------------------------------------------
# AWS Invoicing Invoice Unit
#-----------------------------------------------------------------------
#
# AWS請求書ユニット（Invoice Unit）を作成・管理するリソースです。
# 複数のリンクアカウントをグループ化し、請求書を分割して受信先ごとに
# 個別の請求書を発行するための設定を管理します。
# 管理アカウント（Billing and Cost Management）でのみ使用可能です。
#
# AWS公式ドキュメント:
#   - Invoice Units: https://docs.aws.amazon.com/invoicing/latest/userguide/invoice-units.html
#   - CreateInvoiceUnit API: https://docs.aws.amazon.com/invoicing/latest/APIReference/API_CreateInvoiceUnit.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/invoicing_invoice_unit
#
# Provider Version: 6.36.0
# Generated: 2026-03-18
#
# NOTE:
#   - このリソースはAWS管理アカウントでのみ作成可能。メンバーアカウントからは操作できない
#   - invoice_receiverには請求書を受信するアカウントIDを指定し、対象アカウントは組織内のメンバーである必要がある
#   - ruleブロックのlinked_accountsには請求書をグループ化するアカウントIDのセットを指定する
#   - 税務継承（tax_inheritance_disabled）を無効にすると、リンクアカウントが独自の税務設定を使用できる
#-----------------------------------------------------------------------

resource "aws_invoicing_invoice_unit" "example" {
  #-----------------------------------------------------------------------
  # 基本設定
  #-----------------------------------------------------------------------

  # 設定内容: Invoice Unitの名前
  # 設定可能な値: 文字列（一意である必要がある）
  # 省略時: 設定必須
  name = "example-invoice-unit"

  # 設定内容: 請求書を受信するアカウントのID
  # 設定可能な値: AWSアカウントID（12桁の数値文字列、例: "123456789012"）
  # 省略時: 設定必須
  invoice_receiver = "123456789012"

  # 設定内容: Invoice Unitの説明
  # 設定可能な値: 任意の文字列
  # 省略時: 説明は設定されない
  description = "Example invoice unit for department billing"

  # 設定内容: 税務継承を無効にするかどうか
  # 設定可能な値: true（税務継承を無効化）/ false（税務継承を有効化）
  # 省略時: 計算される（デフォルトはfalse）
  tax_inheritance_disabled = false

  #-----------------------------------------------------------------------
  # リソース配置
  #-----------------------------------------------------------------------

  # 設定内容: リソースを管理するAWSリージョン
  # 設定可能な値: AWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダーで設定されたリージョンが使用される
  region = null

  #-----------------------------------------------------------------------
  # ルール設定
  #-----------------------------------------------------------------------

  # 設定内容: Invoice Unitにグループ化するリンクアカウントのルール
  # 省略時: ルールが設定されない
  rule {
    # 設定内容: 請求書ユニットに含めるリンクアカウントIDのセット
    # 設定可能な値: AWSアカウントIDの集合（例: ["123456789012", "234567890123"]）
    # 省略時: 設定必須
    linked_accounts = [
      "123456789012",
      "234567890123",
    ]
  }

  #-----------------------------------------------------------------------
  # タグ
  #-----------------------------------------------------------------------

  # 設定内容: リソースに割り当てるタグのマップ
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグは設定されない
  tags = {
    Name        = "example-invoice-unit"
    Environment = "production"
    ManagedBy   = "terraform"
  }

  #-----------------------------------------------------------------------
  # タイムアウト設定
  #-----------------------------------------------------------------------

  # 設定内容: 作成・更新・削除操作のタイムアウト時間
  # 設定可能な値: 時間文字列（例: "5m", "1h"）
  # 省略時: デフォルトのタイムアウト設定が使用される
  # timeouts {
  #   create = "5m"
  #   update = "5m"
  #   delete = "5m"
  # }
}

#-----------------------------------------------------------------------
# Attributes Reference
#-----------------------------------------------------------------------
# このリソースが公開する属性の参照方法
#
# - arn: Invoice UnitのARN
#   aws_invoicing_invoice_unit.example.arn
#
# - id: Invoice UnitのID（arnと同一）
#   aws_invoicing_invoice_unit.example.id
#
# - last_modified: Invoice Unitが最後に変更された日時（ISO 8601形式）
#   aws_invoicing_invoice_unit.example.last_modified
#
# - tags_all: プロバイダーのdefault_tagsを含む全タグのマップ
#   aws_invoicing_invoice_unit.example.tags_all
#
