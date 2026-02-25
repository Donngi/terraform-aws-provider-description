#---------------------------------------------------------------
# AWS Redshift Snapshot Copy
#---------------------------------------------------------------
#
# Amazon Redshiftクラスターのスナップショットを別のAWSリージョンへ
# 自動コピーする設定をプロビジョニングするリソースです。
# クロスリージョンスナップショットコピーを有効にすることで、
# データの冗長性確保やディザスタリカバリを実現できます。
#
# AWS公式ドキュメント:
#   - クロスリージョンスナップショットコピー: https://docs.aws.amazon.com/redshift/latest/mgmt/cross-region-snapshot-copy.html
#   - 非暗号化クラスターの設定: https://docs.aws.amazon.com/redshift/latest/mgmt/snapshot-crossregioncopy-configure.html
#   - KMS暗号化クラスターの設定: https://docs.aws.amazon.com/redshift/latest/mgmt/xregioncopy-kms-encrypted-snapshot.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/redshift_snapshot_copy
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_redshift_snapshot_copy" "example" {
  #-------------------------------------------------------------
  # クラスター設定
  #-------------------------------------------------------------

  # cluster_identifier (Required)
  # 設定内容: スナップショットコピーの対象となるソースクラスターの識別子を指定します。
  # 設定可能な値: 既存のRedshiftクラスター識別子（文字列）
  cluster_identifier = "my-redshift-cluster"

  #-------------------------------------------------------------
  # コピー先リージョン設定
  #-------------------------------------------------------------

  # destination_region (Required)
  # 設定内容: スナップショットのコピー先AWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, eu-west-1）
  # 注意: コピー先リージョンを変更するには、一度この設定を無効にしてから再度有効化する必要があります。
  # 参考: https://docs.aws.amazon.com/redshift/latest/mgmt/cross-region-snapshot-copy.html
  destination_region = "us-east-1"

  #-------------------------------------------------------------
  # スナップショット保持期間設定
  #-------------------------------------------------------------

  # retention_period (Optional)
  # 設定内容: コピー先リージョンで自動スナップショットを保持する日数を指定します。
  # 設定可能な値: 正の整数（日数）
  # 省略時: ソースリージョンのデフォルト保持期間（7日）が適用されます。
  # 参考: https://docs.aws.amazon.com/redshift/latest/mgmt/cross-region-snapshot-copy.html
  retention_period = 7

  # manual_snapshot_retention_period (Optional)
  # 設定内容: コピー先リージョンで手動スナップショットを保持する日数を指定します。
  # 設定可能な値:
  #   - 正の整数（日数）
  #   - -1: 手動スナップショットを無期限に保持します。
  # 省略時: ソースリージョンの手動スナップショット保持期間が適用されます。
  # 参考: https://docs.aws.amazon.com/redshift/latest/APIReference/API_EnableSnapshotCopy.html
  manual_snapshot_retention_period = -1

  #-------------------------------------------------------------
  # 暗号化設定
  #-------------------------------------------------------------

  # snapshot_copy_grant_name (Optional)
  # 設定内容: AWS KMS暗号化クラスターのスナップショットをコピー先リージョンにコピーする際に
  #           使用するスナップショットコピーグラントの名前を指定します。
  # 設定可能な値: 有効なスナップショットコピーグラント名（文字列）
  # 省略時: null（暗号化されていないクラスターの場合は不要）
  # 注意: KMS暗号化クラスターのスナップショットをコピーする場合は、
  #       コピー先リージョンでスナップショットコピーグラントを事前に作成する必要があります。
  # 参考: https://docs.aws.amazon.com/redshift/latest/mgmt/xregioncopy-kms-encrypted-snapshot.html
  snapshot_copy_grant_name = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: ソースクラスターの識別子。
#---------------------------------------------------------------
