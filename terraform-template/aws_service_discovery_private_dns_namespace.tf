#---------------------------------------------------------------
# AWS Cloud Map Service Discovery Private DNS Namespace
#---------------------------------------------------------------
#
# AWS Cloud Mapのプライベートな DNS 名前空間をプロビジョニングするリソースです。
# プライベート DNS 名前空間は、指定した VPC 内でのみ有効な Route 53 プライベートホストゾーンを
# 自動的に作成し、VPC 内のサービスを DNS クエリまたは AWS Cloud Map API 呼び出しで
# ディスカバリ可能にします。
#
# AWS公式ドキュメント:
#   - AWS Cloud Map 名前空間の作成: https://docs.aws.amazon.com/cloud-map/latest/dg/creating-namespaces.html
#   - AWS Cloud Map 名前空間の概要: https://docs.aws.amazon.com/cloud-map/latest/dg/working-with-namespaces.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/service_discovery_private_dns_namespace
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_service_discovery_private_dns_namespace" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: 名前空間の名前を指定します。
  # 設定可能な値: DNS 互換の文字列（例: "example.local"、"hoge.example.local"）
  # 注意: 同一 VPC 内で一意の名前を指定してください。
  #       作成後に変更するにはリソースの再作成が必要です（Forces new resource）。
  name = "example.local"

  # vpc (Required)
  # 設定内容: 名前空間を関連付ける VPC の ID を指定します。
  # 設定可能な値: 有効な VPC ID（例: "vpc-12345678"）
  # 注意: 作成後に変更するにはリソースの再作成が必要です（Forces new resource）。
  #       対象 VPC の DNS 解決（enableDnsSupport）と DNS ホスト名（enableDnsHostnames）が
  #       有効になっている必要があります。
  vpc = "vpc-12345678"

  #-------------------------------------------------------------
  # 説明設定
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: 名前空間の説明を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: 説明なし
  description = "example private DNS namespace"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルの default_tags 設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-private-dns-namespace"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: 名前空間の ID
# - arn: Amazon Route 53 が名前空間作成時に割り当てる ARN
# - hosted_zone: AWS Cloud Map が名前空間作成時に作成する Route 53 プライベートホストゾーンの ID
# - tags_all: プロバイダーの default_tags 設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
