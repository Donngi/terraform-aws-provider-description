#---------------------------------------------------------------
# Amazon OpenSearch Service Outbound Connection
#---------------------------------------------------------------
#
# Amazon OpenSearch Serviceのアウトバウンド接続をプロビジョニングするリソースです。
# アウトバウンド接続は、ソースドメインから宛先ドメインへのクロスクラスター検索を
# 可能にします。異なるAWSアカウントやリージョン間でのクエリや集計を実行できます。
#
# AWS公式ドキュメント:
#   - クロスクラスター検索: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/cross-cluster-search.html
#   - CreateOutboundConnection API: https://docs.aws.amazon.com/opensearch-service/latest/APIReference/API_CreateOutboundConnection.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/opensearch_outbound_connection
#
# Provider Version: 6.28.0
# Generated: 2026-02-02
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_opensearch_outbound_connection" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # connection_alias (Required, Forces new resource)
  # 設定内容: アウトバウンド接続に使用されるエイリアス名を指定します。
  # 設定可能な値: 文字列。この名前はクロスクラスター検索時にインデックスパターンで使用されます。
  # 注意: リソース作成後の変更は新しいリソースの作成を強制します。
  # 用途: OpenSearch Dashboardsでのデータ可視化時に `connection-alias:index` の形式で使用
  # 参考: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/cross-cluster-search.html
  connection_alias = "outbound_connection"

  # connection_mode (Optional, Forces new resource)
  # 設定内容: 接続モードを指定します。
  # 設定可能な値:
  #   - "DIRECT": 直接接続モード
  #   - "VPC_ENDPOINT": VPCエンドポイント経由の接続モード
  # 省略時: 自動的に設定されます。
  # 注意: リソース作成後の変更は新しいリソースの作成を強制します。
  # 参考: https://docs.aws.amazon.com/opensearch-service/latest/APIReference/API_CreateOutboundConnection.html
  connection_mode = "DIRECT"

  # accept_connection (Optional, Forces new resource)
  # 設定内容: 接続リクエストを自動的に受け入れるかを指定します。
  # 設定可能な値:
  #   - true: 接続を自動的に受け入れます
  #   - false: 手動での承認が必要です
  # 省略時: false（手動承認が必要）
  # 注意: リソース作成後の変更は新しいリソースの作成を強制します。
  # 参考: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/cross-cluster-search.html
  accept_connection = false

  # id (Optional)
  # 設定内容: リソースのIDを指定します。
  # 省略時: 自動的に生成されます。
  # 注意: 通常は明示的に指定する必要はありません。
  id = null

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
  # ローカルドメイン情報
  #-------------------------------------------------------------

  # local_domain_info (Required, Forces new resource)
  # 設定内容: ソース側（ローカル）のOpenSearchドメイン情報を指定します。
  # 必須: このブロックは必ず1つ指定する必要があります。
  # 注意: リソース作成後の変更は新しいリソースの作成を強制します。
  # 参考: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/cross-cluster-search.html
  local_domain_info {
    # owner_id (Required, Forces new resource)
    # 設定内容: ローカルドメインの所有者のAWSアカウントIDを指定します。
    # 設定可能な値: 12桁のAWSアカウントID
    # 注意: リソース作成後の変更は新しいリソースの作成を強制します。
    owner_id = "123456789012"

    # domain_name (Required, Forces new resource)
    # 設定内容: ローカルドメインの名前を指定します。
    # 設定可能な値: 既存のOpenSearchドメイン名
    # 注意: リソース作成後の変更は新しいリソースの作成を強制します。
    domain_name = "local-domain"

    # region (Required, Forces new resource)
    # 設定内容: ローカルドメインが存在するリージョンを指定します。
    # 設定可能な値: 有効なAWSリージョンコード
    # 注意: リソース作成後の変更は新しいリソースの作成を強制します。
    region = "ap-northeast-1"
  }

  #-------------------------------------------------------------
  # リモートドメイン情報
  #-------------------------------------------------------------

  # remote_domain_info (Required, Forces new resource)
  # 設定内容: 宛先側（リモート）のOpenSearchドメイン情報を指定します。
  # 必須: このブロックは必ず1つ指定する必要があります。
  # 注意: リソース作成後の変更は新しいリソースの作成を強制します。
  # 用途: クロスアカウントやクロスリージョンでのデータアクセスに使用
  # 参考: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/application-cross-cluster-search.html
  remote_domain_info {
    # owner_id (Required, Forces new resource)
    # 設定内容: リモートドメインの所有者のAWSアカウントIDを指定します。
    # 設定可能な値: 12桁のAWSアカウントID
    # 注意: リソース作成後の変更は新しいリソースの作成を強制します。
    owner_id = "123456789012"

    # domain_name (Required, Forces new resource)
    # 設定内容: リモートドメインの名前を指定します。
    # 設定可能な値: 既存のOpenSearchドメイン名
    # 注意: リソース作成後の変更は新しいリソースの作成を強制します。
    domain_name = "remote-domain"

    # region (Required, Forces new resource)
    # 設定内容: リモートドメインが存在するリージョンを指定します。
    # 設定可能な値: 有効なAWSリージョンコード
    # 注意: リソース作成後の変更は新しいリソースの作成を強制します。
    region = "us-east-1"
  }

  #-------------------------------------------------------------
  # 接続プロパティ
  #-------------------------------------------------------------

  # connection_properties (Optional, Forces new resource)
  # 設定内容: アウトバウンド接続の追加プロパティを指定します。
  # 省略可能: このブロックは省略可能です（最大1つまで指定可能）。
  # 注意: リソース作成後の変更は新しいリソースの作成を強制します。
  # 参考: https://docs.aws.amazon.com/opensearch-service/latest/APIReference/API_ConnectionProperties.html
  connection_properties {
    # cross_cluster_search (Optional, Forces new resource)
    # 設定内容: クロスクラスター検索の設定を指定します。
    # 省略可能: このブロックは省略可能です（最大1つまで指定可能）。
    # 注意: リソース作成後の変更は新しいリソースの作成を強制します。
    cross_cluster_search {
      # skip_unavailable (Optional, Forces new resource)
      # 設定内容: 利用不可能なクラスターをスキップするかを指定します。
      # 設定可能な値:
      #   - "ENABLED": 利用不可能なクラスターをスキップしてクロスクラスター検索を継続
      #   - "DISABLED": 利用不可能なクラスターがある場合は検索を失敗させる
      # 省略時: デフォルト動作が適用されます。
      # 用途: クロスクラスター検索でのみ使用可能。障害発生時の可用性を向上させます。
      # 注意: リソース作成後の変更は新しいリソースの作成を強制します。
      # 参考: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/cross-cluster-search.html
      skip_unavailable = "DISABLED"
    }
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定します。
  # 省略可能: このブロックは省略可能です。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成のタイムアウト時間を指定します。
    # 設定可能な値: 時間の文字列（例: "5m", "1h"）
    # 省略時: デフォルトのタイムアウト時間が使用されます。
    create = "5m"

    # delete (Optional)
    # 設定内容: リソース削除のタイムアウト時間を指定します。
    # 設定可能な値: 時間の文字列（例: "5m", "1h"）
    # 省略時: デフォルトのタイムアウト時間が使用されます。
    delete = "5m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: 接続のID
#
# - connection_status: 接続リクエストのステータス
#        接続の現在の状態を示します（例: PENDING_ACCEPTANCE, ACTIVE等）
#
# - connection_properties.0.endpoint: リモートドメインのエンドポイント
#        connection_modeが"VPC_ENDPOINT"で、accept_connectionが"true"の場合のみ設定されます
#---------------------------------------------------------------
