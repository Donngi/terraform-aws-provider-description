#---------------------------------------------------------------
# AWS RDS DB Parameter Group
#---------------------------------------------------------------
#
# Amazon RDS DB パラメータグループを管理するリソースです。
# パラメータグループはデータベースエンジンの設定を定義し、
# 1つ以上のDBインスタンスに適用できます。
#
# 各データベースエンジンのパラメータに関するドキュメント:
#   - Aurora MySQL: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/AuroraMySQL.Reference.html
#   - Aurora PostgreSQL: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/AuroraPostgreSQL.Reference.html
#   - MariaDB: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Appendix.MariaDB.Parameters.html
#   - Oracle: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_ModifyInstance.Oracle.html#USER_ModifyInstance.Oracle.sqlnet
#   - PostgreSQL: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Appendix.PostgreSQL.CommonDBATasks.html#Appendix.PostgreSQL.CommonDBATasks.Parameters
#
# AWS公式ドキュメント:
#   - パラメータグループの操作: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_WorkingWithParamGroups.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_parameter_group
#
# Provider Version: 6.28.0
# Generated: 2026-01-22
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_db_parameter_group" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # family (Required, Forces new resource)
  # 設定内容: DBパラメータグループのファミリーを指定します。
  # 設定可能な値: DBエンジンとバージョンに対応するファミリー名
  #   例:
  #   - MySQL: mysql5.6, mysql5.7, mysql8.0
  #   - PostgreSQL: postgres13, postgres14, postgres15
  #   - MariaDB: mariadb10.4, mariadb10.5, mariadb10.6
  #   - Oracle: oracle-ee-19, oracle-se2-19
  # 用途: パラメータグループが適用されるDBエンジンのバージョンを決定
  # 関連機能: RDS DBエンジンとバージョン
  #   パラメータグループはファミリーと互換性のあるDBインスタンスにのみ適用可能。
  #   - https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_WorkingWithParamGroups.html
  family = "mysql5.7"

  # name (Optional, Computed, Forces new resource)
  # 設定内容: DBパラメータグループの名前を指定します。
  # 設定可能な値: 1〜255文字の英数字またはハイフン (先頭は英字)
  # 省略時: Terraformがランダムな一意の名前を自動生成
  # 注意: name と name_prefix は排他的 (どちらか一方のみ指定可能)
  # 用途: パラメータグループを識別するための名前
  name = "my-db-parameter-group"

  # name_prefix (Optional, Computed, Forces new resource)
  # 設定内容: 指定したプレフィックスで始まる一意の名前を生成します。
  # 設定可能な値: 名前のプレフィックスとなる文字列
  # 省略時: name属性が使用されます
  # 注意: nameと競合します
  # 用途: create_before_destroy ライフサイクルルールと組み合わせて使用
  #   パラメータグループを更新する際、新しいグループを先に作成してから
  #   古いグループを削除することで、ダウンタイムを最小化できます。
  # name_prefix = "my-pg-"

  # description (Optional, Forces new resource)
  # 設定内容: DBパラメータグループの説明を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: "Managed by Terraform" がデフォルト値として設定されます
  # 用途: パラメータグループの目的や用途を文書化
  description = "Custom parameter group for MySQL 5.7"

  #-------------------------------------------------------------
  # パラメータ設定
  #-------------------------------------------------------------

  # parameter (Optional)
  # 設定内容: DBに適用するパラメータのリストを指定します。
  # 用途: データベースエンジンの動作をカスタマイズ
  # 注意:
  #   - パラメータはファミリー（DBエンジン/バージョン）によって異なります
  #   - 利用可能なパラメータの完全なリストは `aws rds describe-db-parameters` で取得可能
  #   - パラメータグループ作成後に確認できます
  # 関連機能: RDS DBパラメータ
  #   - https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_WorkingWithParamGroups.html
  parameter {
    # name (Required)
    # 設定内容: DBパラメータの名前を指定します。
    # 設定可能な値: 有効なパラメータ名 (DBエンジンに依存)
    # 用途: 変更するパラメータを特定
    name = "character_set_server"

    # value (Required)
    # 設定内容: DBパラメータの値を指定します。
    # 設定可能な値: パラメータに対して有効な値 (パラメータの型に依存)
    # 用途: パラメータの新しい値を設定
    value = "utf8mb4"

    # apply_method (Optional)
    # 設定内容: パラメータ変更の適用方法を指定します。
    # 設定可能な値:
    #   - "immediate" (デフォルト): 即時に適用。動的パラメータに使用
    #   - "pending-reboot": 次回の再起動時に適用。静的パラメータに必須
    # 注意:
    #   - 一部のエンジンでは特定のパラメータに "pending-reboot" が必須
    #   - 適用方法が AWS デフォルトと異なる場合、永続的な差分が発生する可能性あり
    # 関連機能: 動的パラメータと静的パラメータ
    #   - https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_WorkingWithParamGroups.html
    apply_method = "immediate"
  }

  parameter {
    name  = "character_set_client"
    value = "utf8mb4"
  }

  # 複数のパラメータを設定する例:
  # parameter {
  #   name         = "max_connections"
  #   value        = "200"
  #   apply_method = "pending-reboot"
  # }
  #
  # parameter {
  #   name  = "slow_query_log"
  #   value = "1"
  # }

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
  # 動作制御オプション
  #-------------------------------------------------------------

  # skip_destroy (Optional)
  # 設定内容: destroy時にパラメータグループを削除しないかどうかを指定します。
  # 設定可能な値:
  #   - true: Terraform stateから削除するが、AWSリソースは残す
  #   - false (デフォルト): 通常どおりリソースを削除
  # 用途:
  #   - パラメータグループを他のDBインスタンスが参照している場合
  #   - 誤削除を防止したい重要なパラメータグループ
  skip_destroy = false

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 用途: リソースの分類、コスト配分、アクセス制御などに使用
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルの default_tags 設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_Tagging.html
  tags = {
    Name        = "my-db-parameter-group"
    Environment = "production"
  }

  # tags_all (Optional, Computed)
  # 設定内容: プロバイダーの default_tags から継承されるタグを含む全タグのマップ
  # 注意: 通常は明示的に設定する必要はありません。Terraformが自動管理します
  tags_all = null

  # id (Optional, Computed)
  # 設定内容: リソースのID。DBパラメータグループ名と同じ値
  # 注意: 通常は明示的に設定する必要はありません。Terraformが自動管理します
  id = null

  #-------------------------------------------------------------
  # ライフサイクル設定の推奨
  #-------------------------------------------------------------
  # パラメータグループの更新時にダウンタイムを防ぐため、
  # create_before_destroy と name_prefix の組み合わせを推奨します:
  #
  # lifecycle {
  #   create_before_destroy = true
  # }
  #
  # 注意: パラメータグループを使用しているDBインスタンスの
  # apply_immediately を true に設定することで、
  # 新しいパラメータグループへの切り替えを即時に行えます。
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: DBパラメータグループ名
#
# - arn: DBパラメータグループのAmazon Resource Name (ARN)
#
# - tags_all: プロバイダーの default_tags 設定ブロックから継承されたタグを含む、
#   リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------

#---------------------------------------------------------------
# Perpetual Diffs (永続的な差分) に関する注意
#---------------------------------------------------------------
# パラメータ設定がAWSのデフォルト値と同じ場合、apply後に
# Terraform plan で永続的な差分が表示されることがあります。
#
# これは apply_method のデフォルト値 ("immediate") と
# AWS側のデフォルト値 ("pending-reboot") が異なることが原因です。
#
# 対処法:
# 1. デフォルト値と同じパラメータを削除する
# 2. 値を変更する (AWSデフォルトと異なる値にする)
# 3. apply_method を AWS デフォルトに合わせる (pending-reboot)
#
# 詳細は Terraform ドキュメントの "Problematic Plan Changes" セクションを参照:
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_parameter_group
#---------------------------------------------------------------
