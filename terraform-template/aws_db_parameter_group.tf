#-------
# AWS Provider v6.28.0
# resource "aws_db_parameter_group"
# Provider Version: 6.28.0
# Generated: 2026-02-14
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/db_parameter_group
#-------
# NOTE: RDSパラメータグループはデータベースエンジン固有の設定を集約管理します。
# 一部パラメータは再起動が必要なため、apply_methodの適切な設定が重要です。
#-------
# 目的: RDS/Auroraデータベースのパラメータグループを定義し、エンジン固有の設定を管理
#
# 主な用途:
# - データベースエンジン（MySQL、PostgreSQL、Oracle等）のパラメータカスタマイズ
# - 文字セット、接続数、メモリ設定などのチューニング
# - 複数のDBインスタンス/クラスターで共通設定を再利用
#
# 関連ドキュメント:
# - Aurora MySQL パラメータ: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/AuroraMySQL.Reference.html
# - Aurora PostgreSQL パラメータ: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/AuroraPostgreSQL.Reference.html
# - MariaDB パラメータ: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Appendix.MariaDB.Parameters.html
# - Oracle パラメータ: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_ModifyInstance.Oracle.html
# - PostgreSQL パラメータ: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Appendix.PostgreSQL.CommonDBATasks.html
#
# 注意事項:
# - 一部のパラメータはデータベース再起動が必要（apply_method = "pending-reboot"）
# - familyはエンジン種類とバージョンで決定（例: mysql5.6, postgres13, oracle-ee-19）
# - 同じfamily内でもエンジンバージョンによりパラメータが異なる場合がある
# - AWS CLIでパラメータ一覧を確認可能: aws rds describe-db-parameters
#-------

#-------
# 基本設定
#-------
resource "aws_db_parameter_group" "example" {
  # 設定内容: パラメータグループ名（省略時はランダム生成）
  # 制約: 小文字英数字とハイフンのみ、63文字以内、先頭は英字
  # 省略時: Terraformがランダムな一意の名前を自動生成
  # 備考: 変更すると新規リソースが作成される（forces new resource）
  name = "my-db-parameter-group"

  # 設定内容: パラメータグループ名のプレフィックス（nameと排他）
  # 制約: 小文字英数字とハイフンのみ、先頭は英字
  # 省略時: 使用しない
  # 備考: 変更すると新規リソースが作成される、nameとの併用不可
  name_prefix = null

  # 設定内容: DBパラメータグループのファミリー（必須）
  # 設定可能な値: mysql5.6, mysql5.7, mysql8.0, postgres11, postgres12, postgres13, postgres14, postgres15, postgres16, oracle-ee-19, oracle-se2-19, mariadb10.3, mariadb10.4, mariadb10.5, mariadb10.6等
  # 備考: エンジン種類とメジャーバージョンで決定、変更すると新規リソース作成
  family = "mysql8.0"

  # 設定内容: パラメータグループの説明文
  # 省略時: "Managed by Terraform"が自動設定
  # 備考: 変更すると新規リソースが作成される
  description = "Custom parameter group for MySQL 8.0"

  #-------
  # リージョン設定
  #-------
  # 設定内容: リソースを管理するAWSリージョン
  # 省略時: プロバイダー設定のリージョンを使用
  # 備考: リージョナルエンドポイントで管理
  region = null

  #-------
  # パラメータ設定
  #-------
  # 設定内容: 個別のDBパラメータ設定（複数指定可能）
  # 備考: エンジンとバージョンにより利用可能なパラメータが異なる
  parameter {
    # 設定内容: パラメータ名（必須）
    # 備考: エンジン固有のパラメータ名を指定
    name = "character_set_server"

    # 設定内容: パラメータの値（必須）
    # 備考: パラメータごとに有効な値の範囲や形式が異なる
    value = "utf8mb4"

    # 設定内容: パラメータ適用方法
    # 設定可能な値: immediate（即時適用）、pending-reboot（再起動時適用）
    # 省略時: immediate
    # 備考: 再起動が必要なパラメータはpending-rebootを指定
    apply_method = "immediate"
  }

  parameter {
    name  = "max_connections"
    value = "150"
    # 動的パラメータは即時適用可能
    apply_method = "immediate"
  }

  parameter {
    name  = "innodb_buffer_pool_size"
    value = "{DBInstanceClassMemory*3/4}"
    # 静的パラメータは再起動が必要
    apply_method = "pending-reboot"
  }

  parameter {
    name  = "log_bin_trust_function_creators"
    value = "1"
  }

  #-------
  # ライフサイクル管理
  #-------
  # 設定内容: 削除時の動作制御
  # 設定可能な値: true（Terraform管理から除外のみ）、false（実際に削除）
  # 省略時: false
  # 備考: trueの場合、destroy実行時にAWS上のリソースは削除されずTerraform stateから除外のみ
  skip_destroy = false

  #-------
  # タグ設定
  #-------
  # 設定内容: リソースに付与するタグ
  # 省略時: タグなし（プロバイダーのdefault_tagsは適用される）
  # 備考: プロバイダーのdefault_tagsと同じキーがある場合、こちらが優先
  tags = {
    Name        = "my-db-parameter-group"
    Environment = "production"
    Engine      = "MySQL 8.0"
    ManagedBy   = "Terraform"
  }
}

#-------
# Attributes Reference（参照可能な属性）
#-------
# このリソースは以下の属性をエクスポートします:
#
# - id: パラメータグループ名
# - arn: パラメータグループのARN（例: arn:aws:rds:ap-northeast-1:123456789012:pg:my-db-parameter-group）
# - tags_all: リソースに割り当てられた全タグ（プロバイダーのdefault_tags含む）
#
# 参照例:
# - aws_db_parameter_group.example.id
# - aws_db_parameter_group.example.arn
# - aws_db_parameter_group.example.tags_all
#-------
