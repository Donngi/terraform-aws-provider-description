# AWS CodeCatalyst Dev Environment
# 参考: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/codecatalyst_dev_environment
# Provider Version: 6.28.0
# Generated: 2026-02-12
# NOTE: このテンプレートは自動生成されています。実際の使用時は環境に応じてパラメータを調整してください。

# CodeCatalystの開発環境を作成
# - ブラウザベースまたはIDEベースの開発環境を提供
# - プロジェクトのリポジトリに接続してコード編集・実行が可能
# - 永続ストレージとIDE設定をカスタマイズ可能

#------------------------------------------------------------------------
# 基本設定
#------------------------------------------------------------------------

variable "codecatalyst_dev_environment_space_name" {
  description = "CodeCatalystスペース名"
  type        = string
  # 設定内容: 開発環境が属するCodeCatalystスペースの名前
  # 設定可能な値: 既存のCodeCatalystスペース名
  # 省略時: (必須項目)
}

variable "codecatalyst_dev_environment_project_name" {
  description = "CodeCatalystプロジェクト名"
  type        = string
  # 設定内容: 開発環境が属するCodeCatalystプロジェクトの名前
  # 設定可能な値: スペース内の既存プロジェクト名
  # 省略時: (必須項目)
}

variable "codecatalyst_dev_environment_instance_type" {
  description = "開発環境のインスタンスタイプ"
  type        = string
  default     = "dev.standard1.small"
  # 設定内容: 開発環境の計算リソースタイプ
  # 設定可能な値: dev.standard1.small | dev.standard1.medium | dev.standard1.large | dev.standard1.xlarge
  # 省略時: (必須項目)
}

variable "codecatalyst_dev_environment_alias" {
  description = "開発環境のエイリアス名"
  type        = string
  default     = null
  # 設定内容: 開発環境を識別するための任意の名前
  # 設定可能な値: 任意の文字列
  # 省略時: 自動生成される
}

variable "codecatalyst_dev_environment_inactivity_timeout_minutes" {
  description = "非アクティブタイムアウト時間（分）"
  type        = number
  default     = null
  # 設定内容: 非アクティブ状態が続いた場合に開発環境を停止するまでの時間
  # 設定可能な値: 0～9999（分）
  # 省略時: プロジェクトのデフォルト設定を使用
}

#------------------------------------------------------------------------
# 永続ストレージ設定
#------------------------------------------------------------------------

variable "codecatalyst_dev_environment_persistent_storage_size" {
  description = "永続ストレージサイズ（GB）"
  type        = number
  default     = 16
  # 設定内容: 開発環境の永続ストレージ容量
  # 設定可能な値: 16～64（GB）
  # 省略時: (必須項目)
}

#------------------------------------------------------------------------
# IDE設定
#------------------------------------------------------------------------

variable "codecatalyst_dev_environment_ide_name" {
  description = "IDE名"
  type        = string
  default     = null
  # 設定内容: 使用するIDE/エディタの名前
  # 設定可能な値: AWS Cloud9 | IntelliJ | PyCharm | GoLand | VSCode等
  # 省略時: AWS Cloud9が使用される
}

variable "codecatalyst_dev_environment_ide_runtime" {
  description = "IDEランタイム"
  type        = string
  default     = null
  # 設定内容: IDEの実行環境バージョン
  # 設定可能な値: public.ecr.aws/他のランタイムイメージURL
  # 省略時: デフォルトランタイムを使用
}

#------------------------------------------------------------------------
# リージョン設定
#------------------------------------------------------------------------

variable "codecatalyst_dev_environment_region" {
  description = "開発環境を作成するAWSリージョン"
  type        = string
  default     = null
  # 設定内容: 開発環境が実行されるAWSリージョン
  # 設定可能な値: us-east-1 | us-west-2 | ap-southeast-1等のリージョンコード
  # 省略時: プロバイダーのデフォルトリージョン
}

#------------------------------------------------------------------------
# リソース定義
#------------------------------------------------------------------------

resource "aws_codecatalyst_dev_environment" "this" {
  space_name                 = var.codecatalyst_dev_environment_space_name
  project_name               = var.codecatalyst_dev_environment_project_name
  instance_type              = var.codecatalyst_dev_environment_instance_type
  alias                      = var.codecatalyst_dev_environment_alias
  inactivity_timeout_minutes = var.codecatalyst_dev_environment_inactivity_timeout_minutes
  region                     = var.codecatalyst_dev_environment_region

  persistent_storage {
    size = var.codecatalyst_dev_environment_persistent_storage_size
  }

  ides {
    name    = var.codecatalyst_dev_environment_ide_name
    runtime = var.codecatalyst_dev_environment_ide_runtime
  }

  # repositories {
  #   # 設定内容: 開発環境にクローンするリポジトリ名
  #   # 設定可能な値: プロジェクト内の既存リポジトリ名
  #   # 省略時: リポジトリをクローンしない
  #   repository_name = "my-repo"
  #
  #   # 設定内容: クローンするブランチ名
  #   # 設定可能な値: リポジトリ内の既存ブランチ名
  #   # 省略時: デフォルトブランチを使用
  #   branch_name = "main"
  # }

  # timeouts {
  #   # 設定内容: 作成時のタイムアウト時間
  #   # 設定可能な値: "30m" | "1h"等の時間文字列
  #   # 省略時: 30m
  #   create = "30m"
  #
  #   # 設定内容: 更新時のタイムアウト時間
  #   # 設定可能な値: "30m" | "1h"等の時間文字列
  #   # 省略時: 30m
  #   update = "30m"
  #
  #   # 設定内容: 削除時のタイムアウト時間
  #   # 設定可能な値: "30m" | "1h"等の時間文字列
  #   # 省略時: 30m
  #   delete = "30m"
  # }
}

#------------------------------------------------------------------------
# Attributes Reference（参照可能な属性）
#------------------------------------------------------------------------

output "codecatalyst_dev_environment_id" {
  description = "開発環境ID"
  value       = aws_codecatalyst_dev_environment.this.id
}
