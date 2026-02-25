#---------------------------------------------------------------
# Amazon Lightsail Bucket Access Key
#---------------------------------------------------------------
#
# Amazon LightsailバケットへのアクセスキーをプロビジョニングするリソースTFです。
# バケットアクセスキーは、Lightsailバケットへのプログラムによるアクセスを
# 可能にするアクセスキーID（ユーザー名に相当）とシークレットアクセスキー
# （パスワードに相当）のセットです。このキーを使用して、静的サイト、
# アプリケーション、またはプラグインからバケットへの読み書きアクセスを
# 許可することができます。
#
# AWS公式ドキュメント:
#   - Lightsailバケットアクセスキーの作成: https://docs.aws.amazon.com/lightsail/latest/userguide/amazon-lightsail-creating-bucket-access-keys.html
#   - バケットアクセス許可の概要: https://docs.aws.amazon.com/lightsail/latest/userguide/amazon-lightsail-understanding-bucket-permissions.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lightsail_bucket_access_key
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
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
  # 設定内容: アクセスキーを作成するLightsailバケットの名前を指定します。
  # 設定可能な値: 既存のLightsailバケット名（文字列）
  # 注意: 指定したバケットが事前に存在している必要があります。
  #      アクセスキーはバケットに対するプログラムアクセスを提供するため、
  #      バケット名は正確に一致する必要があります。
  bucket_name = "example-bucket"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用します
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - access_key_id: アクセスキーのID（ユーザー名に相当）
#
# - created_at: アクセスキーが作成された日時
#
# - id: バケット名とアクセスキーIDの組み合わせ（bucket_name,access_key_id形式）
#
# - secret_access_key: アクセスキーのシークレット（パスワードに相当）
#                     注意: この値はリソース作成時のみ取得可能です。
#                     Terraformのstateファイルに平文で保存されるため、
#                     stateファイルの取り扱いには十分注意してください。
#
# - status: アクセスキーのステータス（Active または Inactive）
#---------------------------------------------------------------
