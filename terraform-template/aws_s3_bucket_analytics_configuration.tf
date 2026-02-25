#---------------------------------------------------------------
# AWS S3 Bucket Analytics Configuration
#---------------------------------------------------------------
#
# S3バケットのアナリティクス設定リソースをプロビジョニングします。
# このリソースは、S3バケットのストレージクラス分析設定を管理し、
# オブジェクトアクセスパターンを分析して最適なストレージクラスへの
# ライフサイクル移行タイミングを判断するためのデータをエクスポートします。
#
# 注意: このリソースはS3ディレクトリバケットでは使用できません。
#
# AWS公式ドキュメント:
#   - S3アナリティクス設定概要: https://docs.aws.amazon.com/AmazonS3/latest/dev/analytics-storage-class.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_analytics_configuration
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_s3_bucket_analytics_configuration" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # bucket (Required)
  # 設定内容: アナリティクス設定を関連付けるバケット名を指定します。
  # 設定可能な値: 既存のS3バケット名
  bucket = "example-bucket"

  # name (Required)
  # 設定内容: バケットのアナリティクス設定の一意の識別子を指定します。
  # 設定可能な値: 任意の文字列
  name = "EntireBucket"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # フィルタ設定
  #-------------------------------------------------------------

  # filter (Optional)
  # 設定内容: アナリティクス設定に適用するオブジェクトフィルタリング条件を指定します。
  # 設定可能な値: prefix、tags、またはprefixとtagsの論理ANDの組み合わせ
  # 省略時: バケット全体のオブジェクトを分析対象とする
  filter {
    # prefix (Optional)
    # 設定内容: フィルタリングに使用するオブジェクトプレフィックスを指定します。
    # 設定可能な値: 任意の文字列（パス形式も可）
    prefix = "documents/"

    # tags (Optional)
    # 設定内容: フィルタリングに使用するオブジェクトタグのマップを指定します。
    # 設定可能な値: キーと値のペアのマップ
    tags = {
      priority = "high"
      class    = "blue"
    }
  }

  #-------------------------------------------------------------
  # ストレージクラス分析設定
  #-------------------------------------------------------------

  # storage_class_analysis (Optional)
  # 設定内容: アナリティクスデータのエクスポート設定を指定します。
  # 省略時: エクスポートは設定されない
  storage_class_analysis {
    # data_export (Required within storage_class_analysis)
    # 設定内容: データエクスポートの設定を指定します。
    data_export {
      # output_schema_version (Optional)
      # 設定内容: エクスポートされるアナリティクスデータのスキーマバージョンを指定します。
      # 設定可能な値: "V_1"
      # 省略時: "V_1"
      output_schema_version = "V_1"

      # destination (Required within data_export)
      # 設定内容: エクスポートされるアナリティクスデータの送信先を指定します。
      destination {
        # s3_bucket_destination (Required within destination)
        # 設定内容: エクスポート先となるS3バケットの設定を指定します。
        # 注意: アナリティクスデータのエクスポート先はS3バケットのみサポートされます。
        s3_bucket_destination {
          # bucket_arn (Required)
          # 設定内容: エクスポート先バケットのARNを指定します。
          # 設定可能な値: S3バケットのARN
          bucket_arn = "arn:aws:s3:::analytics-destination-bucket"

          # bucket_account_id (Optional)
          # 設定内容: エクスポート先バケットを所有するアカウントIDを指定します。
          # 設定可能な値: 12桁のAWSアカウントID
          # 省略時: バケット所有者のアカウントIDを使用
          bucket_account_id = null

          # format (Optional)
          # 設定内容: エクスポートされるアナリティクスデータの出力フォーマットを指定します。
          # 設定可能な値: "CSV"
          # 省略時: "CSV"
          format = "CSV"

          # prefix (Optional)
          # 設定内容: エクスポートされるアナリティクスデータのプレフィックスを指定します。
          # 設定可能な値: 任意の文字列
          # 省略時: プレフィックスなし
          prefix = "analytics/"
        }
      }
    }
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: バケット名とアナリティクス設定名の組み合わせ（bucket:name）
#
#---------------------------------------------------------------
