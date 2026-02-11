#---------------------------------------------------------------
# VPC Peering Connection Options
#---------------------------------------------------------------
# VPCピアリング接続のオプション（DNS解決設定など）を管理するリソース
# VPCピアリング接続本体とは独立してオプションを設定でき、
# クロスリージョンやクロスアカウントのシナリオで正しくオプションを
# 設定可能にします。
#
# AWS公式ドキュメント:
# https://docs.aws.amazon.com/vpc/latest/peering/vpc-peering-dns.html
#
# Terraform Registry:
# https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/vpc_peering_connection_options
#
# Provider Version: 6.28.0
# Generated: 2026-02-09
#
# NOTE: このファイルは自動生成されたテンプレートです。
# 実際の使用前に、環境に応じた適切な値への変更と検証が必要です。
#
# IMPORTANT: このリソースとaws_vpc_peering_connectionリソースの
# accepter/requester引数を同時に使用しないでください。
# オプションの競合が発生し、設定が上書きされます。
#---------------------------------------------------------------

resource "aws_vpc_peering_connection_options" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # vpc_peering_connection_id (Required)
  # 設定内容: リクエスター側のVPCピアリング接続ID
  # 設定可能な値: 有効なVPCピアリング接続のID（pcx-で始まる）
  # 関連機能: VPC Peering Connection
  #   2つのVPC間でプライベート通信を可能にする接続
  #   https://docs.aws.amazon.com/vpc/latest/peering/what-is-vpc-peering.html
  vpc_peering_connection_id = "pcx-0123456789abcdef0"

  #-------------------------------------------------------------
  # アクセプター側オプション（受信側VPC）
  #-------------------------------------------------------------

  # accepter (Optional)
  # 設定内容: ピアリング接続のアクセプター（受信者）側のオプション設定
  # NOTE: このブロックはアクセプターVPCの所有者が設定する必要があります
  #       クロスアカウントの場合、アクセプター側のプロバイダーで
  #       別途このリソースを作成します
  accepter {
    # allow_remote_vpc_dns_resolution (Optional)
    # 設定内容: ピアVPCからクエリされた際に、ローカルVPCのパブリックDNS
    #          ホスト名をプライベートIPアドレスに解決することを許可
    # 設定可能な値: true（許可）, false（不許可）
    # 省略時: false
    # NOTE: 有効にするには両方のVPCでDNSホスト名とDNS解決が有効で、
    #       ピアリング接続がactiveステータスである必要があります
    # 関連機能: VPC DNS Resolution
    #   VPC内のDNSクエリ解決を制御
    #   https://docs.aws.amazon.com/vpc/latest/userguide/vpc-dns.html
    allow_remote_vpc_dns_resolution = true
  }

  #-------------------------------------------------------------
  # リクエスター側オプション（送信側VPC）
  #-------------------------------------------------------------

  # requester (Optional)
  # 設定内容: ピアリング接続のリクエスター（要求者）側のオプション設定
  # NOTE: このブロックはリクエスターVPCの所有者が設定する必要があります
  #       クロスアカウントの場合、リクエスター側のプロバイダーで
  #       このブロックを設定します
  requester {
    # allow_remote_vpc_dns_resolution (Optional)
    # 設定内容: ピアVPCからクエリされた際に、ローカルVPCのパブリックDNS
    #          ホスト名をプライベートIPアドレスに解決することを許可
    # 設定可能な値: true（許可）, false（不許可）
    # 省略時: false
    # NOTE: DNS解決を双方向で有効にするには、accepterとrequesterの
    #       両方でこのオプションをtrueに設定する必要があります
    allow_remote_vpc_dns_resolution = true
  }

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョン
  # 設定可能な値: 有効なAWSリージョンコード（例: "us-east-1", "ap-northeast-1"）
  # 省略時: プロバイダー設定で指定されたリージョン
  # NOTE: クロスリージョンピアリングの場合、リクエスターとアクセプターで
  #       それぞれのリージョンに対応したプロバイダーを使用します
  # 関連機能: リージョナルエンドポイント
  #   リージョン固有のリソース管理
  #   https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "ap-northeast-1"
}

#---------------------------------------------------------------
# Attributes Reference（参照専用属性）
#---------------------------------------------------------------
# 以下の属性はリソース作成後に参照可能です（設定不可）:
#
# - id: VPCピアリング接続オプションのID
#   output "peering_options_id" {
#     value = aws_vpc_peering_connection_options.example.id
#   }
#---------------------------------------------------------------

#---------------------------------------------------------------
# クロスアカウント使用例
#---------------------------------------------------------------
# クロスアカウントでVPCピアリングを行う場合の設定例:
#
# # リクエスター側（アカウントA）
# provider "aws" {
#   alias = "requester"
#   # リクエスターの認証情報
# }
#
# resource "aws_vpc_peering_connection_options" "requester" {
#   provider = aws.requester
#   vpc_peering_connection_id = aws_vpc_peering_connection_accepter.peer.id
#
#   requester {
#     allow_remote_vpc_dns_resolution = true
#   }
# }
#
# # アクセプター側（アカウントB）
# provider "aws" {
#   alias = "accepter"
#   # アクセプターの認証情報
# }
#
# resource "aws_vpc_peering_connection_options" "accepter" {
#   provider = aws.accepter
#   vpc_peering_connection_id = aws_vpc_peering_connection_accepter.peer.id
#
#   accepter {
#     allow_remote_vpc_dns_resolution = true
#   }
# }
#---------------------------------------------------------------
