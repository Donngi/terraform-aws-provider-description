#-----------------------------------------------------------------------
# Provider Version: 6.28.0
# Generated: 2026-02-14
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/directory_service_shared_directory_accepter
#-----------------------------------------------------------------------
# NOTE: このリソースを削除すると、コンシューマーアカウントから共有ディレクトリが削除されます。
#       オーナーアカウントのディレクトリには影響しません。
#-----------------------------------------------------------------------
# Directory Service 共有ディレクトリ受入
#-----------------------------------------------------------------------
# 用途: Directory Service共有ディレクトリの共有招待をコンシューマーアカウントで受け入れる
# ユースケース: クロスアカウントでのディレクトリ共有、組織間ディレクトリアクセス
# 料金メモ: 共有ディレクトリ自体に追加費用なし（オーナーディレクトリの料金のみ）
# 注意事項:
#   - 共有招待は別途aws_directory_service_shared_directoryリソースで作成する必要がある
#   - コンシューマーアカウントで実行する必要がある
#-----------------------------------------------------------------------

#-----------------------------------------------------------------------
# 基本設定
#-----------------------------------------------------------------------

resource "aws_directory_service_shared_directory_accepter" "example" {
  # 設定内容: 共有ディレクトリID（コンシューマーアカウントに格納されたディレクトリ識別子）
  # 設定可能な値: d-xxxxxxxxxx形式のディレクトリID
  # 利用シーン: オーナーアカウントから送信された共有招待を受け入れる
  # 関連リソース: aws_directory_service_shared_directory（オーナーアカウント側で作成）
  shared_directory_id = aws_directory_service_shared_directory.example.shared_directory_id
}

#-----------------------------------------------------------------------
# リージョン管理
#-----------------------------------------------------------------------

resource "aws_directory_service_shared_directory_accepter" "example_with_region" {
  # 設定内容: 共有ディレクトリID
  shared_directory_id = aws_directory_service_shared_directory.example.shared_directory_id

  # 設定内容: リソース管理を行うリージョン
  # 設定可能な値: us-east-1, ap-northeast-1等の有効なAWSリージョンコード
  # 省略時: プロバイダー設定のリージョンを使用
  # 利用シーン: 特定リージョンでの共有ディレクトリ管理
  region = "us-east-1"
}

#-----------------------------------------------------------------------
# タイムアウト設定（オプション）
#-----------------------------------------------------------------------

# resource "aws_directory_service_shared_directory_accepter" "example_with_timeouts" {
#   shared_directory_id = aws_directory_service_shared_directory.example.shared_directory_id
#
#   # 設定内容: タイムアウト時間の設定
#   timeouts {
#     # 設定内容: 共有ディレクトリ受入のタイムアウト時間
#     # 設定可能な値: "30m", "1h"等の時間文字列
#     # 省略時: 60分
#     # 推奨値: 通常は省略（デフォルト値で十分）
#     create = "60m"
#
#     # 設定内容: 共有ディレクトリ削除のタイムアウト時間
#     # 設定可能な値: "30m", "1h"等の時間文字列
#     # 省略時: 60分
#     # 推奨値: 通常は省略（デフォルト値で十分）
#     delete = "60m"
#   }
# }

#-----------------------------------------------------------------------
# クロスアカウント共有の完全な例
#-----------------------------------------------------------------------

# # オーナーアカウント側（providerはデフォルト）
# resource "aws_directory_service_directory" "owner" {
#   name     = "corp.example.com"
#   password = "SuperSecretPassw0rd"
#   type     = "MicrosoftAD"
#   edition  = "Standard"
#
#   vpc_settings {
#     vpc_id     = aws_vpc.owner.id
#     subnet_ids = [aws_subnet.owner_1.id, aws_subnet.owner_2.id]
#   }
# }
#
# resource "aws_directory_service_shared_directory" "example" {
#   directory_id = aws_directory_service_directory.owner.id
#   notes        = "本番環境のディレクトリを共有します"
#
#   target {
#     # コンシューマーアカウントID
#     id = "123456789012"
#   }
# }
#
# # コンシューマーアカウント側（別プロバイダー設定が必要）
# provider "aws" {
#   alias   = "consumer"
#   profile = "consumer-account"
# }
#
# resource "aws_directory_service_shared_directory_accepter" "example" {
#   provider = aws.consumer
#
#   shared_directory_id = aws_directory_service_shared_directory.example.shared_directory_id
# }
#
# # 受け入れた共有ディレクトリをEC2インスタンスで使用する例
# resource "aws_directory_service_region" "consumer_region" {
#   provider = aws.consumer
#
#   directory_id = aws_directory_service_shared_directory_accepter.example.id
#   region_name  = "ap-northeast-1"
#
#   vpc_settings {
#     vpc_id     = aws_vpc.consumer.id
#     subnet_ids = [aws_subnet.consumer_1.id, aws_subnet.consumer_2.id]
#   }
# }

#-----------------------------------------------------------------------
# Attributes Reference
#-----------------------------------------------------------------------
# id                - 共有ディレクトリの識別子
# method            - ディレクトリ共有で使用された方法（ORGANIZATIONS または HANDSHAKE）
# notes             - オーナーが送信した共有招待メッセージ
# owner_account_id  - ディレクトリオーナーのAWSアカウントID
# owner_directory_id - オーナー視点でのManaged Microsoft ADディレクトリID
#-----------------------------------------------------------------------
