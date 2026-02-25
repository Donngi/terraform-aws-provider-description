#---------------------------------------------------------------
# Amazon GameLift フリート
#---------------------------------------------------------------
#
# Amazon GameLiftのフリートをプロビジョニングするリソースです。
# フリートはゲームサーバービルドまたはRealtime Scriptを実行するEC2インスタンスの
# 集合体であり、プレイヤー接続を受け付けてゲームセッションをホストします。
# フリートにはインバウンド通信ルール、ランタイム設定、リソース作成制限ポリシーなどを
# 構成することができます。
#
# AWS公式ドキュメント:
#   - Amazon GameLift フリート: https://docs.aws.amazon.com/gamelift/latest/developerguide/fleets-intro.html
#   - フリートの作成: https://docs.aws.amazon.com/gamelift/latest/developerguide/fleets-creating.html
#   - ランタイム設定: https://docs.aws.amazon.com/gamelift/latest/developerguide/fleets-multiprocess.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/gamelift_fleet
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_gamelift_fleet" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: フリートのわかりやすい名前を指定します。
  # 設定可能な値: 最大1024文字の文字列
  name = "example-fleet"

  # description (Optional)
  # 設定内容: フリートの説明文を指定します。
  # 設定可能な値: 最大1024文字の文字列
  description = "Example GameLift fleet"

  #-------------------------------------------------------------
  # コンピューティング設定
  #-------------------------------------------------------------

  # ec2_instance_type (Required)
  # 設定内容: フリートで使用するEC2インスタンスタイプを指定します。
  # 設定可能な値: GameLiftがサポートするEC2インスタンスタイプ
  #   例: "c5.large", "c5.xlarge", "m5.large", "r5.large" など
  # 参考: https://docs.aws.amazon.com/gamelift/latest/developerguide/gamelift-ec2-instances.html
  ec2_instance_type = "c5.large"

  # fleet_type (Optional)
  # 設定内容: フリートで使用するコンピューティングリソースの種類を指定します。
  # 設定可能な値:
  #   - "ON_DEMAND": オンデマンドインスタンスを使用（デフォルト）
  #   - "SPOT": スポットインスタンスを使用（コスト削減可能だが中断リスクあり）
  # 省略時: "ON_DEMAND"
  fleet_type = "ON_DEMAND"

  # instance_role_arn (Optional)
  # 設定内容: フリートのEC2インスタンスに割り当てるIAMロールのARNを指定します。
  # 設定可能な値: IAMロールのARN
  # 注意: このロールを使用することで、インスタンスが他のAWSサービスにアクセスできます
  instance_role_arn = null

  #-------------------------------------------------------------
  # ゲームビルドまたはスクリプト設定
  #-------------------------------------------------------------

  # build_id (Optional)
  # 設定内容: フリートで実行するGameLiftビルドのIDを指定します。
  # 設定可能な値: aws_gamelift_build リソースのID
  # 注意: build_id または script_id のいずれか一方を指定する必要があります
  build_id = null

  # script_id (Optional)
  # 設定内容: フリートで実行するGameLift Realtime ScriptのIDを指定します。
  # 設定可能な値: aws_gamelift_script リソースのID
  # 注意: build_id または script_id のいずれか一方を指定する必要があります
  script_id = null

  #-------------------------------------------------------------
  # ゲームセッション設定
  #-------------------------------------------------------------

  # new_game_session_protection_policy (Optional)
  # 設定内容: フリート内のゲームセッションの保護ポリシーを指定します。
  # 設定可能な値:
  #   - "NoProtection": 保護なし（スケールダウン時に終了される可能性あり）
  #   - "FullProtection": アクティブなゲームセッションを持つインスタンスを保護
  # 省略時: "NoProtection"
  new_game_session_protection_policy = "NoProtection"

  # metric_groups (Optional)
  # 設定内容: フリートをグループ化するメトリクスグループ名のリストを指定します。
  # 設定可能な値: メトリクスグループ名の文字列リスト（最大1つ）
  # 注意: GameLiftはメトリクスグループを使用してCloudWatchダッシュボードにデータを集約します
  metric_groups = ["example-group"]

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "example-fleet"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # SSL証明書設定
  #-------------------------------------------------------------

  # certificate_configuration (Optional)
  # 設定内容: フリートのSSL証明書の生成設定を指定するブロックです。
  # 注意: 証明書を有効化することで、ゲームクライアントがサーバーを認証できます
  certificate_configuration {
    # certificate_type (Optional)
    # 設定内容: SSL証明書の生成タイプを指定します。
    # 設定可能な値:
    #   - "DISABLED": SSL証明書を生成しない（デフォルト）
    #   - "GENERATED": GameLiftが管理するSSL証明書を自動生成
    # 省略時: "DISABLED"
    certificate_type = "DISABLED"
  }

  #-------------------------------------------------------------
  # インバウンドアクセス設定
  #-------------------------------------------------------------

  # ec2_inbound_permission (Optional)
  # 設定内容: フリートインスタンスへのインバウンド通信を許可するルールを指定するブロックです。
  # 注意: 最大50件まで指定できます。ゲームクライアントがサーバーに接続するための
  #       ポートと通信プロトコルを許可する必要があります
  ec2_inbound_permission {
    # from_port (Required)
    # 設定内容: 許可するポート範囲の開始ポート番号を指定します。
    # 設定可能な値: 1〜60000の整数
    from_port = 1935

    # to_port (Required)
    # 設定内容: 許可するポート範囲の終了ポート番号を指定します。
    # 設定可能な値: from_port以上60000以下の整数
    to_port = 1935

    # ip_range (Required)
    # 設定内容: アクセスを許可するIPアドレスの範囲をCIDR表記で指定します。
    # 設定可能な値: CIDR形式のIPアドレス範囲（例: "0.0.0.0/0", "10.0.0.0/8"）
    ip_range = "0.0.0.0/0"

    # protocol (Required)
    # 設定内容: 許可する通信プロトコルを指定します。
    # 設定可能な値:
    #   - "TCP": TCPプロトコル
    #   - "UDP": UDPプロトコル
    protocol = "TCP"
  }

  #-------------------------------------------------------------
  # リソース作成制限ポリシー
  #-------------------------------------------------------------

  # resource_creation_limit_policy (Optional)
  # 設定内容: フリートで1人のプレイヤーが作成できるゲームセッション数の制限を
  #          指定するブロックです。
  # 注意: プレイヤーIDでゲームセッション作成をリクエストする場合に適用されます
  resource_creation_limit_policy {
    # new_game_sessions_per_creator (Optional)
    # 設定内容: 指定した時間内に1プレイヤーが作成できるゲームセッションの最大数を指定します。
    # 設定可能な値: 0以上の整数
    new_game_sessions_per_creator = 3

    # policy_period_in_minutes (Optional)
    # 設定内容: ゲームセッション作成制限を適用する時間（分）を指定します。
    # 設定可能な値: 1以上の整数
    policy_period_in_minutes = 15
  }

  #-------------------------------------------------------------
  # ランタイム設定
  #-------------------------------------------------------------

  # runtime_configuration (Optional)
  # 設定内容: フリートでゲームサーバープロセスを起動する方法を指定するブロックです。
  # 注意: マルチプロセス機能を使用する場合は、server_processブロックを複数指定します
  # 参考: https://docs.aws.amazon.com/gamelift/latest/developerguide/fleets-multiprocess.html
  runtime_configuration {
    # game_session_activation_timeout_seconds (Optional)
    # 設定内容: ゲームセッションがACTIVATINGステータスにとどまる最大時間（秒）を指定します。
    # 設定可能な値: 1〜600の整数
    # 省略時: 300秒
    game_session_activation_timeout_seconds = 300

    # max_concurrent_game_session_activations (Optional)
    # 設定内容: 同時にACTIVATINGステータスにできるゲームセッションの最大数を指定します。
    # 設定可能な値: 1〜2147483647の整数
    # 省略時: 制限なし
    max_concurrent_game_session_activations = 1

    # server_process (Optional)
    # 設定内容: 各サーバープロセスの起動設定を指定するブロックです。
    # 注意: 最大50件まで指定できます
    server_process {
      # concurrent_executions (Required)
      # 設定内容: 各EC2インスタンスで同時に起動するこのプロセスの数を指定します。
      # 設定可能な値: 1以上の整数
      concurrent_executions = 1

      # launch_path (Required)
      # 設定内容: ゲームサーバー実行ファイルのパスを指定します。
      # 設定可能な値: サーバー実行ファイルへの絶対パス
      #   - Windowsフリート: C:\game\MyGame.exe 形式
      #   - Linuxフリート: /local/game/MyGame 形式
      launch_path = "/local/game/MyGame"

      # parameters (Optional)
      # 設定内容: サーバープロセス起動時に渡すパラメーターを指定します。
      # 設定可能な値: コマンドラインパラメーターの文字列（最大1024文字）
      parameters = "+sv_port 7777 +start_lobby"
    }
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: "30m", "1h" などのGoの時間文字列
    # 省略時: 70m
    create = "70m"

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: "30m", "1h" などのGoの時間文字列
    # 省略時: 20m
    delete = "20m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: フリートのID
#
# - arn: フリートを識別するARN
#
# - build_arn: フリートに関連付けられたビルドのARN
#
# - script_arn: フリートに関連付けられたRealtime ScriptのARN
#
# - log_paths: ゲームセッションログのアップロード先パスのリスト
#
# - operating_system: フリートのEC2インスタンスで実行するオペレーティングシステム
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
