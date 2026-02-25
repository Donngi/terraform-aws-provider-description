#---------------------------------------------------------------
# AWS Route53 Reusable Delegation Set
#---------------------------------------------------------------
#
# Amazon Route 53の再利用可能なデリゲーションセットをプロビジョニングするリソースです。
# 再利用可能なデリゲーションセットとは、同一AWSアカウントが作成した複数のホストゾーンで
# 共有して使用できる4つのネームサーバーのグループです。
# これにより、ドメインレジストラに登録するネームサーバーを統一できます。
#
# AWS公式ドキュメント:
#   - Route53 再利用可能デリゲーションセット概要: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/hosted-zone-public-considerations.html
#   - CreateReusableDelegationSet API: https://docs.aws.amazon.com/Route53/latest/APIReference/API_CreateReusableDelegationSet.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_delegation_set
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_route53_delegation_set" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # reference_name (Optional)
  # 設定内容: デリゲーションセットを識別するための参照名を指定します。
  #           CallerReference（重複リクエスト防止用の一意識別子）として内部的に使用されます。
  # 設定可能な値: 任意の文字列
  # 省略時: 参照名なしでデリゲーションセットが作成されます。
  # 用途: 複数のデリゲーションセットを管理する際に識別しやすくするために使用します。
  reference_name = "MyDelegationSet"
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: デリゲーションセットのID
#
# - arn: デリゲーションセットのAmazon Resource Name (ARN)
#
# - name_servers: ホストゾーンに対する権威ネームサーバーのリスト
#                 (NSレコードの一覧に相当する4つのネームサーバーアドレス)
#---------------------------------------------------------------
