#------------------------------------------------------------------------------------
# AWS CloudFront Origin Access Identity (OAI)
#------------------------------------------------------------------------------------
# 用途:
#   CloudFrontディストリビューションがS3バケットのコンテンツに安全にアクセスするための
#   特別なCloudFrontユーザーアイデンティティを作成します。
#   OAIを使用することで、S3バケットへの直接アクセスを制限し、CloudFront経由のみでの
#   アクセスを強制することができます。
#
# 主な用途:
#   - S3バケットの静的コンテンツをCloudFront経由で配信する際のアクセス制御
#   - S3バケットポリシーでOAIに対してのみ読み取り権限を付与
#   - S3バケットへの直接アクセスを防止し、CloudFront URLのみでのアクセスを実現
#
# 注意事項:
#   - OAI (Origin Access Identity) は従来の機能であり、新規実装では
#     OAC (Origin Access Control) の使用が推奨されています
#   - OACは全てのAWSリージョンのS3バケット、SSE-KMS暗号化、動的リクエストをサポート
#   - OAIは主に中国リージョンなどOACが利用できない環境で使用されます
#   - 作成後、S3バケットポリシーでこのOAIに対する権限を明示的に付与する必要があります
#
# Generated: 2026-02-12
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/cloudfront_origin_access_identity
# Terraform AWS Provider Version: 6.28.0
# NOTE: OAIは従来の機能です。新規実装ではOrigin Access Control (OAC)の使用が推奨されます
#------------------------------------------------------------------------------------

resource "aws_cloudfront_origin_access_identity" "example" {
  #-----------------------------------------------------------------------
  # 識別情報
  #-----------------------------------------------------------------------
  # 設定内容: Origin Access Identityの説明コメント
  # 設定可能な値: 任意の文字列（最大128文字）
  # 省略時: 空文字列が設定されます
  # 用途:
  #   - OAIの目的や用途を記述し、管理を容易にします
  #   - 複数のOAIを使用する場合、それぞれを識別するために有用です
  #   - S3バケット名や配信コンテンツの種類などを記述すると管理しやすくなります
  comment = "OAI for example-bucket static content distribution"

  #-----------------------------------------------------------------------
  # タグ設定
  #-----------------------------------------------------------------------
  # CloudFront Origin Access Identityはタグをサポートしていません
}

#------------------------------------------------------------------------------------
# Attributes Reference (参照可能な属性)
#------------------------------------------------------------------------------------
# このリソースの作成後、以下の属性を参照できます:
#
# arn - Origin Access IdentityのARN
# caller_reference - 自動生成される一意の参照値
# cloudfront_access_identity_path - CloudFrontがS3アクセスに使用するパス形式ID
# etag - リソースの現在バージョンを表すETag値
# iam_arn - S3バケットポリシーのPrincipalとして使用するIAM ARN形式
# id - Origin Access IdentityのID
# s3_canonical_user_id - S3バケットACLで使用可能な正規ユーザーID
