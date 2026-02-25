#---------------------------------------------------------------
# AWS S3 Control Multi-Region Access Point Policy
#---------------------------------------------------------------
#
# マルチリージョンアクセスポイントのアクセスポリシーをプロビジョニングするリソースです。
# マルチリージョンアクセスポイントに対するIAMリソースポリシーを定義し、
# グローバルエンドポイントを通じたデータアクセスを制御します。
# ポリシーの変更はプロポーズド（proposed）として送信され、非同期で確立されます。
#
# AWS公式ドキュメント:
#   - マルチリージョンアクセスポイントポリシー: https://docs.aws.amazon.com/AmazonS3/latest/userguide/MultiRegionAccessPointPermissions.html
#   - マルチリージョンアクセスポイント概要: https://docs.aws.amazon.com/AmazonS3/latest/userguide/MultiRegionAccessPoints.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3control_multi_region_access_point_policy
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_s3control_multi_region_access_point_policy" "example" {
  #-------------------------------------------------------------
  # アカウント設定
  #-------------------------------------------------------------

  # account_id (Optional)
  # 設定内容: マルチリージョンアクセスポイントを所有するAWSアカウントIDを指定します。
  # 設定可能な値: 12桁のAWSアカウントID
  # 省略時: Terraformプロバイダー設定のアカウントIDを使用
  account_id = null

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # ポリシー詳細設定
  #-------------------------------------------------------------

  # details (Required)
  # 設定内容: マルチリージョンアクセスポイントポリシーの詳細設定を指定します。
  # 関連機能: アクセスポイントポリシー設定
  #   アクセスポイント名と適用するIAMリソースポリシーを定義するブロックです。
  #   ポリシーはプロポーズド（proposed）として送信され、非同期で確立（established）されます。
  #   - https://docs.aws.amazon.com/AmazonS3/latest/userguide/MultiRegionAccessPointPermissions.html
  details {
    # name (Required)
    # 設定内容: ポリシーを適用するマルチリージョンアクセスポイントの名前を指定します。
    # 設定可能な値: 既存のマルチリージョンアクセスポイント名（3-50文字の小文字英数字とハイフン）
    name = "example-mrap"

    # policy (Required)
    # 設定内容: マルチリージョンアクセスポイントに適用するIAMリソースポリシーを
    #          JSON形式で指定します。
    # 設定可能な値: IAMポリシードキュメント（JSON文字列）
    # 注意: jsonencode()を使用してポリシードキュメントを記述することを推奨します。
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [{
        Sid       = "AllowGetObject"
        Effect    = "Allow"
        Principal = { AWS = "arn:aws:iam::123456789012:role/example-role" }
        Action    = ["s3:GetObject"]
        Resource  = "arn:aws:s3::123456789012:accesspoint/example-mrap/object/*"
      }]
    })
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: "60m"のようなGoのDuration形式の文字列
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    create = "60m"

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウト時間を指定します。
    # 設定可能な値: "60m"のようなGoのDuration形式の文字列
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    update = "60m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: AWSアカウントIDとアクセスポイント名をコロンで結合した識別子
#       (形式: account_id:access_point_name)
#
# - established: マルチリージョンアクセスポイントに現在確立されているポリシー（JSON文字列）
#
# - proposed: 未確立のプロポーズドポリシー（JSON文字列）。
#             ポリシーが確立されると established に移行します。
#---------------------------------------------------------------
