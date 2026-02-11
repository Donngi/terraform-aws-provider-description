#---------------------------------------------------------------
# SageMaker AI Project
#---------------------------------------------------------------
#
# Amazon SageMaker AI Projectリソースをプロビジョニングします。
# SageMaker Projectsは、CI/CDを活用したエンドツーエンドのMLOps自動化を
# 実現する機能で、モデルの構築・トレーニング・デプロイメントといった
# ML ライフサイクル全体を統合管理するためのコンテナ化された環境を提供します。
#
# AWS Service Catalogと統合されており、あらかじめ構成されたプロジェクト
# テンプレートを使用することで、標準化されたMLワークフローを迅速に
# セットアップできます。
#
# AWS公式ドキュメント:
#   - MLOps Automation With SageMaker Projects: https://docs.aws.amazon.com/sagemaker/latest/dg/sagemaker-projects.html
#   - Create a MLOps Project: https://docs.aws.amazon.com/sagemaker/latest/dg/sagemaker-projects-create.html
#   - MLOps Project Templates: https://docs.aws.amazon.com/sagemaker/latest/dg/sagemaker-projects-templates.html
#   - Granting Studio Permissions for Projects: https://docs.aws.amazon.com/sagemaker/latest/dg/sagemaker-projects-studio-updates.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/sagemaker_project
#
# Provider Version: 6.28.0
# Generated: 2026-02-03
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
  # 設定内容: SageMaker AI Projectの名前を指定します。
  # 設定可能な値: AWSアカウント内で一意な文字列
  # 注意: プロジェクト名はAWSアカウント・リージョン内で一意である必要があります。
  project_name = "example-mlops-project"

  # project_description (Optional)
  # 設定内容: プロジェクトの説明を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: 説明なしでプロジェクトが作成されます。
  # 用途: SageMaker Studio UIやコンソール上でプロジェクトを識別する際に表示されます。
  project_description = "Example MLOps project for model building and deployment"

  # id (Optional)
  # 設定内容: Terraformが使用するリソースの識別子を明示的に指定します。
  # 設定可能な値: 文字列
  # 省略時: Terraformが自動的にproject_nameの値を使用します。
  # 注意: 通常は指定不要です。主にインポート時や特殊なケースで使用されます。
  # id = "example-mlops-project"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースが管理されるAWSリージョンを明示的に指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンが使用されます。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなしでリソースが作成されます。
  # 関連機能: SageMaker Studio プロジェクト可視性
  #   SageMaker Studioでプロジェクトを使用する場合、
  #   `sagemaker:studio-visibility` タグをtrueに設定する必要があります。
  #   - https://docs.aws.amazon.com/sagemaker/latest/dg/sagemaker-projects-templates-custom.html
  # 注意: プロバイダーのdefault_tagsと一致するキーを持つタグは、
  #       プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Environment                       = "development"
    Project                           = "mlops"
    ManagedBy                         = "terraform"
    "sagemaker:studio-visibility"     = "true"
  }

  # tags_all (Optional)
  # 設定内容: プロバイダーのdefault_tagsと明示的に指定したtagsを統合した全タグのマップです。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: Terraformが自動的に計算します。
  # 注意: 通常はTerraformが自動的に計算するため指定不要です。
  #       明示的に全タグを管理したい場合に使用できます。
  # tags_all = {
  #   Environment                   = "development"
  #   Project                       = "mlops"
  #   ManagedBy                     = "terraform"
  #   "sagemaker:studio-visibility" = "true"
  # }

  #-------------------------------------------------------------
  # Service Catalog プロビジョニング設定
  #-------------------------------------------------------------

  # service_catalog_provisioning_details (Required)
  # 設定内容: AWS Service Catalogを使用したプロビジョニング詳細を指定します。
  # 関連機能: SageMaker Projects と Service Catalog統合
  #   SageMaker Projectsは内部的にAWS Service Catalogと統合されており、
  #   あらかじめ定義されたプロジェクトテンプレート（製品）を使用して
  #   MLワークフローに必要なリソースを自動的にプロビジョニングします。
  #   - https://docs.aws.amazon.com/sagemaker/latest/dg/sagemaker-projects-templates.html
  service_catalog_provisioning_details {

    # product_id (Required)
    # 設定内容: プロビジョニングするService Catalog製品のIDを指定します。
    # 設定可能な値: 有効なService Catalog製品ID（形式: prod-xxxxxxxxxxxxx）
    # 用途: SageMaker提供のテンプレートまたはカスタムテンプレートの製品IDを指定します。
    product_id = "prod-example123456789"

    # path_id (Optional)
    # 設定内容: Service Catalog製品のパス識別子を指定します。
    # 設定可能な値: 有効なService Catalogパスの識別子
    # 省略時: 製品のデフォルトパスが使用されます。
    # 注意: 製品が複数のパスを持つ場合は必須です。
    #       製品にデフォルトパスが設定されている場合は省略可能です。
    # path_id = "pa-example123456789"

    # provisioning_artifact_id (Optional)
    # 設定内容: 使用するプロビジョニングアーティファクト（バージョン）のIDを指定します。
    # 設定可能な値: 有効なプロビジョニングアーティファクトID
    # 省略時: 製品のデフォルトバージョンが使用されます。
    # provisioning_artifact_id = "pa-artifact123456789"

    # provisioning_parameter (Optional)
    # 設定内容: Service Catalog製品をプロビジョニングする際に渡すキー・バリュー
    #          パラメータのリストを指定します。
    # 設定可能な値: 製品テンプレートで定義されたパラメータに対応するキーと値のペア
    # 省略時: パラメータなしでプロビジョニングが実行されます。
    # 用途: S3バケット名、IAMロールARN、VPC ID、サブネットIDなど、
    #      テンプレートが要求するパラメータを指定します。
    provisioning_parameter {
      # key (Required)
      # 設定内容: プロビジョニングパラメータを識別するキーを指定します。
      # 設定可能な値: Service Catalog製品テンプレートで定義されたパラメータ名
      # 注意: テンプレートで定義されたパラメータ名と正確に一致する必要があります。
      key = "SourceModelPackageGroupName"

      # value (Optional)
      # 設定内容: パラメータに設定する値を指定します。
      # 設定可能な値: パラメータの仕様に応じた文字列
      # 省略時: 空の値が設定されます。
      value = "example-model-package-group"
    }

    # 複数のパラメータを指定する例
    # provisioning_parameter {
    #   key   = "ModelApprovalStatus"
    #   value = "Approved"
    # }
    #
    # provisioning_parameter {
    #   key   = "PipelineExecutionRoleArn"
    #   value = "arn:aws:iam::123456789012:role/SageMakerPipelineRole"
    # }
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn
#   AWSによって割り当てられたプロジェクトのAmazon Resource Name (ARN)。
#   形式: arn:aws:sagemaker:<region>:<account-id>:project/<project-name>
#   例: aws_sagemaker_project.example.arn
#
# - project_id
#   AWSによって割り当てられたプロジェクトのID。
#   形式: p-xxxxxxxxxxxxxx
#   例: aws_sagemaker_project.example.project_id
#
# - id
#   プロジェクトの識別子。通常はproject_nameと同じ値が自動設定されます。
#   例: aws_sagemaker_project.example.id
#
# - region
#   リソースが管理されているAWSリージョン。
#   明示的に指定しない場合は、プロバイダー設定のリージョンが自動設定されます。
#   例: aws_sagemaker_project.example.region
#
# - tags_all
#   プロバイダーのdefault_tagsと明示的に指定したtagsを統合した全タグのマップ。
#   例: aws_sagemaker_project.example.tags_all
#---------------------------------------------------------------

# 出力例
# output "sagemaker_project_arn" {
#   description = "The ARN of the SageMaker Project"
#   value       = aws_sagemaker_project.example.arn
# }
#
# output "sagemaker_project_id" {
#   description = "The ID of the SageMaker Project"
#   value       = aws_sagemaker_project.example.project_id
# }
