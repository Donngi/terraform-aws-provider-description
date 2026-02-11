#---------------------------------------------------------------
# AWS Amazon Connect Vocabulary
#---------------------------------------------------------------
#
# Amazon Connectのカスタム語彙をプロビジョニングするリソースです。
# カスタム語彙を使用することで、Amazon Transcribeがコンタクトセンターの
# 会話をより正確に文字起こしできるようになります。
# 業界固有の用語、製品名、人名などをカスタム語彙として登録できます。
#
# AWS公式ドキュメント:
#   - Amazon Connect概要: https://docs.aws.amazon.com/connect/latest/adminguide/amazon-connect-get-started.html
#   - カスタム語彙の作成: https://docs.aws.amazon.com/transcribe/latest/dg/custom-vocabulary.html
#   - カスタム語彙テーブルの作成: https://docs.aws.amazon.com/transcribe/latest/dg/custom-vocabulary.html#create-vocabulary-table
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/connect_vocabulary
#
# Provider Version: 6.28.0
# Generated: 2026-01-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_connect_vocabulary" "example" {
  #-------------------------------------------------------------
  # 必須パラメータ
  #-------------------------------------------------------------

  # instance_id (Required)
  # 設定内容: Amazon Connect インスタンスの識別子を指定します。
  # 設定可能な値: 有効なAmazon Connect インスタンスID (UUID形式)
  # 注意: このインスタンスでカスタム語彙をホストします
  instance_id = "aaaaaaaa-bbbb-cccc-dddd-111111111111"

  # name (Required)
  # 設定内容: カスタム語彙の一意な名前を指定します。
  # 設定可能な値: 1-140文字の文字列
  # 注意: インスタンス内で一意である必要があります
  name = "example-vocabulary"

  # content (Required)
  # 設定内容: カスタム語彙の内容をプレーンテキスト形式のテーブルで指定します。
  # 設定可能な値: 1-60000文字の文字列
  # フォーマット: Phrase、IPA、SoundsLike、DisplayAsの4つのフィールドをTAB文字で区切ったテーブル
  #   - Phrase: 語彙に追加する単語またはフレーズ（必須）
  #   - IPA: 国際音声記号による発音（任意）
  #   - SoundsLike: 音声類似表記（任意）
  #   - DisplayAs: 表示形式（任意）
  # 関連機能: Amazon Transcribe カスタム語彙
  #   テーブル形式でカスタム語彙を定義。各行が1つの単語またはフレーズを表します。
  #   TAB文字でフィールドを区切る必要があります。
  #   - https://docs.aws.amazon.com/transcribe/latest/dg/custom-vocabulary.html#create-vocabulary-table
  content = <<-EOT
Phrase	IPA	SoundsLike	DisplayAs
Los-Angeles			Los Angeles
F.B.I.	ɛ f b i aɪ		FBI
Etienne		eh-tee-en
EOT

  # language_code (Required)
  # 設定内容: 語彙エントリの言語コードを指定します。
  # 設定可能な値:
  #   - ar-AE: アラビア語（UAE）
  #   - de-CH: ドイツ語（スイス）
  #   - de-DE: ドイツ語（ドイツ）
  #   - en-AB: 英語（英国）
  #   - en-AU: 英語（オーストラリア）
  #   - en-GB: 英語（英国）
  #   - en-IE: 英語（アイルランド）
  #   - en-IN: 英語（インド）
  #   - en-US: 英語（米国）
  #   - en-WL: 英語（ウェールズ）
  #   - es-ES: スペイン語（スペイン）
  #   - es-US: スペイン語（米国）
  #   - fr-CA: フランス語（カナダ）
  #   - fr-FR: フランス語（フランス）
  #   - hi-IN: ヒンディー語（インド）
  #   - it-IT: イタリア語（イタリア）
  #   - ja-JP: 日本語（日本）
  #   - ko-KR: 韓国語（韓国）
  #   - pt-BR: ポルトガル語（ブラジル）
  #   - pt-PT: ポルトガル語（ポルトガル）
  #   - zh-CN: 中国語（簡体字）
  # 関連機能: Amazon Transcribe サポート言語
  #   Amazon Transcribeがサポートする言語の一覧
  #   - https://docs.aws.amazon.com/transcribe/latest/dg/transcribe-whatis.html
  language_code = "en-US"

  #-------------------------------------------------------------
  # オプションパラメータ
  #-------------------------------------------------------------

  # id (Optional, Computed)
  # 設定内容: リソースの識別子を指定します。
  # 設定可能な値: 文字列
  # 省略時: Amazon Connect インスタンスIDと語彙IDをコロン(:)で連結した値が自動生成されます
  # フォーマット例: "aaaaaaaa-bbbb-cccc-dddd-111111111111:vocabulary-id"
  # 注意: 通常は省略推奨。Terraformが自動的に管理します
  id = null

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 関連機能: リージョナルエンドポイント
  #   - https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # 参考: プロバイダー設定
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#aws-configuration-reference
  region = null

  # tags (Optional)
  # 設定内容: カスタム語彙に割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、リソースレベルで定義されたものが優先されます。
  tags = {
    Name        = "example-vocabulary"
    Environment = "production"
  }

  # tags_all (Optional, Computed)
  # 設定内容: リソースに割り当てられるすべてのタグを明示的に指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: tagsとプロバイダーのdefault_tagsがマージされた値が自動設定されます
  # 注意: 通常はtagsの使用を推奨。tags_allは高度なユースケースでのみ使用
  # 関連機能: デフォルトタグ設定
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags_all = null

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "30m", "1h"）
    # 省略時: デフォルトのタイムアウト時間が使用されます
    create = null

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "30m", "1h"）
    # 省略時: デフォルトのタイムアウト時間が使用されます
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: カスタム語彙のAmazon Resource Name (ARN)
#
# - failure_reason: カスタム語彙が作成されなかった理由
#        語彙の作成に失敗した場合にエラーメッセージが設定されます
#
# - last_modified_time: カスタム語彙が最後に変更されたタイムスタンプ
#
# - state: カスタム語彙の現在の状態
#        設定可能な値:
#        - CREATION_IN_PROGRESS: 作成処理中
#        - ACTIVE: 使用可能な状態
#        - CREATION_FAILED: 作成失敗
#        - DELETE_IN_PROGRESS: 削除処理中
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#
# - vocabulary_id: カスタム語彙の識別子
#---------------------------------------------------------------
