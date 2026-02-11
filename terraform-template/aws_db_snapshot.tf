#---------------------------------------------------------------
# AWS RDS Database Instance Snapshot
#---------------------------------------------------------------
#
# Amazon RDS データベースインスタンスのスナップショットを管理するリソースです。
# 手動スナップショットを作成し、データベースのバックアップやポイントインタイムリカバリに使用できます。
#
# 注意: RDS クラスター (Aurora等) のスナップショットについては、
# aws_db_cluster_snapshot リソースを使用してください。
#
# AWS公式ドキュメント:
#   - RDS スナップショット概要: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_CreateSnapshot.html
#   - RDS スナップショットの共有: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_ShareSnapshot.html
#   - RDS API リファレンス: https://docs.aws.amazon.com/AmazonRDS/latest/APIReference/Welcome.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_snapshot
#
# Provider Version: 6.28.0
# Generated: 2026-01-22
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_db_snapshot" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # db_instance_identifier (Required)
  # 設定内容: スナップショットを取得する対象のDBインスタンスの識別子を指定します。
  # 設定可能な値: 有効なRDS DBインスタンスの識別子
  # 用途: どのDBインスタンスからスナップショットを作成するかを指定
  # 関連機能: RDS DB インスタンス
  #   DBインスタンスの現在の状態をキャプチャしてスナップショットを作成します。
  #   - https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_CreateSnapshot.html
  db_instance_identifier = "my-database-instance"

  # db_snapshot_identifier (Required)
  # 設定内容: 作成するスナップショットの識別子を指定します。
  # 設定可能な値: 以下の制約を満たす文字列
  #   - 1〜255文字の英数字またはハイフン
  #   - 最初の文字は英字
  #   - 連続するハイフン不可
  #   - 末尾がハイフン不可
  # 用途: スナップショットを一意に識別するために使用
  # 関連機能: RDS スナップショット識別子
  #   手動スナップショットには一意の識別子が必要です。
  #   - https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_CreateSnapshot.html
  db_snapshot_identifier = "my-database-snapshot-20260122"

  #-------------------------------------------------------------
  # スナップショット共有設定
  #-------------------------------------------------------------

  # shared_accounts (Optional)
  # 設定内容: スナップショットを共有するAWSアカウントIDのリストを指定します。
  # 設定可能な値:
  #   - AWSアカウントIDのセット (例: ["123456789012", "987654321098"])
  #   - "all" を指定するとスナップショットをパブリックにします
  # 省略時: スナップショットは作成元アカウントでのみアクセス可能
  # 注意:
  #   - 暗号化されたスナップショットを共有する場合、KMSキーも共有先で利用可能にする必要があります
  #   - パブリックスナップショットには機密データを含めないでください
  # 関連機能: RDS スナップショットの共有
  #   他のAWSアカウントとスナップショットを共有して、データベースの複製やマイグレーションを実現できます。
  #   - https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_ShareSnapshot.html
  shared_accounts = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード (例: us-east-1, ap-northeast-1)
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_Tagging.html
  tags = {
    Name        = "my-database-snapshot"
    Environment = "production"
  }

  # tags_all (Optional, Computed)
  # 設定内容: プロバイダーのdefault_tagsから継承されるタグを含む全タグのマップ
  # 注意: 通常は明示的に設定する必要はありません。Terraformが自動管理します
  tags_all = null

  # id (Optional, Computed)
  # 設定内容: リソースのID。通常はスナップショット識別子と同じ値
  # 注意: 通常は明示的に設定する必要はありません。Terraformが自動管理します
  id = null

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース作成のタイムアウト値を設定します。
  # 用途: 大規模なデータベースのスナップショット作成には時間がかかる場合があります
  timeouts {
    # create (Optional)
    # 設定内容: スナップショット作成のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列 (例: "30m", "1h", "2h30m")
    # 省略時: デフォルトのタイムアウト値を使用
    # 注意: データベースのサイズに応じて適切な値を設定してください
    create = "20m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - allocated_storage: スナップショット取得時に割り当てられていた
#   ストレージサイズ (GB)
#
# - availability_zone: スナップショット取得時にDBインスタンスが
#   配置されていたアベイラビリティゾーン
#
# - db_snapshot_arn: スナップショットのAmazon Resource Name (ARN)
#
# - encrypted: スナップショットが暗号化されているかどうか
#
# - engine: データベースエンジン名 (例: mysql, postgres, oracle-se2)
#
# - engine_version: データベースエンジンのバージョン
#
# - iops: スナップショット取得時のプロビジョンドIOPS値
#
# - kms_key_id: 暗号化に使用されるKMSキーのARN
#
# - license_model: ライセンスモデル情報
#   (例: license-included, bring-your-own-license, general-public-license)
#---------------------------------------------------------------
