#---------------------------------------------------------------
# AWS App Runner Default Auto Scaling Configuration Version
#---------------------------------------------------------------
#
# AWS App Runnerのデフォルトオートスケーリング設定を管理するリソースです。
# このリソースを作成または更新すると、既存のデフォルトオートスケーリング設定は
# 自動的に非デフォルトに設定されます。
# 設定された構成は、今後作成する新しいサービスのデフォルトとして自動的に割り当てられます。
# 既存のサービスに以前設定された関連付けには影響しません。
# 各アカウントは、リージョンごとに1つのデフォルトオートスケーリング設定のみを持つことができます。
#
# AWS公式ドキュメント:
#   - App Runnerオートスケーリング: https://docs.aws.amazon.com/apprunner/latest/dg/manage-autoscaling.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apprunner_default_auto_scaling_configuration_version
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_apprunner_default_auto_scaling_configuration_version" "example" {
  #-------------------------------------------------------------
  # オートスケーリング設定ARN
  #-------------------------------------------------------------

  # auto_scaling_configuration_arn (Required)
  # 設定内容: デフォルトとして設定するApp Runnerオートスケーリング設定のARNを指定します。
  # 設定可能な値: 有効なApp Runnerオートスケーリング設定のARN
  # 関連機能: App Runnerオートスケーリング
  #   オートスケーリング設定は、サービスの最小/最大インスタンス数や
  #   同時接続数の設定を定義します。aws_apprunner_auto_scaling_configuration_version
  #   リソースで作成した設定のARNを指定します。
  #   - https://docs.aws.amazon.com/apprunner/latest/dg/manage-autoscaling.html
  auto_scaling_configuration_arn = aws_apprunner_auto_scaling_configuration_version.example.arn

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: リソースの識別子
#---------------------------------------------------------------
