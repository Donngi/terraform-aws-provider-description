#---------------------------------------------------------------
# Amazon GameLift Fleet
#---------------------------------------------------------------
#
# Amazon GameLift managed EC2フリートを作成し、マルチプレイヤーゲームサーバーのホスティング環境を構築します。
# フリートはAmazon EC2インスタンスの集合で、ゲームビルドまたはスクリプトをデプロイし、
# ゲームセッションのホスティング、オートスケーリング、ヘルスチェックなどを自動管理します。
#
# AWS公式ドキュメント:
#   - Create an Amazon GameLift Servers managed EC2 fleet: https://docs.aws.amazon.com/gameliftservers/latest/developerguide/fleets-creating.html
#   - Amazon GameLift Servers managed EC2 fleets: https://docs.aws.amazon.com/gameliftservers/latest/developerguide/fleets-intro-managed.html
#   - RuntimeConfiguration API: https://docs.aws.amazon.com/gameliftservers/latest/apireference/API_RuntimeConfiguration.html
#   - CertificateConfiguration API: https://docs.aws.amazon.com/gameliftservers/latest/apireference/API_CertificateConfiguration.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/gamelift_fleet
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_gamelift_fleet" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # フリートの名前
  # 説明: フリートを識別するための一意の名前を指定します。
  #       管理コンソールやCLIでの識別に使用されます。
  name = "example-fleet-name"

  # EC2インスタンスタイプ
  # 説明: フリートで使用するEC2インスタンスのタイプを指定します。
  #       ゲームサーバーの要件（CPU、メモリ、ネットワーク容量）に基づいて選択します。
  # 例: "t2.micro", "c5.large", "r5.xlarge"
  # 参考: https://docs.aws.amazon.com/gameliftservers/latest/developerguide/gamelift-compute.html
  ec2_instance_type = "t2.micro"

  #---------------------------------------------------------------
  # ビルド/スクリプト設定（いずれか必須）
  #---------------------------------------------------------------

  # ゲームビルドID
  # 説明: フリートにデプロイするGameLiftビルドのIDを指定します。
  #       script_idとは排他的で、どちらか一方のみ指定可能です。
  # 参考: aws_gamelift_build リソースで作成したビルドのIDを使用します。
  build_id = aws_gamelift_build.example.id

  # スクリプトID（build_idとは排他的）
  # 説明: フリートにデプロイするGameLiftスクリプトのIDを指定します。
  #       Realtime Serversを使用する場合に指定します。
  #       build_idとは排他的で、どちらか一方のみ指定可能です。
  # script_id = aws_gamelift_script.example.id

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # フリートの説明
  # 説明: フリートの目的や用途を説明する人間が読める形式の説明文です。
  description = "Example fleet for multiplayer game hosting"

  # フリートタイプ
  # 説明: フリートのインスタンスタイプを指定します。
  # 有効な値:
  #   - "ON_DEMAND": オンデマンドインスタンスを使用（デフォルト、安定した可用性）
  #   - "SPOT": スポットインスタンスを使用（コスト削減、中断のリスクあり）
  # デフォルト: "ON_DEMAND"
  fleet_type = "ON_DEMAND"

  # インスタンスロールARN
  # 説明: フリート内のインスタンスが引き受けることができるIAMロールのARNです。
  #       ゲームサーバーから他のAWSサービス（S3、DynamoDBなど）にアクセスする場合に使用します。
  instance_role_arn = aws_iam_role.fleet_role.arn

  # メトリクスグループ
  # 説明: このフリートを追加するメトリクスグループ名のリストです。
  #       メトリクスグループは、グループ内の全フリートのメトリクスを集約して追跡します。
  # デフォルト: ["default"]
  metric_groups = ["production-fleets", "us-east-1-fleets"]

  # ゲームセッション保護ポリシー
  # 説明: フリート内の全インスタンスに適用するゲームセッション保護ポリシーです。
  # 有効な値:
  #   - "NoProtection": スケールダウン時にセッションを終了可能（デフォルト）
  #   - "FullProtection": ACTIVE状態のセッションは終了不可
  # デフォルト: "NoProtection"
  # 参考: https://docs.aws.amazon.com/gameliftservers/latest/apireference/API_GameSessionDetail.html
  new_game_session_protection_policy = "FullProtection"

  # リージョン
  # 説明: このリソースが管理されるAWSリージョンを指定します。
  #       指定しない場合、プロバイダー設定のリージョンが使用されます。
  # region = "us-west-2"

  # タグ
  # 説明: リソースに付与するキー・バリュー形式のタグマップです。
  #       プロバイダーのdefault_tagsと統合されます。
  tags = {
    Environment = "production"
    Game        = "example-game"
    ManagedBy   = "terraform"
  }

  # tags_allは通常指定不要（computed属性として自動管理）
  # tags_all = {}

  #---------------------------------------------------------------
  # 証明書設定（オプション）
  #---------------------------------------------------------------

  # TLS/SSL証明書の生成設定
  # 説明: フリートのTLS/SSL証明書を生成するかどうかを指定します。
  #       フリート作成時に設定する必要があり、後から変更できません。
  #       全インスタンスが同じ証明書を共有します。
  # 参考: https://docs.aws.amazon.com/gameliftservers/latest/apireference/API_CertificateConfiguration.html
  certificate_configuration {
    # 証明書タイプ
    # 有効な値:
    #   - "DISABLED": 証明書を生成しない（デフォルト）
    #   - "GENERATED": フリート用の証明書を生成
    certificate_type = "GENERATED"
  }

  #---------------------------------------------------------------
  # EC2インバウンド許可設定（オプション、複数指定可能）
  #---------------------------------------------------------------

  # インバウンドトラフィック許可設定
  # 説明: フリート上で実行されているサーバープロセスへのインバウンドトラフィックを
  #       許可するIPアドレス範囲とポート設定を定義します。
  # 最大数: 50
  ec2_inbound_permission {
    # 開始ポート番号
    # 説明: 許可するポート範囲の開始値を指定します。
    from_port = 7777

    # 終了ポート番号
    # 説明: 許可するポート範囲の終了値を指定します。
    #       from_portより大きい値である必要があります（ポート番号は範囲の終端を含む）。
    to_port = 7777

    # IPアドレス範囲
    # 説明: CIDR表記で許可するIPアドレス範囲を指定します。
    # 例: "0.0.0.0/0" (全IPアドレスを許可), "192.168.1.0/24" (特定のサブネット)
    ip_range = "0.0.0.0/0"

    # プロトコル
    # 説明: フリートで使用するネットワーク通信プロトコルを指定します。
    # 有効な値: "TCP", "UDP"
    protocol = "UDP"
  }

  # 追加のポート設定例（必要に応じて複数定義可能）
  ec2_inbound_permission {
    from_port = 8080
    to_port   = 8080
    ip_range  = "0.0.0.0/0"
    protocol  = "TCP"
  }

  #---------------------------------------------------------------
  # リソース作成制限ポリシー（オプション）
  #---------------------------------------------------------------

  # リソース作成制限ポリシー
  # 説明: 個々のプレイヤーが一定期間内に作成できるゲームセッション数を制限するポリシーです。
  resource_creation_limit_policy {
    # 作成者あたりの新規ゲームセッション数
    # 説明: ポリシー期間中に個々のプレイヤーが作成できる最大ゲームセッション数です。
    new_game_sessions_per_creator = 10

    # ポリシー期間（分）
    # 説明: リソース作成制限ポリシーを評価する際の時間範囲（分単位）です。
    policy_period_in_minutes = 15
  }

  #---------------------------------------------------------------
  # ランタイム設定（オプション）
  #---------------------------------------------------------------

  # ランタイム設定
  # 説明: フリート内の各インスタンスで起動するサーバープロセスの設定を定義します。
  #       Amazon GameLiftはこれらのプロセスのライフサイクルを管理し、定期的に更新をチェックします。
  # 参考: https://docs.aws.amazon.com/gameliftservers/latest/apireference/API_RuntimeConfiguration.html
  runtime_configuration {
    # ゲームセッションアクティベーションタイムアウト（秒）
    # 説明: 新しいゲームセッションが起動し、プレイヤーのホストを開始できる状態になるまでの
    #       最大待機時間（秒単位）です。タイムアウトするとゲームセッションは終了されます。
    game_session_activation_timeout_seconds = 300

    # 最大同時アクティベーション数
    # 説明: インスタンスまたはコンピュート上で同時にACTIVATING状態になれる
    #       ゲームセッションの最大数です。
    max_concurrent_game_session_activations = 1

    # サーバープロセス設定（複数指定可能）
    # 説明: フリートコンピュート上で実行するサーバープロセスを識別する設定のコレクションです。
    #       カスタムゲームビルドの実行可能ファイルまたはRealtimeスクリプトを起動できます。
    # 最大数: 50
    # 参考: https://docs.aws.amazon.com/gameliftservers/latest/apireference/API_ServerProcess.html
    server_process {
      # 同時実行数
      # 説明: この設定を使用するサーバープロセスが、各インスタンスまたはコンピュート上で
      #       同時に実行される数です。
      # 最小値: 1
      concurrent_executions = 1

      # 起動パス
      # 説明: ゲームビルドの実行可能ファイルまたはRealtimeスクリプトの場所です。
      #       カスタムゲームビルドの場合、Server SDK操作のinitSDK()とProcessReady()を
      #       呼び出す実行可能ファイルを指定する必要があります。
      # Windowsの場合: C:\game\ 配下
      # Linuxの場合: /local/game/ 配下
      # 例: "C:\\game\\MyGameServer.exe" (Windows)
      #     "/local/game/MyGameServer.x86_64" (Linux)
      launch_path = "C:\\game\\GomokuServer.exe"

      # パラメータ（オプション）
      # 説明: 起動時にサーバー実行可能ファイルまたはRealtimeスクリプトに渡すパラメータのリストです。
      parameters = "-port 7777 -logLevel INFO"
    }

    # 追加のサーバープロセス設定例（必要に応じて複数定義可能）
    # server_process {
    #   concurrent_executions = 2
    #   launch_path           = "C:\\game\\MatchmakingService.exe"
    #   parameters            = "-matchmaker"
    # }
  }

  #---------------------------------------------------------------
  # タイムアウト設定（オプション）
  #---------------------------------------------------------------

  # リソース操作のタイムアウト
  timeouts {
    # 作成時のタイムアウト
    # 説明: フリート作成操作のタイムアウト時間を指定します。
    # デフォルト: 60分
    create = "70m"

    # 削除時のタイムアウト
    # 説明: フリート削除操作のタイムアウト時間を指定します。
    # デフォルト: 20分
    delete = "20m"
  }
}

#---------------------------------------------------------------
# Attributes Reference（参照専用属性）
#---------------------------------------------------------------
# 以下の属性はリソース作成後に参照可能ですが、入力として指定することはできません。
#
# - id: フリートID
# - arn: フリートのARN
# - build_arn: ビルドのARN
# - script_arn: スクリプトのARN
# - operating_system: フリートのコンピューティングリソースのオペレーティングシステム
# - log_paths: フリートインスタンス内に保存されているゲームサーバーログファイルのパス（非推奨）
# - tags_all: リソースに割り当てられたタグのマップ（プロバイダーのdefault_tagsを含む）
#
# 使用例:
# output "fleet_id" {
#   value = aws_gamelift_fleet.example.id
# }
# output "fleet_arn" {
#   value = aws_gamelift_fleet.example.arn
# }
#---------------------------------------------------------------
