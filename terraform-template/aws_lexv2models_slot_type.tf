#---------------------------------------------------------------
# Amazon Lex V2 Models Slot Type
#---------------------------------------------------------------
#
# AWS Lex V2 のカスタムスロットタイプを定義するリソース。
# スロットタイプは、ユーザーのリクエストを満たすために必要な情報の種類を
# 定義し、各値に対する同義語やバリデーションルールを設定できます。
#
# AWS公式ドキュメント:
#   - Custom slot types: https://docs.aws.amazon.com/lexv2/latest/dg/custom-slot-types.html
#   - Adding slot types: https://docs.aws.amazon.com/lexv2/latest/dg/add-slot-types.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lexv2models_slot_type
#
# Provider Version: 6.28.0
# Generated: 2026-01-28
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lexv2models_slot_type" "example" {
  #---------------------------------------------------------------
  # Required Arguments
  #---------------------------------------------------------------

  # bot_id - Lex V2 ボットの識別子
  # このスロットタイプが関連付けられるボットのID。
  # aws_lexv2models_bot リソースから取得できます。
  bot_id = "EXAMPLE_BOT_ID"

  # bot_version - ボットのバージョン
  # このスロットタイプが関連付けられるボットのバージョン。
  # 通常は "DRAFT" または特定のバージョン番号を指定します。
  bot_version = "DRAFT"

  # locale_id - ロケール識別子
  # このスロットタイプが使用される言語とロケール。
  # ボット、スロットタイプ、スロットはすべて同じロケールである必要があります。
  # 例: "en_US", "ja_JP", "es_ES" など
  locale_id = "en_US"

  # name - スロットタイプ名
  # スロットタイプの一意な名前。
  # ビルトインスロットタイプ（Date, Number, Confirmation等）と
  # 同じ名前は使用できません。
  name = "example_slot_type"

  #---------------------------------------------------------------
  # Optional Arguments
  #---------------------------------------------------------------

  # description - スロットタイプの説明
  # スロットタイプの目的や用途を説明するテキスト。
  description = "Example slot type description"

  # parent_slot_type_signature - 親スロットタイプ
  # このスロットタイプの親として使用されるビルトインスロットタイプ。
  # 親スロットタイプを定義すると、そのタイプの設定を継承します。
  # 現在サポートされているのは "AMAZON.AlphaNumeric" のみです。
  # parent_slot_type_signature = "AMAZON.AlphaNumeric"

  # region - リージョン
  # このリソースが管理されるAWSリージョン。
  # 指定しない場合、プロバイダー設定のリージョンが使用されます。
  # region = "us-east-1"

  #---------------------------------------------------------------
  # Optional Blocks - Composite Slot Type Setting
  #---------------------------------------------------------------
  # composite_slot_type_setting - 複合スロットタイプの設定
  # 複数のサブスロットを持つ複合スロットタイプの仕様を定義します。
  # 複雑なエンティティ（例: 住所 = 郵便番号 + 都市 + 番地）を
  # 構造化して定義できます。

  # composite_slot_type_setting {
  #   # sub_slots - サブスロット
  #   # 複合スロット内の構成要素となるサブスロットのリスト。
  #   # 最大10,000個の値と同義語を定義可能（ボット全体で50,000まで）。
  #
  #   sub_slots {
  #     # name - サブスロット名（必須）
  #     # 複合スロット内のサブスロットの名前。
  #     name = "sub_slot_1"
  #
  #     # slot_type_id - スロットタイプID（必須）
  #     # ビルトインスロットタイプまたはカスタムスロットタイプの一意なID。
  #     # aws_lexv2models_slot_type.other.slot_type_id のように参照できます。
  #     slot_type_id = "AMAZON.Number"
  #   }
  #
  #   sub_slots {
  #     name         = "sub_slot_2"
  #     slot_type_id = "AMAZON.City"
  #   }
  # }

  #---------------------------------------------------------------
  # Optional Blocks - External Source Setting
  #---------------------------------------------------------------
  # external_source_setting - 外部ソース設定
  # スロットタイプの作成に使用される外部情報のタイプを定義します。
  # Grammarスロットタイプを使用する場合に設定します。

  # external_source_setting {
  #   # grammar_slot_type_setting - Grammarスロットタイプ設定
  #   # カスタム文法を使用してスロットの期待される入力形式を定義します。
  #   # GRXML形式の文法ファイルをS3に配置して使用します。
  #
  #   grammar_slot_type_setting {
  #     # source - 文法ソース
  #     # スロットタイプの作成に使用される文法のソース情報。
  #
  #     source {
  #       # s3_bucket_name - S3バケット名（必須）
  #       # 文法ソースファイルが格納されているS3バケット名。
  #       s3_bucket_name = "my-grammar-bucket"
  #
  #       # s3_object_key - S3オブジェクトキー（必須）
  #       # S3バケット内の文法ファイルへのパス。
  #       # GRXML形式のファイル（.grxml拡張子）を指定します。
  #       s3_object_key = "grammars/my-grammar.grxml"
  #
  #       # kms_key_arn - KMSキーARN（必須）
  #       # 文法の内容を復号化するために必要なKMSキーのARN。
  #       # 暗号化されていない場合でも指定が必要です（空文字列可）。
  #       kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
  #     }
  #   }
  # }

  #---------------------------------------------------------------
  # Optional Blocks - Slot Type Values
  #---------------------------------------------------------------
  # slot_type_values - スロットタイプ値
  # スロットタイプが取りうる値のリストを定義します。
  # 各値に同義語を設定して、機械学習モデルのトレーニングを強化できます。

  # slot_type_values {
  #   # sample_value - サンプル値
  #   # スロットタイプのエントリの値を定義します。
  #
  #   sample_value {
  #     # value - 値（必須）
  #     # スロットタイプで使用できる値。
  #     # この値がスロット解決時のプライマリ値として使用されます。
  #     value = "small"
  #   }
  #
  #   # synonyms - 同義語
  #   # スロットタイプエントリに関連する追加の値のリスト。
  #   # ユーザーが同義語を入力すると、sample_valueの値に解決されます。
  #
  #   synonyms {
  #     # value - 同義語の値（必須）
  #     value = "tiny"
  #   }
  #
  #   synonyms {
  #     value = "little"
  #   }
  # }
  #
  # slot_type_values {
  #   sample_value {
  #     value = "medium"
  #   }
  #
  #   synonyms {
  #     value = "regular"
  #   }
  # }
  #
  # slot_type_values {
  #   sample_value {
  #     value = "large"
  #   }
  #
  #   synonyms {
  #     value = "big"
  #   }
  #
  #   synonyms {
  #     value = "grande"
  #   }
  # }

  #---------------------------------------------------------------
  # Optional Blocks - Value Selection Setting
  #---------------------------------------------------------------
  # value_selection_setting - 値選択設定
  # Amazon Lexが可能な値のリストから値を選択する戦略を決定します。
  # スロット値の解決方法とバリデーションを設定します。

  # value_selection_setting {
  #   # resolution_strategy - 解決戦略（必須）
  #   # スロットタイプ値を返す際の解決戦略。
  #   # 有効な値:
  #   #   - "OriginalValue": ユーザーの入力値をそのまま使用
  #   #   - "TopResolution": 最も一致度の高い値を使用
  #   #   - "Concatenation": 複数の値を連結して使用
  #   resolution_strategy = "OriginalValue"
  #
  #   # advanced_recognition_setting - 高度な認識設定
  #   # スロット値の高度な認識設定を有効にします。
  #   # スロット値をカスタムボキャブラリとして使用できます。
  #
  #   advanced_recognition_setting {
  #     # audio_recognition_strategy - 音声認識戦略
  #     # スロット値をカスタムボキャブラリとして使用して、
  #     # ユーザーの発話を認識します。
  #     # 有効な値: "UseSlotValuesAsCustomVocabulary"
  #     # 音声会話でスロット値の認識精度を向上させます。
  #     audio_recognition_strategy = "UseSlotValuesAsCustomVocabulary"
  #   }
  #
  #   # regex_filter - 正規表現フィルター
  #   # スロットの値を検証するために使用される正規表現。
  #   # 入力値が指定されたパターンに一致するかチェックします。
  #
  #   regex_filter {
  #     # pattern - パターン（必須）
  #     # スロット値を検証するための正規表現パターン。
  #     # 例: 郵便番号、電話番号、メールアドレスなどの形式を強制できます。
  #     pattern = "^[0-9]{5}$"
  #   }
  # }

  #---------------------------------------------------------------
  # Timeouts
  #---------------------------------------------------------------
  # timeouts - タイムアウト設定
  # リソース作成、更新、削除の操作タイムアウトを設定します。

  # timeouts {
  #   create = "30m"
  #   update = "30m"
  #   delete = "30m"
  # }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# このリソースでは以下の属性が参照可能です（computed属性）:
#
# - id
#   説明: bot_id、bot_version、locale_id、slot_type_idを
#         カンマ区切りで連結した文字列。
#   例: "bot123,DRAFT,en_US,slot456"
#
# - slot_type_id
#   説明: スロットタイプの一意な識別子。
#   用途: 他のリソース（スロット定義など）でこのスロットタイプを
#         参照する際に使用します。
#   例: aws_lexv2models_slot.example.slot_type_id
#
#---------------------------------------------------------------
