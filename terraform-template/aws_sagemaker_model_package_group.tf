#---------------------------------------------------------------
# AWS SageMaker Model Package Group
#---------------------------------------------------------------
#
# Amazon SageMaker Model Registryのモデルパッケージグループをプロビジョニングするリソースです。
# モデルパッケージグループは、同一モデルの異なるバージョン（モデルパッケージ）を
# バージョン番号付きでまとめて管理するためのコンテナです。
# モデルのバージョン管理、承認ワークフロー、デプロイ管理に使用されます。
#
# AWS公式ドキュメント:
#   - Model Groupの作成: https://docs.aws.amazon.com/sagemaker/latest/dg/model-registry-model-group.html
#   - Model Registry概要: https://docs.aws.amazon.com/sagemaker/latest/dg/model-registry-models.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sagemaker_model_package_group
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_sagemaker_model_package_group" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # model_package_group_name (Required, Forces new resource)
  # 設定内容: モデルパッケージグループの名前を指定します。
  # 設定可能な値: 英数字およびハイフンで構成される文字列（最大63文字）
  # 参考: https://docs.aws.amazon.com/sagemaker/latest/dg/model-registry-model-group.html
  model_package_group_name = "example-model-group"

  # model_package_group_description (Optional)
  # 設定内容: モデルパッケージグループの説明を指定します。
  # 設定可能な値: 文字列（最大1024文字）
  # 省略時: 説明なし
  model_package_group_description = "機械学習モデルのバージョン管理グループ"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
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
  # 省略時: タグなし
  # 注意: プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-model-group"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: モデルパッケージグループの名前
# - arn: モデルパッケージグループに割り当てられたAmazon Resource Name (ARN)
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
