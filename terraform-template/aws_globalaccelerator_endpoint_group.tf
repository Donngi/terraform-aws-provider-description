#---------------------------------------------------------------
# AWS Global Accelerator Endpoint Group
#---------------------------------------------------------------
#
# AWS Global Acceleratorのエンドポイントグループを管理するリソース。
# エンドポイントグループは、単一のAWSリージョン内の登録されたエンドポイント
# （NLB、ALB、EC2インスタンス、Elastic IPアドレス）へのトラフィックを
# ルーティングします。
#
# AWS公式ドキュメント:
#   - Endpoint groups for standard accelerators: https://docs.aws.amazon.com/global-accelerator/latest/dg/about-endpoint-groups.html
#   - Endpoints for standard accelerators: https://docs.aws.amazon.com/global-accelerator/latest/dg/about-endpoints.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/globalaccelerator_endpoint_group
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_globalaccelerator_endpoint_group" "example" {
  #---------------------------------------------------------------
  # Required Parameters
  #---------------------------------------------------------------

  # (Required) リスナーのAmazon Resource Name (ARN)
  # このエンドポイントグループが関連付けられるGlobal Acceleratorリスナー
  # を指定します。
  listener_arn = "arn:aws:globalaccelerator::123456789012:accelerator/abcd1234-abcd-1234-abcd-1234abcd5678/listener/0123abcd"

  #---------------------------------------------------------------
  # Optional Parameters
  #---------------------------------------------------------------

  # (Optional) エンドポイントグループのAWSリージョン
  # 指定しない場合は、リソースが作成されるリージョンが使用されます。
  # エンドポイントグループとそのすべてのエンドポイントは、1つのAWSリージョン
  # 内に存在する必要があります。
  # Default: 現在のリージョン
  endpoint_group_region = "us-west-2"

  # (Optional) ヘルスチェックの間隔（秒）
  # エンドポイントの各ヘルスチェック間の時間を指定します。
  # 有効な値: 10 または 30
  # Default: 30
  health_check_interval_seconds = 30

  # (Optional) ヘルスチェックのパス
  # プロトコルがHTTP/Sの場合、ヘルスチェックターゲットの宛先となるパスを
  # 指定します。Terraformは設定に存在する場合のみドリフト検出を実行します。
  # Default: "/" (スラッシュ)
  health_check_path = "/health"

  # (Optional) ヘルスチェックのポート
  # AWS Global Acceleratorがこのエンドポイントグループの一部である
  # エンドポイントのヘルスをチェックするために使用するポートです。
  # デフォルトポートは、このエンドポイントグループが関連付けられている
  # リスナーポートです。リスナーポートがポートのリストの場合、
  # Global Acceleratorはリスト内の最初のポートを使用します。
  # Terraformは設定に存在する場合のみドリフト検出を実行します。
  # Default: リスナーポート
  health_check_port = 80

  # (Optional) ヘルスチェックのプロトコル
  # AWS Global Acceleratorがこのエンドポイントグループの一部である
  # エンドポイントのヘルスをチェックするために使用するプロトコルです。
  # 有効な値: TCP, HTTP, HTTPS
  # Default: TCP
  health_check_protocol = "TCP"

  # (Optional) しきい値カウント
  # 正常なエンドポイントの状態を異常に設定するため、または異常な
  # エンドポイントを正常に設定するために必要な連続したヘルスチェックの
  # 回数です。
  # Default: 3
  threshold_count = 3

  # (Optional) トラフィックダイヤルのパーセンテージ
  # AWSリージョンに送信するトラフィックのパーセンテージです。
  # 追加のトラフィックは、このリスナーの他のエンドポイントグループに
  # 分散されます。値は0.0〜100.0の範囲で指定します。
  # Default: 100.0
  traffic_dial_percentage = 100.0

  #---------------------------------------------------------------
  # Nested Blocks
  #---------------------------------------------------------------

  # (Optional) エンドポイント設定のリスト
  # このエンドポイントグループに含めるエンドポイントのリストを定義します。
  # エンドポイントは、Network Load Balancer、Application Load Balancer、
  # EC2インスタンス、またはElastic IPアドレスのいずれかです。
  endpoint_configuration {
    # (Optional) クロスアカウント添付ファイルのARN
    # 公開されたクロスアカウント添付ファイルのARNです。
    # 詳細については、AWSドキュメントを参照してください。
    # https://docs.aws.amazon.com/global-accelerator/latest/dg/cross-account-resources.html
    attachment_arn = null

    # (Optional) クライアントIPアドレス保持の有効化
    # Application Load BalancerエンドポイントでクライアントIPアドレス
    # 保持が有効かどうかを示します。
    # Default: false
    # 注意: クライアントIPアドレス保持が有効な場合、Global Accelerator
    # サービスは、VPC内に「GlobalAccelerator」という名前のEC2セキュリティ
    # グループを作成します。このセキュリティグループは、VPCが正常に削除
    # される前に（Terraform外で）削除する必要があります。
    # https://docs.aws.amazon.com/global-accelerator/latest/dg/preserve-client-ip-address.html
    client_ip_preservation_enabled = false

    # (Optional) エンドポイントのID
    # エンドポイントのIDです。エンドポイントがNetwork Load Balancerまたは
    # Application Load Balancerの場合、これはリソースのAmazon Resource
    # Name (ARN)です。エンドポイントがElastic IPアドレスの場合、これは
    # Elastic IPアドレス割り当てIDです。
    endpoint_id = "arn:aws:elasticloadbalancing:us-west-2:123456789012:loadbalancer/app/my-alb/50dc6c495c0c9188"

    # (Optional) エンドポイントに関連付けられた重み
    # エンドポイントに重みを追加すると、指定した比率に基づいてトラフィック
    # をルーティングするようにAWS Global Acceleratorを設定します。
    # 値は0〜255の範囲で指定します。
    # Default: 100
    weight = 100
  }

  # (Optional) ポートオーバーライド設定
  # このエンドポイントグループの一部であるエンドポイントへのトラフィックを
  # ルーティングするために使用される特定のリスナーポートをオーバーライド
  # します。制限されたポートや接続の衝突を回避するために使用できます。
  # 最大10個まで設定可能です。
  # https://docs.aws.amazon.com/global-accelerator/latest/dg/about-endpoint-groups-port-override.html
  port_override {
    # (Required) エンドポイントポート
    # リスナーポートをマッピングするエンドポイントポートです。
    # これは、Application Load BalancerやAmazon EC2インスタンスなどの
    # エンドポイント上のポートです。
    endpoint_port = 8080

    # (Required) リスナーポート
    # 特定のエンドポイントポートにマッピングするリスナーポートです。
    # これは、ユーザートラフィックがGlobal Acceleratorに到達するポート
    # です。
    listener_port = 80
  }

  #---------------------------------------------------------------
  # Timeouts
  #---------------------------------------------------------------

  # (Optional) リソース操作のタイムアウト設定
  timeouts {
    # (Optional) リソース作成時のタイムアウト
    # Default: 30m
    create = "30m"

    # (Optional) リソース更新時のタイムアウト
    # Default: 30m
    update = "30m"

    # (Optional) リソース削除時のタイムアウト
    # Default: 30m
    delete = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします（Computed属性）:
#
# - id  - エンドポイントグループのAmazon Resource Name (ARN)
# - arn - エンドポイントグループのAmazon Resource Name (ARN)
#
#---------------------------------------------------------------
