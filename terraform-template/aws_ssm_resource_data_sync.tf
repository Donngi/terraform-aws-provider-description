#---------------------------------------------------------------
# AWS SSM Resource Data Sync
#---------------------------------------------------------------
#
# AWS Systems Manager Resource Data Syncをプロビジョニングするリソースです。
# Resource Data Syncは、複数のAWSリージョンやアカウントから
# インベントリデータやOpsDataを集約し、Amazon S3バケットに
# 同期する機能を提供します。
#
# AWS公式ドキュメント:
#   - Resource Data Syncを使用したインベントリデータの集約: https://docs.aws.amazon.com/systems-manager/latest/userguide/inventory-resource-data-sync.html
#   - CreateResourceDataSync API: https://docs.aws.amazon.com/systems-manager/latest/APIReference/API_CreateResourceDataSync.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_resource_data_sync
#
# Provider Version: 6.28.0
# Generated: 2026-02-09
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ssm_resource_data_sync" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: Resource Data Sync設定の名前を指定します。
  # 設定可能な値: 文字列
  name = "my-resource-data-sync"

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
  # S3同期先設定
  #-------------------------------------------------------------

  # s3_destination (Required)
  # 設定内容: 同期データの保存先となるAmazon S3の設定を指定します。
  s3_destination {

    # bucket_name (Required)
    # 設定内容: 同期データの保存先S3バケット名を指定します。
    # 設定可能な値: 有効なS3バケット名
    # 注意: バケットポリシーでSSMサービス（ssm.amazonaws.com）からの
    #       s3:GetBucketAcl および s3:PutObject アクションを許可する必要があります。
    bucket_name = "my-ssm-resource-data-sync-bucket"

    # region (Required)
    # 設定内容: S3バケットが存在するリージョンを指定します。
    # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
    # 注意: 同期元とバケットが異なるリージョンの場合、データ転送料金が発生する可能性があります。
    region = "ap-northeast-1"

    # kms_key_arn (Optional)
    # 設定内容: 同期データの暗号化に使用するKMSキーのARNを指定します。
    # 設定可能な値: 有効なKMSキーARN
    # 省略時: S3のデフォルト暗号化設定に従います。
    # 関連機能: AWS KMSによるResource Data Sync暗号化
    #   KMSキーを使用して同期されたインベントリデータを暗号化できます。
    #   暗号化されたデータを参照するにはKMSキーへのアクセス権限が必要です。
    #   - https://docs.aws.amazon.com/systems-manager/latest/userguide/inventory-resource-data-sync.html
    kms_key_arn = null

    # prefix (Optional)
    # 設定内容: S3バケット内で同期データを保存するプレフィックス（パス）を指定します。
    # 設定可能な値: 文字列（S3オブジェクトキーのプレフィックス）
    # 省略時: バケットのルートにデータが保存されます。
    prefix = null

    # sync_format (Optional)
    # 設定内容: 同期データのフォーマットを指定します。
    # 設定可能な値:
    #   - "JsonSerDe": JSON形式（Amazon Athenaでのクエリに対応）
    # 省略時: JsonSerDe
    sync_format = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: Resource Data Syncの名前
#---------------------------------------------------------------
