#---------------------------------------------------------------
# AWS Config Organization Managed Rule
#---------------------------------------------------------------
#
# 組織全体に適用されるAWS Config管理ルールを定義するリソースです。
# AWS Organizations配下の全アカウントまたは特定アカウントに対してConfig評価ルールを一元管理できます。
# AWSが提供する管理済みルール（例: required-tags, encrypted-volumes等）を組織レベルで展開可能です。
# 組織管理アカウントまたは委任管理者アカウントから実行する必要があります。
#
# AWS公式ドキュメント:
#   - AWS Config概要: https://docs.aws.amazon.com/config/latest/developerguide/WhatIsConfig.html
#   - 組織ルール: https://docs.aws.amazon.com/config/latest/developerguide/config-rule-multi-account-deployment.html
#   - 管理ルール一覧: https://docs.aws.amazon.com/config/latest/developerguide/managed-rules-by-aws-config.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_organization_managed_rule
#
# Provider Version: 6.28.0
# Generated: 2026-02-13
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_config_organization_managed_rule" "example" {
  #---------------------------------------------------------------
  # 基本設定
  #---------------------------------------------------------------
  # 設定内容: 組織管理ルールの一意な名前
  # 制約: 1文字以上、英数字とハイフン、アンダースコアのみ使用可能
  name = "example-org-rule"

  # 設定内容: 使用するAWS管理ルールの識別子
  # 設定可能な値: required-tags, encrypted-volumes, s3-bucket-public-read-prohibited等
  # 詳細: https://docs.aws.amazon.com/config/latest/developerguide/managed-rules-by-aws-config.html
  rule_identifier = "REQUIRED_TAGS"

  # 設定内容: ルールの説明文
  # 省略時: 説明なし
  description = "組織全体でタグ付けを必須化するルール"

  #---------------------------------------------------------------
  # 実行スコープ設定
  #---------------------------------------------------------------
  # 設定内容: ルール評価から除外するアカウントIDのセット
  # 省略時: 組織内の全アカウントが対象
  excluded_accounts = [
    "123456789012",
    "210987654321",
  ]

  # 設定内容: ルールを適用するリージョン
  # 省略時: プロバイダー設定のリージョン
  # 注意: グローバルリソース（IAM、Route53等）の評価には us-east-1 を指定
  region = "us-east-1"

  #---------------------------------------------------------------
  # リソースフィルタリング
  #---------------------------------------------------------------
  # 設定内容: 評価対象とするリソースタイプのセット
  # 省略時: ルール定義に基づくデフォルトリソースタイプ
  # 例: ["AWS::EC2::Instance", "AWS::S3::Bucket"]
  resource_types_scope = [
    "AWS::EC2::Instance",
    "AWS::EC2::Volume",
    "AWS::S3::Bucket",
  ]

  # 設定内容: 評価対象とする特定のリソースID
  # 省略時: 全リソースが対象
  # 用途: 特定リソースのみを評価したい場合に使用
  resource_id_scope = "i-1234567890abcdef0"

  #---------------------------------------------------------------
  # タグベースフィルタリング
  #---------------------------------------------------------------
  # 設定内容: 評価対象リソースをフィルタリングするタグキー
  # 省略時: タグによるフィルタリングなし
  tag_key_scope = "Environment"

  # 設定内容: 評価対象リソースをフィルタリングするタグ値
  # 省略時: tag_key_scopeで指定したキーを持つ全リソースが対象
  # 注意: tag_key_scopeが設定されている場合のみ有効
  tag_value_scope = "Production"

  #---------------------------------------------------------------
  # ルールパラメータ設定
  #---------------------------------------------------------------
  # 設定内容: ルール実行時に渡すパラメータ（JSON形式）
  # 省略時: パラメータなし
  # 例: required-tagsルールの場合は必須タグキーを指定
  input_parameters = jsonencode({
    tag1Key = "Environment"
    tag2Key = "Owner"
    tag3Key = "Application"
  })

  #---------------------------------------------------------------
  # 実行頻度設定
  #---------------------------------------------------------------
  # 設定内容: 定期評価の実行頻度
  # 設定可能な値: One_Hour, Three_Hours, Six_Hours, Twelve_Hours, TwentyFour_Hours
  # 省略時: 変更トリガー型ルールの場合は設定不要、定期実行型の場合は必須
  # 注意: ルールタイプによっては必須パラメータとなる
  maximum_execution_frequency = "TwentyFour_Hours"

  #---------------------------------------------------------------
  # タイムアウト設定
  #---------------------------------------------------------------
  timeouts {
    # 設定内容: ルール作成のタイムアウト時間
    # 省略時: 5分
    create = "10m"

    # 設定内容: ルール更新のタイムアウト時間
    # 省略時: 5分
    update = "10m"

    # 設定内容: ルール削除のタイムアウト時間
    # 省略時: 5分
    delete = "10m"
  }
}

#---------------------------------------------------------------
# Attributes Reference（参照可能な属性）
#---------------------------------------------------------------
# arn
#   説明: 組織管理ルールのARN
#   形式: arn:aws:config:region:account-id:organization-config-rule/rule-name
#
# id
#   説明: リソースID（ルール名と同じ）
#   用途: 他リソースからの参照や依存関係の定義
#
# region
#   説明: ルールが適用されるリージョン
#   値: 明示指定した値、または計算された値
