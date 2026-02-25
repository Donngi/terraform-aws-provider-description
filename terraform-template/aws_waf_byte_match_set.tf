#---------------------------------------------------------------
# AWS WAF Byte Match Set
#---------------------------------------------------------------
#
# AWS WAF Classic のバイトマッチセットをプロビジョニングするリソースです。
# バイトマッチセットは、Webリクエストの特定部分（URI、クエリ文字列、
# ヘッダー、リクエストボディ等）に特定のバイト文字列が含まれているかを
# 検査するための条件を定義します。
#
# 注意: AWS WAF Classic は廃止予定です。新規実装には AWS WAFv2 の
# 使用が推奨されています。
#
# AWS公式ドキュメント:
#   - Working with byte match conditions: https://docs.aws.amazon.com/waf/latest/developerguide/classic-web-acl-byte-conditions.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/waf_byte_match_set
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_waf_byte_match_set" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: バイトマッチセットの名前を指定します。
  # 設定可能な値: 任意の文字列
  # 注意: 作成後に変更するとリソースが再作成されます。
  name = "byte-match-set-example"

  #-------------------------------------------------------------
  # バイトマッチタプル設定
  #-------------------------------------------------------------

  # byte_match_tuples (Optional)
  # 設定内容: 検査対象のWebリクエスト部分と照合するバイト文字列の条件を定義します。
  # 設定可能な値: 複数のbyte_match_tuplesブロックを指定可能
  # 注意:
  #   - 同一セット内に複数のタプルがある場合、いずれかのタプルに一致すれば条件成立（OR条件）
  #   - 異なる条件を同じルールに追加した場合、すべての条件に一致する必要あり（AND条件）

  # 例1: URIに特定の文字列が含まれているかを検査
  byte_match_tuples {
    # positional_constraint (Required)
    # 設定内容: target_stringがfield_to_matchで指定した部分のどこに位置するかを指定します。
    # 設定可能な値:
    #   - "EXACTLY": 完全一致（指定文字列と完全に等しい）
    #   - "STARTS_WITH": 前方一致（指定文字列で始まる）
    #   - "ENDS_WITH": 後方一致（指定文字列で終わる）
    #   - "CONTAINS": 部分一致（指定文字列を含む）
    #   - "CONTAINS_WORD": 単語一致（指定文字列を単語として含む、前後が非英数字またはUnicode文字）
    positional_constraint = "CONTAINS"

    # target_string (Optional)
    # 設定内容: 検索対象のバイト文字列を指定します。
    # 設定可能な値: 任意のバイト文字列（最大50バイト）
    # 省略時: 空文字列として扱われます
    target_string = "/admin"

    # text_transformation (Required)
    # 設定内容: 検査前にリクエストに適用するテキスト変換を指定します。
    # 設定可能な値:
    #   - "NONE": 変換なし。そのままの値を検査
    #   - "CMD_LINE": コマンドライン向けの変換（バックスラッシュ、ダブルクォート等を削除/置換）
    #   - "COMPRESS_WHITE_SPACE": 複数の連続する空白文字を単一のスペースに圧縮
    #   - "HTML_ENTITY_DECODE": HTMLエンコードされた文字（&quot; 等）をデコード
    #   - "LOWERCASE": すべての文字を小文字に変換
    #   - "URL_DECODE": URLエンコードされた文字（%20 等）をデコード
    text_transformation = "LOWERCASE"

    # field_to_match (Required)
    # 設定内容: 検査対象のWebリクエストの部分を指定します。
    field_to_match {
      # type (Required)
      # 設定内容: 検査対象のリクエストの部分の種類を指定します。
      # 設定可能な値:
      #   - "BODY": リクエストボディ（最初の8192バイトのみ検査）
      #   - "HEADER": 指定したリクエストヘッダー（dataでヘッダー名を指定）
      #   - "METHOD": HTTPメソッド（GET, POST, PUT, DELETE 等）
      #   - "QUERY_STRING": URLの"?"以降のクエリ文字列部分
      #   - "URI": URIパス（クエリ文字列やフラグメントを除く）
      type = "URI"

      # data (Optional)
      # 設定内容: typeが"HEADER"の場合、検査対象のヘッダー名を指定します。
      # 設定可能な値: HTTPヘッダー名（例: "User-Agent", "Referer"）
      # 省略時: typeが"HEADER"以外の場合は指定不要
      # data = null
    }
  }

  # 例2: クエリ文字列に特定の文字列が含まれているかを検査（URL_DECODEを適用）
  byte_match_tuples {
    positional_constraint = "CONTAINS"
    target_string         = "script"
    text_transformation   = "URL_DECODE"

    field_to_match {
      type = "QUERY_STRING"
    }
  }

  # 例3: 特定のHTTPヘッダーに文字列が含まれているかを検査
  byte_match_tuples {
    positional_constraint = "CONTAINS"
    target_string         = "badbot"
    text_transformation   = "LOWERCASE"

    field_to_match {
      type = "HEADER"
      data = "User-Agent"
    }
  }

  # 例4: リクエストボディに特定の文字列が完全一致するかを検査
  byte_match_tuples {
    positional_constraint = "EXACTLY"
    target_string         = "malicious-payload"
    text_transformation   = "NONE"

    field_to_match {
      type = "BODY"
    }
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: WAF Byte Match Set のID
#
# - arn: Amazon Resource Name (ARN)
#---------------------------------------------------------------
