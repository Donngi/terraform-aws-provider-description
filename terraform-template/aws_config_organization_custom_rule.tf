#--------------------------------------------------------------
# AWS Config Organization Custom Rule
#--------------------------------------------------------------
# AWS Config組織全体カスタムルールを管理します。
# Lambda関数を使用してカスタム評価ロジックを実装できます。
#
# Provider Version: 6.28.0
# Generated: 2026-02-13
#
# NOTE: AWS Organizationsの管理アカウントまたは委任管理者アカウントで
#       実行する必要があります。
#
# 公式ドキュメント:
# https://docs.aws.amazon.com/config/latest/developerguide/config-rule-multi-account-deployment.html
# https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/config_organization_custom_rule

#--------------------------------------------------------------
# 基本設定
#--------------------------------------------------------------

resource "aws_config_organization_custom_rule" "example" {
  # ルール名
  # 設定内容: 組織カスタムルールの一意な名前
  # 制約: 最大64文字、英数字とハイフンのみ使用可能
  name = "example-organization-custom-rule"

  # Lambda関数ARN
  # 設定内容: ルール評価を実行するLambda関数のARN
  # 制約: 有効なLambda関数ARNが必要
  lambda_function_arn = "arn:aws:lambda:us-east-1:123456789012:function:ConfigRuleEvaluator"

  # トリガータイプ
  # 設定内容: ルール評価をトリガーするイベントタイプ
  # 設定可能な値:
  #   - ConfigurationItemChangeNotification: 設定変更時
  #   - OversizedConfigurationItemChangeNotification: 大きな設定変更時
  #   - ScheduledNotification: スケジュール実行時
  trigger_types = ["ConfigurationItemChangeNotification"]

  #---------------------------------------------------------------
  # ルール詳細設定
  #---------------------------------------------------------------

  # 説明
  # 設定内容: ルールの目的や評価内容の説明
  # 省略時: 説明なし
  description = "組織全体のカスタム評価ルール"

  # 入力パラメータ
  # 設定内容: Lambda関数に渡すJSON形式のパラメータ
  # 省略時: パラメータなし
  input_parameters = jsonencode({
    threshold = "10"
    severity  = "HIGH"
  })

  #---------------------------------------------------------------
  # 実行頻度設定
  #---------------------------------------------------------------

  # 最大実行頻度
  # 設定内容: スケジュールトリガー使用時の評価頻度
  # 設定可能な値:
  #   - One_Hour: 1時間ごと
  #   - Three_Hours: 3時間ごと
  #   - Six_Hours: 6時間ごと
  #   - Twelve_Hours: 12時間ごと
  #   - TwentyFour_Hours: 24時間ごと
  # 省略時: 頻度制限なし
  # 注意: trigger_typesにScheduledNotificationが含まれる場合のみ有効
  maximum_execution_frequency = "TwentyFour_Hours"

  #---------------------------------------------------------------
  # スコープ設定
  #---------------------------------------------------------------

  # リソースタイプスコープ
  # 設定内容: 評価対象とするAWSリソースタイプのリスト
  # 省略時: すべてのリソースタイプが対象
  resource_types_scope = [
    "AWS::EC2::Instance",
    "AWS::S3::Bucket"
  ]

  # リソースIDスコープ
  # 設定内容: 評価対象とする特定リソースのID
  # 省略時: リソースID制限なし
  resource_id_scope = "i-1234567890abcdef0"

  # タグキースコープ
  # 設定内容: 評価対象とするリソースのタグキー
  # 省略時: タグキー制限なし
  # 注意: tag_value_scopeと組み合わせて使用可能
  tag_key_scope = "Environment"

  # タグ値スコープ
  # 設定内容: 評価対象とするリソースのタグ値
  # 省略時: タグ値制限なし
  # 注意: tag_key_scopeと組み合わせて使用可能
  tag_value_scope = "Production"

  #---------------------------------------------------------------
  # 適用範囲制御
  #---------------------------------------------------------------

  # 除外アカウント
  # 設定内容: ルール適用から除外するAWSアカウントIDのセット
  # 省略時: すべての組織アカウントに適用
  excluded_accounts = [
    "123456789012",
    "210987654321"
  ]

  #---------------------------------------------------------------
  # リージョン設定
  #---------------------------------------------------------------

  # リージョン
  # 設定内容: リソースを管理するAWSリージョン
  # 省略時: プロバイダー設定のリージョンを使用
  region = "us-east-1"

  #---------------------------------------------------------------
  # タイムアウト設定
  #---------------------------------------------------------------

  timeouts {
    # 作成タイムアウト
    # 設定内容: ルール作成の最大待機時間
    # 省略時: 5分
    # create = "10m"

    # 更新タイムアウト
    # 設定内容: ルール更新の最大待機時間
    # 省略時: 5分
    # update = "10m"

    # 削除タイムアウト
    # 設定内容: ルール削除の最大待機時間
    # 省略時: 5分
    # delete = "10m"
  }
}

#--------------------------------------------------------------
# Attributes Reference
#--------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: Config組織カスタムルール名
# - arn: ルールのARN（Amazon Resource Name）
