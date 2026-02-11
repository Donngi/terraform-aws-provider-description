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
# - バケット名ではなく属性ベースでアクセス管理することで、大規模組織での
#   権限管理が簡素化されます
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
#   - S3でのタグ使用: https://docs.aws.amazon.com/AmazonS3/latest/userguide/tagging.html
#   - PutBucketAbac API: https://docs.aws.amazon.com/AmazonS3/latest/API/API_PutBucketAbac.html
#   - S3 Control TagResource API: https://docs.aws.amazon.com/AmazonS3/latest/API/API_control_TagResource.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_abac
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

# 前提条件: S3バケットが既に存在している必要があります
resource "aws_s3_bucket" "example" {
  bucket = "example-bucket-for-abac"

  tags = {
    Environment = "Production"
    Project     = "DataPlatform"
    Team        = "DataEngineering"
    CostCenter  = "Engineering-001"
  }
}

resource "aws_s3_bucket_abac" "example" {
  #-------------------------------------------------------------
  # バケット指定 (Required)
  #-------------------------------------------------------------

  # bucket (Required)
  # 設定内容: ABACメタデータ設定を作成する汎用バケットを指定します。
  # 設定可能な値: 既存のS3汎用バケット名
  # 注意事項:
  #   - S3 Express One Zone（ディレクトリバケット）には対応していません
  #   - Outpostsバケットには対応していません
  #   - 汎用バケットのみに適用可能です
  # 参考: https://docs.aws.amazon.com/AmazonS3/latest/userguide/buckets-tagging-enable-abac.html
  bucket = aws_s3_bucket.example.bucket

  #-------------------------------------------------------------
  # ABAC状態設定 (Required)
  #-------------------------------------------------------------

  # abac_status (Required)
  # 設定内容: ABAC状態の設定を行います。
  # 参考: https://docs.aws.amazon.com/AmazonS3/latest/API/API_PutBucketAbac.html
  abac_status {
    # status (Required)
    # 設定内容: 汎用バケットのABAC状態を指定します。
    # 設定可能な値:
    #   - "Enabled": ABACを有効化します
    #   - "Disabled": ABACを無効化します
    # デフォルト: すべてのAmazon S3汎用バケットでABACはデフォルトで無効です
    #
    # ABACを有効化した場合の影響:
    # 1. タグ管理APIの変更
    #    - PutBucketTagging/DeleteBucketTaggingが使用不可になります
    #    - TagResource/UntagResourceの使用が必須になります
    #    - 必要な権限: s3:TagResource, s3:UntagResource, s3:ListTagsForResource
    #
    # 2. タグベースのアクセス制御が有効化されます
    #    - IAMポリシーやバケットポリシーでaws:RequestTagやaws:ResourceTagなどの
    #      条件キーを使用してアクセス制御ができます
    #
    # 3. コスト配分タグとの統合
    #    - アクセス制御に使用しているのと同じタグを、S3バケットのコスト配分
    #      タグとして使用できます
    #
  # オプション設定
  #-------------------------------------------------------------

  # expected_bucket_owner (Optional, Forces new resource, Deprecated)
  # 設定内容: 予想されるバケット所有者のアカウントIDを指定します。
  # 設定可能な値: 12桁のAWSアカウントID
  # 用途: バケット所有者の検証に使用します。指定したアカウントIDが実際の
  #       バケット所有者と異なる場合、操作は失敗します。
  # 注意: このパラメータは非推奨(Deprecated)であり、変更すると新しい
  #       リソースが作成されます（Forces new resource）
  # 参考: https://docs.aws.amazon.com/AmazonS3/latest/API/API_PutBucketAbac.html
  expected_bucket_owner = null

  # region (Optional)
  # 設定内容: このリソースが管理されるリージョンを指定します。
  # 設定可能な値: AWSリージョン名（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定で指定されたリージョンがデフォルトで使用されます
  # 用途: マルチリージョン環境で特定のリージョンにリソースを配置する場合に使用します
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
#
# ABACを有効化したバケットに対して、タグベースのIAMポリシーの例:
#
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Action": [
#         "s3:GetObject",
#         "s3:PutObject"
#       ],
#       "Resource": "arn:aws:s3:::example-bucket-for-abac/*",
#       "Condition": {
#         "StringEquals": {
#           "aws:PrincipalTag/Team": "${aws:ResourceTag/Team}",
#           "aws:PrincipalTag/Project": "${aws:ResourceTag/Project}"
#         }
#       }
#     }
#   ]
# }
#
# この例では、IAMプリンシパル（ユーザーまたはロール）のタグと
# S3バケットのタグが一致する場合にのみアクセスを許可します。
#
#---------------------------------------------------------------

#---------------------------------------------------------------
#
# サービスコントロールポリシー(SCP)またはIAMポリシーで、
# バケット作成時に特定のタグを必須にする例:
#
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Deny",
#       "Action": "s3:CreateBucket",
#       "Resource": "*",
#       "Condition": {
#         "StringNotEquals": {
#           "aws:RequestTag/Environment": ["Production", "Development", "Staging"]
#         }
#       }
#     },
#     {
#       "Effect": "Deny",
#       "Action": "s3:CreateBucket",
#       "Resource": "*",
#       "Condition": {
#         "Null": {
#           "aws:RequestTag/Project": "true"
#         }
#       }
#     }
#   ]
# }
#
# この例では、EnvironmentタグとProjectタグが指定されていない場合、
# バケット作成を拒否します。
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 必要なIAM権限
#---------------------------------------------------------------
#
# ABACを管理するために必要な権限:
# - s3:PutBucketAbac: ABAC状態を更新する権限
# - s3:GetBucketAbac: ABAC状態を確認する権限
#
# ABAC有効化後のタグ管理に必要な権限:
# - s3:TagResource: バケットにタグを追加する権限
# - s3:UntagResource: バケットからタグを削除する権限
# - s3:ListTagsForResource: バケットのタグを一覧表示する権限
#
# IAMポリシー例:
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Action": [
#         "s3:PutBucketAbac",
#         "s3:GetBucketAbac"
#       ],
#       "Resource": "arn:aws:s3:::example-bucket-for-abac"
#     },
#     {
#       "Effect": "Allow",
#       "Action": [
#         "s3:TagResource",
#         "s3:UntagResource",
#         "s3:ListTagsForResource"
#       ],
#       "Resource": "arn:aws:s3:::example-bucket-for-abac"
#     }
#   ]
# }
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 関連リソース
#---------------------------------------------------------------
#
# - aws_s3_bucket: S3汎用バケットを作成します（ABACの前提条件）
#   https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
#
# - aws_iam_policy: ABACを利用したタグベースのIAMポリシーを作成します
#   https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy
#
# - aws_s3_bucket_policy: ABACを利用したタグベースのバケットポリシーを作成します
#   https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# トラブルシューティング
#---------------------------------------------------------------
#
# 問題: ABACを有効化した後、タグの追加/削除ができなくなった
# 解決策: PutBucketTagging/DeleteBucketTagging APIから
#         TagResource/UntagResource APIに切り替えてください。
#         また、必要なIAM権限（s3:TagResource, s3:UntagResource）を
#         付与してください。
#
# 問題: ABACを有効化した後、意図しないアクセス拒否が発生する
# 解決策: 既存のタグベースの条件を使用しているIAMポリシーや
#         バケットポリシーを監査し、タグが正しく設定されているか
#         確認してください。aws:PrincipalTag と aws:ResourceTag の
#         整合性を確認してください。
#
# 問題: Terraform プロバイダーがタグ操作でエラーを返す
# 解決策: ABACを有効化する前に、aws_s3_bucketリソースでdefault_tagsを
#         使用している場合は、プロバイダー設定でTerraformが自動的に
#         TagResource APIを使用するように設定されていることを確認してください。
#         AWS Provider 5.0以降では、S3 Control APIが自動的に使用されます。
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは標準的な読み取り専用属性をエクスポートしますが、
# 公式ドキュメントに明示的なattributes referenceの記載はありません。
#
# 一般的に利用可能な属性:
# - id: リソースの識別子（通常はバケット名）
#
# ABACの状態を確認するには、AWS CLIまたはSDKを使用してください:
# aws s3api get-bucket-abac --bucket example-bucket-for-abac --region us-east-1
#---------------------------------------------------------------
