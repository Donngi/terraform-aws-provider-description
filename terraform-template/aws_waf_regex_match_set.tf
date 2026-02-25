#---------------------------------------------------------------
# AWS WAF Regex Match Set
#---------------------------------------------------------------
#
# AWS WAF Classic の正規表現マッチセットをプロビジョニングするリソースです。
# 正規表現マッチセットは、Webリクエストの特定部分（URI、クエリ文字列、
# ヘッダー、ボディ等）を正規表現パターンと照合し、リクエストを
# 許可またはブロックするための条件を定義します。
#
# 注意: AWS WAF Classic は廃止予定です。新規実装には AWS WAFv2 の
# 使用が推奨されています。
#
# AWS公式ドキュメント:
#   - Working with regex match conditions: https://docs.aws.amazon.com/waf/latest/developerguide/classic-web-acl-regex-conditions.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/waf_regex_match_set
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_waf_regex_match_set" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: 正規表現マッチセットの名前を指定します。
  # 設定可能な値: 任意の文字列
  # 注意: 作成後に変更するとリソースが再作成されます。
  name = "regex-match-set-example"

  #-------------------------------------------------------------
  # 正規表現マッチタプル設定
  #-------------------------------------------------------------

  # regex_match_tuple (Optional)
  # 設定内容: 正規表現パターンと照合するWebリクエストの部分を指定します。
  # 複数の regex_match_tuple ブロックを定義することで、複数の条件を設定できます。
  # 注意:
  #   - regex_pattern_set_id で参照する aws_waf_regex_pattern_set を事前に作成する必要があります。
  #   - 同一マッチセット内に複数のタプルがある場合、いずれかに一致すれば条件成立（OR条件）

  # 例1: URI を正規表現パターンと照合
  regex_match_tuple {
    # regex_pattern_set_id (Required)
    # 設定内容: 照合に使用する正規表現パターンセットのIDを指定します。
    # 設定可能な値: aws_waf_regex_pattern_set リソースの id 属性
    regex_pattern_set_id = aws_waf_regex_pattern_set.example.id

    # text_transformation (Required)
    # 設定内容: 検査前にリクエストに適用するテキスト変換を指定します。
    # 設定可能な値:
    #   - "NONE": 変換なし。そのままの値を検査
    #   - "CMD_LINE": コマンドライン用の変換。バックスラッシュ、ダブルクォート等の文字を削除/置換
    #   - "COMPRESS_WHITE_SPACE": 複数の連続する空白文字を単一のスペースに圧縮
    #   - "HTML_ENTITY_DECODE": HTMLエンコードされた文字（&quot; など）をデコード
    #   - "LOWERCASE": すべての文字を小文字に変換
    #   - "URL_DECODE": URLエンコードされた文字（%20 など）をデコード
    text_transformation = "NONE"

    # field_to_match (Required)
    # 設定内容: 正規表現パターンと照合するWebリクエストの部分を指定します。
    # 注意: min_items=1, max_items=1 のため、必ず1つのブロックを指定してください。
    field_to_match {
      # type (Required)
      # 設定内容: 検査対象のリクエストの部分の種類を指定します。
      # 設定可能な値:
      #   - "BODY": リクエストボディ（POSTリクエストのデータ部分）
      #   - "HEADER": 特定のHTTPヘッダー（dataでヘッダー名を指定）
      #   - "METHOD": HTTPメソッド（GET、POST等）
      #   - "QUERY_STRING": URLのクエリ文字列部分（?以降）
      #   - "URI": URLのパス部分（クエリ文字列を除く）
      type = "URI"

      # data (Optional)
      # 設定内容: type が "HEADER" の場合、検査するヘッダー名を指定します。
      # 設定可能な値: HTTPヘッダー名（例: "User-Agent", "Referer"）
      # 省略時: type が "HEADER" 以外の場合は指定不要
      # data = null
    }
  }

  # 例2: クエリ文字列を URL_DECODE 変換後に正規表現パターンと照合
  regex_match_tuple {
    regex_pattern_set_id = aws_waf_regex_pattern_set.example.id
    text_transformation  = "URL_DECODE"

    field_to_match {
      type = "QUERY_STRING"
    }
  }

  # 例3: 特定ヘッダーを HTML_ENTITY_DECODE 変換後に正規表現パターンと照合
  regex_match_tuple {
    regex_pattern_set_id = aws_waf_regex_pattern_set.example.id
    text_transformation  = "HTML_ENTITY_DECODE"

    field_to_match {
      type = "HEADER"
      data = "User-Agent"
    }
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: WAF 正規表現マッチセットのID
#
# - arn: 正規表現マッチセットのAmazon Resource Name (ARN)
#---------------------------------------------------------------
