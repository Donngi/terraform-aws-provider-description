#---------------------------------------
# CloudFront VPCオリジン (aws_cloudfront_vpc_origin)
#---------------------------------------
# CloudFront VPCオリジンはVPC内のリソースをCloudFrontのオリジンとして構成できます。
# VPC内のALB、NLB、EC2インスタンスなどをCloudFrontのコンテンツソースとして使用でき、
# VPC内リソースへのセキュアなアクセスを提供します。
#
# 主な用途:
# - VPC内のロードバランサーをCloudFrontのオリジンとして使用
# - プライベートサブネット内のリソースへのグローバル配信
# - VPCエンドポイント経由でのセキュアなコンテンツ配信
# - VPC内のアプリケーションとCloudFrontの統合
#
# 制限事項:
# - VPCオリジンエンドポイント設定が必須
# - 特定のAWSリージョンでのみサポート
# - VPCエンドポイントサービスの事前設定が必要
#
# Provider Version: 6.28.0
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/cloudfront_vpc_origin
# Generated: 2026-02-12
#
# NOTE:
# - VPCエンドポイントサービスの事前作成が必要です
# - https-onlyプロトコルポリシー使用時はorigin_ssl_protocolsの設定が必須です
# - 複数のVPCオリジンエンドポイントを設定できます
# - タグは後から変更可能です
#---------------------------------------

#---------------------------------------
# VPCオリジンエンドポイント設定
#---------------------------------------
# CloudFrontからVPC内リソースへのアクセスを制御するエンドポイント設定です。
# VPCエンドポイントサービスのARN、プロトコル、ポート、SSL設定を定義します。

resource "aws_cloudfront_vpc_origin" "example" {
  #---------------------------------------
  # VPCオリジンエンドポイント設定
  #---------------------------------------
  vpc_origin_endpoint_config {
    # 設定内容: VPCエンドポイントサービスのARN
    # 形式: arn:aws:ec2:region:account-id:vpc-endpoint-service/vpce-svc-xxxxx
    # 注意: VPCエンドポイントサービスが事前に作成されている必要があります
    arn = "arn:aws:ec2:us-east-1:123456789012:vpc-endpoint-service/vpce-svc-1234567890abcdef0"

    # 設定内容: VPCエンドポイントのわかりやすい名前
    # 用途: CloudFrontコンソールやAPIでの識別に使用
    # 注意: 一意である必要があります
    name = "my-vpc-origin-endpoint"

    # 設定内容: HTTPポート番号
    # 設定可能な値: 1-65535
    # 推奨値: 80（標準HTTP）
    http_port = 80

    # 設定内容: HTTPSポート番号
    # 設定可能な値: 1-65535
    # 推奨値: 443（標準HTTPS）
    https_port = 443

    # 設定内容: CloudFrontがVPCオリジンと通信する際のプロトコルポリシー
    # 設定可能な値:
    # - "http-only"   = HTTP接続のみを使用
    # - "https-only"  = HTTPS接続のみを使用（推奨）
    # - "match-viewer" = ビューアーとの接続プロトコルと同じものを使用
    # 推奨値: セキュリティのため"https-only"を推奨
    origin_protocol_policy = "https-only"

    # オリジンSSLプロトコル設定（https-only使用時に必須）
    origin_ssl_protocols {
      # 設定内容: 許可するSSL/TLSプロトコルのリスト
      # 設定可能な値: "TLSv1", "TLSv1.1", "TLSv1.2", "SSLv3"
      # 推奨値: セキュリティのため["TLSv1.2"]を推奨
      # 注意: SSLv3とTLSv1は非推奨のため使用を避けてください
      items = ["TLSv1.2"]

      # 設定内容: プロトコルの数量
      # 注意: itemsの要素数と一致する必要があります
      quantity = 1
    }
  }

  #---------------------------------------
  # タグ設定
  #---------------------------------------
  # リソース管理用のタグを設定できます。

  tags = {
    Name        = "my-vpc-origin"
    Environment = "production"
    Service     = "cloudfront"
    ManagedBy   = "terraform"
  }

  #---------------------------------------
  # タイムアウト設定
  #---------------------------------------
  # リソース操作のタイムアウト時間を設定できます。

  # timeouts {
  #   # 設定内容: リソース作成時のタイムアウト時間
  #   # 形式: "30s", "5m", "1h"など
  #   # 省略時: デフォルトのタイムアウト時間が適用されます
  #   create = "30m"
  #
  #   # 設定内容: リソース更新時のタイムアウト時間
  #   # 形式: "30s", "5m", "1h"など
  #   # 省略時: デフォルトのタイムアウト時間が適用されます
  #   update = "30m"
  #
  #   # 設定内容: リソース削除時のタイムアウト時間
  #   # 形式: "30s", "5m", "1h"など
  #   # 省略時: デフォルトのタイムアウト時間が適用されます
  #   delete = "30m"
  # }
}

#---------------------------------------
# 出力値 (Attributes Reference)
#---------------------------------------
# このリソースでは以下の属性が参照可能です:
#
# - id      = VPCオリジンのID
# - arn     = VPCオリジンのARN（例: arn:aws:cloudfront::123456789012:vpc-origin/xxxxx）
# - etag    = リソースのバージョン識別子（更新時に使用）
# - tags_all = デフォルトタグとリソース固有タグをマージしたすべてのタグ
#
# 参照例:
# - aws_cloudfront_vpc_origin.example.id
# - aws_cloudfront_vpc_origin.example.arn
#---------------------------------------
