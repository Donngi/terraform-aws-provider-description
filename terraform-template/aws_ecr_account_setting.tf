#---------------------------------------------------------------------------------------
# Resource: aws_ecr_account_setting
#---------------------------------------------------------------------------------------
# Purpose: AWS ECRアカウント設定を管理
# Provider Version: 6.28.0
# Generated: 2026-02-16
# Docs: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_account_setting
#
# NOTE:
#   基本スキャン設定、Blobマウント設定、レジストリポリシースコープ設定が可能
#---------------------------------------------------------------------------------------

resource "aws_ecr_account_setting" "example" {
  #-------
  # 設定名
  #-------
  # 設定内容: ECRアカウント設定の名前
  # 設定可能な値:
  #   - BASIC_SCAN_TYPE_VERSION: 基本スキャンタイプのバージョン設定
  #   - BLOB_MOUNTING: クロスリポジトリレイヤー共有の有効化設定
  #   - REGISTRY_POLICY_SCOPE: レジストリポリシーのスコープ設定
  name = "BASIC_SCAN_TYPE_VERSION"

  #-------
  # 設定値
  #-------
  # 設定内容: 設定名に対応する値
  # 設定可能な値:
  #   - nameが"BASIC_SCAN_TYPE_VERSION"の場合: AWS_NATIVE, CLAIR
  #   - nameが"BLOB_MOUNTING"の場合: ENABLED, DISABLED
  #   - nameが"REGISTRY_POLICY_SCOPE"の場合: V1, V2
  value = "AWS_NATIVE"

  #-------
  # リージョン設定
  #-------
  # 設定内容: このリソースを管理するリージョン
  # 省略時: プロバイダー設定のリージョンが使用される
  region = "us-east-1"
}

#---------------------------------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------------------------------
# id: アカウント設定の名前
