#---------------------------------------------------------------
# AWS SSO Admin Application Access Scope
#---------------------------------------------------------------
#
# AWS SSO Admin アプリケーションアクセススコープをプロビジョニングするリソースです。
# IAM Identity Center（旧 AWS SSO）のアプリケーションに対して、
# アクセススコープと認可ターゲットの関連付けを管理します。
#
# AWS公式ドキュメント:
#   - IAM Identity Center概要: https://docs.aws.amazon.com/singlesignon/latest/userguide/what-is.html
#   - アプリケーション割り当て: https://docs.aws.amazon.com/singlesignon/latest/userguide/assignuserstoapp.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_application_access_scope
#
# Provider Version: 6.28.0
# Generated: 2026-02-09
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ssoadmin_application_access_scope" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # application_arn (Required)
  # 設定内容: アクセススコープを追加または更新するアプリケーションのARNを指定します。
  # 設定可能な値: 有効なIAM Identity Centerアプリケーション ARN
  # 注意: aws_ssoadmin_applicationリソースの出力値を参照するのが一般的です
  application_arn = aws_ssoadmin_application.example.arn

  # scope (Required)
  # 設定内容: 指定されたターゲットに関連付けるアクセススコープの名前を指定します。
  # 設定可能な値: アクセススコープ名の文字列
  # 例:
  #   - "sso:account:access": アカウントアクセス用スコープ
  # 関連機能: IAM Identity Center アクセススコープ
  #   アプリケーションが利用可能なアクセスの範囲を定義します。
  #   - https://docs.aws.amazon.com/singlesignon/latest/userguide/what-is.html
  scope = "sso:account:access"

  #-------------------------------------------------------------
  # オプション設定
  #-------------------------------------------------------------

  # authorized_targets (Optional)
  # 設定内容: このアクセススコープの認可ターゲットを表すARNの配列リストを指定します。
  # 設定可能な値: IAM Identity Centerアプリケーション ARN のリスト
  # 省略時: ターゲットなし
  # 注意: 認可ターゲットは、このアクセススコープによってアクセスが許可される
  #       アプリケーションを指定します
  authorized_targets = [
    "arn:aws:sso::123456789012:application/ssoins-123456789012/apl-123456789012",
  ]

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: application_arnとscopeをカンマで連結した文字列
#---------------------------------------------------------------
