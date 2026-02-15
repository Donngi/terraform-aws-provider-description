# Terraform Block
#-----------------------------------------------------------------------
# terraform {
#   required_version = ">= 1.10"
#
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 6.28.0"
#     }
#   }
# }

# Provider Block
#-----------------------------------------------------------------------
# provider "aws" {
#   region = var.region
# }

# API Gateway Resource
#-----------------------------------------------------------------------
# Provider Version: 6.28.0
# Generated: 2026-02-11
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_resource
# NOTE: API Gatewayのリソースを作成
#       REST APIエンドポイントのパス構造を定義するために使用
#       親リソースと紐付けて階層的なURLパスを構築可能

resource "aws_api_gateway_resource" "example" {
  #-----------------------------------------------------------------------
  # 基本設定
  #-----------------------------------------------------------------------
  # 設定内容: 関連付けるREST APIのID
  # 設定可能な値: API GatewayのREST APIリソースID（例: "abc123"）
  rest_api_id = "replace_with_your_rest_api_id"

  # 設定内容: 親リソースのID
  # 設定可能な値: API Gatewayリソースのパス構造における親リソースID（ルートリソースIDを含む）
  parent_id = "replace_with_parent_resource_id"

  # 設定内容: このリソースのパスセグメント
  # 設定可能な値: URLパスの一部として使用される文字列（例: "users", "items", "{id}"）
  path_part = "myresource"

  #-----------------------------------------------------------------------
  # リージョン設定（オプション）
  #-----------------------------------------------------------------------
  # 設定内容: リソースを管理するAWSリージョン
  # 設定可能な値: AWSリージョンコード（例: "us-east-1", "ap-northeast-1"）
  # 省略時: プロバイダー設定のリージョンが使用される
  region = "us-east-1"
}

# Attributes Reference
#-----------------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id
#   リソース識別子
#
# - path
#   全ての親パスを含む完全なAPIリソースパス
