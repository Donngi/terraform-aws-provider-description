#---------------------------------------------------------------
# Amazon Lightsail Bucket Resource Access
#---------------------------------------------------------------
#
# Amazon Lightsailバケットへのリソースアクセスを管理するリソースです。
# Lightsailインスタンスなどのリソースにバケットへのアクセス権を付与し、
# クレデンシャルなしでリソースからバケットにアクセスできるようにします。
# これにより、Lightsailリソースがバケット内のオブジェクトを読み書きできます。
#
# AWS公式ドキュメント:
#   - Lightsailバケットのリソースアクセス設定: https://docs.aws.amazon.com/lightsail/latest/userguide/amazon-lightsail-configuring-bucket-permissions.html
#   - Lightsailバケットのアクセス管理: https://docs.aws.amazon.com/lightsail/latest/userguide/amazon-lightsail-understanding-bucket-permissions.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lightsail_bucket_resource_access
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lightsail_bucket_resource_access" "example" {
  #-------------------------------------------------------------
  # バケット設定
  #-------------------------------------------------------------

  # bucket_name (Required)
  # 設定内容: アクセスを許可するLightsailバケットの名前を指定します。
  # 設定可能な値: 既存のLightsailバケット名（文字列）
  # 注意: 指定したバケットが存在している必要があります。
  bucket_name = "example-bucket"

  #-------------------------------------------------------------
  # リソース設定
  #-------------------------------------------------------------

  # resource_name (Required)
  # 設定内容: バケットへのアクセスを許可するLightsailリソースの名前を指定します。
  # 設定可能な値: 既存のLightsailリソース名（例: Lightsailインスタンス名）
  # 注意: アクセスを付与するリソース（インスタンス等）が存在している必要があります。
  resource_name = "example-instance"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用します
  # 関連機能: リージョン選択
  #   - https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: バケット名とリソース名をカンマ区切りで結合した値
#       形式: "<bucket_name>,<resource_name>"
#---------------------------------------------------------------
