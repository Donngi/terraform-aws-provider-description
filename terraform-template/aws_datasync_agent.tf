# ================================================================================
# Terraform AWS DataSync Agent Resource Template
# ================================================================================
# Generated: 2026-01-19
# Provider Version: hashicorp/aws 6.28.0
#
# 注意:
# - このテンプレートは生成時点(2026-01-19)の情報に基づいています
# - 最新の仕様や詳細については、必ず公式ドキュメントをご確認ください
# - AWS Provider公式ドキュメント: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/datasync_agent
# ================================================================================

resource "aws_datasync_agent" "example" {
  # ========================================
  # Agent Activation Configuration
  # ========================================
  # activation_key - (オプション) DataSync Agentのアクティベーションキー
  # リソース作成時にAgentをアクティベートするために使用します
  # ip_addressと競合するため、どちらか一方のみを指定してください
  # ip_addressを指定した場合、Terraformが自動的にactivation_keyを取得します
  #
  # 注意:
  # - Agentのアクティベーション時に必須（activation_keyまたはip_addressのいずれか）
  # - リソースインポート時には不要
  #
  # 参考: https://docs.aws.amazon.com/datasync/latest/userguide/activate-agent.html
  # Type: string
  # Default: なし（computedのため、ip_address指定時は自動取得）
  activation_key = "ABCDE-12345-ABCDE-12345-ABCDE"

  # ip_address - (オプション) DataSync AgentのIPアドレス
  # リソース作成時にアクティベーションキーを取得するために使用します
  # activation_keyと競合するため、どちらか一方のみを指定してください
  #
  # 要件:
  # - TerraformがこのIPアドレスに対してHTTP（ポート80）GETリクエストを実行できる必要があります
  # - Agentはアクティベーション完了後、HTTPサーバーを自動的に停止します
  #
  # 注意:
  # - Agentのアクティベーション時に必須（activation_keyまたはip_addressのいずれか）
  # - リソースインポート時には不要
  #
  # 参考: https://docs.aws.amazon.com/datasync/latest/userguide/activate-agent.html
  # Type: string
  # Default: なし（computedのため省略可能）
  ip_address = "192.168.1.100"

  # name - (オプション) DataSync Agentの名前
  # Agent識別のための人間が読みやすい名前を指定します
  #
  # ベストプラクティス:
  # - 環境やロケーションを識別できる命名規則を使用
  # - 例: "prod-onprem-datasync-agent", "dev-vpc-agent"
  #
  # Type: string
  # Default: なし
  name = "example-datasync-agent"

  # ========================================
  # VPC Endpoint Configuration
  # ========================================
  # private_link_endpoint - (オプション) VPCエンドポイントのIPアドレス
  # リソース作成時にアクティベーションキーを取得する際に、AgentがVPCエンドポイント経由で
  # 接続する場合に指定します
  # activation_keyと競合するため、activation_keyを使用する場合は指定不可
  #
  # 用途:
  # - VPCサービスエンドポイント経由でDataSyncサービスに接続する場合
  # - インターネットアクセスなしでAgentをアクティベートする場合
  #
  # 参考: https://docs.aws.amazon.com/datasync/latest/userguide/choose-service-endpoint.html
  # Type: string
  # Default: なし（computedのため省略可能）
  private_link_endpoint = "10.0.1.50"

  # vpc_endpoint_id - (オプション) VPCエンドポイントのID
  # Agentがアクセス可能なVPC（Virtual Private Cloud）エンドポイントのIDを指定します
  #
  # 用途:
  # - VPCサービスエンドポイント経由でDataSyncに接続する場合
  # - プライベートネットワーク内でのデータ転送を実現
  #
  # 形式: vpce-xxxxxxxxxxxxxxxxx（17文字）
  #
  # 参考: https://docs.aws.amazon.com/datasync/latest/userguide/choose-service-endpoint.html
  # Type: string
  # Default: なし
  vpc_endpoint_id = "vpce-0123456789abcdef0"

  # ========================================
  # Network Configuration
  # ========================================
  # security_group_arns - (オプション) セキュリティグループのARNセット
  # データ転送タスクのサブネットを保護するために使用されるセキュリティグループのARNを指定します
  #
  # 用途:
  # - VPCエンドポイント経由でDataSyncを使用する場合のネットワークアクセス制御
  # - Elastic Network Interface（ENI）に適用されるセキュリティルールの定義
  #
  # 要件:
  # - DataSyncがVPCエンドポイントにアクセスできるよう適切なルールを設定
  # - 通常、アウトバウンドトラフィックをDataSyncサービスに許可
  #
  # 参考: https://docs.aws.amazon.com/datasync/latest/userguide/API_PrivateLinkConfig.html
  # Type: set(string)
  # Default: なし
  security_group_arns = [
    "arn:aws:ec2:us-east-1:123456789012:security-group/sg-0123456789abcdef0",
    "arn:aws:ec2:us-east-1:123456789012:security-group/sg-abcdef0123456789a"
  ]

  # subnet_arns - (オプション) サブネットのARNセット
  # DataSyncが各データ転送タスクのためにElastic Network Interface（ENI）を作成する
  # サブネットのARNを指定します
  #
  # 用途:
  # - VPCエンドポイント経由でDataSyncを使用する場合のネットワーク配置
  # - データ転送のためのプライベートIPアドレス割り当て
  #
  # 要件:
  # - サブネットはVPCエンドポイントと同じVPC内に存在する必要があります
  # - 十分なIPアドレスが利用可能であること
  #
  # 参考: https://docs.aws.amazon.com/datasync/latest/userguide/API_PrivateLinkConfig.html
  # Type: set(string)
  # Default: なし
  subnet_arns = [
    "arn:aws:ec2:us-east-1:123456789012:subnet/subnet-0123456789abcdef0",
    "arn:aws:ec2:us-east-1:123456789012:subnet/subnet-abcdef0123456789a"
  ]

  # ========================================
  # Region Configuration
  # ========================================
  # region - (オプション) リソースが管理されるAWSリージョン
  # このリソースを管理するAWSリージョンを明示的に指定します
  #
  # デフォルト動作:
  # - 指定がない場合、プロバイダー設定のリージョンが使用されます
  #
  # 用途:
  # - マルチリージョン構成でリソースごとに異なるリージョンを指定する場合
  #
  # 参考:
  # - https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#aws-configuration-reference
  # Type: string
  # Default: プロバイダー設定のリージョン（computedのため省略可能）
  region = "us-east-1"

  # ========================================
  # Tagging
  # ========================================
  # tags - (オプション) リソースタグ
  # DataSync Agentに割り当てるキー・バリューペアのタグを指定します
  #
  # 用途:
  # - リソースの分類、コスト配分、アクセス制御
  # - 運用管理の効率化
  #
  # 注意:
  # - provider default_tags設定ブロックが存在する場合、同じキーのタグは上書きされます
  #
  # 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  # Type: map(string)
  # Default: なし
  tags = {
    Name        = "example-datasync-agent"
    Environment = "production"
    ManagedBy   = "terraform"
    Purpose     = "data-migration"
  }

  # tags_all - (オプション) 全タグのマップ（プロバイダーのdefault_tags含む）
  # リソースに割り当てられた全てのタグ（プロバイダーのdefault_tags設定ブロックから
  # 継承されたタグを含む）
  #
  # 注意:
  # - このプロパティはcomputed属性であり、通常は明示的に指定する必要はありません
  # - プロバイダーのdefault_tagsと個別のtagsが自動的にマージされます
  #
  # 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  # Type: map(string)
  # Default: プロバイダーのdefault_tagsとtags（computedのため通常省略）
  # tags_all は computed 属性のため、通常は指定不要

  # id - (オプション) リソースID
  # DataSync AgentのAmazon Resource Name (ARN)
  #
  # 注意:
  # - このプロパティはcomputed属性であり、通常Terraform設定で明示的に指定する必要はありません
  # - リソース作成後、自動的にARN値が設定されます
  # - インポート時にはこの値を使用してリソースを特定します
  #
  # Type: string
  # Default: なし（computedのため自動設定）
  # id は computed 属性のため、通常は指定不要

  # ========================================
  # Timeouts Configuration
  # ========================================
  # timeouts - (オプション) タイムアウト設定
  # リソース操作のタイムアウト時間を設定します
  timeouts {
    # create - (オプション) リソース作成時のタイムアウト
    # DataSync Agentのアクティベーションと作成にかかる最大時間を指定します
    #
    # デフォルト: 10分
    # 推奨: ネットワーク状況に応じて調整
    #
    # 形式: "10m", "1h" など（h=時間、m=分、s=秒）
    # Type: string
    # Default: "10m"
    create = "10m"
  }
}

# ================================================================================
# Computed Attributes (出力専用属性)
# ================================================================================
# 以下の属性は computed のみで、リソース作成後に自動的に設定されます。
# Terraform設定で値を指定することはできません。
#
# - arn: (string) DataSync AgentのAmazon Resource Name (ARN)
#        リソース作成後に自動的に割り当てられます
#        形式: arn:aws:datasync:region:account-id:agent/agent-id
#
# 使用例:
# output "agent_arn" {
#   value = aws_datasync_agent.example.arn
# }
# ================================================================================

# ================================================================================
# 使用上の注意事項
# ================================================================================
# 1. Agent Activation:
#    - activation_key または ip_address のいずれか一方を必ず指定してください
#    - ip_address を使用する場合、Terraformから該当IPアドレスのポート80への
#      HTTPアクセスが可能である必要があります
#
# 2. VPC Endpoint 使用時:
#    - vpc_endpoint_id, security_group_arns, subnet_arns を併せて設定
#    - private_link_endpoint を使用する場合、activation_key は使用不可
#
# 3. Network Requirements:
#    - Agent展開環境からAWSサービスへのネットワーク接続を確保
#    - 公開エンドポイント、FIPS、VPC、FIPS VPCエンドポイントから選択可能
#
# 4. Agent Deployment:
#    - サポートされるハイパーバイザー: VMware ESXi, KVM, Microsoft Hyper-V, Amazon EC2
#    - 必要リソース: 仮想プロセッサ4個、ディスク80GB、RAM 32GB（Basic mode）
#
# 参考資料:
# - Agent Requirements: https://docs.aws.amazon.com/datasync/latest/userguide/agent-requirements.html
# - Agent Activation: https://docs.aws.amazon.com/datasync/latest/userguide/activate-agent.html
# - Service Endpoints: https://docs.aws.amazon.com/datasync/latest/userguide/choose-service-endpoint.html
# - CreateAgent API: https://docs.aws.amazon.com/datasync/latest/userguide/API_CreateAgent.html
# ================================================================================
