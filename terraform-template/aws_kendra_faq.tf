#---------------------------------------------------------------
# Amazon Kendra FAQ
#---------------------------------------------------------------
#
# Amazon Kendra のインデックスに FAQ (よくある質問) を追加するリソース。
# CSV または JSON 形式のファイルから質問と回答のペアを読み込み、
# 検索可能な FAQ データとしてインデックスに追加します。
#
# FAQ ファイルは S3 バケットに配置され、カスタムフィールドや
# アクセス制御リストを含めることが可能です。
#
# AWS公式ドキュメント:
#   - Adding FAQs to an index: https://docs.aws.amazon.com/kendra/latest/dg/in-creating-faq.html
#   - CreateFaq API Reference: https://docs.aws.amazon.com/kendra/latest/APIReference/API_CreateFaq.html
#   - IAM Roles for Amazon Kendra: https://docs.aws.amazon.com/kendra/latest/dg/iam-roles.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kendra_faq
#
# Provider Version: 6.28.0
# Generated: 2026-01-28
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_kendra_faq" "example" {
  #---------------------------------------------------------------
  # Required Parameters
  #---------------------------------------------------------------

  # (Required) FAQ を追加する Amazon Kendra インデックスの ID。
  # インデックスは事前に作成されている必要があります。
  # 変更するとリソースが再作成されます (Forces new resource)。
  index_id = "your-kendra-index-id"

  # (Required) FAQ に関連付ける名前。
  # 管理しやすい一意の名前を指定してください。
  # 変更するとリソースが再作成されます (Forces new resource)。
  name = "example-faq"

  # (Required) S3 バケット内の FAQ ファイルにアクセスする権限を持つ IAM ロールの ARN。
  # このロールには、指定した S3 バケットからファイルを読み取る権限が必要です。
  # 詳細は IAM Roles for Amazon Kendra のドキュメントを参照してください。
  # 変更するとリソースが再作成されます (Forces new resource)。
  role_arn = "arn:aws:iam::123456789012:role/KendraFaqRole"

  #---------------------------------------------------------------
  # S3 Path Configuration (Required Block)
  #---------------------------------------------------------------

  # (Required) FAQ 入力データが格納されている S3 の場所を指定します。
  # このブロックは必須で、1つのみ指定可能です (min_items=1, max_items=1)。
  # 変更するとリソースが再作成されます (Forces new resource)。
  s3_path {
    # (Required) FAQ ファイルが含まれる S3 バケットの名前。
    # 変更するとリソースが再作成されます (Forces new resource)。
    bucket = "your-s3-bucket-name"

    # (Required) FAQ ファイルの S3 キー (パス)。
    # 例: "faqs/example-faq.csv" または "faqs/example-faq.json"
    # 変更するとリソースが再作成されます (Forces new resource)。
    key = "faqs/example-faq.csv"
  }

  #---------------------------------------------------------------
  # Optional Parameters
  #---------------------------------------------------------------

  # (Optional) FAQ の説明文。
  # FAQ の用途や内容を説明するために使用します。
  # 変更するとリソースが再作成されます (Forces new resource)。
  description = "Example FAQ for demonstration purposes"

  # (Optional) FAQ 入力ファイルのファイル形式。
  # 有効な値: "CSV", "CSV_WITH_HEADER", "JSON"
  #
  # - CSV: 基本的な CSV 形式 (各行が質問、回答、オプションのソース URI)
  # - CSV_WITH_HEADER: カスタムフィールドを含むヘッダー付き CSV 形式
  # - JSON: カスタムフィールドやアクセス制御を含む JSON 形式
  #
  # デフォルト: 指定しない場合は CSV として処理されます。
  # 変更するとリソースが再作成されます (Forces new resource)。
  file_format = "CSV"

  # (Optional) FAQ ドキュメントの言語コード。
  # Amazon Kendra がサポートする言語を指定します。
  # 英語がデフォルトでサポートされています。
  #
  # 例: "en" (英語), "ja" (日本語), "es" (スペイン語), "fr" (フランス語) など
  # サポートされる言語の詳細は以下のドキュメントを参照してください:
  # https://docs.aws.amazon.com/kendra/latest/dg/in-adding-languages.html
  #
  # 変更するとリソースが再作成されます (Forces new resource)。
  language_code = "en"

  # (Optional) リソースに設定するタグのキー/値マップ。
  # プロバイダーの default_tags 設定ブロックが存在する場合、
  # 一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #
  # タグは、リソースの管理、コスト配分、アクセス制御などに使用できます。
  tags = {
    Environment = "production"
    Application = "search"
    Team        = "data"
  }

  # (Optional) このリソースが管理されるリージョン。
  # 指定しない場合は、プロバイダー設定で指定されたリージョンがデフォルトで使用されます。
  # 詳細: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  #
  # 通常は省略してプロバイダー設定のリージョンを使用することが推奨されます。
  # region = "us-east-1"

  # (Optional) リソースの一意識別子。
  # 通常は Terraform が自動的に管理するため、明示的な指定は不要です。
  # 指定する場合は、"{faq_id}/{index_id}" の形式になります。
  # computed 属性でもあるため、省略した場合は自動的に生成されます。
  # id = "faq-id/index-id"

  # (Optional) リソースに割り当てられた全てのタグのマップ。
  # プロバイダーの default_tags 設定ブロックから継承されたタグも含まれます。
  # この属性は computed でもあるため、通常は tags 属性のみを使用し、
  # tags_all は読み取り専用として扱うことが推奨されます。
  # tags_all = {}

  #---------------------------------------------------------------
  # Timeouts (Optional)
  #---------------------------------------------------------------

  # FAQ 作成と削除のタイムアウト時間をカスタマイズできます。
  # 大きな FAQ ファイルを処理する場合は、タイムアウト時間を長く設定することを検討してください。
  # timeouts {
  #   # (Optional) FAQ の作成操作のタイムアウト時間。
  #   # デフォルト: 30分
  #   # 形式: "30m", "1h" など
  #   create = "30m"
  #
  #   # (Optional) FAQ の削除操作のタイムアウト時間。
  #   # デフォルト: 30分
  #   # 形式: "30m", "1h" など
  #   delete = "30m"
  # }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
#
# このリソースは以下の属性をエクスポートします (computed 専用):
#
# - arn
#   FAQ の Amazon Resource Name (ARN)。
#   他の AWS リソースで FAQ を参照する際に使用します。
#
# - created_at
#   FAQ が作成された Unix 日時。
#   ISO 8601 形式の文字列として返されます。
#
# - error_message
#   Status フィールドの値が "FAILED" の場合、
#   失敗の理由を説明するメッセージが含まれます。
#
# - faq_id
#   FAQ の一意識別子。
#   Amazon Kendra API で FAQ を参照する際に使用します。
#
# - id
#   FAQ とインデックスの一意識別子をスラッシュで区切った形式。
#   形式: "{faq_id}/{index_id}"
#   Terraform でリソースを識別するために使用されます。
#
# - status
#   FAQ のステータス。
#   ステータスが "ACTIVE" になると、FAQ は検索可能になります。
#   可能な値: "CREATING", "ACTIVE", "UPDATING", "DELETING", "FAILED"
#
# - tags_all
#   リソースに割り当てられたタグのマップ。
#   プロバイダーの default_tags 設定ブロックから継承されたタグを含みます。
#
# - updated_at
#   FAQ が最後に更新された日時。
#   ISO 8601 形式の文字列として返されます。
#
#---------------------------------------------------------------
# Usage Example
#---------------------------------------------------------------
#
# FAQ ARN を参照する例:
#   output "faq_arn" {
#     value = aws_kendra_faq.example.arn
#   }
#
# FAQ ステータスを確認する例:
#   output "faq_status" {
#     value = aws_kendra_faq.example.status
#   }
#
#---------------------------------------------------------------
