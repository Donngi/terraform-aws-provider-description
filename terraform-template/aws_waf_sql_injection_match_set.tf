#---------------------------------------------------------------
# AWS WAF SQL Injection Match Set
#---------------------------------------------------------------
#
# AWS WAF Classic のSQLインジェクションマッチセットをプロビジョニングするリソースです。
# SQLインジェクションマッチセットは、WebリクエストのURIやクエリ文字列、
# ヘッダー、ボディなどに含まれる悪意のあるSQLコードを検出するための
# 検査対象部分を定義します。
#
# 注意: AWS WAF Classic は廃止予定です。新規実装には AWS WAFv2 の
# 使用が推奨されています。
#
# AWS公式ドキュメント:
#   - Working with SQL injection match conditions: https://docs.aws.amazon.com/waf/latest/developerguide/classic-web-acl-sql-conditions.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/waf_sql_injection_match_set
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_waf_sql_injection_match_set" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: SQLインジェクションマッチセットの名前または説明を指定します。
  # 設定可能な値: 任意の文字列
  # 注意: 作成後に変更するとリソースが再作成されます。
  name = "sql-injection-match-set-example"

  #-------------------------------------------------------------
  # SQLインジェクションマッチタプル設定
  #-------------------------------------------------------------

  # sql_injection_match_tuples (Optional)
  # 設定内容: 悪意のあるSQLコードを検査するWebリクエストの部分を定義します。
  # 複数のsql_injection_match_tuplesブロックを定義することで、複数の検査対象を設定できます。
  # 注意:
  #   - 同一セット内に複数のタプルがある場合、いずれかに一致すれば条件成立（OR条件）
  #   - 異なる条件を同じルールに追加した場合、すべての条件に一致する必要あり（AND条件）

  # 例1: クエリ文字列を検査（URLデコードを適用）
  sql_injection_match_tuples {
    # text_transformation (Required)
    # 設定内容: 検査前にリクエストに適用するテキスト変換を指定します。
    # 設定可能な値:
    #   - "NONE": 変換なし。そのままの値を検査
    #   - "CMD_LINE": コマンドライン用の変換。攻撃者がOSコマンドを難読化するために使用する
    #                 バックスラッシュ、ダブルクォート等の文字を削除/置換
    #   - "COMPRESS_WHITE_SPACE": 複数の連続する空白文字を単一のスペースに圧縮
    #   - "HTML_ENTITY_DECODE": HTMLエンコードされた文字（&quot; など）をデコード
    #   - "LOWERCASE": すべての文字を小文字に変換
    #   - "URL_DECODE": URLエンコードされた文字（%20 など）をデコード
    text_transformation = "URL_DECODE"

    # field_to_match (Required)
    # 設定内容: 検査対象のWebリクエストの部分を指定します。
    field_to_match {
      # type (Required)
      # 設定内容: 検査対象のリクエストの部分の種類を指定します。
      # 設定可能な値:
      #   - "BODY": リクエストボディ（POSTリクエストのデータ部分）
      #   - "HEADER": 特定のHTTPヘッダー（dataで名前を指定）
      #   - "METHOD": HTTPメソッド（GET、POST等）
      #   - "QUERY_STRING": URLのクエリ文字列部分（?以降）
      #   - "URI": URLのパス部分（クエリ文字列を除く）
      type = "QUERY_STRING"

      # data (Optional)
      # 設定内容: typeが"HEADER"の場合、検査するHTTPヘッダー名を指定します。
      # 設定可能な値: HTTPヘッダー名（例: "User-Agent", "Referer", "Authorization"）
      # 省略時: typeが"HEADER"以外の場合は指定不要
      # data = null
    }
  }

  # 例2: リクエストボディを検査（HTMLエンティティデコードを適用）
  sql_injection_match_tuples {
    text_transformation = "HTML_ENTITY_DECODE"

    field_to_match {
      type = "BODY"
    }
  }

  # 例3: URIを検査（変換なし）
  sql_injection_match_tuples {
    text_transformation = "NONE"

    field_to_match {
      type = "URI"
    }
  }

  # 例4: 特定のHTTPヘッダーを検査
  sql_injection_match_tuples {
    text_transformation = "URL_DECODE"

    field_to_match {
      type = "HEADER"
      data = "Authorization"
    }
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: WAF SQLインジェクションマッチセットのID
#
# - arn: SQLインジェクションマッチセットのAmazon Resource Name (ARN)
#---------------------------------------------------------------
