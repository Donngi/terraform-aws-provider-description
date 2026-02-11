#---------------------------------------------------------------
# AWS AppConfig Deployment
#---------------------------------------------------------------
#
# AWS AppConfigのデプロイメントをプロビジョニングするリソースです。
# AppConfigは設定データを管理・デプロイするためのサービスで、
# アプリケーションの設定を安全かつ段階的にデプロイできます。
# このリソースは、設定プロファイルの特定バージョンを環境にデプロイします。
#
# AWS公式ドキュメント:
#   - AppConfig概要: https://docs.aws.amazon.com/appconfig/latest/userguide/what-is-appconfig.html
#   - 設定のデプロイ: https://docs.aws.amazon.com/appconfig/latest/userguide/appconfig-deploying.html
#   - 事前定義デプロイ戦略: https://docs.aws.amazon.com/appconfig/latest/userguide/appconfig-creating-deployment-strategy-predefined.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appconfig_deployment
#
# Provider Version: 6.28.0
# Generated: 2026-01-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_appconfig_deployment" "example" {
  #-------------------------------------------------------------
  # 必須設定 - アプリケーション・環境・設定プロファイル
  #-------------------------------------------------------------

  # application_id (Required, Forces new resource)
  # 設定内容: デプロイ先のAppConfigアプリケーションIDを指定します。
  # 設定可能な値: 4-7文字のアプリケーションID
  # 取得方法: aws_appconfig_application リソースの id 属性から取得
  application_id = aws_appconfig_application.example.id

  # environment_id (Required, Forces new resource)
  # 設定内容: デプロイ先の環境IDを指定します。
  # 設定可能な値: 4-7文字の環境ID
  # 取得方法: aws_appconfig_environment リソースの environment_id 属性から取得
  environment_id = aws_appconfig_environment.example.environment_id

  # configuration_profile_id (Required, Forces new resource)
  # 設定内容: デプロイする設定プロファイルIDを指定します。
  # 設定可能な値: 4-7文字の設定プロファイルID
  # 取得方法: aws_appconfig_configuration_profile リソースの configuration_profile_id 属性から取得
  configuration_profile_id = aws_appconfig_configuration_profile.example.configuration_profile_id

  # configuration_version (Required, Forces new resource)
  # 設定内容: デプロイする設定のバージョン番号を指定します。
  # 設定可能な値: 最大1024文字の文字列
  # 取得方法: aws_appconfig_hosted_configuration_version リソースの version_number 属性から取得
  configuration_version = aws_appconfig_hosted_configuration_version.example.version_number

  #-------------------------------------------------------------
  # 必須設定 - デプロイ戦略
  #-------------------------------------------------------------

  # deployment_strategy_id (Required, Forces new resource)
  # 設定内容: 使用するデプロイ戦略のIDまたは事前定義戦略名を指定します。
  # 設定可能な値:
  #   - カスタム戦略: aws_appconfig_deployment_strategy リソースの id 属性
  #   - 事前定義戦略:
  #     - "AppConfig.Linear20PercentEvery6Minutes": 30分間で20%ずつ段階的にデプロイ（本番推奨）
  #     - "AppConfig.Canary10Percent20Minutes": 20分間で10%の成長率で指数的にデプロイ（本番推奨）
  #     - "AppConfig.AllAtOnce": 全ターゲットに即座にデプロイし10分間監視
  #     - "AppConfig.Linear50PercentEvery30Seconds": 30秒ごとに50%ずつデプロイ（テスト用）
  # 関連機能: AppConfig デプロイ戦略
  #   デプロイ中にCloudWatchアラームを監視し、問題があれば自動ロールバックを実行
  #   - https://docs.aws.amazon.com/appconfig/latest/userguide/appconfig-creating-deployment-strategy-predefined.html
  deployment_strategy_id = aws_appconfig_deployment_strategy.example.id

  #-------------------------------------------------------------
  # オプション設定
  #-------------------------------------------------------------

  # description (Optional, Forces new resource)
  # 設定内容: デプロイメントの説明を指定します。
  # 設定可能な値: 最大1024文字の文字列
  # 用途: デプロイの目的や変更内容を記録
  description = "My example deployment"

  # kms_key_identifier (Optional, Forces new resource)
  # 設定内容: 設定データの暗号化に使用するKMSキー識別子を指定します。
  # 設定可能な値:
  #   - KMSキーID
  #   - KMSキーエイリアス
  #   - KMSキーARN
  # 関連機能: AppConfig 暗号化
  #   カスタマー管理キーを使用して設定データを暗号化
  #   デプロイを開始するIAMプリンシパルには kms:GenerateDataKey 権限が必要
  #   - https://docs.aws.amazon.com/appconfig/latest/userguide/appconfig-deploying.html
  kms_key_identifier = aws_kms_key.example.arn

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
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルの default_tags 設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "example-deployment"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: アプリケーションID、環境ID、デプロイ番号をスラッシュ（/）で
#       区切った形式の識別子
#
# - arn: AppConfigデプロイメントのAmazon Resource Name (ARN)
#
# - deployment_number: デプロイメント番号（環境内での連番）
#
# - kms_key_arn: 設定データの暗号化に使用されるKMSキーのARN
#
# - state: デプロイメントの状態
#
# - tags_all: プロバイダーの default_tags 設定ブロックから継承された
#             タグを含む、リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
