#---------------------------------------------------------------
# AWS ElastiCache Serverless Cache
#---------------------------------------------------------------
#
# Amazon ElastiCache Serverless キャッシュを作成・管理するリソースです。
# ElastiCache Serverless は、容量管理不要で自動スケーリングするキャッシュサービスで、
# memcached、redis、または valkey エンジンをサポートします。
#
# 主な特徴:
#   - 1分以内にキャッシュを作成可能
#   - 自動的に垂直・水平スケーリング
#   - 3つのアベイラビリティーゾーンに冗長化
#   - 99.99% の可用性 SLA
#   - 保存時および転送中の暗号化が常に有効
#
# AWS公式ドキュメント:
#   - ElastiCache Serverless 概要: https://docs.aws.amazon.com/AmazonElastiCache/latest/dg/WhatIs.deployment.html
#   - Redis OSS Serverless の作成: https://docs.aws.amazon.com/AmazonElastiCache/latest/dg/GettingStarted.serverless-redis.step1.html
#   - Valkey Serverless の作成: https://docs.aws.amazon.com/AmazonElastiCache/latest/dg/GettingStarted.serverless-valkey.step1.html
#   - Memcached Serverless の作成: https://docs.aws.amazon.com/AmazonElastiCache/latest/dg/create-serverless-cache-mem.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_serverless_cache
#
# Provider Version: 6.28.0
# Generated: 2026-01-23
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_elasticache_serverless_cache" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: サーバーレスキャッシュの一意識別子となるクラスター名を指定します。
  # 設定可能な値: 英数字とハイフンで構成される文字列
  # 注意: クラスター名は AWS アカウント内で一意である必要があります。
  name = "my-serverless-cache"

  # engine (Required)
  # 設定内容: キャッシュクラスターに使用するエンジンを指定します。
  # 設定可能な値:
  #   - "memcached": Memcached エンジン（スナップショット機能なし）
  #   - "redis": Redis OSS エンジン（スナップショット機能あり）
  #   - "valkey": Valkey エンジン（スナップショット機能あり）
  # 注意:
  #   - memcached はスナップショット関連機能をサポートしません
  #   - redis と valkey は User Group をサポートします
  engine = "redis"

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
  # エンジンバージョン設定
  #-------------------------------------------------------------

  # major_engine_version (Optional)
  # 設定内容: サーバーレスキャッシュの作成に使用するエンジンのメジャーバージョンを指定します。
  # 設定可能な値:
  #   - memcached: "1.6" など
  #   - redis: "7" など
  #   - valkey: "7" など
  # 省略時: 各エンジンの最新メジャーバージョンが使用されます。
  # 参考: aws elasticache describe-cache-engine-versions コマンドでサポートバージョンを確認
  #       https://docs.aws.amazon.com/cli/latest/reference/elasticache/describe-cache-engine-versions.html
  major_engine_version = "7"

  #-------------------------------------------------------------
  # 説明設定
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: サーバーレスキャッシュの説明を指定します。
  # 設定可能な値: 任意のテキスト文字列
  # 省略時: NULL
  description = "My ElastiCache Serverless Cache"

  #-------------------------------------------------------------
  # ネットワーク設定
  #-------------------------------------------------------------

  # subnet_ids (Optional)
  # 設定内容: サーバーレスキャッシュの VPC エンドポイントがデプロイされるサブネット ID のリストを指定します。
  # 設定可能な値: サブネット ID のリスト
  # 注意:
  #   - 指定するすべてのサブネットは同一 VPC に属している必要があります。
  #   - 複数のアベイラビリティーゾーンにまたがるサブネットを指定することを推奨します。
  subnet_ids = ["subnet-xxxxxxxxxxxxxxxxx", "subnet-yyyyyyyyyyyyyyyyy"]

  # security_group_ids (Optional)
  # 設定内容: サーバーレスキャッシュに関連付ける VPC セキュリティグループ ID のリストを指定します。
  # 設定可能な値: セキュリティグループ ID のリスト
  # 省略時: クラスター VPC エンドポイントに関連付けられた VPC のデフォルトセキュリティグループが使用されます。
  # 注意: セキュリティグループは VPC エンドポイント（PrivateLink）のトラフィックアクセスを許可します。
  security_group_ids = ["sg-xxxxxxxxxxxxxxxxx"]

  #-------------------------------------------------------------
  # 暗号化設定
  #-------------------------------------------------------------

  # kms_key_id (Optional)
  # 設定内容: 保存データの暗号化に使用するカスタマーマネージドキーの ARN を指定します。
  # 設定可能な値: KMS キーの ARN
  # 省略時: AWS マネージドキーが使用されます。
  # 注意:
  #   - ElastiCache Serverless では保存時暗号化が常に有効です。
  #   - 転送中の暗号化（TLS）も常に有効です。
  kms_key_id = "arn:aws:kms:ap-northeast-1:123456789012:key/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

  #-------------------------------------------------------------
  # スナップショット設定 (Redis/Valkey のみ)
  #-------------------------------------------------------------

  # daily_snapshot_time (Optional)
  # 設定内容: 自動スナップショットが作成される日次時刻（UTC）を指定します。
  # 設定可能な値: "HH:MM" 形式の文字列（例: "09:00"）
  # 対象: redis または valkey エンジンのみ
  # 省略時: デフォルト値 "0" が使用されます。
  # 注意: memcached エンジンではスナップショット機能はサポートされません。
  daily_snapshot_time = "09:00"

  # snapshot_retention_limit (Optional)
  # 設定内容: サーバーレスキャッシュの自動スナップショットを保持する日数を指定します。
  # 設定可能な値: 整数値（日数）
  # 対象: redis または valkey エンジンのみ
  # 注意:
  #   - 新しいスナップショットがこの制限を超えると、最も古いスナップショットがローリング削除されます。
  #   - memcached エンジンでは使用できません。
  snapshot_retention_limit = 7

  # snapshot_arns_to_restore (Optional)
  # 設定内容: 新しいサーバーレスキャッシュの作成元となるスナップショットの ARN リストを指定します。
  # 設定可能な値: スナップショット ARN のリスト
  # 対象: redis エンジンのみ
  # 注意:
  #   - 既存のスナップショットからキャッシュを復元する場合に使用します。
  #   - memcached エンジンでは使用できません。
  snapshot_arns_to_restore = null

  #-------------------------------------------------------------
  # ユーザーグループ設定 (Redis/Valkey のみ)
  #-------------------------------------------------------------

  # user_group_id (Optional)
  # 設定内容: サーバーレスキャッシュに関連付ける UserGroup の識別子を指定します。
  # 設定可能な値: UserGroup の ID
  # 対象: redis または valkey エンジンのみ
  # 省略時: NULL
  # 関連機能: ElastiCache ユーザーとユーザーグループ
  #   RBAC（ロールベースアクセス制御）を使用してキャッシュへのアクセスを制御できます。
  user_group_id = null

  #-------------------------------------------------------------
  # キャッシュ使用制限設定
  #-------------------------------------------------------------

  # cache_usage_limits (Optional)
  # 設定内容: キャッシュのストレージと ElastiCache Processing Units (ECPU) の使用制限を設定します。
  # 関連機能: ElastiCache Serverless の料金
  #   Serverless は使用量に基づく従量課金で、データストレージ（GB-時間）と
  #   リクエスト（ECPU）に基づいて課金されます。
  cache_usage_limits {
    # data_storage (Optional)
    # 設定内容: データストレージの制限を設定します。
    data_storage {
      # unit (Required)
      # 設定内容: ストレージの単位を指定します。
      # 設定可能な値: "GB"
      unit = "GB"

      # minimum (Optional)
      # 設定内容: データストレージの下限値を指定します。
      # 設定可能な値: 1〜5,000（GB）
      # 注意: 最小値を設定すると、その容量分の料金が常に発生します。
      minimum = 1

      # maximum (Optional)
      # 設定内容: データストレージの上限値を指定します。
      # 設定可能な値: 1〜5,000（GB）
      # 注意: この上限に達すると、キャッシュはそれ以上データを受け入れません。
      maximum = 10
    }

    # ecpu_per_second (Optional)
    # 設定内容: 1秒あたりの ECPU（ElastiCache Processing Units）の制限を設定します。
    # 関連機能: ECPU
    #   ECPU は ElastiCache Serverless のコンピューティング使用量の単位です。
    #   読み取り/書き込み操作ごとに ECPU が消費されます。
    ecpu_per_second {
      # minimum (Optional)
      # 設定内容: 1秒あたりの ECPU の下限値を指定します。
      # 設定可能な値: 1,000〜15,000,000
      # 注意: 最小値を設定すると、その容量分の料金が常に発生します。
      minimum = 1000

      # maximum (Optional)
      # 設定内容: 1秒あたりの ECPU の上限値を指定します。
      # 設定可能な値: 1,000〜15,000,000
      # 注意: この上限に達すると、リクエストがスロットリングされる可能性があります。
      maximum = 5000
    }
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWS リソースタグ付け
  #   プロバイダーレベルの default_tags 設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "my-serverless-cache"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト値を指定します。
  timeouts {
    # create (Optional)
    # 設定内容: 作成操作のタイムアウトを指定します。
    # 設定可能な値: "30s" や "2h45m" などの duration 文字列
    # 有効な単位: "s"（秒）, "m"（分）, "h"（時間）
    create = "40m"

    # update (Optional)
    # 設定内容: 更新操作のタイムアウトを指定します。
    # 設定可能な値: "30s" や "2h45m" などの duration 文字列
    # 有効な単位: "s"（秒）, "m"（分）, "h"（時間）
    update = "80m"

    # delete (Optional)
    # 設定内容: 削除操作のタイムアウトを指定します。
    # 設定可能な値: "30s" や "2h45m" などの duration 文字列
    # 有効な単位: "s"（秒）, "m"（分）, "h"（時間）
    # 注意: Delete 操作のタイムアウト設定は、削除操作の前に変更が state に保存される場合のみ適用されます。
    delete = "40m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: サーバーレスキャッシュの Amazon Resource Name (ARN)
#
# - id: サーバーレスキャッシュの識別子
#
# - create_time: サーバーレスキャッシュが作成されたタイムスタンプ
#
# - full_engine_version: サーバーレスキャッシュが互換性を持つエンジンの完全なバージョン番号
#                        （例: "7.0.7"）
#
# - major_engine_version: サーバーレスキャッシュが互換性を持つエンジンのメジャーバージョン番号
#
# - status: サーバーレスキャッシュの現在のステータス
#           有効な値: CREATING, AVAILABLE, DELETING, CREATE-FAILED, MODIFYING
#
# - endpoint: クライアントプログラムがキャッシュノードに接続するための情報
#   - endpoint[0].address: キャッシュノードの DNS ホスト名
#   - endpoint[0].port: キャッシュエンジンがリッスンしているポート番号（整数）
#
# - reader_endpoint: 読み取り専用接続用のエンドポイント情報
#   - reader_endpoint[0].address: リーダーエンドポイントの DNS ホスト名
#---------------------------------------------------------------
