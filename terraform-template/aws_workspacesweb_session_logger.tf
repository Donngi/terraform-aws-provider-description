#---------------------------------------------------------------
# AWS WorkSpaces Web Session Logger
#---------------------------------------------------------------
#
# WorkSpaces Webセッションロガーを管理するリソースです。
# セッションイベント（開始・終了など）をS3バケットへ記録する構成を定義します。
# イベントフィルターで全イベントまたは特定イベントを選択し、
# S3バケットへのログ出力形式（JSON / Parquet）やフォルダ構成を設定できます。
#
# 注意: S3バケットにworkspaces-web.amazonaws.comからのs3:PutObjectを許可する
#       バケットポリシーをあらかじめ設定する必要があります。
#
# AWS公式ドキュメント:
#   - https://docs.aws.amazon.com/workspaces-web/latest/adminguide/session-logger.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/workspacesweb_session_logger
#
# Provider Version: 6.28.0
# Generated: 2026-02-22
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_workspacesweb_session_logger" "example" {

  #---------------------------------------
  # 基本設定
  #---------------------------------------

  # 設定内容: セッションロガーの表示名
  # 設定可能な値: 任意の文字列
  # 省略時: 設定なし
  # 注意: 変更するとリソースの再作成が発生する
  display_name = "example-session-logger"

  # 設定内容: 機密情報の暗号化に使用するカスタマーマネージドKMSキーのARN
  # 設定可能な値: KMSキーのARN文字列
  # 省略時: AWSマネージドキーが使用される
  customer_managed_key = "arn:aws:kms:us-east-1:123456789012:key/example-key-id"

  # 設定内容: KMS暗号化コンテキストに追加するキーと値のマッピング
  # 設定可能な値: 任意のキーと値のマップ
  # 省略時: 追加コンテキストなし
  additional_encryption_context = {
    Environment = "Production"
  }

  # 設定内容: リソースを管理するAWSリージョン
  # 設定可能な値: AWSリージョンコード（例: "us-east-1", "ap-northeast-1"）
  # 省略時: プロバイダー設定のリージョンが使用される
  region = "us-east-1"

  #---------------------------------------
  # イベントフィルター設定
  #---------------------------------------

  # 設定内容: ログに記録するセッションイベントのフィルター条件
  # 注意: all ブロックまたは include のいずれかを設定する
  event_filter {

    # 設定内容: 全イベントを記録する場合に指定する空ブロック
    # 省略時: include で個別のイベントを指定する必要がある
    all {}

    # 設定内容: 記録対象とする特定イベントのリスト（all を使わない場合に指定）
    # 設定可能な値: "SessionStart", "SessionEnd" などのセッションイベント名
    # 省略時: all ブロックを使用する場合は不要
    # include = ["SessionStart", "SessionEnd"]
  }

  #---------------------------------------
  # ログ出力設定
  #---------------------------------------

  # 設定内容: セッションログの配信先と形式を定義するブロック
  log_configuration {

    # 設定内容: S3バケットへのログ配信設定
    s3 {

      # 設定内容: ログの配信先S3バケット名
      # 設定可能な値: 既存のS3バケット名
      bucket = "example-session-logs"

      # 設定内容: S3バケット内のログファイルのフォルダ構成
      # 設定可能な値: "FlatStructure"（フラット）, "DateBasedStructure"（日付階層）
      folder_structure = "FlatStructure"

      # 設定内容: S3に書き込まれるログファイルのフォーマット
      # 設定可能な値: "Json"（JSONフォーマット）, "Parquet"（Parquetフォーマット）
      log_file_format = "Json"

      # 設定内容: ターゲットS3バケットの所有者アカウントID
      # 設定可能な値: AWSアカウントID文字列
      # 省略時: AWSが自動的に解決する
      bucket_owner = "123456789012"

      # 設定内容: ログファイルを格納するS3パスプレフィックス
      # 設定可能な値: 任意のS3パス文字列
      # 省略時: バケットのルートに配置される
      key_prefix = "workspaces-web-logs/"
    }
  }

  #---------------------------------------
  # タグ設定
  #---------------------------------------

  # 設定内容: リソースに付与するタグのマッピング
  # 設定可能な値: 任意のキーと値のマップ
  # 省略時: タグなし
  tags = {
    Name        = "example-session-logger"
    Environment = "Production"
  }
}

#---------------------------------------
# Attributes Reference
#---------------------------------------
# session_logger_arn       - セッションロガーのARN
# associated_portal_arns   - このセッションロガーに関連付けられたWebポータルのARNリスト
# tags_all                 - プロバイダーのdefault_tagsを含む全タグのマップ
