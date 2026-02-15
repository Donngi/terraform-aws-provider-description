#---------------------------------------
# Amazon DataZone Environment Profile
#---------------------------------------
# Provider Version: 6.28.0
# Generated: 2026-02-14
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/datazone_environment_profile
#
# NOTE: Amazon DataZoneの環境プロファイルを定義するリソース。
# 環境プロファイルは、DataZoneプロジェクト内で環境を作成する際のテンプレートとして機能し、
# 特定のAWSアカウントとリージョンにおける環境ブループリントの設定を管理します。

#-------
# 注意事項
#-------
# - environment_blueprint_identifierは作成後の変更不可（再作成が必要）
# - domain_identifierおよびproject_identifierは作成後の変更不可
# - aws_account_regionは環境がデプロイされるリージョンを指定（プロバイダーのリージョンとは独立）
# - user_parametersは環境ブループリントで定義されたパラメータに対応する必要あり

#-------
# 基本設定
#-------
resource "aws_datazone_environment_profile" "example" {
  # 設定内容: 環境プロファイル名
  # 省略時: 省略不可（必須パラメータ）
  name = "example-environment-profile"

  # 設定内容: 環境プロファイルの説明
  # 省略時: 説明なし
  description = "Example environment profile for DataZone project"

  # 設定内容: DataZoneドメインの識別子
  # 省略時: 省略不可（必須パラメータ）
  domain_identifier = "dzd_example123456"

  # 設定内容: プロジェクトの識別子
  # 省略時: 省略不可（必須パラメータ）
  project_identifier = "example-project-id"

  #-------
  # 環境ブループリント設定
  #-------

  # 設定内容: 環境ブループリントの識別子
  # 省略時: 省略不可（必須パラメータ）
  environment_blueprint_identifier = "dzb_example123456"

  #-------
  # デプロイメント設定
  #-------

  # 設定内容: 環境をデプロイするAWSアカウントID
  # 省略時: 現在のアカウントIDが使用される
  aws_account_id = "123456789012"

  # 設定内容: 環境をデプロイするAWSリージョン
  # 省略時: 省略不可（必須パラメータ）
  aws_account_region = "us-east-1"

  #-------
  # ユーザーパラメータ設定
  #-------
  # ブループリントで定義されたパラメータに対する値を設定

  user_parameters {
    # 設定内容: パラメータ名
    # 省略時: パラメータ名なし
    name = "vpc_id"

    # 設定内容: パラメータ値
    # 省略時: パラメータ値なし
    value = "vpc-0123456789abcdef0"
  }

  user_parameters {
    name  = "subnet_ids"
    value = "subnet-0123456789abcdef0,subnet-0123456789abcdef1"
  }

  #-------
  # リージョン設定
  #-------

  # 設定内容: リソースが管理されるリージョン（プロバイダー設定とは独立）
  # 省略時: プロバイダー設定のリージョンが使用される
  region = "us-west-2"
}

#---------------------------------------
# Attributes Reference（参照可能な属性）
#---------------------------------------
# このリソースから参照可能な属性：
#
# - id: 環境プロファイルの一意識別子
# - created_at: 環境プロファイルの作成日時（RFC3339形式）
# - created_by: 環境プロファイルを作成したユーザー
# - updated_at: 環境プロファイルの最終更新日時（RFC3339形式）
#
# 出力例:
# output "environment_profile_id" {
#   value = aws_datazone_environment_profile.example.id
# }
