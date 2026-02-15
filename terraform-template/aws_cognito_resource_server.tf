#########################################################
# aws_cognito_resource_server
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_resource_server
#
# Provider Version: 6.28.0
# Generated: 2026-02-13
#
# NOTE: Amazon Cognito リソースサーバーを作成
#       OAuth 2.0 リソースサーバーを定義し、カスタムスコープを設定してAPIアクセスを制御
#       アプリクライアントで使用可能なスコープを定義し、権限の細かい制御を実現
#########################################################

#-------------------------------------------------------
# 基本設定
#-------------------------------------------------------

resource "aws_cognito_resource_server" "example" {
  # 識別子
  # 設定内容: リソースサーバーを一意に識別する識別子
  # 設定可能な値: 任意の文字列（通常はAPI URIやドメイン名）
  # 省略時: 設定必須
  identifier = "https://api.example.com"

  # リソースサーバー名
  # 設定内容: リソースサーバーの表示名
  # 設定可能な値: 任意の文字列
  # 省略時: 設定必須
  name = "Example API Resource Server"

  # ユーザープールID
  # 設定内容: リソースサーバーを関連付けるCognitoユーザープールのID
  # 設定可能な値: 既存のユーザープールID（例: us-east-1_xxxxxxxxx）
  # 省略時: 設定必須
  user_pool_id = "us-east-1_xxxxxxxxx"

  #-------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------

  # リソース管理リージョン
  # 設定内容: リソースを管理するAWSリージョン
  # 設定可能な値: AWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  region = "us-east-1"

  #-------------------------------------------------------
  # スコープ設定
  #-------------------------------------------------------

  # カスタムスコープ
  # 設定内容: リソースサーバーで定義するカスタムスコープのリスト
  # 設定可能な値: 最大100個のスコープブロック
  # 省略時: スコープなし（設定可能）
  scope {
    # スコープ名
    # 設定内容: スコープを識別する名前
    # 設定可能な値: 任意の文字列（英数字とアンダースコア）
    # 省略時: 設定必須
    scope_name = "read"

    # スコープ説明
    # 設定内容: スコープの目的や権限内容を説明
    # 設定可能な値: 任意の文字列
    # 省略時: 設定必須
    scope_description = "Read access to API resources"
  }

  scope {
    scope_name        = "write"
    scope_description = "Write access to API resources"
  }

  scope {
    scope_name        = "admin"
    scope_description = "Administrative access to all API resources"
  }
}

#-------------------------------------------------------
# Attributes Reference
#-------------------------------------------------------

# id - リソースサーバーのID（user_pool_id|identifier形式）
# identifier - リソースサーバーの識別子
# name - リソースサーバーの名前
# user_pool_id - 関連付けられたユーザープールのID
# region - リソースが管理されているリージョン
# scope_identifiers - 定義されたすべてのスコープ識別子のリスト（identifier/scope_name形式）

# 出力例:
# output "resource_server_id" {
#   value = aws_cognito_resource_server.example.id
# }
#
# output "scope_identifiers" {
#   value = aws_cognito_resource_server.example.scope_identifiers
# }
