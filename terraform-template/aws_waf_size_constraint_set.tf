#---------------------------------------------------------------
# AWS WAF Size Constraint Set
#---------------------------------------------------------------
#
# AWS WAF Classic のサイズ制約セットをプロビジョニングするリソースです。
# サイズ制約セットは、Webリクエストの特定部分（クエリ文字列、ヘッダー、
# リクエストボディなど）の長さに基づいてリクエストを許可またはブロック
# するための条件を定義します。
#
# 注意: AWS WAF Classic は廃止予定です。新規実装には AWS WAFv2 の
# 使用が推奨されています。
#
# AWS公式ドキュメント:
#   - Working with size constraint conditions: https://docs.aws.amazon.com/waf/latest/developerguide/classic-web-acl-size-conditions.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/waf_size_constraint_set
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_waf_size_constraint_set" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: サイズ制約セットの名前または説明を指定します。
  # 設定可能な値: 英数字(A-Z, a-z, 0-9)または特殊文字(_-!"#`+*},./.)を含む文字列
  # 注意: 作成後に名前を変更することはできません。
  name = "my-size-constraint-set"

  #-------------------------------------------------------------
  # サイズ制約設定
  #-------------------------------------------------------------

  # size_constraints (Optional)
  # 設定内容: 検査対象のWebリクエスト部分とサイズ条件を定義します。
  # 設定可能な値: 複数のsize_constraintsブロックを指定可能
  # 注意:
  #   - 同一条件内に複数のフィルタがある場合、いずれかのフィルタに一致すれば条件成立（OR条件）
  #   - 異なる条件を同じルールに追加した場合、すべての条件に一致する必要あり（AND条件）
  size_constraints {
    # comparison_operator (Required)
    # 設定内容: サイズ比較に使用する演算子を指定します。
    # 設定可能な値:
    #   - "EQ": 等しい（Equal）
    #   - "NE": 等しくない（Not Equal）
    #   - "LT": より小さい（Less Than）
    #   - "LE": 以下（Less than or Equal）
    #   - "GT": より大きい（Greater Than）
    #   - "GE": 以上（Greater than or Equal）
    comparison_operator = "GT"

    # size (Required)
    # 設定内容: 比較対象のサイズをバイト単位で指定します。
    # 設定可能な値: 0以上の整数（バイト数）
    # 注意:
    #   - URIの場合、"/"は1文字としてカウントされます（例: /logo.jpg は9文字）
    #   - リクエストボディの検査は最初の8192バイト（8KB）のみが対象です
    size = 4096

    # text_transformation (Required)
    # 設定内容: サイズ評価前にリクエストに適用するテキスト変換を指定します。
    # 設定可能な値:
    #   - "NONE": 変換なし
    #   - "COMPRESS_WHITE_SPACE": 空白文字を正規化（複数の空白を単一スペースに）
    #   - "HTML_ENTITY_DECODE": HTMLエンコードされた文字をデコード
    #   - "LOWERCASE": 大文字を小文字に変換
    #   - "CMD_LINE": コマンドライン向けの変換（特殊文字削除、大文字小文字正規化など）
    #   - "URL_DECODE": URLエンコードされた文字をデコード
    # 注意: Bodyを検査対象とする場合、変換は適用できません（"NONE"のみ使用可能）
    text_transformation = "NONE"

    # field_to_match (Required)
    # 設定内容: サイズを検査するWebリクエストの部分を指定します。
    field_to_match {
      # type (Required)
      # 設定内容: 検査対象のリクエスト部分の種類を指定します。
      # 設定可能な値:
      #   - "BODY": リクエストボディ（最初の8192バイトのみ検査）
      #   - "HEADER": 指定したリクエストヘッダー（dataでヘッダー名を指定）
      #   - "METHOD": HTTPメソッド（GET, POST, PUT, DELETE等）
      #   - "QUERY_STRING": URLの"?"以降のクエリ文字列部分
      #   - "URI": URIパス（クエリ文字列やフラグメントを除く）
      #   - "SINGLE_QUERY_ARG": 特定のクエリパラメータの値（dataでパラメータ名を指定）
      #   - "ALL_QUERY_ARGS": すべてのクエリパラメータの値
      type = "BODY"

      # data (Optional)
      # 設定内容: typeが"HEADER"または"SINGLE_QUERY_ARG"の場合に、
      #          対象のヘッダー名またはクエリパラメータ名を指定します。
      # 設定可能な値:
      #   - typeが"HEADER"の場合: ヘッダー名（例: "User-Agent", "Referer"）
      #   - typeが"SINGLE_QUERY_ARG"の場合: クエリパラメータ名（最大30文字、大文字小文字区別なし）
      # 省略時: typeが"HEADER"または"SINGLE_QUERY_ARG"以外の場合は不要
      data = null
    }
  }

  # 追加のサイズ制約例（クエリ文字列のサイズ制限）
  # size_constraints {
  #   comparison_operator = "GT"
  #   size                = 100
  #   text_transformation = "URL_DECODE"
  #
  #   field_to_match {
  #     type = "QUERY_STRING"
  #   }
  # }

  # 追加のサイズ制約例（特定ヘッダーのサイズ制限）
  # size_constraints {
  #   comparison_operator = "GT"
  #   size                = 2048
  #   text_transformation = "NONE"
  #
  #   field_to_match {
  #     type = "HEADER"
  #     data = "User-Agent"
  #   }
  # }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: WAF Size Constraint Set のID
#
# - arn: Amazon Resource Name (ARN)
#---------------------------------------------------------------
