#---------------------------------------------------------------
# aws_s3control_access_grants_location
#
# S3 Access Grantsのロケーションリソース
# ロケーションはパーミッショングラントで指定するS3リソース（バケットまたはプレフィックス）
# S3データはS3 Access Grantsインスタンスと同じリージョンに存在する必要がある
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3control_access_grants_location
#
# NOTE: このファイルはリファレンス用テンプレートです。
#       実際の利用時は不要な設定を削除し、値を適切に変更してください。
#---------------------------------------------------------------

resource "aws_s3control_access_grants_location" "example" {

  #---------------------------------------------------------------
  # ロケーション設定
  #---------------------------------------------------------------

  # 設定内容: S3 Access Grantsがランタイムアクセスリクエストを処理する際に使用するIAMロールのARN
  # 設定可能な値: 有効なIAMロールのARN文字列
  # 省略時: 必須項目のため省略不可
  iam_role_arn = "arn:aws:iam::123456789012:role/example-role"

  # 設定内容: ロケーションのスコープ（デフォルトS3 URIまたはカスタムロケーションのURI）
  # 設定可能な値: "s3://" (全バケット), "s3://bucket-name", "s3://bucket-name/prefix/"
  # 省略時: 必須項目のため省略不可
  location_scope = "s3://"

  #---------------------------------------------------------------
  # アカウント・リージョン設定
  #---------------------------------------------------------------

  # 設定内容: S3 Access GrantsロケーションのAWSアカウントID
  # 設定可能な値: 12桁のAWSアカウントID
  # 省略時: Terraform AWSプロバイダーのアカウントIDが自動的に使用される
  account_id = "123456789012"

  # 設定内容: このリソースを管理するリージョン
  # 設定可能な値: 有効なAWSリージョンコード（例: "us-east-1", "ap-northeast-1"）
  # 省略時: プロバイダー設定のリージョンが使用される
  region = "ap-northeast-1"

  #---------------------------------------------------------------
  # タグ設定
  #---------------------------------------------------------------

  # 設定内容: リソースに付与するタグのキーと値のマップ
  # 設定可能な値: 任意のキーと値の文字列マップ
  # 省略時: タグなし
  tags = {
    Name        = "example-access-grants-location"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference
#
# access_grants_location_arn - S3 Access GrantsロケーションのARN
# access_grants_location_id  - S3 Access GrantsロケーションのユニークID
# tags_all                   - プロバイダーのdefault_tagsを含む全タグのマップ
# id                         - リソースID（account_id:access_grants_location_id形式）
#---------------------------------------------------------------
