#---------------------------------------------------------------
# Amazon Lex V2 スロットタイプ
#---------------------------------------------------------------
#
# Amazon Lex V2 のスロットタイプをプロビジョニングするリソースです。
# スロットタイプはスロットが受け付けられる値の集合を定義するもので、
# カスタム値リスト、外部文法ソース、コンポジットスロットタイプの
# 3 種類の定義方法をサポートします。
# スロットタイプはボット・ロケール・インテント・スロットと組み合わせて
# 会話型 AI の入力データ型を表現します。
#
# AWS公式ドキュメント:
#   - Amazon Lex V2 スロットタイプ: https://docs.aws.amazon.com/lexv2/latest/dg/building-slots.html
#   - スロットタイプの管理: https://docs.aws.amazon.com/lexv2/latest/dg/API_CreateSlotType.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lexv2models_slot_type
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lexv2models_slot_type" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # bot_id (Required)
  # 設定内容: スロットタイプを作成するボットの ID を指定します。
  # 設定可能な値: 既存の aws_lexv2models_bot リソースの bot_id 属性
  # 省略時: 省略不可
  bot_id = aws_lexv2models_bot.example.id

  # bot_version (Required)
  # 設定内容: スロットタイプを作成するボットのバージョンを指定します。
  # 設定可能な値:
  #   - "DRAFT": ドラフト版（開発中のバージョン）
  #   - 特定のバージョン番号（例: "1", "2"）
  # 省略時: 省略不可
  bot_version = "DRAFT"

  # locale_id (Required)
  # 設定内容: スロットタイプを作成するロケール ID を指定します。
  # 設定可能な値:
  #   - "en_US": 英語（米国）
  #   - "ja_JP": 日本語（日本）
  #   - "de_DE": ドイツ語（ドイツ）
  #   - "es_ES": スペイン語（スペイン）
  #   - "fr_FR": フランス語（フランス）
  #   - その他 Lex V2 がサポートするロケール ID
  # 省略時: 省略不可
  locale_id = "ja_JP"

  # name (Required)
  # 設定内容: スロットタイプの名前を指定します。
  # 設定可能な値: 英数字およびアンダースコアからなる一意の名前
  # 省略時: 省略不可
  name = "example_slot_type"

  # description (Optional)
  # 設定内容: スロットタイプの説明を指定します。
  # 設定可能な値: 最大200文字の文字列
  # 省略時: 説明なし
  description = "サンプルスロットタイプです。"

  # parent_slot_type_signature (Optional)
  # 設定内容: このスロットタイプの基底となる組み込みスロットタイプのシグネチャを指定します。
  # 設定可能な値:
  #   - "AMAZON.AlphaNumeric": 英数字
  #   - "AMAZON.City": 都市名
  #   - "AMAZON.Country": 国名
  #   - "AMAZON.Date": 日付
  #   - "AMAZON.Number": 数値
  #   - "AMAZON.Ordinal": 序数
  #   - "AMAZON.PhoneNumber": 電話番号
  #   - "AMAZON.Time": 時刻
  #   - null: 基底スロットタイプなし
  # 省略時: 基底スロットタイプなし
  parent_slot_type_signature = null

  #-------------------------------------------------------------
  # 値の選択設定
  #-------------------------------------------------------------

  # value_selection_setting (Optional)
  # 設定内容: スロットタイプの値をどのように解決するかを設定するブロックです。
  # 省略時: 値の選択設定なし
  value_selection_setting {

    # resolution_strategy (Required)
    # 設定内容: スロットの値をどのような戦略で解決するかを指定します。
    # 設定可能な値:
    #   - "ORIGINAL_VALUE": ユーザーが入力した元の値をそのまま使用
    #   - "TOP_RESOLUTION": 認識された値の中から最も確率が高いものを使用
    # 省略時: 省略不可
    resolution_strategy = "ORIGINAL_VALUE"

    # advanced_recognition_setting (Optional)
    # 設定内容: 音声認識の詳細設定を行うブロックです。
    advanced_recognition_setting {

      # audio_recognition_strategy (Optional)
      # 設定内容: 音声入力時の認識戦略を指定します。
      # 設定可能な値:
      #   - "UseSlotValuesAsCustomVocabulary": スロット値をカスタム語彙として使用して音声認識精度を向上させる
      # 省略時: 音声認識戦略なし（デフォルト動作）
      audio_recognition_strategy = "UseSlotValuesAsCustomVocabulary"
    }

    # regex_filter (Optional)
    # 設定内容: スロット値を正規表現でフィルタリングするブロックです。
    regex_filter {

      # pattern (Required)
      # 設定内容: スロット値をフィルタリングする正規表現パターンを指定します。
      # 設定可能な値: 有効な正規表現文字列
      # 省略時: 省略不可
      pattern = "[a-zA-Z0-9]+"
    }
  }

  #-------------------------------------------------------------
  # スロットタイプ値設定
  #-------------------------------------------------------------

  # slot_type_values (Optional)
  # 設定内容: スロットタイプが受け入れる値のリストを設定するブロックです。
  #           複数指定可能で、それぞれに代表値とシノニム（同義語）を設定できます。
  # 省略時: 値リストなし
  slot_type_values {

    # sample_value (Optional)
    # 設定内容: スロットタイプの代表的なサンプル値を設定するブロックです。
    sample_value {

      # value (Required)
      # 設定内容: スロットタイプの代表値を指定します。
      # 設定可能な値: 任意の文字列
      # 省略時: 省略不可
      value = "東京"
    }

    # synonyms (Optional)
    # 設定内容: サンプル値の同義語を設定するブロックです。複数指定可能です。
    synonyms {

      # value (Required)
      # 設定内容: 同義語の値を指定します。
      # 設定可能な値: 任意の文字列
      # 省略時: 省略不可
      value = "Tokyo"
    }

    synonyms {
      value = "とうきょう"
    }
  }

  slot_type_values {
    sample_value {
      value = "大阪"
    }

    synonyms {
      value = "Osaka"
    }
  }

  #-------------------------------------------------------------
  # 外部ソース設定
  #-------------------------------------------------------------

  # external_source_setting (Optional)
  # 設定内容: 外部ソース（S3 上の文法ファイルなど）からスロットタイプを定義するブロックです。
  #           slot_type_values と排他的に使用します。
  # 省略時: 外部ソースなし
  # external_source_setting {
  #
  #   # grammar_slot_type_setting (Optional)
  #   # 設定内容: GRXML 形式の文法ファイルを使用するスロットタイプ設定ブロックです。
  #   grammar_slot_type_setting {
  #
  #     # source (Optional)
  #     # 設定内容: 文法ファイルが格納されている S3 ソースを設定するブロックです。
  #     source {
  #
  #       # kms_key_arn (Required)
  #       # 設定内容: S3 オブジェクトの暗号化に使用する KMS キーの ARN を指定します。
  #       # 設定可能な値: 有効な KMS キーの ARN
  #       # 省略時: 省略不可
  #       kms_key_arn = aws_kms_key.example.arn
  #
  #       # s3_bucket_name (Required)
  #       # 設定内容: 文法ファイルが格納されている S3 バケットの名前を指定します。
  #       # 設定可能な値: 既存の S3 バケット名
  #       # 省略時: 省略不可
  #       s3_bucket_name = aws_s3_bucket.example.id
  #
  #       # s3_object_key (Required)
  #       # 設定内容: 文法ファイルの S3 オブジェクトキーを指定します。
  #       # 設定可能な値: S3 バケット内の有効なオブジェクトキー（例: "grammars/example.grxml"）
  #       # 省略時: 省略不可
  #       s3_object_key = "grammars/example.grxml"
  #     }
  #   }
  # }

  #-------------------------------------------------------------
  # コンポジットスロットタイプ設定
  #-------------------------------------------------------------

  # composite_slot_type_setting (Optional)
  # 設定内容: 複数のスロットタイプを組み合わせたコンポジットスロットタイプを定義するブロックです。
  # 省略時: コンポジット設定なし
  # composite_slot_type_setting {
  #
  #   # sub_slots (Optional)
  #   # 設定内容: コンポジットスロットタイプを構成するサブスロットのリストを設定するブロックです。
  #   sub_slots {
  #
  #     # name (Required)
  #     # 設定内容: サブスロットの名前を指定します。
  #     # 設定可能な値: 任意の文字列
  #     # 省略時: 省略不可
  #     name = "sub_slot_example"
  #
  #     # slot_type_id (Required)
  #     # 設定内容: サブスロットに使用するスロットタイプの ID を指定します。
  #     # 設定可能な値: 既存のスロットタイプ ID または組み込みスロットタイプのシグネチャ
  #     # 省略時: 省略不可
  #     slot_type_id = aws_lexv2models_slot_type.sub_example.slot_type_id
  #   }
  # }

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
    create = "5m"

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウト時間を指定します。
    # 設定可能な値: Goの time.Duration 形式の文字列（例: "5m", "1h"）
    # 省略時: デフォルトタイムアウト
    update = "5m"

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
# - id: スロットタイプの ID（slot_type_id と同一）
# - slot_type_id: スロットタイプの一意識別子
# - region: リソースが管理されているリージョン
#---------------------------------------------------------------
