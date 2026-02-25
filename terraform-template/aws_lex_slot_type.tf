#---------------------------------------------------------------
# Amazon Lex Slot Type
#---------------------------------------------------------------
#
# Amazon Lex V1 のスロットタイプをプロビジョニングするリソースです。
# スロットタイプは、インテント内のスロットが受け取ることができる値の
# 種類を定義します。列挙値とその同義語を設定することで、ユーザーが
# 入力できる値を制御します。
# 注意: 本リソースは Amazon Lex V1 のリソースです。
#       Amazon Lex V2 を使用する場合は aws_lexv2models_slot_type を
#       使用してください。
#
# AWS公式ドキュメント:
#   - Amazon Lex スロットタイプ: https://docs.aws.amazon.com/lex/latest/dg/howitworks-builtins-slots.html
#   - カスタムスロットタイプ: https://docs.aws.amazon.com/lex/latest/dg/custom-slot-types.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lex_slot_type
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lex_slot_type" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: スロットタイプの名前を指定します。
  # 設定可能な値: 1〜100文字の英数字、アンダースコア（AMAZON. プレフィックスは使用不可）
  # 省略時: 省略不可
  name = "example-slot-type"

  # description (Optional)
  # 設定内容: スロットタイプの説明を指定します。
  # 設定可能な値: 最大200文字の文字列
  # 省略時: 説明なし
  description = "Amazon Lex スロットタイプのサンプルテンプレートです。"

  # value_selection_strategy (Optional)
  # 設定内容: スロット値の選択戦略を指定します。
  # 設定可能な値:
  #   - "ORIGINAL_VALUE": ユーザーが入力した値をそのまま使用する
  #   - "TOP_RESOLUTION": 解決された最上位の値を使用する
  # 省略時: "ORIGINAL_VALUE"
  value_selection_strategy = "ORIGINAL_VALUE"

  # create_version (Optional)
  # 設定内容: 更新時に新しいスロットタイプバージョンを自動的に作成するかを指定します。
  # 設定可能な値:
  #   - true: 変更のたびに新しいバージョンを作成
  #   - false: バージョンを作成しない
  # 省略時: false
  create_version = false

  #-------------------------------------------------------------
  # 列挙値設定
  #-------------------------------------------------------------

  # enumeration_value (Required, 1〜10000件)
  # 設定内容: スロットタイプに対して有効な値（列挙値）を定義するブロックです。
  # 省略時: 省略不可（最低1件必要）
  enumeration_value {

    # value (Required)
    # 設定内容: スロットに一致させる値を指定します。
    # 設定可能な値: 1〜140文字の文字列
    # 省略時: 省略不可
    value = "apple"

    # synonyms (Optional)
    # 設定内容: 値の同義語を指定します。Lex はこれらの単語を value として解決します。
    # 設定可能な値: 1〜140文字の文字列のセット（最大10000件）
    # 省略時: 同義語なし
    synonyms = ["apples", "red apple", "green apple"]
  }

  enumeration_value {
    value    = "orange"
    synonyms = ["oranges", "tangerine"]
  }

  enumeration_value {
    value    = "banana"
    synonyms = ["bananas"]
  }

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を設定するブロックです。
  timeouts {

    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: Goの time.Duration 形式の文字列（例: "5m", "1h"）
    # 省略時: デフォルトタイムアウト
    create = "1m"

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウト時間を指定します。
    # 設定可能な値: Goの time.Duration 形式の文字列（例: "5m", "1h"）
    # 省略時: デフォルトタイムアウト
    update = "1m"

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: Goの time.Duration 形式の文字列（例: "5m", "1h"）
    # 省略時: デフォルトタイムアウト
    delete = "5m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - checksum: スロットタイプのチェックサム（更新時の競合検出に使用）
# - created_date: スロットタイプが作成された日時（ISO 8601形式）
# - id: スロットタイプの名前（name 属性と同一）
# - last_updated_date: スロットタイプが最後に更新された日時（ISO 8601形式）
# - version: スロットタイプのバージョン（$LATEST または数値バージョン）
#---------------------------------------------------------------
