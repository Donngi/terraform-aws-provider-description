#---------------------------------------------------------------
# Amazon S3 Access Grants Location
#---------------------------------------------------------------
#
# S3 Access Grantsロケーションを管理するリソースです。
# ロケーションは、権限付与対象となるS3リソース（バケットまたはプレフィックス）を表します。
# S3データは、S3 Access Grantsインスタンスと同じリージョンに存在する必要があります。
# ロケーションを登録する際は、登録するS3ロケーションを管理する権限を持つ
# IAMロールを含める必要があります。
#
# AWS公式ドキュメント:
#   - S3 Access Grants概要: https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-grants.html
#   - ロケーションの登録: https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-grants-location.html
#   - CreateAccessGrantsLocation API: https://docs.aws.amazon.com/AmazonS3/latest/API/API_control_CreateAccessGrantsLocation.html
#   - 必要なIAM権限: https://docs.aws.amazon.com/AmazonS3/latest/userguide/using-with-s3-policy-actions.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3control_access_grants_location
#
# Provider Version: 6.28.0
# Generated: 2026-02-03
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_s3control_access_grants_location" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # iam_role_arn (Required)
  # 設定内容: S3 Access Grantsがロケーションへのランタイムアクセス要求を
  #          満たす際に使用するIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  # 重要: このロールには以下の要件があります
  #   - S3バケットへのアクセス権限（s3:GetObject、s3:PutObjectなど）
  #   - S3 Access Grantsサービスプリンシパルからの引き受け（AssumeRole）を許可する信頼ポリシー
  # 関連機能: IAM Role for S3 Access Grants
  #   ロケーションにマッピングされたIAMロールは、S3 Access Grantsが
  #   一時的な認証情報を付与者に提供する際に引き受けられます。
  #   信頼ポリシー例:
  #   {
  #     "Version": "2012-10-17",
  #     "Statement": [{
  #       "Effect": "Allow",
  #       "Principal": {
  #         "Service": "access-grants.s3.amazonaws.com"
  #       },
  #       "Action": "sts:AssumeRole"
  #     }]
  #   }
  #   - https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-grants-location.html
  #   - https://docs.aws.amazon.com/singlesignon/latest/userguide/tip-tutorial-s3.html
  iam_role_arn = "arn:aws:iam::123456789012:role/S3AccessGrantsRole"

  # location_scope (Required)
  # 設定内容: デフォルトのS3 URI "s3://"、またはカスタムロケーション
  #          （特定のバケットまたはプレフィックス）へのURIを指定します。
  # 設定可能な値:
  #   - "s3://": すべてのS3リソースへのアクセスを表すデフォルトスコープ
  #   - "s3://bucket-name/": 特定のバケット
  #   - "s3://bucket-name/prefix/": バケット内の特定のプレフィックス
  # 重要: デフォルトスコープ "s3://" を使用する場合、グラント作成時に
  #      Subprefixフィールドでスコープを絞り込む必要があります。
  # アカウント・リージョン設定
  #-------------------------------------------------------------

  # account_id (Optional)
  # 設定内容: S3 Access Grantsロケーション用のAWSアカウントIDを指定します。
  # 設定可能な値: 有効なAWSアカウントID（12桁の数字）
  # 省略時: Terraform AWSプロバイダーで自動判別されたアカウントIDを使用
  # 注意: マルチアカウント環境で特定のアカウントを明示的に指定する場合に使用
  account_id = null

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 重要: S3バケットとS3 Access Grantsインスタンスは同じリージョンに存在する必要があります
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 依存関係
  #-------------------------------------------------------------
  # 注意: このリソースを作成する前に、以下のリソースが必要です
  #   1. aws_s3control_access_grants_instance: S3 Access Grantsインスタンス
  #   2. IAMロール: iam_role_arnで指定するロール
  #   3. S3バケット: location_scopeで指定するバケット（バケット指定の場合）
  #
  # 推奨される依存関係の設定例:
  # depends_on = [
  #   aws_s3control_access_grants_instance.example,
  #   aws_iam_role.s3_access_grants_role,
  # ]
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - access_grants_location_arn: S3 Access GrantsロケーションのAmazon Resource Name (ARN)
#   形式: arn:aws:s3:region:account-id:access-grants/instance-id/location/location-id
#
# - access_grants_location_id: S3 Access Grantsロケーションの一意なID

#---------------------------------------------------------------
# 以下は、S3 Access Grantsの完全な構成例です。
# この例では、インスタンス、ロケーション、IAMロールを含みます。
#
# # S3 Access Grantsインスタンス
# resource "aws_s3control_access_grants_instance" "example" {
#   # インスタンスの作成（追加設定は不要）
# }
#
# # IAMロール（S3 Access Grants用）
# resource "aws_iam_role" "s3_access_grants" {
#   name = "S3AccessGrantsRole"
#
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#---------------------------------------------------------------
