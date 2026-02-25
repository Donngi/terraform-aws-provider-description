#-----------------------------------------------------------------------
# AWS Provider: aws_ssoadmin_application_assignment_configuration
#
# Provider Version: 6.28.0
# Generated:       2026-02-19
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_application_assignment_configuration
#
# NOTE: このファイルはリファレンス用テンプレートです。
#       実際の環境に合わせて値を変更してください。
#-----------------------------------------------------------------------

resource "aws_ssoadmin_application_assignment_configuration" "example" {

  #-----------------------------------------------------------------------
  # アプリケーション設定
  #-----------------------------------------------------------------------

  # 設定内容: アサイン設定を適用するアプリケーションのARN
  # 設定可能な値: SSO アプリケーションの有効なARN文字列
  application_arn = "arn:aws:sso::123456789012:application/ssoins-0123456789abcdef/apl-0123456789abcdef"

  # 設定内容: アプリケーションへのアクセスにユーザーまたはグループへの割り当てを必須とするかどうか
  # 設定可能な値: true（割り当て必須）/ false（割り当て不要）
  # 省略時: 変更なし（既存の設定を保持）
  assignment_required = true

  #-----------------------------------------------------------------------
  # リージョン設定
  #-----------------------------------------------------------------------

  # 設定内容: リソースを管理するAWSリージョン
  # 設定可能な値: 有効なAWSリージョンコード（例: "us-east-1", "ap-northeast-1"）
  # 省略時: プロバイダー設定のリージョンを使用
  region = "ap-northeast-1"

}

#-----------------------------------------------------------------------
# Attributes Reference
#
# id - (非推奨) アプリケーションのARN
#-----------------------------------------------------------------------
