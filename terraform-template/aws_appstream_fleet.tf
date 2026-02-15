#---------------------------------------
# AppStream Fleet
#---------------------------------------
# AppStreamフリートを定義するリソース
# ストリーミングセッションを実行するためのインスタンスのコレクションを管理
#
# 主な用途:
# - アプリケーションストリーミング環境の構築
# - デスクトップストリーミングの提供
# - セッション管理とキャパシティ制御
#
# Provider Version: 6.28.0
# Generated: 2026-02-11
#
# NOTE: このテンプレートはAWS Provider 6.28.0のスキーマから生成されています
#       実際の使用前に最新のプロバイダードキュメントを確認してください
#
# 公式ドキュメント: https://docs.aws.amazon.com/appstream2/latest/developerguide/managing-stacks-fleets.html
# Terraform ドキュメント: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appstream_fleet
#---------------------------------------

#---------------------------------------
# 基本設定
#---------------------------------------
resource "aws_appstream_fleet" "example" {
  # 設定内容: フリートの一意な名前
  # 省略時: 指定必須
  name = "example-fleet"

  # 設定内容: フリートインスタンス起動時に使用するインスタンスタイプ
  # 設定可能な値: stream.standard.small / stream.standard.medium / stream.standard.large など
  # 省略時: 指定必須
  instance_type = "stream.standard.large"

  # 設定内容: フリートの表示名（ユーザーに表示される）
  # 省略時: nameと同じ値が使用される
  display_name = "Example Fleet"

  # 設定内容: フリートの説明
  # 省略時: 説明なし
  description = "Example AppStream fleet"

  # 設定内容: このリソースが管理されるリージョン
  # 省略時: プロバイダー設定のリージョンが使用される
  region = "us-west-2"

  #---------------------------------------
  # キャパシティ設定
  #---------------------------------------
  compute_capacity {
    # 設定内容: 希望するストリーミングインスタンス数（シングルセッションフリート用）
    # 省略時: 設定なし（マルチセッションフリートの場合はdesired_sessionsを使用）
    desired_instances = 1

    # 設定内容: 希望するユーザーセッション数（マルチセッションフリート用）
    # 省略時: 設定なし（シングルセッションフリートの場合は使用不可）
    desired_sessions = 10
  }

  #---------------------------------------
  # イメージ設定
  #---------------------------------------
  # 設定内容: フリート作成に使用するイメージの名前
  # 省略時: image_arnが使用される
  image_name = "Amazon-AppStream2-Sample-Image-03-11-2023"

  # 設定内容: 使用するパブリック/プライベート/共有イメージのARN
  # 省略時: image_nameが使用される
  image_arn = "arn:aws:appstream:us-west-2:123456789012:image/example-image"

  #---------------------------------------
  # フリートタイプと動作設定
  #---------------------------------------
  # 設定内容: フリートのタイプ
  # 設定可能な値: ON_DEMAND（オンデマンド） / ALWAYS_ON（常時起動）
  # 省略時: ON_DEMAND
  fleet_type = "ON_DEMAND"

  # 設定内容: インスタンスごとの最大ユーザーセッション数（マルチセッションフリートのみ）
  # 省略時: 設定なし
  max_sessions_per_instance = 5

  # 設定内容: ユーザーに表示されるストリーミングビュー
  # 設定可能な値: APP（アプリケーションウィンドウのみ） / DESKTOP（デスクトップ全体）
  # 省略時: APP
  stream_view = "APP"

  #---------------------------------------
  # セッションタイムアウト設定
  #---------------------------------------
  # 設定内容: ユーザーが非アクティブ状態になってから切断されるまでの時間（秒）
  # 設定可能な値: 60〜3600秒
  # 省略時: 0（無効）
  idle_disconnect_timeout_in_seconds = 600

  # 設定内容: ユーザーが切断された後にストリーミングセッションがアクティブ状態を維持する時間（秒）
  # 省略時: デフォルト値が使用される
  disconnect_timeout_in_seconds = 300

  # 設定内容: ストリーミングセッションがアクティブ状態を維持できる最大時間（秒）
  # 省略時: デフォルト値が使用される
  max_user_duration_in_seconds = 57600

  #---------------------------------------
  # ネットワーク設定
  #---------------------------------------
  # 設定内容: フリートのデフォルトインターネットアクセスの有効化
  # 設定可能な値: true（有効） / false（無効）
  # 省略時: false
  enable_default_internet_access = false

  vpc_config {
    # 設定内容: フリートインスタンスにアタッチするサブネットの識別子リスト
    # 省略時: 設定なし
    subnet_ids = ["subnet-12345678"]

    # 設定内容: フリートインスタンスに適用するセキュリティグループの識別子リスト
    # 省略時: デフォルトセキュリティグループが使用される
    security_group_ids = ["sg-12345678"]
  }

  #---------------------------------------
  # Active Directory設定
  #---------------------------------------
  domain_join_info {
    # 設定内容: コンピュータアカウント用のディレクトリの完全修飾名
    # 省略時: ドメイン参加なし
    directory_name = "corp.example.com"

    # 設定内容: コンピュータアカウント用の組織単位(OU)の識別名
    # 省略時: デフォルトOU
    organizational_unit_distinguished_name = "OU=AppStream,DC=corp,DC=example,DC=com"
  }

  #---------------------------------------
  # IAM設定
  #---------------------------------------
  # 設定内容: フリートに適用するIAMロールのARN
  # 省略時: デフォルトのサービスロールが使用される
  iam_role_arn = "arn:aws:iam::123456789012:role/AmazonAppStreamServiceAccess"

  #---------------------------------------
  # タグ設定
  #---------------------------------------
  # 設定内容: リソースに付与するタグのマップ
  # 省略時: タグなし
  tags = {
    Environment = "production"
    Name        = "example-fleet"
  }
}

#---------------------------------------
# Attributes Reference
#---------------------------------------
# この定義により以下の属性が参照可能:
# - id: フリートの一意な識別子
# - arn: フリートのARN
# - state: フリートの状態（STARTING/RUNNING/STOPPING/STOPPED）
# - created_time: フリート作成日時（UTC、RFC 3339拡張形式）
# - compute_capacity.available: ストリーミング可能な現在利用可能なインスタンス数
# - compute_capacity.in_use: ストリーミング中のインスタンス数
# - compute_capacity.running: 実行中の同時ストリーミングインスタンスの総数
# - tags_all: プロバイダーのdefault_tagsとリソースのtagsを統合したタグマップ
