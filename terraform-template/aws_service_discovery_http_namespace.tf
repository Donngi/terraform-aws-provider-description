#---------------------------------------------------------------
# AWS Cloud Map HTTP Namespace
#---------------------------------------------------------------
#
# AWS Cloud MapのHTTPネームスペースをプロビジョニングするリソースです。
# HTTPネームスペースでは、DiscoverInstances APIコールを使用してサービスインスタンスを
# 検索できますが、DNSクエリによる検索はサポートしていません。
# マイクロサービスアーキテクチャでサービスのロケーション情報を管理する際に使用します。
#
# AWS公式ドキュメント:
#   - AWS Cloud Map HTTPネームスペースの作成: https://docs.aws.amazon.com/cloud-map/latest/dg/creating-namespaces.html
#   - AWS Cloud Map ネームスペースの概念: https://docs.aws.amazon.com/cloud-map/latest/dg/working-with-namespaces.html
#   - CreateHttpNamespace API: https://docs.aws.amazon.com/cloud-map/latest/api/API_CreateHttpNamespace.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/service_discovery_http_namespace
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_service_discovery_http_namespace" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required, Forces new resource)
  # 設定内容: HTTPネームスペースの名前を指定します。
  # 設定可能な値: 1〜1024文字の文字列（使用可能文字: !〜~、パターン: ^[!-~]{1,1024}$）
  # 注意: 同一リージョン内で一意である必要があります。作成後は変更できません。
  name = "my-application"

  # description (Optional)
  # 設定内容: ネームスペースに付与する説明文を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: 説明なしで作成されます。
  description = "My application HTTP namespace"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなしで作成されます。
  # 注意: プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "my-application"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: ネームスペースのID
#
# - arn: Amazon Route 53がネームスペース作成時に割り当てるARN
#
# - http_name: HTTPネームスペースの名前
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
