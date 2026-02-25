#---------------------------------------------------------------
# AWS GameLift Build
#---------------------------------------------------------------
#
# Amazon GameLift のゲームサーバービルドをプロビジョニングするリソースです。
# ゲームサーバーのバイナリファイルをS3バケットから取り込み、GameLift上で
# 使用可能なビルドリソースを作成します。
#
# AWS公式ドキュメント:
#   - Amazon GameLift ビルドの作成: https://docs.aws.amazon.com/gamelift/latest/developerguide/gamelift-build-cli-uploading.html
#   - Amazon GameLift 概要: https://docs.aws.amazon.com/gamelift/latest/developerguide/gamelift-intro.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/gamelift_build
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_gamelift_build" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: ビルドの名前を指定します。
  # 設定可能な値: 任意の文字列
  name = "example-build"

  # operating_system (Required)
  # 設定内容: ゲームサーバーバイナリが動作するオペレーティングシステムを指定します。
  # 設定可能な値:
  #   - "WINDOWS_2012": Windows Server 2012
  #   - "AMAZON_LINUX": Amazon Linux
  #   - "AMAZON_LINUX_2": Amazon Linux 2
  #   - "WINDOWS_2016": Windows Server 2016
  #   - "AMAZON_LINUX_2023": Amazon Linux 2023
  operating_system = "AMAZON_LINUX_2023"

  # version (Optional)
  # 設定内容: このビルドに関連付けるバージョン文字列を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: バージョンは設定されません。
  version = "1.0.0"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # ストレージ設定
  #-------------------------------------------------------------

  # storage_location (Required)
  # 設定内容: ゲームビルドファイルが保存されているS3バケットの情報を指定する設定ブロックです。
  # 関連機能: Amazon GameLift ビルドストレージ
  #   GameLiftはS3バケットからゲームサーバーバイナリを読み込み、ビルドを作成します。
  #   - https://docs.aws.amazon.com/gamelift/latest/developerguide/gamelift-build-cli-uploading.html
  storage_location {

    # bucket (Required)
    # 設定内容: ゲームビルドファイルが格納されているS3バケット名を指定します。
    # 設定可能な値: 有効なS3バケット名
    bucket = "my-gamelift-builds-bucket"

    # key (Required)
    # 設定内容: ビルドファイルを含むzipファイルのS3オブジェクトキーを指定します。
    # 設定可能な値: 有効なS3オブジェクトキー（zipファイルのパス）
    key = "builds/my-game-server.zip"

    # role_arn (Required)
    # 設定内容: Amazon GameLiftがS3バケットにアクセスするために使用するIAMロールのARNを指定します。
    # 設定可能な値: 有効なIAMロールARN
    # 注意: 指定するIAMロールには、対象S3バケットへのアクセス権限が必要です。
    role_arn = "arn:aws:iam::123456789012:role/gamelift-s3-access-role"

    # object_version (Optional)
    # 設定内容: S3オブジェクトの特定バージョンを指定します。
    # 設定可能な値: 有効なS3オブジェクトバージョンID
    # 省略時: ファイルの最新バージョンを使用します。
    object_version = null
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
    Name        = "example-build"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: GameLift ビルドID
# - arn: GameLift ビルドのARN
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
