#---------------------------------------------------------------
# AWS WorkSpaces Web User Access Logging Settings
#---------------------------------------------------------------
#
# Amazon WorkSpaces Secure Browserのユーザーアクセスログ設定を
# プロビジョニングするリソースです。
# Webポータルに関連付けると、ユーザーアクセスイベントがAmazon Kinesis
# データストリームにログ記録されます。セッションの開始・終了、URL訪問
# などの重要なセッションイベントをリアルタイムで処理・分析できます。
#
# AWS公式ドキュメント:
#   - User Access Logging概要: https://docs.aws.amazon.com/workspaces-web/latest/adminguide/data-protection-logging.html
#   - User Access Loggingの設定: https://docs.aws.amazon.com/workspaces-web/latest/adminguide/user-access-logging.html
#   - セッションイベント: https://docs.aws.amazon.com/workspaces-web/latest/adminguide/session-events-logging.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/workspacesweb_user_access_logging_settings
#
# Provider Version: 6.28.0
# Generated: 2026-02-06
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_workspacesweb_user_access_logging_settings" "example" {
  #-------------------------------------------------------------
  # Kinesisストリーム設定
  #-------------------------------------------------------------

  # kinesis_stream_arn (Required)
  # 設定内容: ユーザーアクセスログの配信先となるKinesisデータストリームのARNを指定します。
  # 設定可能な値: 有効なKinesisストリームのARN
  # 注意: ストリーム名は "amazon-workspaces-web-" で始まる必要があります。
  #       また、ストリームはサーバーサイド暗号化が無効か、AWS管理キーによる
  #       サーバーサイド暗号化を使用している必要があります。
  # 参考: https://docs.aws.amazon.com/workspaces-web/latest/adminguide/user-access-logging.html
  kinesis_stream_arn = "arn:aws:kinesis:ap-northeast-1:123456789012:stream/amazon-workspaces-web-example-stream"

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
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-user-access-logging-settings"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - associated_portal_arns: このユーザーアクセスログ設定リソースに関連付けられている
#                           Webポータルの ARN のリスト。
#
# - user_access_logging_settings_arn: ユーザーアクセスログ設定リソースのARN。
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
