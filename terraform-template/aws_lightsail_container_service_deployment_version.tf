#---------------------------------------------------------------
# AWS Lightsail Container Service Deployment Version
#---------------------------------------------------------------
#
# AWS LightsailコンテナサービスのデプロイメントバージョンをTerraformで管理します。
# デプロイメントバージョンはコンテナの設定（イメージ、環境変数、ポート等）と
# パブリックエンドポイントを定義します。各デプロイメントはバージョン番号が付与され、
# 状態（ACTIVATING, ACTIVE, INACTIVE, FAILED）が管理されます。
#
# AWS公式ドキュメント:
#   - デプロイメント概要: https://docs.aws.amazon.com/lightsail/latest/userguide/amazon-lightsail-container-services.html
#   - コンテナイメージ: https://lightsail.aws.amazon.com/ls/docs/en_us/articles/amazon-lightsail-creating-container-images
#   - パブリックエンドポイント: https://lightsail.aws.amazon.com/ls/docs/en_us/articles/amazon-lightsail-container-service-deployments
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lightsail_container_service_deployment_version
#
# Provider Version: 6.28.0
# Generated: 2025-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lightsail_container_service_deployment_version" "example" {
  #-------------------------------------------------------------
  # サービス設定
  #-------------------------------------------------------------

  # service_name (Required)
  # 設定内容: デプロイメントを作成する対象のLightsailコンテナサービス名を指定します。
  # 設定可能な値: 既存のLightsailコンテナサービスの名前
  # 注意: 対象サービスが存在し、有効な状態である必要があります。
  service_name = "container-service-1"

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # container ブロック (Required, 1〜53個, setのため順序なし)
  #-------------------------------------------------------------
  # デプロイメントで実行するコンテナの設定を定義します。
  # 最低1つ、最大53個まで指定可能です。
  # 注意: 各コンテナ名（container_name）はデプロイメント内で一意である必要があります。

  container {
    # container_name (Required)
    # 設定内容: コンテナの名前を指定します。デプロイメント内でユニークな識別子として使用されます。
    # 設定可能な値: 英数字とハイフンで構成された文字列
    # 注意: public_endpoint.container_name から参照する場合、この名前を使用します。
    container_name = "hello-world"

    # image (Required)
    # 設定内容: コンテナで使用するイメージ名を指定します。
    # 設定可能な値:
    #   - パブリックイメージ: "docker.io/library/nginx:latest"
    #   - Lightsailコンテナイメージ: ":container-service-1.my-image.1"（:サービス名.イメージ名.バージョン形式）
    #   - ECRプライベートイメージ: "123456789012.dkr.ecr.us-east-1.amazonaws.com/my-repo:latest"
    # 注意: ECRプライベートイメージを使用する場合は、コンテナサービスのECRアクセス設定が必要です。
    image = "docker.io/library/hello-world:latest"

    # command (Optional)
    # 設定内容: コンテナ起動時に実行するコマンドをリスト形式で指定します。
    # 設定可能な値: 文字列のリスト（例: ["/bin/sh", "-c", "echo hello"]）
    # 省略時: Dockerfileで定義されたCMDが使用されます。
    command = []

    # environment (Optional)
    # 設定内容: コンテナに渡す環境変数をマップ形式で指定します。
    # 設定可能な値: キーと値のペアのマップ（どちらも文字列）
    # 省略時: 環境変数なし
    # 注意: シークレット情報はAWS Secrets ManagerやAWS Systems Manager Parameter Storeの
    #       参照を利用することを推奨します（Lightsailでは直接統合されていません）。
    environment = {
      MY_ENV_VAR = "my_value"
    }

    # ports (Optional)
    # 設定内容: コンテナが公開するポートとプロトコルのマッピングを指定します。
    # 設定可能な値: ポート番号（文字列）をキー、プロトコルを値とするマップ
    #   プロトコルの値:
    #   - "HTTP": HTTPトラフィック
    #   - "HTTPS": HTTPSトラフィック
    #   - "TCP": TCPトラフィック
    #   - "UDP": UDPトラフィック
    # 省略時: ポート公開なし
    # 注意: public_endpointで使用するポートはここで定義する必要があります。
    ports = {
      "80" = "HTTP"
    }
  }

  # 追加コンテナの例（サイドカーコンテナ等）
  # container {
  #   container_name = "sidecar"
  #   image          = "docker.io/library/fluentd:latest"
  #   command        = []
  #   environment    = {}
  #   ports          = {}
  # }

  #-------------------------------------------------------------
  # public_endpoint ブロック (Optional, 最大1個)
  #-------------------------------------------------------------
  # パブリックエンドポイントの設定を定義します。
  # コンテナサービスのURLを通じて外部からアクセスする際のコンテナとポートを指定します。
  # 省略した場合、コンテナサービスへのパブリックアクセスは無効になります。

  public_endpoint {
    # container_name (Required)
    # 設定内容: パブリックエンドポイントとして公開するコンテナの名前を指定します。
    # 設定可能な値: 同じデプロイメント内で定義されたcontainer_nameのいずれか
    # 注意: 指定したコンテナはportsマップで対応するポートを公開している必要があります。
    container_name = "hello-world"

    # container_port (Required)
    # 設定内容: パブリックエンドポイントとして公開するコンテナのポート番号を指定します。
    # 設定可能な値: 1〜65535の整数
    # 注意: 指定したポートはコンテナのportsマップに定義されている必要があります。
    container_port = 80

    #-----------------------------------------------------------
    # health_check ブロック (Required, 1個のみ)
    #-----------------------------------------------------------
    # パブリックエンドポイントのヘルスチェック設定を定義します。
    # ロードバランサーがコンテナの健全性を確認するために使用します。

    health_check {
      # healthy_threshold (Optional)
      # 設定内容: コンテナを正常と判定するために必要な連続成功回数を指定します。
      # 設定可能な値: 2〜10の整数
      # 省略時: 2
      healthy_threshold = 2

      # interval_seconds (Optional)
      # 設定内容: 各ヘルスチェックの実行間隔（秒）を指定します。
      # 設定可能な値: 5〜300の整数
      # 省略時: 5
      interval_seconds = 5

      # path (Optional)
      # 設定内容: ヘルスチェックリクエストのパスを指定します。
      # 設定可能な値: スラッシュで始まるURLパス文字列（例: "/health", "/status"）
      # 省略時: "/"
      path = "/"

      # success_codes (Optional)
      # 設定内容: 正常とみなすHTTPレスポンスコードの範囲または値を指定します。
      # 設定可能な値: "200-299" や "200,301" のような文字列
      # 省略時: "200-499"
      success_codes = "200-499"

      # timeout_seconds (Optional)
      # 設定内容: ヘルスチェックのタイムアウト時間（秒）を指定します。
      # 設定可能な値: 2〜60の整数（interval_seconds より小さい値にすること）
      # 省略時: 2
      timeout_seconds = 2

      # unhealthy_threshold (Optional)
      # 設定内容: コンテナを異常と判定するために必要な連続失敗回数を指定します。
      # 設定可能な値: 2〜10の整数
      # 省略時: 2
      unhealthy_threshold = 2
    }
  }

  #-------------------------------------------------------------
  # timeouts ブロック (Optional)
  #-------------------------------------------------------------
  # リソース操作のタイムアウト設定を定義します。

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "30m", "1h"）
    # 省略時: プロバイダーデフォルトのタイムアウトが適用されます。
    create = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - created_at: デプロイメントバージョンが作成された日時（ISO 8601形式）
#
# - id: "service_name/version" 形式の文字列
#
# - state: デプロイメントの現在の状態
#   値: ACTIVATING（起動中）, ACTIVE（稼働中）, INACTIVE（非アクティブ）, FAILED（失敗）
#
# - version: デプロイメントのバージョン番号（数値）
#   注意: デプロイのたびに自動でインクリメントされます。
#
#---------------------------------------------------------------
