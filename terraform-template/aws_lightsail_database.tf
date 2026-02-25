#---------------------------------------------------------------
# AWS Lightsail リレーショナルデータベース
#---------------------------------------------------------------
#
# Amazon Lightsail のマネージドリレーショナルデータベースをプロビジョニングするリソースです。
# 自動バックアップ、監視、メンテナンスを含む完全マネージド型のデータベースインスタンスを提供します。
# MySQL および PostgreSQL エンジンをサポートしています。
#
# 注意: Lightsail は限られた AWS リージョンでのみ利用可能です。
#   利用可能なリージョンについては AWS の公式ページを確認してください。
#
# AWS公式ドキュメント:
#   - Lightsail リレーショナルデータベース概要: https://docs.aws.amazon.com/lightsail/latest/userguide/amazon-lightsail-databases.html
#   - データベースブループリント一覧: https://docs.aws.amazon.com/lightsail/latest/userguide/choosing-a-database-bundle-in-amazon-lightsail.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lightsail_database
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lightsail_database" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # relational_database_name (Required)
  # 設定内容: Lightsail データベースリソースの名前を指定します。
  # 設定可能な値: 文字列。同一 AWS リージョンの Lightsail アカウント内で一意である必要があります。
  relational_database_name = "example-database"

  # blueprint_id (Required)
  # 設定内容: データベースのブループリント ID を指定します。ブループリットはデータベースのメジャーエンジンバージョンを表します。
  # 設定可能な値: 例 "mysql_8_0", "postgres_12", "postgres_14" 等
  # 参考: 利用可能なブループリット ID は AWS CLI コマンド `aws lightsail get-relational-database-blueprints` で確認できます。
  blueprint_id = "mysql_8_0"

  # bundle_id (Required)
  # 設定内容: データベースのバンドル ID を指定します。バンドルはデータベースのパフォーマンス仕様（CPU、メモリ、ストレージ等）を表します。
  # 設定可能な値: 例 "micro_1_0", "small_1_0", "medium_1_0", "large_1_0" 等
  # 参考: 利用可能なバンドル ID は AWS CLI コマンド `aws lightsail get-relational-database-bundles` で確認できます。
  bundle_id = "micro_1_0"

  #-------------------------------------------------------------
  # マスターユーザー設定
  #-------------------------------------------------------------

  # master_database_name (Required)
  # 設定内容: Lightsail データベースリソース作成時に作成されるマスターデータベースの名前を指定します。
  master_database_name = "exampledb"

  # master_username (Required)
  # 設定内容: データベースのマスターユーザー名を指定します。
  master_username = "exampleuser"

  # master_password (Required, Sensitive)
  # 設定内容: データベースのマスターユーザーのパスワードを指定します。
  # 設定可能な値: "/" 、 '"' 、 "@" を除く印刷可能な ASCII 文字を含む文字列
  # 注意: このフィールドは機密情報（sensitive）として扱われます。Terraform の state ファイルに平文で保存されるため、
  #       シークレット管理ツール（AWS Secrets Manager 等）との連携を検討してください。
  master_password = "examplepassword123"

  #-------------------------------------------------------------
  # ネットワーク設定
  #-------------------------------------------------------------

  # availability_zone (Optional)
  # 設定内容: データベースを作成するアベイラビリティゾーンを指定します。
  # 設定可能な値: "us-east-2a" のような形式（大文字小文字を区別）
  # 省略時: AWS が自動的にアベイラビリティゾーンを選択します。
  availability_zone = "us-east-1a"

  # publicly_accessible (Optional)
  # 設定内容: データベースを Lightsail アカウント外のリソースからアクセス可能にするかを指定します。
  # 設定可能な値:
  #   - true: Lightsail アカウント外のリソースからアクセス可能
  #   - false: 同一リージョンの Lightsail リソースからのみアクセス可能
  # 省略時: false（デフォルト）
  publicly_accessible = false

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # バックアップ設定
  #-------------------------------------------------------------

  # backup_retention_enabled (Optional)
  # 設定内容: データベースの自動バックアップ保持を有効にするかを指定します。
  # 設定可能な値:
  #   - true: 自動バックアップ保持を有効化
  #   - false: 自動バックアップ保持を無効化。無効化するとすべての自動バックアップが削除されます。
  # 省略時: true（デフォルト）
  # 注意: 無効化前にデータベースのスナップショットを作成することを推奨します。
  backup_retention_enabled = true

  # preferred_backup_window (Optional)
  # 設定内容: 自動バックアップが有効な場合に、毎日自動バックアップが作成される時間帯を指定します。
  # 設定可能な値: hh24:mi-hh24:mi 形式（例: "16:00-16:30"）。UTC で指定します。
  # 省略時: AWS が自動的にバックアップウィンドウを選択します。
  preferred_backup_window = "16:00-16:30"

  #-------------------------------------------------------------
  # メンテナンス設定
  #-------------------------------------------------------------

  # preferred_maintenance_window (Optional)
  # 設定内容: データベースのシステムメンテナンスが実行される週次の時間帯を指定します。
  # 設定可能な値: ddd:hh24:mi-ddd:hh24:mi 形式（例: "Tue:17:00-Tue:17:30"）。UTC で指定します。
  # 省略時: AWS が自動的にメンテナンスウィンドウを選択します。
  preferred_maintenance_window = "Tue:17:00-Tue:17:30"

  # apply_immediately (Optional)
  # 設定内容: 変更をすぐに適用するかどうかを指定します。
  # 設定可能な値:
  #   - true: 変更を即時適用
  #   - false: 次の優先メンテナンスウィンドウ中に変更を適用
  # 省略時: false（デフォルト）
  # 注意: 一部の変更はアウテージを引き起こす可能性があります。
  apply_immediately = false

  #-------------------------------------------------------------
  # スナップショット設定
  #-------------------------------------------------------------

  # skip_final_snapshot (Optional)
  # 設定内容: データベースが削除される前に最終スナップショットを作成するかどうかを指定します。
  # 設定可能な値:
  #   - true: 最終スナップショットを作成しない
  #   - false: データベース削除前に最終スナップショットを作成する
  # 省略時: false（デフォルト）
  # 注意: false の場合、final_snapshot_name の指定が必要です。
  skip_final_snapshot = false

  # final_snapshot_name (Required unless skip_final_snapshot = true)
  # 設定内容: skip_final_snapshot が false の場合に作成されるデータベーススナップショットの名前を指定します。
  # 設定可能な値: 文字列
  # 省略時: skip_final_snapshot が true の場合は省略可能。false の場合は必須。
  final_snapshot_name = "example-final-snapshot"

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ。キーのみのタグを作成するには空文字列を値として使用します。
  # 省略時: タグなし
  # 参考: プロバイダーの default_tags 設定ブロックが存在する場合、一致するキーを持つタグはプロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-database"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: データベースの Amazon Resource Name (ARN)（id と同じ値）
# - ca_certificate_identifier: データベースに関連付けられた CA 証明書の識別子
# - cpu_count: データベースの vCPU 数
# - created_at: データベースが作成された日時
# - disk_size: データベースのディスクサイズ（GB）
# - engine: データベースソフトウェア（例: MySQL）
# - engine_version: データベースエンジンバージョン（例: 5.7.23）
# - master_endpoint_address: データベースのマスターエンドポイント FQDN
# - master_endpoint_port: データベースのマスターエンドポイントのネットワークポート
# - ram_size: データベースの RAM サイズ（GB）
# - secondary_availability_zone: 高可用性データベースのセカンダリアベイラビリティゾーン
# - support_code: データベースのサポートコード。Lightsail サポートへの問い合わせ時に使用します。
# - tags_all: プロバイダーの default_tags 設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
