#-----------------------------------------------
# AWS DataSync Location - FSx for Lustre
#-----------------------------------------------
# 用途: DataSyncタスクでFSx for Lustreファイルシステムをソースまたはデスティネーションとして使用するためのロケーション設定
# - S3やオンプレミスストレージとFSx for Lustre間のデータ転送を実現
# - セキュリティグループによるネットワークアクセス制御
# - サブディレクトリ単位での転送範囲指定に対応
# - 複数DataSyncタスクでの共有利用が可能
#
# NOTE: このテンプレートは自動生成されたものです。環境に応じて適宜修正してください。
#
# Provider Version: 6.28.0
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/datasync_location_fsx_lustre_file_system
# Generated: 2026-02-14
#-----------------------------------------------

#-----------------------------------------------
# 基本設定
#-----------------------------------------------

resource "aws_datasync_location_fsx_lustre_file_system" "example" {
  # 設定内容: 転送対象となるFSx for LustreファイルシステムのARN
  # 備考: ファイルシステムは同一リージョン内に存在する必要がある
  fsx_filesystem_arn = "arn:aws:fsx:us-east-1:123456789012:file-system/fs-0123456789abcdef0"

  # 設定内容: DataSyncタスクが使用するセキュリティグループのARNセット
  # 備考: FSx for Lustreへのネットワークアクセスを許可するセキュリティグループを指定
  # 備考: 最低1つのセキュリティグループが必須
  security_group_arns = [
    "arn:aws:ec2:us-east-1:123456789012:security-group/sg-0123456789abcdef0",
    "arn:aws:ec2:us-east-1:123456789012:security-group/sg-abcdef0123456789a",
  ]

  #-----------------------------------------------
  # パス設定
  #-----------------------------------------------

  # 設定内容: 転送対象とするファイルシステム内のサブディレクトリパス
  # 省略時: ファイルシステムのルートディレクトリが対象となる
  # 備考: パスは /fsx で始まる絶対パスで指定
  subdirectory = "/fsx/data"

  #-----------------------------------------------
  # リージョン設定
  #-----------------------------------------------

  # 設定内容: リソースを管理するAWSリージョン
  # 省略時: プロバイダー設定のリージョンが使用される
  # 備考: FSx for Lustreファイルシステムと同一リージョンを指定
  region = "us-east-1"

  #-----------------------------------------------
  # タグ設定
  #-----------------------------------------------

  # 設定内容: リソースに付与するタグのキー・バリューペア
  # 備考: コスト配分、運用管理、セキュリティポリシー適用に活用
  tags = {
    Name        = "datasync-fsx-lustre-location"
    Environment = "production"
    DataType    = "analytics-data"
    ManagedBy   = "terraform"
  }
}

#-----------------------------------------------
# Attributes Reference（参照専用属性）
#-----------------------------------------------
# 以下の属性は読み取り専用です。他のリソースから参照できます。
#
# arn
#   ロケーションのAmazon Resource Name (ARN)
#   形式: arn:aws:datasync:us-east-1:123456789012:location/loc-0123456789abcdef0
#
# creation_time
#   ロケーションの作成日時（RFC3339形式）
#   形式: 2024-01-15T12:34:56Z
#
# id
#   ロケーションのID（通常はarnと同値）
#
# tags_all
#   プロバイダーのdefault_tagsとリソースのtagsをマージした全タグ
#
# uri
#   ロケーションのURI形式のパス
#   形式: fsxl://us-east-1.fs-0123456789abcdef0.fsx.amazonaws.com/fsx/data
#-----------------------------------------------
