#---------------------------------------
# Amazon FSx S3アクセスポイントアタッチメント
#---------------------------------------
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: openzfs_configurationはtype=OpenZFSの場合に必須。file_system_identityのtypeはPOSIXのみサポート
#
# FSx for OpenZFSボリュームにS3アクセスポイントをアタッチして管理するリソース
# S3アクセスポイントを通じてFSxボリュームにS3互換のAPIアクセスを提供する
#
# 主な機能:
# - FSx for OpenZFSボリュームへのS3アクセスポイント作成・アタッチ
# - POSIXユーザーIDによるファイルシステムアクセス制御
# - VPCエンドポイント経由のアクセス制限設定
# - S3バケットポリシー互換のアクセスポリシー設定
#
# ユースケース:
# - S3 APIを使用してFSxファイルシステムにアクセスする場合
# - 特定VPC内からのみFSxデータへのS3アクセスを許可する場合
# - POSIXユーザー権限でFSxボリュームのデータを操作する場合
# - S3互換ツールからFSx for OpenZFSのデータにアクセスする場合
#
# 制約事項:
# - 現在サポートされているtypeはOpenZFSのみ
# - openzfs_configurationはtype=OpenZFSの場合に必須
# - file_system_identityのtypeはPOSIXのみサポート
# - vpc_configuration指定時はVPCからのアクセスのみに限定される
#
# 参考資料:
# - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/fsx_s3_access_point_attachment
# - https://docs.aws.amazon.com/fsx/latest/OpenZFSGuide/s3accesspoints-for-FSx.html

#---------------------------------------
# Terraform設定
#---------------------------------------
terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.28.0"
    }
  }
}

#---------------------------------------
# Provider設定
#---------------------------------------
provider "aws" {
  region = "ap-northeast-1"

  default_tags {
    tags = {
      Environment = "production"
      ManagedBy   = "terraform"
    }
  }
}

#---------------------------------------
# 基本設定（OpenZFSボリュームへのS3アクセスポイントアタッチ）
#---------------------------------------

# OpenZFSボリュームに対するS3アクセスポイントアタッチメント（最小構成）
resource "aws_fsx_s3_access_point_attachment" "example" {
  # アクセスポイント名
  # 設定内容: S3アクセスポイントの名前
  # 設定可能な値: 英数字とハイフンを使用した文字列
  # 省略時: 設定必須
  name = "example-attachment"

  # アクセスポイントタイプ
  # 設定内容: S3アクセスポイントのタイプ
  # 設定可能な値: "OpenZFS"
  # 省略時: 設定必須
  type = "OpenZFS"

  # OpenZFS設定
  # 設定内容: FSx for OpenZFSボリュームへのS3アクセスポイント設定
  # 省略時: 設定必須（typeがOpenZFSの場合）
  openzfs_configuration {
    # ボリュームID
    # 設定内容: S3アクセスポイントをアタッチするFSx for OpenZFSボリュームのID
    # 設定可能な値: 既存のOpenZFSボリュームID (fsvol-xxxxxxxxxxxxxxxxx形式)
    # 省略時: 設定必須
    volume_id = "fsvol-0123456789abcdef0"

    # ファイルシステムIDentity設定
    # 設定内容: S3アクセスポイント経由のファイル読み書きリクエストを認可するユーザーID
    # 省略時: 設定必須
    file_system_identity {
      # IDentityタイプ
      # 設定内容: FSx for OpenZFSのユーザーIDentityタイプ
      # 設定可能な値: "POSIX"
      # 省略時: 設定必須
      type = "POSIX"

      # POSIXユーザー設定
      # 設定内容: ファイルシステムのPOSIXユーザーのUIDおよびGID
      # 省略時: 設定必須（typeがPOSIXの場合）
      posix_user {
        # ユーザーID
        # 設定内容: ファイルシステムユーザーのUID
        # 設定可能な値: 0以上の整数
        # 省略時: 設定必須
        uid = 1001

        # グループID
        # 設定内容: ファイルシステムユーザーのGID
        # 設定可能な値: 0以上の整数
        # 省略時: 設定必須
        gid = 1001

        # セカンダリグループID一覧
        # 設定内容: ファイルシステムユーザーのセカンダリGIDリスト
        # 設定可能な値: 0以上の整数のリスト
        # 省略時: セカンダリGIDなし
        secondary_gids = []
      }
    }
  }
}

#---------------------------------------
# VPC制限付きS3アクセスポイントアタッチメント設定
#---------------------------------------

# VPCエンドポイント経由のみアクセスを許可するS3アクセスポイントアタッチメント
resource "aws_fsx_s3_access_point_attachment" "vpc_restricted" {
  name = "vpc-restricted-attachment"
  type = "OpenZFS"

  openzfs_configuration {
    volume_id = "fsvol-0123456789abcdef0"

    file_system_identity {
      type = "POSIX"

      posix_user {
        uid = 1001
        gid = 1001
      }
    }
  }

  # S3アクセスポイント設定
  # 設定内容: S3アクセスポイントの詳細設定（ポリシーとVPC制限）
  # 省略時: デフォルト設定でアクセスポイントを作成
  s3_access_point {
    # アクセスポリシー
    # 設定内容: S3アクセスポイントに関連付けるアクセスポリシー（JSON形式）
    # 設定可能な値: IAMポリシードキュメントJSON文字列
    # 省略時: ポリシーなし
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Sid    = "AllowVpcAccess"
          Effect = "Allow"
          Principal = {
            AWS = "arn:aws:iam::123456789012:role/example-role"
          }
          Action = [
            "s3:GetObject",
            "s3:PutObject",
            "s3:DeleteObject",
            "s3:ListBucket"
          ]
          Resource = "*"
        }
      ]
    })

    # VPC設定
    # 設定内容: S3アクセスポイントへのアクセスを制限するVPCの設定
    # 省略時: VPC制限なし（パブリックアクセス可能）
    vpc_configuration {
      # VPC ID
      # 設定内容: S3アクセスポイントへのアクセスを制限するVPCのID
      # 設定可能な値: 既存のVPC ID (vpc-xxxxxxxxxxxxxxxxx形式)
      # 省略時: VPC制限なし
      vpc_id = "vpc-0123456789abcdef0"
    }
  }
}

#---------------------------------------
# リージョン指定設定
#---------------------------------------

# 特定リージョンで管理するS3アクセスポイントアタッチメント
resource "aws_fsx_s3_access_point_attachment" "cross_region" {
  name = "cross-region-attachment"
  type = "OpenZFS"

  # リージョン設定
  # 設定内容: リソースを管理するAWSリージョン
  # 設定可能な値: 有効なAWSリージョンコード (us-east-1, ap-northeast-1など)
  # 省略時: プロバイダー設定のリージョン
  region = "us-east-1"

  openzfs_configuration {
    volume_id = "fsvol-0123456789abcdef0"

    file_system_identity {
      type = "POSIX"

      posix_user {
        uid = 0
        gid = 0
      }
    }
  }
}

#---------------------------------------
# タイムアウト設定
#---------------------------------------

# タイムアウトカスタマイズ設定のS3アクセスポイントアタッチメント
resource "aws_fsx_s3_access_point_attachment" "with_timeouts" {
  name = "timeout-example-attachment"
  type = "OpenZFS"

  openzfs_configuration {
    volume_id = "fsvol-0123456789abcdef0"

    file_system_identity {
      type = "POSIX"

      posix_user {
        uid = 1001
        gid = 1001
      }
    }
  }

  # タイムアウト設定
  timeouts {
    # 作成タイムアウト
    # 設定内容: S3アクセスポイントアタッチメント作成の最大待機時間
    # 設定可能な値: Go duration形式 (例: 30s, 10m, 1h)
    # 省略時: デフォルトタイムアウト値
    create = "30m"

    # 削除タイムアウト
    # 設定内容: S3アクセスポイントアタッチメント削除の最大待機時間
    # 設定可能な値: Go duration形式 (例: 30s, 10m, 1h)
    # 省略時: デフォルトタイムアウト値
    delete = "30m"
  }
}

#---------------------------------------
# Attributes Reference (参照専用属性)
#---------------------------------------
# このセクションの属性は読み取り専用で、リソース作成後に参照可能

# s3_access_point_alias: S3アクセスポイントのエイリアス名
output "s3_access_point_alias" {
  description = "S3アクセスポイントのエイリアス"
  value       = aws_fsx_s3_access_point_attachment.example.s3_access_point_alias
}

# s3_access_point_arn: S3アクセスポイントのAmazon Resource Name (ARN)
output "s3_access_point_arn" {
  description = "S3アクセスポイントのARN"
  value       = aws_fsx_s3_access_point_attachment.example.s3_access_point_arn
}
