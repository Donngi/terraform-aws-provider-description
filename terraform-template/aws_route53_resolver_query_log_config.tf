#---------------------------------------------------------------
# Route 53 Resolver Query Logging Configuration
#---------------------------------------------------------------
#
# Route 53 Resolverクエリロギング設定をプロビジョニングするリソースです。
# VPC内のリソースから発信されたDNSクエリを記録し、Amazon S3、
# Amazon CloudWatch Logs、Amazon Kinesis Data Firehoseに送信できます。
#
# このリソースはロギング設定を定義するのみです。VPCと関連付けるには、
# aws_route53_resolver_query_log_config_associationリソースが別途必要です。
#
# AWS公式ドキュメント:
#   - Resolver Query Logging概要: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resolver-query-logs.html
#   - クエリログの送信先選択: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resolver-query-logs-choosing-target-resource.html
#   - クエリログ設定の管理: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resolver-query-logging-configurations-managing.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_resolver_query_log_config
#
# Provider Version: 6.28.0
# Generated: 2026-02-03
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
  # 設定内容: Route 53 Resolverクエリロギング設定の名前を指定します。
  # 設定可能な値: 1〜64文字の英数字、ハイフン、アンダースコア
  # 注意: この名前はAWSコンソールやAPIで表示され、設定を識別するために使用されます
  name = "example-query-log-config"

  # destination_arn (Required)
  # 設定内容: Route 53 Resolverがクエリログを送信するAWSリソースのARNを指定します。
  # 設定可能な値:
  #   - S3バケットのARN: arn:aws:s3:::bucket-name
  #   - CloudWatch LogsロググループのARN: arn:aws:logs:region:account-id:log-group:log-group-name
  #   - Kinesis Data FirehoseデリバリーストリームのARN: arn:aws:firehose:region:account-id:deliverystream/stream-name
  # 注意:
  #   - 送信先リソースは事前に作成されている必要があります
  #   - S3バケットを使用する場合、適切なバケットポリシーで
  #     Route 53 Resolverログ配信アカウント（各リージョンで異なる）からの
  #     書き込みアクセスを許可する必要があります
  #   - CloudWatch Logsを使用する場合、リソースポリシーで
  #     Route 53 Resolverからのログ配信を許可する必要があります
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 注意: クエリログ設定とVPCは同じリージョンに存在する必要があります
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: Route 53 Resolverクエリロギング設定のID
#
# - arn: Route 53 Resolverクエリロギング設定の
#        Amazon Resource Name (ARN)
#
# - owner_id: クエリロギング設定を作成したアカウントのAWSアカウントID
#
# - share_status: クエリロギング設定が他のAWSアカウントと共有されているか、
#                または別のアカウントから現在のアカウントと共有されているかを示す値
#                共有はAWS Resource Access Manager (AWS RAM)を通じて設定されます
#                取りうる値:
#                  - "NOT_SHARED": 共有されていない
#                  - "SHARED_BY_ME": 現在のアカウントが他のアカウントと共有している
#                  - "SHARED_WITH_ME": 別のアカウントから現在のアカウントと共有されている
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------

#---------------------------------------------------------------
#---------------------------------------------------------------
