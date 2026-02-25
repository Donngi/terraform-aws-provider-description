#-----------------------------------------------------------------------
# AWS VPC Peering Connection Options
#-----------------------------------------------------------------------
#
# VPCピアリング接続のオプション設定を管理するリソースです。
# 既存のVPCピアリング接続に対して、リクエスター側およびアクセプター側の
# DNS解決オプションなどを設定します。
# aws_vpc_peering_connectionまたはaws_vpc_peering_connection_accepterと
# 組み合わせて使用し、ピアリング接続のオプションを細かく制御するために使います。
#
# AWS公式ドキュメント:
#   - VPCピアリングとは: https://docs.aws.amazon.com/vpc/latest/peering/what-is-vpc-peering.html
#   - ピアリング接続オプションの変更: https://docs.aws.amazon.com/vpc/latest/peering/modify-peering-connections.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection_options
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
#
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#-----------------------------------------------------------------------

resource "aws_vpc_peering_connection_options" "example" {
  #-----------------------------------------------------------------------
  # ピアリング接続の識別
  #-----------------------------------------------------------------------

  # 設定内容: オプションを設定する対象のVPCピアリング接続ID
  # 設定可能な値: 有効なVPCピアリング接続ID（例: pcx-xxxxxxxxxxxxxxxxx）
  # 省略時: 設定必須のため省略不可
  # 備考: aws_vpc_peering_connectionリソースのidから参照するか、直接IDを指定する
  vpc_peering_connection_id = aws_vpc_peering_connection.example.id

  #-----------------------------------------------------------------------
  # リージョン設定
  #-----------------------------------------------------------------------

  # 設定内容: このリソースを管理するAWSリージョン
  # 設定可能な値: AWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダーで設定されたリージョンが使用される
  # 備考: Provider v6以降では、provider aliasの代わりにこの属性でリージョンを指定できる
  region = null

  #-----------------------------------------------------------------------
  # アクセプター側ピアリングオプション
  #-----------------------------------------------------------------------

  # 設定内容: アクセプター（受け入れ側）VPCのピアリング接続オプション
  # 省略時: デフォルトオプションが使用される
  accepter {
    # 設定内容: リモートVPC（ピアVPC）のパブリックDNSホスト名をプライベートIPアドレスに解決することを許可するかどうか
    # 設定可能な値: true（許可）/ false（不許可）
    # 省略時: false
    # 備考: 有効にするには両側のVPCでenableDnsHostnamesとenableDnsSupportがtrueである必要がある
    allow_remote_vpc_dns_resolution = true
  }

  #-----------------------------------------------------------------------
  # リクエスター側ピアリングオプション
  #-----------------------------------------------------------------------

  # 設定内容: リクエスター（送信側）VPCのピアリング接続オプション
  # 省略時: デフォルトオプションが使用される
  requester {
    # 設定内容: リモートVPC（ピアVPC）のパブリックDNSホスト名をプライベートIPアドレスに解決することを許可するかどうか
    # 設定可能な値: true（許可）/ false（不許可）
    # 省略時: false
    # 備考: 有効にするには両側のVPCでenableDnsHostnamesとenableDnsSupportがtrueである必要がある
    allow_remote_vpc_dns_resolution = true
  }
}

#-----------------------------------------------------------------------
# Attributes Reference
#-----------------------------------------------------------------------
# このリソースが公開する属性の参照方法
#
# - id: VPCピアリング接続オプションのID（vpc_peering_connection_idと同じ値）
#   aws_vpc_peering_connection_options.example.id
#
#-----------------------------------------------------------------------
