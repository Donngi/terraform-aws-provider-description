#---------------------------------------------------------------
# AWS Redshift Snapshot Copy Grant
#---------------------------------------------------------------
#
# Amazon Redshift がコピー先リージョンで暗号化されたスナップショットをコピーする際に
# 使用する AWS KMS キーへのアクセスを許可するスナップショットコピーグラントを
# プロビジョニングするリソースです。
#
# グラントはクラスターが存在するリージョンではなく、コピー先リージョンに
# 作成する必要があります。KMS 暗号化クラスターのクロスリージョンスナップショット
# コピーを有効にするために使用します。
#
# AWS公式ドキュメント:
#   - KMS暗号化クラスターのクロスリージョンスナップショットコピー設定:
#       https://docs.aws.amazon.com/redshift/latest/mgmt/xregioncopy-kms-encrypted-snapshot.html
#   - Amazon Redshift データベース暗号化:
#       https://docs.aws.amazon.com/redshift/latest/mgmt/working-with-db-encryption.html
#   - CreateSnapshotCopyGrant API:
#       https://docs.aws.amazon.com/redshift/latest/APIReference/API_CreateSnapshotCopyGrant.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/redshift_snapshot_copy_grant
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_redshift_snapshot_copy_grant" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # snapshot_copy_grant_name (Required, Forces new resource)
  # 設定内容: スナップショットコピーグラントの一意の名前を指定します。
  # 設定可能な値: 1〜255文字の英数字、ハイフン（-）を含む文字列。
  #              先頭はアルファベット、末尾はハイフン不可、連続ハイフン不可。
  # 参考: https://docs.aws.amazon.com/redshift/latest/APIReference/API_CreateSnapshotCopyGrant.html
  snapshot_copy_grant_name = "my-snapshot-copy-grant"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  #          グラントはコピー先リージョンに作成する必要があるため、
  #          クラスターが存在するリージョンとは異なるリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: us-east-1, eu-west-1）
  # 省略時: プロバイダー設定で指定されたリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # 暗号化設定
  #-------------------------------------------------------------

  # kms_key_id (Optional, Forces new resource)
  # 設定内容: コピースナップショットの暗号化に使用する KMS キーの識別子を指定します。
  # 設定可能な値:
  #   - KMS キー ID（例: "1234abcd-12ab-34cd-56ef-1234567890ab"）
  #   - KMS キー ARN（例: "arn:aws:kms:us-east-1:123456789012:key/1234abcd-..."）
  #   - 別の AWS アカウントのキーを指定する場合はキー ARN を使用
  # 省略時: コピー先リージョンのデフォルト KMS キー（aws/redshift）を使用
  # 参考: https://docs.aws.amazon.com/redshift/latest/mgmt/working-with-db-encryption.html
  kms_key_id = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値の文字列ペアのマップ
  # 省略時: タグなし
  # 注意: プロバイダーレベルの default_tags 設定ブロックで定義されたタグと
  #      一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "my-snapshot-copy-grant"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: スナップショットコピーグラントの Amazon Resource Name (ARN)
#
# - tags_all: プロバイダーの default_tags 設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
