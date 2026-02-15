#-----------------------------------------------
# AWS EC2 Transit Gateway Peering Attachment Accepter
#-----------------------------------------------
# 用途: 他のAWSアカウントまたはリージョンから送信されたTransit Gatewayピアリングアタッチメントリクエストを受け入れる
# 補足: このリソースは受信側で使用し、送信側では aws_ec2_transit_gateway_peering_attachment を使用する
# 制約事項: アタッチメントの承認は送信後24時間以内に行う必要がある
#
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/ec2_transit_gateway_peering_attachment_accepter
# AWS Provider Version: 6.28.0
# Generated: 2026-02-15
#
# NOTE: このリソースはTransit Gatewayピアリング接続の受信側で使用します
#-----------------------------------------------

#-----------------------------------------------
# 基本設定
#-----------------------------------------------

resource "aws_ec2_transit_gateway_peering_attachment_accepter" "example" {
  # 設定内容: 受け入れるTransit GatewayピアリングアタッチメントのID
  # 補足: 送信側で作成された aws_ec2_transit_gateway_peering_attachment のIDを指定する
  transit_gateway_attachment_id = "tgw-attach-0123456789abcdef0"

  #-----------------------------------------------
  # タグ設定
  #-----------------------------------------------

  # 設定内容: ピアリングアタッチメント受信側に付与するタグ
  # 補足: 送信側のタグとは独立して管理される
  tags = {
    Name        = "example-tgw-peering-accepter"
    Environment = "production"
    ManagedBy   = "terraform"
  }

  #-----------------------------------------------
  # リージョン設定
  #-----------------------------------------------

  # 設定内容: このリソースが管理されるAWSリージョン
  # 省略時: プロバイダー設定のリージョンが使用される
  region = "us-west-2"
}

#-----------------------------------------------
# Attributes Reference（参照可能な属性）
#-----------------------------------------------
# 以下の属性は、リソース作成後に参照可能です:
#
# id                        - Transit Gatewayアタッチメントのリソース識別子（transit_gateway_attachment_idと同じ）
# peer_account_id          - ピアリング送信側のAWSアカウントID
# peer_region              - ピアリング送信側のAWSリージョン
# peer_transit_gateway_id  - ピアリング送信側のTransit Gateway ID
# transit_gateway_id       - 受信側のTransit Gateway ID
# region                   - このリソースが管理されるリージョン（プロバイダーのリージョン設定がデフォルト）
# tags_all                 - デフォルトタグを含む全てのタグ
#
# 参照方法:
# aws_ec2_transit_gateway_peering_attachment_accepter.example.peer_account_id
