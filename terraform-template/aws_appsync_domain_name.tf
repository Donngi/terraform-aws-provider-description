#---------------------------------------------------------------
# AWS AppSync Domain Name
#---------------------------------------------------------------
#
# AWS AppSyncのカスタムドメイン名を設定するリソースです。
# カスタムドメインを使用することで、AppSync APIに独自のドメイン名で
# アクセスできるようになります。
#
# AWS公式ドキュメント:
#   - AppSync カスタムドメイン名: https://docs.aws.amazon.com/appsync/latest/devguide/custom-domain-name.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appsync_domain_name
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_appsync_domain_name" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # domain_name (Required)
  # 設定内容: AppSync APIに使用するカスタムドメイン名を指定します。
  # 設定可能な値: 有効なドメイン名（例: api.example.com）
  # 注意: Route 53やその他のDNSプロバイダーでDNSレコードの設定が必要です。
  domain_name = "api.example.com"

  # certificate_arn (Required)
  # 設定内容: ドメイン名に関連付けるSSL/TLS証明書のARNを指定します。
  # 設定可能な値: ACM (AWS Certificate Manager) 証明書またはIAMサーバー証明書のARN
  # 注意: 証明書は必ず us-east-1 リージョンに存在する必要があります。
  certificate_arn = "arn:aws:acm:us-east-1:123456789012:certificate/12345678-1234-1234-1234-123456789012"

  #-------------------------------------------------------------
  # オプション設定
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: ドメイン名の説明を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: 説明なし
  description = "Custom domain for my AppSync API"

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: AppSyncドメイン名（domain_nameと同値）
#
# - appsync_domain_name: AppSyncが提供するドメイン名
#        Route 53などでCNAMEレコードを作成する際のターゲットとして使用します。
#
# - hosted_zone_id: Amazon Route 53ホストゾーンのID
#        Route 53エイリアスレコードを作成する際に使用します。
#---------------------------------------------------------------
