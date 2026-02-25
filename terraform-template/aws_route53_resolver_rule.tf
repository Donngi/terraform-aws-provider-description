#---------------------------------------------------------------
# AWS Route 53 Resolver Rule
#---------------------------------------------------------------
#
# Amazon Route 53 Resolverのルールをプロビジョニングするリソースです。
# Resolverルールは、指定したドメイン名に対するDNSクエリを
# 特定のIPアドレスに転送（FORWARD）するか、システムデフォルト（SYSTEM）で
# 処理するかを定義します。
#
# AWS公式ドキュメント:
#   - Route 53 Resolverルールの概要: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resolver-overview-DSN-queries-to-vpc.html
#   - CreateResolverRule APIリファレンス: https://docs.aws.amazon.com/Route53/latest/APIReference/API_route53resolver_CreateResolverRule.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_resolver_rule
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_route53_resolver_rule" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # domain_name (Required)
  # 設定内容: DNSクエリを転送するドメイン名を指定します。
  #   このドメイン名へのDNSクエリは、target_ipで指定したIPアドレスに転送されます。
  # 設定可能な値: 有効なドメイン名文字列（例: example.com, subdomain.example.com）
  domain_name = "example.com"

  # rule_type (Required)
  # 設定内容: ルールのタイプを指定します。
  # 設定可能な値:
  #   - "FORWARD": 指定ドメインのDNSクエリをtarget_ipで指定したIPアドレスに転送
  #   - "SYSTEM": AWSのデフォルトDNS処理（Resolverが独自のルールを使用）
  #   - "RECURSIVE": 再帰的クエリ処理（パブリックDNSに対してResolverが再帰的に解決）
  # 注意: FORWARDタイプの場合のみtarget_ipを指定する必要があります
  rule_type = "FORWARD"

  # name (Optional)
  # 設定内容: Route 53 ConsoleのResolverダッシュボードでルールを識別するフレンドリー名を指定します。
  # 設定可能な値: 最大64文字の英数字、ハイフン、アンダースコアを含む文字列
  # 省略時: 名前なしで作成されます
  name = "example-resolver-rule"

  # resolver_endpoint_id (Optional)
  # 設定内容: Resolverエンドポイントのいずれかに関連付けるエンドポイントIDを指定します。
  # 設定可能な値: 有効なResolverエンドポイントID
  # 省略時: エンドポイントに関連付けられません
  # 注意: FORWARDタイプのルールでtarget_ipを指定する場合は送信エンドポイントIDを指定してください
  resolver_endpoint_id = null

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
  # 転送先IPアドレス設定
  #-------------------------------------------------------------

  # target_ip (Optional)
  # 設定内容: DNSクエリを転送するIPアドレスの設定ブロックです。
  # 注意: FORWARDタイプのルールにのみ指定してください
  # 注意: SYSTEMまたはRECURSIVEタイプのルールには指定しないでください
  target_ip {
    # ip (Optional)
    # 設定内容: DNSクエリの転送先となるIPv4アドレスを指定します。
    # 設定可能な値: 有効なIPv4アドレス文字列
    # 省略時: IPv4アドレスなしで設定されます
    ip = "123.45.67.89"

    # ipv6 (Optional)
    # 設定内容: DNSクエリの転送先となるIPv6アドレスを指定します。
    # 設定可能な値: 有効なIPv6アドレス文字列
    # 省略時: IPv6アドレスなしで設定されます
    ipv6 = null

    # port (Optional)
    # 設定内容: DNSクエリを転送するIPアドレスのポート番号を指定します。
    # 設定可能な値: 有効なポート番号（1〜65535）
    # 省略時: 53（標準DNSポート）が適用されます
    port = 53

    # protocol (Optional)
    # 設定内容: Resolverエンドポイントが使用するプロトコルを指定します。
    # 設定可能な値:
    #   - "Do53": 標準DNS（DNS over Port 53）
    #   - "DoH": DNS over HTTPS（暗号化DNS）
    # 省略時: "Do53"が適用されます
    # 参考: https://docs.aws.amazon.com/Route53/latest/APIReference/API_route53resolver_TargetAddress.html
    protocol = "Do53"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間の設定ブロックです。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成のタイムアウト時間を指定します。
    # 設定可能な値: "60m"、"2h" などのDuration文字列
    # 省略時: デフォルトのタイムアウト時間が適用されます
    create = "10m"

    # update (Optional)
    # 設定内容: リソース更新のタイムアウト時間を指定します。
    # 設定可能な値: "60m"、"2h" などのDuration文字列
    # 省略時: デフォルトのタイムアウト時間が適用されます
    update = "10m"

    # delete (Optional)
    # 設定内容: リソース削除のタイムアウト時間を指定します。
    # 設定可能な値: "60m"、"2h" などのDuration文字列
    # 省略時: デフォルトのタイムアウト時間が適用されます
    delete = "10m"
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-resolver-rule"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: Route 53 ResolverルールのARN
# - id: ResolverルールのID
# - owner_id: ルールが別のAWSアカウントと共有されている場合、共有先アカウントのID
# - share_status: ルールの共有状態。値は NOT_SHARED / SHARED_BY_ME / SHARED_WITH_ME のいずれか
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
