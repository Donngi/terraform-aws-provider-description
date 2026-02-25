#---------------------------------------------------------------
# Amazon Redshift Serverless Workgroup
#---------------------------------------------------------------
#
# Amazon Redshift Serverlessのワークグループをプロビジョニングするリソースです。
# ワークグループはコンピューティングリソース（RPU・VPCサブネットグループ・
# セキュリティグループ等）のコレクションであり、クエリ実行のエンドポイントを
# 提供します。ネームスペースと組み合わせて使用します。
#
# AWS公式ドキュメント:
#   - ワークグループとネームスペース: https://docs.aws.amazon.com/redshift/latest/mgmt/serverless-workgroup-namespace.html
#   - ワークグループの作成: https://docs.aws.amazon.com/redshift/latest/mgmt/serverless-console-workgroups-create-workgroup-wizard.html
#   - Workgroup APIリファレンス: https://docs.aws.amazon.com/redshift-serverless/latest/APIReference/API_Workgroup.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/redshiftserverless_workgroup
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_redshiftserverless_workgroup" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # namespace_name (Required)
  # 設定内容: ワークグループに関連付けるネームスペースの名前を指定します。
  # 設定可能な値: 既存のRedshift Serverlessネームスペース名
  namespace_name = "example-namespace"

  # workgroup_name (Required)
  # 設定内容: ワークグループの一意な名前を指定します。
  # 設定可能な値: 英数字およびハイフンを使用した文字列
  workgroup_name = "example-workgroup"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # コンピューティングキャパシティ設定
  #-------------------------------------------------------------

  # base_capacity (Optional)
  # 設定内容: ワークグループのベースデータウェアハウスキャパシティをRPU（Redshift Processing Units）で指定します。
  # 設定可能な値: 8〜512 の整数（8の倍数）
  # 省略時: AWSがデフォルト値を設定します
  # 注意: price_performance_targetブロックを使用する場合、このパラメータとの組み合わせに注意が必要です
  base_capacity = 8

  # max_capacity (Optional)
  # 設定内容: クエリ処理のためにAmazon Redshift Serverlessが使用する最大データウェアハウスキャパシティをRPUで指定します。
  # 設定可能な値: base_capacity以上の整数（8の倍数）
  # 省略時: 上限なし
  max_capacity = 512

  #-------------------------------------------------------------
  # ネットワーク設定
  #-------------------------------------------------------------

  # subnet_ids (Optional)
  # 設定内容: ワークグループに関連付けるVPCサブネットIDのセットを指定します。
  # 設定可能な値: 有効なサブネットIDのセット
  # 省略時: デフォルトVPCのサブネットを使用
  # 注意: 設定する場合は、3つ以上のアベイラビリティゾーンにまたがる
  #       最低3つのサブネットが必要です
  # 参考: https://docs.aws.amazon.com/redshift/latest/mgmt/serverless-known-issues.html
  subnet_ids = [
    "subnet-11111111",
    "subnet-22222222",
    "subnet-33333333",
  ]

  # security_group_ids (Optional)
  # 設定内容: ワークグループに関連付けるセキュリティグループIDのセットを指定します。
  # 設定可能な値: 有効なセキュリティグループIDのセット
  # 省略時: デフォルトのセキュリティグループを使用
  security_group_ids = [
    "sg-11111111",
  ]

  # enhanced_vpc_routing (Optional)
  # 設定内容: 拡張VPCルーティングを有効にするかどうかを指定します。
  # 設定可能な値:
  #   - true: 有効。COPY/UNLOADトラフィックをインターネット経由ではなくVPC経由にルーティングします
  #   - false: 無効
  # 省略時: false
  # 関連機能: 拡張VPCルーティング
  #   有効化するとVPCの機能（セキュリティグループ・エンドポイントポリシー等）で
  #   ネットワークトラフィックをより細かく制御できます。
  #   - https://docs.aws.amazon.com/redshift/latest/mgmt/serverless-console-configure-workgroup-working.html
  enhanced_vpc_routing = false

  # publicly_accessible (Optional)
  # 設定内容: ワークグループにパブリックネットワークからアクセスできるかどうかを指定します。
  # 設定可能な値:
  #   - true: パブリックアクセスを許可
  #   - false: パブリックアクセスを禁止（VPC内からのアクセスのみ）
  # 省略時: false
  # 注意: セキュリティ上、本番環境ではfalseを推奨します
  # 参考: https://docs.aws.amazon.com/securityhub/latest/userguide/redshiftserverless-controls.html
  publicly_accessible = false

  # port (Optional)
  # 設定内容: クラスターが受信接続を受け入れるポート番号を指定します。
  # 設定可能な値: 有効なポート番号（1150〜65535）
  # 省略時: 5439（Redshiftのデフォルトポート）
  port = 5439

  #-------------------------------------------------------------
  # トラック設定
  #-------------------------------------------------------------

  # track_name (Optional)
  # 設定内容: ワークグループのトラック名を指定します。
  # 設定可能な値:
  #   - "current": 最新の認定リリースバージョン（最新機能・セキュリティアップデート・パフォーマンス改善を含む）
  #   - "trailing": 1つ前の認定リリース
  # 省略時: AWSがデフォルト値を設定します
  # 参考: https://docs.aws.amazon.com/redshift/latest/mgmt/tracks.html
  track_name = "current"

  #-------------------------------------------------------------
  # 価格パフォーマンス設定
  #-------------------------------------------------------------

  # price_performance_target (Optional)
  # 設定内容: ワークグループの価格パフォーマンススケーリングの設定ブロックです。
  # 関連機能: AI駆動のスケーリングと最適化
  #   コストとパフォーマンスのバランスを5段階のプロファイルで設定できます。
  #   - https://aws.amazon.com/blogs/big-data/unlock-the-power-of-optimization-in-amazon-redshift-serverless/
  price_performance_target {

    # enabled (Required)
    # 設定内容: 価格パフォーマンススケーリングを有効にするかどうかを指定します。
    # 設定可能な値:
    #   - true: 有効
    #   - false: 無効
    enabled = true

    # level (Optional)
    # 設定内容: 価格パフォーマンススケーリングのレベルを指定します。
    # 設定可能な値:
    #   - 1: LOW_COST（コスト最適化）
    #   - 25: ECONOMICAL（経済的）
    #   - 50: BALANCED（バランス）
    #   - 75: RESOURCEFUL（リソース重視）
    #   - 100: HIGH_PERFORMANCE（高パフォーマンス）
    # 省略時: AWSがデフォルト値を設定します
    level = 50
  }

  #-------------------------------------------------------------
  # データベースパラメータ設定
  #-------------------------------------------------------------

  # config_parameter (Optional)
  # 設定内容: サーバーレスデータベースをより細かく制御するためのパラメータ設定ブロックです。
  # 複数のconfig_parameterブロックを定義できます。
  # 参考: https://docs.aws.amazon.com/redshift-serverless/latest/APIReference/API_CreateWorkgroup.html
  config_parameter {

    # parameter_key (Required)
    # 設定内容: パラメータのキーを指定します。
    # 設定可能な値:
    #   - "auto_mv": 自動マテリアライズドビューの有効化
    #   - "datestyle": 日付スタイルの設定
    #   - "enable_case_sensitive_identifier": 大文字小文字を区別する識別子の有効化
    #   - "enable_user_activity_logging": ユーザーアクティビティログの有効化
    #   - "query_group": クエリグループの設定
    #   - "search_path": 検索パスの設定
    #   - "require_ssl": SSL接続の強制
    #   - "use_fips_ssl": FIPS準拠のSSLエンドポイントの使用
    #   - クエリモニタリングメトリクス: max_query_cpu_time, max_query_blocks_read,
    #     max_scan_row_count, max_query_execution_time, max_query_queue_time,
    #     max_query_cpu_usage_percent, max_query_temp_blocks_to_disk,
    #     max_join_row_count, max_nested_loop_join_row_count
    parameter_key = "require_ssl"

    # parameter_value (Required)
    # 設定内容: パラメータに設定する値を指定します。
    # 設定可能な値: 対応するパラメータキーに応じた文字列値
    parameter_value = "true"
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-workgroup"
    Environment = "production"
    ManagedBy   = "terraform"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を設定するブロックです。
  timeouts {

    # create (Optional)
    # 設定内容: リソース作成のタイムアウト時間を指定します。
    # 設定可能な値: "Xm"（分）、"Xh"（時間）等の期間文字列
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    create = "20m"

    # update (Optional)
    # 設定内容: リソース更新のタイムアウト時間を指定します。
    # 設定可能な値: "Xm"（分）、"Xh"（時間）等の期間文字列
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    update = "20m"

    # delete (Optional)
    # 設定内容: リソース削除のタイムアウト時間を指定します。
    # 設定可能な値: "Xm"（分）、"Xh"（時間）等の期間文字列
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    delete = "20m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: Redshift ServerlessワークグループのARN
# - id: Redshiftワークグループ名
# - workgroup_id: RedshiftワークグループのID
# - endpoint: ワークグループから作成されたエンドポイント情報
#     - address: VPCエンドポイントのDNSアドレス
#     - port: Amazon Redshift Serverlessがリッスンするポート番号
#     - vpc_endpoint: VPCエンドポイント情報のリスト
#         - vpc_endpoint_id: VPCエンドポイントのID
#         - vpc_id: VPCのID
#         - network_interface: ネットワークインターフェース情報のリスト
#             - availability_zone: アベイラビリティゾーン
#             - network_interface_id: ネットワークインターフェースの一意識別子
#             - private_ip_address: サブネット内のネットワークインターフェースのIPv4アドレス
#             - subnet_id: サブネットの一意識別子
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む全タグのマップ
#---------------------------------------------------------------
