#---------------------------------------------------------------
# Amazon Redshift Authentication Profile
#---------------------------------------------------------------
#
# Amazon Redshiftの認証プロファイルをプロビジョニングするリソースです。
# 認証プロファイルはJDBC/ODBC/Python接続文字列の設定オプションを
# JSON形式でまとめて管理する機能で、多数の接続を効率的に管理できます。
# 作成されたプロファイルは接続文字列のAuthProfileパラメータで参照できます。
#
# AWS公式ドキュメント:
#   - 認証プロファイルの概要: https://docs.aws.amazon.com/redshift/latest/mgmt/connecting-with-authentication-profiles.html
#   - 認証プロファイルの作成: https://docs.aws.amazon.com/redshift/latest/mgmt/connecting-with-authentication-profiles-creating.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/redshift_authentication_profile
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_redshift_authentication_profile" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # authentication_profile_name (Required, Forces new resource)
  # 設定内容: 認証プロファイルの名前を指定します。
  # 設定可能な値: nullまたは空文字列以外の文字列
  # 注意: 1アカウントあたり最大10個の認証プロファイルを作成できます。
  authentication_profile_name = "example"

  # authentication_profile_content (Required)
  # 設定内容: 認証プロファイルの設定内容をJSON形式の文字列で指定します。
  # 設定可能な値: 有効なJSON文字列。文字列の最大長はアカウントのクォータによって決まります。
  # 注意: AccessKeyIDやSecretAccessKeyなどの機密情報は格納できません。
  #       機密情報を含むキーと値を格納しようとするとエラーが発生します。
  # 参考: https://docs.aws.amazon.com/redshift/latest/mgmt/connecting-with-authentication-profiles-creating.html
  authentication_profile_content = jsonencode({
    AllowDBUserOverride = "1"
    Client_ID           = "ExampleClientID"
    App_ID              = "example"
  })

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
# - id: 認証プロファイルの名前（authentication_profile_nameと同値）
#---------------------------------------------------------------
