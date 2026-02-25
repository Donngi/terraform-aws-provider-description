#---------------------------------------------------------------
# AWS WAF Regional Byte Match Set
#---------------------------------------------------------------
#
# AWS WAF Regional のバイトマッチセットをプロビジョニングするリソースです。
# バイトマッチセットは、Webリクエストの特定部分（ヘッダー、URI、ボディ等）に対して
# 文字列やバイトシーケンスでマッチングを行う条件を定義します。
# このリソースはAWS WAF Classicのリージョナル版で、Application Load Balancer (ALB)
# および API Gateway と連携して使用します。
#
# 注意: AWS WAF Classic は 2025年9月30日にサポート終了予定です。
#       新規構築には AWS WAFv2 の使用を推奨します。
#
# AWS公式ドキュメント:
#   - AWS WAF Classic: https://docs.aws.amazon.com/waf/latest/developerguide/classic-waf-chapter.html
#   - ByteMatchSet API: https://docs.aws.amazon.com/waf/latest/APIReference/API_waf_ByteMatchSet.html
#   - ByteMatchTuple API: https://docs.aws.amazon.com/waf/latest/APIReference/API_waf_ByteMatchTuple.html
#   - FieldToMatch: https://docs.aws.amazon.com/waf/latest/APIReference/API_waf_FieldToMatch.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafregional_byte_match_set
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_wafregional_byte_match_set" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: バイトマッチセットの名前または説明を指定します。
  # 設定可能な値: 1-128文字の文字列
  # 注意: 作成後に変更することはできません。
  name = "example-byte-match-set"

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
  # バイトマッチタプル設定
  #-------------------------------------------------------------

  # byte_match_tuples (Optional)
  # 設定内容: AWS WAFがWebリクエスト内で検索するバイトシーケンス、
  #           検索対象の場所、照合方法、およびテキスト変換を指定します。
  # 注意: 複数のbyte_match_tuplesブロックを定義可能です。
  byte_match_tuples {

    # positional_constraint (Required)
    # 設定内容: AWS WAFがWebリクエスト内でtarget_stringを検索する際の照合方法を指定します。
    # 設定可能な値:
    #   - "EXACTLY": target_stringと完全に一致する場合にマッチ
    #   - "STARTS_WITH": target_stringで始まる場合にマッチ
    #   - "ENDS_WITH": target_stringで終わる場合にマッチ
    #   - "CONTAINS": target_stringを含む場合にマッチ
    #   - "CONTAINS_WORD": target_stringを単語として含む場合にマッチ（英数字以外で囲まれていること）
    # 参考: https://docs.aws.amazon.com/waf/latest/APIReference/API_waf_ByteMatchTuple.html
    positional_constraint = "CONTAINS"

    # target_string (Optional)
    # 設定内容: AWS WAFがWebリクエスト内で検索する文字列を指定します。
    # 設定可能な値: 最大50バイトのUTF-8文字列
    # 省略時: 空の文字列（空のバイトシーケンス）でマッチング
    target_string = "BadBot"

    # text_transformation (Required)
    # 設定内容: 攻撃者がAWS WAFをバイパスするために使用する異常なフォーマットを
    #           排除するためのテキスト変換を指定します。
    # 設定可能な値:
    #   - "NONE": テキスト変換を行わない
    #   - "COMPRESS_WHITE_SPACE": 複数の空白文字を単一のスペースに圧縮
    #   - "HTML_ENTITY_DECODE": HTMLエンコードされた文字をデコード
    #   - "LOWERCASE": 大文字を小文字に変換
    #   - "CMD_LINE": コマンドライン注入攻撃を検出するための変換
    #   - "URL_DECODE": URLエンコードされた値をデコード
    # 参考: https://docs.aws.amazon.com/waf/latest/APIReference/API_waf_ByteMatchTuple.html
    text_transformation = "NONE"

    # field_to_match (Required)
    # 設定内容: AWS WAFが検索するWebリクエストの部分を指定します。
    # 注意: 1つのbyte_match_tuplesにつき1つのfield_to_matchブロックが必須です。
    field_to_match {

      # type (Required)
      # 設定内容: AWS WAFが検索するWebリクエストの部分を指定します。
      # 設定可能な値:
      #   - "HEADER": リクエストヘッダー。dataでヘッダー名を指定
      #   - "METHOD": HTTPメソッド（GET, POST, PUT, DELETE等）
      #   - "QUERY_STRING": URLの?以降のクエリ文字列
      #   - "URI": URIのパスコンポーネント（クエリ文字列やフラグメントは含まない）
      #   - "BODY": リクエストボディ（最初の8192バイトのみ検査）
      #   - "SINGLE_QUERY_ARG": 指定した単一のクエリパラメータ。dataでパラメータ名を指定
      #   - "ALL_QUERY_ARGS": すべてのクエリパラメータ
      # 参考: https://docs.aws.amazon.com/waf/latest/APIReference/API_waf_FieldToMatch.html
      type = "HEADER"

      # data (Optional)
      # 設定内容: typeがHEADERの場合は検索対象のヘッダー名、
      #           typeがSINGLE_QUERY_ARGの場合は検索対象のパラメータ名を指定します。
      # 設定可能な値: 1-128文字の文字列（大文字小文字を区別しない）
      # 省略時: typeがHEADERまたはSINGLE_QUERY_ARG以外の場合は省略
      # 注意: typeがHEADERまたはSINGLE_QUERY_ARG以外の場合はこのフィールドを省略してください。
      data = "User-Agent"
    }
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: WAF Regional バイトマッチセットのID
#
#---------------------------------------------------------------
