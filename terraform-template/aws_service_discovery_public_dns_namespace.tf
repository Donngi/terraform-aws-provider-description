#---------------------------------------------------------------
# AWS Service Discovery Public DNS Namespace
#---------------------------------------------------------------
#
# AWS Cloud Map のパブリック DNS 名前空間をプロビジョニングするリソースです。
# パブリック DNS 名前空間はインターネット上に公開され、Route 53 のパブリック
# ホストゾーンと連携してサービスの名前解決を提供します。
# DNS クエリおよび Cloud Map API の両方でサービスインスタンスを検出できます。
#
# AWS公式ドキュメント:
#   - AWS Cloud Map 名前空間の作成: https://docs.aws.amazon.com/cloud-map/latest/dg/creating-namespaces.html
#   - CreatePublicDnsNamespace API: https://docs.aws.amazon.com/cloud-map/latest/api/API_CreatePublicDnsNamespace.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/service_discovery_public_dns_namespace
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_service_discovery_public_dns_namespace" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required, Forces new resource)
  # 設定内容: 名前空間の名前を指定します。
  # 設定可能な値: DNS 名として有効な文字列（例: hoge.example.com）
  # 注意: 名前はパブリック DNS クエリで使用されるため、機密情報を含めないこと。
  #       Amazon Route 53 のパブリックホストゾーンが自動的に作成されます。
  #   - https://docs.aws.amazon.com/cloud-map/latest/dg/creating-namespaces.html
  name = "example.com"

  # description (Optional)
  # 設定内容: 名前空間を作成する際に指定する説明文を設定します。
  # 設定可能な値: 任意の文字列
  # 省略時: 説明なし
  description = "example public DNS namespace"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理する AWS リージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 注意: CreatePublicDnsNamespace API 操作は AWS GovCloud (US) リージョンでは
  #       サポートされていません。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: 名前空間に割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルの default_tags 設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "example-public-dns-namespace"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: 名前空間の ID
#
# - arn: Amazon Route 53 が名前空間の作成時に割り当てる ARN
#
# - hosted_zone: 名前空間の作成時に Amazon Route 53 が作成する
#               ホストゾーンの ID
#
# - tags_all: プロバイダーの default_tags 設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
