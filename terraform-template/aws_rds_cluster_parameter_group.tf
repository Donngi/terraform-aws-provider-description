#---------------------------------------------------------------
# AWS RDS DBクラスターパラメータグループ
#---------------------------------------------------------------
#
# Amazon Aurora DBクラスターのパラメータグループをプロビジョニングするリソースです。
# DBクラスターパラメータグループは、クラスター内の全DBインスタンスに適用される
# 設定値のコレクションです。Aurora MySQL / Aurora PostgreSQL 等のエンジンファミリーに
# 対応したカスタムパラメータを定義することができます。
#
# AWS公式ドキュメント:
#   - DBクラスターパラメータグループの操作: https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/USER_WorkingWithDBClusterParamGroups.html
#   - Auroraパラメータグループの概要: https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/parameter-groups-overview.html
#   - Aurora MySQLパラメータリファレンス: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/AuroraMySQL.Reference.html
#   - Aurora PostgreSQLパラメータリファレンス: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/AuroraPostgreSQL.Reference.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_parameter_group
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_rds_cluster_parameter_group" "example" {
  #-------------------------------------------------------------
  # エンジンファミリー設定
  #-------------------------------------------------------------

  # family (Required)
  # 設定内容: DBクラスターパラメータグループのエンジンファミリーを指定します。
  # 設定可能な値（例）:
  #   Aurora MySQL系:
  #   - "aurora-mysql8.0": Aurora MySQL 8.0互換
  #   - "aurora-mysql5.7": Aurora MySQL 5.7互換
  #   - "aurora5.6": Aurora MySQL 5.6互換
  #   Aurora PostgreSQL系:
  #   - "aurora-postgresql17": Aurora PostgreSQL 17互換
  #   - "aurora-postgresql16": Aurora PostgreSQL 16互換
  #   - "aurora-postgresql15": Aurora PostgreSQL 15互換
  #   - "aurora-postgresql14": Aurora PostgreSQL 14互換
  #   - "aurora-postgresql13": Aurora PostgreSQL 13互換
  #   - "aurora-postgresql12": Aurora PostgreSQL 12互換
  # 参考: 利用可能なファミリー一覧は aws rds describe-db-engine-versions --query 'DBEngineVersions[].DBParameterGroupFamily' で確認可能
  family = "aurora-mysql8.0"

  #-------------------------------------------------------------
  # 名前設定
  #-------------------------------------------------------------

  # name (Optional, Forces new resource)
  # 設定内容: DBクラスターパラメータグループの名前を指定します。
  # 設定可能な値: 1〜255文字。英字で始まり、英数字・ハイフンが使用可能。
  #              ハイフンで終わることや、連続したハイフン、ピリオドは使用不可。
  # 省略時: Terraformがランダムな一意の名前を生成します。
  # 注意: name_prefix と排他的（どちらか一方のみ指定可能）
  name = "my-aurora-mysql8-cluster-pg"

  # name_prefix (Optional, Forces new resource)
  # 設定内容: DBクラスターパラメータグループ名のプレフィックスを指定します。
  #           指定したプレフィックスに続けてTerraformがランダムなサフィックスを付与します。
  # 設定可能な値: 文字列（プレフィックスとして有効な名前）
  # 省略時: name が使用されます。
  # 注意: name と排他的（どちらか一方のみ指定可能）
  name_prefix = null

  #-------------------------------------------------------------
  # 説明設定
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: DBクラスターパラメータグループの説明を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: "Managed by Terraform" が自動設定されます。
  description = "Aurora MySQL 8.0 cluster parameter group"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # パラメータ設定
  #-------------------------------------------------------------

  # parameter (Optional)
  # 設定内容: クラスターに適用するDBパラメータの設定ブロックです。複数指定可能です。
  #           パラメータ名と有効な値はエンジンファミリーによって異なります。
  # 関連機能: Aurora DBクラスターパラメータ管理
  #   パラメータグループ作成後に aws rds describe-db-cluster-parameters コマンドで
  #   利用可能な全パラメータを確認できます。静的パラメータの変更はDBインスタンスの
  #   再起動が必要です。
  #   - https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/USER_WorkingWithParamGroups.ModifyingCluster.html
  parameter {

    # name (Required)
    # 設定内容: 設定するDBパラメータの名前を指定します。
    # 設定可能な値: 対象エンジンファミリーで有効なパラメータ名
    name = "character_set_server"

    # value (Required)
    # 設定内容: DBパラメータに設定する値を指定します。
    # 設定可能な値: 対象パラメータで有効な値
    value = "utf8mb4"

    # apply_method (Optional)
    # 設定内容: パラメータ変更を適用するタイミングを指定します。
    # 設定可能な値:
    #   - "immediate": 即時適用（動的パラメータのみ有効）
    #   - "pending-reboot": 次回の再起動時に適用（静的パラメータに必要）
    # 省略時: "immediate" が使用されます。
    # 注意: エンジンによっては一部パラメータを再起動なしに適用できない場合があり、
    #       その場合は "pending-reboot" を指定する必要があります。
    apply_method = "immediate"
  }

  parameter {
    name         = "character_set_client"
    value        = "utf8mb4"
    apply_method = "immediate"
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし。プロバイダーレベルの default_tags が存在する場合は継承されます。
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルの default_tags 設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "my-aurora-mysql8-cluster-pg"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: DBクラスターパラメータグループの名前
# - arn: DBクラスターパラメータグループのAmazon Resource Name (ARN)
# - tags_all: プロバイダーの default_tags 設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
