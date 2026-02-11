#---------------------------------------------------------------
# AWS RDS DB Proxy Default Target Group
#---------------------------------------------------------------
#
# RDS DB Proxy のデフォルトターゲットグループを管理するリソースです。
# デフォルトターゲットグループは DB Proxy の作成時に暗黙的に作成され、
# 接続プールの設定を構成するために使用します。
#
# NOTE: このリソースは DB Proxy の作成時に自動的に作成されるため、
#       Terraform は作成・削除を行いません。リソース作成時に自動的に
#       インポートされ、リソース削除時には RDS で何も操作を行いません。
#
# NOTE: 関連する aws_db_proxy リソースが置換された場合、Terraform は
#       このリソースを追跡できなくなり、次回の apply 時に予期しない差分が
#       発生します。適切な依存関係管理のため、aws_db_proxy リソースの id
#       属性を参照する replace_triggered_by を含む lifecycle ブロックを
#       追加することを推奨します。
#
# AWS公式ドキュメント:
#   - Amazon RDS Proxy 概要: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/rds-proxy.html
#   - RDS Proxy 接続プール: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/rds-proxy-connections.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_proxy_default_target_group
#
# Provider Version: 6.28.0
# Generated: 2026-01-22
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_db_proxy_default_target_group" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # db_proxy_name (Required)
  # 設定内容: RDS DB Proxy の名前を指定します。
  # 設定可能な値: 既存の RDS DB Proxy 名
  # 関連リソース: aws_db_proxy
  db_proxy_name = aws_db_proxy.example.name

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # 接続プール設定
  #-------------------------------------------------------------

  # connection_pool_config (Optional)
  # 設定内容: ターゲットグループの接続プールのサイズと動作を決定する設定を指定します。
  # 関連機能: RDS Proxy 接続プール
  #   データベース接続を効率的に再利用し、データベースリソースの消費を最小化します。
  connection_pool_config {
    # connection_borrow_timeout (Optional)
    # 設定内容: プロキシが接続プールで接続が利用可能になるまで待機する秒数を指定します。
    # 設定可能な値: 0〜3600 秒
    # 省略時: 120 秒
    # 注意: プロキシが最大接続数に達し、すべての接続がクライアントセッションで
    #       ビジー状態の場合にのみ適用されます。
    connection_borrow_timeout = 120

    # init_query (Optional)
    # 設定内容: 新しいデータベース接続を開くときにプロキシが実行する SQL 文を指定します。
    # 設定可能な値: 1 つ以上の SQL 文（セミコロンで区切り）
    # 省略時: 空（SQL を実行しない）
    # 一般的な用途: SET 文を使用してタイムゾーンや文字セットなどの設定を統一
    # 例: "SET x=1, y=2" のように 1 つの SET 文に複数の変数を含めることが可能
    init_query = "SET x=1, y=2"

    # max_connections_percent (Optional)
    # 設定内容: ターゲットグループ内の各ターゲットの接続プールの最大サイズを指定します。
    # 設定可能な値: 1〜100 のパーセンテージ値
    # 省略時: 100
    # 注意: Aurora MySQL の場合、RDS DB インスタンスまたは Aurora DB クラスターの
    #       max_connections 設定に対するパーセンテージとして表されます。
    max_connections_percent = 100

    # max_idle_connections_percent (Optional)
    # 設定内容: 接続プール内のアイドルデータベース接続をプロキシが閉じる割合を制御します。
    # 設定可能な値: 0〜max_connections_percent のパーセンテージ値
    # 省略時: 50
    # 高い値: アイドル接続を多く維持（迅速な接続応答）
    # 低い値: アイドル接続を積極的に閉じてプールに戻す（リソース節約）
    # 注意: Aurora MySQL の場合、RDS DB インスタンスまたは Aurora DB クラスターの
    #       max_connections 設定に対するパーセンテージとして表されます。
    max_idle_connections_percent = 50

    # session_pinning_filters (Optional)
    # 設定内容: セッションピンニングの動作から除外する SQL 操作クラスのリストを指定します。
    # 設定可能な値: ["EXCLUDE_VARIABLE_SETS"]
    #   - "EXCLUDE_VARIABLE_SETS": SET 文による変数設定をピンニングから除外
    # 省略時: 空（すべての操作でピンニングが発生する可能性がある）
    # 対象: MySQL エンジンファミリーのデータベースのみ
    # 関連機能: セッションピンニング
    #   特定の SQL 操作により、後続のすべての文が同じ基盤データベース接続に
    #   固定されます。このリストに含めることで、その操作クラスをピンニング
    #   動作から除外できます。
    session_pinning_filters = ["EXCLUDE_VARIABLE_SETS"]
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト値を指定します。
  timeouts {
    # create (Optional)
    # 設定内容: 作成操作のタイムアウトを指定します。
    # 設定可能な値: "30m" などの duration 文字列
    # 省略時: デフォルトのタイムアウト値
    create = "30m"

    # update (Optional)
    # 設定内容: 更新操作のタイムアウトを指定します。
    # 設定可能な値: "30m" などの duration 文字列
    # 省略時: デフォルトのタイムアウト値
    update = "30m"
  }

  #-------------------------------------------------------------
  # ライフサイクル設定（推奨）
  #-------------------------------------------------------------

  # lifecycle ブロック
  # NOTE: 関連する aws_db_proxy リソースが置換された場合に
  #       このリソースも適切に再作成されるようにするため、
  #       replace_triggered_by を設定することを推奨します。
  lifecycle {
    replace_triggered_by = [aws_db_proxy.example.id]
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: RDS DB Proxy の名前
#
# - arn: ターゲットグループの Amazon Resource Name (ARN)
#
# - name: デフォルトターゲットグループの名前
#---------------------------------------------------------------
