#---------------------------------------------------------------
# AWS Transcribe Vocabulary Filter
#---------------------------------------------------------------
#
# Amazon Transcribeの語彙フィルター（Vocabulary Filter）をプロビジョニングするリソースです。
# 語彙フィルターを使用することで、音声文字変換の結果から特定の単語を
# フィルタリング（マスク、削除、またはタグ付け）することができます。
# 不適切な言葉や機密情報を含む単語を自動的に処理するのに役立ちます。
#
# AWS公式ドキュメント:
#   - 語彙フィルター: https://docs.aws.amazon.com/transcribe/latest/dg/vocabulary-filtering.html
#   - 語彙フィルターの使用: https://docs.aws.amazon.com/transcribe/latest/dg/vocabulary-filtering-using.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/transcribe_vocabulary_filter
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_transcribe_vocabulary_filter" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # vocabulary_filter_name (Required, Forces new resource)
  # 設定内容: 語彙フィルターの名前を指定します。
  # 設定可能な値: 一意の文字列
  vocabulary_filter_name = "example-vocabulary-filter"

  # language_code (Required, Forces new resource)
  # 設定内容: 語彙フィルターの言語コードを指定します。
  # 設定可能な値: Amazon Transcribeがサポートする言語コード
  #   - "en-US": 英語（米国）
  #   - "ja-JP": 日本語
  #   - "en-GB": 英語（英国）
  #   - その他、Transcribeがサポートする言語コード
  # 参考: https://docs.aws.amazon.com/transcribe/latest/dg/supported-languages.html
  language_code = "ja-JP"

  #-------------------------------------------------------------
  # フィルターデータ設定
  #-------------------------------------------------------------

  # vocabulary_filter_file_uri (Optional)
  # 設定内容: フィルタリングする単語のリストを含むテキストファイルのAmazon S3ロケーション（URI）を指定します。
  # 設定可能な値: S3 URI（例: s3://bucket-name/path/to/filter-words.txt）
  # 注意: wordsと排他的（どちらか一方のみ指定可能）
  vocabulary_filter_file_uri = "s3://my-bucket/transcribe/filter-words.txt"

  # words (Optional)
  # 設定内容: フィルタリングする単語のリストを直接指定します。
  # 設定可能な値: 文字列のリスト
  # 注意: vocabulary_filter_file_uriと排他的（どちらか一方のみ指定可能）
  words = null

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
    Name        = "example-vocabulary-filter"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: 語彙フィルターのAmazon Resource Name (ARN)
#
# - download_uri: 生成されたダウンロードURI
#
# - id: 語彙フィルターの名前
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
