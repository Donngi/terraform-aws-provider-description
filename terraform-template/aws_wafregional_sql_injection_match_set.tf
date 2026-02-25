#---------------------------------------------------------------
# aws_wafregional_sql_injection_match_set
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafregional_sql_injection_match_set
#
# NOTE: このファイルは参照用テンプレートです。
#       実際の利用時は不要な属性を削除し、値を適切に設定してください。
#---------------------------------------------------------------

resource "aws_wafregional_sql_injection_match_set" "example" {

  #---------------------------------------------------------------
  # 基本設定
  #---------------------------------------------------------------

  # 設定内容: SQLインジェクション一致セットの名前
  # 設定可能な値: 任意の文字列
  name = "sql-injection-match-set"

  # 設定内容: リソースを管理するAWSリージョン
  # 設定可能な値: "us-east-1", "ap-northeast-1" 等のリージョンコード
  # 省略時: プロバイダー設定のリージョンが使用される
  region = "ap-northeast-1"

  #---------------------------------------------------------------
  # SQLインジェクション一致タプル
  #---------------------------------------------------------------

  # 設定内容: SQLインジェクション攻撃を検査する対象フィールドと変換の組み合わせ
  # 複数指定可能（セット型）
  sql_injection_match_tuple {

    # 設定内容: テキスト変換の種類
    # 設定可能な値:
    #   "NONE"               - 変換なし
    #   "COMPRESS_WHITE_SPACE" - 連続する空白を1つのスペースに圧縮
    #   "HTML_ENTITY_DECODE" - HTMLエンティティをデコード
    #   "LOWERCASE"          - 大文字を小文字に変換
    #   "CMD_LINE"           - コマンドライン特殊文字を正規化
    #   "URL_DECODE"         - URLエンコードをデコード
    text_transformation = "URL_DECODE"

    # 設定内容: SQLインジェクション検査を行うリクエストのフィールド（必須、1つのみ）
    field_to_match {

      # 設定内容: 検査するフィールドの種類
      # 設定可能な値:
      #   "URI"              - リクエストURIパス
      #   "QUERY_STRING"     - クエリ文字列
      #   "HEADER"           - HTTPヘッダー（dataにヘッダー名を指定）
      #   "METHOD"           - HTTPメソッド
      #   "BODY"             - リクエストボディ
      #   "SINGLE_QUERY_ARG" - 単一クエリパラメータ（dataにパラメータ名を指定）
      #   "ALL_QUERY_ARGS"   - 全クエリパラメータ
      type = "QUERY_STRING"

      # 設定内容: typeが "HEADER" または "SINGLE_QUERY_ARG" の場合に対象の名前を指定
      # 設定可能な値: ヘッダー名（例: "User-Agent"）またはクエリパラメータ名
      # 省略時: type が HEADER/SINGLE_QUERY_ARG 以外では不要
      # data = "User-Agent"
      data = null
    }
  }

}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# id - SQLインジェクション一致セットのID
#---------------------------------------------------------------
