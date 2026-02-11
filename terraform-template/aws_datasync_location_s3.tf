# ================================================================================
# aws_datasync_location_s3
# ================================================================================
#
# リソース概要:
#   AWS DataSyncのS3ロケーションを管理するリソース。
#   DataSyncはS3バケット間、またはS3とオンプレミスストレージ間でデータを転送する
#   マネージドサービスで、このリソースは転送元または転送先としてのS3ロケーションを定義します。
#
# 生成日: 2026-01-19
# Provider version: 6.28.0
#
# 注意事項:
#   - このテンプレートは生成時点（Provider version 6.28.0）の情報です
#   - 最新の仕様は公式ドキュメントを確認してください
#   - computed only属性（arn, uri）はテンプレートから除外しています
#
# 公式ドキュメント:
#   https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/datasync_location_s3
#   https://docs.aws.amazon.com/datasync/latest/userguide/create-s3-location.html
# ================================================================================

resource "aws_datasync_location_s3" "example" {
  # ==============================================================================
  # 必須パラメータ
  # ==============================================================================

  # s3_bucket_arn - (Required) Amazon S3バケットのARN、またはAWS Outposts上のS3バケットの場合は
  # S3アクセスポイントのARNを指定します。
  # 通常のS3バケット: arn:aws:s3:::bucket-name
  # Outposts上のS3: arn:aws:s3-outposts:region:account-id:outpost/outpost-id/accesspoint/access-point-name
  # 公式ドキュメント: https://docs.aws.amazon.com/datasync/latest/userguide/API_CreateLocationS3.html
  s3_bucket_arn = "arn:aws:s3:::example-bucket"

  # subdirectory - (Required) ソースまたは宛先として使用する際のプレフィックスパス。
  # DataSyncがこのロケーションで読み取りまたは書き込みを行う際の起点となるディレクトリを指定します。
  # 注意: スラッシュ(/)で始まるプレフィックス、または//、/./、/../を含むパターンは使用できません
  # 有効な例: "example/prefix", "data/2024"
  # 無効な例: "/photos", "photos//2006/January", "photos/./2006/February"
  # 公式ドキュメント: https://docs.aws.amazon.com/datasync/latest/userguide/API_CreateLocationS3.html
  subdirectory = "/example/prefix"

  # ==============================================================================
  # オプションパラメータ
  # ==============================================================================

  # agent_arns - (Optional) AWS Outposts上のAmazon S3専用。
  # Outpost上にデプロイされたDataSyncエージェントのARNを指定します。
  # 通常のS3バケットでは不要ですが、S3 on Outpostsを使用する場合は必須です。
  # 例: ["arn:aws:datasync:us-east-1:123456789012:agent/agent-0123456789abcdef0"]
  # 公式ドキュメント: https://docs.aws.amazon.com/datasync/latest/userguide/deploy-agents.html#outposts-agent
  agent_arns = []

  # id - (Optional) リソースのID。通常は自動生成されるため、明示的な指定は不要です。
  # Terraformの管理IDとして使用され、省略するとARNが使用されます。
  # id = "arn:aws:datasync:us-east-1:123456789012:location/loc-0123456789abcdef0"

  # region - (Optional) このリソースが管理されるAWSリージョン。
  # 指定しない場合、プロバイダー設定のリージョンが使用されます。
  # クロスリージョン転送を行う場合に明示的に指定できます。
  # 公式ドキュメント: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  # s3_storage_class - (Optional) このロケーションが転送先として使用される場合に、
  # ファイルを保存する際のAmazon S3ストレージクラスを指定します。
  # 有効な値: STANDARD, REDUCED_REDUNDANCY, STANDARD_IA, ONEZONE_IA,
  #           INTELLIGENT_TIERING, GLACIER, DEEP_ARCHIVE, GLACIER_INSTANT_RETRIEVAL, OUTPOSTS
  # デフォルト: STANDARD
  # 注意: ストレージクラスによってはオーバーライト、削除、取得時に追加料金が発生する場合があります
  # 公式ドキュメント: https://docs.aws.amazon.com/datasync/latest/userguide/create-s3-location.html#using-storage-classes
  s3_storage_class = "STANDARD"

  # tags - (Optional) DataSyncロケーションに割り当てるリソースタグ（キー・バリューペア）。
  # プロバイダーのdefault_tags設定ブロックが存在する場合、一致するキーを持つタグは
  # プロバイダーレベルで定義されたタグを上書きします。
  # 公式ドキュメント: https://docs.aws.amazon.com/datasync/latest/userguide/tagging-resources.html
  tags = {
    Name        = "example-datasync-location"
    Environment = "production"
  }

  # tags_all - (Optional) プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
  # リソースに割り当てられたすべてのタグのマップ。
  # 通常はTerraformによって自動的に管理されるため、明示的な指定は不要です。
  # tags_all = {}

  # ==============================================================================
  # ネストブロック: s3_config
  # ==============================================================================

  # s3_config - (Required) S3への接続情報を含む設定ブロック。
  # DataSyncがS3バケットにアクセスするために必要なIAMロールを指定します。
  s3_config {
    # bucket_access_role_arn - (Required) S3バケットへの接続に使用するIAMロールのARN。
    # このIAMロールには、DataSyncがバケットにアクセスするための適切な権限が必要です。
    # ソースロケーションの場合: s3:GetObject, s3:GetObjectTagging, s3:ListBucket等
    # 宛先ロケーションの場合: s3:PutObject, s3:DeleteObject, s3:ListBucket等
    # 公式ドキュメント: https://docs.aws.amazon.com/datasync/latest/userguide/create-s3-location.html#create-s3-location-access
    bucket_access_role_arn = "arn:aws:iam::123456789012:role/datasync-s3-access-role"
  }
}

# ================================================================================
# 出力例（参考）
# ================================================================================
# output "datasync_location_arn" {
#   description = "DataSync S3ロケーションのARN"
#   value       = aws_datasync_location_s3.example.arn
# }
#
# output "datasync_location_uri" {
#   description = "DataSync S3ロケーションのURI"
#   value       = aws_datasync_location_s3.example.uri
# }

# ================================================================================
# 使用例
# ================================================================================
#
# 1. 基本的な使用例（S3間のデータ転送）:
#
# resource "aws_datasync_location_s3" "source" {
#   s3_bucket_arn = aws_s3_bucket.source.arn
#   subdirectory  = "/data/source"
#
#   s3_config {
#     bucket_access_role_arn = aws_iam_role.datasync_source.arn
#   }
# }
#
# resource "aws_datasync_location_s3" "destination" {
#   s3_bucket_arn    = aws_s3_bucket.destination.arn
#   subdirectory     = "/data/destination"
#   s3_storage_class = "INTELLIGENT_TIERING"
#
#   s3_config {
#     bucket_access_role_arn = aws_iam_role.datasync_destination.arn
#   }
#
#   tags = {
#     Purpose = "DataSync Destination"
#   }
# }
#
# 2. AWS Outposts上のS3バケット:
#
# resource "aws_datasync_location_s3" "outposts" {
#   agent_arns       = [aws_datasync_agent.outposts.arn]
#   s3_bucket_arn    = aws_s3_access_point.outposts.arn
#   s3_storage_class = "OUTPOSTS"
#   subdirectory     = "/outposts/data"
#
#   s3_config {
#     bucket_access_role_arn = aws_iam_role.datasync_outposts.arn
#   }
# }
#
# 3. 必要なIAMロールの例（ソースロケーション用）:
#
# resource "aws_iam_role" "datasync_source" {
#   name = "datasync-s3-source-role"
#
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Principal = {
#           Service = "datasync.amazonaws.com"
#         }
#         Action = "sts:AssumeRole"
#       }
#     ]
#   })
# }
#
# resource "aws_iam_role_policy" "datasync_source" {
#   role = aws_iam_role.datasync_source.id
#
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Action = [
#           "s3:GetBucketLocation",
#           "s3:ListBucket",
#           "s3:ListBucketMultipartUploads"
#         ]
#         Resource = aws_s3_bucket.source.arn
#       },
#       {
#         Effect = "Allow"
#         Action = [
#           "s3:GetObject",
#           "s3:GetObjectTagging",
#           "s3:GetObjectVersion",
#           "s3:GetObjectVersionTagging",
#           "s3:ListMultipartUploadParts"
#         ]
#         Resource = "${aws_s3_bucket.source.arn}/*"
#       }
#     ]
#   })
# }
#
# 4. 必要なIAMロールの例（宛先ロケーション用）:
#
# resource "aws_iam_role_policy" "datasync_destination" {
#   role = aws_iam_role.datasync_destination.id
#
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Action = [
#           "s3:GetBucketLocation",
#           "s3:ListBucket",
#           "s3:ListBucketMultipartUploads"
#         ]
#         Resource = aws_s3_bucket.destination.arn
#         Condition = {
#           StringEquals = {
#             "aws:ResourceAccount" = data.aws_caller_identity.current.account_id
#           }
#         }
#       },
#       {
#         Effect = "Allow"
#         Action = [
#           "s3:AbortMultipartUpload",
#           "s3:DeleteObject",
#           "s3:GetObject",
#           "s3:GetObjectTagging",
#           "s3:GetObjectVersion",
#           "s3:GetObjectVersionTagging",
#           "s3:ListMultipartUploadParts",
#           "s3:PutObject",
#           "s3:PutObjectTagging"
#         ]
#         Resource = "${aws_s3_bucket.destination.arn}/*"
#         Condition = {
#           StringEquals = {
#             "aws:ResourceAccount" = data.aws_caller_identity.current.account_id
#           }
#         }
#       }
#     ]
#   })
# }
# ================================================================================
