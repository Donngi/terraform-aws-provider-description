#---------------------------------------------------------------
# Amazon Transcribe Medical Vocabulary
#---------------------------------------------------------------
#
# Amazon Transcribe Medicalのカスタム医療用語集をプロビジョニングするリソースです。
# カスタム医療用語集は、ドメイン固有の単語やフレーズのコレクションであり、
# Amazon Transcribe Medicalがそれらの用語をより正確に文字起こしするのに役立ちます。
#
# AWS公式ドキュメント:
#   - 医療用カスタム語彙で文字起こし精度を向上させる: https://docs.aws.amazon.com/transcribe/latest/dg/vocabulary-med.html
#   - テキストファイルを使用した医療用カスタム語彙の作成: https://docs.aws.amazon.com/transcribe/latest/dg/create-med-custom-vocabulary.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/transcribe_medical_vocabulary
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_transcribe_medical_vocabulary" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # vocabulary_name (Required)
  # 設定内容: 医療用語集の名前を指定します。
  # 設定可能な値: 1-200文字の文字列。英数字、ハイフン、アンダースコアが使用可能
  # 注意: 名前は大文字と小文字を区別します。同じAWSアカウントとリージョン内で一意である必要があります
  # 参考: https://docs.aws.amazon.com/transcribe/latest/dg/vocabulary-med.html
  vocabulary_name = "example-medical-vocabulary"

  # language_code (Required)
  # 設定内容: 医療用語集に使用する言語コードを指定します。
  # 設定可能な値:
  #   - "en-US": 米国英語（Amazon Transcribe Medicalでサポートされる唯一の言語）
  # 注意: Amazon Transcribe Medicalは現在、米国英語（en-US）のみをサポートしています
  # 参考: https://docs.aws.amazon.com/transcribe/latest/dg/vocabulary-med.html
  language_code = "en-US"

  # vocabulary_file_uri (Required)
  # 設定内容: カスタム医療用語集を含むテキストファイルのAmazon S3ロケーション（URI）を指定します。
  # 設定可能な値: s3://バケット名/オブジェクトキー の形式のS3 URI
  # 注意: テキストファイルには、行ごとに1つの単語またはフレーズを含める必要があります。
  #       ファイルはUTF-8エンコーディングである必要があります。
  #       最適な結果を得るには、特定の録音用に小さなカスタム語彙を作成してください。
  # 関連機能: Amazon Transcribe Medical カスタム語彙
  #   カスタム語彙のサイズは50 KBを超えることはできません。
  #   デフォルトでは、AWSアカウントで最大100個のカスタム語彙が許可されています。
  #   - https://docs.aws.amazon.com/transcribe/latest/dg/create-med-custom-vocabulary.html
  vocabulary_file_uri = "s3://example-bucket/transcribe/medical-terms.txt"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, us-west-2）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://docs.aws.amazon.com/transcribe/latest/dg/tagging.html
  tags = {
    Name        = "example-medical-vocabulary"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "30m", "1h"）
    # 省略時: デフォルトのタイムアウト時間が使用されます
    # 注意: 医療用語集の作成には、ファイルサイズと用語数に応じて時間がかかる場合があります
    create = null

    # update (Optional)
    # 設定内容: リソース更新のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "30m", "1h"）
    # 省略時: デフォルトのタイムアウト時間が使用されます
    update = null

    # delete (Optional)
    # 設定内容: リソース削除のタイムアウト時間を指定します。
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
# - id: 医療用語集の名前
#
# - arn: 医療用語集のAmazon Resource Name (ARN)
#        形式: arn:aws:transcribe:region:account-id:medical-vocabulary/vocabulary-name
#
# - download_uri: 生成されたダウンロードURI
#                 Amazon Transcribeが処理した医療用語集ファイルをダウンロードするための
#                 一時的なS3 URIです。このURIは限られた期間のみ有効です。
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
