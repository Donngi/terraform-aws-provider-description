#---------------------------------------------------------------
# AWS Route 53 Recovery Readiness Resource Set
#---------------------------------------------------------------
#
# AWS Route 53 Application Recovery Controller の Recovery Readiness で使用される
# リソースセットを定義するリソースです。
# リソースセットは、アプリケーションの準備状態チェックの対象となる
# AWSリソースのグループを表します。
#
# 主な用途:
#   - アプリケーションの復旧準備状態を監視するリソースのグループ化
#   - CloudWatch Alarm、DynamoDBテーブル、EBSボリュームなどの準備状態チェック
#   - DNSターゲットリソース(Route53レコード、NLB)の監視
#   - 複数リージョンにまたがるリソースの準備状態の確認
#
# AWS公式ドキュメント:
#   - Recovery Readiness 概要: https://docs.aws.amazon.com/r53recovery/latest/dg/recovery-readiness.html
#   - リソースセット: https://docs.aws.amazon.com/r53recovery/latest/dg/recovery-readiness.resource-sets.html
#   - Recovery Readiness API: https://docs.aws.amazon.com/recovery-readiness/latest/api/Welcome.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53recoveryreadiness_resource_set
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_route53recoveryreadiness_resource_set" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # resource_set_name (Required)
  # 設定内容: リソースセットを識別する一意の名前を指定します。
  # 設定可能な値: 文字列 (英数字、ハイフン、アンダースコア)
  # 用途: リソースセットの識別と管理に使用
  # 関連機能: Route53 Recovery Readiness リソースセット
  #   リソースセット名はアカウント内で一意である必要があります。
  #   Readiness Check で参照する際に使用されます。
  #   - https://docs.aws.amazon.com/r53recovery/latest/dg/recovery-readiness.resource-sets.html
  resource_set_name = "my-resource-set"

  # resource_set_type (Required)
  # 設定内容: リソースセット内のリソースのタイプを指定します。
  # 設定可能な値:
  #   - "AWS::CloudWatch::Alarm": CloudWatch アラーム
  #   - "AWS::DynamoDB::Table": DynamoDB テーブル
  #   - "AWS::EC2::CustomerGateway": カスタマーゲートウェイ
  #   - "AWS::EC2::EIP": Elastic IP アドレス
  #   - "AWS::EC2::Instance": EC2 インスタンス
  #   - "AWS::EC2::InternetGateway": インターネットゲートウェイ
  #   - "AWS::EC2::NATGateway": NAT ゲートウェイ
  #   - "AWS::EC2::NetworkInterface": ネットワークインターフェース
  #   - "AWS::EC2::RouteTable": ルートテーブル
  #   - "AWS::EC2::SecurityGroup": セキュリティグループ
  #   - "AWS::EC2::Subnet": サブネット
  #   - "AWS::EC2::Volume": EBS ボリューム
  #   - "AWS::EC2::VPC": VPC
  #   - "AWS::EC2::VPCEndpoint": VPC エンドポイント
  #   - "AWS::EC2::VPCGatewayAttachment": VPC ゲートウェイアタッチメント
  #   - "AWS::EC2::VPNConnection": VPN 接続
  #   - "AWS::EC2::VPNGateway": VPN ゲートウェイ
  #   - "AWS::ElasticLoadBalancingV2::LoadBalancer": Application/Network Load Balancer
  #   - "AWS::Lambda::Function": Lambda 関数
  #   - "AWS::RDS::DBCluster": RDS DB クラスター
  #   - "AWS::Route53::HealthCheck": Route53 ヘルスチェック
  #   - "AWS::Route53RecoveryReadiness::DNSTargetResource": DNS ターゲットリソース
  #   - "AWS::SQS::Queue": SQS キュー
  #   - "AWS::SNS::Topic": SNS トピック
  #   - "AWS::AutoScaling::AutoScalingGroup": Auto Scaling グループ
  # 注意: リソースセット内のすべてのリソースは同じタイプである必要があります
  # 関連機能: サポートされるリソースタイプ
  #   各リソースタイプには特定の準備状態チェックルールが適用されます。
  #   - https://docs.aws.amazon.com/r53recovery/latest/dg/recovery-readiness.resource-sets.html
  resource_set_type = "AWS::CloudWatch::Alarm"

  #-------------------------------------------------------------
  # リソース定義
  #-------------------------------------------------------------

  # resources (Required, Min: 1)
  # 設定内容: リソースセットに含めるリソースのリストを指定します。
  # 用途: 準備状態チェックの対象となるリソースを定義
  # 注意: 少なくとも1つのリソースが必要です
  resources {
    # resource_arn (Optional)
    # 設定内容: リソースのARNを指定します。
    # 設定可能な値: 有効なAWSリソースARN
    # 用途: 標準的なAWSリソース(CloudWatch Alarm、DynamoDB、EC2など)を指定
    # 注意: resource_arn または dns_target_resource のいずれかが必須
    # 関連機能: リソースARN指定
    #   ARNで直接リソースを指定する方式。ほとんどのAWSリソースで使用可能。
    #   - https://docs.aws.amazon.com/general/latest/gr/aws-arns-and-namespaces.html
    resource_arn = "arn:aws:cloudwatch:us-east-1:123456789012:alarm:example-alarm"

    # readiness_scopes (Optional)
    # 設定内容: このリソースが属する Recovery Group ARN または Cell ARN のリストを指定します。
    # 設定可能な値: Recovery Group または Cell のARNのリスト
    # 用途: リソースのスコープを特定のRecovery GroupまたはCellに限定
    # 関連機能: Readiness Scope
    #   リソースがどのRecovery GroupやCellに関連付けられているかを定義。
    #   マルチリージョン構成で使用されます。
    #   - https://docs.aws.amazon.com/r53recovery/latest/dg/recovery-readiness.resource-sets.html
    readiness_scopes = [
      "arn:aws:route53-recovery-readiness::123456789012:recovery-group/example-recovery-group"
    ]

    # component_id (Computed)
    # 設定内容: DNS Target Resources の一意の識別子
    # 注意: 自動生成される値のため、設定不要です
    # 用途: Readiness Check で参照する際に使用
  }

  #-------------------------------------------------------------
  # DNSターゲットリソースの例
  #-------------------------------------------------------------
  # Route53 レコードや Network Load Balancer を監視する場合の設定例

  resources {
    # dns_target_resource (Optional, Max: 1)
    # 設定内容: DNS/Routing Control Readiness Checks のコンポーネントを指定します。
    # 用途: Route53 レコードセットや NLB などのDNSベースのリソースを監視
    # 注意: resource_arn が設定されていない場合は必須
    dns_target_resource {
      # domain_name (Required)
      # 設定内容: アプリケーションへの入口となるDNS名を指定します。
      # 設定可能な値: 完全修飾ドメイン名 (FQDN)
      # 用途: 監視対象のドメイン名を指定
      # 関連機能: DNSターゲット
      #   アプリケーションのエンドポイントとなるドメイン名を定義。
      #   - https://docs.aws.amazon.com/r53recovery/latest/dg/recovery-readiness.resource-sets.html
      domain_name = "example.com"

      # hosted_zone_arn (Optional)
      # 設定内容: 指定されたドメイン名のDNSレコードを含むHosted Zone ARNを指定します。
      # 設定可能な値: Route53 Hosted Zone の ARN
      # 用途: Route53 でホストされるドメインの場合に指定
      # 関連機能: Route53 Hosted Zone
      #   DNSレコードが管理されているHosted Zoneを特定。
      #   - https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/hosted-zones-working-with.html
      hosted_zone_arn = "arn:aws:route53:::hostedzone/Z1234567890ABC"

      # record_set_id (Optional)
      # 設定内容: domain_name と record_type で一意にレコードを識別するための
      #           Route53 レコードセットIDを指定します。
      # 設定可能な値: Route53 レコードセットID
      # 用途: 同じドメイン名と同じレコードタイプが複数ある場合の識別
      # 関連機能: Route53 レコードセット
      #   レコードセットを一意に識別するためのID。
      #   - https://docs.aws.amazon.com/Route53/latest/APIReference/API_ResourceRecordSet.html
      record_set_id = "12345678-1234-1234-1234-123456789012"

      # record_type (Optional)
      # 設定内容: ターゲットリソースのDNSレコードタイプを指定します。
      # 設定可能な値:
      #   - "A": IPv4 アドレス
      #   - "AAAA": IPv6 アドレス
      #   - "CNAME": 正規名
      #   - "CAA": Certification Authority Authorization
      # 用途: DNSレコードのタイプを明示的に指定
      # 関連機能: DNSレコードタイプ
      #   Route53でサポートされるレコードタイプ。
      #   - https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/ResourceRecordTypes.html
      record_type = "A"

      # target_resource (Optional, Max: 1)
      # 設定内容: Route53 レコードが指し示すターゲットリソースを指定します。
      # 用途: DNS名前解決の最終的なターゲット(NLBまたはRoute53リソース)を定義
      target_resource {
        # nlb_resource (Optional, Max: 1)
        # 設定内容: DNSターゲットリソースが指し示すNetwork Load Balancer リソースを指定します。
        # 用途: NLBをターゲットとする場合に使用
        # 注意: r53_resource と nlb_resource は排他的 (どちらか一方のみ指定)
        nlb_resource {
          # arn (Required)
          # 設定内容: Network Load Balancer のARNを指定します。
          # 設定可能な値: 有効な NLB ARN
          # 用途: ターゲットとなるNLBを識別
          # 関連機能: Network Load Balancer
          #   高性能なLayer 4ロードバランサー。
          #   - https://docs.aws.amazon.com/elasticloadbalancing/latest/network/introduction.html
          arn = "arn:aws:elasticloadbalancing:us-east-1:123456789012:loadbalancer/net/example-nlb/1234567890abcdef"
        }

        # r53_resource (Optional, Max: 1)
        # 設定内容: DNSターゲットリソースレコードが指し示すRoute53リソースを指定します。
        # 用途: Route53リソースをターゲットとする場合に使用
        # 注意: r53_resource と nlb_resource は排他的 (どちらか一方のみ指定)
        # r53_resource {
        #   # domain_name (Optional)
        #   # 設定内容: ターゲットとなるドメイン名を指定します。
        #   # 設定可能な値: 完全修飾ドメイン名 (FQDN)
        #   # 用途: Route53エイリアスレコードのターゲットドメインを指定
        #   domain_name = "target.example.com"
        #
        #   # record_set_id (Optional)
        #   # 設定内容: ターゲットとなるリソースレコードセットIDを指定します。
        #   # 設定可能な値: Route53 レコードセットID
        #   # 用途: ターゲットレコードを一意に識別
        #   record_set_id = "87654321-4321-4321-4321-210987654321"
        # }
      }
    }
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
  #   コスト配分、リソース管理、アクセス制御に活用できます。
  #   - https://docs.aws.amazon.com/general/latest/gr/aws_tagging.html
  tags = {
    Name        = "example-resource-set"
    Environment = "production"
    Purpose     = "disaster-recovery"
  }

  # tags_all (Optional, Computed)
  # 設定内容: プロバイダーのdefault_tagsから継承されるタグを含む全タグのマップ
  # 注意: 通常は明示的に設定する必要はありません。Terraformが自動管理します
  tags_all = null

  # id (Optional, Computed)
  # 設定内容: リソースのID。通常はARNと同じ値
  # 注意: 通常は明示的に設定する必要はありません。Terraformが自動管理します
  id = null

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定します。
  # 用途: 大規模なリソースセットや複雑な構成での操作時間を調整
  timeouts {
    # delete (Optional)
    # 設定内容: 削除操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列 (例: "5m", "1h")
    # デフォルト: 5分
    # 用途: リソースセットの削除に時間がかかる場合に調整
    delete = "5m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: リソースセットのAmazon Resource Name (ARN)
#
# - resources.#.component_id: DNS Target Resources の一意の識別子。
#   Readiness Check で使用されます。
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#   リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------

#---------------------------------------------------------------
# resource "aws_route53recoveryreadiness_resource_set" "cloudwatch_alarms" {
#   resource_set_name = "cloudwatch-alarm-set"
#   resource_set_type = "AWS::CloudWatch::Alarm"
#
#   resources {
#     resource_arn = aws_cloudwatch_metric_alarm.example_us_east_1.arn
#     readiness_scopes = [
#       aws_route53recoveryreadiness_recovery_group.example.arn
#     ]
#   }
#---------------------------------------------------------------
