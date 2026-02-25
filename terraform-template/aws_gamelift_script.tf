#---------------------------------------------------------------
# AWS GameLift Script
#---------------------------------------------------------------
#
# Amazon GameLift のリアルタイムサーバースクリプトをプロビジョニングするリソースです。
# Realtime ServersはNode.jsベースのゲームサーバーをスクリプトで定義する機能であり、
# S3バケットまたはzipファイルからスクリプトを取り込みます。
#
# AWS公式ドキュメント:
#   - Amazon GameLift Realtime Servers: https://docs.aws.amazon.com/gamelift/latest/developerguide/realtime-intro.html
#   - スクリプトのアップロード: https://docs.aws.amazon.com/gamelift/latest/developerguide/realtime-script-uploading.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/gamelift_script
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_gamelift_script" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: スクリプトの名前を指定します。
  # 設定可能な値: 任意の文字列
  name = "example-script"

  # version (Optional)
  # 設定内容: このスクリプトに関連付けるバージョン文字列を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: バージョンは設定されません。
  version = "1.0.0"

  # zip_file (Optional)
  # 設定内容: スクリプトファイルを含むzipファイルのBase64エンコードされた内容を指定します。
  # 設定可能な値: Base64エンコードされたzipファイルの内容（filebase64() 関数を使用）
  # 省略時: storage_location ブロックでS3からスクリプトを参照する必要があります。
  # 注意: zip_file と storage_location はどちらか一方を指定します。
  zip_file = null

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

  # storage_location (Optional)
  # 設定内容: スクリプトファイルが保存されているS3バケットの情報を指定する設定ブロックです。
  # 関連機能: Amazon GameLift スクリプトストレージ
  #   GameLiftはS3バケットからRealtime Serversスクリプトを読み込みます。
  #   zip_file を指定しない場合に使用します。
  #   - https://docs.aws.amazon.com/gamelift/latest/developerguide/realtime-script-uploading.html
  # 省略時: zip_file でスクリプトを直接指定する必要があります。
  storage_location {

    # bucket (Required)
    # 設定内容: スクリプトファイルが格納されているS3バケット名を指定します。
    # 設定可能な値: 有効なS3バケット名
    bucket = "my-gamelift-scripts-bucket"

    # key (Required)
    # 設定内容: スクリプトファイルを含むzipファイルのS3オブジェクトキーを指定します。
    # 設定可能な値: 有効なS3オブジェクトキー（zipファイルのパス）
    key = "scripts/my-realtime-script.zip"

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
    Name        = "example-script"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: GameLift スクリプトID
# - arn: GameLift スクリプトのARN
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
