################################################################################
# AWS Service Discovery HTTP Namespace
# Resource: aws_service_discovery_http_namespace
# Provider Version: 6.28.0
################################################################################
# AWS Cloud Map HTTP namespace用のリソース。
# HTTP namespacesでは、API呼び出しまたはAWS SDKを使用してサービスインスタンスを
# 検出できます。DNSクエリベースのサービス検出は使用できません。
#
# 参考: https://docs.aws.amazon.com/cloud-map/latest/dg/working-with-namespaces.html
################################################################################

resource "aws_service_discovery_http_namespace" "example" {
  #-----------------------------------------------------------------------------
  # Required Arguments
  #-----------------------------------------------------------------------------

  # name - (Required) HTTPネームスペースの名前
  # Type: string
  #
  # ネームスペース名は以下の制約があります:
  # - 1024文字以内
  # - 英数字、ハイフン(-)、アンダースコア(_)のみ使用可能
  # - 先頭と末尾は英数字である必要がある
  #
  # 例: "development", "production-api", "staging_services"
  name = "development"

  #-----------------------------------------------------------------------------
  # Optional Arguments
  #-----------------------------------------------------------------------------

  # description - (Optional) ネームスペース作成時に指定する説明
  # Type: string
  # Default: null (設定なし)
  #
  # ネームスペースの用途や目的を説明する任意のテキスト。
  # AWS Management Consoleやコメントとして表示されます。
  description = "HTTP namespace for development environment"

  # region - (Optional) このリソースを管理するAWSリージョン
  # Type: string
  # Default: プロバイダー設定で指定されたリージョン
  #
  # 通常は省略し、プロバイダー設定のリージョンを使用することを推奨します。
  # 明示的に異なるリージョンにリソースを作成する場合のみ指定してください。
  #
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-west-2"

  # tags - (Optional) ネームスペースに割り当てるタグのマップ
  # Type: map(string)
  # Default: {} (空のマップ)
  #
  # AWSリソースの整理、コスト配分、アクセス制御に使用できます。
  # プロバイダーのdefault_tagsと組み合わせて使用可能です。
  #
  # 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Environment = "Development"
    ManagedBy   = "Terraform"
    Purpose     = "Service Discovery"
  }

  #-----------------------------------------------------------------------------
  # Computed Arguments (Reference Only - Do Not Set)
  #-----------------------------------------------------------------------------
  # これらの属性は読み取り専用で、Terraformによって自動的に設定されます。
  # リソースブロックでは設定せず、他のリソースから参照する際に使用します。
  #
  # - id (string): ネームスペースのID
  #   使用例: aws_service_discovery_http_namespace.example.id
  #
  # - arn (string): Amazon Route 53がネームスペース作成時に割り当てるARN
  #   使用例: aws_service_discovery_http_namespace.example.arn
  #   形式: arn:aws:servicediscovery:region:account-id:namespace/namespace-id
  #
  # - http_name (string): HTTPネームスペースの名前（nameと同じ値）
  #   使用例: aws_service_discovery_http_namespace.example.http_name
  #
  # - tags_all (map(string)): リソースに割り当てられたすべてのタグ
  #   プロバイダーのdefault_tagsから継承されたタグを含みます
  #   使用例: aws_service_discovery_http_namespace.example.tags_all
}

################################################################################
# Outputs (参照用の出力例)
################################################################################

output "http_namespace_id" {
  description = "HTTPネームスペースのID"
  value       = aws_service_discovery_http_namespace.example.id
}

output "http_namespace_arn" {
  description = "HTTPネームスペースのARN"
  value       = aws_service_discovery_http_namespace.example.arn
}

output "http_namespace_name" {
  description = "HTTPネームスペースの名前"
  value       = aws_service_discovery_http_namespace.example.http_name
}

################################################################################
# 使用例とベストプラクティス
################################################################################
#
# 1. HTTPネームスペースの用途:
#    - RESTful APIやgRPCベースのサービス検出
#    - AWS SDKまたはAPI呼び出しを使用したサービスインスタンスの検出
#    - DNSクエリを使用しないサービス検出パターン
#
# 2. 関連リソース:
#    - aws_service_discovery_service: HTTPネームスペース内のサービス定義
#    - aws_service_discovery_instance: サービスインスタンスの登録
#
# 3. セキュリティ考慮事項:
#    - IAMポリシーでCloud Map APIへのアクセスを制御
#    - タグベースのアクセス制御(TBAC)を活用
#
# 4. コスト最適化:
#    - HTTPネームスペース自体に課金はありません
#    - サービスインスタンスの登録数とAPIコール数で課金されます
#
# 5. 削除時の注意:
#    - ネームスペースを削除する前に、すべてのサービスとインスタンスを
#      削除する必要があります
#
################################################################################
