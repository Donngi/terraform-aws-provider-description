################################################################################
# AWS Firewall Manager Policy
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/fms_policy
################################################################################

# AWS Firewall Manager (FMS) は、AWS Organizations 全体でセキュリティポリシーを
# 一元的に設定・管理するサービスです。WAF、Shield Advanced、セキュリティグループ、
# Network Firewall などのポリシーを複数のアカウント・リソースに自動適用できます。

resource "aws_fms_policy" "example" {
  #------------------------------------------------------------------------------
  # 必須パラメータ
  #------------------------------------------------------------------------------

  # ポリシー名
  # - 長さ: 1-128文字
  # - AWS Firewall Manager ポリシーの識別名
  name = "FMS-Policy-Example"

  # リソースタグの除外設定
  # - true: resource_tags に指定されたタグを持つリソースをポリシー対象から除外
  # - false: resource_tags に指定されたタグを持つリソースのみをポリシー対象に含める
  # - Forces new resource (変更時は再作成が必要)
  exclude_resource_tags = false

  # 自動修復の有効化
  # - true: ポリシーを既存リソースに自動適用し、非準拠リソースを自動修復
  # - false: 非準拠リソースを特定するのみで修復は行わない
  remediation_enabled = false

  # 保護対象のリソースタイプ
  # - CloudFormation リソース形式で指定 (例: AWS::EC2::Instance)
  # - resource_type_list と競合 (どちらか一方のみ使用可能)
  # - Forces new resource (変更時は再作成が必要)
  # - ポリシータイプごとの有効なリソースタイプ:
  #   * WAF/WAFv2: AWS::ApiGateway::Stage, AWS::CloudFront::Distribution,
  #                AWS::ElasticLoadBalancingV2::LoadBalancer
  #   * Shield Advanced: AWS::ElasticLoadBalancingV2::LoadBalancer,
  #                      AWS::ElasticLoadBalancing::LoadBalancer,
  #                      AWS::EC2::EIP, AWS::CloudFront::Distribution
  #   * Network ACL: AWS::EC2::Subnet
  #   * Security Group (usage audit): AWS::EC2::SecurityGroup
  #   * Security Group (content audit): AWS::EC2::SecurityGroup,
  #                                     AWS::EC2::NetworkInterface, AWS::EC2::Instance
  #   * DNS Firewall/Network Firewall/Third-party: AWS::EC2::VPC
  resource_type = "AWS::ElasticLoadBalancingV2::LoadBalancer"

  # セキュリティサービスポリシーデータ
  # - ポリシーの種類と設定を定義する必須ブロック
  security_service_policy_data {
    # セキュリティサービスのタイプ
    # - 有効な値:
    #   * WAF: AWS WAF Classic ポリシー
    #   * WAFV2: AWS WAF ポリシー (推奨)
    #   * SHIELD_ADVANCED: Shield Advanced ポリシー
    #   * SECURITY_GROUPS_COMMON: 共通セキュリティグループポリシー
    #   * SECURITY_GROUPS_CONTENT_AUDIT: セキュリティグループ内容監査
    #   * SECURITY_GROUPS_USAGE_AUDIT: セキュリティグループ使用状況監査
    #   * NETWORK_FIREWALL: AWS Network Firewall ポリシー
    #   * DNS_FIREWALL: Route 53 Resolver DNS Firewall ポリシー
    #   * THIRD_PARTY_FIREWALL: サードパーティファイアウォール
    #   * IMPORT_NETWORK_FIREWALL: 既存 Network Firewall のインポート
    #   * NETWORK_ACL_COMMON: ネットワーク ACL ポリシー
    type = "WAF"

    # マネージドサービスデータ (JSON形式)
    # - セキュリティサービス固有の設定を JSON エンコードで指定
    # - 各ポリシータイプで異なる設定項目が必要
    # - 長さ: 1-30000文字
    #
    # WAF Classic の例:
    # {
    #   "type": "WAF",
    #   "ruleGroups": [
    #     {
    #       "id": "rule-group-id",
    #       "overrideAction": { "type": "COUNT" }
    #     }
    #   ],
    #   "defaultAction": { "type": "BLOCK" },
    #   "overrideCustomerWebACLAssociation": false
    # }
    #
    # WAFv2 の例:
    # {
    #   "type": "WAFV2",
    #   "preProcessRuleGroups": [
    #     {
    #       "ruleGroupType": "ManagedRuleGroup",
    #       "overrideAction": { "type": "NONE" },
    #       "managedRuleGroupIdentifier": {
    #         "vendorName": "AWS",
    #         "managedRuleGroupName": "AWSManagedRulesCommonRuleSet"
    #       }
    #     }
    #   ],
    #   "postProcessRuleGroups": [],
    #   "defaultAction": { "type": "ALLOW" },
    #   "overrideCustomerWebACLAssociation": false,
    #   "loggingConfiguration": {
    #     "logDestinationConfigs": ["arn:aws:s3:::bucket-name"]
    #   }
    # }
    #
    # Network Firewall (分散デプロイ) の例:
    # {
    #   "type": "NETWORK_FIREWALL",
    #   "networkFirewallStatelessRuleGroupReferences": [
    #     {
    #       "resourceARN": "arn:aws:network-firewall:region:account:stateless-rulegroup/name",
    #       "priority": 1
    #     }
    #   ],
    #   "networkFirewallStatelessDefaultActions": ["aws:forward_to_sfe"],
    #   "networkFirewallStatelessFragmentDefaultActions": ["aws:forward_to_sfe"],
    #   "networkFirewallStatefulRuleGroupReferences": [
    #     {
    #       "resourceARN": "arn:aws:network-firewall:region:account:stateful-rulegroup/name"
    #     }
    #   ],
    #   "networkFirewallOrchestrationConfig": {
    #     "singleFirewallEndpointPerVPC": false,
    #     "allowedIPV4CidrList": ["10.0.0.0/8"],
    #     "routeManagementAction": "MONITOR"
    #   }
    # }
    #
    # Security Groups Common の例:
    # {
    #   "type": "SECURITY_GROUPS_COMMON",
    #   "securityGroups": [{ "id": "sg-12345678" }],
    #   "revertManualSecurityGroupChanges": true,
    #   "exclusiveResourceSecurityGroupManagement": false,
    #   "applyToAllEC2InstanceENIs": false,
    #   "includeSharedVPC": false
    # }
    #
    # Shield Advanced の例:
    # {
    #   "type": "SHIELD_ADVANCED",
    #   "automaticResponseConfiguration": {
    #     "automaticResponseStatus": "ENABLED",
    #     "automaticResponseAction": "BLOCK"
    #   },
    #   "optimizeUnassociatedWebACL": true
    # }
    #
    # DNS Firewall の例:
    # {
    #   "type": "DNS_FIREWALL",
    #   "preProcessRuleGroups": [
    #     {
    #       "ruleGroupId": "rslvr-frg-123456",
    #       "priority": 10
    #     }
    #   ],
    #   "postProcessRuleGroups": [
    #     {
    #       "ruleGroupId": "rslvr-frg-789012",
    #       "priority": 9911
    #     }
    #   ]
    # }
    managed_service_data = jsonencode({
      type = "WAF"
      ruleGroups = [{
        id = aws_wafregional_rule_group.example.id
        overrideAction = {
          type = "COUNT"
        }
      }]
      defaultAction = {
        type = "BLOCK"
      }
      overrideCustomerWebACLAssociation = false
    })

    # ポリシーオプション (オプション)
    # - Network ACL、Network Firewall、サードパーティファイアウォールの
    #   追加設定を定義するネストブロック
    # - 詳細は policy_option ブロックを参照
    # policy_option {
    #   network_firewall_policy {
    #     firewall_deployment_model = "DISTRIBUTED" # または "CENTRALIZED"
    #   }
    # }
  }

  #------------------------------------------------------------------------------
  # オプションパラメータ
  #------------------------------------------------------------------------------

  # ポリシーの説明
  # - 長さ: 最大256文字
  # - ポリシーの目的や適用範囲などを記述
  description = "Example Firewall Manager policy for WAF"

  # 複数リソースタイプのリスト
  # - 複数のリソースタイプを保護する場合に使用
  # - resource_type と競合 (どちらか一方のみ使用可能)
  # - 要素が1つのリストは非サポート (単一要素の場合は resource_type を使用)
  # resource_type_list = [
  #   "AWS::ElasticLoadBalancingV2::LoadBalancer",
  #   "AWS::CloudFront::Distribution"
  # ]

  # ポリシー適用リージョン
  # - デフォルト: プロバイダー設定のリージョン
  # - グローバルリソース (CloudFront など) の場合は "Global" または "us-east-1" を指定
  # - リージョナルリソースの場合は適用対象リージョンを指定
  # region = "us-east-1"

  # 対象アカウント・OU のインクルード設定
  # - include_map と exclude_map は両方指定不可 (どちらか一方のみ)
  # - include_map を指定した場合、exclude_map は評価されない
  # - 指定しない場合、exclude_map で除外されたアカウント以外の全アカウントが対象
  # include_map {
  #   # アカウント ID のリスト
  #   ACCOUNT = ["123456789012", "234567890123"]
  #
  #   # 組織単位 (OU) ID のリスト
  #   # - OU とその配下の全 OU・アカウントが対象に含まれる
  #   ORG_UNIT = ["ou-xxxx-xxxxxxxx", "ou-yyyy-yyyyyyyy"]
  # }

  # 除外アカウント・OU の設定
  # - include_map が指定されていない場合に有効
  # - exclude_map で指定されたアカウント・OU 以外が対象となる
  exclude_map {
    # 除外するアカウント ID のリスト
    ACCOUNT = ["345678901234"]

    # 除外する組織単位 (OU) ID のリスト
    # - OU とその配下の全 OU・アカウントが除外される
    # ORG_UNIT = ["ou-zzzz-zzzzzzzz"]
  }

  # リソースタグのフィルタ設定
  # - exclude_resource_tags の値に応じて包含/除外を制御
  # - 最大50個のタグを指定可能
  # resource_tags = {
  #   Environment = "Production"
  #   ManagedBy   = "Firewall-Manager"
  # }

  # リソースタグの論理演算子
  # - AND: リソースが全てのタグを持つ必要がある
  # - OR: リソースが少なくとも1つのタグを持てば良い
  # - デフォルト: AND
  # resource_tag_logical_operator = "AND"

  # 未使用の FMS 管理リソースの削除
  # - true: リソースがポリシースコープから外れた際、保護を自動削除し、
  #         FMS が管理するリソース (WebACL など) をクリーンアップ
  # - false: ポリシースコープから外れてもリソースの関連付けを維持
  # - デフォルト: false
  # - Shield Advanced および WAF Classic ポリシーでは使用不可
  #
  # 注意: 有効化すると、FMS は既存の未使用 WebACL を一度だけクリーンアップします。
  # このプロセスには数時間かかる場合があります。
  delete_unused_fm_managed_resources = false

  # ポリシー削除時の全リソース削除
  # - true: ポリシー削除時に関連する全リソース (WebACL、ルールグループなど) も削除
  # - false: ポリシーのみ削除し、関連リソースは保持
  # - デフォルト: true
  #
  # API 参考: https://docs.aws.amazon.com/fms/2018-01-01/APIReference/API_DeletePolicy.html
  delete_all_policy_resources = true

  # リソースタグ
  # - ポリシーに付与するタグ
  # - プロバイダーの default_tags とマージされる
  tags = {
    Name        = "example-fms-policy"
    Environment = "Production"
    ManagedBy   = "Terraform"
  }
}

#------------------------------------------------------------------------------
# policy_option ブロック (security_service_policy_data 内で使用)
#------------------------------------------------------------------------------

# Network Firewall ポリシーオプションの例
# resource "aws_fms_policy" "network_firewall" {
#   name                  = "FMS-NetworkFirewall-Policy"
#   exclude_resource_tags = false
#   remediation_enabled   = true
#   resource_type         = "AWS::EC2::VPC"
#
#   security_service_policy_data {
#     type = "NETWORK_FIREWALL"
#
#     managed_service_data = jsonencode({
#       type = "NETWORK_FIREWALL"
#       # ... Network Firewall 設定 ...
#     })
#
#     # Network Firewall のデプロイメントモデル設定
#     policy_option {
#       network_firewall_policy {
#         # ファイアウォールのデプロイメントモデル
#         # - DISTRIBUTED: 各 VPC にファイアウォールエンドポイントを配置
#         # - CENTRALIZED: 中央の検査 VPC にファイアウォールを配置
#         firewall_deployment_model = "DISTRIBUTED"
#       }
#     }
#   }
# }

# Network ACL ポリシーオプションの例
# resource "aws_fms_policy" "network_acl" {
#   name                  = "FMS-NetworkACL-Policy"
#   exclude_resource_tags = false
#   remediation_enabled   = true
#   resource_type         = "AWS::EC2::Subnet"
#
#   security_service_policy_data {
#     type = "NETWORK_ACL_COMMON"
#
#     managed_service_data = jsonencode({
#       type = "NETWORK_ACL_COMMON"
#       # ... Network ACL 設定 ...
#     })
#
#     # Network ACL の詳細設定
#     policy_option {
#       network_acl_common_policy {
#         # ネットワーク ACL エントリの設定
#       }
#     }
#   }
# }

# サードパーティファイアウォールポリシーオプションの例
# resource "aws_fms_policy" "third_party" {
#   name                  = "FMS-ThirdParty-Policy"
#   exclude_resource_tags = false
#   remediation_enabled   = true
#   resource_type         = "AWS::EC2::VPC"
#
#   security_service_policy_data {
#     type = "THIRD_PARTY_FIREWALL"
#
#     managed_service_data = jsonencode({
#       type                = "THIRD_PARTY_FIREWALL"
#       thirdPartyFirewall  = "PALO_ALTO_NETWORKS_CLOUD_NGFW" # または "FORTIGATE_CLOUD_NATIVE_FIREWALL"
#       # ... サードパーティファイアウォール設定 ...
#     })
#
#     # サードパーティファイアウォールのポリシー設定
#     policy_option {
#       third_party_firewall_policy {
#         # サードパーティファイアウォールの詳細設定
#       }
#     }
#   }
# }

#------------------------------------------------------------------------------
# 出力属性 (Computed Attributes)
#------------------------------------------------------------------------------

# output "fms_policy_id" {
#   description = "Firewall Manager ポリシーの ID"
#   value       = aws_fms_policy.example.id
# }

# output "fms_policy_update_token" {
#   description = "ポリシー更新の一意識別子 (更新時に必要)"
#   value       = aws_fms_policy.example.policy_update_token
# }

# output "fms_policy_tags_all" {
#   description = "プロバイダーの default_tags を含む全タグ"
#   value       = aws_fms_policy.example.tags_all
# }

#------------------------------------------------------------------------------
# 依存リソース例
#------------------------------------------------------------------------------

# WAF Regional ルールグループ (WAF Classic ポリシー用)
resource "aws_wafregional_rule_group" "example" {
  metric_name = "WAFRuleGroupExample"
  name        = "WAF-Rule-Group-Example"
}

# WAFv2 Web ACL ルールグループ例
# resource "aws_wafv2_rule_group" "example" {
#   name     = "example-rule-group"
#   scope    = "REGIONAL" # または "CLOUDFRONT"
#   capacity = 100
#
#   rule {
#     name     = "rule-1"
#     priority = 1
#
#     action {
#       block {}
#     }
#
#     statement {
#       geo_match_statement {
#         country_codes = ["US", "NL"]
#       }
#     }
#
#     visibility_config {
#       cloudwatch_metrics_enabled = true
#       metric_name                = "rule-1"
#       sampled_requests_enabled   = true
#     }
#   }
#
#   visibility_config {
#     cloudwatch_metrics_enabled = true
#     metric_name                = "example-rule-group"
#     sampled_requests_enabled   = true
#   }
# }

# Network Firewall ルールグループ例
# resource "aws_networkfirewall_rule_group" "example" {
#   capacity = 100
#   name     = "example-rule-group"
#   type     = "STATEFUL"
#
#   rule_group {
#     rules_source {
#       stateful_rule {
#         action = "DROP"
#         header {
#           destination      = "ANY"
#           destination_port = "ANY"
#           protocol         = "TCP"
#           direction        = "FORWARD"
#           source           = "10.0.0.0/8"
#           source_port      = "ANY"
#         }
#         rule_option {
#           keyword = "sid:1"
#         }
#       }
#     }
#   }
# }

# セキュリティグループ例 (SECURITY_GROUPS_COMMON ポリシー用)
# resource "aws_security_group" "example" {
#   name        = "fms-managed-sg"
#   description = "Firewall Manager managed security group"
#   vpc_id      = aws_vpc.example.id
#
#   ingress {
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#
#   tags = {
#     Name = "FMS-Managed-SG"
#   }
# }

#------------------------------------------------------------------------------
# 重要な注意事項
#------------------------------------------------------------------------------

# 1. 前提条件:
#    - AWS Organizations が有効化されていること
#    - Firewall Manager 管理者アカウントが設定されていること
#    - 対象アカウントで AWS Config が有効化されていること
#    - 保護対象リソースがあるリージョンで AWS Config が設定されていること
#
# 2. ポリシータイプごとの AWS Config 要件:
#    - WAF: AWS::WAFRegional::WebACL または AWS::WAFv2::WebACL
#    - Shield Advanced: CloudFront, ELB, EIP, Global Accelerator のリソースタイプ
#    - Security Group: AWS::EC2::SecurityGroup, AWS::EC2::NetworkInterface
#    - Network Firewall: AWS::NetworkFirewall::FirewallPolicy
#    - DNS Firewall: AWS::Route53Resolver::ResolverRuleAssociation
#
# 3. リージョン考慮事項:
#    - グローバルリソース (CloudFront) の場合は us-east-1 を使用
#    - リージョナルリソースの場合は対象リージョンを指定
#    - 1つのポリシーは1つのリージョンのみに適用可能
#
# 4. managed_service_data の複雑性:
#    - JSON 形式で複雑な設定を記述する必要がある
#    - ポリシータイプごとに異なるスキーマ
#    - 検証が実行時まで行われないため、注意深く設定すること
#
# 5. コスト考慮事項:
#    - ポリシーごとに課金される
#    - 保護されるリソース数に応じて追加コスト
#    - Shield Advanced は別途サブスクリプション料金が必要
#
# 6. パフォーマンス影響:
#    - WAF/Network Firewall はトラフィック検査でレイテンシが増加する可能性
#    - 適切なルール設計とキャパシティプランニングが必要
#
# 7. 削除時の注意:
#    - delete_all_policy_resources = true の場合、関連リソースも削除される
#    - 本番環境では慎重に設定すること
#
# 8. テストとベストプラクティス:
#    - まず remediation_enabled = false で動作確認
#    - 段階的にアカウント・OU を追加
#    - CloudWatch Logs でポリシー適用状況を監視
#    - 定期的なコンプライアンスレポートの確認
