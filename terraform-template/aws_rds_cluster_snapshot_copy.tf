#---------------------------------------------------------------
# AWS RDS Cluster Snapshot Copy
#---------------------------------------------------------------
#
# Amazon RDS DB クラスタースナップショットのコピーを管理するリソースです。
# 既存の DB クラスタースナップショットを同一リージョン内または別のリージョンにコピーします。
# これにより、災害復旧、マルチリージョン戦略、データ移行などのユースケースに対応できます。
#
# 主な特徴:
#   - クロスリージョンコピーによる災害復旧対策の実現
#   - 暗号化されたスナップショットのコピーをサポート (異なる KMS キーでの再暗号化も可能)
#   - コピー元のタグを継承するオプション
#   - 他の AWS アカウントとスナップショットコピーを共有可能
#
# 注意事項:
#   - RDS DB インスタンスのスナップショットコピーには aws_db_snapshot_copy を使用してください
#   - クロスリージョンコピーを行う場合、destination_region と presigned_url の設定が必要になる場合があります
#   - 暗号化されたスナップショットをコピーする場合、適切な KMS キーへのアクセス権が必要です
#
# AWS公式ドキュメント:
#   - DB クラスタースナップショットのコピー: https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/USER_CopySnapshot.html
#   - クロスリージョンスナップショットコピー: https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/Aurora.Managing.Backups.html#Aurora.Managing.Backups.CrossRegion
#   - CopyDBClusterSnapshot API: https://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_CopyDBClusterSnapshot.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_snapshot_copy
#
# Provider Version: 6.28.0
# Generated: 2026-02-03
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_rds_cluster_snapshot_copy" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # source_db_cluster_snapshot_identifier (Required)
  # 設定内容: コピー元のスナップショット識別子を指定します。
  # 設定可能な値:
  #   - スナップショット識別子 (同一リージョンの場合)
  #   - スナップショット ARN (クロスリージョンコピーの場合)
  # 用途: コピー元となるスナップショットを特定
  # 注意:
  #   - 同一リージョン内のコピーの場合、識別子のみでも可能
  #   - クロスリージョンコピーの場合、完全な ARN が必要
  #   - 例: arn:aws:rds:us-east-1:123456789012:cluster-snapshot:snapshot-name
  # 関連機能: DB クラスタースナップショットのコピー
  #   コピー元スナップショットは available 状態である必要があります。
  #   - https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/USER_CopySnapshot.html
  source_db_cluster_snapshot_identifier = "arn:aws:rds:us-east-1:123456789012:cluster-snapshot:source-snapshot"

  # target_db_cluster_snapshot_identifier (Required)
  # 設定内容: 作成するスナップショットコピーの識別子を指定します。
  # 設定可能な値: 英数字とハイフンで構成される一意の名前
  # 制約:
  #   - 1-255 文字
  #   - 英字で始まる必要があります
  #   - 連続したハイフンは使用不可
  #   - リージョン内で一意である必要があります
  # 用途: スナップショットコピーを識別し、復元時に参照するための名前
  # 関連機能: スナップショット識別子の命名規則
  #   コピー先リージョンで一意の識別子を指定する必要があります。
  #   - https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/USER_CopySnapshot.html
  target_db_cluster_snapshot_identifier = "example-copy"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード (例: us-east-1, ap-northeast-1)
  # 省略時: プロバイダー設定のリージョンを使用
  # 用途: Terraform がこのリソースを管理する際に使用するリージョンを明示的に指定
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  # destination_region (Optional)
  # 設定内容: スナップショットコピーを配置する宛先リージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード (例: us-west-2, eu-west-1)
  # 省略時: 現在のリージョン (region で指定されたリージョン) にコピーされます
  # 用途: クロスリージョンコピーを実行する際の宛先リージョン指定
  # 注意:
  #   - クロスリージョンコピーを行う場合に設定
  #   - 同一リージョン内のコピーの場合は不要
  # 関連機能: クロスリージョンスナップショットコピー
  #   災害復旧やマルチリージョン戦略のため、別リージョンにスナップショットをコピー。
  #   - https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/Aurora.Managing.Backups.html#Aurora.Managing.Backups.CrossRegion
  destination_region = null

  #-------------------------------------------------------------
  # 暗号化設定
  #-------------------------------------------------------------

  # kms_key_id (Optional)
  # 設定内容: スナップショットコピーを暗号化する KMS キー ID を指定します。
  # 設定可能な値:
  #   - KMS キー ID
  #   - KMS キー ARN
  #   - KMS エイリアス名
  #   - KMS エイリアス ARN
  # 省略時:
  #   - コピー元が暗号化されている場合、同じ KMS キーで暗号化されます
  #   - コピー元が暗号化されていない場合、暗号化されません
  # 用途:
  #   - 暗号化されていないスナップショットを暗号化してコピー
  #   - 異なる KMS キーで再暗号化
  #   - クロスリージョンコピー時の宛先リージョンの KMS キー指定
  # 注意:
  #   - クロスリージョンコピーで暗号化する場合、宛先リージョンの KMS キーを指定する必要があります
  #   - KMS キーへの適切なアクセス権限が必要です (kms:CreateGrant, kms:Decrypt, kms:DescribeKey など)
  # 関連機能: Amazon RDS 暗号化
  #   スナップショットの暗号化により、保存データのセキュリティを強化。
  #   - https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/Overview.Encryption.html
  kms_key_id = null

  # presigned_url (Optional)
  # 設定内容: Signature Version 4 署名付きリクエストを含む URL を指定します。
  # 設定可能な値: 署名付き URL 文字列
  # 省略時: 通常は設定不要 (AWS SDK が自動生成)
  # 用途:
  #   - クロスリージョンコピー時に、コピー元リージョンでのアクセス認証に使用
  #   - 主に AWS SDK や CLI が内部的に使用
  # 注意:
  #   - 通常は明示的に設定する必要はありません
  #   - 特殊なクロスアカウント、クロスリージョンシナリオでのみ必要
  #   - URL の有効期限に注意が必要
  # 関連機能: 署名付き URL
  #   クロスリージョンリクエストの認証に使用される事前署名付き URL。
  #   - https://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_CopyDBClusterSnapshot.html
  presigned_url = null

  #-------------------------------------------------------------
  # タグとメタデータ設定
  #-------------------------------------------------------------

  # copy_tags (Optional)
  # 設定内容: コピー元スナップショットのタグをコピーするかどうかを指定します。
  # 設定可能な値:
  #   - true: コピー元のタグを継承
  #   - false: タグをコピーしない (デフォルト)
  # 省略時: false (タグはコピーされません)
  # 用途: コピー元スナップショットのタグ情報を保持
  # 注意:
  #   - tags パラメータで明示的に指定したタグは、コピー元のタグより優先されます
  #   - 同じキーがある場合、tags で指定した値で上書きされます
  # 関連機能: リソースタグ管理
  #   タグの継承により、一貫したリソース管理とコスト配分を実現。
  copy_tags = false

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 用途: リソースの分類、コスト配分、管理目的でタグを付与
  # 注意:
  #   - プロバイダーレベルの default_tags 設定ブロックで定義されたタグと
  #     一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします
  #   - copy_tags が true の場合でも、ここで指定したタグが優先されます
  # 関連機能: AWS リソースタグ付け
  #   タグを使用してリソースを整理し、コスト配分、アクセス制御などに活用。
  #   - https://docs.aws.amazon.com/general/latest/gr/aws_tagging.html
  tags = {
    Name        = "example-cluster-snapshot-copy"
    Environment = "production"
    Purpose     = "disaster-recovery"
    CopiedFrom  = "us-east-1"
  }

  #-------------------------------------------------------------
  # スナップショット共有設定
  #-------------------------------------------------------------

  # shared_accounts (Optional)
  # 設定内容: スナップショットコピーを共有する AWS アカウント ID のリストを指定します。
  # 設定可能な値:
  #   - AWS アカウント ID のリスト (例: ["123456789012", "234567890123"])
  #   - ["all"] を指定するとスナップショットを公開 (暗号化されていないスナップショットのみ)
  # 省略時: スナップショットはコピーを実行したアカウントのみがアクセス可能
  # 用途: 他の AWS アカウントとスナップショットコピーを共有してクロスアカウント復元を可能にする
  # 注意:
  #   - 暗号化されたスナップショットは公開 ("all") できません
  #   - 暗号化されたスナップショットを共有する場合、共有先アカウントに KMS キーへのアクセス権も付与する必要があります
  #   - 最大 20 アカウントまで共有可能
  # 関連機能: DB クラスタースナップショットの共有
  #   共有されたスナップショットから、認可されたアカウントは DB クラスターを復元可能。
  #   - https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/aurora-share-snapshot.html
  shared_accounts = null

  # tags_all (Optional, Computed)
  # 設定内容: プロバイダーの default_tags から継承されるタグを含む全タグのマップ
  # 注意: 通常は明示的に設定する必要はありません。Terraform が自動管理します
  tags_all = null

  # id (Optional, Computed)
  # 設定内容: リソースの ID。通常は target_db_cluster_snapshot_identifier と同じ値
  # 注意: 通常は明示的に設定する必要はありません。Terraform が自動管理します
  id = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - allocated_storage: 割り当てられたストレージサイズ (GB)
#
# - availability_zones: DB スナップショット取得時に DB クラスターが
#   配置されていたアベイラビリティゾーンのリスト
#
# - db_cluster_snapshot_arn: DB クラスタースナップショットの
#   Amazon Resource Name (ARN)
#   クロスリージョン参照やクロスアカウント共有で使用します
#
# - engine: データベースエンジン名 (例: "aurora-mysql", "aurora-postgresql")
#
# - engine_version: データベースエンジンのバージョン
#
# - id: クラスタースナップショット識別子
#   通常、target_db_cluster_snapshot_identifier と同じ値
#
# - kms_key_id: 暗号化された DB クラスタースナップショットの
#   KMS 暗号化キーの ARN
#
# - license_model: 復元された DB クラスターのライセンスモデル情報
#
# - shared_accounts: スナップショットを共有している AWS アカウント ID のリスト
#   "all" が設定されている場合、スナップショットは公開されています
#
# - source_db_cluster_snapshot_identifier: コピー元の DB スナップショット ARN
#   クロスカスタマーまたはクロスリージョンコピーの場合にのみ値を持ちます
#
# - storage_encrypted: DB クラスタースナップショットが暗号化されているかどうか
#   true の場合、暗号化されています
#
# - storage_type: DB クラスタースナップショットに関連付けられたストレージタイプ
#   (例: "standard", "io1", "aurora")
#
# - tags_all: プロバイダーの default_tags 設定ブロックから継承されたタグを含む、
#   リソースに割り当てられたすべてのタグのマップ
#
# - vpc_id: DB クラスタースナップショットに関連付けられた VPC ID
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例: クロスリージョンコピー
#---------------------------------------------------------------
# resource "aws_rds_cluster_snapshot_copy" "cross_region" {
#   source_db_cluster_snapshot_identifier = "arn:aws:rds:us-east-1:123456789012:cluster-snapshot:source-snapshot"
#   target_db_cluster_snapshot_identifier = "dr-snapshot-copy"
#   destination_region                    = "us-west-2"
#   kms_key_id                            = "arn:aws:kms:us-west-2:123456789012:key/12345678-1234-1234-1234-123456789012"
#   copy_tags                             = true
#
#   tags = {
#     Name        = "dr-snapshot"
#     Environment = "disaster-recovery"
#   }
# }
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例: 暗号化されていないスナップショットを暗号化してコピー
#---------------------------------------------------------------
# resource "aws_rds_cluster_snapshot_copy" "encrypted_copy" {
#   source_db_cluster_snapshot_identifier = aws_db_cluster_snapshot.unencrypted.db_cluster_snapshot_arn
#   target_db_cluster_snapshot_identifier = "encrypted-snapshot-copy"
#   kms_key_id                            = aws_kms_key.rds.arn
#
#   tags = {
#     Name       = "encrypted-copy"
#     Encrypted  = "true"
#   }
# }
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例: 他のアカウントと共有
#---------------------------------------------------------------
# resource "aws_rds_cluster_snapshot_copy" "shared_copy" {
#   source_db_cluster_snapshot_identifier = aws_db_cluster_snapshot.source.db_cluster_snapshot_arn
#   target_db_cluster_snapshot_identifier = "shared-snapshot-copy"
#   shared_accounts                       = ["123456789012", "234567890123"]
#
#   tags = {
#     Name   = "shared-snapshot"
#     Shared = "true"
#   }
# }
#---------------------------------------------------------------
