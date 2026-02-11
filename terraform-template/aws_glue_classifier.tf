################################################################################
# AWS Glue Classifier
# Terraform Resource: aws_glue_classifier
# AWS Provider Version: 6.28.0
#
# Overview:
# AWS Glue Classifierは、AWS Glueクローラーがデータのスキーマを推測するために
# 使用するカスタム分類子を定義します。CSV、Grok、JSON、XMLの4種類の分類子
# タイプをサポートしており、データソースの形式に応じて適切な分類子を選択できます。
#
# Important Notes:
# - 1つの分類子リソースにつき、1種類の分類子タイプのみ作成可能
#   (csv_classifier、grok_classifier、json_classifier、xml_classifierのいずれか)
# - 分類子タイプを変更すると、リソースが再作成されます
# - クローラーに分類子を関連付けることで、データのスキーマ推測動作をカスタマイズ可能
#
# AWS Documentation:
# https://docs.aws.amazon.com/glue/latest/dg/add-classifier.html
################################################################################

################################################################################
# CSV Classifier Example
################################################################################

resource "aws_glue_classifier" "csv_example" {
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  # Required Arguments
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  # name - (Required) 分類子の名前
  # 要件:
  # - 一意である必要があります
  # - アカウント内で分類子を識別するために使用されます
  # - 英数字とハイフン、アンダースコアが使用可能
  name = "csv-classifier-example"

  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  # CSV Classifier Configuration
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  csv_classifier {
    # allow_single_column - (Optional) 単一列のみを含むファイルの処理を有効化
    # デフォルト: false
    # 用途: 単一列のCSVファイルを処理する場合に設定
    allow_single_column = false

    # contains_header - (Optional) CSVファイルにヘッダーが含まれているかを指定
    # 有効な値:
    # - "ABSENT": ヘッダー行なし
    # - "PRESENT": ヘッダー行あり
    # - "UNKNOWN": ヘッダーの有無が不明（自動検出）
    # デフォルト: "UNKNOWN"
    contains_header = "PRESENT"

    # custom_datatype_configured - (Optional) カスタムデータ型の設定を有効化
    # デフォルト: false
    # 注意: trueに設定した場合、custom_datatypes属性も指定する必要があります
    custom_datatype_configured = false

    # custom_datatypes - (Optional) サポートされるカスタムデータ型のリスト
    # 有効な値: BINARY, BOOLEAN, DATE, DECIMAL, DOUBLE, FLOAT, INT, LONG, SHORT, STRING, TIMESTAMP
    # 要件: custom_datatype_configured = true の場合に使用
    # custom_datatypes = ["STRING", "INT", "TIMESTAMP"]

    # delimiter - (Optional) CSV内で列を区切るために使用される区切り文字
    # デフォルト: ","
    # 一般的な値: ",", "\t", "|", ";"
    delimiter = ","

    # disable_value_trimming - (Optional) 列の値のトリミング（前後の空白除去）を無効化
    # デフォルト: false
    # true: 空白を保持
    # false: 先頭と末尾の空白を削除
    disable_value_trimming = false

    # header - (Optional) 列名を表す文字列のリスト
    # 要件:
    # - contains_header = "ABSENT" の場合、ここで列名を指定
    # - 列の数と一致する必要があります
    # 用途: ヘッダーがないCSVファイルにカスタム列名を付与
    header = ["column1", "column2", "column3"]

    # quote_symbol - (Optional) 内容を単一の列値に結合するために使用されるカスタム記号
    # デフォルト: "\""
    # 要件: 列の区切り文字とは異なる必要があります
    # 用途: 区切り文字を含むフィールドを囲む引用符文字
    quote_symbol = "\""

    # serde - (Optional) CSVを処理するためのSerDe（Serializer/Deserializer）
    # 有効な値:
    # - "OpenCSVSerDe": 標準的なCSV形式（デフォルト）
    # - "LazySimpleSerDe": より柔軟なパース（Hive互換）
    # - "None": SerDeなし
    # serde = "OpenCSVSerDe"
  }

  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  # Optional Arguments
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  # region - (Optional) このリソースが管理されるリージョン
  # デフォルト: プロバイダー設定のリージョン
  # 用途: マルチリージョン構成で明示的にリージョンを指定する場合
  # region = "us-east-1"
}

################################################################################
# Grok Classifier Example
################################################################################

resource "aws_glue_classifier" "grok_example" {
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  # Required Arguments
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  name = "grok-classifier-example"

  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  # Grok Classifier Configuration
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  grok_classifier {
    # classification - (Required) 分類子が一致するデータ形式の識別子
    # 例: "custom-log", "apache-log", "json-log"
    # 用途:
    # - Glueカタログでデータ形式を識別するために使用
    # - クローラーがこの分類子を使用する際の参照名
    classification = "custom-log"

    # grok_pattern - (Required) この分類子が使用するGrokパターン
    # 形式: Grok構文に従ったパターン（Logstashなどで使用される形式）
    # 例: "%{TIMESTAMP_ISO8601:timestamp} %{LOGLEVEL:level} %{GREEDYDATA:message}"
    # 用途: ログファイルや構造化されていないテキストからデータを抽出
    # 注意:
    # - 組み込みパターンまたはカスタムパターンを使用可能
    # - custom_patternsで定義したカスタムパターンを参照できます
    grok_pattern = "%{TIMESTAMP_ISO8601:timestamp} %{LOGLEVEL:level} %{GREEDYDATA:message}"

    # custom_patterns - (Optional) この分類子が使用するカスタムGrokパターン
    # 形式: "PATTERN_NAME regex_pattern" の形式で複数のパターンを改行で区切る
    # 例:
    # custom_patterns = <<EOF
    # CUSTOM_TIMESTAMP %{YEAR}-%{MONTHNUM}-%{MONTHDAY}
    # CUSTOM_LEVEL (INFO|WARN|ERROR)
    # EOF
    # 用途:
    # - 組み込みのGrokパターンでカバーされない独自の形式を定義
    # - grok_pattern内で定義したカスタムパターンを参照可能
    custom_patterns = <<EOF
CUSTOM_TIMESTAMP %{YEAR}-%{MONTHNUM}-%{MONTHDAY}
CUSTOM_LEVEL (INFO|WARN|ERROR|DEBUG)
EOF
  }
}

################################################################################
# JSON Classifier Example
################################################################################

resource "aws_glue_classifier" "json_example" {
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  # Required Arguments
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  name = "json-classifier-example"

  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  # JSON Classifier Configuration
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  json_classifier {
    # json_path - (Required) 分類子が分類するJSONデータを定義するJsonPath文字列
    # AWS Glueは、JsonPathのサブセットをサポートしています
    # 詳細: https://docs.aws.amazon.com/glue/latest/dg/custom-classifier.html#custom-classifier-json
    #
    # 基本構文:
    # - "$" : ルート要素
    # - "." : 子要素へのアクセス
    # - "[]" : 配列要素
    # - "*" : すべての要素
    # - ".." : 再帰的な検索
    #
    # 例:
    # - "$" : JSONドキュメント全体を1つのレコードとして扱う
    # - "$.records[*]" : recordsという配列の各要素を個別のレコードとして扱う
    # - "$[*]" : ルートレベルの配列の各要素を個別のレコードとして扱う
    # - "$.data.items[*]" : ネストされた配列の各要素をレコードとして扱う
    #
    # 用途:
    # - ネストされたJSONからレコードを抽出
    # - 配列形式のJSONデータを個別のレコードに分割
    json_path = "$.records[*]"
  }
}

################################################################################
# XML Classifier Example
################################################################################

resource "aws_glue_classifier" "xml_example" {
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  # Required Arguments
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  name = "xml-classifier-example"

  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  # XML Classifier Configuration
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  xml_classifier {
    # classification - (Required) 分類子が一致するデータ形式の識別子
    # 例: "custom-xml", "rss-feed", "soap-message"
    # 用途: Glueカタログでデータ形式を識別するために使用
    classification = "custom-xml"

    # row_tag - (Required) 解析されるXMLドキュメント内の各レコードを含む要素を指定するXMLタグ
    # 要件:
    # - 自己閉じ要素（"/>"で閉じられる）を識別できません
    # - 属性のみを含む空の行要素は、閉じタグで終わる限り解析可能
    #   例: OK: <row item_a="A" item_b="B"></row>
    #       NG: <row item_a="A" item_b="B" />
    #
    # 例:
    # - "record" : <record>...</record> の各要素が1つのレコード
    # - "item" : <item>...</item> の各要素が1つのレコード
    # - "row" : <row>...</row> の各要素が1つのレコード
    #
    # 用途: XMLドキュメントから個別のレコードを抽出する際の基準要素を指定
    row_tag = "record"
  }
}

################################################################################
# Attributes Reference (Read-Only)
################################################################################

# 以下の属性は、リソース作成後に参照可能です:
#
# - id : 分類子の名前（name属性と同じ値）
#
# 使用例:
# output "classifier_id" {
#   value = aws_glue_classifier.csv_example.id
# }

################################################################################
# Import
################################################################################

# 既存のGlue Classifierは、分類子名を使用してインポート可能です:
#
# terraform import aws_glue_classifier.csv_example my-classifier-name
#
# 注意: インポート時は、適切な分類子タイプのブロック（csv_classifier、
# grok_classifier、json_classifier、xml_classifier）を含む構成が必要です。

################################################################################
# Common Use Cases & Best Practices
################################################################################

# 1. CSV Classifier:
#    - 非標準的な区切り文字を使用するCSVファイル
#    - ヘッダーがないCSVファイルにカスタム列名を付与
#    - 特殊な引用符文字を使用するCSV
#
# 2. Grok Classifier:
#    - カスタムログ形式の解析
#    - 非構造化テキストからの構造化データ抽出
#    - アプリケーション固有のログフォーマット
#
# 3. JSON Classifier:
#    - ネストされたJSON構造からのレコード抽出
#    - JSON配列の各要素を個別のレコードとして処理
#    - 複雑なJSON階層の解析
#
# 4. XML Classifier:
#    - XMLフィード（RSS、Atomなど）の処理
#    - SOAP/XMLメッセージの解析
#    - カスタムXML形式のデータソース
#
# ベストプラクティス:
# - 分類子はクローラーに関連付けて使用します
# - テストデータでパターンを検証してから本番環境に適用
# - 複雑なGrokパターンはシンプルなパターンに分解してテスト
# - JsonPathは最小限の階層で目的のデータを抽出できるように設計
# - 分類子名には用途が分かる命名規則を使用（例: "project-format-type"）

################################################################################
# Related Resources
################################################################################

# aws_glue_crawler         : クローラーに分類子を関連付け
# aws_glue_catalog_database: Glueカタログデータベースの定義
# aws_glue_catalog_table   : Glueカタログテーブルの定義
