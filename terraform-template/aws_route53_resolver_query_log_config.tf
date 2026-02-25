#---------------------------------------------------------------
# Route 53 Resolver Query Log Config
#---------------------------------------------------------------
#
# Amazon Route 53 ResolverのDNSクエリログ設定を管理するリソースです。
# VPCを対象とするResolver クエリログ設定を作成し、DNSクエリの
# 詳細ログをS3バケット、CloudWatch Logsロググループ、または
# Kinesis Data Firehoseデリバリーストリームに送信することができます。
# セキュリティ調査、トラブルシューティング、コンプライアンス要件への
# 対応などに活用できます。
#
# AWS公式ドキュメント:
#   - Route 53 Resolver クエリログ: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resolver-query-logs.html
#   - ログ設定の作成: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resolver-query-logs-creating.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_resolver_query_log_config
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_route53_resolver_query_log_config" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: Route 53 Resolverクエリログ設定の名前を指定します。
  # 設定可能な値: 任意の文字列（例: "my-query-log-config"）
  # 省略時: このフィールドは必須のため省略不可
  name = "example"

  # destination_arn (Required)
  # 設定内容: クエリログの送信先リソースのARNを指定します。
  # 設定可能な値:
  #   - S3バケットのARN          : "arn:aws:s3:::my-bucket"
  #   - CloudWatch Logsロググループ: "arn:aws:logs:us-east-1:123456789012:log-group:/aws/route53/..."
  #   - Kinesis Data Firehose    : "arn:aws:firehose:us-east-1:123456789012:deliverystream/my-stream"
  # 省略時: このフィールドは必須のため省略不可
  # 補足: 各送信先に適切なIAMアクセス権限が必要です。
  #   - https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resolver-query-logs-creating.html
  destination_arn = aws_s3_bucket.example.arn

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに付与するタグのマップを指定します。
  # 設定可能な値: キーと値がともに文字列のマップ
  # 省略時: タグなし
  # 補足: プロバイダーレベルで default_tags が設定されている場合、
  #   同一キーのタグはプロバイダー設定で上書きされます。
  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
  }

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
# - id          : Route 53 Resolverクエリログ設定のID
#
# - arn         : クエリログ設定のARN（Amazon Resource Name）
#
# - owner_id    : クエリログ設定を作成したAWSアカウントのID
#
# - share_status: 設定が他のAWSアカウントと共有されているかの状態
#                 "NOT_SHARED"、"SHARED_BY_ME"、"SHARED_WITH_ME" のいずれか
#                 （AWS RAMを通じた共有状態を示す）
#
# - tags_all    : プロバイダーの default_tags を含む全タグのマップ
#---------------------------------------------------------------
