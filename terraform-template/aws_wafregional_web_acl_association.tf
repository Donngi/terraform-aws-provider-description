#---------------------------------------------------------------
# AWS WAF Regional Web ACL Association
#---------------------------------------------------------------
#
# AWS WAF Classic (Regional) のWeb ACLをAWSリソースに関連付けるための
# リソースです。Application Load Balancer (ALB) またはAmazon API Gateway
# ステージにWeb ACLを関連付けることで、WAFルールによるトラフィック制御を
# 適用できます。
#
# 注意: AWS WAF Classicは廃止予定のサービスです。新規構築では
#       AWS WAFv2 (aws_wafv2_web_acl_association) の使用を推奨します。
#
# AWS公式ドキュメント:
#   - AssociateWebACL API: https://docs.aws.amazon.com/waf/latest/APIReference/API_wafRegional_AssociateWebACL.html
#   - Web ACLの関連付け・解除: https://docs.aws.amazon.com/waf/latest/developerguide/classic-web-acl-associating-cloudfront-distribution.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafregional_web_acl_association
#
# Provider Version: 6.28.0
# Generated: 2026-02-06
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_wafregional_web_acl_association" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # resource_arn (Required)
  # 設定内容: WAF Web ACLで保護する対象リソースのARNを指定します。
  # 設定可能な値:
  #   - Application Load BalancerのARN:
  #     arn:aws:elasticloadbalancing:region:account-id:loadbalancer/app/load-balancer-name/load-balancer-id
  #   - Amazon API GatewayステージのARN:
  #     arn:aws:apigateway:region::/restapis/api-id/stages/stage-name
  # 注意: 各Application Load Balancerには1つのWAF Regional Web ACLのみ
  #       関連付けることができます。
  # 参考: https://docs.aws.amazon.com/waf/latest/APIReference/API_wafRegional_AssociateWebACL.html
  resource_arn = "arn:aws:elasticloadbalancing:ap-northeast-1:123456789012:loadbalancer/app/my-alb/1234567890123456"

  # web_acl_id (Required)
  # 設定内容: 関連付けるWAF Regional Web ACLのIDを指定します。
  # 設定可能な値: 有効なWAF Regional Web ACLのID（1〜128文字）
  # 注意: AWS WAF Classic Regional用です。AWS WAFv2の場合は
  #       aws_wafv2_web_acl_associationリソースを使用してください。
  # 参考: https://docs.aws.amazon.com/waf/latest/APIReference/API_wafRegional_AssociateWebACL.html
  web_acl_id = "a1b2c3d4-5678-90ab-cdef-EXAMPLE11111"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "10m", "30s"）
    # 省略時: デフォルトのタイムアウト時間が適用されます。
    create = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: Web ACL関連付けのID
#---------------------------------------------------------------
