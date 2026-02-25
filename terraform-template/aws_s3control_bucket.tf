#---------------------------------------------------------------
# Amazon S3 on Outposts バケット
#---------------------------------------------------------------
#
# AWS Outposts上のS3バケットをプロビジョニングするリソースです。
# S3 on Outpostsは、オンプレミス環境にあるAWS Outpostsに
# S3ストレージを提供し、データをローカルで保存・処理できます。
# 通常のAWSリージョンのS3バケットは aws_s3_bucket リソースを使用してください。
#
# AWS公式ドキュメント:
#   - S3 on Outposts 概要: https://docs.aws.amazon.com/AmazonS3/latest/dev/S3onOutposts.html
#   - Outposts上のバケット管理: https://docs.aws.amazon.com/AmazonS3/latest/userguide/S3OutpostsWorkingBuckets.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3control_bucket
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_s3control_bucket" "example" {
  #-------------------------------------------------------------
  # 基本設定 (必須)
  #-------------------------------------------------------------

  # 設定内容: バケット名
  # 設定可能な値: 文字列（バケット名）
  bucket = "example-outpost-bucket"

  # 設定内容: バケットを作成するOutpostsのID
  # 設定可能な値: AWS OutpostsのリソースID (例: "op-XXXXXXXXXXXXXXXXX")
  outpost_id = "op-XXXXXXXXXXXXXXXXX"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # 設定内容: リソースを管理するリージョン
  # 設定可能な値: AWSリージョンコード (例: "us-east-1")
  # 省略時: プロバイダー設定のリージョンが使用される
  region = "us-east-1"

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # 設定内容: リソースに付与するタグのキーと値のマップ
  # 設定可能な値: map(string)
  # 省略時: タグなし
  tags = {
    Name        = "example-outpost-bucket"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
#
# aws_s3control_bucket リソースが生成する参照可能な属性:
#
# arn                      - バケットのAmazon Resource Name (ARN)
# creation_date            - バケットの作成日時 (UTC、RFC3339形式)
# id                       - バケットのARN
# public_access_block_enabled - パブリックアクセスブロックが有効かどうか (bool)
# tags_all                 - プロバイダーのdefault_tagsを含む全タグのマップ
#
#---------------------------------------------------------------
