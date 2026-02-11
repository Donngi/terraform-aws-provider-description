#---------------------------------------------------------------
# AWS WAF Regional XSS Match Set
#---------------------------------------------------------------
#
# AWS WAF Regional（Classic）のXSSマッチセットをプロビジョニングするリソースです。
# Application Load Balancer（ALB）と連携して、Webリクエストの特定部分に
# クロスサイトスクリプティング（XSS）攻撃が含まれているかを検出するための
# 条件セットを定義します。
#
# 注意: AWS WAF Classicは2025年9月30日にサポート終了予定です。
#       新規構築ではAWS WAFv2（aws_wafv2_*リソース）の使用を推奨します。
#
# AWS公式ドキュメント:
#   - XssMatchSet API Reference: https://docs.aws.amazon.com/waf/latest/APIReference/API_wafRegional_XssMatchSet.html
#   - FieldToMatch Reference: https://docs.aws.amazon.com/waf/latest/APIReference/API_waf_FieldToMatch.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafregional_xss_match_set
#
# Provider Version: 6.28.0
# Generated: 2026-02-06
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_wafregional_xss_match_set" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: XSSマッチセットの名前を指定します。
  # 設定可能な値: 最大128文字の文字列
  # 用途: AWS WAFコンソールやAPIでこのマッチセットを識別するために使用します。
  name = "example-xss-match-set"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "ap-northeast-1"

  #-------------------------------------------------------------
  # XSSマッチタプル設定
  #-------------------------------------------------------------
  # xss_match_tuple (Optional)
  # 設定内容: クロスサイトスクリプティング攻撃を検査するWebリクエストの部分を指定します。
  # 複数のxss_match_tupleブロックを定義可能。いずれか1つでもマッチすれば条件に一致します。

  # 例1: URIパスのXSS検査
  xss_match_tuple {
    # text_transformation (Required)
    # 設定内容: XSS攻撃を検査する前にリクエストに適用するテキスト変換を指定します。
    # 設定可能な値:
    #   - "NONE": 変換なし。リクエストをそのまま検査
    #   - "CMD_LINE": OSコマンドライン関連の変換を実行
    #   - "COMPRESS_WHITE_SPACE": 特定の文字をスペースに置換
    #   - "HTML_ENTITY_DECODE": HTMLエンコードされた文字をデコード
    #   - "LOWERCASE": 大文字を小文字に変換
    #   - "URL_DECODE": URLエンコードされた値をデコード
    # 注意: 攻撃者はエンコーディングを使用してWAFを回避しようとするため、
    #       適切な変換を選択することが重要です。
    text_transformation = "NONE"

    # field_to_match (Required)
    # 設定内容: XSS攻撃を検査するWebリクエストの部分を指定します。
    field_to_match {
      # type (Required)
      # 設定内容: 検査対象のリクエスト部分の種類を指定します。
      # 設定可能な値:
      #   - "HEADER": 指定したリクエストヘッダー（User-Agent、Referer等）
      #   - "METHOD": HTTPメソッド（GET、POST、DELETE等）
      #   - "QUERY_STRING": URLの?以降のクエリ文字列
      #   - "URI": URIパス（ドメインとクエリ文字列を除いた部分）
      #   - "BODY": リクエストボディ（POSTデータ等）
      #   - "SINGLE_QUERY_ARG": 特定のクエリパラメータ
      #   - "ALL_QUERY_ARGS": すべてのクエリパラメータ
      type = "URI"

      # data (Optional)
      # 設定内容: typeが"HEADER"または"SINGLE_QUERY_ARG"の場合に、
      #           検査対象のヘッダー名またはパラメータ名を指定します。
      # 設定可能な値: ヘッダー名またはクエリパラメータ名の文字列
      # 注意: typeがHEADER以外の場合は省略してください。
      # data = null
    }
  }

  # 例2: クエリ文字列のXSS検査
  xss_match_tuple {
    text_transformation = "URL_DECODE"

    field_to_match {
      type = "QUERY_STRING"
    }
  }

  # 例3: リクエストボディのXSS検査（HTMLエンティティデコード適用）
  xss_match_tuple {
    text_transformation = "HTML_ENTITY_DECODE"

    field_to_match {
      type = "BODY"
    }
  }

  # 例4: 特定ヘッダー（User-Agent）のXSS検査
  xss_match_tuple {
    text_transformation = "NONE"

    field_to_match {
      type = "HEADER"
      data = "user-agent"
    }
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: Regional WAF XSSマッチセットのID
#---------------------------------------------------------------
