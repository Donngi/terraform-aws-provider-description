#---------------------------------------------------------------
# Amazon FSx S3 Access Point Attachment
#---------------------------------------------------------------
#
# Amazon FSx for OpenZFS のボリュームに Amazon S3 Access Point を
# アタッチするリソース。S3 API を使用してファイルシステムデータに
# アクセスできるようにし、AI/ML/分析サービスとの統合を簡素化します。
#
# AWS公式ドキュメント:
#   - Accessing your data using Amazon S3 access points: https://docs.aws.amazon.com/fsx/latest/OpenZFSGuide/s3accesspoints-for-FSx.html
#   - Creating an access point: https://docs.aws.amazon.com/fsx/latest/OpenZFSGuide/fsxz-creating-access-points.html
#   - API Reference - S3AccessPointOpenZFSConfiguration: https://docs.aws.amazon.com/fsx/latest/APIReference/API_S3AccessPointOpenZFSConfiguration.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/fsx_s3_access_point_attachment
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_fsx_s3_access_point_attachment" "example" {
  #---------------------------------------------------------------
  # Required Parameters
  #---------------------------------------------------------------

  # (Required) S3 アクセスポイントの名前
  # - FSx for OpenZFS ボリュームへのアクセスポイントを識別するための名前
  # - DNS に公開されるため、機密情報を含めないこと
  # - アクセスポイントの命名規則に従う必要がある
  name = "example-access-point"

  # (Required) S3 アクセスポイントのタイプ
  # - 有効な値: "OPENZFS"
  # - FSx for OpenZFS ファイルシステムと S3 API の統合を指定
  type = "OPENZFS"

  #---------------------------------------------------------------
  # Optional Parameters
  #---------------------------------------------------------------

  # (Optional) リソースが管理されるリージョン
  # - 指定しない場合、プロバイダー設定のリージョンがデフォルトとして使用される
  # - リージョナルエンドポイントで管理される
  # - FSx ファイルシステムと同じリージョンである必要がある
  # region = "us-east-1"

  #---------------------------------------------------------------
  # OpenZFS Configuration Block
  #---------------------------------------------------------------

  # (Required) FSx for OpenZFS ボリュームへの S3 アクセスポイント作成時の設定
  # - ボリューム ID とファイルシステムユーザー ID を指定
  openzfs_configuration {
    # (Required) S3 アクセスポイントがアタッチされる FSx for OpenZFS ボリュームの ID
    # - 形式: "fsvol-" で始まる 23 文字の ID
    # - このボリュームに対して S3 API 経由でアクセスが可能になる
    volume_id = "fsvol-0123456789abcdef0"

    # (Required) ファイル読み取り/書き込みリクエストを承認するために使用される
    # ファイルシステムユーザー ID
    file_system_identity {
      # (Required) FSx for OpenZFS ユーザー ID のタイプ
      # - 有効な値: "POSIX"
      # - POSIX ユーザー/グループ ID に基づいてアクセス制御を行う
      type = "POSIX"

      # (Required) ファイルシステム POSIX ユーザーの UID と GID
      # - S3 API 経由のファイルアクセス時に使用されるユーザー/グループ ID
      posix_user {
        # (Required) ファイルシステムユーザーの UID
        # - POSIX ファイルシステムのユーザー ID
        # - 0 以上の整数値
        uid = 1001

        # (Required) ファイルシステムユーザーの GID
        # - POSIX ファイルシステムのグループ ID
        # - 0 以上の整数値
        gid = 1001

        # (Optional) ファイルシステムユーザーのセカンダリ GID のリスト
        # - 追加のグループメンバーシップを指定
        # - 複数のグループに所属する場合に使用
        # secondary_gids = [1002, 1003]
      }
    }
  }

  #---------------------------------------------------------------
  # S3 Access Point Configuration Block (Optional)
  #---------------------------------------------------------------

  # (Optional) S3 アクセスポイントの構成
  # - アクセスポリシーと VPC 制限を設定可能
  # s3_access_point {
  #   # (Optional) S3 アクセスポイントに関連付けられたアクセスポリシー
  #   # - IAM ポリシードキュメント (JSON 形式)
  #   # - S3 アクセスポイントへのアクセスを制御
  #   # - バケットポリシーや IAM ポリシーと組み合わせて評価される
  #   # policy = jsonencode({
  #   #   Version = "2012-10-17"
  #   #   Statement = [
  #   #     {
  #   #       Effect = "Allow"
  #   #       Principal = {
  #   #         AWS = "arn:aws:iam::123456789012:user/example-user"
  #   #       }
  #   #       Action = [
  #   #         "s3:GetObject",
  #   #         "s3:PutObject"
  #   #       ]
  #   #       Resource = "*"
  #   #     }
  #   #   ]
  #   # })
  #
  #   # (Optional) 特定の VPC からのアクセスのみを許可する VPC 構成
  #   # - ネットワークオリジン制御を実装
  #   # vpc_configuration {
  #     # (Optional) VPC ID
  #     # - 指定した VPC からのリクエストのみが S3 アクセスポイントにアクセス可能
  #     # - Block Public Access 設定と組み合わせて使用可能
  #     # vpc_id = "vpc-0123456789abcdef0"
  #   # }
  # }

  #---------------------------------------------------------------
  # Timeouts Configuration Block (Optional)
  #---------------------------------------------------------------

  # (Optional) リソース操作のタイムアウト設定
  # timeouts {
  #   # (Optional) リソース作成のタイムアウト
  #   # - デフォルト: 30分
  #   # - 形式: "30s", "5m", "1h" など
  #   # create = "30m"
  #
  #   # (Optional) リソース削除のタイムアウト
  #   # - デフォルト: 30分
  #   # - 形式: "30s", "5m", "1h" など
  #   # delete = "30m"
  # }
}

#---------------------------------------------------------------
# Attributes Reference (Computed Only)
#---------------------------------------------------------------
# 以下の属性は Terraform によって自動的に設定され、参照のみ可能です。
#
# - s3_access_point_alias (string)
#   S3 アクセスポイントのエイリアス
#   - S3 API リクエストで使用する短縮名
#   - 例: "example-access-point-1234567890abcdef0"
#
# - s3_access_point_arn (string)
#   S3 アクセスポイントの ARN
#   - Amazon リソースネーム (一意識別子)
#   - IAM ポリシーやリソースポリシーで使用
#   - 形式: "arn:aws:s3:region:account-id:accesspoint/access-point-name"
#
#---------------------------------------------------------------
