#---------------------------------------
# aws_cognito_user_in_group
#---------------------------------------
# Provider Version: 6.28.0
# Generated: 2026-02-13
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/cognito_user_in_group
#
# NOTE:
# Cognitoユーザープール内の特定ユーザーをグループに追加します
# このリソースは、ユーザーとグループの関連付けを管理するために使用されます
#
# 主な用途:
# - ユーザーのグループメンバーシップ管理
# - ロールベースアクセス制御（RBAC）の実装
# - ユーザー権限の動的割り当て
#
# 制約事項:
# - ユーザーとグループは同一ユーザープール内に存在する必要があります
# - ユーザーは複数のグループに所属可能です
# - グループの削除時は先にユーザーとの関連付けを削除する必要があります

#---------------------------------------
# リソース定義
#---------------------------------------

resource "aws_cognito_user_in_group" "example" {

  #---------------------------------------
  # 基本設定
  #---------------------------------------

  # 設定内容: Cognitoユーザープール識別子
  # 設定可能な値: 有効なユーザープールID（例: us-east-1_aBcDeFgHi）
  # 省略時: 設定必須
  user_pool_id = "us-east-1_XXXXXXXXX"

  # 設定内容: グループ名
  # 設定可能な値: ユーザープール内の既存グループ名
  # 省略時: 設定必須
  group_name = "example-group"

  # 設定内容: ユーザー名
  # 設定可能な値: ユーザープール内の既存ユーザー名
  # 省略時: 設定必須
  username = "example-user"

  #---------------------------------------
  # リージョン設定
  #---------------------------------------

  # 設定内容: リソース管理リージョン
  # 設定可能な値: AWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  region = null
}

#---------------------------------------
# Attributes Reference
#---------------------------------------
# このリソースの作成後に参照可能な属性:
#
# - id - リソース識別子（形式: user_pool_id/group_name/username）
# - user_pool_id - ユーザープールID
# - group_name - グループ名
# - username - ユーザー名
# - region - リソース管理リージョン
#
# 属性の参照例:
# - aws_cognito_user_in_group.example.id
# - aws_cognito_user_in_group.example.user_pool_id
# - aws_cognito_user_in_group.example.group_name
#---------------------------------------
