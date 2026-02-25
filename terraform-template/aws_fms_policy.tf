#-----------------------------------------------------------------------
# AWS Firewall Manager Policy
#-----------------------------------------------------------------------
# AWS Firewall Managerポリシーを作成・管理するリソース。
# 組織全体でセキュリティポリシーを一元管理し、複数のAWSアカウントにまたがって
# WAF、Shield Advanced、セキュリティグループ、Network Firewall、DNS Firewallなどの
# セキュリティサービスポリシーを適用できます。
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/fms_policy
#
# NOTE: このテンプレートは全設定項目を網羅した参考例です。
#       実際の使用時は必要な項目のみを残し、不要な項目は削除してください。
#
# 前提条件:
# - AWS Organizationsが有効化されていること
# - Firewall Manager管理者アカウントが設定されていること
#
# 主な用途:
# - 組織全体でのWAFルールの統一適用
# - Shield Advanced保護の一元管理
# - セキュリティグループポリシーの強制
# - Network Firewallポリシーの配布
# - DNS Firewallルールの統一管理
#
# 注意事項:
# - このリソースはベストエフォート提供（テスト制限のため）
# - ポリシー適用には時間がかかる場合があります
# - 組織のルートアカウントまたは委任管理者アカウントで実行する必要があります
#
# 関連リソース:
# - aws_fms_admin_account: Firewall Manager管理者アカウント設定
# - aws_fms_resource_set: ポリシーに適用するリソースセット
#
# 参考: https://docs.aws.amazon.com/fms/
#-----------------------------------------------------------------------

resource "aws_fms_policy" "example" {
  #---------------------------------------
  # 基本設定
  #---------------------------------------
  # 設定内容: ポリシーの名前
  # 設定可能な値: 任意の文字列（1〜128文字）
  # 省略時: エラー（必須項目）
  # 補足: 作成後の変更は新しいリソースを作成します（Forces new resource）
  name = "example-fms-policy"

  # 設定内容: ポリシーの説明
  # 設定可能な値: 任意の文字列
  # 省略時: 説明なし
  # 補足: ポリシーの目的や適用範囲を明確にすることを推奨
  description = "Example Firewall Manager policy for WAF"

  #---------------------------------------
  # リソース適用設定
  #---------------------------------------
  # 設定内容: resource_tagsで指定したタグを持つリソースを除外するかどうか
  # 設定可能な値: true（タグ付きリソースを保護対象外）、false（タグ付きリソースを保護対象）
  # 省略時: エラー（必須項目）
  # 補足: 作成後の変更は新しいリソースを作成します（Forces new resource）
  exclude_resource_tags = false

  # 設定内容: 既存リソースに対してポリシーを自動適用するかどうか
  # 設定可能な値: true（自動適用）、false（新規リソースのみ）
  # 省略時: false
  # 補足: trueの場合、既存の非準拠リソースに対して自動的に修復アクションを実行
  remediation_enabled = false

  # 設定内容: ポリシーで保護するリソースタイプ（単一）
  # 設定可能な値: AWS::ElasticLoadBalancingV2::LoadBalancer、AWS::CloudFront::Distribution、
  #              AWS::ApiGateway::Stage、AWS::EC2::Instance など
  # 省略時: resource_type_listまたはresource_set_idsのいずれかが必要
  # 補足: resource_type_listとは排他的（どちらか一方のみ指定可能）
  resource_type = "AWS::ElasticLoadBalancingV2::LoadBalancer"

  # 設定内容: ポリシーで保護するリソースタイプ（複数）
  # 設定可能な値: リソースタイプ文字列のセット
  # 省略時: resource_typeまたはresource_set_idsのいずれかが必要
  # 補足: resource_typeとは排他的、単一要素リストは非対応（resource_typeを使用）
  resource_type_list = [
    "AWS::ElasticLoadBalancingV2::LoadBalancer",
    "AWS::CloudFront::Distribution"
  ]

  # 設定内容: ポリシーに関連付けるリソースセットID
  # 設定可能な値: リソースセットIDのセット
  # 省略時: resource_typeまたはresource_type_listのいずれかが必要
  # 補足: リソースセットを使用する場合に指定
  resource_set_ids = ["resource-set-id-1", "resource-set-id-2"]

  #---------------------------------------
  # タグベースのフィルタリング
  #---------------------------------------
  # 設定内容: リソース保護対象を判定するためのタグ
  # 設定可能な値: キーバリューペアのマップ
  # 省略時: タグによるフィルタリングなし
  # 補足: exclude_resource_tagsの設定により、含める/除外するの動作が変わります
  resource_tags = {
    Environment = "production"
    ManagedBy   = "firewall-manager"
  }

  # 設定内容: 複数のresource_tagsを組み合わせる論理演算子
  # 設定可能な値: AND（すべてのタグが一致）、OR（いずれかのタグが一致）
  # 省略時: AND
  # 補足: resource_tagsが複数ある場合の評価方法を制御
  resource_tag_logical_operator = "AND"

  #---------------------------------------
  # アカウント/OU適用範囲設定
  #---------------------------------------
  # 設定内容: ポリシーを適用するアカウントと組織単位
  # 省略時: 組織全体に適用
  include_map {
    # 設定内容: ポリシーを適用するAWSアカウントIDのセット
    # 設定可能な値: 12桁のアカウントID
    # 省略時: アカウント指定なし（orgunitsと併用可能）
    account = ["123456789012", "210987654321"]

    # 設定内容: ポリシーを適用する組織単位（OU）のARNセット
    # 設定可能な値: OU ARN（arn:aws:organizations::123456789012:ou/o-xxxxx/ou-xxxxx）
    # 省略時: OU指定なし（accountと併用可能）
    orgunit = [
      "arn:aws:organizations::123456789012:ou/o-xxxxx/ou-prod-xxxxx",
      "arn:aws:organizations::123456789012:ou/o-xxxxx/ou-dev-xxxxx"
    ]
  }

  # 設定内容: ポリシーを適用しないアカウントと組織単位
  # 省略時: 除外なし
  # 補足: include_mapと併用可能（include後にexcludeを評価）
  exclude_map {
    # 設定内容: ポリシーを適用しないAWSアカウントIDのセット
    # 設定可能な値: 12桁のアカウントID
    # 省略時: アカウント除外なし
    account = ["999999999999"]

    # 設定内容: ポリシーを適用しない組織単位（OU）のARNセット
    # 設定可能な値: OU ARN
    # 省略時: OU除外なし
    orgunit = ["arn:aws:organizations::123456789012:ou/o-xxxxx/ou-test-xxxxx"]
  }

  #---------------------------------------
  # セキュリティサービスポリシー設定
  #---------------------------------------
  # 設定内容: 適用するセキュリティサービスの種類と設定
  # 省略時: エラー（必須ブロック）
  security_service_policy_data {
    # 設定内容: セキュリティサービスのタイプ
    # 設定可能な値: WAF、WAFV2、SHIELD_ADVANCED、SECURITY_GROUPS_COMMON、
    #              SECURITY_GROUPS_CONTENT_AUDIT、SECURITY_GROUPS_USAGE_AUDIT、
    #              NETWORK_FIREWALL、DNS_FIREWALL、THIRD_PARTY_FIREWALL、
    #              IMPORT_NETWORK_FIREWALL、NETWORK_ACL_COMMON
    # 省略時: エラー（必須項目）
    type = "WAFV2"

    # 設定内容: セキュリティサービス固有の設定（JSON形式）
    # 設定可能な値: typeに応じたJSON文字列
    # 省略時: typeによっては必須
    # 補足: WAFの場合はルールグループ、デフォルトアクション等を指定
    managed_service_data = jsonencode({
      type = "WAFV2"
      preProcessRuleGroups = [{
        ruleGroupArn = "arn:aws:wafv2:us-east-1:123456789012:regional/rulegroup/example/a1b2c3d4"
        overrideAction = {
          type = "NONE"
        }
        managedRuleGroupIdentifier = null
        ruleGroupType              = "RuleGroup"
        excludeRules               = []
      }]
      postProcessRuleGroups = []
      defaultAction = {
        type = "ALLOW"
      }
      overrideCustomerWebACLAssociation = false
      loggingConfiguration = {
        logDestinationConfigs = [
          "arn:aws:firehose:us-east-1:123456789012:deliverystream/aws-waf-logs-example"
        ]
      }
    })

    # 設定内容: ポリシーオプション（Network Firewall、Network ACL、サードパーティファイアウォール用）
    # 省略時: デフォルト設定を使用
    policy_option {
      # 設定内容: Network Firewallポリシーオプション
      # 省略時: Network Firewallポリシー以外では不要
      network_firewall_policy {
        # 設定内容: ファイアウォールのデプロイメントモデル
        # 設定可能な値: CENTRALIZED（集中型）、DISTRIBUTED（分散型）
        # 省略時: デフォルトモデルを使用
        # 補足: CENTRALIZEDは単一VPCでのインスペクション、DISTRIBUTEDは各VPCに配置
        firewall_deployment_model = "DISTRIBUTED"
      }

      # 設定内容: サードパーティファイアウォールポリシーオプション
      # 省略時: サードパーティファイアウォールポリシー以外では不要
      # third_party_firewall_policy {
      #   # 設定内容: ファイアウォールのデプロイメントモデル
      #   # 設定可能な値: CENTRALIZED、DISTRIBUTED
      #   # 省略時: デフォルトモデルを使用
      #   firewall_deployment_model = "CENTRALIZED"
      # }

      # 設定内容: Network ACL共通ポリシーオプション
      # 省略時: Network ACLポリシー以外では不要
      # network_acl_common_policy {
      #   network_acl_entry_set {
      #     # 設定内容: 最初のエントリに対する強制修復
      #     # 設定可能な値: true（強制修復）、false（修復しない）
      #     # 省略時: エラー（必須項目）
      #     force_remediate_for_first_entries = true
      #
      #     # 設定内容: 最後のエントリに対する強制修復
      #     # 設定可能な値: true（強制修復）、false（修復しない）
      #     # 省略時: エラー（必須項目）
      #     force_remediate_for_last_entries = true
      #
      #     # 設定内容: ACLの最初に適用するエントリ
      #     # 省略時: 最初のエントリなし
      #     first_entry {
      #       # 設定内容: CIDR表記のIPv4アドレス範囲
      #       # 設定可能な値: 有効なCIDR表記（例: 10.0.0.0/8）
      #       # 省略時: ipv6_cidr_blockのいずれかが必要
      #       cidr_block = "0.0.0.0/0"
      #
      #       # 設定内容: エグレス（送信）ルールかどうか
      #       # 設定可能な値: true（送信）、false（受信）
      #       # 省略時: エラー（必須項目）
      #       egress = false
      #
      #       # 設定内容: プロトコル番号またはプロトコル名
      #       # 設定可能な値: -1（すべて）、6（TCP）、17（UDP）、1（ICMP）など
      #       # 省略時: エラー（必須項目）
      #       protocol = "-1"
      #
      #       # 設定内容: ルールアクション
      #       # 設定可能な値: allow、deny
      #       # 省略時: エラー（必須項目）
      #       rule_action = "deny"
      #
      #       # 設定内容: ICMPタイプとコード
      #       # 省略時: ICMP以外では不要
      #       # icmp_type_code {
      #       #   code = 0
      #       #   type = 8
      #       # }
      #
      #       # 設定内容: ポート範囲
      #       # 省略時: すべてのポート
      #       # port_range {
      #       #   from = 443
      #       #   to   = 443
      #       # }
      #     }
      #
      #     # 設定内容: ACLの最後に適用するエントリ
      #     # 省略時: 最後のエントリなし
      #     # 補足: first_entryと同じ構造
      #     # last_entry {
      #     #   cidr_block  = "0.0.0.0/0"
      #     #   egress      = false
      #     #   protocol    = "-1"
      #     #   rule_action = "allow"
      #     # }
      #   }
      # }
    }
  }

  #---------------------------------------
  # リソース削除設定
  #---------------------------------------
  # 設定内容: ポリシー削除時にすべてのポリシーリソースも削除するかどうか
  # 設定可能な値: true（すべて削除）、false（リソースを保持）
  # 省略時: true
  # 補足: クリーンアッププロセスを実行して関連リソースも削除
  delete_all_policy_resources = true

  # 設定内容: ポリシースコープから外れたリソースの保護を自動解除するかどうか
  # 設定可能な値: true（自動解除）、false（保護を維持）
  # 省略時: false
  # 補足: Shield AdvancedおよびAWS WAF Classicポリシーでは使用不可
  delete_unused_fm_managed_resources = false

  #---------------------------------------
  # リージョン設定
  #---------------------------------------
  # 設定内容: ポリシーを管理するAWSリージョン
  # 設定可能な値: 有効なAWSリージョンコード（us-east-1、ap-northeast-1など）
  # 省略時: プロバイダー設定のリージョンを使用
  # 補足: グローバルリソース（CloudFront、Route 53など）の場合はus-east-1を指定
  region = "us-east-1"

  #---------------------------------------
  # タグ設定
  #---------------------------------------
  # 設定内容: ポリシーに付与するタグ
  # 設定可能な値: キーバリューペアのマップ
  # 省略時: タグなし
  # 補足: プロバイダーのdefault_tagsと統合されます
  tags = {
    Name        = "example-fms-policy"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

#---------------------------------------
# Attributes Reference（参照可能な属性）
#---------------------------------------
# このリソースから参照できる属性の一覧
# 主にoutputブロックや他のリソースから参照する際に使用します
#
# - id
#   説明: Firewall Managerポリシーの一意識別子
#   用途: ポリシーの参照や依存関係の定義に使用
#
# - arn
#   説明: ポリシーのAmazon Resource Name (ARN)
#   用途: IAMポリシーやクロスアカウント参照で使用
#
# - policy_update_token
#   説明: ポリシー更新ごとの一意識別子
#   用途: ポリシー更新の追跡に使用
#
# - tags_all
#   説明: ポリシーに付与されたすべてのタグ（プロバイダーのdefault_tagsを含む）
#   用途: タグの完全なリストを参照する場合に使用
