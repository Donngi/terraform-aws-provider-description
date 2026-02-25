#---------------------------------------------------------------
# AWS SageMaker Project
#---------------------------------------------------------------
#
# Amazon SageMaker AIのプロジェクトをプロビジョニングするリソースです。
# SageMaker Projectは、AWS Service Catalogと連携してMLOpsテンプレートを
# 活用し、機械学習ライフサイクル全体の管理・自動化を実現します。
# データサイエンティストとMLエンジニアがCI/CDパイプラインを含む
# 標準化された環境でコラボレーションするための基盤となります。
#
# 注意: SageMaker Studioでプロジェクト機能を使用するには、
# `sagemaker:studio-visibility` = `true` のタグを付与する必要があります。
#
# AWS公式ドキュメント:
#   - SageMaker Projects概要: https://docs.aws.amazon.com/sagemaker/latest/dg/sagemaker-projects-templates.html
#   - カスタムプロジェクトテンプレート: https://docs.aws.amazon.com/sagemaker/latest/dg/sagemaker-projects-templates-custom.html
#   - ServiceCatalogProvisioningDetails API: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_ServiceCatalogProvisioningDetails.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sagemaker_project
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_sagemaker_project" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # project_name (Required)
  # 設定内容: SageMakerプロジェクトの名前を指定します。
  # 設定可能な値: 英数字、ハイフンを使用した文字列
  project_name = "my-sagemaker-project"

  # project_description (Optional)
  # 設定内容: プロジェクトの説明を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: 説明なしでプロジェクトが作成されます。
  project_description = "MLOpsパイプラインを管理するプロジェクト"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # Service Catalog プロビジョニング設定
  #-------------------------------------------------------------

  # service_catalog_provisioning_details (Required)
  # 設定内容: Service CatalogプロダクトのプロビジョニングにかかわるIDと
  #           成果物IDを指定する設定ブロックです。プロジェクト作成時に
  #           Service Catalogプロダクトをプロビジョニングするために使用します。
  # 参考: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_ServiceCatalogProvisioningDetails.html
  service_catalog_provisioning_details {

    # product_id (Required)
    # 設定内容: プロビジョニングするService CatalogプロダクトのIDを指定します。
    # 設定可能な値: 英数字、アンダースコア、ハイフンを含む1〜100文字の文字列
    #              パターン: [a-zA-Z0-9_\-]*
    product_id = "prod-xxxxxxxxxxxx"

    # path_id (Optional)
    # 設定内容: プロダクトのパス識別子を指定します。
    # 設定可能な値: 英数字、アンダースコア、ハイフンを含む1〜100文字の文字列
    #              パターン: [a-zA-Z0-9_\-]*
    # 省略時: プロダクトにデフォルトパスが存在する場合は省略可能です。
    # 注意: プロダクトに複数のパスが存在する場合は指定が必須です。
    path_id = null

    # provisioning_artifact_id (Optional)
    # 設定内容: プロビジョニング成果物（プロビジョニングテンプレートのバージョン）のIDを指定します。
    # 設定可能な値: 英数字、アンダースコア、ハイフンを含む1〜100文字の文字列
    #              パターン: [a-zA-Z0-9_\-]*
    # 省略時: Terraformがデフォルトの成果物IDを自動的に取得して設定します。
    provisioning_artifact_id = null

    #-------------------------------------------------------------
    # プロビジョニングパラメーター設定
    #-------------------------------------------------------------

    # provisioning_parameter (Optional)
    # 設定内容: プロダクトのプロビジョニング時に渡すキーと値のペアを指定する
    #           設定ブロックです。複数のパラメーターを指定する場合は、
    #           ブロックを繰り返し記述します。
    provisioning_parameter {

      # key (Required)
      # 設定内容: プロビジョニングパラメーターを識別するキーを指定します。
      # 設定可能な値: 任意の文字列
      key = "GitBranch"

      # value (Optional)
      # 設定内容: プロビジョニングパラメーターの値を指定します。
      # 設定可能な値: 任意の文字列
      # 省略時: 値なしでパラメーターが設定されます。
      value = "main"
    }
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 注意: SageMaker Studioでプロジェクトを表示するには
  #       `sagemaker:studio-visibility` = `true` のタグが必要です。
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name                          = "my-sagemaker-project"
    Environment                   = "production"
    "sagemaker:studio-visibility" = "true"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: プロジェクトに割り当てられたAmazon Resource Name (ARN)
# - id: プロジェクトの名前
# - project_id: AWSが割り当てたプロジェクトの一意のID
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
