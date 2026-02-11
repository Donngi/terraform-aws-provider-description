#---------------------------------------------------------------
# Amazon DataZone Glossary Term
#---------------------------------------------------------------
#
# DataZone Glossary Term リソースは、ビジネス用語集内の個別のエントリを
# 表します。各用語には詳細な定義、同義語、関連用語、使用例などの
# リッチなメタデータを含めることができます。用語はデータアセットに
# 直接リンクでき、技術的なデータ要素にビジネスコンテキストを提供します。
# 用語間の関係を定義することで、ビジネス概念の複雑さを反映する
# セマンティックネットワークを作成できます。
#
# AWS公式ドキュメント:
#   - CreateGlossaryTerm API: https://docs.aws.amazon.com/datazone/latest/APIReference/API_CreateGlossaryTerm.html
#   - Create a term in a glossary: https://docs.aws.amazon.com/datazone/latest/userguide/create-maintain-term.html
#   - Amazon DataZone terminology and concepts: https://docs.aws.amazon.com/datazone/latest/userguide/datazone-concepts.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/datazone_glossary_term
#
# Provider Version: 6.28.0
# Generated: 2026-01-28
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_datazone_glossary_term" "example" {
  #---------------------------------------------------------------
  # Required Parameters
  #---------------------------------------------------------------

  # domain_identifier - (Required) DataZoneドメインの識別子
  # DataZoneドメインの一意の識別子を指定します。
  # パターン: dzd[-_][a-zA-Z0-9_-]{1,36}
  # 例: "dzd_53ielnpxktdilj"
  domain_identifier = "dzd_example123"

  # glossary_identifier - (Required) ビジネス用語集の識別子
  # この用語を作成する用語集の一意の識別子を指定します。
  # 用語集は事前に作成されている必要があります。
  # パターン: [a-zA-Z0-9_-]{1,36}
  # 例: "gls8m3nqx2wkfp"
  glossary_identifier = "gls_example123"

  # name - (Required) ビジネス用語の名前
  # 用語集内で一意の名前を指定します。
  # 同じ用語集内で重複する名前は使用できません。
  # 長さ: 1～256文字
  # 例: "CustomerLifetimeValue", "Revenue", "DataQuality"
  name = "example_term"

  #---------------------------------------------------------------
  # Optional Parameters
  #---------------------------------------------------------------

  # long_description - (Optional) 用語の詳細な説明
  # ビジネス用語の詳細な説明文を指定します。
  # 用語の意味、使用方法、コンテキストなどを含めることができます。
  # 長さ: 0～4096文字
  # 例: "Customer Lifetime Value (CLV) is the total revenue a business can
  #      reasonably expect from a single customer account throughout the
  #      business relationship."
  long_description = null

  # short_description - (Optional) 用語の簡潔な説明
  # ビジネス用語の簡潔な説明文を指定します。
  # 長さ: 0～1024文字
  # 例: "Total revenue expected from a customer over their lifetime"
  short_description = null

  # status - (Optional) 用語のステータス
  # 用語が有効か無効かを指定します。
  # 有効な値: "ENABLED" または "DISABLED"
  # デフォルト: "ENABLED"
  # ENABLEDの場合、用語はアクティブで使用可能です。
  # DISABLEDの場合、用語は無効化され、新しい関連付けには使用できません。
  status = "ENABLED"

  # region - (Optional) リージョン
  # このリソースを管理するAWSリージョンを指定します。
  # 指定しない場合、プロバイダー設定のリージョンが使用されます。
  # 例: "us-east-1", "ap-northeast-1"
  region = null

  #---------------------------------------------------------------
  # Nested Blocks
  #---------------------------------------------------------------

  # term_relations - (Optional) 用語の関係性
  # 他の用語との関係を定義するブロックです。
  # 用語間の階層構造やセマンティックな関係を表現できます。
  term_relations {
    # classifies - (Optional) 分類する用語のリスト
    # 現在の用語が分類する用語の識別子のリストを指定します。
    # 現在の用語が、指定された用語の汎用的な用語であることを示します。
    # 例: "Vehicle"という用語が["Car", "Truck", "Motorcycle"]を分類
    # 最小: 1項目、最大: 10項目
    # パターン: [a-zA-Z0-9_-]{1,36}
    # 例: ["trm_abc123", "trm_def456"]
    classifies = []

    # is_a - (Optional) 上位概念の用語リスト
    # 現在の用語が特定の型であることを示す用語の識別子のリストを指定します。
    # 現在の用語が、識別された用語のサブタイプであることを示します。
    # 例: "Car"という用語が"Vehicle"の is_a 関係を持つ
    # 最小: 1項目、最大: 10項目
    # パターン: [a-zA-Z0-9_-]{1,36}
    # 例: ["trm_parent123"]
    is_a = []
  }

  #---------------------------------------------------------------
  # Tags
  #---------------------------------------------------------------

  # タグはこのリソースではサポートされていません
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# このリソースでは以下の属性が参照可能です（computed値）:
#
# - id - 用語の一意の識別子
#   パターン: [a-zA-Z0-9_-]{1,36}
#   例: "trm9k4pq7xwnmh"
#
# - created_at - 用語の作成日時
#   RFC3339形式のタイムスタンプ
#   例: "2024-01-15T10:30:00Z"
#
# - created_by - 用語を作成したユーザー
#   作成者の識別子（IAMユーザーまたはSSOユーザー）
#
# 参照例:
#   aws_datazone_glossary_term.example.id
#   aws_datazone_glossary_term.example.created_at
#   aws_datazone_glossary_term.example.created_by
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# Import
#---------------------------------------------------------------
# 既存のDataZone Glossary Termをインポートできます:
#
# terraform import aws_datazone_glossary_term.example domain_id:glossary_term_id
#
# 例:
# terraform import aws_datazone_glossary_term.example dzd_53ielnpxktdilj:trm9k4pq7xwnmh
#
#---------------------------------------------------------------
