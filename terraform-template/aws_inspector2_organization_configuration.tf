#---------------------------------------------------------------
# AWS Inspector2 Organization Configuration
#---------------------------------------------------------------
#
# Amazon Inspector V2のOrganization（組織）設定を管理するリソースです。
# Organizations管理者アカウントで、メンバーアカウント追加時に
# 自動的にInspectorスキャンを有効化するかどうかを制御します。
# このリソースはOrganizationsの委任管理者アカウントで作成する必要があります。
#
# AWS公式ドキュメント:
#   - Inspector2 組織設定: https://docs.aws.amazon.com/inspector/latest/user/getting_started_tutorial.html
#   - UpdateOrganizationConfiguration API: https://docs.aws.amazon.com/inspector/v2/APIReference/API_UpdateOrganizationConfiguration.html
#   - Organizations統合: https://docs.aws.amazon.com/inspector/latest/user/integrations-aws-organizations.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/inspector2_organization_configuration
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_inspector2_organization_configuration" "example" {
  #-------------------------------------------------------------
  # 自動有効化設定
  #-------------------------------------------------------------

  auto_enable {
    # ec2 (Required)
    # 設定内容: 新規メンバーアカウント追加時にEC2インスタンスのスキャンを自動有効化するかを指定します。
    # 設定可能な値: true / false
    ec2 = true

    # ecr (Required)
    # 設定内容: 新規メンバーアカウント追加時にECRコンテナイメージのスキャンを自動有効化するかを指定します。
    # 設定可能な値: true / false
    ecr = true

    # lambda (Optional)
    # 設定内容: 新規メンバーアカウント追加時にLambda関数のスキャンを自動有効化するかを指定します。
    # 設定可能な値: true / false
    # 省略時: 自動有効化しない（false相当）
    lambda = false

    # lambda_code (Optional)
    # 設定内容: 新規メンバーアカウント追加時にLambda関数のカスタムコードスキャンを自動有効化するかを指定します。
    # 設定可能な値: true / false
    #   - lambdaがtrueの場合のみ有効になります
    # 省略時: 自動有効化しない（false相当）
    lambda_code = false

    # code_repository (Optional)
    # 設定内容: 新規メンバーアカウント追加時にコードリポジトリのスキャンを自動有効化するかを指定します。
    # 設定可能な値: true / false
    # 省略時: 自動有効化しない（false相当）
    code_repository = false
  }

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: Goのtime.Duration形式の文字列（例: "30m", "1h"）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    create = null

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: Goのtime.Duration形式の文字列（例: "30m", "1h"）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    delete = null

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウト時間を指定します。
    # 設定可能な値: Goのtime.Duration形式の文字列（例: "30m", "1h"）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    update = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: リソースのID（Terraform内部で使用される識別子）。
# - max_account_limit_reached: Organizationのメンバーアカウント数が自動有効化の上限に
#   達しているかどうかを示すブール値。
#---------------------------------------------------------------
