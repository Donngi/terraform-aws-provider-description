#---------------------------------------------------------------
# AWS App Mesh Gateway Route
#---------------------------------------------------------------
#
# AWS App Meshのゲートウェイルートをプロビジョニングするリソースです。
# ゲートウェイルートは仮想ゲートウェイにアタッチされ、メッシュ外部からの
# トラフィックを既存の仮想サービスにルーティングします。
# HTTP、HTTP/2、gRPCプロトコルをサポートし、パス、ホスト名、ヘッダー等の
# 条件に基づいてルーティングルールを定義できます。
#
# AWS公式ドキュメント:
#   - App Mesh概念: https://docs.aws.amazon.com/app-mesh/latest/userguide/concepts.html
#   - Gateway Routes: https://docs.aws.amazon.com/app-mesh/latest/userguide/gateway-routes.html
#   - CreateGatewayRoute API: https://docs.aws.amazon.com/app-mesh/latest/APIReference/API_CreateGatewayRoute.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appmesh_gateway_route
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_appmesh_gateway_route" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required, Forces new resource)
  # 設定内容: ゲートウェイルートの名前を指定します。
  # 設定可能な値: 1〜255文字の文字列
  name = "example-gateway-route"

  # mesh_name (Required, Forces new resource)
  # 設定内容: ゲートウェイルートを作成するサービスメッシュの名前を指定します。
  # 設定可能な値: 1〜255文字の文字列
  mesh_name = "example-service-mesh"

  # virtual_gateway_name (Required, Forces new resource)
  # 設定内容: ゲートウェイルートを関連付ける仮想ゲートウェイの名前を指定します。
  # 設定可能な値: 1〜255文字の文字列
  # 関連機能: Virtual Gateway
  #   仮想ゲートウェイはメッシュ外部のリソースとメッシュ内部のリソース間の
  #   通信を可能にするEnvoyプロキシを表します。
  virtual_gateway_name = "example-virtual-gateway"

  # mesh_owner (Optional)
  # 設定内容: サービスメッシュの所有者のAWSアカウントIDを指定します。
  # 設定可能な値: 有効なAWSアカウントID
  # 省略時: 現在接続されているAWSプロバイダーのアカウントIDを使用
  # 用途: クロスアカウントでメッシュを共有する場合に使用
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
  # ゲートウェイルートの仕様を定義します。
  # grpc_route、http_route、http2_routeのいずれか1つを指定します。

  spec {
    # priority (Optional)
    # 設定内容: ゲートウェイルートの優先度を指定します。
    # 設定可能な値: 0〜1000の整数（小さい値ほど高い優先度）
    # 用途: 複数のルートがマッチする場合の優先順位を決定
    priority = 100

    #-----------------------------------------------------------
    # HTTP Route (http_route)
    #-----------------------------------------------------------
    # HTTP/1.1トラフィックのルーティング仕様を定義します。

    http_route {
      #---------------------------------------------------------
      # マッチ条件 (match)
      #---------------------------------------------------------

      match {
        # prefix (Optional)
        # 設定内容: リクエストパスのプレフィックスでマッチングします。
        # 設定可能な値: "/"で始まる文字列
        # 注意: "/"単独で指定すると、仮想サービス名へのすべてのリクエストにマッチ
        prefix = "/"

        # port (Optional)
        # 設定内容: マッチングするリクエストのポート番号を指定します。
        # 設定可能な値: 有効なポート番号
        # 用途: 仮想サービスプロバイダーが複数のリスナーを持つ場合に使用
        # port = 8080

        # path (Optional)
        # パスでのマッチング条件を指定します。
        # path {
        #   # exact (Optional)
        #   # 設定内容: 完全一致するパスを指定します。
        #   exact = "/api/v1/users"

        #   # regex (Optional)
        #   # 設定内容: 正規表現でパスをマッチングします。
        #   # regex = "/api/v[0-9]+/.*"
        # }

        # hostname (Optional)
        # ホスト名でのマッチング条件を指定します。
        # hostname {
        #   # exact (Optional)
        #   # 設定内容: 完全一致するホスト名を指定します。
        #   exact = "api.example.com"

        #   # suffix (Optional)
        #   # 設定内容: ホスト名の末尾でマッチングします。
        #   # suffix = ".example.com"
        # }

        # header (Optional, 最大10個)
        # HTTPヘッダーでのマッチング条件を指定します。
        # header {
        #   # name (Required)
        #   # 設定内容: マッチングするHTTPヘッダーの名前を指定します。
        #   name = "X-Custom-Header"

        #   # invert (Optional)
        #   # 設定内容: マッチ条件を反転するかを指定します。
        #   # 設定可能な値: true / false (デフォルト: false)
        #   invert = false

        #   # match (Optional)
        #   # ヘッダー値のマッチング方法を指定します。
        #   match {
        #     # exact (Optional)
        #     # 設定内容: ヘッダー値が完全一致する値を指定します。
        #     exact = "expected-value"

        #     # prefix (Optional)
        #     # 設定内容: ヘッダー値が指定した文字列で始まることを条件とします。
        #     # prefix = "Bearer "

        #     # suffix (Optional)
        #     # 設定内容: ヘッダー値が指定した文字列で終わることを条件とします。
        #     # suffix = "-suffix"

        #     # regex (Optional)
        #     # 設定内容: ヘッダー値を正規表現でマッチングします。
        #     # regex = "^v[0-9]+$"

        #     # range (Optional)
        #     # 数値範囲でのマッチング条件を指定します。
        #     # range {
        #     #   # start (Required)
        #     #   # 設定内容: 範囲の開始値を指定します。
        #     #   start = 1

        #     #   # end (Required)
        #     #   # 設定内容: 範囲の終了値を指定します。
        #     #   end = 100
        #     # }
        #   }
        # }

        # query_parameter (Optional, 最大10個)
        # クエリパラメータでのマッチング条件を指定します。
        # query_parameter {
        #   # name (Required)
        #   # 設定内容: マッチングするクエリパラメータの名前を指定します。
        #   name = "version"

        #   # match (Optional)
        #   # クエリパラメータ値のマッチング方法を指定します。
        #   match {
        #     # exact (Optional)
        #     # 設定内容: クエリパラメータ値が完全一致する値を指定します。
        #     exact = "v2"
        #   }
        # }
      }

      #---------------------------------------------------------
      # アクション (action)
      #---------------------------------------------------------

      action {
        # target (Required)
        # トラフィックのルーティング先を指定します。

        target {
          # port (Optional)
          # 設定内容: 仮想サービスプロバイダーのターゲットポート番号を指定します。
          # 設定可能な値: 有効なポート番号
          # 用途: プロバイダー（ルーターまたはノード）が複数のリスナーを持つ場合に必須
          # port = 8080

          # virtual_service (Required)
          # ルーティング先の仮想サービスを指定します。
          virtual_service {
            # virtual_service_name (Required)
            # 設定内容: トラフィックをルーティングする仮想サービスの名前を指定します。
            # 設定可能な値: 1〜255文字の文字列
            virtual_service_name = "example-virtual-service"
          }
        }

        # rewrite (Optional)
        # リクエストの書き換えルールを指定します。
        # rewrite {
        #   # hostname (Optional)
        #   # ホスト名の書き換えルールを指定します。
        #   hostname {
        #     # default_target_hostname (Required)
        #     # 設定内容: デフォルトのターゲットホスト名の書き換え方法を指定します。
        #     # 設定可能な値:
        #     #   - "ENABLED": ターゲットの仮想サービス名でホスト名を書き換え
        #     #   - "DISABLED": ホスト名の書き換えを無効化
        #     default_target_hostname = "ENABLED"
        #   }

        #   # path (Optional)
        #   # パスの書き換えルールを指定します。
        #   # path {
        #   #   # exact (Required)
        #   #   # 設定内容: マッチしたパスを置換する値を指定します。
        #   #   exact = "/new-path"
        #   # }

        #   # prefix (Optional)
        #   # プレフィックスの書き換えルールを指定します。
        #   # prefix {
        #   #   # default_prefix (Optional)
        #   #   # 設定内容: デフォルトのプレフィックス書き換え方法を指定します。
        #   #   # 設定可能な値:
        #   #   #   - "ENABLED": マッチしたプレフィックスをターゲットの仮想サービス名に置換
        #   #   #   - "DISABLED": プレフィックスの書き換えを無効化
        #   #   default_prefix = "ENABLED"

        #   #   # value (Optional)
        #   #   # 設定内容: マッチしたプレフィックスを置換する値を指定します。
        #   #   # value = "/api/v2"
        #   # }
        # }
      }
    }

    #-----------------------------------------------------------
    # HTTP/2 Route (http2_route) - 代替オプション
    #-----------------------------------------------------------
    # HTTP/2トラフィックのルーティング仕様を定義します。
    # http_routeと同様の構造を持ちます。

    # http2_route {
    #   match {
    #     prefix = "/"
    #     # port, path, hostname, header, query_parameter は http_route と同様
    #   }

    #   action {
    #     target {
    #       virtual_service {
    #         virtual_service_name = "example-virtual-service"
    #       }
    #     }
    #     # rewrite は http_route と同様
    #   }
    # }

    #-----------------------------------------------------------
    # gRPC Route (grpc_route) - 代替オプション
    #-----------------------------------------------------------
    # gRPCトラフィックのルーティング仕様を定義します。

    # grpc_route {
    #   match {
    #     # service_name (Required)
    #     # 設定内容: マッチングするサービスの完全修飾ドメイン名を指定します。
    #     service_name = "com.example.grpc.MyService"

    #     # port (Optional)
    #     # 設定内容: マッチングするリクエストのポート番号を指定します。
    #     # port = 50051
    #   }

    #   action {
    #     target {
    #       # port (Optional)
    #       # port = 50051

    #       virtual_service {
    #         virtual_service_name = "example-grpc-virtual-service"
    #       }
    #     }
    #   }
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
    Name        = "example-gateway-route"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: ゲートウェイルートのID
#
# - arn: ゲートウェイルートのAmazon Resource Name (ARN)
#
# - created_date: ゲートウェイルートの作成日時
#
# - last_updated_date: ゲートウェイルートの最終更新日時
#
# - resource_owner: リソース所有者のAWSアカウントID
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
