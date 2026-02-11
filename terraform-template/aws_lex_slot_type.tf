#---------------------------------------------------------------
# Amazon Lex スロットタイプ
#---------------------------------------------------------------
#
# Amazon Lexのカスタムスロットタイプをプロビジョニングするリソースです。
# スロットタイプは、ボットのインテント内のスロットが取りうる値のセットを定義し、
# 機械学習モデルがユーザー入力を認識するためのトレーニングデータとして使用されます。
#
# 注意: Amazon Lex V1は2025年9月15日にサポート終了予定です。
#       新規プロジェクトではAmazon Lex V2の使用を推奨します。
#
# AWS公式ドキュメント:
#   - PutSlotType API: https://docs.aws.amazon.com/lex/latest/dg/API_PutSlotType.html
#   - EnumerationValue: https://docs.aws.amazon.com/lex/latest/dg/API_EnumerationValue.html
#   - Amazon Lex How It Works: https://docs.aws.amazon.com/lex/latest/dg/how-it-works.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/lex_slot_type
#
# Provider Version: 6.28.0
# Generated: 2026-01-31
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lex_slot_type" "example" {
  #---------------------------------------------------------------
  # 基本設定
  #---------------------------------------------------------------

  # name (Required, Forces new resource)
  # 設定内容: スロットタイプの名前を指定します。
  # 設定可能な値:
  #   - 1〜100文字の文字列
  #   - パターン: ^([A-Za-z]_?)+$
  #   - 大文字小文字を区別しない
  # 注意: ビルトインスロットタイプ名（AMAZON.DATE等）や、"AMAZON."を除いた
  #       ビルトインスロットタイプ名は使用不可
  #       例: AMAZON.DATEが存在するため、DATEという名前は使用不可
  # 参考: https://docs.aws.amazon.com/lex/latest/dg/API_PutSlotType.html
  name = "FlowerTypes"

  # description (Optional)
  # 設定内容: スロットタイプの説明を指定します。
  # 設定可能な値: 0〜200文字の文字列
  # 省略時: 説明なし
  # 参考: https://docs.aws.amazon.com/lex/latest/dg/API_PutSlotType.html
  description = "Types of flowers to order"

  #---------------------------------------------------------------
  # 列挙値設定
  #---------------------------------------------------------------

  # enumeration_value (Required)
  # 設定内容: スロットタイプが取りうる値のリストを定義します。
  # 設定可能な値:
  #   - 最小1個、最大10,000個のEnumerationValueオブジェクト
  #   - 各値には同義語（synonyms）を設定可能
  # 関連機能: Amazon Lex カスタムスロットタイプ
  #   機械学習モデルがユーザー入力を認識するためのトレーニングデータとして使用。
  #   Amazon Lexは解決リスト（最大5つの値）を生成し、Lambda関数に渡します。
  #   - https://docs.aws.amazon.com/lex/latest/dg/API_EnumerationValue.html
  # 注意: 正規表現スロットタイプの場合は不要（その他のスロットタイプでは必須）
  enumeration_value {
    # value (Required)
    # 設定内容: スロットタイプの値を指定します。
    # 設定可能な値: 1〜140文字の文字列
    # 注意: この値がスロット解決時の基準値となります
    # 参考: https://docs.aws.amazon.com/lex/latest/dg/API_EnumerationValue.html
    value = "lilies"

    # synonyms (Optional)
    # 設定内容: スロットタイプ値に関連する同義語のリストを指定します。
    # 設定可能な値: 1〜140文字の文字列の配列
    # 省略時: 同義語なし
    # 関連機能: Amazon Lex シノニム（同義語）
    #   ユーザーが同義語を入力した場合、モデルはスロットタイプ値を返します。
    #   機械学習モデルがユーザー入力を認識する際の学習データとして使用されます。
    #   - https://docs.aws.amazon.com/lex/latest/dg/API_EnumerationValue.html
    # 注意: 頭字語を含む場合は、ピリオドまたはスペースで区切って定義することを推奨
    #       例: D.V.D. または D V D
    synonyms = [
      "Lirium",
      "Martagon",
    ]
  }

  enumeration_value {
    value = "tulips"
    synonyms = [
      "Eduardoregelia",
      "Podonix",
    ]
  }

  #---------------------------------------------------------------
  # バージョン管理設定
  #---------------------------------------------------------------

  # create_version (Optional)
  # 設定内容: リソース作成時および更新時に新しい番号付きバージョンを作成するかを指定します。
  # 設定可能な値:
  #   - true: 新しい番号付きバージョンを作成
  #   - false (デフォルト): $LATEST バージョンのみを更新
  # 省略時: false
  # 関連機能: Amazon Lex バージョニング
  #   CreateSlotTypeVersion操作を実行するのと同等の動作。
  #   $LATESTバージョンを使用するボットのインテントがある場合、
  #   スロットタイプ更新時にボットのstatusがNOT_BUILTに設定されます。
  #   - https://docs.aws.amazon.com/lex/latest/dg/API_PutSlotType.html
  create_version = true

  #---------------------------------------------------------------
  # スロット解決設定
  #---------------------------------------------------------------

  # value_selection_strategy (Optional)
  # 設定内容: Amazon Lexがスロット値を返す際の戦略を指定します。
  # 設定可能な値:
  #   - "ORIGINAL_VALUE" (デフォルト): ユーザーが入力した値を返します
  #     ユーザーの入力値がスロット値に類似している場合に使用
  #     コンソールでは「Expand values」オプションに相当
  #   - "TOP_RESOLUTION": 解決リストの最初の値を返します
  #     解決リストが存在しない場合はnullを返します
  #     コンソールでは「Restrict to slot values and synonyms」オプションに相当
  # 省略時: "ORIGINAL_VALUE"
  # 関連機能: Amazon Lex スロット値解決
  #   Lambda関数を使用している場合、解決リスト（最大5つの値）が関数に渡されます。
  #   Lambda関数を使用していない場合、ユーザー入力値または解決リストの最初の値を
  #   スロット値として返すことができます。
  #   - https://docs.aws.amazon.com/lex/latest/dg/API_PutSlotType.html
  value_selection_strategy = "ORIGINAL_VALUE"

  #---------------------------------------------------------------
  # リージョン設定
  #---------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 注意: Amazon Lex V1は特定のリージョンでのみ利用可能です
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  #---------------------------------------------------------------
  # タイムアウト設定
  #---------------------------------------------------------------

  # timeouts {
  #   # create (Optional)
  #   # 設定内容: リソース作成時のタイムアウト時間を指定します。
  #   # 設定可能な値: 時間文字列（例: "5m", "1h"）
  #   # 省略時: デフォルトのタイムアウト値が適用されます
  #   create = "5m"
  #
  #   # update (Optional)
  #   # 設定内容: リソース更新時のタイムアウト時間を指定します。
  #   # 設定可能な値: 時間文字列（例: "5m", "1h"）
  #   # 省略時: デフォルトのタイムアウト値が適用されます
  #   update = "5m"
  #
  #   # delete (Optional)
  #   # 設定内容: リソース削除時のタイムアウト時間を指定します。
  #   # 設定可能な値: 時間文字列（例: "5m", "1h"）
  #   # 省略時: デフォルトのタイムアウト値が適用されます
  #   delete = "5m"
  # }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - checksum: $LATESTバージョンのスロットタイプを識別するチェックサム。
#             リソース更新時に自動的に追加されるため、引数として指定する必要はありません。
#             新規作成時にchecksumを指定するとBadRequestException例外が発生します。
#
# - created_date: スロットタイプが作成された日時（タイムスタンプ形式）。
#
# - id: スロットタイプの一意な識別子。
#
# - last_updated_date: $LATESTバージョンのスロットタイプが最後に更新された日時（タイムスタンプ形式）。
#                      スロットタイプ作成時は、created_dateとlast_updated_dateは同じ値になります。
#
# - version: スロットタイプのバージョン番号。
#            create_version = true の場合、新しい番号付きバージョンが作成されます。
#
#---------------------------------------------------------------
