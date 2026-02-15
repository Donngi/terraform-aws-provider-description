#-----------------------------------------------------------------------
# CloudFront Origin Access Control
#-----------------------------------------------------------------------
#
# CloudFrontのOrigin Access Control（OAC）を作成します。
# OACを使用することで、S3バケット、MediaStore、MediaPackage v2、Lambda関数URLなどの
# オリジンへのアクセスをCloudFrontディストリビューションのみに制限できます。
#
# OACは従来のOrigin Access Identity（OAI）の後継機能で、以下の利点があります：
# - すべてのAWSリージョンのS3バケットをサポート
# - AWS KMSによるS3サーバー側暗号化に対応
# - S3への動的リクエスト（PUT/POST/DELETE）をサポート
# - Lambda関数URL、MediaStore、MediaPackage v2オリジンに対応
# - AWS Signature Version 4（SigV4）を使用した署名による安全な認証
#
# AWS公式ドキュメント:
#   - Origin Access Control設定: https://docs.aws.amazon.com/cloudfront/latest/APIReference/API_OriginAccessControlConfig.html
#   - S3オリジンへのアクセス制限: https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/private-content-restricting-access-to-s3.html
#   - Lambda関数URLへのアクセス制限: https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/private-content-restricting-access-to-lambda.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_access_control
#
# Provider Version: 6.28.0
# Generated: 2026-02-12
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       最新の公式ドキュメントを必ず確認してください。

#-----------------------------------------------------------------------
# 基本設定
#-----------------------------------------------------------------------

resource "aws_cloudfront_origin_access_control" "example" {
  # 設定内容: Origin Access Controlの名前
  # 設定可能な値: 最大64文字の文字列
  # 必須: はい
  # 用途: OACを識別するための一意の名前です。CloudFrontディストリビューションの
  #       オリジン設定でこの名前を参照します。
  name = "example-oac"

  # 設定内容: Origin Access Controlの説明
  # 省略時: 説明なし
  # 用途: OACの目的や用途を記述します。管理を容易にするための任意の説明文です。
  description = "Origin Access Control for S3 bucket"

  #-----------------------------------------------------------------------
  # オリジンタイプ設定
  #-----------------------------------------------------------------------

  # 設定内容: このOACが対象とするオリジンのタイプ
  # 設定可能な値:
  #   - s3: Amazon S3バケット
  #   - mediastore: AWS Elemental MediaStore
  #   - mediapackagev2: AWS Elemental MediaPackage v2
  #   - lambda: AWS Lambda関数URL
  # 必須: はい
  # 用途: OACを適用するオリジンサービスの種類を指定します。
  #       オリジンタイプに応じて適切なIAMポリシーの設定が必要です。
  origin_access_control_origin_type = "s3"

  #-----------------------------------------------------------------------
  # 署名設定
  #-----------------------------------------------------------------------

  # 設定内容: CloudFrontがオリジンリクエストに署名を行うかどうかの動作
  # 設定可能な値:
  #   - always: 常にオリジンリクエストに署名する（推奨）
  #   - never: オリジンリクエストに署名しない（オリジンが公開アクセス可能な場合のみ）
  #   - no-override: ビューワーからのAuthorizationヘッダーを上書きしない
  # 必須: はい
  # 用途: オリジンへのリクエストに対する署名動作を制御します。
  #       alwaysを指定すると、CloudFrontがSigV4署名を使用してオリジンに認証されたリクエストを送信します。
  #       no-overrideを使用する場合は、キャッシュポリシーにAuthorizationヘッダーを追加する必要があります。
  signing_behavior = "always"

  # 設定内容: オリジンリクエストの署名プロトコル
  # 設定可能な値: sigv4（AWS Signature Version 4のみサポート）
  # 必須: はい
  # 用途: CloudFrontがオリジンリクエストに署名する際に使用するプロトコルを指定します。
  #       現在はSigV4のみがサポートされています。
  signing_protocol = "sigv4"
}

#-----------------------------------------------------------------------
# Attributes Reference
#-----------------------------------------------------------------------
# このリソースは以下の属性をエクスポートします：
#
# - arn: Origin Access ControlのARN
#   形式: arn:aws:cloudfront::123456789012:origin-access-control/ABCDEFG1234567
#   用途: IAMポリシーやCloudFormationテンプレートでOACを参照する際に使用
#
# - id: Origin Access Controlの一意の識別子
#   用途: CloudFrontディストリビューションのオリジン設定でOACを参照する際に使用
#
# - etag: Origin Access Controlの現在のバージョンを表すETag
#   用途: 更新時の競合検出や条件付きリクエストに使用
