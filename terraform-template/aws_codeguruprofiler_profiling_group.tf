#-------
# AWS CodeGuru Profiler Profiling Group
# https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/codeguruprofiler_profiling_group
#
# Provider Version: 6.28.0
# Generated: 2026-02-13
#
# NOTE: このテンプレートは AWS Provider 6.28.0 のスキーマに基づいて生成されています。
#       実際の使用時には、必要な属性のみを残し、不要な部分は削除してください。
#-------

#-------
# プロファイリンググループの基本設定
#-------
resource "aws_codeguruprofiler_profiling_group" "example" {
  # プロファイリンググループ名
  # 設定内容: CodeGuru Profilerプロファイリンググループの一意な名前
  # 制約: 変更すると新しいリソースが作成される
  name = "example-profiling-group"

  # コンピューティングプラットフォーム
  # 設定内容: アプリケーションが実行されるコンピューティングプラットフォーム
  # 設定可能な値: Default（Lambda以外）、AWSLambda
  # 省略時: Default
  compute_platform = "Default"

  #-------
  # リージョン設定
  #-------
  # デプロイリージョン
  # 設定内容: リソースを管理するAWSリージョン
  # 省略時: プロバイダー設定のリージョンを使用
  region = "ap-northeast-1"

  #-------
  # タグ設定
  #-------
  # リソースタグ
  # 設定内容: プロファイリンググループに付与するタグのキー・バリューペア
  # 用途: リソースの分類、コスト配分、管理の簡素化
  tags = {
    Name        = "example-profiling-group"
    Environment = "production"
  }
}

#-------
# エージェントオーケストレーション設定（オプション）
#-------
resource "aws_codeguruprofiler_profiling_group" "with_agent_orchestration" {
  name             = "example-profiling-group-with-orchestration"
  compute_platform = "Default"

  # エージェントオーケストレーション設定
  # 設定内容: CodeGuru Profilerエージェントの動作制御設定
  agent_orchestration_config {
    # プロファイリング有効化フラグ
    # 設定内容: プロファイリングエージェントの有効/無効を制御
    # 設定可能な値: true（有効）、false（無効）
    profiling_enabled = true
  }

  tags = {
    Name        = "example-profiling-group-with-orchestration"
    Environment = "production"
  }
}

#-------
# Lambda関数用プロファイリンググループ
#-------
resource "aws_codeguruprofiler_profiling_group" "lambda" {
  name             = "lambda-profiling-group"
  compute_platform = "AWSLambda"

  agent_orchestration_config {
    profiling_enabled = true
  }

  tags = {
    Name        = "lambda-profiling-group"
    Environment = "production"
    Platform    = "Lambda"
  }
}

#-------
# Attributes Reference
#-------
# 以下の属性がエクスポートされます:
#
# arn - プロファイリンググループのARN
# id - プロファイリンググループ名
# tags_all - プロバイダーのdefault_tagsとリソースのtagsを統合したタグマップ
# compute_platform - コンピューティングプラットフォーム（省略時はDefaultが設定される）
# region - リソースが管理されるリージョン（省略時はプロバイダー設定値）
