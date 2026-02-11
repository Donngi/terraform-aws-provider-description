# -----------------------------------------------------------------------------
# AWS DAX (DynamoDB Accelerator) Cluster Template
# -----------------------------------------------------------------------------
# Generated: 2026-01-22
# Provider Version: 6.28.0
#
# 注意: このテンプレートは生成時点の情報に基づいています。
# 最新の仕様については、以下の公式ドキュメントを確認してください。
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dax_cluster
# https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/DAX.html
# -----------------------------------------------------------------------------

resource "aws_dax_cluster" "example" {
  # -----------------------------------------------------------------------------
  # Required Parameters
  # -----------------------------------------------------------------------------

  # クラスター名（必須）
  # DAXクラスターの識別子。小文字に自動変換される
  # https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/DAX.concepts.cluster.html
  cluster_name = "example-cluster"

  # IAMロールARN（必須）
  # DAXがDynamoDBにアクセスするために使用するIAMロールのARN
  # このロールには、DynamoDBテーブルへのアクセス権限が必要
  # https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/DAX.create-cluster.html
  iam_role_arn = "arn:aws:iam::123456789012:role/DAXServiceRole"

  # ノードタイプ（必須）
  # クラスターの各ノードのコンピュートとメモリ容量
  # サポートされているノードタイプ: dax.t2.small, dax.t2.medium, dax.t3.small, dax.t3.medium,
  # dax.r3.large, dax.r3.xlarge, dax.r3.2xlarge, dax.r3.4xlarge, dax.r3.8xlarge,
  # dax.r4.large, dax.r4.xlarge, dax.r4.2xlarge, dax.r4.4xlarge, dax.r4.8xlarge, dax.r4.16xlarge
  # https://aws.amazon.com/dynamodb/pricing/
  node_type = "dax.r4.large"

  # レプリケーション係数（必須）
  # クラスター内のノード数（プライマリノード1つ + リードレプリカ）
  # レプリケーション係数1は単一ノードクラスター（リードレプリカなし）を作成
  # 本番環境では、フォールトトレランスのため最低3ノードを推奨
  # 最大11ノード（プライマリ1つ + リードレプリカ10個）まで指定可能
  # https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/DAX.concepts.cluster.html
  replication_factor = 3

  # -----------------------------------------------------------------------------
  # Optional Parameters
  # -----------------------------------------------------------------------------

  # アベイラビリティーゾーン（オプション）
  # ノードを作成するアベイラビリティーゾーンのリスト
  # 指定しない場合、ノードは自動的にAZ間で分散される
  # 本番環境では、異なるAZにノードを配置することを推奨
  # https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/DAX.concepts.cluster.html#DAX.concepts.regions-and-azs
  availability_zones = ["us-west-2a", "us-west-2b", "us-west-2c"]

  # クラスターエンドポイント暗号化タイプ（オプション）
  # クラスターのエンドポイントがサポートする暗号化のタイプ
  # 有効な値: "NONE", "TLS"
  # デフォルト: "NONE"
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dax_cluster
  cluster_endpoint_encryption_type = "TLS"

  # 説明（オプション）
  # クラスターの説明文
  description = "DAX cluster for production DynamoDB tables"

  # メンテナンスウィンドウ（オプション）
  # クラスターのメンテナンスを実行する週次の時間範囲
  # フォーマット: ddd:hh24:mi-ddd:hh24:mi（24時間表記UTC）
  # 最小メンテナンスウィンドウは60分
  # 例: "sun:05:00-sun:09:00"
  # 指定しない場合、リージョンごとの8時間ブロックからランダムに選択される
  # https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/DAX.concepts.cluster.html#DAX.concepts.maintenance-window
  maintenance_window = "sun:05:00-sun:06:00"

  # 通知トピックARN（オプション）
  # DAX通知を送信するためのAmazon SNSトピックのARN
  # クラスターイベント（ノード追加の成功/失敗など）の通知を受信できる
  # https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/DAX.cluster-management.html#DAX.cluster-management.custom-settings
  notification_topic_arn = "arn:aws:sns:us-west-2:123456789012:dax-notifications"

  # パラメータグループ名（オプション）
  # このDAXクラスターに関連付けるパラメータグループの名前
  # パラメータグループを使用して、キャッシュTTL動作などを指定可能
  # デフォルト: default.dax1.0
  # https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/DAX.concepts.cluster.html#DAX.concepts.parameter-groups
  parameter_group_name = "default"

  # リージョン（オプション）
  # このリソースが管理されるリージョン
  # プロバイダー設定のリージョンがデフォルト
  # https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = "us-west-2"

  # セキュリティグループID（オプション）
  # クラスターに関連付ける1つ以上のVPCセキュリティグループ
  # セキュリティグループは、VPCのインバウンド/アウトバウンドトラフィックを制御
  # 非暗号化クラスターにはポート8111、暗号化クラスターにはポート9111の受信ルールが必要
  # https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/DAX.concepts.cluster.html#DAX.concepts.security-groups
  security_group_ids = ["sg-12345678"]

  # サブネットグループ名（オプション）
  # クラスターに使用するサブネットグループの名前
  # サブネットグループは、VPC環境内でクラスターノードを実行するサブネットのコレクション
  # DAXクラスターアクセスは、特定のサブネット上で実行されるEC2インスタンスに制限される
  # https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/DAX.concepts.cluster.html#DAX.concepts.cluster.security
  subnet_group_name = "default"

  # タグ（オプション）
  # リソースに割り当てるタグのマップ
  # プロバイダーのdefault_tags設定ブロックと一致するキーを持つタグは上書きされる
  # https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/DAX.management.tagging.html
  tags = {
    Name        = "example-dax-cluster"
    Environment = "production"
    Application = "myapp"
  }

  # -----------------------------------------------------------------------------
  # Nested Blocks
  # -----------------------------------------------------------------------------

  # サーバーサイド暗号化設定（オプション）
  # 保存時の暗号化オプション
  # 最大1つまで指定可能
  server_side_encryption {
    # 暗号化を有効化するかどうか（オプション）
    # デフォルト: false
    # 暗号化を有効にすると、クラスター内のディスクに保存されるすべてのデータが暗号化される
    enabled = true
  }

  # タイムアウト設定（オプション）
  # リソース操作のタイムアウト時間を設定
  timeouts {
    # 作成タイムアウト（オプション）
    # クラスター作成操作のタイムアウト時間
    # デフォルト: 45分
    create = "45m"

    # 更新タイムアウト（オプション）
    # クラスター更新操作のタイムアウト時間
    # デフォルト: 90分
    update = "90m"

    # 削除タイムアウト（オプション）
    # クラスター削除操作のタイムアウト時間
    # デフォルト: 45分
    delete = "45m"
  }
}

# -----------------------------------------------------------------------------
# Computed Attributes (Read-only)
# -----------------------------------------------------------------------------
# 以下の属性は、Terraformによって自動的に計算され、参照可能です。
#
# arn                      - DAXクラスターのARN
# cluster_address          - ポート番号を除いたDAXクラスターのDNS名
# configuration_endpoint   - このDAXクラスターの設定エンドポイント（DNS名とポート番号）
# nodes                    - ノードオブジェクトのリスト（id, address, port, availability_zone）
#                            例: aws_dax_cluster.example.nodes[0].address
# port                     - 設定エンドポイントで使用されるポート番号
# tags_all                 - プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#                            リソースに割り当てられたタグのマップ
# -----------------------------------------------------------------------------

