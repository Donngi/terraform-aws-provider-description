#---------------------------------------------------------------
# Lightsail Container Service Deployment Version
#---------------------------------------------------------------
#
# Lightsailコンテナサービスのデプロイメントバージョンを管理するリソースです。
# コンテナ化されたアプリケーションを特定のコンテナ設定でLightsailコンテナサービスに
# デプロイできます。各デプロイメントは新しいバージョンを作成し、サービスごとに
# 最新50バージョンが保持されます。
#
# AWS公式ドキュメント:
#   - Container Services概要: https://docs.aws.amazon.com/lightsail/latest/userguide/amazon-lightsail-container-services.html
#   - CreateContainerServiceDeployment API: https://docs.aws.amazon.com/lightsail/2016-11-28/api-reference/API_CreateContainerServiceDeployment.html
#   - Deployment Versions: https://docs.aws.amazon.com/lightsail/latest/userguide/amazon-lightsail-container-services-deployment-versions.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lightsail_container_service_deployment_version
#
# Provider Version: 6.28.0
# Generated: 2026-01-31
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lightsail_container_service_deployment_version" "example" {
  #-------------------------------------------------------------
  # 必須パラメータ
  #-------------------------------------------------------------

  # service_name (Required)
  # 設定内容: デプロイメント先のLightsailコンテナサービスの名前を指定します。
  # 設定可能な値: 既存のLightsailコンテナサービス名（1-63文字、小文字英数字とハイフンのみ）
  # 注意: コンテナサービスはREADYまたはRUNNING状態である必要があります。
  # 参考: https://docs.aws.amazon.com/lightsail/latest/userguide/amazon-lightsail-container-services.html
  service_name = "example-container-service"

  #-------------------------------------------------------------
  # コンテナ設定
  #-------------------------------------------------------------

  # container (Required, 1-53個)
  # 設定内容: コンテナサービスで起動するコンテナの設定を記述します。
  # 設定可能な値: 最小1個、最大53個のコンテナブロック
  # 関連機能: Container Deployments
  #   各コンテナは個別のプロセスとして実行され、イメージソース、環境変数、
  #   ポート、起動コマンドなどを指定できます。
  #   - https://docs.aws.amazon.com/lightsail/latest/userguide/amazon-lightsail-container-services-deployments.html
  container {
    # container_name (Required)
    # 設定内容: コンテナの一意の名前を指定します。
    # 設定可能な値: 英数字とハイフンのみ（デプロイメント内で一意）
    # 注意: この名前はpublic_endpointブロックでの参照にも使用されます。
    container_name = "hello-world"

    # image (Required)
    # 設定内容: 使用するコンテナイメージを指定します。
    # 設定可能な値:
    #   - パブリックレジストリ: "nginx:latest", "amazon/amazon-lightsail:hello-world"
    #   - Lightsailストレージイメージ: ":container-service-1.mystaticwebsite.1" (コロンで開始)
    # 関連機能: Container Images
    #   Docker HubやAmazon ECR Public Galleryのパブリックイメージ、または
    #   ローカルからプッシュしたカスタムイメージを使用できます。Linux基盤のみサポート。
    #   - https://docs.aws.amazon.com/lightsail/latest/userguide/amazon-lightsail-container-services-images.html
    image = "amazon/amazon-lightsail:hello-world"

    # command (Optional)
    # 設定内容: コンテナ起動時に実行するコマンドを文字列のリストで指定します。
    # 設定可能な値: 文字列のリスト（例: ["node", "server.js"]）
    # 省略時: イメージのデフォルトCMDが使用されます。
    # 注意: 初期化スクリプトの実行やアプリケーション設定に使用できます。
    command = []

    # environment (Optional)
    # 設定内容: コンテナの環境変数をキー/値のマップで指定します。
    # 設定可能な値: 文字列のキー/値マップ
    # 省略時: 環境変数は設定されません。
    # 関連機能: Service Communication
    #   同一サービス内のコンテナ間通信には"localhost"を使用、
    #   異なるサービスとの通信には"<service-name>.service.local"形式を使用します。
    #   - https://docs.aws.amazon.com/lightsail/latest/userguide/amazon-lightsail-container-services-private-domain.html
    # 注意: センシティブな情報はAWS Secrets ManagerやParameter Storeの使用を推奨します。
    environment = {
      MY_ENVIRONMENT_VARIABLE = "my_value"
    }

    # ports (Optional)
    # 設定内容: コンテナで開くファイアウォールポートをポート番号とプロトコルのマップで指定します。
    # 設定可能な値:
    #   - キー: ポート番号（文字列）
    #   - 値: プロトコル（HTTP, HTTPS, TCP, UDP）
    # 省略時: ポートは開かれません。
    # 注意: パブリックエンドポイントとして使用する場合、HTTPまたはHTTPSポートが必要です。
    ports = {
      "80" = "HTTP"
    }
  }

  #-------------------------------------------------------------
  # オプションパラメータ
  #-------------------------------------------------------------

  # public_endpoint (Optional, 最大1個)
  # 設定内容: コンテナサービスのパブリックエンドポイントの設定を記述します。
  # 設定可能な値: 1個のpublic_endpointブロック
  # 省略時: コンテナはインターネットからアクセスできません。
  # 関連機能: Public Endpoints
  #   パブリックエンドポイントはHTTPS経由でインターネットからアクセス可能になります。
  #   ランダムに生成されたデフォルトドメインまたはカスタムドメインを使用できます。
  #   - https://docs.aws.amazon.com/lightsail/latest/userguide/amazon-lightsail-container-services-public-endpoint.html
  # 注意: HTTPまたはHTTPSポートを持つコンテナのみ指定可能です。
  public_endpoint {
    # container_name (Required)
    # 設定内容: トラフィックを転送するコンテナの名前を指定します。
    # 設定可能な値: containerブロックで定義したコンテナ名
    # 注意: HTTPまたはHTTPSポートを持つコンテナである必要があります。
    container_name = "hello-world"

    # container_port (Required)
    # 設定内容: トラフィックを転送するコンテナのポート番号を指定します。
    # 設定可能な値: containerブロックのportsで定義したHTTP/HTTPSポート
    # 注意: ロードバランサーはHTTPSを受け付け、HTTPでコンテナに転送します。
    container_port = 80

    # health_check (Required)
    # 設定内容: コンテナのヘルスチェック設定を記述します。
    # 設定可能な値: 1個のhealth_checkブロック
    # 関連機能: Health Checks
    #   ロードバランサーがコンテナの正常性を定期的に確認し、正常なコンテナのみに
    #   トラフィックをルーティングします。
    #   - https://docs.aws.amazon.com/lightsail/latest/userguide/amazon-lightsail-container-services-health-checks.html
    health_check {
      # healthy_threshold (Optional)
      # 設定内容: コンテナをHealthy状態に移行するために必要な連続成功回数を指定します。
      # 設定可能な値: 数値（通常2-10）
      # 省略時: 2
      healthy_threshold = 2

      # unhealthy_threshold (Optional)
      # 設定内容: コンテナをUnhealthy状態に移行するために必要な連続失敗回数を指定します。
      # 設定可能な値: 数値（通常2-10）
      # 省略時: 2
      unhealthy_threshold = 2

      # timeout_seconds (Optional)
      # 設定内容: レスポンスがない場合にヘルスチェックを失敗とみなすまでの時間（秒）を指定します。
      # 設定可能な値: 2～60秒
      # 省略時: 2
      # 注意: interval_secondsより小さい値を設定してください。
      timeout_seconds = 2

      # interval_seconds (Optional)
      # 設定内容: 個別のコンテナへのヘルスチェック間のおおよその間隔（秒）を指定します。
      # 設定可能な値: 5～300秒
      # 省略時: 5
      # 注意: timeout_secondsより大きい値を設定してください。
      interval_seconds = 5

      # path (Optional)
      # 設定内容: ヘルスチェックを実行するコンテナ上のパスを指定します。
      # 設定可能な値: URLパス文字列
      # 省略時: "/"
      # 注意: 軽量で高速なエンドポイントを使用することを推奨します。
      path = "/"

      # success_codes (Optional)
      # 設定内容: コンテナからの成功レスポンスを判定するHTTPコードを指定します。
      # 設定可能な値: 200～499の範囲の値（例: "200", "200-299", "200,204"）
      # 省略時: "200-499"
      # 注意: 本番環境では具体的な成功コード（例: "200-299"）の使用を推奨します。
      success_codes = "200-499"
    }
  }

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 関連機能: Regional Endpoints
  #   Lightsailは限定されたリージョンで利用可能です。
  #   - https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # 注意: コンテナサービスのリージョンと一致させる必要があります。
  # region = "us-east-1"

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース作成時のタイムアウト時間を設定します。
  # 設定可能な値: timeoutsブロック
  # 省略時: デフォルトのタイムアウト値が使用されます。
  # timeouts {
  #   # create (Optional)
  #   # 設定内容: デプロイメント作成処理のタイムアウト時間を指定します。
  #   # 設定可能な値: 時間文字列（例: "30m", "1h"）
  #   # 省略時: デフォルトのタイムアウト値が使用されます。
  #   create = "30m"
  # }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - created_at: デプロイメントが作成された日時（RFC3339タイムスタンプ形式）
#
# - id: リソースID（形式: <service_name>/<version>）
#
# - state: デプロイメントの現在の状態
#          値: ACTIVATING, ACTIVE, INACTIVE, FAILED
#
# - version: デプロイメントのバージョン番号（1から始まる整数）
#---------------------------------------------------------------
