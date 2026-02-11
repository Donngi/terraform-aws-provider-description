#---------------------------------------------------------------
# Amazon ECR アカウント設定
#---------------------------------------------------------------
#
# Amazon ECR（Elastic Container Registry）のアカウントレベルの設定を管理します。
# このリソースは、基本スキャンタイプのバージョン、レジストリポリシースコープ、
# およびBlobマウント（クロスリポジトリレイヤー共有）の設定を制御します。
#
# 主な機能:
#   - 基本スキャンタイプのバージョン設定（AWS_NATIVE または CLAIR）
#   - レジストリポリシースコープの設定（V1 または V2）
#   - Blobマウント設定（ENABLED または DISABLED）
#
# AWS公式ドキュメント:
#   - PutAccountSetting API: https://docs.aws.amazon.com/AmazonECR/latest/APIReference/API_PutAccountSetting.html
#   - プライベートレジストリ設定: https://docs.aws.amazon.com/AmazonECR/latest/userguide/registry-settings.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_account_setting
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ecr_account_setting" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # name - (必須) アカウント設定の名前
  #
  # 設定可能な値:
  #   - BASIC_SCAN_TYPE_VERSION: 基本スキャンタイプのバージョンを設定
  #   - BLOB_MOUNTING: Blobマウント（クロスリポジトリレイヤー共有）を設定
  #   - REGISTRY_POLICY_SCOPE: レジストリポリシースコープを設定
  #
  # 説明:
  #   ECRアカウントで設定する項目を指定します。各設定項目により、
  #   valueパラメータで指定可能な値が異なります。
  #
  # 例: name = "BASIC_SCAN_TYPE_VERSION"
  name = "BASIC_SCAN_TYPE_VERSION"

  # value - (必須) 設定値
  #
  # nameパラメータに応じた設定可能な値:
  #
  # name = "BASIC_SCAN_TYPE_VERSION" の場合:
  #   - AWS_NATIVE: AWSネイティブ技術を使用した改善版の基本スキャン（推奨）
  #   - CLAIR: オープンソースのClairプロジェクトを使用した基本スキャン
  #
  # name = "BLOB_MOUNTING" の場合:
  #   - ENABLED: レジストリ内のリポジトリ間で共通レイヤーを共有
  #   - DISABLED: 各リポジトリで重複レイヤーを保存
  #
  # name = "REGISTRY_POLICY_SCOPE" の場合:
  #   - V1: レジストリポリシースコープバージョン1
  #   - V2: レジストリポリシースコープバージョン2
  #
  # 説明:
  #   指定したアカウント設定に対する値を設定します。
  #   基本スキャンタイプでは、AWS_NATIVEが推奨されており、
  #   より優れた脆弱性検出機能を提供します。
  #   一度AWS_NATIVEに変更すると、CLAIRへの戻しは推奨されません。
  #
  # 例: value = "AWS_NATIVE"
  value = "AWS_NATIVE"

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # region - (オプション) このリソースが管理されるリージョン
  #
  # 説明:
  #   このアカウント設定が適用されるAWSリージョンを指定します。
  #   指定しない場合は、プロバイダー設定で指定されたリージョンが使用されます。
  #   ECRのプライベートレジストリ設定は各リージョンごとに個別に構成されます。
  #
  # デフォルト: プロバイダー設定のリージョン
  #
  # 例: region = "us-east-1"
  # region = null
}

#---------------------------------------------------------------
# Attributes Reference（参照専用属性）
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# id - アカウント設定の名前（nameと同じ値）
#
# これらの属性は読み取り専用であり、Terraformの設定ファイルで
# 直接指定することはできません。他のリソースから参照する際に
# 使用できます。
#
# 例:
#   output "ecr_account_setting_id" {
#     value = aws_ecr_account_setting.example.id
#   }
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例
#---------------------------------------------------------------
#
# 1. 基本スキャンタイプをAWS Nativeに設定:
#
# resource "aws_ecr_account_setting" "basic_scan_type_version" {
#   name  = "BASIC_SCAN_TYPE_VERSION"
#   value = "AWS_NATIVE"
# }
#
# 2. Blobマウント（クロスリポジトリレイヤー共有）を有効化:
#
# resource "aws_ecr_account_setting" "blob_mounting" {
#   name  = "BLOB_MOUNTING"
#   value = "ENABLED"
# }
#
# 3. レジストリポリシースコープをV2に設定:
#
# resource "aws_ecr_account_setting" "registry_policy_scope" {
#   name  = "REGISTRY_POLICY_SCOPE"
#   value = "V2"
# }
#
# 4. 特定のリージョンに設定を適用:
#
# resource "aws_ecr_account_setting" "us_west_2_scan" {
#   name   = "BASIC_SCAN_TYPE_VERSION"
#   value  = "AWS_NATIVE"
#   region = "us-west-2"
# }
#---------------------------------------------------------------
