#---------------------------------------------------------------
# AWS WAFv2 Web ACL Association
#---------------------------------------------------------------
#
# AWS WAFv2 Web ACLをAWSリソースに関連付けるためのリソースです。
# Web ACLをApplication Load Balancer、API Gateway REST APIステージ、
# Amazon Cognito User Pool、AppSync GraphQL API、App Runnerサービス、
# Amazon Verified Accessインスタンスに関連付けることで、これらのリソースへの
# リクエストをWAFルールで保護できます。
#
# AWS公式ドキュメント:
#   - AWS WAF Web ACLとリソースの関連付け: https://docs.aws.amazon.com/waf/latest/developerguide/web-acl-associating-aws-resource.html
#   - AssociateWebACL API: https://docs.aws.amazon.com/waf/latest/APIReference/API_AssociateWebACL.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl_association
#
# Provider Version: 6.28.0
# Generated: 2026-02-06
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_wafv2_web_acl_association" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # resource_arn (Required)
  # 設定内容: Web ACLを関連付けるAWSリソースのARNを指定します。
  # 設定可能な値:
  #   - Application Load BalancerのARN
  #   - API Gateway REST APIステージのARN（HTTP APIは非対応）
  #   - Amazon Cognito User PoolのARN
  #   - Amazon AppSync GraphQL APIのARN
  #   - Amazon App RunnerサービスのARN
  #   - Amazon Verified AccessインスタンスのARN
  # 注意: CloudFrontディストリビューションへの関連付けには、このリソースを
  #       使用しないでください。代わりに、aws_cloudfront_distribution
  #       リソースのweb_acl_id属性を使用してください。
  # 参考: https://docs.aws.amazon.com/waf/latest/APIReference/API_AssociateWebACL.html
  resource_arn = "arn:aws:elasticloadbalancing:ap-northeast-1:123456789012:loadbalancer/app/my-alb/1234567890123456"

  # web_acl_arn (Required)
  # 設定内容: リソースに関連付けるWeb ACLのARNを指定します。
  # 設定可能な値: 有効なWAFv2 Web ACLのARN
  # 注意: スコープがREGIONALのWeb ACLのみ指定可能です。
  #       CloudFrontスコープのWeb ACLは使用できません。
  web_acl_arn = "arn:aws:wafv2:ap-northeast-1:123456789012:regional/webacl/my-web-acl/12345678-1234-1234-1234-123456789012"

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

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定します。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "5m", "10m", "1h"）
    # 省略時: デフォルトのタイムアウト時間を使用
    # 注意: ALBなど一部のリソースでは関連付けに時間がかかる場合があります。
    create = "5m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: resource_arnとweb_acl_arnをカンマで連結した値
#       （例: "arn:aws:elasticloadbalancing:...,arn:aws:wafv2:..."）
#
#---------------------------------------------------------------
