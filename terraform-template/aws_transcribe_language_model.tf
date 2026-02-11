#---------------------------------------------------------------
# AWS Transcribe Language Model
#---------------------------------------------------------------
#
# Amazon Transcribeのカスタム言語モデルをプロビジョニングするリソースです。
# カスタム言語モデルは、ドメイン固有の音声の文字起こし精度を向上させるために、
# トレーニングデータとチューニングデータを使用して作成されます。
#
# NOTE: このリソースのプロビジョニングには相当な時間がかかる場合があります。
#
# AWS公式ドキュメント:
#   - カスタム言語モデル: https://docs.aws.amazon.com/transcribe/latest/dg/custom-language-models.html
#   - カスタム言語モデルの作成: https://docs.aws.amazon.com/transcribe/latest/dg/custom-language-models-create.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/transcribe_language_model
#
# Provider Version: 6.28.0
# Generated: 2026-02-09
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_transcribe_language_model" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # model_name (Required, Forces new resource)
  # 設定内容: カスタム言語モデルの名前を指定します。
  # 設定可能な値: 1-200文字の文字列（英数字、アンダースコア、ハイフン）
  model_name = "example-language-model"

  # base_model_name (Required, Forces new resource)
  # 設定内容: ベースモデルの名前を指定します。
  # 設定可能な値:
  #   - "NarrowBand": サンプルレートが16,000 Hz未満の音声用（電話音声など）
  #   - "WideBand": サンプルレートが16,000 Hz以上の音声用（高品質録音など）
  # 参考: https://docs.aws.amazon.com/transcribe/latest/dg/custom-language-models-create.html
  base_model_name = "NarrowBand"

  # language_code (Required, Forces new resource)
  # 設定内容: 言語モデルの言語コードを指定します。
  # 設定可能な値: サポートされている言語コード（例: "en-US", "ja-JP" 等）
  # 注意: カスタム言語モデルの言語は、文字起こしリクエストで指定する言語コードと一致する必要があります。
  # 参考: https://docs.aws.amazon.com/transcribe/latest/dg/supported-languages.html
  language_code = "en-US"

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
  # 入力データ設定
  #-------------------------------------------------------------

  # input_data_config (Required)
  # 設定内容: 言語モデルのトレーニングに使用する入力データの設定を指定します。
  # 関連機能: カスタム言語モデルのデータ準備
  #   トレーニングデータはプレーンテキスト形式でS3バケットにアップロードする必要があります。
  #   トレーニングデータは最大2 GB、チューニングデータは最大200 MBまで指定可能です。
  #   - https://docs.aws.amazon.com/transcribe/latest/dg/custom-language-models-create.html
  input_data_config {
    # data_access_role_arn (Required)
    # 設定内容: S3バケットへのアクセス権限を持つIAMロールのARNを指定します。
    # 設定可能な値: 有効なIAMロールARN
    # 注意: ロールにはtranscribe.amazonaws.comサービスプリンシパルの信頼ポリシーと、
    #       S3バケットへのGetObject/ListBucket権限が必要です。
    data_access_role_arn = "arn:aws:iam::123456789012:role/example-transcribe-role"

    # s3_uri (Required)
    # 設定内容: トレーニングデータが配置されているS3 URIを指定します。
    # 設定可能な値: 有効なS3 URI（例: s3://bucket-name/path/）
    # 注意: データはプレーンテキスト形式である必要があります。
    s3_uri = "s3://example-bucket/transcribe/training-data/"

    # tuning_data_s3_uri (Optional)
    # 設定内容: チューニングデータが配置されているS3 URIを指定します。
    # 設定可能な値: 有効なS3 URI（例: s3://bucket-name/path/）
    # 省略時: チューニングデータなしでモデルが作成されます。
    # 関連機能: チューニングデータ
    #   トレーニングデータから学習した文脈関係を最適化・改善するために使用されます。
    #   正確なトランスクリプトがある場合、チューニングデータとして使用すると効果的です。
    #   - https://docs.aws.amazon.com/transcribe/latest/dg/custom-language-models.html
    tuning_data_s3_uri = null
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定します。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "30m", "1h", "2h"）
    # 省略時: デフォルトのタイムアウトが適用されます。
    # 注意: カスタム言語モデルの作成には相当な時間がかかる場合があります。
    create = null
  }

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
    Name        = "example-language-model"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: 言語モデルの名前
#
# - arn: 言語モデルのAmazon Resource Name (ARN)
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
