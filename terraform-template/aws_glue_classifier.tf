#---------------------------------------------------------------
# AWS Glue Classifier
#---------------------------------------------------------------
#
# AWS Glueクローラーがデータソースをクロールする際に使用するカスタム
# クラシファイアをプロビジョニングするリソースです。
# クラシファイアはファイルのフォーマットを識別し、対応するスキーマを
# 生成するために使用されます。
# CSV、Grok、JSON、XMLの4種類のクラシファイアに対応しています。
# 注意: 1つのリソースに対して作成できるクラシファイアの種類は1つのみです。
#
# AWS公式ドキュメント:
#   - カスタムクラシファイアの作成: https://docs.aws.amazon.com/glue/latest/dg/custom-classifier.html
#   - クラシファイアの定義と管理: https://docs.aws.amazon.com/glue/latest/dg/add-classifier.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_classifier
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_glue_classifier" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: クラシファイアの一意な名前を指定します。
  # 設定可能な値: 文字列
  name = "example-classifier"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # CSVクラシファイア設定
  #-------------------------------------------------------------

  # csv_classifier (Optional)
  # 設定内容: CSVコンテンツ用のクラシファイア設定ブロックです。
  # 注意: csv_classifier、grok_classifier、json_classifier、xml_classifierのいずれか1つのみ指定可能です。
  # 関連機能: CSV カスタムクラシファイア
  #   CSVファイルの列区切り文字やヘッダー設定などを柔軟にカスタマイズできます。
  #   - https://docs.aws.amazon.com/glue/latest/dg/custom-classifier.html#custom-classifier-csv
  csv_classifier {

    # allow_single_column (Optional)
    # 設定内容: 1列のみを含むファイルの処理を有効にするかどうかを指定します。
    # 設定可能な値:
    #   - true: 1列ファイルの処理を許可
    #   - false: 1列ファイルの処理を拒否
    # 省略時: false
    allow_single_column = false

    # contains_header (Optional)
    # 設定内容: CSVファイルにヘッダー行が含まれるかどうかを指定します。
    # 設定可能な値:
    #   - "ABSENT": ヘッダー行なし
    #   - "PRESENT": ヘッダー行あり
    #   - "UNKNOWN": ヘッダー行の有無を自動判定
    # 省略時: null
    contains_header = "PRESENT"

    # custom_datatype_configured (Optional)
    # 設定内容: カスタムデータ型の設定を有効にするかどうかを指定します。
    # 設定可能な値:
    #   - true: カスタムデータ型設定を有効化（custom_datatypes と併用）
    #   - false: カスタムデータ型設定を無効化
    # 省略時: false
    custom_datatype_configured = false

    # custom_datatypes (Optional)
    # 設定内容: サポートするカスタムデータ型のリストを指定します。
    # 設定可能な値: 以下の値の組み合わせ
    #   "BINARY", "BOOLEAN", "DATE", "DECIMAL", "DOUBLE",
    #   "FLOAT", "INT", "LONG", "SHORT", "STRING", "TIMESTAMP"
    # 省略時: null
    # 注意: custom_datatype_configured = true の場合に有効
    custom_datatypes = ["STRING", "INT", "DOUBLE"]

    # delimiter (Optional)
    # 設定内容: CSV内の列を区切る区切り文字を指定します。
    # 設定可能な値: 任意の1文字の文字列（例: ",", "|", "\t", ";"）
    # 省略時: null
    delimiter = ","

    # disable_value_trimming (Optional)
    # 設定内容: 列の値のトリミングを無効にするかどうかを指定します。
    # 設定可能な値:
    #   - true: 値のトリミングを無効化（前後の空白を保持）
    #   - false: 値のトリミングを有効化（前後の空白を除去）
    # 省略時: false
    disable_value_trimming = false

    # header (Optional)
    # 設定内容: 列名を表す文字列のリストを指定します。
    # 設定可能な値: 列名の文字列リスト
    # 省略時: null
    # 注意: contains_header = "PRESENT" の場合はCSVファイルのヘッダー行が使用されるため不要
    header = ["column1", "column2", "column3"]

    # quote_symbol (Optional)
    # 設定内容: 列値を囲む引用符として使用するカスタムシンボルを指定します。
    # 設定可能な値: 任意の1文字の文字列（例: "\"", "'"）
    # 省略時: null
    # 注意: 列区切り文字（delimiter）と異なる文字を指定する必要があります。
    quote_symbol = "\""

    # serde (Optional)
    # 設定内容: CSVの処理に使用するSerDeを指定します。
    # 設定可能な値:
    #   - "OpenCSVSerDe": OpenCSVSerDeを使用（引用符付き文字列をより柔軟に処理）
    #   - "LazySimpleSerDe": LazySimpleSerDeを使用（シンプルな処理）
    #   - "None": SerDeを使用しない
    # 省略時: Terraformが計算した値を使用
    serde = "OpenCSVSerDe"
  }

  #-------------------------------------------------------------
  # Grokクラシファイア設定
  #-------------------------------------------------------------

  # grok_classifier (Optional)
  # 設定内容: Grokパターンを使用するクラシファイアの設定ブロックです。
  # 注意: csv_classifier、grok_classifier、json_classifier、xml_classifierのいずれか1つのみ指定可能です。
  # 関連機能: Grok カスタムクラシファイア
  #   正規表現ベースのGrokパターンを使用してテキストデータを解析し、スキーマを推定します。
  #   - https://docs.aws.amazon.com/glue/latest/dg/custom-classifier.html#custom-classifier-grok
  # grok_classifier {

    # classification (Required)
    # 設定内容: クラシファイアが一致するデータフォーマットの識別子を指定します。
    # 設定可能な値: 任意の文字列（例: "JSON", "CSV", "twitter", "Apache logs"）
    # classification = "custom-log-format"

    # grok_pattern (Required)
    # 設定内容: このクラシファイアが使用するGrokパターンを指定します。
    # 設定可能な値: 有効なGrokパターン文字列（AWS Glue組み込みパターンおよびカスタムパターンを使用可能）
    # 参考: https://docs.aws.amazon.com/glue/latest/dg/custom-classifier.html#custom-classifier-grok-syntax
    # grok_pattern = "%{TIMESTAMP_ISO8601:timestamp} %{LOGLEVEL:level} %{GREEDYDATA:message}"

    # custom_patterns (Optional)
    # 設定内容: このクラシファイアが使用するカスタムGrokパターンを指定します。
    # 設定可能な値: カスタムGrokパターンの定義文字列
    # 省略時: null
    # 注意: grok_patternで使用する前にカスタムパターンをここで定義します。
    # custom_patterns = "CUSTOM_PATTERN [0-9]{4}"
  # }

  #-------------------------------------------------------------
  # JSONクラシファイア設定
  #-------------------------------------------------------------

  # json_classifier (Optional)
  # 設定内容: JSONコンテンツ用のクラシファイア設定ブロックです。
  # 注意: csv_classifier、grok_classifier、json_classifier、xml_classifierのいずれか1つのみ指定可能です。
  # 関連機能: JSON カスタムクラシファイア
  #   JSONPathを使用してJSONドキュメント内の特定オブジェクトのスキーマを定義します。
  #   - https://docs.aws.amazon.com/glue/latest/dg/custom-classifier.html#custom-classifier-json
  # json_classifier {

    # json_path (Required)
    # 設定内容: クラシファイアが分類するJSONデータを定義するJsonPath文字列を指定します。
    # 設定可能な値: 有効なJsonPath文字列（ドット記法、ブラケット記法、ワイルドカード、配列インデックスをサポート）
    # 参考: https://docs.aws.amazon.com/glue/latest/dg/custom-classifier.html#custom-classifier-json
    # json_path = "$[*]"
  # }

  #-------------------------------------------------------------
  # XMLクラシファイア設定
  #-------------------------------------------------------------

  # xml_classifier (Optional)
  # 設定内容: XMLコンテンツ用のクラシファイア設定ブロックです。
  # 注意: csv_classifier、grok_classifier、json_classifier、xml_classifierのいずれか1つのみ指定可能です。
  # 関連機能: XML カスタムクラシファイア
  #   解析するXMLドキュメント内の各レコードを含む要素を指定します。
  #   - https://docs.aws.amazon.com/glue/latest/dg/custom-classifier.html#custom-classifier-xml
  # xml_classifier {

    # classification (Required)
    # 設定内容: クラシファイアが一致するデータフォーマットの識別子を指定します。
    # 設定可能な値: 任意の文字列（例: "xml", "custom-xml"）
    # classification = "custom-xml-format"

    # row_tag (Required)
    # 設定内容: 解析するXMLドキュメント内の各レコードを含む要素を指定するXMLタグを指定します。
    # 設定可能な値: 有効なXMLタグ名（文字列）
    # 注意: 自己終了要素（/>で閉じる）は使用不可。終了タグを持つ閉じた要素のみ指定可能。
    #       例: <row item_a="A"></row> は有効、<row item_a="A" /> は無効
    # row_tag = "row"
  # }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: クラシファイアの名前（name と同一）
#---------------------------------------------------------------
