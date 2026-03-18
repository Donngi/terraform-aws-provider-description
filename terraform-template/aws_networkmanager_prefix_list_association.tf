#---------------------------------------------------------------
# AWS Network Manager Prefix List Association
#---------------------------------------------------------------
#
# EC2マネージドプレフィックスリストをCloud WANコアネットワークに関連付けるリソースです。
# 関連付けることで、コアネットワークポリシードキュメント内でプレフィックスリストを
# エイリアスで参照できるようになり、ルーティングポリシーやセグメント共有ポリシーで
# CIDRブロックの集合を簡潔に指定できます。
#
# 重要: プレフィックスリストはCloud WANホームリージョン（us-west-2）で定義する
# 必要があります。ホームリージョンで定義されたプレフィックスリストベースのポリシーは、
# コアネットワーク内の全エッジ（リージョン）にグローバルに適用されます。
#
# AWS公式ドキュメント:
#   - AWS Cloud WAN: https://docs.aws.amazon.com/vpc/latest/cloudwan/what-is-cloudwan.html
#   - Cloud WANホームリージョン: https://docs.aws.amazon.com/network-manager/latest/cloudwan/what-is-cloudwan.html#cloudwan-home-region
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkmanager_prefix_list_association
#
# Provider Version: 6.36.0
# Generated: 2026-03-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_networkmanager_prefix_list_association" "example" {
  #-------------------------------------------------------------
  # コアネットワーク設定
  #-------------------------------------------------------------

  # core_network_id (Required, Forces new resource)
  # 設定内容: プレフィックスリストを関連付けるCloud WANコアネットワークのIDを指定します。
  # 設定可能な値: 有効なコアネットワークID
  # 関連機能: AWS Cloud WAN Core Network
  #   Cloud WANのグローバルネットワークの中心となるバックボーン。
  #   複数リージョンにまたがるネットワークを統合管理します。
  #   - https://docs.aws.amazon.com/vpc/latest/cloudwan/cloudwan-core-networks.html
  core_network_id = "core-network-0123456789abcdef0"

  #-------------------------------------------------------------
  # プレフィックスリスト設定
  #-------------------------------------------------------------

  # prefix_list_arn (Required, Forces new resource)
  # 設定内容: コアネットワークに関連付けるEC2マネージドプレフィックスリストのARNを指定します。
  # 設定可能な値: 有効なEC2マネージドプレフィックスリストのARN
  # 関連機能: EC2 Managed Prefix List
  #   CIDRブロックのセットを管理するリソース。セキュリティグループやルートテーブルで
  #   再利用可能なIP範囲の集合を定義できます。Cloud WANホームリージョン（us-west-2）で
  #   作成する必要があります。
  #   - https://docs.aws.amazon.com/vpc/latest/userguide/managed-prefix-lists.html
  prefix_list_arn = "arn:aws:ec2:us-west-2:123456789012:prefix-list/pl-0123456789abcdef0"

  # prefix_list_alias (Required, Forces new resource)
  # 設定内容: プレフィックスリスト関連付けのエイリアスを指定します。
  #   このエイリアスはコアネットワークポリシードキュメント内でプレフィックスリストを
  #   参照するために使用します。
  # 設定可能な値: 英字で始まる64文字未満の英数字文字列
  # 制約: 英字で始まる必要があり、英字と数字のみ使用可能
  prefix_list_alias = "exampleprefixlist"
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - core_network_id: 関連付けられたコアネットワークのID
# - prefix_list_arn: 関連付けられたプレフィックスリストのARN
# - prefix_list_alias: プレフィックスリストのエイリアス名
#---------------------------------------------------------------
