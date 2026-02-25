#---------------------------------------------------------------
# Route 53 Resolver ルール関連付け
#---------------------------------------------------------------
#
# Route 53 ResolverルールをVPCに関連付けるリソースです。
# 関連付けを行うことで、対象VPCのDNSクエリに対してResolverルールが適用され、
# 指定したアウトバウンドエンドポイント経由でのDNS転送が有効になります。
# 転送ルールを利用したハイブリッドDNS構成（オンプレミスとのDNS統合など）に
# 使用されます。
#
# AWS公式ドキュメント:
#   - Route 53 Resolverルール: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resolver-rules-managing.html
#   - VPCへのルール関連付け: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resolver-rules-managing.html#resolver-rules-managing-associating-rules
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_resolver_rule_association
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_route53_resolver_rule_association" "example" {
  #-------------------------------------------------------------
  # ルール関連付け設定
  #-------------------------------------------------------------

  # resolver_rule_id (Required)
  # 設定内容: VPCに関連付けるRoute 53 ResolverルールのIDを指定します。
  # 設定可能な値: 既存の aws_route53_resolver_rule リソースのID
  # 補足: 転送ルール（FORWARD）またはシステムルール（SYSTEM）を指定できます。
  #   関連付けにより、対象VPCのDNSクエリへルールが適用されます。
  #   - https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resolver-rules-managing.html
  resolver_rule_id = aws_route53_resolver_rule.example.id

  # vpc_id (Required)
  # 設定内容: Resolverルールを関連付けるVPCのIDを指定します。
  # 設定可能な値: 既存のVPCのID（例: "vpc-0123456789abcdef0"）
  # 補足: 指定したVPCで発生するDNSクエリが、関連付けたルールの条件に
  #   一致する場合に転送処理が適用されます。
  vpc_id = aws_vpc.example.id

  #-------------------------------------------------------------
  # 識別子設定
  #-------------------------------------------------------------

  # name (Optional)
  # 設定内容: ルール関連付けに付ける名前を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: 名前なしで関連付けが作成されます
  # 補足: 複数の関連付けを管理する際の識別に役立ちます。
  name = "example-rule-association"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成完了までの最大待機時間を指定します。
    # 設定可能な値: Goのtime.Duration形式の文字列（例: "10m", "1h"）
    # 省略時: プロバイダーのデフォルト値を使用
    create = "10m"

    # delete (Optional)
    # 設定内容: リソース削除完了までの最大待機時間を指定します。
    # 設定可能な値: Goのtime.Duration形式の文字列（例: "10m", "1h"）
    # 省略時: プロバイダーのデフォルト値を使用
    delete = "10m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: Route 53 Resolverルール関連付けのID
#---------------------------------------------------------------
