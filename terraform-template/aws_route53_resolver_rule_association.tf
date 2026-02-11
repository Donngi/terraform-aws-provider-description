################################################################################
# AWS Route 53 Resolver Rule Association
################################################################################
# Route 53 Resolver Rule Associationは、Resolver RuleとVPCを関連付けるリソースです。
# この関連付けにより、VPCから発信される特定のドメイン名に対するDNSクエリが、
# Resolver Ruleで指定されたIPアドレスに転送されます。
#
# ユースケース:
# - オンプレミスネットワークとVPC間のDNSクエリ転送
# - マルチVPC環境における一貫したDNS解決
# - プライベートホストゾーンへの条件付きDNSルーティング
#
# 参考リンク:
# - https://docs.aws.amazon.com/Route53/latest/APIReference/API_route53resolver_AssociateResolverRule.html
# - https://docs.aws.amazon.com/Route53/latest/APIReference/API_route53resolver_ResolverRuleAssociation.html
################################################################################

resource "aws_route53_resolver_rule_association" "example" {
  ################################################################################
  # Required Parameters
  ################################################################################

  # resolver_rule_id - (Required) VPCと関連付けるResolver RuleのID
  #
  # 説明:
  # - aws_route53_resolver_ruleリソースで作成したResolver RuleのIDを指定
  # - このルールで定義されたドメイン名パターンに一致するDNSクエリが転送対象になる
  # - System RuleまたはForward Rule、Recursive Ruleを指定可能
  #
  # 例:
  # resolver_rule_id = aws_route53_resolver_rule.example.id
  # resolver_rule_id = "rslvr-rr-0123456789abcdef0"
  resolver_rule_id = aws_route53_resolver_rule.example.id

  # vpc_id - (Required) Resolver Ruleを関連付けるVPCのID
  #
  # 説明:
  # - このVPCから発信されるDNSクエリがResolver Ruleの対象となる
  # - VPCは関連付け実行時に存在している必要がある
  # - 1つのVPCに複数のResolver Ruleを関連付けることが可能
  #
  # 例:
  # vpc_id = aws_vpc.example.id
  # vpc_id = "vpc-0123456789abcdef0"
  vpc_id = aws_vpc.example.id

  ################################################################################
  # Optional Parameters
  ################################################################################

  # name - (Optional) Resolver Rule Associationのわかりやすい名前
  #
  # 説明:
  # - 最大64文字まで指定可能
  # - 英数字、ハイフン、アンダースコア、スペースを使用可能
  # - 数字のみの名前は使用不可
  # - 管理コンソールやログで識別しやすくなる
  #
  # 例:
  # name = "example-vpc-association"
  # name = "prod vpc to on-premises dns"
  name = "example-resolver-rule-association"

  # region - (Optional) このリソースを管理するAWSリージョン
  #
  # 説明:
  # - 省略時はプロバイダー設定のリージョンが使用される
  # - マルチリージョン構成で明示的にリージョンを指定する際に使用
  # - 指定したリージョンのVPCとResolver Ruleを関連付ける必要がある
  #
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  #
  # 例:
  # region = "us-west-2"
  # region = "ap-northeast-1"
  # region = "us-east-1"

  ################################################################################
  # Timeouts
  ################################################################################
  # Resolver Rule Associationの作成・削除時のタイムアウト設定
  #
  # 説明:
  # - 大規模なVPCや複雑なDNS設定がある場合、処理に時間がかかることがある
  # - デフォルトのタイムアウトで不十分な場合に調整
  #
  # timeouts {
  #   # create - (Optional) 作成タイムアウト (デフォルト: 10分)
  #   create = "10m"
  #
  #   # delete - (Optional) 削除タイムアウト (デフォルト: 10分)
  #   delete = "10m"
  # }

  ################################################################################
  # Tags
  ################################################################################
  # 注意: aws_route53_resolver_rule_associationリソースは、
  # プロバイダーバージョン6.28.0の時点でタグをサポートしていません。
  # タグが必要な場合は、関連するaws_route53_resolver_ruleリソースにタグを設定してください。
}

################################################################################
# Outputs
################################################################################

# id - Resolver Rule AssociationのID
# 形式: "rslvr-rr-association-0123456789abcdef0"
# 用途: 他のリソースから参照、またはデータソースで検索する際に使用
output "resolver_rule_association_id" {
  description = "The ID of the Route 53 Resolver Rule Association"
  value       = aws_route53_resolver_rule_association.example.id
}

################################################################################
# 補足情報
################################################################################

# 【関連リソース】
# - aws_route53_resolver_rule: 関連付けるResolver Rule本体
# - aws_vpc: 関連付け対象のVPC
# - aws_route53_resolver_endpoint: Resolver Ruleで使用するエンドポイント
#
# 【制約事項】
# - 1つのResolver Ruleを複数のVPCに関連付け可能
# - 1つのVPCに同じドメインパターンを持つ複数のResolver Ruleは関連付け不可
# - System Ruleは明示的に関連付ける必要はなく、VPCに自動的に適用される
# - Resolver Rule削除時は、先に全ての関連付けを削除する必要がある
#
# 【ステータス】
# 関連付けのステータスは以下のいずれかになります:
# - CREATING: 関連付け作成中
# - COMPLETE: 関連付け完了（正常動作中）
# - DELETING: 関連付け削除中
# - FAILED: 関連付け失敗
# - OVERRIDDEN: より具体的なルールによって上書きされている
#
# 【ベストプラクティス】
# - 明確な命名規則を使用してnameパラメータを設定
# - VPCとResolver Ruleが同じリージョンにあることを確認
# - 複数のVPCに同じルールを適用する場合、countまたはfor_eachを使用
# - 依存関係を明示的に設定してリソース作成順序を制御
#
# 【トラブルシューティング】
# - 関連付けがFAILEDステータスの場合、status_messageで詳細を確認
# - VPCまたはResolver Ruleが存在しない場合、関連付けは失敗
# - リージョン不一致の場合も関連付けは失敗
# - DNSクエリが転送されない場合、Resolver RuleのターゲットIPアドレスを確認
