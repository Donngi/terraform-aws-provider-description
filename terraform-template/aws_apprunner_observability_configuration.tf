#---------------------------------------------------------------
# AWS App Runner Observability Configuration
#---------------------------------------------------------------
#
# AWS App Runnerのオブザーバビリティ設定をプロビジョニングするリソースです。
# オブザーバビリティ設定は、App Runnerサービスのトレーシング機能を構成するための
# 共有可能なリソースで、複数のサービス間で一貫したオブザーバビリティ設定を
# 維持するために使用できます。
#
# AWS公式ドキュメント:
#   - App Runnerオブザーバビリティ設定: https://docs.aws.amazon.com/apprunner/latest/dg/manage-configure-observability.html
#   - X-Rayトレーシング: https://docs.aws.amazon.com/apprunner/latest/dg/monitor-xray.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apprunner_observability_configuration
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_apprunner_observability_configuration" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # observability_configuration_name (Required, Forces new resource)
  # 設定内容: オブザーバビリティ設定の名前を指定します。
  # 設定可能な値: 任意の文字列
  # 注意: 同じ名前で複数回作成すると、新しいリビジョンが作成されます。
  observability_configuration_name = "example-observability-config"

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
  # トレース設定
  #-------------------------------------------------------------

  # trace_configuration (Optional)
  # 設定内容: オブザーバビリティ設定内のトレーシング機能の設定を指定します。
  # 省略時: App Runnerはトレーシングを有効化しません。
  # 関連機能: AWS X-Ray トレーシング
  #   App RunnerサービスをAWS X-Rayと統合し、リクエストのトレースと
  #   ダウンストリーム呼び出しの可視化を実現します。
  #   X-Rayを使用するには、インスタンスロールにAWSXRayDaemonWriteAccessポリシーが必要です。
  #   - https://docs.aws.amazon.com/apprunner/latest/dg/monitor-xray.html
  trace_configuration {
    # vendor (Optional)
    # 設定内容: App Runnerサービスのトレーシング実装プロバイダーを指定します。
    # 設定可能な値:
    #   - "AWSXRAY": AWS X-Rayをトレーシングプロバイダーとして使用
    # 注意: 現時点ではAWSXRAYのみがサポートされています。
    vendor = "AWSXRAY"
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
  tags = {
    Name        = "example-apprunner-observability-configuration"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: オブザーバビリティ設定のAmazon Resource Name (ARN)
#
# - observability_configuration_revision: オブザーバビリティ設定のリビジョン番号
#
# - latest: このオブザーバビリティ設定が、同じ名前を共有するすべての設定の中で
#           最も高いリビジョン番号を持つかどうかを示すブール値
#
# - status: オブザーバビリティ設定の現在の状態
#           INACTIVE状態の設定リビジョンは削除されており、使用できません。
#           削除後しばらくすると完全に削除されます。
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
