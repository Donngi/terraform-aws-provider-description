#########################################################################################
# AWS CloudFormation StackSet
# Provider Version: 6.28.0
# Generated: 2026-02-11
#
# CloudFormation StackSetを管理し、複数のアカウントやリージョンにスタックを一括デプロイします
#
# 主な機能:
# - 複数アカウント・リージョンへのスタック一括デプロイ
# - セルフマネージド/サービスマネージド権限モデル
# - 自動デプロイメント設定
# - 同時実行・失敗許容の操作設定
#
# NOTE: Default値を持つパラメータも含め全てのテンプレートパラメータを設定するか
#       lifecycle ignore_changesで無視すること
# NOTE: NoEchoパラメータは必ずlifecycle ignore_changesで無視すること
# NOTE: DELEGATED_ADMIN使用時はorganizations:ListDelegatedAdministrators権限が必要
#
# ドキュメント: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudformation_stack_set
#########################################################################################

#-------
# 基本設定
#-------

# StackSet名（必須）
# 設定内容: StackSetの一意な名前
# 制約事項: リージョン内で一意、英数字とハイフンのみ、先頭は英字、最大128文字
variable "stack_set_name" {
  type    = string
  default = "example-stackset"
}

# StackSet説明
# 設定内容: StackSetの説明文
variable "stack_set_description" {
  type    = string
  default = null
}

# テンプレート本文
# 設定内容: CloudFormationテンプレートのJSON/YAML文字列
# 制約事項: 最大51,200バイト、template_urlとは排他
variable "template_body" {
  type    = string
  default = null
}

# テンプレートURL
# 設定内容: S3バケットに保存されたCloudFormationテンプレートのURL
# 制約事項: 最大460,800バイト、template_bodyとは排他
variable "template_url" {
  type    = string
  default = null
}

# テンプレートパラメータ
# 設定内容: CloudFormationテンプレートに渡すパラメータのキーバリューマップ
# 注意事項: Default値を持つパラメータも含め全てのパラメータを設定するか、lifecycle ignore_changesで無視すること
# 注意事項: NoEchoパラメータは必ずlifecycle ignore_changesで無視すること
variable "template_parameters" {
  type    = map(string)
  default = {}
}

#-------
# 権限設定
#-------

# 権限モデル
# 設定内容: IAMロールの作成方法を指定
# 設定可能な値: SELF_MANAGED（手動でロール作成）, SERVICE_MANAGED（AWS Organizations管理）
# 省略時: SELF_MANAGED
variable "permission_model" {
  type    = string
  default = "SELF_MANAGED"
}

# 管理ロールARN
# 設定内容: 管理アカウントのIAMロールARN
# 適用条件: SELF_MANAGED権限モデル使用時に必須
variable "administration_role_arn" {
  type    = string
  default = null
}

# 実行ロール名
# 設定内容: ターゲットアカウントのIAMロール名
# 省略時: SELF_MANAGEDの場合はAWSCloudFormationStackSetExecutionRole
# 注意事項: SERVICE_MANAGED使用時は設定しないこと
variable "execution_role_name" {
  type    = string
  default = null
}

# 呼び出し元の種類
# 設定内容: 管理アカウント管理者または委任管理者としての実行を指定
# 設定可能な値: SELF（管理アカウント）, DELEGATED_ADMIN（委任管理者）
# 省略時: SELF
# 注意事項: DELEGATED_ADMIN使用時はorganizations:ListDelegatedAdministrators権限が必要
variable "call_as" {
  type    = string
  default = "SELF"
}

# Capabilities
# 設定内容: StackSetに必要なIAM機能のリスト
# 設定可能な値: CAPABILITY_IAM, CAPABILITY_NAMED_IAM, CAPABILITY_AUTO_EXPAND
variable "capabilities" {
  type    = set(string)
  default = []
}

#-------
# 自動デプロイメント設定
#-------

# 自動デプロイメント有効化
# 設定内容: 新しいアカウントが組織に追加された際の自動デプロイを有効化
# 適用条件: SERVICE_MANAGED権限モデル使用時のみ
variable "auto_deployment_enabled" {
  type    = bool
  default = null
}

# アカウント削除時のスタック保持
# 設定内容: アカウントが組織から削除された際にスタックを保持するか
# 適用条件: SERVICE_MANAGED権限モデルかつauto_deployment有効時
variable "auto_deployment_retain_stacks" {
  type    = bool
  default = null
}

#-------
# 操作設定
#-------

# 失敗許容数
# 設定内容: リージョンごとに許容される操作失敗アカウント数
# 制約事項: failure_tolerance_percentageとは排他
variable "operation_failure_tolerance_count" {
  type    = number
  default = null
}

# 失敗許容率
# 設定内容: リージョンごとに許容される操作失敗アカウント割合（%）
# 制約事項: failure_tolerance_countとは排他
variable "operation_failure_tolerance_percentage" {
  type    = number
  default = null
}

# 最大同時実行数
# 設定内容: 同時に操作を実行する最大アカウント数
# 制約事項: max_concurrent_percentageとは排他
variable "operation_max_concurrent_count" {
  type    = number
  default = null
}

# 最大同時実行率
# 設定内容: 同時に操作を実行する最大アカウント割合（%）
# 制約事項: max_concurrent_countとは排他
variable "operation_max_concurrent_percentage" {
  type    = number
  default = null
}

# リージョン同時実行タイプ
# 設定内容: リージョン間の操作実行方法
# 設定可能な値: SEQUENTIAL（順次実行）, PARALLEL（並列実行）
variable "operation_region_concurrency_type" {
  type    = string
  default = null
}

# リージョン実行順序
# 設定内容: スタック操作を実行するリージョンの順序リスト
variable "operation_region_order" {
  type    = list(string)
  default = []
}

#-------
# マネージド実行設定
#-------

# マネージド実行の有効化
# 設定内容: 競合しない操作の同時実行と競合操作のキューイングを有効化
# 省略時: false
variable "managed_execution_active" {
  type    = bool
  default = null
}

#-------
# リソース管理設定
#-------

# リージョン
# 設定内容: リソースを管理するAWSリージョン
# 省略時: プロバイダー設定のリージョン
variable "region" {
  type    = string
  default = null
}

# タグ
# 設定内容: StackSetおよび作成されるスタックに関連付けるタグのキーバリューマップ
# 制約事項: 最大50タグ
# 注意事項: サポートされるリソースにも伝播される
variable "tags" {
  type    = map(string)
  default = {}
}

#-------
# タイムアウト設定
#-------

# 更新タイムアウト
# 設定内容: StackSet更新操作のタイムアウト時間
# 設定形式: "30m"（分）、"1h"（時間）など
variable "update_timeout" {
  type    = string
  default = null
}

#########################################################################################
# リソース定義
#########################################################################################

resource "aws_cloudformation_stack_set" "this" {
  #-------
  # 基本設定
  #-------
  name        = var.stack_set_name
  description = var.stack_set_description

  #-------
  # テンプレート設定
  #-------
  template_body = var.template_body
  template_url  = var.template_url
  parameters    = var.template_parameters

  #-------
  # 権限設定
  #-------
  permission_model        = var.permission_model
  administration_role_arn = var.administration_role_arn
  execution_role_name     = var.execution_role_name
  call_as                 = var.call_as
  capabilities            = var.capabilities

  #-------
  # 自動デプロイメント設定（SERVICE_MANAGED権限モデル時のみ）
  #-------
  auto_deployment {
    enabled                          = var.auto_deployment_enabled
    retain_stacks_on_account_removal = var.auto_deployment_retain_stacks
  }

  #-------
  # 操作設定
  #-------
  operation_preferences {
    failure_tolerance_count      = var.operation_failure_tolerance_count
    failure_tolerance_percentage = var.operation_failure_tolerance_percentage
    max_concurrent_count         = var.operation_max_concurrent_count
    max_concurrent_percentage    = var.operation_max_concurrent_percentage
    region_concurrency_type      = var.operation_region_concurrency_type
    region_order                 = var.operation_region_order
  }

  #-------
  # マネージド実行設定
  #-------
  managed_execution {
    active = var.managed_execution_active
  }

  #-------
  # リソース管理設定
  #-------
  region = var.region
  tags   = var.tags

  #-------
  # タイムアウト設定
  #-------
  timeouts {
    update = var.update_timeout
  }
}

#########################################################################################
# Attributes Reference（参照可能な属性）
#########################################################################################
# arn              - StackSetのARN
# id               - StackSetの名前
# stack_set_id     - StackSetの一意な識別子
# tags_all         - プロバイダーdefault_tags含む全タグのマップ

#########################################################################################
# 出力例
#########################################################################################

output "stack_set_arn" {
  description = "StackSetのARN"
  value       = aws_cloudformation_stack_set.this.arn
}

output "stack_set_id" {
  description = "StackSetの一意な識別子"
  value       = aws_cloudformation_stack_set.this.stack_set_id
}

output "stack_set_name" {
  description = "StackSetの名前"
  value       = aws_cloudformation_stack_set.this.id
}
