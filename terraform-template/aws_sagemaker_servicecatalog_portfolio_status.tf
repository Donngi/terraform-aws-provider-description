#---------------------------------------------------------------
# AWS SageMaker Service Catalog Portfolio Status
#---------------------------------------------------------------
#
# Amazon SageMaker における AWS Service Catalog ポートフォリオの有効・無効状態を
# 管理するリソースです。Service Catalog を有効化することで、SageMaker Studio から
# SageMaker プロジェクトを作成できるようになります。
#
# AWS公式ドキュメント:
#   - EnableSagemakerServicecatalogPortfolio API: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_EnableSagemakerServicecatalogPortfolio.html
#   - SageMaker Projects カスタムテンプレートの作成: https://docs.aws.amazon.com/sagemaker/latest/dg/sagemaker-projects-templates-custom.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sagemaker_servicecatalog_portfolio_status
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_sagemaker_servicecatalog_portfolio_status" "example" {
  #-------------------------------------------------------------
  # 有効化状態設定
  #-------------------------------------------------------------

  # status (Required)
  # 設定内容: SageMaker における Service Catalog ポートフォリオの有効・無効状態を指定します。
  # 設定可能な値:
  #   - "Enabled": Service Catalog を有効化します。SageMaker Studio からプロジェクトを
  #                作成する際に Service Catalog が利用可能になります。
  #   - "Disabled": Service Catalog を無効化します。
  status = "Enabled"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: Service Catalog ポートフォリオステータスが存在する AWS リージョン名。
#---------------------------------------------------------------
