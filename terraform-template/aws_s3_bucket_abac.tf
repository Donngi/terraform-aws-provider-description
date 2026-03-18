#---------------------------------------------------------------
# AWS S3 Bucket ABAC (Attribute Based Access Control)
#---------------------------------------------------------------
#
# Amazon S3汎用バケットに対してABAC（Attribute Based Access Control：
# 属性ベースのアクセス制御）を管理するリソースです。
#
# ABACとは:
# タグなどの属性に基づいてアクセス許可を定義する認可戦略です。
# デフォルトではすべてのS3汎用バケットでABACは無効になっています。
#
# ABACを有効にすることで:
# - バケットにタグを付与し、タグベースのIAMポリシーやバケットポリシーで
#   アクセス制御を管理できます
# - プロジェクト、チーム、コストセンター、データ分類などの属性に基づいて
#   アクセスを許可/拒否できます
#
# 重要な注意事項:
# ABACを有効にした後、バケットのタグ管理に使用するAPIが変更されます:
# - 使用不可: PutBucketTagging, DeleteBucketTagging
# - 使用必須: TagResource, UntagResource, ListTagsForResource
# これらのS3 Control APIを使用するには、適切なIAM権限
# (s3:TagResource, s3:UntagResource, s3:ListTagsForResource)が必要です。
#
# AWS公式ドキュメント:
#   - ABAC有効化: https://docs.aws.amazon.com/AmazonS3/latest/userguide/buckets-tagging-enable-abac.html
#   - PutBucketAbac API: https://docs.aws.amazon.com/AmazonS3/latest/API/API_PutBucketAbac.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_abac
#
# Provider Version: 6.36.0
# Generated: 2026-03-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_s3_bucket_abac" "example" {
  #-------------------------------------------------------------
  # バケット指定
  #-------------------------------------------------------------

  # bucket (Required)
  # 設定内容: ABACメタデータ設定を作成する汎用バケットを指定します。
  # 設定可能な値: 既存のS3汎用バケット名
  # 注意: S3 Express One Zone（ディレクトリバケット）やOutpostsバケットには対応していません
  bucket = "my-example-bucket"

  #-------------------------------------------------------------
  # ABAC状態設定
  #-------------------------------------------------------------

  # abac_status (Optional)
  # 設定内容: バケットのABAC状態を設定するブロックです。
  abac_status {
    # status (Required)
    # 設定内容: 汎用バケットのABAC状態を指定します。
    # 設定可能な値:
    #   - "Enabled" : ABACを有効化する
    #   - "Disabled": ABACを無効化する
    # 省略時: すべてのAmazon S3汎用バケットでABACはデフォルトで無効です
    #
    # ABACを有効化した場合の影響:
    # - PutBucketTagging/DeleteBucketTaggingが使用不可になります
    # - TagResource/UntagResourceの使用が必須になります
    # - 必要な権限: s3:TagResource, s3:UntagResource, s3:ListTagsForResource
    # - IAMポリシーでaws:RequestTagやaws:ResourceTag等の条件キーによる
    #   タグベースのアクセス制御が有効になります
    status = "Enabled"
  }

  #-------------------------------------------------------------
  # オプション設定
  #-------------------------------------------------------------

  # expected_bucket_owner (Optional, Deprecated)
  # 設定内容: 予想されるバケット所有者のアカウントIDを指定します。
  # 設定可能な値: 12桁のAWSアカウントID
  # 省略時: バケット所有者の検証を行いません
  # 注意: このパラメータは非推奨(Deprecated)です
  expected_bucket_owner = null

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: リソースの識別子（バケット名）
#---------------------------------------------------------------
