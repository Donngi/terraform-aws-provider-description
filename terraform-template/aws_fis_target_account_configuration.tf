################################################################################
# AWS FIS Target Account Configuration
################################################################################
# このテンプレートは AWS Fault Injection Simulator (FIS) のターゲットアカウント設定を
# 定義するためのものです。マルチアカウント実験を実行する際に、各ターゲットアカウントの
# 設定を管理します。
#
# Generated: 2026-01-23
# Provider Version: 6.28.0
# Resource: aws_fis_target_account_configuration
#
# 注意: このテンプレートは生成時点の情報です。最新の仕様については
# 公式ドキュメントを参照してください。
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/fis_target_account_configuration
################################################################################

resource "aws_fis_target_account_configuration" "example" {
  #-----------------------------------------------------------------------------
  # 必須パラメータ
  #-----------------------------------------------------------------------------

  # account_id - (Required) ターゲットアカウントのAWSアカウントID
  # マルチアカウント実験の対象となるアカウントのIDを指定します。
  # オーケストレーターアカウントから、このアカウントのリソースに対して
  # フォールトインジェクション実験を実行できるようになります。
  #
  # 型: string
  # 必須: Yes
  # 例: "123456789012"
  account_id = "123456789012"

  # experiment_template_id - (Required) 実験テンプレートのID
  # このターゲットアカウント設定を関連付ける実験テンプレートのIDを指定します。
  # aws_fis_experiment_template リソースの id 属性を参照することが一般的です。
  #
  # 型: string
  # 必須: Yes
  # 例: "EXT1234567890abcdef"
  experiment_template_id = aws_fis_experiment_template.example.id

  #-----------------------------------------------------------------------------
  # オプションパラメータ
  #-----------------------------------------------------------------------------

  # description - (Optional) ターゲットアカウントの説明
  # このターゲットアカウント設定の目的や用途を説明するテキストです。
  # 複数のターゲットアカウントを管理する際の識別に役立ちます。
  #
  # 型: string
  # デフォルト: 計算される値
  # 例: "Production account for experiment"
  description = "Example target account configuration for multi-account FIS experiment"

  # role_arn - (Optional) ターゲットアカウントのIAMロールARN
  # オーケストレーターアカウントがこのターゲットアカウントのリソースに対して
  # アクションを実行するために使用するIAMロールのARNを指定します。
  # IAMロールチェーンを通じて、ターゲットアカウントの権限を委任します。
  #
  # 型: string
  # デフォルト: 計算される値
  #
  # 参考:
  # - マルチアカウント実験の前提条件: https://docs.aws.amazon.com/fis/latest/userguide/multi-account-prerequisites.html
  # - IAMロールチェーンの設定が必要です
  #
  # 例: "arn:aws:iam::123456789012:role/FISTargetAccountRole"
  role_arn = "arn:aws:iam::123456789012:role/FISTargetAccountRole"

  # region - (Optional) このリソースが管理されるリージョン
  # このリソースが管理されるAWSリージョンを指定します。
  # 指定しない場合は、プロバイダー設定のリージョンがデフォルトとして使用されます。
  #
  # 型: string
  # デフォルト: プロバイダー設定のリージョン
  #
  # 参考:
  # - リージョナルエンドポイント: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # - プロバイダー設定: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#aws-configuration-reference
  #
  # 例: "us-west-2"
  region = "us-east-1"
}

################################################################################
# 参考情報
################################################################################
#
# マルチアカウント実験について:
# AWS FISのマルチアカウント実験は、複数のAWSアカウントにまたがるアプリケーションに対して
# 実際の障害シナリオをテストすることを可能にします。
#
# 主な概念:
# - オーケストレーターアカウント: 実験を設定・管理する中央アカウント
# - ターゲットアカウント: 実験の対象となるリソースを持つアカウント
# - ターゲットアカウント設定: 各ターゲットアカウントに対する設定（このリソース）
#
# 設定要件:
# 1. 実験テンプレートの accountTargeting を "multi-account" に設定
# 2. 各ターゲットアカウントに対してターゲットアカウント設定を作成
# 3. IAMロールチェーンを通じた権限委任の設定
#
# ベストプラクティス:
# - すべてのターゲットアカウントで一貫したタグを使用してリソースをターゲティング
# - 複数のアカウントでリソースをターゲティングする場合は、アベイラビリティゾーン名
#   ではなくアベイラビリティゾーンIDを指定
# - CloudFormation StackSetsを使用して複数のIAMロールを一度にプロビジョニング
#
# 関連リソース:
# - aws_fis_experiment_template: 実験テンプレート
# - aws_iam_role: IAMロール（オーケストレーターおよびターゲットアカウント用）
#
# 公式ドキュメント:
# - マルチアカウント実験: https://docs.aws.amazon.com/fis/latest/userguide/multi-account.html
# - 実験オプション: https://docs.aws.amazon.com/fis/latest/userguide/experiment-options.html
# - API リファレンス: https://docs.aws.amazon.com/fis/latest/APIReference/API_CreateTargetAccountConfiguration.html
################################################################################
