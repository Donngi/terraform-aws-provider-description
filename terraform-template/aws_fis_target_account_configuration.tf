#-------------------------------------------------------------------------------------------------------
# AWS FIS (Fault Injection Simulator) Target Account Configuration
#-------------------------------------------------------------------------------------------------------
# Provider Version: 6.28.0
# Generated: 2026-02-17
#
# マルチアカウント実験のターゲットアカウント設定を管理するリソース。
# FIS実験テンプレートに対してターゲットアカウントを定義し、複数のAWSアカウントにまたがる
# 実験シナリオを実行できるようにする。オーケストレーターアカウントから各ターゲットアカウントに
# 障害注入を行うためのIAMロールとアカウントIDを設定する。
#
# 主な用途:
# - マルチアカウント実験環境の構築
# - 複数アカウントにまたがるアプリケーションの耐障害性テスト
# - クロスアカウントでの障害注入シナリオ実行
#
# 関連リソース:
# - aws_fis_experiment_template: 実験テンプレート本体
# - aws_iam_role: ターゲットアカウントでのFIS実行用ロール
#
# NOTE:
# - マルチアカウント実験は同一リージョン内でのみ実行可能
# - ターゲットアカウント側でオーケストレーターアカウントからのAssumeRoleを許可する信頼ポリシーが必要
# - IAMロールチェーンを使用してターゲットアカウントのリソースにアクセスする
#
# Terraformドキュメント: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/fis_target_account_configuration
# AWSドキュメント: https://docs.aws.amazon.com/fis/latest/userguide/multi-account.html
#-------------------------------------------------------------------------------------------------------

#-------------------------------------------------------------------------------------------------------
# 基本設定
#-------------------------------------------------------------------------------------------------------
resource "aws_fis_target_account_configuration" "example" {
  # 実験テンプレートID（必須）
  # 設定内容: このターゲットアカウント設定を関連付けるFIS実験テンプレートのID
  # 形式: fit-xxxxxxxxxxxxx
  experiment_template_id = "fit-0123456789abcdef0"

  # ターゲットアカウントID（必須）
  # 設定内容: 障害注入の対象となるAWSアカウントのID
  # 形式: 12桁の数字
  # 注意: オーケストレーターアカウント自体も設定可能
  account_id = "123456789012"

  # ターゲットアカウントの説明
  # 設定内容: ターゲットアカウントの用途や役割を説明するテキスト
  # 省略時: 空文字列
  description = "本番環境アカウント - アプリケーションサーバー群"

  # IAMロールARN
  # 設定内容: ターゲットアカウントでFISアクションを実行するためのIAMロールARN
  # 形式: arn:aws:iam::ACCOUNT_ID:role/ROLE_NAME
  # 注意: ターゲットアカウント側でオーケストレーターアカウントからのAssumeRoleを許可する信頼ポリシーが必要
  # 省略時: ロールが設定されず、実験実行時にエラーになる可能性あり
  role_arn = "arn:aws:iam::123456789012:role/FISTargetAccountRole"
}

#-------------------------------------------------------------------------------------------------------
# リージョン管理設定
#-------------------------------------------------------------------------------------------------------
resource "aws_fis_target_account_configuration" "region_specific" {
  experiment_template_id = "fit-0123456789abcdef0"
  account_id             = "123456789012"
  role_arn               = "arn:aws:iam::123456789012:role/FISTargetAccountRole"
  description            = "東京リージョンでの実験用ターゲット"

  # リージョン
  # 設定内容: このリソースを管理するAWSリージョン
  # 省略時: プロバイダー設定のリージョンを使用
  # 注意: マルチアカウント実験は同一リージョン内でのみ実行可能
  region = "ap-northeast-1"
}

#-------------------------------------------------------------------------------------------------------
# マルチアカウント実験の設定例
#-------------------------------------------------------------------------------------------------------
# 複数のターゲットアカウントを持つ実験環境
resource "aws_fis_target_account_configuration" "production" {
  experiment_template_id = aws_fis_experiment_template.multi_account.id
  account_id             = "111111111111"
  role_arn               = "arn:aws:iam::111111111111:role/FISTargetRole"
  description            = "本番環境 - Webサーバー層"
}

resource "aws_fis_target_account_configuration" "staging" {
  experiment_template_id = aws_fis_experiment_template.multi_account.id
  account_id             = "222222222222"
  role_arn               = "arn:aws:iam::222222222222:role/FISTargetRole"
  description            = "ステージング環境 - 結合テスト用"
}

resource "aws_fis_target_account_configuration" "development" {
  experiment_template_id = aws_fis_experiment_template.multi_account.id
  account_id             = "333333333333"
  role_arn               = "arn:aws:iam::333333333333:role/FISTargetRole"
  description            = "開発環境 - 機能開発用"
}

#-------------------------------------------------------------------------------------------------------
# 動的なターゲットアカウント設定
#-------------------------------------------------------------------------------------------------------
# 変数で管理された複数アカウントを一括設定
variable "target_accounts" {
  type = map(object({
    account_id  = string
    role_arn    = string
    description = string
  }))
  default = {
    prod = {
      account_id  = "111111111111"
      role_arn    = "arn:aws:iam::111111111111:role/FISTargetRole"
      description = "本番環境"
    }
    staging = {
      account_id  = "222222222222"
      role_arn    = "arn:aws:iam::222222222222:role/FISTargetRole"
      description = "ステージング環境"
    }
  }
}

resource "aws_fis_target_account_configuration" "dynamic" {
  for_each = var.target_accounts

  experiment_template_id = aws_fis_experiment_template.multi_account.id
  account_id             = each.value.account_id
  role_arn               = each.value.role_arn
  description            = each.value.description
}

#-------------------------------------------------------------------------------------------------------
# Attributes Reference（参照可能な属性）
#-------------------------------------------------------------------------------------------------------
# このリソースでは以下の属性が参照可能:
#
# - account_id - ターゲットアカウントID
# - description - ターゲットアカウントの説明
# - experiment_template_id - 実験テンプレートID
# - region - リソース管理リージョン
# - role_arn - IAMロールARN
#
# 参照例:
# - アカウントID: aws_fis_target_account_configuration.example.account_id
# - ロールARN: aws_fis_target_account_configuration.example.role_arn
