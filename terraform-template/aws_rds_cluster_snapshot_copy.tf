#---------------------------------------------------------------
# AWS RDS DB Cluster Snapshot Copy
#---------------------------------------------------------------
#
# Amazon RDS DBクラスタースナップショットのコピーをプロビジョニングするリソースです。
# 既存のDBクラスタースナップショットを同一リージョン内または別のリージョンへコピーします。
# クロスリージョンコピーやクロスアカウント共有、暗号化キーの変更が可能です。
# RDS DBインスタンススナップショットのコピーには aws_db_snapshot_copy を使用してください。
#
# AWS公式ドキュメント:
#   - DB クラスタースナップショットのコピー: https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/aurora-copy-snapshot.html
#   - 暗号化済みスナップショットのクロスリージョンコピー: https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/USER_CopyDBClusterSnapshot.Encrypted.CrossRegion.html
#   - 暗号化済みスナップショットの共有: https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/share-encrypted-snapshot.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_snapshot_copy
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_rds_cluster_snapshot_copy" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # source_db_cluster_snapshot_identifier (Required)
  # 設定内容: コピー元のDBクラスタースナップショットの識別子またはARNを指定します。
  # 設定可能な値: スナップショット識別子またはARN文字列
  #   - 同一アカウント内: スナップショット識別子またはARN
  #   - 別アカウントの共有スナップショット: スナップショットのARN
  #   - クロスリージョンコピー: ソースリージョンのスナップショットARN
  # 参考: https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/aurora-copy-snapshot.html
  source_db_cluster_snapshot_identifier = "arn:aws:rds:ap-northeast-1:123456789012:cluster-snapshot:example-snapshot"

  # target_db_cluster_snapshot_identifier (Required)
  # 設定内容: コピー先のDBクラスタースナップショットの識別子を指定します。
  # 設定可能な値: 1-255文字の英数字・ハイフン。先頭は英字。末尾はハイフン不可。連続ハイフン不可
  target_db_cluster_snapshot_identifier = "example-snapshot-copy"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  # destination_region (Optional)
  # 設定内容: スナップショットのコピー先リージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, eu-west-1）
  # 省略時: 同一リージョンへのコピーを実施
  # 注意: クロスリージョンコピーの場合はこのパラメータが必要です。
  #       コピーを同一リージョン内で行う場合は省略可能です。
  # 参考: https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/aurora-copy-snapshot.html
  destination_region = null

  #-------------------------------------------------------------
  # 暗号化設定
  #-------------------------------------------------------------

  # kms_key_id (Optional)
  # 設定内容: コピー先スナップショットの暗号化に使用するKMSキーのIDまたはARNを指定します。
  # 設定可能な値: 有効なKMSキーID、ARN、エイリアス名、またはエイリアスARN
  # 省略時: ソーススナップショットが暗号化されていない場合はコピーも暗号化なし。
  #         ソースが暗号化済みの場合はソースと同じKMSキーでコピーを暗号化
  # 注意: クロスリージョンコピーで暗号化済みスナップショットをコピーする場合は、
  #       コピー先リージョンで有効なKMSキーを指定する必要があります。
  #       ソースの暗号化KMSキーはコピー先リージョンでは使用できません。
  # 参考: https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/USER_CopyDBClusterSnapshot.Encrypted.CrossRegion.html
  kms_key_id = null

  # presigned_url (Optional)
  # 設定内容: クロスリージョンの暗号化済みスナップショットコピー時に使用する
  #           Signature Version 4 署名済みリクエストのURLを指定します。
  # 設定可能な値: 有効な署名済みURL文字列
  # 省略時: Terraformが自動的に生成する場合があります
  # 注意: クロスリージョンで暗号化済みスナップショットをコピーする場合に必要です。
  #       AWSはソースリージョンのスナップショットへのアクセスを検証するためにこのURLを使用します。
  # 参考: https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/USER_CopyDBClusterSnapshot.Encrypted.CrossRegion.html
  presigned_url = null

  #-------------------------------------------------------------
  # スナップショット共有設定
  #-------------------------------------------------------------

  # shared_accounts (Optional)
  # 設定内容: スナップショットを共有するAWSアカウントIDのリストを指定します。
  # 設定可能な値:
  #   - AWSアカウントIDの文字列セット（例: ["123456789012", "210987654321"]）
  #   - "all" を指定するとスナップショットをパブリックに公開
  # 省略時: スナップショットは共有されません
  # 注意: 暗号化済みスナップショットはパブリック共有（"all"）できません。
  #       暗号化済みスナップショットの共有にはKMSキーの共有も必要です。
  # 参考: https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/share-encrypted-snapshot.html
  shared_accounts = []

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # copy_tags (Optional)
  # 設定内容: ソーススナップショットの既存タグをコピーするかを指定します。
  # 設定可能な値:
  #   - true: ソーススナップショットのタグをコピー先スナップショットにコピーします
  #   - false (デフォルト): タグをコピーしません
  # 省略時: false（タグはコピーされません）
  copy_tags = false

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  # 注意: プロバイダーの default_tags 設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-snapshot-copy"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: スナップショットコピーの作成完了を待機する最大時間を指定します。
    # 設定可能な値: "30s", "5m", "2h" 等の時間文字列（s=秒, m=分, h=時間）
    # 省略時: デフォルトのタイムアウト値を使用
    # 注意: クロスリージョンコピーは時間がかかる場合があります。
    #       大きなスナップショットのコピーには適切なタイムアウト値を設定してください。
    create = "20m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: クラスタースナップショット識別子
# - db_cluster_snapshot_arn: DBクラスタースナップショットのARN
# - allocated_storage: 割り当てられたストレージサイズ（GB単位）
# - engine: データベースエンジン名
# - engine_version: データベースエンジンのバージョン
# - license_model: DBインスタンスのライセンスモデル情報
# - snapshot_type: スナップショットのタイプ（manual等）
# - storage_encrypted: DBクラスタースナップショットが暗号化されているかの真偽値
# - storage_type: DBクラスタースナップショットに関連するストレージタイプ
# - vpc_id: DBクラスタースナップショットに関連するVPC ID
# - tags_all: プロバイダーの default_tags 設定ブロックから継承されたタグを含む
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
