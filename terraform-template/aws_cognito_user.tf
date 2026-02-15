# Terraform AWS Cognito User Resource Template
# リソース: aws_cognito_user
# Provider Version: 6.28.0
# 最終更新: 2026-02-13
# Generated: 2026-02-13
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/cognito_user
# NOTE: このファイルの用途 - Amazon Cognito User Poolに新しいユーザーを作成するためのTerraformテンプレート

#---------------------------------------
# Cognito User
#---------------------------------------
resource "aws_cognito_user" "example" {
  #---------------------------------------
  # 必須パラメータ
  #---------------------------------------

  # 設定内容: ユーザーが属するCognito User PoolのID
  # 設定可能な値: 有効なCognito User PoolのリソースIDまたは文字列ID
  # 省略時: エラー (必須パラメータ)
  user_pool_id = "us-east-1_XXXXXXXXX"

  # 設定内容: 作成するユーザーのユーザー名
  # 設定可能な値: User Poolの設定に応じた有効なユーザー名 (大文字小文字を区別)
  # 省略時: エラー (必須パラメータ)
  username = "example-user"

  #---------------------------------------
  # ユーザー属性
  #---------------------------------------

  # 設定内容: ユーザーのカスタム属性や標準属性の値
  # 設定可能な値: 属性名と値のマップ (例: email, phone_number, custom:attribute_name)
  # 省略時: 属性は設定されない
  attributes = {
    email          = "user@example.com"
    email_verified = "true"
    # phone_number          = "+819012345678"
    # phone_number_verified = "true"
    # custom:department     = "Engineering"
  }

  #---------------------------------------
  # パスワード設定
  #---------------------------------------

  # 設定内容: ユーザーの永続パスワード
  # 設定可能な値: User Poolのパスワードポリシーに準拠したパスワード文字列
  # 省略時: パスワードなしでユーザーが作成される (temporary_passwordまたは招待メールで設定)
  password = "SecurePassword123!"

  # 設定内容: ユーザーの一時パスワード (初回ログイン時に変更が必要)
  # 設定可能な値: User Poolのパスワードポリシーに準拠したパスワード文字列
  # 省略時: 一時パスワードは設定されない
  temporary_password = "TempPassword123!"

  #---------------------------------------
  # メッセージ配信設定
  #---------------------------------------

  # 設定内容: 検証コードまたは一時パスワードの配信方法
  # 設定可能な値: ["EMAIL"], ["SMS"], または ["EMAIL", "SMS"]
  # 省略時: User Poolの設定に従う
  desired_delivery_mediums = ["EMAIL"]

  # 設定内容: ユーザー作成時のメッセージアクション
  # 設定可能な値: "SUPPRESS" (メッセージを送信しない), "RESEND" (既存ユーザーに再送信)
  # 省略時: デフォルトでウェルカムメッセージが送信される
  message_action = "SUPPRESS"

  #---------------------------------------
  # ユーザーステータス
  #---------------------------------------

  # 設定内容: ユーザーアカウントの有効/無効状態
  # 設定可能な値: true (有効), false (無効)
  # 省略時: true (有効)
  enabled = true

  #---------------------------------------
  # エイリアス設定
  #---------------------------------------

  # 設定内容: 既存のエイリアス (email/phone_number) と競合する場合に強制的にエイリアスを作成
  # 設定可能な値: true (強制作成), false (競合時にエラー)
  # 省略時: false
  force_alias_creation = false

  #---------------------------------------
  # 検証データ
  #---------------------------------------

  # 設定内容: カスタムワークフローのLambda関数に渡される検証データ
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: 検証データは送信されない
  validation_data = {
    key1 = "value1"
    key2 = "value2"
  }

  #---------------------------------------
  # クライアントメタデータ
  #---------------------------------------

  # 設定内容: カスタムワークフローのLambda関数に渡されるクライアントメタデータ
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: メタデータは送信されない
  client_metadata = {
    source      = "terraform"
    environment = "production"
  }

  #---------------------------------------
  # リージョン設定
  #---------------------------------------

  # 設定内容: このリソースが管理されるAWSリージョン
  # 設定可能な値: 有効なAWSリージョンコード (例: us-east-1, ap-northeast-1)
  # 省略時: プロバイダー設定のリージョンが使用される
  region = "us-east-1"
}

#---------------------------------------
# Attributes Reference (参照可能な属性)
#---------------------------------------
# このリソースをデプロイ後に参照できる属性:
#
# aws_cognito_user.example.id                    - ユーザーのID (形式: user_pool_id/username)
# aws_cognito_user.example.sub                   - ユーザーの一意なサブジェクト識別子 (UUID)
# aws_cognito_user.example.status                - ユーザーのステータス (UNCONFIRMED, CONFIRMED, ARCHIVED, COMPROMISED, UNKNOWN, RESET_REQUIRED, FORCE_CHANGE_PASSWORD)
# aws_cognito_user.example.creation_date         - ユーザーの作成日時 (RFC3339形式)
# aws_cognito_user.example.last_modified_date    - ユーザーの最終更新日時 (RFC3339形式)
# aws_cognito_user.example.mfa_setting_list      - ユーザーに対して有効なMFA設定のリスト
# aws_cognito_user.example.preferred_mfa_setting - ユーザーの優先MFA設定
# aws_cognito_user.example.region                - リソースが管理されているAWSリージョン
