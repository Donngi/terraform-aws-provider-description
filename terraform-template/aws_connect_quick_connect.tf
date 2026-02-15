#-------
# Amazon Connect Quick Connect
#-------
# Provider Version: 6.28.0
# Generated: 2026-02-13
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/connect_quick_connect
#
# 用途: Amazon Connectのクイック接続を作成・管理
#
# クイック接続は、コンタクトセンターのエージェントや顧客が
# 他のエージェント、キュー、または外部電話番号に素早く転送
# できるようにするための事前定義された接続先です。
#
# 主な用途:
# - エージェント間転送の設定
# - キューへの転送ルーティング
# - 外部電話番号への転送
# - コンタクトフローでの転送先設定
#
# 関連リソース:
# - aws_connect_instance: Connect インスタンス
# - aws_connect_queue: Connect キュー
# - aws_connect_user: Connect ユーザー
# - aws_connect_contact_flow: コンタクトフロー
#
# AWS公式ドキュメント:
# https://docs.aws.amazon.com/connect/latest/adminguide/quick-connects.html
#
# NOTE:
# - クイック接続は、コンタクトフロー内で転送先として使用されます
# - 各タイプ（USER/QUEUE/PHONE_NUMBER）に応じて適切な設定ブロックを使用してください
# - phone_configを使用する場合、電話番号はE.164形式で指定する必要があります
#-------

#-------
# 基本設定
#-------
# Connect インスタンスとクイック接続の基本設定
#-------

resource "aws_connect_quick_connect" "example" {
  # 設定内容: Amazon Connect インスタンスのID
  # 設定可能な値: 既存のConnect インスタンスID
  instance_id = "arn:aws:connect:us-west-2:123456789012:instance/11111111-1111-1111-1111-111111111111"

  # 設定内容: クイック接続の名前
  # 設定可能な値: 1-127文字の英数字、ハイフン、アンダースコア
  name = "example-quick-connect"

  # 設定内容: クイック接続の説明
  # 設定可能な値: 1-250文字の説明テキスト
  # 省略時: 説明なし
  description = "Example quick connect for routing to agents or queues"

  #-------
  # クイック接続設定
  #-------
  # 転送先のタイプと詳細設定を定義
  #-------

  quick_connect_config {
    # 設定内容: クイック接続のタイプ
    # 設定可能な値: PHONE_NUMBER（外部電話）、QUEUE（キュー）、USER（ユーザー/エージェント）
    quick_connect_type = "USER"

    # --- ユーザー転送設定（quick_connect_type = "USER"の場合に使用）---
    # エージェント間の転送を設定
    user_config {
      # 設定内容: 転送時に使用するコンタクトフローのID
      # 設定可能な値: 既存のコンタクトフローのID
      contact_flow_id = "22222222-2222-2222-2222-222222222222"

      # 設定内容: 転送先のConnect ユーザーID
      # 設定可能な値: 既存のConnect ユーザーのID
      user_id = "33333333-3333-3333-3333-333333333333"
    }

    # --- キュー転送設定（quick_connect_type = "QUEUE"の場合に使用）---
    # キューへの転送を設定
    # queue_config {
    #   # 設定内容: 転送時に使用するコンタクトフローのID
    #   # 設定可能な値: 既存のコンタクトフローのID
    #   contact_flow_id = "44444444-4444-4444-4444-444444444444"
    #
    #   # 設定内容: 転送先のConnect キューID
    #   # 設定可能な値: 既存のConnect キューのID
    #   queue_id = "55555555-5555-5555-5555-555555555555"
    # }

    # --- 外部電話転送設定（quick_connect_type = "PHONE_NUMBER"の場合に使用）---
    # 外部電話番号への転送を設定
    # phone_config {
    #   # 設定内容: 転送先の電話番号
    #   # 設定可能な値: E.164形式の電話番号（例: +81312345678）
    #   phone_number = "+15551234567"
    # }
  }

  #-------
  # リソース管理設定
  #-------

  # 設定内容: リソースのリージョン指定
  # 設定可能な値: AWSリージョンコード（例: us-west-2）
  # 省略時: プロバイダー設定のリージョンを使用
  region = "us-west-2"

  # 設定内容: リソースに付与するタグ
  # 設定可能な値: キーと値のペア（最大50タグ）
  # 省略時: タグなし
  tags = {
    Environment = "production"
    Team        = "customer-service"
    Purpose     = "agent-routing"
  }
}

#-------
# Attributes Reference（参照可能な属性）
#-------
# この aws_connect_quick_connect リソースが提供する参照可能な属性:
#
# arn              : クイック接続のARN
#                    例: arn:aws:connect:us-west-2:123456789012:instance/11111111-1111-1111-1111-111111111111/transfer-destination/66666666-6666-6666-6666-666666666666
#
# id               : クイック接続のID（インスタンスIDとクイック接続IDの組み合わせ）
#                    例: 11111111-1111-1111-1111-111111111111:66666666-6666-6666-6666-666666666666
#
# quick_connect_id : クイック接続の一意なID
#                    例: 66666666-6666-6666-6666-666666666666
#
# 参照方法:
#   aws_connect_quick_connect.example.arn
#-------
