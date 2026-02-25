#-----------------------------------------------
# AWS Elastic Transcoder Pipeline
#-----------------------------------------------
# Elastic Transcoderパイプラインを作成します。
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/elastictranscoder_pipeline
#
# NOTE: このリソースは非推奨です
# AWS Elastic Transcoderのサポートは2025年11月13日に終了予定です。
# AWS Elemental MediaConvertへの移行を推奨します。
# https://aws.amazon.com/blogs/media/migrating-workflows-from-amazon-elastic-transcoder-to-aws-elemental-mediaconvert/

#-----------------------------------------------
# 基本設定
#-----------------------------------------------
resource "aws_elastictranscoder_pipeline" "example" {
  # 設定内容: パイプライン名
  # 設定可能な値: 最大40文字の文字列
  # 省略時: 自動生成される
  # 注意: 変更すると新しいリソースが作成される
  name = "example-pipeline"

  # 設定内容: 入力メディアファイルと透かし用グラフィックを保存するS3バケット
  # 設定可能な値: S3バケット名
  input_bucket = "input-bucket-name"

  # 設定内容: トランスコードジョブの実行に使用するIAMロールのARN
  # 設定可能な値: IAMロールのARN
  role = "arn:aws:iam::123456789012:role/Elastic_Transcoder_Default_Role"

  #-----------------------------------------------
  # リージョン設定
  #-----------------------------------------------
  # 設定内容: リソースを管理するAWSリージョン
  # 設定可能な値: AWSリージョンコード（us-east-1など）
  # 省略時: プロバイダー設定のリージョンを使用
  region = "us-east-1"

  #-----------------------------------------------
  # 出力設定
  #-----------------------------------------------
  # 設定内容: トランスコード済みファイルを保存するS3バケット
  # 設定可能な値: S3バケット名
  # 省略時: 自動生成される
  # 注意: content_configとthumbnail_configを指定する場合は省略する
  output_bucket = "output-bucket-name"

  #-----------------------------------------------
  # 暗号化設定
  #-----------------------------------------------
  # 設定内容: パイプラインで使用するAWS KMSキー
  # 設定可能な値: AWS KMSキーのARN
  # 省略時: 暗号化なし
  aws_kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"

  #-----------------------------------------------
  # コンテンツ出力設定
  #-----------------------------------------------
  # 設定内容: トランスコード済みファイルとプレイリストの保存先S3バケット設定
  # 注意: この設定を使用する場合はthumbnail_configも必須、output_bucketは省略する
  # content_config {
  #   # 設定内容: トランスコード済みファイルとプレイリストを保存するS3バケット
  #   # 設定可能な値: S3バケット名
  #   # 省略時: 自動生成される
  #   bucket = "content-bucket-name"
  #
  #   # 設定内容: ファイルに割り当てるS3ストレージクラス
  #   # 設定可能な値: Standard、ReducedRedundancy
  #   # 省略時: Standardが使用される
  #   storage_class = "Standard"
  # }

  #-----------------------------------------------
  # コンテンツアクセス権限設定
  #-----------------------------------------------
  # 設定内容: トランスコード済みファイルとプレイリストへのアクセス権限
  # 注意: 複数のアクセス権限を設定可能
  # content_config_permissions {
  #   # 設定内容: 付与する権限
  #   # 設定可能な値: Read、ReadAcp、WriteAcp、FullControl
  #   access = ["Read", "ReadAcp"]
  #
  #   # 設定内容: アクセス権を付与するAWSユーザーまたはグループ
  #   # 設定可能な値: CanonicalユーザーID、Eメールアドレス、グループURI
  #   grantee = "canonical-user-id"
  #
  #   # 設定内容: granteeに指定する値のタイプ
  #   # 設定可能な値: Canonical、Email、Group
  #   grantee_type = "Canonical"
  # }

  #-----------------------------------------------
  # サムネイル出力設定
  #-----------------------------------------------
  # 設定内容: サムネイルファイルの保存先S3バケット設定
  # 注意: content_configを使用する場合はこの設定も必須
  # thumbnail_config {
  #   # 設定内容: サムネイルファイルを保存するS3バケット
  #   # 設定可能な値: S3バケット名
  #   # 省略時: 自動生成される
  #   bucket = "thumbnail-bucket-name"
  #
  #   # 設定内容: サムネイルファイルに割り当てるS3ストレージクラス
  #   # 設定可能な値: Standard、ReducedRedundancy
  #   # 省略時: Standardが使用される
  #   storage_class = "Standard"
  # }

  #-----------------------------------------------
  # サムネイルアクセス権限設定
  #-----------------------------------------------
  # 設定内容: サムネイルファイルへのアクセス権限
  # 注意: 複数のアクセス権限を設定可能
  # thumbnail_config_permissions {
  #   # 設定内容: 付与する権限
  #   # 設定可能な値: Read、ReadAcp、WriteAcp、FullControl
  #   access = ["Read"]
  #
  #   # 設定内容: アクセス権を付与するAWSユーザーまたはグループ
  #   # 設定可能な値: CanonicalユーザーID、Eメールアドレス、グループURI
  #   grantee = "canonical-user-id"
  #
  #   # 設定内容: granteeに指定する値のタイプ
  #   # 設定可能な値: Canonical、Email、Group
  #   grantee_type = "Canonical"
  # }

  #-----------------------------------------------
  # 通知設定
  #-----------------------------------------------
  # 設定内容: ジョブステータスを通知するSNSトピック
  # notifications {
  #   # 設定内容: ジョブ完了時に通知するSNSトピックのARN
  #   # 設定可能な値: SNSトピックのARN
  #   # 省略時: 通知なし
  #   completed = "arn:aws:sns:us-east-1:123456789012:topic-completed"
  #
  #   # 設定内容: エラー発生時に通知するSNSトピックのARN
  #   # 設定可能な値: SNSトピックのARN
  #   # 省略時: 通知なし
  #   error = "arn:aws:sns:us-east-1:123456789012:topic-error"
  #
  #   # 設定内容: ジョブ処理開始時に通知するSNSトピックのARN
  #   # 設定可能な値: SNSトピックのARN
  #   # 省略時: 通知なし
  #   progressing = "arn:aws:sns:us-east-1:123456789012:topic-progressing"
  #
  #   # 設定内容: 警告発生時に通知するSNSトピックのARN
  #   # 設定可能な値: SNSトピックのARN
  #   # 省略時: 通知なし
  #   warning = "arn:aws:sns:us-east-1:123456789012:topic-warning"
  # }
}

#-----------------------------------------------
# Attributes Reference
#-----------------------------------------------
# 以下の属性がエクスポートされます:
#
# id - Elastic Transcoderパイプラインのリソース識別子
# arn - Elastic TranscoderパイプラインのARN（Amazon Resource Name）
#-----------------------------------------------
