#---------------------------------------------------------------
# Amazon Elastic Transcoder Pipeline
#---------------------------------------------------------------
#
# Amazon Elastic Transcoder のパイプラインを作成・管理します。
# パイプラインは、トランスコーディングジョブのキューとして機能し、
# 入力メディアファイルの取得元、出力先、通知設定などを定義します。
#
# 重要: このリソースは非推奨です。AWS Elemental MediaConvert への
# 移行が推奨されています。Amazon Elastic Transcoder のサポートは
# 2025年11月13日をもって終了する予定です。
#
# AWS公式ドキュメント:
#   - Amazon Elastic Transcoder endpoints and quotas: https://docs.aws.amazon.com/general/latest/gr/elastictranscoder.html
#   - AmazonElasticTranscoder_FullAccess Managed Policy: https://docs.aws.amazon.com/aws-managed-policy/latest/reference/AmazonElasticTranscoder_FullAccess.html
#   - Migration to AWS Elemental MediaConvert: https://aws.amazon.com/blogs/media/migrating-workflows-from-amazon-elastic-transcoder-to-aws-elemental-mediaconvert/
#   - End of Support Announcement: https://aws.amazon.com/blogs/media/support-for-amazon-elastic-transcoder-ending-soon/
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/elastictranscoder_pipeline
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_elastictranscoder_pipeline" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # (Required) トランスコード対象のメディアファイルとグラフィックを
  # 保存するAmazon S3バケットの名前またはARN。
  # このバケットから入力ファイルを取得します。
  input_bucket = "my-input-bucket"

  # (Required) Elastic Transcoder がこのパイプラインのジョブを
  # トランスコードする際に使用するIAMロールのARN。
  # このロールには、S3バケットへのアクセス権限、SNSトピックへの
  # パブリッシュ権限などが必要です。
  role = "arn:aws:iam::123456789012:role/Elastic_Transcoder_Default_Role"

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # (Optional) AWS Key Management Service (AWS KMS) キーのARN。
  # このパイプラインで使用する暗号化キーを指定します。
  # 指定しない場合、デフォルトのS3暗号化が使用されます。
  aws_kms_key_arn = null

  # (Optional) パイプラインの名前。最大40文字。
  # 指定しない場合は自動生成されます。
  # Forces new resource: この値を変更すると新しいリソースが作成されます。
  name = "my-transcoding-pipeline"

  # (Optional) Elastic Transcoder がトランスコード済みファイルを
  # 保存するAmazon S3バケットの名前。
  # content_config を指定する場合は、このパラメータは省略してください。
  output_bucket = "my-output-bucket"

  # (Optional) Region where this resource will be managed.
  # デフォルトではプロバイダー設定のリージョンが使用されます。
  region = null

  #---------------------------------------------------------------
  # Content Config ブロック
  #---------------------------------------------------------------
  # (Optional) トランスコード済みファイルとプレイリストを保存する
  # Amazon S3バケットの情報を指定します。
  # このブロックを指定する場合は、thumbnail_config も必ず指定し、
  # output_bucket は省略してください。

  content_config {
    # (Optional) Elastic Transcoder がトランスコード済みファイルと
    # プレイリストを保存するAmazon S3バケット。
    # 指定しない場合は input_bucket が使用されます。
    bucket = "my-content-bucket"

    # (Optional) Amazon S3 ストレージクラス。
    # 有効な値: "Standard" または "ReducedRedundancy"
    storage_class = "Standard"
  }

  #---------------------------------------------------------------
  # Content Config Permissions ブロック
  #---------------------------------------------------------------
  # (Optional) content_config で指定したバケットへのアクセス権限を設定します。
  # 複数のユーザーやグループに対して権限を付与できます。

  content_config_permissions {
    # (Optional) content_config_permissions.grantee で指定したAWSユーザーに
    # 付与する権限。
    # 有効な値: ["Read", "ReadAcp", "WriteAcp", "FullControl"]
    # 複数の権限を配列で指定できます。
    access = ["Read", "ReadAcp"]

    # (Optional) トランスコード済みファイルとプレイリストへのアクセスを
    # 許可するAWSユーザーまたはグループ。
    # grantee_type に応じて、カノニカルユーザーID、メールアドレス、
    # またはグループURIを指定します。
    grantee = "user@example.com"

    # (Optional) content_config_permissions.grantee に表示される値のタイプ。
    # 有効な値: "Canonical", "Email", "Group"
    grantee_type = "Email"
  }

  #---------------------------------------------------------------
  # Notifications ブロック
  #---------------------------------------------------------------
  # (Optional) ジョブのステータスを通知するAmazon SNSトピックを指定します。
  # ジョブの各状態（完了、エラー、進行中、警告）に対して
  # 個別のSNSトピックを設定できます。

  notifications {
    # (Optional) パイプライン内のジョブの処理が完了したときに
    # 通知するAmazon SNS トピックのARN。
    completed = "arn:aws:sns:us-east-1:123456789012:transcoder-completed"

    # (Optional) パイプライン内のジョブの処理中にElastic Transcoder が
    # エラー状態に遭遇したときに通知するAmazon SNS トピックのARN。
    error = "arn:aws:sns:us-east-1:123456789012:transcoder-error"

    # (Optional) Elastic Transcoder がパイプライン内のジョブの
    # 処理を開始したときに通知するAmazon SNS トピックのARN。
    progressing = "arn:aws:sns:us-east-1:123456789012:transcoder-progressing"

    # (Optional) パイプライン内のジョブの処理中にElastic Transcoder が
    # 警告状態に遭遇したときに通知するAmazon SNS トピックのARN。
    warning = "arn:aws:sns:us-east-1:123456789012:transcoder-warning"
  }

  #---------------------------------------------------------------
  # Thumbnail Config ブロック
  #---------------------------------------------------------------
  # (Optional) サムネイルファイルを保存するAmazon S3バケットの情報を指定します。
  # content_config を指定する場合は、thumbnail_config も必ず指定してください。
  # サムネイルを作成しない場合でも、このブロックの指定が必要です。
  # （サムネイルの作成有無はジョブ作成時のThumbnailPatternで制御します）

  thumbnail_config {
    # (Optional) Elastic Transcoder がサムネイルファイルを保存する
    # Amazon S3バケット。
    # 指定しない場合は input_bucket が使用されます。
    bucket = "my-thumbnail-bucket"

    # (Optional) Amazon S3 ストレージクラス。
    # 有効な値: "Standard" または "ReducedRedundancy"
    storage_class = "Standard"
  }

  #---------------------------------------------------------------
  # Thumbnail Config Permissions ブロック
  #---------------------------------------------------------------
  # (Optional) thumbnail_config で指定したバケットへのアクセス権限を設定します。
  # 複数のユーザーやグループに対して権限を付与できます。

  thumbnail_config_permissions {
    # (Optional) thumbnail_config_permissions.grantee で指定したAWSユーザーに
    # 付与する権限。
    # 有効な値: ["Read", "ReadAcp", "WriteAcp", "FullControl"]
    # 複数の権限を配列で指定できます。
    access = ["Read"]

    # (Optional) サムネイルファイルへのアクセスを許可する
    # AWSユーザーまたはグループ。
    # grantee_type に応じて、カノニカルユーザーID、メールアドレス、
    # またはグループURIを指定します。
    grantee = "user@example.com"

    # (Optional) thumbnail_config_permissions.grantee に表示される値のタイプ。
    # 有効な値: "Canonical", "Email", "Group"
    grantee_type = "Email"
  }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします（読み取り専用）:
#
# - id  : Elastictranscoder パイプラインのID
# - arn : Elastictranscoder パイプラインのARN
#
# これらの属性は他のリソースから参照できます:
#   resource_arn = aws_elastictranscoder_pipeline.example.arn
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例: シンプルな構成
#---------------------------------------------------------------
# resource "aws_elastictranscoder_pipeline" "simple" {
#   input_bucket  = aws_s3_bucket.input.id
#   name          = "my-simple-pipeline"
#   role          = aws_iam_role.transcoder.arn
#   output_bucket = aws_s3_bucket.output.id
# }
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例: Content ConfigとThumbnail Configを使用
#---------------------------------------------------------------
# resource "aws_elastictranscoder_pipeline" "advanced" {
#   input_bucket = aws_s3_bucket.input.id
#   name         = "my-advanced-pipeline"
#   role         = aws_iam_role.transcoder.arn
#
#   content_config {
#     bucket        = aws_s3_bucket.content.id
#     storage_class = "Standard"
#   }
#
#   thumbnail_config {
#     bucket        = aws_s3_bucket.thumbnails.id
#     storage_class = "ReducedRedundancy"
#   }
#
#   notifications {
#     completed = aws_sns_topic.transcoder_completed.arn
#     error     = aws_sns_topic.transcoder_error.arn
#   }
# }
#---------------------------------------------------------------

#---------------------------------------------------------------
# サービスクォータ（デフォルト値）
#---------------------------------------------------------------
# - Pipelines per region: 4（調整可能）
# - Concurrent jobs per pipeline:
#   * us-west-2: 20
#   * その他のリージョン: 12（調整可能）
# - Queued jobs per pipeline: 1,000,000（調整不可）
# - Rate of Create Job requests: 2 requests/second（調整可能）
# - User-defined presets: 50（調整可能）
#---------------------------------------------------------------
