#---------------------------------------------------------------
# AWS App Mesh Route
#---------------------------------------------------------------
#
# AWS App Meshのルートをプロビジョニングするリソースです。
# ルートは仮想ルーターに関連付けられ、リクエストを仮想ノードに
# ルーティングするための条件とアクションを定義します。
# HTTP、HTTP/2、gRPC、TCPプロトコルに対応しています。
#
# AWS公式ドキュメント:
#   - App Mesh概要: https://docs.aws.amazon.com/app-mesh/latest/userguide/what-is-app-mesh.html
#   - ルート: https://docs.aws.amazon.com/app-mesh/latest/userguide/routes.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appmesh_route
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_appmesh_route" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required, Forces new resource)
  # 設定内容: ルートの名前を指定します。
  # 設定可能な値: 1-255文字の文字列
  name = "example-route"

  # mesh_name (Required, Forces new resource)
  # 設定内容: ルートを作成するサービスメッシュの名前を指定します。
  # 設定可能な値: 1-255文字の文字列
  mesh_name = "example-mesh"

  # virtual_router_name (Required, Forces new resource)
  # 設定内容: ルートを作成する仮想ルーターの名前を指定します。
  # 設定可能な値: 1-255文字の文字列
  virtual_router_name = "example-virtual-router"

  # mesh_owner (Optional)
  # 設定内容: サービスメッシュの所有者のAWSアカウントIDを指定します。
  # 設定可能な値: AWSアカウントID
  # 省略時: 現在接続しているAWSプロバイダーのアカウントID
  # 用途: 別のアカウントが所有するメッシュ内にルートを作成する場合に使用
  mesh_owner = null

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # ルート仕様 (spec)
  #-------------------------------------------------------------

  # spec (Required)
  # 設定内容: ルートの仕様を定義するブロックです。
  # grpc_route、http2_route、http_route、tcp_routeのいずれかを指定します。
  spec {
    # priority (Optional)
    # 設定内容: ルートの優先度を指定します。
    # 設定可能な値: 0-1000の整数。値が小さいほど優先度が高い。
    # 用途: 複数のルートが同じリクエストにマッチする場合の優先順位を決定
    priority = 100

    #-----------------------------------------------------------
    # HTTP Route（HTTPルーティング）
    #-----------------------------------------------------------
    # HTTP/1.1リクエストのルーティング設定

    http_route {
      #---------------------------------------------------------
      # Match（マッチング条件）
      #---------------------------------------------------------

      # match (Required)
      # 設定内容: HTTPリクエストのマッチング条件を定義します。
      match {
        # prefix (Optional)
        # 設定内容: リクエストパスのプレフィックスでマッチングします。
        # 設定可能な値: / で始まる文字列
        # 注意: / のみを指定すると、仮想ルーターへのすべてのリクエストにマッチします
        prefix = "/"

        # method (Optional)
        # 設定内容: HTTPメソッドでマッチングします。
        # 設定可能な値: GET, HEAD, POST, PUT, DELETE, CONNECT, OPTIONS, TRACE, PATCH
        method = null

        # scheme (Optional)
        # 設定内容: HTTPスキームでマッチングします。
        # 設定可能な値: http, https
        scheme = null

        # port (Optional)
        # 設定内容: ポート番号でマッチングします。
        # 設定可能な値: 1-65535の整数
        port = null

        # path (Optional)
        # 設定内容: リクエストパスでマッチングします。
        # path {
        #   # exact (Optional)
        #   # 設定内容: 完全一致するパスを指定します。
        #   exact = "/api/v1/users"
        #
        #   # regex (Optional)
        #   # 設定内容: 正規表現でパスをマッチングします。
        #   regex = "/api/v[0-9]+/.*"
        # }

        # header (Optional, max: 10)
        # 設定内容: HTTPヘッダーでマッチングします。
        # header {
        #   # name (Required)
        #   # 設定内容: マッチングするヘッダー名を指定します。
        #   name = "X-Custom-Header"
        #
        #   # invert (Optional)
        #   # 設定内容: マッチング条件を反転します。
        #   # 設定可能な値: true, false (デフォルト: false)
        #   invert = false
        #
        #   # match (Optional)
        #   # 設定内容: ヘッダー値のマッチング条件を指定します。
        #   # match {
        #   #   # exact (Optional)
        #   #   # 設定内容: 完全一致する値を指定します。1-255文字
        #   #   exact = "exact-value"
        #   #
        #   #   # prefix (Optional)
        #   #   # 設定内容: プレフィックスで一致する値を指定します。1-255文字
        #   #   prefix = "prefix-"
        #   #
        #   #   # suffix (Optional)
        #   #   # 設定内容: サフィックスで一致する値を指定します。1-255文字
        #   #   suffix = "-suffix"
        #   #
        #   #   # regex (Optional)
        #   #   # 設定内容: 正規表現でマッチングします。1-255文字
        #   #   regex = ".*pattern.*"
        #   #
        #   #   # range (Optional)
        #   #   # 設定内容: 数値範囲でマッチングします。
        #   #   # range {
        #   #   #   # start (Required)
        #   #   #   # 設定内容: 範囲の開始値を指定します。
        #   #   #   start = 1
        #   #   #
        #   #   #   # end (Required)
        #   #   #   # 設定内容: 範囲の終了値を指定します。
        #   #   #   end = 100
        #   #   # }
        #   # }
        # }

        # query_parameter (Optional, max: 10)
        # 設定内容: クエリパラメータでマッチングします。
        # query_parameter {
        #   # name (Required)
        #   # 設定内容: マッチングするクエリパラメータ名を指定します。
        #   name = "version"
        #
        #   # match (Optional)
        #   # 設定内容: クエリパラメータ値のマッチング条件を指定します。
        #   # match {
        #   #   # exact (Optional)
        #   #   # 設定内容: 完全一致する値を指定します。
        #   #   exact = "v1"
        #   # }
        # }
      }

      #---------------------------------------------------------
      # Action（アクション）
      #---------------------------------------------------------

      # action (Required)
      # 設定内容: マッチしたリクエストに対するアクションを定義します。
      action {
        # weighted_target (Required, min: 1, max: 10)
        # 設定内容: トラフィックをルーティングするターゲットと重みを指定します。
        # 複数指定することで重み付けルーティングが可能です。
        weighted_target {
          # virtual_node (Required)
          # 設定内容: ルーティング先の仮想ノード名を指定します。
          # 設定可能な値: 1-255文字の文字列
          virtual_node = "example-virtual-node"

          # weight (Required)
          # 設定内容: このターゲットへのトラフィックの重みを指定します。
          # 設定可能な値: 0-100の整数。すべてのターゲットの合計は100である必要があります。
          weight = 100

          # port (Optional)
          # 設定内容: ターゲットのポート番号を指定します。
          # 設定可能な値: 1-65535の整数
          port = null
        }
      }

      #---------------------------------------------------------
      # Retry Policy（リトライポリシー）
      #---------------------------------------------------------

      # retry_policy (Optional)
      # 設定内容: リクエストのリトライポリシーを定義します。
      # retry_policy {
      #   # max_retries (Required)
      #   # 設定内容: 最大リトライ回数を指定します。
      #   max_retries = 3
      #
      #   # per_retry_timeout (Required)
      #   # 設定内容: リトライごとのタイムアウトを指定します。
      #   per_retry_timeout {
      #     # unit (Required)
      #     # 設定内容: 時間の単位を指定します。
      #     # 設定可能な値: ms (ミリ秒), s (秒)
      #     unit = "s"
      #
      #     # value (Required)
      #     # 設定内容: タイムアウト値を指定します。
      #     # 設定可能な値: 0以上の整数
      #     value = 15
      #   }
      #
      #   # http_retry_events (Optional)
      #   # 設定内容: リトライをトリガーするHTTPイベントを指定します。
      #   # 設定可能な値:
      #   #   - client-error: HTTPステータスコード409
      #   #   - gateway-error: HTTPステータスコード502, 503, 504
      #   #   - server-error: HTTPステータスコード500, 501, 502, 503, 504, 505, 506, 507, 508, 510, 511
      #   #   - stream-error: ストリームが拒否された場合
      #   http_retry_events = ["server-error", "gateway-error"]
      #
      #   # tcp_retry_events (Optional)
      #   # 設定内容: リトライをトリガーするTCPイベントを指定します。
      #   # 設定可能な値: connection-error
      #   tcp_retry_events = ["connection-error"]
      # }

      #---------------------------------------------------------
      # Timeout（タイムアウト）
      #---------------------------------------------------------

      # timeout (Optional)
      # 設定内容: タイムアウト設定を定義します。
      # timeout {
      #   # idle (Optional)
      #   # 設定内容: アイドルタイムアウトを指定します。
      #   # 接続がアイドル状態でいられる最大時間を設定します。
      #   idle {
      #     # unit (Required)
      #     # 設定内容: 時間の単位を指定します。
      #     # 設定可能な値: ms (ミリ秒), s (秒)
      #     unit = "s"
      #
      #     # value (Required)
      #     # 設定内容: タイムアウト値を指定します。
      #     # 設定可能な値: 0以上の整数
      #     value = 300
      #   }
      #
      #   # per_request (Optional)
      #   # 設定内容: リクエストごとのタイムアウトを指定します。
      #   per_request {
      #     # unit (Required)
      #     # 設定内容: 時間の単位を指定します。
      #     # 設定可能な値: ms (ミリ秒), s (秒)
      #     unit = "s"
      #
      #     # value (Required)
      #     # 設定内容: タイムアウト値を指定します。
      #     # 設定可能な値: 0以上の整数
      #     value = 30
      #   }
      # }
    }

    #-----------------------------------------------------------
    # HTTP/2 Route（HTTP/2ルーティング）
    #-----------------------------------------------------------
    # HTTP/2リクエストのルーティング設定
    # http_routeと同じ構造を持ちます。

    # http2_route {
    #   match {
    #     prefix = "/"
    #     method = null
    #     scheme = null
    #     port = null
    #
    #     # path (Optional)
    #     # path {
    #     #   exact = "/api/v1/users"
    #     #   regex = null
    #     # }
    #
    #     # header (Optional, max: 10)
    #     # header {
    #     #   name = "X-Custom-Header"
    #     #   invert = false
    #     #   match {
    #     #     exact = "value"
    #     #     prefix = null
    #     #     suffix = null
    #     #     regex = null
    #     #     range {
    #     #       start = 1
    #     #       end = 100
    #     #     }
    #     #   }
    #     # }
    #
    #     # query_parameter (Optional, max: 10)
    #     # query_parameter {
    #     #   name = "version"
    #     #   match {
    #     #     exact = "v1"
    #     #   }
    #     # }
    #   }
    #
    #   action {
    #     weighted_target {
    #       virtual_node = "example-virtual-node"
    #       weight = 100
    #       port = null
    #     }
    #   }
    #
    #   # retry_policy (Optional)
    #   # retry_policy {
    #   #   max_retries = 3
    #   #   per_retry_timeout {
    #   #     unit = "s"
    #   #     value = 15
    #   #   }
    #   #   http_retry_events = ["server-error"]
    #   #   tcp_retry_events = ["connection-error"]
    #   # }
    #
    #   # timeout (Optional)
    #   # timeout {
    #   #   idle {
    #   #     unit = "s"
    #   #     value = 300
    #   #   }
    #   #   per_request {
    #   #     unit = "s"
    #   #     value = 30
    #   #   }
    #   # }
    # }

    #-----------------------------------------------------------
    # gRPC Route（gRPCルーティング）
    #-----------------------------------------------------------
    # gRPCリクエストのルーティング設定

    # grpc_route {
    #   #---------------------------------------------------------
    #   # Match（マッチング条件）
    #   #---------------------------------------------------------
    #
    #   # match (Required)
    #   # 設定内容: gRPCリクエストのマッチング条件を定義します。
    #   match {
    #     # service_name (Optional)
    #     # 設定内容: マッチングするサービスの完全修飾ドメイン名を指定します。
    #     service_name = "my.package.MyService"
    #
    #     # method_name (Optional)
    #     # 設定内容: マッチングするメソッド名を指定します。
    #     # 注意: method_nameを指定する場合はservice_nameも指定する必要があります
    #     method_name = "MyMethod"
    #
    #     # port (Optional)
    #     # 設定内容: ポート番号でマッチングします。
    #     # 設定可能な値: 1-65535の整数
    #     port = null
    #
    #     # prefix (Optional)
    #     # 設定内容: サービス名のプレフィックスでマッチングします。
    #     prefix = null
    #
    #     # metadata (Optional, max: 10)
    #     # 設定内容: gRPCメタデータでマッチングします。
    #     # metadata {
    #     #   # name (Required)
    #     #   # 設定内容: マッチングするメタデータ名を指定します。1-50文字
    #     #   name = "x-custom-metadata"
    #     #
    #     #   # invert (Optional)
    #     #   # 設定内容: マッチング条件を反転します。
    #     #   # 設定可能な値: true, false (デフォルト: false)
    #     #   invert = false
    #     #
    #     #   # match (Optional)
    #     #   # 設定内容: メタデータ値のマッチング条件を指定します。
    #     #   # match {
    #     #   #   exact = "exact-value"
    #     #   #   prefix = "prefix-"
    #     #   #   suffix = "-suffix"
    #     #   #   regex = ".*pattern.*"
    #     #   #   range {
    #     #   #     start = 1
    #     #   #     end = 100
    #     #   #   }
    #     #   # }
    #     # }
    #   }
    #
    #   #---------------------------------------------------------
    #   # Action（アクション）
    #   #---------------------------------------------------------
    #
    #   action {
    #     weighted_target {
    #       virtual_node = "example-virtual-node"
    #       weight = 100
    #       port = null
    #     }
    #   }
    #
    #   #---------------------------------------------------------
    #   # Retry Policy（リトライポリシー）
    #   #---------------------------------------------------------
    #
    #   # retry_policy (Optional)
    #   # retry_policy {
    #   #   max_retries = 3
    #   #
    #   #   per_retry_timeout {
    #   #     unit = "s"
    #   #     value = 15
    #   #   }
    #   #
    #   #   # grpc_retry_events (Optional)
    #   #   # 設定内容: リトライをトリガーするgRPCイベントを指定します。
    #   #   # 設定可能な値:
    #   #   #   - cancelled: リクエストがキャンセルされた
    #   #   #   - deadline-exceeded: デッドラインを超過した
    #   #   #   - internal: 内部エラー
    #   #   #   - resource-exhausted: リソースが枯渇した
    #   #   #   - unavailable: サービスが利用不可
    #   #   grpc_retry_events = ["cancelled", "unavailable"]
    #   #
    #   #   # http_retry_events (Optional)
    #   #   # 設定内容: リトライをトリガーするHTTPイベントを指定します。
    #   #   http_retry_events = ["server-error"]
    #   #
    #   #   # tcp_retry_events (Optional)
    #   #   # 設定内容: リトライをトリガーするTCPイベントを指定します。
    #   #   tcp_retry_events = ["connection-error"]
    #   # }
    #
    #   #---------------------------------------------------------
    #   # Timeout（タイムアウト）
    #   #---------------------------------------------------------
    #
    #   # timeout (Optional)
    #   # timeout {
    #   #   idle {
    #   #     unit = "s"
    #   #     value = 300
    #   #   }
    #   #   per_request {
    #   #     unit = "s"
    #   #     value = 30
    #   #   }
    #   # }
    # }

    #-----------------------------------------------------------
    # TCP Route（TCPルーティング）
    #-----------------------------------------------------------
    # TCPリクエストのルーティング設定

    # tcp_route {
    #   #---------------------------------------------------------
    #   # Match（マッチング条件）
    #   #---------------------------------------------------------
    #
    #   # match (Optional)
    #   # 設定内容: TCPリクエストのマッチング条件を定義します。
    #   # match {
    #   #   # port (Optional)
    #   #   # 設定内容: ポート番号でマッチングします。
    #   #   # 設定可能な値: 1-65535の整数
    #   #   port = 8080
    #   # }
    #
    #   #---------------------------------------------------------
    #   # Action（アクション）
    #   #---------------------------------------------------------
    #
    #   action {
    #     weighted_target {
    #       virtual_node = "example-virtual-node"
    #       weight = 100
    #       port = null
    #     }
    #   }
    #
    #   #---------------------------------------------------------
    #   # Timeout（タイムアウト）
    #   #---------------------------------------------------------
    #
    #   # timeout (Optional)
    #   # timeout {
    #   #   idle {
    #   #     unit = "s"
    #   #     value = 300
    #   #   }
    #   # }
    # }
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
    Name        = "example-route"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: ルートのID
#
# - arn: ルートのAmazon Resource Name (ARN)
#
# - created_date: ルートの作成日時
#
# - last_updated_date: ルートの最終更新日時
#
# - resource_owner: リソース所有者のAWSアカウントID
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
