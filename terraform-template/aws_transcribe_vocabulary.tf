#---------------------------------------------------------------
# AWS Transcribe Vocabulary
#---------------------------------------------------------------
#
# Amazon Transcribeのカスタム語彙（Custom Vocabulary）をプロビジョニングするリソースです。
# カスタム語彙を使用することで、ドメイン固有の用語や固有名詞、略語などの
# 音声認識精度を向上させることができます。
#
# AWS公式ドキュメント:
#   - カスタム語彙: https://docs.aws.amazon.com/transcribe/latest/dg/custom-vocabulary.html
#   - カスタム語彙の使用: https://docs.aws.amazon.com/transcribe/latest/dg/custom-vocabulary-using.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/transcribe_vocabulary
#
# Provider Version: 6.28.0
# Generated: 2026-02-09
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_transcribe_vocabulary" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # vocabulary_name (Required, Forces new resource)
  # 設定内容: カスタム語彙の名前を指定します。
  # 設定可能な値: 一意の文字列
  vocabulary_name = "example-vocabulary"

  # language_code (Required, Forces new resource)
  # 設定内容: カスタム語彙の言語コードを指定します。
  # 設定可能な値: Amazon Transcribeがサポートする言語コード
  #   - "en-US": 英語（米国）
  #   - "ja-JP": 日本語
  #   - "en-GB": 英語（英国）
  #   - その他、Transcribeがサポートする言語コード
  # 参考: https://docs.aws.amazon.com/transcribe/latest/dg/supported-languages.html
  language_code = "ja-JP"

  #-------------------------------------------------------------
  # 語彙データ設定
  #-------------------------------------------------------------

  # vocabulary_file_uri (Optional)
  # 設定内容: カスタム語彙を含むテキストファイルのAmazon S3ロケーション（URI）を指定します。
  # 設定可能な値: S3 URI（例: s3://bucket-name/path/to/vocabulary.txt）
  # 注意: phrasesと排他的（どちらか一方のみ指定可能）
  vocabulary_file_uri = "s3://my-bucket/transcribe/vocabulary.txt"

  # phrases (Optional)
  # 設定内容: 語彙に含める用語のリストを指定します。
  # 設定可能な値: 文字列のリスト
  # 注意: vocabulary_file_uriと排他的（どちらか一方のみ指定可能）
  # 参考: https://docs.aws.amazon.com/transcribe/latest/dg/custom-vocabulary-create-list.html
  phrases = null

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
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-vocabulary"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウトを指定します。
    # 設定可能な値: 時間を表す文字列（例: "30m", "1h"）
    create = null

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウトを指定します。
    # 設定可能な値: 時間を表す文字列（例: "30m", "1h"）
    update = null

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウトを指定します。
    # 設定可能な値: 時間を表す文字列（例: "30m", "1h"）
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
# - download_uri: 生成されたダウンロードURI
#
# - id: カスタム語彙の名前
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
