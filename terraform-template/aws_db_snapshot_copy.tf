# -----------------------------------------------------------
# Terraform AWS Resource Template: aws_db_snapshot_copy
# -----------------------------------------------------------
# Generated: 2026-01-22
# Provider Version: 6.28.0
#
# 注意: このテンプレートは生成時点(2026-01-22)の情報に基づいています。
# 最新の仕様や詳細については、公式ドキュメントを必ず確認してください。
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_snapshot_copy
#
# aws_db_snapshot_copy は、RDSデータベースインスタンスのスナップショットコピーを管理します。
# DBクラスタースナップショットの管理には、aws_db_cluster_snapshot リソースを使用してください。
# -----------------------------------------------------------

resource "aws_db_snapshot_copy" "example" {
  # -----------------------------------------------------------
  # 必須パラメータ (Required)
  # -----------------------------------------------------------

  # ソーススナップショット識別子
  # コピー元のスナップショットの識別子を指定します。
  # スナップショットARN形式での指定が可能です。
  # クロスリージョンコピーの場合は、ARN形式での指定が必要です。
  # 型: string
  # 必須: true
  # 参考: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_CopySnapshot.html
  source_db_snapshot_identifier = "arn:aws:rds:us-east-1:123456789012:snapshot:my-snapshot"

  # ターゲットDBスナップショット識別子
  # コピー先のスナップショットに付ける一意の識別子を指定します。
  # 同一リージョン内で重複しない名前を指定する必要があります。
  # 型: string
  # 必須: true
  target_db_snapshot_identifier = "my-snapshot-copy"

  # -----------------------------------------------------------
  # オプションパラメータ (Optional)
  # -----------------------------------------------------------

  # タグのコピー設定
  # ソーススナップショットのタグをコピー先にも適用するかどうかを指定します。
  # デフォルト値は false です。
  # true に設定すると、ソーススナップショットのタグが全てコピーされます。
  # 型: bool
  # デフォルト: false
  copy_tags = true

  # 宛先リージョン
  # スナップショットコピーを配置する宛先リージョンを指定します。
  # クロスリージョンコピーを実行する際に使用します。
  # 指定しない場合は、現在のリージョンにコピーされます。
  # 型: string
  # オプション: true
  # 参考: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_CopySnapshot.html
  destination_region = "us-west-2"

  # KMSキーID
  # 暗号化されたスナップショットをコピーする際に使用するKMSキーのIDを指定します。
  # RDS Customのスナップショットは全て暗号化されているため、クロスリージョンコピーの
  # 際には宛先リージョンで有効なKMSキーを指定する必要があります。
  # 型: string
  # オプション: true
  # 参考: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/custom-copying-snapshot-sqlserver.html
  kms_key_id = "arn:aws:kms:us-west-2:123456789012:key/12345678-1234-1234-1234-123456789012"

  # オプショングループ名
  # コピー先スナップショットに適用するオプショングループ名を指定します。
  # オプショングループはリージョン固有のため、クロスリージョンコピーの際には
  # 宛先リージョンに存在するオプショングループを指定する必要があります。
  # 型: string
  # オプション: true
  # Computed: true
  option_group_name = "default:mysql-5-7"

  # 事前署名URL
  # Signature Version 4で署名されたリクエストを含むURLを指定します。
  # クロスリージョンコピーの際、RDSが認証に使用します。
  # 通常は自動的に生成されるため、明示的な指定は不要です。
  # 型: string
  # オプション: true
  presigned_url = null

  # リージョン設定
  # このリソースが管理されるリージョンを指定します。
  # 指定しない場合は、プロバイダー設定のリージョンがデフォルトで使用されます。
  # 型: string
  # オプション: true
  # Computed: true
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = "us-west-2"

  # 共有アカウント
  # スナップショットを共有するAWSアカウントIDのリストを指定します。
  # "all" を指定すると、スナップショットが公開されます（暗号化されていない場合のみ）。
  # 暗号化されたスナップショットは公開できません。
  # 型: set(string)
  # オプション: true
  # 参考: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/share-encrypted-snapshot.html
  shared_accounts = ["123456789012", "210987654321"]

  # ターゲットカスタムアベイラビリティゾーン
  # 外部カスタムアベイラビリティゾーンを指定します。
  # RDS Custom for SQL Serverなどのカスタム環境で使用されます。
  # 型: string
  # オプション: true
  target_custom_availability_zone = "us-west-2-custom-az-1"

  # タグ
  # リソースに適用するキー・バリュー形式のタグを指定します。
  # プロバイダーレベルで default_tags が設定されている場合、
  # 同じキーのタグはこちらで指定した値で上書きされます。
  # 型: map(string)
  # オプション: true
  tags = {
    Name        = "my-db-snapshot-copy"
    Environment = "production"
    Backup      = "true"
  }

  # 全タグ
  # プロバイダーの default_tags とマージされた全タグのマップです。
  # 通常、このパラメータは明示的に設定する必要はありません。
  # プロバイダーレベルのタグと個別のタグが自動的にマージされます。
  # 型: map(string)
  # オプション: true
  # Computed: true
  tags_all = {
    Name        = "my-db-snapshot-copy"
    Environment = "production"
    Backup      = "true"
    ManagedBy   = "terraform"
  }

  # ID (通常は指定不要)
  # スナップショット識別子として使用されます。
  # 通常は target_db_snapshot_identifier と同じ値が自動的に設定されるため、
  # 明示的に指定する必要はありません。
  # 型: string
  # オプション: true
  # Computed: true
  id = null

  # -----------------------------------------------------------
  # タイムアウト設定 (Timeouts)
  # -----------------------------------------------------------

  timeouts {
    # 作成タイムアウト
    # スナップショットコピー操作の作成タイムアウト時間を指定します。
    # クロスリージョンコピーの場合、データ量によっては数時間かかることがあります。
    # デフォルト値が設定されていますが、大容量のスナップショットをコピーする場合は
    # より長い時間を設定することを推奨します。
    # 型: string (例: "20m", "2h")
    # 参考: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_CopySnapshot.html
    create = "2h"
  }
}

# -----------------------------------------------------------
# Computed-Only 属性 (Output として参照可能)
# -----------------------------------------------------------
# 以下の属性は Terraform によって自動的に計算され、
# リソース作成後に参照可能になります。入力パラメータとしては指定できません。
#
# - allocated_storage (number)
#   割り当てられたストレージサイズ（GB単位）
#
# - availability_zone (string)
#   DBスナップショットが作成された時点でのDBインスタンスのアベイラビリティゾーン
#
# - db_snapshot_arn (string)
#   DBスナップショットのAmazon Resource Name (ARN)
#
# - encrypted (bool)
#   DBスナップショットが暗号化されているかどうか
#
# - engine (string)
#   データベースエンジン名
#
# - engine_version (string)
#   データベースエンジンのバージョン
#
# - iops (number)
#   スナップショット作成時のDBインスタンスのプロビジョンドIOPS値
#
# - license_model (string)
#   復元されたDBインスタンスのライセンスモデル情報
#
# - port (number)
#   DBインスタンスのポート番号
#
# - snapshot_type (string)
#   スナップショットのタイプ
#
# - source_region (string)
#   DBスナップショットが作成またはコピーされたリージョン
#
# - storage_type (string)
#   DBスナップショットに関連付けられたストレージタイプ
#
# - vpc_id (string)
#   DBスナップショットに関連付けられたVPC ID
# -----------------------------------------------------------

# -----------------------------------------------------------
# 使用例: Output
# -----------------------------------------------------------
# output "db_snapshot_copy_arn" {
#   description = "The ARN of the DB snapshot copy"
#   value       = aws_db_snapshot_copy.example.db_snapshot_arn
# }
#
# output "db_snapshot_copy_encrypted" {
#   description = "Whether the DB snapshot copy is encrypted"
#   value       = aws_db_snapshot_copy.example.encrypted
# }
#
# output "db_snapshot_copy_kms_key_id" {
#   description = "The KMS key ID used for encryption"
#   value       = aws_db_snapshot_copy.example.kms_key_id
# }
# -----------------------------------------------------------

