#---------------------------------------------------------------
# Route 53 Resolver Config
#---------------------------------------------------------------
#
# Amazon Route 53 ResolverのDNS設定（リバースDNS自動定義ルール）を管理するリソースです。
# 指定したVPCに対して、Resolverがリバースルックアップ用の自動定義ルールを作成するか否かを
# 制御します。デフォルトでは、ResolverはRFC 1918プライベートアドレス空間に対して
# リバースDNSクエリを処理するための自動定義ルールを作成します。
# このリソースでその動作を無効化することが可能です。
#
# AWS公式ドキュメント:
#   - Route 53 Resolver設定: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resolver.html
#   - リバースDNS自動定義ルール: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resolver-automatic-forwarding-rules-reverse-dns.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_resolver_config
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_route53_resolver_config" "example" {
  #-------------------------------------------------------------
  # 対象VPC設定
  #-------------------------------------------------------------

  # resource_id (Required)
  # 設定内容: この設定を適用するVPCのIDを指定します。
  # 設定可能な値: 既存VPCのID（例: "vpc-0123456789abcdef0"）
  # 用途: どのVPCのResolver設定を変更するかを識別するために使用します。
  # 関連機能: Route 53 Resolver
  #   Route 53 Resolverは各VPCにデフォルトで存在し、DNS解決を担います。
  #   - https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resolver.html
  resource_id = aws_vpc.example.id

  #-------------------------------------------------------------
  # リバースDNS自動定義ルール設定
  #-------------------------------------------------------------

  # autodefined_reverse_flag (Required)
  # 設定内容: Resolverがリバースルックアップ用の自動定義ルールを作成するかどうかを指定します。
  # 設定可能な値:
  #   - "ENABLE"  : RFC 1918プライベートアドレス空間向けのリバースDNS自動定義ルールを作成する（デフォルト動作）
  #   - "DISABLE" : リバースDNS自動定義ルールを作成しない
  # 省略時: このフィールドは必須のため省略不可
  # 補足: "DISABLE"を設定すると、RFC 1918アドレス（10.x.x.x, 172.16-31.x.x, 192.168.x.x）の
  #   リバースルックアップをカスタムルールで制御できるようになります。
  #   - https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resolver-automatic-forwarding-rules-reverse-dns.html
  autodefined_reverse_flag = "DISABLE"

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
# - id: Resolverコンフィグレーションのリソースのうちの最初のID
#
# - owner_id: このResolverコンフィグレーションが適用されるVPCの所有者AWSアカウントID
#---------------------------------------------------------------
