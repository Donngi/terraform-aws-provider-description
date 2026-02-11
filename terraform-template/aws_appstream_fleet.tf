#---------------------------------------------------------------
# AWS AppStream 2.0 Fleet
#---------------------------------------------------------------
#
# Amazon AppStream 2.0のフリートをプロビジョニングするリソースです。
# フリートは、ユーザーがアプリケーションをストリーミングするための
# ストリーミングインスタンスのプールを定義します。
#
# AWS公式ドキュメント:
#   - AppStream 2.0概要: https://docs.aws.amazon.com/appstream2/latest/developerguide/what-is-appstream.html
#   - フリートタイプ: https://docs.aws.amazon.com/appstream2/latest/developerguide/fleet-type.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appstream_fleet
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_appstream_fleet" "example" {
  #-------------------------------------------------------------
  # 基本設定（必須）
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: フリートの一意の名前を指定します。
  # 設定可能な値: 文字列
  name = "example-fleet"

  # instance_type (Required)
  # 設定内容: フリートインスタンスを起動する際に使用するインスタンスタイプを指定します。
  # 設定可能な値: stream.standard.small, stream.standard.medium, stream.standard.large,
  #              stream.standard.xlarge, stream.standard.2xlarge,
  #              stream.compute.large, stream.compute.xlarge, stream.compute.2xlarge,
  #              stream.compute.4xlarge, stream.compute.8xlarge,
  #              stream.memory.large, stream.memory.xlarge, stream.memory.2xlarge,
  #              stream.memory.4xlarge, stream.memory.8xlarge, stream.memory.z1d.large,
  #              stream.memory.z1d.xlarge, stream.memory.z1d.2xlarge, stream.memory.z1d.3xlarge,
  #              stream.memory.z1d.6xlarge, stream.memory.z1d.12xlarge,
  #              stream.graphics-design.large, stream.graphics-design.xlarge,
  #              stream.graphics-design.2xlarge, stream.graphics-design.4xlarge,
  #              stream.graphics-desktop.2xlarge,
  #              stream.graphics.g4dn.xlarge, stream.graphics.g4dn.2xlarge,
  #              stream.graphics.g4dn.4xlarge, stream.graphics.g4dn.8xlarge,
  #              stream.graphics.g4dn.12xlarge, stream.graphics.g4dn.16xlarge,
  #              stream.graphics-pro.4xlarge, stream.graphics-pro.8xlarge, stream.graphics-pro.16xlarge
  instance_type = "stream.standard.large"

  #-------------------------------------------------------------
  # コンピュートキャパシティ設定（必須）
  #-------------------------------------------------------------

  # compute_capacity (Required)
  # 設定内容: フリートの希望キャパシティを設定するブロックです。
  compute_capacity {
    # desired_instances (Optional)
    # 設定内容: ストリーミングインスタンスの希望数を指定します。
    # 設定可能な値: 正の整数
    # 注意: desired_sessionsと排他的。single-sessionフリートで使用。
    desired_instances = 1

    # desired_sessions (Optional)
    # 設定内容: マルチセッションフリートの希望ユーザーセッション数を指定します。
    # 設定可能な値: 正の整数
    # 注意: desired_instancesと排他的。マルチセッションフリートでのみ使用可能。
    # desired_sessions = 10
  }

  #-------------------------------------------------------------
  # 表示設定
  #-------------------------------------------------------------

  # display_name (Optional)
  # 設定内容: AppStreamフリートの人間が読みやすいフレンドリー名を指定します。
  # 設定可能な値: 文字列
  display_name = "Example Fleet"

  # description (Optional)
  # 設定内容: 表示する説明を指定します。
  # 設定可能な値: 文字列
  description = "Example AppStream fleet for demonstration"

  #-------------------------------------------------------------
  # フリートタイプ設定
  #-------------------------------------------------------------

  # fleet_type (Optional)
  # 設定内容: フリートのタイプを指定します。
  # 設定可能な値:
  #   - "ON_DEMAND": ユーザーがストリーミング中のみインスタンスが実行。
  #                  1-2分の起動待ち時間あり。停止インスタンスは低コスト料金。
  #   - "ALWAYS_ON": インスタンスは常時実行。即時アクセス可能。
  #                  ユーザーがいなくても実行中インスタンス料金が発生。
  # 関連機能: AppStream 2.0 フリートタイプ
  #   フリートタイプはインスタンスの実行タイミングと課金方法を決定します。
  #   - https://docs.aws.amazon.com/appstream2/latest/developerguide/fleet-type.html
  fleet_type = "ON_DEMAND"

  #-------------------------------------------------------------
  # イメージ設定
  #-------------------------------------------------------------

  # image_name (Optional)
  # 設定内容: フリートの作成に使用するイメージの名前を指定します。
  # 設定可能な値: 有効なAppStream 2.0イメージ名
  # 注意: image_arnと排他的（どちらか一方を指定）
  image_name = "Amazon-AppStream2-Sample-Image-03-11-2023"

  # image_arn (Optional)
  # 設定内容: 使用するパブリック、プライベート、または共有イメージのARNを指定します。
  # 設定可能な値: 有効なAppStream 2.0イメージARN
  # 注意: image_nameと排他的（どちらか一方を指定）
  # image_arn = "arn:aws:appstream:ap-northeast-1:123456789012:image/my-custom-image"

  #-------------------------------------------------------------
  # セッションタイムアウト設定
  #-------------------------------------------------------------

  # max_user_duration_in_seconds (Optional)
  # 設定内容: ストリーミングセッションがアクティブでいられる最大時間（秒）を指定します。
  # 設定可能な値: 600〜432000秒（10分〜5日）
  max_user_duration_in_seconds = 57600

  # disconnect_timeout_in_seconds (Optional)
  # 設定内容: ユーザーが切断された後、ストリーミングセッションがアクティブのままでいる時間（秒）を指定します。
  # 設定可能な値: 60〜360000秒
  # 注意: この時間内に再接続すると、同じセッションを継続できます。
  disconnect_timeout_in_seconds = 300

  # idle_disconnect_timeout_in_seconds (Optional)
  # 設定内容: ユーザーがアイドル状態でいられる時間（秒）を指定します。
  #          この時間が経過すると切断され、disconnect_timeout_in_secondsが開始されます。
  # 設定可能な値: 0（無効）、または60〜3600秒
  # 省略時: 0（アイドル切断は無効）
  idle_disconnect_timeout_in_seconds = 900

  #-------------------------------------------------------------
  # ストリームビュー設定
  #-------------------------------------------------------------

  # stream_view (Optional)
  # 設定内容: フリートからストリーミングするときにユーザーに表示されるビューを指定します。
  # 設定可能な値:
  #   - "APP": ユーザーが開いたアプリケーションのウィンドウのみ表示
  #   - "DESKTOP": OSが提供する標準デスクトップを表示
  # 省略時: "APP"
  stream_view = "APP"

  #-------------------------------------------------------------
  # マルチセッション設定
  #-------------------------------------------------------------

  # max_sessions_per_instance (Optional)
  # 設定内容: インスタンスあたりの最大ユーザーセッション数を指定します。
  # 設定可能な値: 正の整数
  # 注意: マルチセッションフリートにのみ適用されます。シングルセッションフリートでは使用不可。
  # max_sessions_per_instance = 5

  #-------------------------------------------------------------
  # ネットワーク設定
  #-------------------------------------------------------------

  # enable_default_internet_access (Optional)
  # 設定内容: フリートのデフォルトインターネットアクセスを有効または無効にします。
  # 設定可能な値:
  #   - true: デフォルトインターネットアクセスを有効化
  #   - false: デフォルトインターネットアクセスを無効化
  # 注意: VPC設定がある場合、この設定はNATゲートウェイまたはインターネットゲートウェイの
  #       設定に依存します。
  enable_default_internet_access = false

  # vpc_config (Optional)
  # 設定内容: フリートのVPC設定を指定するブロックです。
  vpc_config {
    # subnet_ids (Optional)
    # 設定内容: フリートインスタンスにネットワークインターフェースをアタッチするサブネットのIDを指定します。
    # 設定可能な値: 有効なサブネットIDのリスト
    # 注意: 高可用性のために複数のサブネットを指定することを推奨します。
    subnet_ids = ["subnet-xxxxxxxxxxxxxxxxx"]

    # security_group_ids (Optional)
    # 設定内容: フリートのセキュリティグループIDを指定します。
    # 設定可能な値: 有効なセキュリティグループIDのリスト
    security_group_ids = ["sg-xxxxxxxxxxxxxxxxx"]
  }

  #-------------------------------------------------------------
  # ドメイン参加設定
  #-------------------------------------------------------------

  # domain_join_info (Optional)
  # 設定内容: フリートをMicrosoft Active Directoryドメインに参加させるための設定ブロックです。
  # domain_join_info {
  #   # directory_name (Optional)
  #   # 設定内容: ディレクトリの完全修飾名を指定します（例: corp.example.com）。
  #   # 設定可能な値: 有効なActive Directoryドメイン名
  #   directory_name = "corp.example.com"
  #
  #   # organizational_unit_distinguished_name (Optional)
  #   # 設定内容: コンピュータアカウント用の組織単位（OU）の識別名を指定します。
  #   # 設定可能な値: 有効なOU識別名（例: "OU=AppStream,DC=corp,DC=example,DC=com"）
  #   organizational_unit_distinguished_name = "OU=AppStream,DC=corp,DC=example,DC=com"
  # }

  #-------------------------------------------------------------
  # IAM設定
  #-------------------------------------------------------------

  # iam_role_arn (Optional)
  # 設定内容: フリートに適用するIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  # 用途: ストリーミングインスタンスがAWSリソースにアクセスするための権限を付与。
  # iam_role_arn = "arn:aws:iam::123456789012:role/AppStreamFleetRole"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "ap-northeast-1"

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: AppStreamインスタンスにアタッチするタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  tags = {
    Name        = "example-fleet"
    Environment = "development"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: AppStreamフリートの一意の識別子（ID）
#
# - arn: AppStreamフリートのAmazon Resource Name (ARN)
#
# - state: フリートの状態。STARTING, RUNNING, STOPPING, STOPPEDのいずれか。
#
# - created_time: フリートが作成された日時（UTC、拡張RFC 3339形式）
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#
# compute_capacity内の読み取り専用属性:
# - available: セッションのストリーミングに使用できる現在利用可能なインスタンス数
# - in_use: ストリーミング中のインスタンス数
# - running: 実行中の同時ストリーミングインスタンスの総数
#---------------------------------------------------------------
