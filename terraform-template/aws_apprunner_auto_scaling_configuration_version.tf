#---------------------------------------------------------------
# AWS App Runner Auto Scaling Configuration Version
#---------------------------------------------------------------
#
# AWS App Runnerのオートスケーリング設定バージョンをプロビジョニングするリソースです。
# オートスケーリング設定は、App Runnerサービスのスケーリング動作を制御し、
# 同時リクエスト数やインスタンス数の上下限を定義します。
#
# AWS公式ドキュメント:
#   - App Runner概要: https://docs.aws.amazon.com/apprunner/latest/dg/what-is-apprunner.html
#   - オートスケーリング設定: https://docs.aws.amazon.com/apprunner/latest/dg/manage-autoscaling.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apprunner_auto_scaling_configuration_version
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_apprunner_auto_scaling_configuration_version" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # auto_scaling_configuration_name (Required, Forces new resource)
  # 設定内容: オートスケーリング設定の名前を指定します。
  # 設定可能な値: 4-32文字の英数字、ハイフン、アンダースコア
  # 注意: 同じ名前で新しいリソースを作成すると、リビジョン番号が増加します。
  auto_scaling_configuration_name = "example-autoscaling-config"

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
  # スケーリング設定
  #-------------------------------------------------------------

  # max_concurrency (Optional, Forces new resource)
  # 設定内容: 1インスタンスが処理する最大同時リクエスト数を指定します。
  # 設定可能な値: 1 - 200
  # 省略時: 100
  # 動作: 同時リクエスト数がこの値を超えると、App Runnerはサービスを
  #       スケールアップします。
  # 関連機能: App Runner オートスケーリング
  #   同時リクエスト数に基づいて自動的にインスタンス数を調整します。
  #   - https://docs.aws.amazon.com/apprunner/latest/dg/manage-autoscaling.html
  max_concurrency = 50

  # max_size (Optional, Forces new resource)
  # 設定内容: App Runnerがプロビジョニングする最大インスタンス数を指定します。
  # 設定可能な値: 1 - 25
  # 省略時: 25
  # 注意: 高負荷時でもこの値を超えてスケールアウトしません。
  #       コスト管理やリソース制限の観点で適切な値を設定してください。
  max_size = 10

  # min_size (Optional, Forces new resource)
  # 設定内容: App Runnerがプロビジョニングする最小インスタンス数を指定します。
  # 設定可能な値: 1 - 25
  # 省略時: 1
  # 注意: この値を大きくするとコールドスタートを減らせますが、
  #       最低限のコストが増加します。
  min_size = 2

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
    Name        = "example-apprunner-autoscaling"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: このオートスケーリング設定バージョンのAmazon Resource Name (ARN)
#
# - auto_scaling_configuration_revision: このオートスケーリング設定のリビジョン番号
#        同じ名前で作成するたびにインクリメントされます。
#
# - has_associated_service: この設定に関連付けられたApp Runnerサービスが
#        存在するかどうかを示すブール値
#
# - is_default: このオートスケーリング設定がデフォルトかどうかを示すブール値
#
# - latest: このオートスケーリング設定が、同じ名前を共有するすべての設定の中で
#           最も高いリビジョン番号を持つかどうかを示すブール値
#
# - status: オートスケーリング設定の現在のステータス
#           INACTIVE状態の設定リビジョンは削除済みで使用できません。
#           削除後しばらくすると完全に削除されます。
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
