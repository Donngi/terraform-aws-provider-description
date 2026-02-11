#---------------------------------------------------------------
# AWS AppFabric App Bundle
#---------------------------------------------------------------
#
# AWS AppFabricのApp Bundleをプロビジョニングするリソースです。
# App Bundleは、SaaSアプリケーションからの監査ログ収集のための
# App AuthorizationやIngestionを格納するコンテナです。
# 各AWSアカウントはリージョンごとに1つのApp Bundleを作成できます。
#
# AWS公式ドキュメント:
#   - AppFabricの用語と概念: https://docs.aws.amazon.com/appfabric/latest/adminguide/terminology.html
#   - CreateAppBundle API: https://docs.aws.amazon.com/appfabric/latest/api/API_CreateAppBundle.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appfabric_app_bundle
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_appfabric_app_bundle" "example" {
  #-------------------------------------------------------------
  # 暗号化設定
  #-------------------------------------------------------------

  # customer_managed_key_arn (Optional)
  # 設定内容: アプリケーションデータの暗号化に使用するAWS KMSキーのARNを指定します。
  # 設定可能な値: 有効なKMSキーのARN
  # 省略時: AWS所有のキーが暗号化に使用されます。
  # 関連機能: AWS KMSによるデータ暗号化
  #   カスタマー管理キー(CMK)を使用してApp Bundle内のデータを暗号化できます。
  #   CMKを使用することで、暗号化キーのライフサイクルと権限を自身で管理できます。
  #   - https://docs.aws.amazon.com/kms/latest/developerguide/concepts.html
  customer_managed_key_arn = "arn:aws:kms:ap-northeast-1:123456789012:key/12345678-1234-1234-1234-123456789012"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1, eu-west-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 注意: AppFabricは一部のリージョンでのみ利用可能です。
  #       利用可能リージョン: us-east-1 (N. Virginia), ap-northeast-1 (Tokyo), eu-west-1 (Ireland)
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "my-appfabric-bundle"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: App BundleのAmazon Resource Name (ARN)
#
# - id: App Bundleの識別子
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
