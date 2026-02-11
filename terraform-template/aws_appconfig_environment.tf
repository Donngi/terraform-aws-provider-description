#---------------------------------------------------------------
# AWS AppConfig Environment
#---------------------------------------------------------------
#
# AWS AppConfigアプリケーション用の環境リソースをプロビジョニングします。
# 環境は、開発、ステージング、本番など、アプリケーションの論理的な
# デプロイメントターゲットを表します。1つのアプリケーションに対して
# 複数の環境を定義できます。
#
# AWS公式ドキュメント:
#   - AppConfig概要: https://docs.aws.amazon.com/appconfig/latest/userguide/what-is-appconfig.html
#   - デプロイの監視と自動ロールバック: https://docs.aws.amazon.com/appconfig/latest/userguide/monitoring-deployments.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appconfig_environment
#
# Provider Version: 6.28.0
# Generated: 2026-01-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_appconfig_environment" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # application_id (Required, Forces new resource)
  # 設定内容: AppConfigアプリケーションのIDを指定します。
  # 設定可能な値: 4〜7文字のアプリケーションID
  # 注意: aws_appconfig_applicationリソースのidを参照することが一般的
  application_id = aws_appconfig_application.example.id

  # name (Required)
  # 設定内容: 環境の名前を指定します。
  # 設定可能な値: 1〜64文字の文字列
  # 用途: 開発環境、ステージング環境、本番環境などを識別するために使用
  name = "production"

  # description (Optional)
  # 設定内容: 環境の説明を指定します。
  # 設定可能な値: 最大1024文字の文字列
  # 用途: 環境の目的や特性を記述
  description = "Production environment for application configuration deployment"

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
  # モニタリング設定
  #-------------------------------------------------------------

  # monitor (Optional)
  # 設定内容: デプロイメントプロセス中に監視するAmazon CloudWatchアラームを指定します。
  # 設定可能な値: 最大5つのmonitorブロック
  # 関連機能: AppConfig自動ロールバック
  #   デプロイ中にCloudWatchアラームがALARMまたはINSUFFICIENT_DATA状態になると、
  #   AppConfigは自動的に設定データを以前のバージョンにロールバックします。
  #   - https://docs.aws.amazon.com/appconfig/latest/userguide/monitoring-deployments.html
  # 推奨メトリクス:
  #   - API Gateway: 4XXError, 5XXError, Latency
  #   - Lambda: Errors, Throttles
  #   - EC2/ECS/EKS: CPUUtilization, memory_utilization
  monitor {
    # alarm_arn (Required)
    # 設定内容: 監視するAmazon CloudWatchアラームのARNを指定します。
    # 設定可能な値: 有効なCloudWatchアラームARN
    # 用途: デプロイメント中のアプリケーション健全性を監視
    alarm_arn = aws_cloudwatch_metric_alarm.example.arn

    # alarm_role_arn (Optional)
    # 設定内容: AppConfigがalarm_arnを監視するためのIAMロールのARNを指定します。
    # 設定可能な値: 有効なIAMロールARN
    # 省略時: AppConfigサービスリンクロールが使用される
    # 用途: クロスアカウントアラーム監視や特定の権限が必要な場合に使用
    alarm_role_arn = aws_iam_role.appconfig_alarm_role.arn
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "production-environment"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: AppConfig環境のAmazon Resource Name (ARN)
#
# - environment_id: AppConfig環境のID
#
# - id: (非推奨) AppConfig環境IDとアプリケーションIDをコロン(:)で区切った値
#
# - state: 環境の状態。以下の値が可能:
#   - READY_FOR_DEPLOYMENT: デプロイ準備完了
#   - DEPLOYING: デプロイ中
#   - ROLLING_BACK: ロールバック中
#   - ROLLED_BACK: ロールバック完了
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
