#---------------------------------------------------------------
# Route 53 Resolver Query Log Config Association
#---------------------------------------------------------------
#
# Route 53 ResolverのクエリログDNS設定とVPCの関連付けを管理するリソースです。
# 指定したResolver クエリログ設定を特定のVPCに紐付け、そのVPCで発生する
# すべてのDNSクエリをログに記録できるようにします。
# ログの送信先はCloudWatch Logs、S3、Kinesis Data Firehoseから選択可能です。
#
# AWS公式ドキュメント:
#   - Route 53 Resolver Query Logging: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resolver-query-logs.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_resolver_query_log_config_association
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_route53_resolver_query_log_config_association" "example" {
  #-------------------------------------------------------------
  # クエリログ設定とVPCの関連付け
  #-------------------------------------------------------------

  # resolver_query_log_config_id (Required)
  # 設定内容: VPCに関連付けるRoute 53 Resolverクエリログ設定のIDを指定します。
  # 設定可能な値: 既存のaws_route53_resolver_query_log_configリソースのID
  # 補足: 関連付けを行うことで、そのVPCで実行されるDNSクエリがすべてログ対象となります。
  resolver_query_log_config_id = aws_route53_resolver_query_log_config.example.id

  # resource_id (Required)
  # 設定内容: クエリをログ記録したいVPCのIDを指定します。
  # 設定可能な値: 既存VPCのID（例: "vpc-0123456789abcdef0"）
  # 補足: 同じVPCに複数のクエリログ設定を関連付けることはできません。
  #   1つのVPCに対し、関連付けできるクエリログ設定は1つのみです。
  resource_id = aws_vpc.example.id

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: Route 53 Resolverクエリログ設定の関連付けID
#---------------------------------------------------------------
