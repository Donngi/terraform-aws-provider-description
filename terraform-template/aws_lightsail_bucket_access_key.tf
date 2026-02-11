#---------------------------------------------------------------
# AWS Lightsail Bucket Access Key
#---------------------------------------------------------------
#
# Amazon Lightsailバケットのアクセスキーを管理するリソースです。
# アクセスキーは、アクセスキーIDとシークレットアクセスキーで構成され、
# AWS APIやSDKを介してLightsailバケットおよびそのオブジェクトへの
# フルアクセス（読み書き）をプログラムから行うための認証情報を提供します。
#
# 各バケットには最大2つのアクセスキーを作成できますが、
# 一度に1つのみ作成し、定期的にローテーションすることが推奨されています。
# シークレットアクセスキーは作成時にのみ表示され、後から取得できないため、
# 安全な場所に保管してください。
#
# AWS公式ドキュメント:
#   - バケットアクセスキーの作成: https://docs.aws.amazon.com/lightsail/latest/userguide/amazon-lightsail-creating-bucket-access-keys.html
#   - バケットのアクセス制御: https://docs.aws.amazon.com/lightsail/latest/userguide/amazon-lightsail-understanding-bucket-permissions.html
#   - CreateBucketAccessKey API: https://docs.aws.amazon.com/lightsail/2016-11-28/api-reference/API_CreateBucketAccessKey.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lightsail_bucket_access_key
#
# Provider Version: 6.28.0
# Generated: 2026-02-09
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lightsail_bucket_access_key" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # bucket_name (Required)
  # 設定内容: アクセスキーが属し、アクセスを許可するバケットの名前を指定します。
  # 設定可能な値: 既存のLightsailバケットの名前（文字列）
  # 注意: アクセスキーは指定したバケットとそのオブジェクトに対して
  #       フルアクセス（読み書き）権限を持ちます。
  #       各バケットには最大2つのアクセスキーを作成できます。
  # 関連リソース: aws_lightsail_bucket
  #   Lightsailバケットリソースで作成したバケットの名前またはIDを参照できます。
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lightsail_bucket
  bucket_name = aws_lightsail_bucket.example.id

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

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
# - access_key_id: アクセスキーID。
#     AWS APIやSDKでバケットにアクセスする際の認証に使用します。
#
# - created_at: アクセスキーが作成された日時。
#
# - id: bucket_nameとaccess_key_idをカンマ(,)で結合した一意のID。
#     形式: "bucket_name,access_key_id"
#
# - secret_access_key: リクエストの署名に使用するシークレットアクセスキー。
#     この属性はインポートされたリソースでは利用できません。
#     注意: この値はTerraformのステートファイルに書き込まれます。
#     シークレットアクセスキーは作成時にのみ取得可能で、
#     紛失した場合は新しいアクセスキーを作成する必要があります。
#
# - status: アクセスキーのステータス。
#     アクセスキーが有効かどうかを示します。
#---------------------------------------------------------------
