#---------------------------------------------------------------
# AWS Invoicing Invoice Unit
#---------------------------------------------------------------
#
# AWS Invoicingサービスのインボイスユニットをプロビジョニングするリソースです。
# インボイスユニットは、AWS組織内の複数のアカウントからの請求を統合し、
# 特定の請求先アカウントに割り当てるための論理的なグループ化単位です。
# これにより、組織内の請求管理を柔軟に行うことができます。
#
# 主な機能:
# - AWS組織内の異なるビジネスエンティティに対して個別の請求書を受け取る
# - メンバーアカウントをビジネスエンティティに対応する論理ユニットに集約
# - 各ビジネスエンティティのコストと請求を個別に追跡
# - 各インボイスユニットに購買発注書(PO)を関連付けて資金追跡を実施
# - 組織全体のボリュームディスカウントを維持しながら請求書を分離
#
# 利用シーン:
# - 複数の子会社やビジネスユニットを持つ組織で個別請求が必要な場合
# - AWSコストを異なるコストセンターに追跡・配分する必要がある企業
# - 複数の税設定と記録システムを管理する企業
# - 異なる部門やプロジェクトに対して個別請求が必要な組織
#
# 重要な注意事項:
# - インボイスユニット名とinvoice_receiverは作成後に変更できません
# - メンバーアカウントは正しい税設定と請求情報を設定する必要があります
# - インボイスユニットは相互排他的なメンバーアカウントで構成されます
#   （1つのアカウントは1つのインボイスユニットにのみ所属可能）
# - インボイスユニットは支払者アカウントの支払方法と条件を継承します
# - 支払者アカウントとメンバーアカウントの両方がすべての請求に対して
#   連帯責任を負います
# - インボイスユニットへの変更は次の請求月の開始時に有効になります
# - GovCloud (US)と中国リージョンを除くすべてのパブリックAWSリージョンで利用可能
#
# AWS公式ドキュメント:
#   - Invoice Configuration概要: https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/invoice-configuration.html
#   - インボイスユニットの作成: https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/invoice-configuration-create.html
#   - トラブルシューティング: https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/invoice-configuration-delete-troubleshooting.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/invoicing_invoice_unit
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_invoicing_invoice_unit" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # name (Required, Forces new resource)
  # 設定内容: インボイスユニットの名前を指定します。
  # 設定可能な値: 1文字以上の文字列
  # 注意:
  #   - 組織内で一意である必要があります
  #   - リソース作成後の変更はできません（Forces new resource）
  #   - ビジネスエンティティや目的を反映した説明的な名前を使用してください
  # 推奨命名例:
  #   - ビジネスユニット名: "sales-division", "engineering-dept"
  #   - 子会社名: "subsidiary-apac", "subsidiary-emea"
  #   - コストセンター名: "cost-center-1234"
  name = "example-invoice-unit"

  # invoice_receiver (Required, Forces new resource)
  # 設定内容: このユニットの請求書を受け取るAWSアカウントIDを指定します。
  # 設定可能な値: 12桁のAWSアカウントID
  # 注意:
  #   - このアカウントに対してメンバーアカウントの請求が統合された請求書が送信されます
  #   - リソース作成後の変更はできません（Forces new resource）
  #   - 請求受信アカウントは同じAWS組織の一部である必要があります
  #   - 請求受信アカウントが閉鎖または組織から削除された場合、
  #     インボイスユニット全体が削除されます
  # ベストプラクティス:
  #   - 閉鎖または削除されない安定したアカウントを選択してください
  #   - アカウントに適切な請求連絡先が設定されていることを確認してください
  #   - インボイスユニット作成前に税設定が正しいことを確認してください
  invoice_receiver = "123456789012"

  #-------------------------------------------------------------
  # インボイスユニットルール設定
  #-------------------------------------------------------------

  # rule (Required)
  # 設定内容: インボイスユニットに含めるアカウントを定義するルールです。
  # 注意:
  #   - 少なくとも1つのruleブロックが必要です
  #   - 各ルールでlinked_accountsを指定します
  #   - メンバーアカウントはインボイスユニット間で相互排他的である必要があります
  #   - アカウントは1つのインボイスユニットにのみ所属できます
  #   - アカウントの追加・削除はいつでも可能ですが、変更は次の請求月から有効になります
  rule {
    # linked_accounts (Required)
    # 設定内容: このインボイスユニットに含めるAWSアカウントIDのセットを指定します。
    # 設定可能な値: AWSアカウントIDの配列（12桁の数字）
    # 注意:
    #   - 各アカウントIDは有効な12桁のAWSアカウントIDである必要があります
    #   - アカウントは同じAWS組織の一部である必要があります
    #   - アカウントは相互排他的である必要があります（複数のインボイスユニットに所属不可）
    #   - 少なくとも1つのアカウントを指定する必要があります
    # 動作:
    #   - これらのアカウントの請求は、invoice_receiverアカウントに送信される
    #     請求書に表示されます
    #   - アカウントの追加・削除は月中いつでも可能です
    #   - 変更は次の月次請求書から有効になります
    #   - メンバーアカウントが閉鎖または組織から削除された場合、
    #     自動的に請求書から除外されます
    linked_accounts = [
      "098765432109",
      "111111111111",
    ]
  }

  #-------------------------------------------------------------
  # オプション設定
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: インボイスユニットの説明を指定します。
  # 設定可能な値: 文字列
  # 省略時: 説明なし
  # ベストプラクティス:
  #   - このインボイスユニットがどのビジネスエンティティを表すかの情報を含める
  #   - 含まれるアカウントの目的やスコープを文書化する
  #   - 特別な請求上の考慮事項があれば記載する
  description = "Invoice unit for production workloads"

  # tax_inheritance_disabled (Optional)
  # 設定内容: このインボイスユニットの税金継承を無効化するかどうかを指定します。
  # 設定可能な値:
  #   - true: 税金設定の継承を無効化（メンバーアカウントが独立した税設定を使用）
  #   - false: 税金設定を継承（デフォルト）
  # 省略時: false（支払者アカウントから税金設定を継承）
  # 利用シーン:
  #   - ビジネスエンティティごとに異なる税要件がある組織
  #   - メンバーアカウントが独立した税設定を必要とするシナリオ
  #   - 異なる税管轄区域を持つ国際的な組織
  # 重要な注意事項:
  #   - trueに設定すると、メンバーアカウントは独自に税設定を
  #     構成する必要があります
  #   - 請求の問題を避けるため、継承を無効化する前に
  #     適切な税設定を確認してください
  tax_inheritance_disabled = false

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 注意:
  #   - この設定は、リソースが管理される場所に影響し、
  #     請求が発生する場所には影響しません
  #   - インボイスユニットは組織全体に適用され、
  #     すべてのリージョンの請求に影響します
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  # ベストプラクティス:
  #   - すべてのインボイスユニットで一貫したタグ付け戦略を使用する
  #   - 以下のタグを含める: Owner, Environment, CostCenter, Department
  #   - コスト追跡とレポート作成を容易にするためにタグを使用する
  #   - コンプライアンスとガバナンス要件を考慮する
  # 一般的なタグキー:
  #   - Environment: production, staging, development
  #   - Owner: 責任を持つチームまたは個人
  #   - CostCenter: 内部コスト配分用
  #   - BusinessUnit: 組織部門
  #   - ManagedBy: terraform, manual など
  tags = {
    Name        = "example-invoice-unit"
    Environment = "production"
    CostCenter  = "finance"
    ManagedBy   = "terraform"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定します。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: 期間文字列（例: "30s", "5m", "2h"）
    # 省略時: デフォルトのタイムアウト値が使用されます
    # 参考: https://pkg.go.dev/time#ParseDuration
    create = "10m"

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウト時間を指定します。
    # 設定可能な値: 期間文字列（例: "30s", "5m", "2h"）
    # 省略時: デフォルトのタイムアウト値が使用されます
    update = "10m"

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: 期間文字列（例: "30s", "5m", "2h"）
    # 省略時: デフォルトのタイムアウト値が使用されます
    # 注意: Delete操作のタイムアウトは、destroy操作が発生する前に
    #       変更がstateに保存される場合にのみ適用されます。
    delete = "10m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: インボイスユニットのAmazon Resource Name (ARN)
#   形式: arn:aws:invoicing:region:account-id:invoice-unit/unit-id
#
# - last_modified: インボイスユニットが最後に変更された日時
#   形式: RFC3339タイムスタンプ
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#
# 使用例:
#   - ARNの参照: aws_invoicing_invoice_unit.example.arn
#   - IDの参照: aws_invoicing_invoice_unit.example.id
#   - 最終更新日時の参照: aws_invoicing_invoice_unit.example.last_modified
#---------------------------------------------------------------

#---------------------------------------------------------------
# Import
#---------------------------------------------------------------
# 既存のインボイスユニットをTerraform管理下にインポートできます。
#
# インポート構文:
#   terraform import aws_invoicing_invoice_unit.example invoice-unit-id
#
# 例:
#   terraform import aws_invoicing_invoice_unit.example iu-1234567890abcdef0
#
# 注意:
#   - インボイスユニットIDは、請求コンソールのInvoice Configurationで確認できます
#   - インポート後、terraform planを実行して、インポートされたstateと
#     設定の違いを確認してください
#---------------------------------------------------------------

#---------------------------------------------------------------
# Lifecycle設定の考慮事項
#---------------------------------------------------------------
# 誤削除の防止:
# lifecycle {
#   prevent_destroy = true
# }
#
# 外部タグ変更の無視:
# lifecycle {
#   ignore_changes = [tags]
# }
#
# 注意:
# - nameまたはinvoice_receiverの変更はリソースの置き換えが必要です
# - linked_accountsの変更は次の請求月の開始時に有効になります
# - インボイスユニットの削除は次月の請求に影響します
# - 誤削除を避けるためにprevent_destroyの使用を検討してください
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例1: 複数のインボイスユニット（異なるビジネスエンティティ用）
#---------------------------------------------------------------
/*
resource "aws_invoicing_invoice_unit" "sales_division" {
  name             = "sales-division-us"
  description      = "Invoice unit for US Sales Division"
  invoice_receiver = "111111111111"

  rule {
    linked_accounts = [
      "222222222222",
      "333333333333",
    ]
  }

  tags = {
    Environment  = "production"
    BusinessUnit = "sales"
    Region       = "us"
    CostCenter   = "CC-SALES-001"
  }
}

resource "aws_invoicing_invoice_unit" "engineering_division" {
  name             = "engineering-division"
  description      = "Invoice unit for Engineering Division"
  invoice_receiver = "444444444444"

  rule {
    linked_accounts = [
      "555555555555",
      "666666666666",
      "777777777777",
    ]
  }

  tags = {
    Environment  = "production"
    BusinessUnit = "engineering"
    CostCenter   = "CC-ENG-001"
  }
}
*/

#---------------------------------------------------------------
# 使用例2: 税金継承を無効化したインボイスユニット
#---------------------------------------------------------------
/*
resource "aws_invoicing_invoice_unit" "international_subsidiary" {
  name                     = "subsidiary-emea"
  description              = "Invoice unit for EMEA subsidiary with separate tax settings"
  invoice_receiver         = "888888888888"
  tax_inheritance_disabled = true

  rule {
    linked_accounts = [
      "999999999999",
      "000000000000",
    ]
  }

  tags = {
    Environment  = "production"
    BusinessUnit = "subsidiary-emea"
    Region       = "emea"
    TaxEntity    = "separate"
  }
}
*/

#---------------------------------------------------------------
# 使用例3: 変数とデータソースの使用
#---------------------------------------------------------------
/*
variable "invoice_units" {
  description = "Configuration for invoice units"
  type = map(object({
    description      = string
    invoice_receiver = string
    linked_accounts  = list(string)
    tags             = map(string)
  }))
  default = {}
}

resource "aws_invoicing_invoice_unit" "this" {
  for_each = var.invoice_units

  name             = each.key
  description      = each.value.description
  invoice_receiver = each.value.invoice_receiver

  rule {
    linked_accounts = each.value.linked_accounts
  }

  tags = merge(
    each.value.tags,
    {
      ManagedBy = "terraform"
    }
  )
}

output "invoice_unit_arns" {
  description = "ARNs of created invoice units"
  value       = { for k, v in aws_invoicing_invoice_unit.this : k => v.arn }
}

output "invoice_unit_ids" {
  description = "IDs of created invoice units"
  value       = { for k, v in aws_invoicing_invoice_unit.this : k => v.id }
}
*/

#---------------------------------------------------------------
# よくあるエラーとトラブルシューティング
#---------------------------------------------------------------
# エラー: Account already in another invoice unit
# 解決策: アカウントは相互排他的である必要があります。
#         まず他のインボイスユニットからアカウントを削除してください。
#
# エラー: Invalid invoice receiver account
# 解決策: invoice_receiverアカウントが同じAWS組織の一部であり、
#         適切な請求設定がされていることを確認してください。
#
# エラー: Cannot change name or invoice_receiver
# 解決策: これらのフィールドは新しいリソースを強制します。
#         既存のインボイスユニットを削除して新しいものを作成する必要があります。
#
# エラー: Invoice receiver account deleted
# 解決策: 請求受信アカウントが閉鎖または削除された場合、
#         インボイスユニットは自動的に削除されます。
#         別の受信アカウントで新しいインボイスユニットを作成してください。
#---------------------------------------------------------------

#---------------------------------------------------------------
# 関連リソース
#---------------------------------------------------------------
# このリソースは以下のリソースとよく連携します:
# - AWS Organizations: aws_organizations_organization
# - AWS Accounts: aws_organizations_account
# - Cost Categories: インボイスユニット別に請求を可視化
# - Cost and Usage Report (CUR): 詳細なコスト分析用
#
# 統合例:
# - AWS Organizationsと連携してメンバーアカウントを管理
# - Cost Explorerと統合してインボイスユニット別のコストを可視化
# - Cost and Usage Reportsを設定してインボイスユニット別の請求を追跡
# - Cost Categoriesを使用してインボイスユニットに整合したカスタムグループを作成
#---------------------------------------------------------------

#---------------------------------------------------------------
# 追加リソース
#---------------------------------------------------------------
# AWSブログ:
# - Invoice Configurationを使用したAWS請求書の設定:
#   https://aws.amazon.com/blogs/aws-cloud-financial-management/configuring-your-aws-invoices-using-invoice-configuration/
#
# AWS公式ドキュメント:
# - インボイスユニットの作成:
#   https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/invoice-configuration-create.html
# - Invoice Configuration概要:
#   https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/invoice-configuration.html
# - トラブルシューティング:
#   https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/invoice-configuration-delete-troubleshooting.html
#
# Terraform Registry:
# - リソースドキュメント:
#   https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/invoicing_invoice_unit
#---------------------------------------------------------------
