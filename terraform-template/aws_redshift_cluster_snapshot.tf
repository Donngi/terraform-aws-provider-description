#---------------------------------------------------------------
# Amazon Redshift Cluster Snapshot
#---------------------------------------------------------------
#
# Amazon Redshiftクラスターの手動スナップショットをプロビジョニングするリソースです。
# スナップショットはクラスターのデータをAmazon S3に保存したポイントインタイムバックアップです。
# 手動スナップショットは明示的に削除するまで保持されます。
#
# AWS公式ドキュメント:
#   - スナップショットの作成: https://docs.aws.amazon.com/redshift/latest/mgmt/snapshot-create.html
#   - Amazon Redshiftのスナップショットとバックアップ: https://docs.aws.amazon.com/redshift/latest/mgmt/working-with-snapshots.html
#   - CreateClusterSnapshot API: https://docs.aws.amazon.com/redshift/latest/APIReference/API_CreateClusterSnapshot.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/redshift_cluster_snapshot
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_redshift_cluster_snapshot" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # cluster_identifier (Required, Forces new resource)
  # 設定内容: スナップショットを取得するクラスターの識別子を指定します。
  # 設定可能な値: 有効なRedshiftクラスター識別子
  # 注意: スナップショット作成時にクラスターが「available」状態である必要があります。
  cluster_identifier = "my-redshift-cluster"

  # snapshot_identifier (Required, Forces new resource)
  # 設定内容: スナップショットの一意な識別子を指定します。
  # 設定可能な値: 1～255文字の英数字またはハイフン。最初の文字は英字。
  #   末尾にハイフンを使用不可。2つの連続するハイフンは使用不可。
  # 注意: AWSアカウント内の全スナップショットで一意である必要があります。
  snapshot_identifier = "my-cluster-snapshot-20260218"

  #-------------------------------------------------------------
  # 保持期間設定
  #-------------------------------------------------------------

  # manual_snapshot_retention_period (Optional)
  # 設定内容: 手動スナップショットを保持する日数を指定します。
  # 設定可能な値:
  #   - -1: 無期限保持（デフォルト）
  #   - 1～3653: 保持する日数
  # 省略時: -1（無期限保持）
  # 参考: https://docs.aws.amazon.com/redshift/latest/mgmt/working-with-snapshots.html
  manual_snapshot_retention_period = -1

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
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  # 注意: プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "my-cluster-snapshot"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: スナップショットの一意な識別子（snapshot_identifierと同値）
# - arn: スナップショットのAmazon Resource Name (ARN)
# - kms_key_id: スナップショット取得元クラスターのデータ暗号化に使用された
#               KMS（Key Management Service）キーのID
# - owner_account: 手動スナップショットを作成またはコピーしたAWSアカウント。
#                  自動スナップショットの場合はクラスターのオーナーアカウント。
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
