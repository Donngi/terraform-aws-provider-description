#---------------------------------------------------------------
# Amazon DataZone Environment Blueprint Configuration
#---------------------------------------------------------------
#
# Amazon DataZone環境ブループリント設定を管理するリソースです。
# データレイク、データウェアハウス、SageMakerなどの環境ブループリントを有効化し、
# デプロイ先のリージョンやIAMロール、パラメータを設定します。
#
# 主な用途:
#   - DataZone環境ブループリントの有効化と設定
#   - ブループリントのデプロイ対象リージョンの指定
#   - プロビジョニングおよびアクセス管理用IAMロールの設定
#   - リージョン固有パラメータの管理
#
# 注意点:
#   - domain_id、environment_blueprint_id、enabled_regionsは必須項目です
#   - ブループリントの種類に応じて適切なIAMロールとパラメータを設定する必要があります
#   - 有効化されたブループリントは環境プロファイル作成時に使用可能になります
#   - regional_parametersはリージョンごとの設定値をネストしたマップ形式で指定します
#
# AWS公式ドキュメント:
#   - ブループリントの使用: https://docs.aws.amazon.com/datazone/latest/userguide/working-with-blueprints.html
#   - API リファレンス: https://docs.aws.amazon.com/datazone/latest/APIReference/API_PutEnvironmentBlueprintConfiguration.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/datazone_environment_blueprint_configuration
#
# Provider Version: 6.28.0
# Generated: 2026-02-14
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

#-------------------------------------------------------------------------------------------------------
# 基本設定
#-------------------------------------------------------------------------------------------------------
resource "aws_datazone_environment_blueprint_configuration" "example" {
  # 設定内容: DataZoneドメインのID
  # 参照方法: aws_datazone_domain.example.id で取得可能
  domain_id = "dzd_abc123xyz456"

  # 設定内容: 環境ブループリントのID
  # 設定可能な値:
  #   - "dzb_abc123" (Data Lake blueprint)
  #   - "dzb_xyz456" (Data Warehouse blueprint)
  #   - "dzb_sagemaker789" (SageMaker blueprint)
  # 参照方法: aws_datazone_environment_blueprint.example.id で取得可能
  environment_blueprint_id = "dzb_abc123xyz456"

  # 設定内容: ブループリントを有効化するAWSリージョンのリスト
  # 設定例: ["us-east-1", "ap-northeast-1"]
  # 注意: 最低1つのリージョンを指定する必要があります
  enabled_regions = ["us-east-1"]

  #-------------------------------------------------------------------------------------------------------
  # IAMロール設定
  #-------------------------------------------------------------------------------------------------------
  # 設定内容: DataZoneがリソースへのアクセスを管理するためのIAMロールARN
  # 用途: AWS Glue、Lake Formation、Redshift、SageMakerなどへのアクセス管理
  # 設定例: "arn:aws:iam::123456789012:role/DataZoneManageAccessRole"
  # 省略時: ブループリントの種類に応じたデフォルト動作が適用されます
  manage_access_role_arn = "arn:aws:iam::123456789012:role/DataZoneManageAccessRole"

  # 設定内容: DataZoneが環境をプロビジョニングするためのIAMロールARN
  # 用途: 環境リソースの作成・削除権限を持つロール
  # 設定例: "arn:aws:iam::123456789012:role/DataZoneProvisioningRole"
  # 省略時: ブループリントの種類に応じたデフォルト動作が適用されます
  provisioning_role_arn = "arn:aws:iam::123456789012:role/DataZoneProvisioningRole"

  #-------------------------------------------------------------------------------------------------------
  # リージョン固有パラメータ
  #-------------------------------------------------------------------------------------------------------
  # 設定内容: リージョンごとの設定パラメータをネストしたマップ形式で指定
  # 構造: map[region][parameter_name] = parameter_value
  # 設定例:
  #   Data Warehouse: Redshiftクラスタ情報、データベース名、シークレットARNなど
  #   SageMaker: VPC設定、セキュリティグループ、KMSキー、データソース情報など
  # 省略時: リージョン固有パラメータなしで動作します
  regional_parameters = {
    "us-east-1" = {
      "redshiftClusterName" = "my-redshift-cluster"
      "databaseName"        = "my_database"
      "secretArn"           = "arn:aws:secretsmanager:us-east-1:123456789012:secret:datazone-secret"
    }
    "ap-northeast-1" = {
      "vpcId"            = "vpc-abc123"
      "subnetIds"        = "subnet-123,subnet-456"
      "securityGroupIds" = "sg-789"
      "kmsKeyId"         = "arn:aws:kms:ap-northeast-1:123456789012:key/abc-def-123"
    }
  }

  #-------------------------------------------------------------------------------------------------------
  # リージョン設定（管理用）
  #-------------------------------------------------------------------------------------------------------
  # 設定内容: このリソースが管理されるAWSリージョン
  # 省略時: プロバイダー設定のリージョンが使用されます
  # 注意: この設定はリソースの管理リージョンであり、enabled_regionsとは異なります
  region = "us-east-1"
}

#-------------------------------------------------------------------------------------------------------
# Attributes Reference（参照可能な属性）
#-------------------------------------------------------------------------------------------------------
# ブループリント設定作成後に参照可能な属性:
#
# domain_id                  - DataZoneドメインのID
# environment_blueprint_id   - 環境ブループリントのID
# enabled_regions           - 有効化されたリージョンのリスト
# manage_access_role_arn    - アクセス管理用IAMロールのARN
# provisioning_role_arn     - プロビジョニング用IAMロールのARN
# regional_parameters       - リージョン固有パラメータのマップ
# region                    - リソースが管理されているリージョン
#
# 参照例:
#   output "blueprint_config_id" {
#     value = aws_datazone_environment_blueprint_configuration.example.environment_blueprint_id
#   }
#
#-------------------------------------------------------------------------------------------------------
