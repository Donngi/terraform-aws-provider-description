# ================================================================================
# AWS S3 Access Point - Terraform Annotated Template
# ================================================================================
# Provider Version: 6.28.0
# Resource: aws_s3_access_point
#
# Overview:
# - S3 Access Pointは、S3バケット内の共有データセットへのアクセスを簡素化するための
#   名前付きネットワークエンドポイントです
# - 各アクセスポイントには独自の権限とネットワークコントロールがあります
# - VPCからのみのアクセス制限、カスタムBlock Public Access設定が可能です
# - S3 General Purpose Bucket、S3 on Outposts、Directory Bucketで使用できます
#
# Important Notes:
# - Access Point PolicyはAccess Point Policy専用リソース(aws_s3control_access_point_policy)
#   と併用できません。ポリシーの競合が発生します
# - カスタムAPIエンドポイントを使用する場合は、s3controlエンドポイント設定を使用してください
# - アクセスポイントはHTTPSのみサポートし、HTTPはサポートされていません
# - S3 on OutpostsではVPC設定が必須です
#
# Use Cases:
# - マルチリージョンアプリケーションの高速化
# - VPCからのプライベートアクセスの提供
# - バケット単位ではなく、データセット単位でのアクセス制御
# - 計画的/非計画的な障害時のフェイルオーバー管理
# ================================================================================

# ================================================================================
# Example 1: Basic S3 Access Point for General Purpose Bucket
# ================================================================================
# 標準的なS3バケット用のアクセスポイント設定
# - 最もシンプルな構成
# - パブリックアクセスブロック設定はデフォルトで有効
# ================================================================================

resource "aws_s3_bucket" "example" {
  bucket = "example-bucket-name"
}

resource "aws_s3_access_point" "example" {
  # ================================================================================
  # Required Arguments
  # ================================================================================

  # bucket - (Required) S3バケット名またはS3 on Outposts BucketのARN
  # - AWS Partition S3 General Purpose Bucketの名前
  # - または S3 on Outposts BucketのARN
  # Example: "my-bucket" または "arn:aws:s3-outposts:region:account:outpost/op-id/bucket/bucket-name"
  bucket = aws_s3_bucket.example.id

  # name - (Required) アクセスポイントに割り当てる名前
  # - 命名規則: https://docs.aws.amazon.com/AmazonS3/latest/userguide/creating-access-points.html#access-points-names
  # - アカウント内で一意である必要があります
  # - 小文字、数字、ハイフンのみ使用可能
  # - 3〜50文字
  # - Directory Bucketの場合: "name--zoneId--xa-s3" 形式
  name = "example-access-point"

  # ================================================================================
  # Optional Arguments
  # ================================================================================

  # account_id - (Optional) アクセスポイントのオーナーAWSアカウントID
  # - デフォルト: Terraform AWSプロバイダーのアカウントIDが自動決定されます
  # - クロスアカウントでアクセスポイントを作成する場合に指定
  # account_id = "123456789012"

  # bucket_account_id - (Optional) S3バケットが所属するAWSアカウントID
  # - クロスアカウントアクセスの場合に指定
  # bucket_account_id = "123456789012"

  # policy - (Optional) アクセスポイントに適用するポリシー(JSON形式)
  # - aws_s3control_access_point_policyと併用不可
  # - policyを削除する場合は "{}" を設定(null や "" では削除されません)
  # - バケットポリシーと組み合わせて、きめ細かいアクセス制御が可能
  # policy = jsonencode({
  #   Version = "2012-10-17"
  #   Statement = [{
  #     Effect = "Allow"
  #     Principal = {
  #       AWS = "arn:aws:iam::123456789012:role/example-role"
  #     }
  #     Action = [
  #       "s3:GetObject",
  #       "s3:PutObject"
  #     ]
  #     Resource = "arn:aws:s3:region:account-id:accesspoint/access-point-name/object/*"
  #   }]
  # })

  # region - (Optional) リソースを管理するリージョン
  # - デフォルト: プロバイダー設定のリージョン
  # - マルチリージョン構成で明示的に指定する場合に使用
  # region = "us-east-1"

  # tags - (Optional) アクセスポイントに割り当てるタグ
  # - provider default_tagsと組み合わせて使用可能
  tags = {
    Name        = "example-access-point"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

# ================================================================================
# Example 2: VPC-Restricted Access Point (S3 on Outposts)
# ================================================================================
# VPCからのみアクセス可能なアクセスポイント
# - S3 on Outpostsでは必須設定
# - network_originは自動的に "VPC" になります
# ================================================================================

resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "example-vpc"
  }
}

resource "aws_s3control_bucket" "outposts_example" {
  bucket = "example-outposts-bucket"
  # Outpost ARN等の追加設定が必要
}

resource "aws_s3_access_point" "vpc_restricted" {
  bucket = aws_s3control_bucket.outposts_example.arn
  name   = "vpc-restricted-access-point"

  # ================================================================================
  # vpc_configuration Block
  # ================================================================================
  # - アクセスポイントへのアクセスを特定のVPCからのリクエストに制限
  # - S3 on Outpostsでは必須
  # - max_items: 1
  # ================================================================================
  vpc_configuration {
    # vpc_id - (Required) アクセスを許可するVPC ID
    # - このVPC IDからの接続のみが許可されます
    # - VPCエンドポイント経由でプライベートアクセスが可能
    vpc_id = aws_vpc.example.id
  }

  tags = {
    Name        = "vpc-restricted-access-point"
    Environment = "production"
    AccessType  = "VPC-Only"
  }
}

# ================================================================================
# Example 3: Access Point with Public Access Block Configuration
# ================================================================================
# パブリックアクセスブロック設定を明示的に構成したアクセスポイント
# - デフォルトではすべてtrueで有効
# - バケット、アカウントレベルのBlock Public Access設定と組み合わせて評価されます
# ================================================================================

resource "aws_s3_bucket" "public_block_example" {
  bucket = "public-block-example-bucket"
}

resource "aws_s3_access_point" "with_public_block" {
  bucket = aws_s3_bucket.public_block_example.id
  name   = "public-block-access-point"

  # ================================================================================
  # public_access_block_configuration Block
  # ================================================================================
  # - アクセスポイントに適用するPublicAccessBlock設定
  # - 作成後は変更不可(アクセスポイントの再作成が必要)
  # - 各オプションは任意の組み合わせで有効化可能
  # - max_items: 1
  #
  # 評価順序:
  # 1. アクセスポイントのBlock Public Access設定
  # 2. 基盤となるバケットのBlock Public Access設定
  # 3. バケットオーナーアカウントのBlock Public Access設定
  # いずれかでブロックが指定されている場合、リクエストは拒否されます
  # ================================================================================
  public_access_block_configuration {
    # block_public_acls - (Optional) パブリックACLをブロックするか
    # - デフォルト: true
    # - trueの場合の動作:
    #   * パブリックACLを指定したPUT Bucket aclとPUT Object aclは失敗
    #   * パブリックACLを含むPUT Objectは失敗
    #   * パブリックACLを含むPUT Bucketは失敗
    # - 既存のポリシーやACLには影響しません
    block_public_acls = true

    # block_public_policy - (Optional) パブリックバケットポリシーをブロックするか
    # - デフォルト: true
    # - trueの場合の動作:
    #   * パブリックアクセスを許可するPUT Bucket policyは拒否
    # - 既存のバケットポリシーには影響しません
    block_public_policy = true

    # ignore_public_acls - (Optional) パブリックACLを無視するか
    # - デフォルト: true
    # - trueの場合の動作:
    #   * このアカウントのバケットとそのオブジェクトのパブリックACLをすべて無視
    # - ACLの永続性には影響せず、新しいパブリックACLの設定も妨げません
    ignore_public_acls = true

    # restrict_public_buckets - (Optional) パブリックバケットポリシーを制限するか
    # - デフォルト: true
    # - trueの場合の動作:
    #   * バケットオーナーとAWSサービスのみがパブリックポリシーのあるバケットにアクセス可能
    # - 以前に保存されたバケットポリシーには影響しませんが、
    #   パブリックおよびクロスアカウントアクセスはブロックされます
    restrict_public_buckets = true
  }

  tags = {
    Name           = "public-block-access-point"
    Environment    = "production"
    SecurityLevel  = "High"
    PublicAccess   = "Blocked"
  }
}

# ================================================================================
# Example 4: Directory Bucket Access Point
# ================================================================================
# Directory Bucket用のアクセスポイント
# - Zone IDを含む特殊な命名規則が必要
# - 高スループット・低レイテンシーワークロード向け
# ================================================================================

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_s3_directory_bucket" "example" {
  bucket = "example-bucket--usw2-az1--x-s3"

  location {
    name = data.aws_availability_zones.available.zone_ids[0]
  }
}

resource "aws_s3_access_point" "directory_bucket" {
  bucket = aws_s3_directory_bucket.example.bucket

  # Directory Bucketアクセスポイントの命名規則: "name--zoneId--xa-s3"
  name = "example-ap--usw2-az1--xa-s3"

  tags = {
    Name        = "directory-bucket-access-point"
    Environment = "production"
    BucketType  = "Directory"
  }
}

# ================================================================================
# Computed Attributes (Output Examples)
# ================================================================================
# アクセスポイント作成後に参照可能な属性

output "access_point_alias" {
  description = "アクセスポイントのエイリアス"
  # - アクセスポイントの短縮名
  # - S3 APIでアクセスポイントを参照する際に使用可能
  value = aws_s3_access_point.example.alias
}

output "access_point_arn" {
  description = "アクセスポイントのARN"
  # - 完全修飾ARN
  # - IAMポリシーやリソースポリシーで使用
  # Example: "arn:aws:s3:region:account-id:accesspoint/access-point-name"
  value = aws_s3_access_point.example.arn
}

output "access_point_domain_name" {
  description = "アクセスポイントのDNSドメイン名"
  # - フォーマット: name-account_id.s3-accesspoint.region.amazonaws.com
  # - HTTPS経由でのみアクセス可能(HTTPは非サポート)
  # - S3 APIリクエストのエンドポイントとして使用
  value = aws_s3_access_point.example.domain_name
}

output "access_point_endpoints" {
  description = "アクセスポイントのVPCエンドポイント"
  # - VPC設定がある場合のVPCエンドポイントのマップ
  # - キー: VPC ID
  # - 値: エンドポイントURL
  value = aws_s3_access_point.vpc_restricted.endpoints
}

output "has_public_access_policy" {
  description = "パブリックアクセスを許可するポリシーの有無"
  # - true: パブリックアクセスを許可するポリシーが現在設定されている
  # - false: パブリックアクセスを許可するポリシーなし
  value = aws_s3_access_point.example.has_public_access_policy
}

output "access_point_id" {
  description = "アクセスポイントのID"
  # - AWS Partition S3 Bucketの場合: account-id:access-point-name
  # - S3 on Outpostsの場合: アクセスポイントのARN
  value = aws_s3_access_point.example.id
}

output "network_origin" {
  description = "ネットワークオリジン"
  # - "VPC": VPC設定があり、パブリックインターネットからのアクセスを許可しない
  # - "Internet": パブリックインターネットからのアクセスを許可
  #   (アクセスポイントとバケットのアクセスポリシーに従う)
  value = aws_s3_access_point.example.network_origin
}

output "tags_all" {
  description = "割り当てられた全タグ(provider default_tags含む)"
  # - リソースに割り当てられたすべてのタグのマップ
  # - provider default_tagsからの継承タグを含む
  value = aws_s3_access_point.example.tags_all
}

# ================================================================================
# Best Practices & Recommendations
# ================================================================================
# 1. セキュリティ
#    - Block Public Access設定はデフォルトで有効にする
#    - 必要な場合のみVPC制限を解除する
#    - 最小権限の原則に従ってアクセスポリシーを設定
#    - アクセスポイントポリシーとバケットポリシーを組み合わせた多層防御
#
# 2. ネットワーク
#    - VPC内からのアクセスにはvpc_configurationを使用
#    - VPCエンドポイント経由でプライベート接続を確保
#    - HTTPS通信のみサポート(HTTPは使用不可)
#
# 3. 命名規則
#    - 一貫性のある命名パターンを採用
#    - 環境、用途、チームなどを識別可能な名前
#    - Directory Bucketの場合は規定のフォーマットに従う
#
# 4. ポリシー管理
#    - インラインポリシーとスタンドアロンポリシーリソースを混在させない
#    - ポリシー削除時は "{}" を明示的に設定
#    - バケットポリシー、アクセスポイントポリシー、IAMポリシーの
#      評価順序を理解する
#
# 5. モニタリング・ログ
#    - CloudTrailでアクセスポイント経由のAPI呼び出しを記録
#    - S3サーバーアクセスログでリクエストを追跡
#    - CloudWatchメトリクスで使用状況を監視
#
# 6. タグ管理
#    - コスト配分のためのタグ付け戦略を実装
#    - 環境、所有者、プロジェクトなどの識別タグを付与
#    - provider default_tagsで共通タグを一元管理
#
# 7. マルチリージョン・フェイルオーバー
#    - Multi-Region Access Pointsで複数リージョンのレプリケーションを管理
#    - Cross-Region Replicationと組み合わせてデータの冗長性を確保
#    - フェイルオーバーコントロールでRPO/RTOを最適化
#
# 8. パフォーマンス最適化
#    - アクセスパターンに応じたアクセスポイントの配置
#    - Directory Bucketで高スループット要件に対応
#    - 適切なリージョン選択でレイテンシーを最小化
# ================================================================================

# ================================================================================
# Related Resources
# ================================================================================
# - aws_s3_bucket: アクセスポイントが接続するS3バケット
# - aws_s3control_access_point_policy: スタンドアロンのアクセスポイントポリシー
# - aws_s3control_bucket: S3 on Outpostsバケット
# - aws_s3_directory_bucket: Directory Bucket
# - aws_vpc: VPC制限アクセスポイント用のVPC
# - aws_s3_bucket_public_access_block: バケットレベルのパブリックアクセスブロック
# - aws_s3control_multi_region_access_point: マルチリージョンアクセスポイント
# ================================================================================

# ================================================================================
# Import
# ================================================================================
# 既存のアクセスポイントをインポート可能
#
# AWS Partition S3 Bucketの場合:
# terraform import aws_s3_access_point.example account-id:access-point-name
#
# S3 on Outpostsの場合:
# terraform import aws_s3_access_point.example arn:aws:s3-outposts:region:account:outpost/op-id/accesspoint/access-point-name
# ================================================================================
