#---------------------------------------------------------------
# Amazon Transcribe Vocabulary Filter
#---------------------------------------------------------------
#
# Amazon Transcribeの書き起こし結果から特定の単語を削除、マスク、
# またはタグ付けするためのカスタム語彙フィルターをプロビジョニングします。
# 不適切な用語の除外や機密情報のマスキングなどに使用できます。
#
# AWS公式ドキュメント:
#   - カスタム語彙フィルターの使用: https://docs.aws.amazon.com/transcribe/latest/dg/vocabulary-filtering.html
#   - 語彙フィルターの作成: https://docs.aws.amazon.com/transcribe/latest/dg/vocabulary-filter-create.html
#   - CreateVocabularyFilter API: https://docs.aws.amazon.com/transcribe/latest/APIReference/API_CreateVocabularyFilter.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/transcribe_vocabulary_filter
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_transcribe_vocabulary_filter" "example" {
  #---------------------------------------------------------------
  # 基本設定
  #---------------------------------------------------------------

  # vocabulary_filter_name (Required)
  # 設定内容: VocabularyFilterの名前を指定します。
  # 設定可能な値: 文字列
  vocabulary_filter_name = "example-vocabulary-filter"

  # language_code (Required)
  # 設定内容: 語彙フィルターのエントリで使用する言語コードを指定します。
  #           書き起こしジョブの言語コードと一致する必要があります。
  # 設定可能な値: Amazon Transcribeがサポートする言語コード
  #   例: "en-US", "ja-JP", "es-ES", "fr-FR", "de-DE" など
  # 参考: サポートされている言語の完全なリスト
  #       https://docs.aws.amazon.com/transcribe/latest/dg/supported-languages.html
  language_code = "en-US"

  #---------------------------------------------------------------
  # フィルター単語設定
  #---------------------------------------------------------------

  # words (Optional)
  # 設定内容: フィルタリングする単語のリストを直接指定します。
  # 設定可能な値: 文字列のリスト
  #   - 各エントリは1単語のみを含むことができます
  #   - 大文字小文字は区別されません
  #   - 完全一致する単語のみがフィルタリングされます（部分一致は対象外）
  # 注意: vocabulary_filter_file_uriと排他的（どちらか一方のみ指定可能）
  # 制限:
  #   - 各語彙フィルターは最大50KBまで
  #   - AWSアカウントあたり最大100個のカスタム語彙フィルター
  # 関連機能: カスタム語彙フィルター
  #   不適切な用語の除外や機密情報のマスキングなどに使用できます。
  #   https://docs.aws.amazon.com/transcribe/latest/dg/vocabulary-filter-create.html
  words = ["cars", "bucket"]

  # vocabulary_filter_file_uri (Optional)
  # 設定内容: カスタム語彙フィルターを含むテキストファイルの
  #           Amazon S3ロケーション（URI）を指定します。
  # 設定可能な値: S3 URI形式の文字列（例: "s3://bucket-name/path/to/file.txt"）
  # 注意: wordsパラメータと排他的（どちらか一方のみ指定可能）
  # 制限:
  #   - ファイルはUTF-8エンコーディングのプレーンテキスト形式である必要があります
  #   - IAMロールがS3バケットへのアクセス権限を持つ必要があります
  # 関連機能: カスタム語彙フィルター
  #   S3に保存された単語リストファイルを使用してフィルタリングを行います。
  #   https://docs.aws.amazon.com/transcribe/latest/dg/vocabulary-filter-create.html
  # vocabulary_filter_file_uri = "s3://example-bucket/vocabulary-filter.txt"

  #---------------------------------------------------------------
  # リージョン設定
  #---------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #---------------------------------------------------------------
  # タグ設定
  #---------------------------------------------------------------

  # tags (Optional)
  # 設定内容: VocabularyFilterに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Environment = "production"
    Project     = "transcription-system"
    ManagedBy   = "terraform"
  }
}

#---------------------------------------------------------------
# Attributes Reference（参照専用属性）
#---------------------------------------------------------------
# 以下の属性はリソース作成後に参照可能です（設定不可）:
#
# - id
#   説明: VocabularyFilter名（vocabulary_filter_nameと同じ値）
#   型: string
#
# - arn
#   説明: VocabularyFilterのAmazon Resource Name (ARN)
#   型: string
#   例: "arn:aws:transcribe:us-east-1:123456789012:vocabulary-filter/example-vocabulary-filter"
#
# - download_uri
#   説明: 語彙フィルターファイルをダウンロードするための生成されたURI
#   型: string
#   注意: このURIは一時的なもので、有効期限があります
#
# - tags_all
#   説明: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#         リソースに割り当てられたすべてのタグのマップ
#   型: map(string)
#
#---------------------------------------------------------------
# 使用例
#---------------------------------------------------------------
# 出力例:
# output "vocabulary_filter_arn" {
#   description = "The ARN of the vocabulary filter"
#   value       = aws_transcribe_vocabulary_filter.example.arn
# }
#
# output "vocabulary_filter_download_uri" {
#   description = "The download URI for the vocabulary filter"
#   value       = aws_transcribe_vocabulary_filter.example.download_uri
# }
#
# 書き起こしジョブでの使用例:
# resource "aws_transcribe_transcription_job" "example" {
#   transcription_job_name = "example-job"
#   language_code          = "en-US"
#   media_format           = "mp3"
#
#   media {
#     media_file_uri = "s3://my-bucket/audio.mp3"
#   }
#
#   settings {
#     vocabulary_filter_name   = aws_transcribe_vocabulary_filter.example.vocabulary_filter_name
#     vocabulary_filter_method = "mask" # "remove", "mask", または "tag"
#   }
# }
#
#---------------------------------------------------------------
