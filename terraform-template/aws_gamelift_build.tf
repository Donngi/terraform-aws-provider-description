#---------------------------------------------------------------
# Amazon GameLift Build
#---------------------------------------------------------------
#
# Amazon GameLiftのビルドリソースを管理します。
# ゲームサーバーバイナリをS3バケットからGameLiftにアップロードし、
# フリート作成時に使用できるビルドとして登録します。
#
# AWS公式ドキュメント:
#   - Amazon GameLift - Uploading builds:
#     https://docs.aws.amazon.com/gamelift/latest/developerguide/gamelift-build-intro.html
#   - Amazon GameLift Build API:
#     https://docs.aws.amazon.com/gamelift/latest/apireference/API_Build.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/gamelift_build
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_gamelift_build" "example" {
  #---------------------------------------------------------------
  # Required Parameters
  #---------------------------------------------------------------

  # ビルドの名前
  # - フリート作成時にどのビルドを使用するか識別するために使用
  # - 同じリージョン内で一意である必要はない
  name = "example-game-build"

  # ゲームサーバーバイナリが実行されるオペレーティングシステム
  # - WINDOWS_2012: Windows Server 2012
  # - WINDOWS_2016: Windows Server 2016
  # - AMAZON_LINUX: Amazon Linux (第1世代)
  # - AMAZON_LINUX_2: Amazon Linux 2
  # - AMAZON_LINUX_2023: Amazon Linux 2023
  # - OSの選択はゲームサーバーのビルド環境に依存
  operating_system = "AMAZON_LINUX_2023"

  # S3に格納されたビルドファイルの場所情報
  # - ゲームサーバーバイナリを含むzipファイルの情報を指定
  # - 必須ブロック（min_items: 1, max_items: 1）
  storage_location {
    # ビルドファイルが格納されているS3バケット名
    # - GameLiftがアクセス可能なバケットを指定
    bucket = "my-gamelift-builds"

    # S3バケット内のzipファイルのキー（パス）
    # - ゲームサーバーの実行可能ファイルとその依存関係を含むzipファイル
    # - ファイル構造はGameLiftの要件に従う必要がある
    key = "builds/my-game-server-v1.0.0.zip"

    # GameLiftがS3バケットにアクセスするために使用するIAMロールのARN
    # - s3:GetObject, s3:GetObjectVersion 権限が必要
    # - GameLiftサービスをtrust relationshipとして持つロールを指定
    role_arn = "arn:aws:iam::123456789012:role/GameLiftS3AccessRole"

    # (Optional) S3オブジェクトの特定バージョンを指定
    # - S3バージョニングが有効な場合に使用可能
    # - 未指定の場合は最新バージョンが取得される
    # - バージョンIDを指定することで特定のビルドバージョンを固定可能
    # object_version = "abc123def456"
  }

  #---------------------------------------------------------------
  # Optional Parameters
  #---------------------------------------------------------------

  # (Optional) このリソースが管理されるAWSリージョン
  # - 指定しない場合はプロバイダー設定のリージョンが使用される
  # - 特定のリージョンにビルドを配置する必要がある場合に指定
  # region = "us-west-2"

  # (Optional) ビルドに関連付けられるバージョン文字列
  # - セマンティックバージョニング（例: "1.0.0"）や任意の文字列を指定可能
  # - ビルドの識別やトラッキングに使用
  # - GameLiftコンソールやAPIで表示される
  # version = "1.0.0"

  # (Optional) リソースに付与するタグ
  # - コスト配分、リソース管理、アクセス制御に使用
  # - provider default_tags設定がある場合、そちらのタグとマージされる
  # tags = {
  #   Environment = "production"
  #   Game        = "my-awesome-game"
  #   ManagedBy   = "terraform"
  # }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# 以下の属性はリソース作成後に参照可能です（computed）:
#
# - id
#   GameLift Build ID（例: "build-12345678-abcd-1234-abcd-123456789012"）
#   他のリソース（aws_gamelift_fleetなど）で参照可能
#
# - arn
#   GameLift BuildのARN
#   形式: "arn:aws:gamelift:<region>:<account-id>:build/build-<id>"
#
# - tags_all
#   リソースに割り当てられたすべてのタグのマップ
#   provider default_tags設定で定義されたタグを含む
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# Usage Example - GameLift Fleet with Build
#---------------------------------------------------------------
# GameLift Buildを使用してフリートを作成する例:
#
# resource "aws_gamelift_fleet" "example" {
#   name              = "example-fleet"
#   build_id          = aws_gamelift_build.example.id
#   fleet_type        = "ON_DEMAND"
#   ec2_instance_type = "c5.large"
#
#   runtime_configuration {
#     server_process {
#       concurrent_executions = 1
#       launch_path           = "/local/game/GameLiftExampleServer.exe"
#     }
#   }
# }
#
#---------------------------------------------------------------
