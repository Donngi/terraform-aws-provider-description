#---------------------------------------------------------------
# AWS AppConfig Deployment Strategy
#---------------------------------------------------------------
#
# AWS AppConfigのデプロイメント戦略をプロビジョニングするリソースです。
# デプロイメント戦略は、設定をターゲットにロールアウトする際の重要な基準
# （デプロイ時間、成長率、成長タイプ、ベイク時間）を定義します。
#
# AWS公式ドキュメント:
#   - AppConfigデプロイメント戦略の概要: https://docs.aws.amazon.com/appconfig/latest/userguide/appconfig-creating-deployment-strategy.html
#   - デプロイメント戦略の作成: https://docs.aws.amazon.com/appconfig/latest/userguide/appconfig-creating-deployment-strategy-create.html
#   - 事前定義されたデプロイメント戦略: https://docs.aws.amazon.com/appconfig/latest/userguide/appconfig-creating-deployment-strategy-predefined.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appconfig_deployment_strategy
#
# Provider Version: 6.28.0
# Generated: 2026-01-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_appconfig_deployment_strategy" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required, Forces new resource)
  # 設定内容: デプロイメント戦略の名前を指定します。
  # 設定可能な値: 1-64文字の文字列
  # 注意: リソース作成後に変更すると新しいリソースが作成されます。
  name = "example-deployment-strategy"

  # description (Optional)
  # 設定内容: デプロイメント戦略の説明を指定します。
  # 設定可能な値: 最大1024文字の文字列
  description = "Example deployment strategy for gradual rollout"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # デプロイメント時間設定
  #-------------------------------------------------------------

  # deployment_duration_in_minutes (Required)
  # 設定内容: デプロイメント全体の所要時間（分）を指定します。
  # 設定可能な値: 0-1440（分）
  # 関連機能: AppConfig デプロイメント時間
  #   設定をターゲットにデプロイするまでの総時間を設定します。
  #   この期間中、設定は段階的にロールアウトされます。
  #   - https://docs.aws.amazon.com/appconfig/latest/userguide/appconfig-creating-deployment-strategy.html
  deployment_duration_in_minutes = 30

  # final_bake_time_in_minutes (Optional)
  # 設定内容: 設定が100%のターゲットにデプロイされた後、AWS AppConfigが
  #           CloudWatchアラームを監視する時間（分）を指定します。
  # 設定可能な値: 0-1440（分）
  # 省略時: 0
  # 関連機能: AppConfig ベイク時間
  #   デプロイメント完了後の監視期間です。この期間中にアラームが発生すると
  #   自動ロールバックの対象となります。
  #   - https://docs.aws.amazon.com/appconfig/latest/userguide/appconfig-creating-deployment-strategy.html
  final_bake_time_in_minutes = 10

  #-------------------------------------------------------------
  # 成長設定
  #-------------------------------------------------------------

  # growth_factor (Required)
  # 設定内容: 各インターバルでデプロイ済み設定を受け取るターゲットの
  #           パーセンテージを指定します。
  # 設定可能な値: 1.0-100.0（パーセンテージ）
  # 関連機能: AppConfig ステップパーセンテージ
  #   各デプロイステップでターゲットに設定を配信する割合を定義します。
  #   growth_typeと組み合わせてロールアウト速度を制御します。
  #   - https://docs.aws.amazon.com/appconfig/latest/userguide/appconfig-creating-deployment-strategy.html
  growth_factor = 10

  # growth_type (Optional)
  # 設定内容: パーセンテージが時間とともにどのように増加するかを定義する
  #           アルゴリズムを指定します。
  # 設定可能な値:
  #   - "LINEAR" (デフォルト): 設定を指定された時間枠で均等にロールアウト
  #   - "EXPONENTIAL": 成長率に基づいて指数関数的にロールアウト
  # 関連機能: AppConfig デプロイメントタイプ
  #   LINEARは一定の割合で段階的にロールアウト。EXPONENTIALは初期段階では
  #   少数のターゲットに配信し、徐々に加速してロールアウトします。
  #   - https://docs.aws.amazon.com/appconfig/latest/userguide/appconfig-creating-deployment-strategy.html
  growth_type = "LINEAR"

  #-------------------------------------------------------------
  # レプリケーション設定
  #-------------------------------------------------------------

  # replicate_to (Required, Forces new resource)
  # 設定内容: デプロイメント戦略の保存先を指定します。
  # 設定可能な値:
  #   - "NONE": AWS AppConfigにのみ保存
  #   - "SSM_DOCUMENT": Systems Managerドキュメントとしても保存
  # 注意: リソース作成後に変更すると新しいリソースが作成されます。
  replicate_to = "NONE"

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-deployment-strategy"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: AppConfigデプロイメント戦略のID
#
# - arn: AppConfigデプロイメント戦略のAmazon Resource Name (ARN)
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
