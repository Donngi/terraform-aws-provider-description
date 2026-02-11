#---------------------------------------------------------------
# aws_networkflowmonitor_monitor
#---------------------------------------------------------------
#
# Amazon CloudWatch Network Flow Monitorのモニターリソースを作成します。
# Network Flow Monitorは、VPC内のネットワークフローに対してリアルタイムに近い
# パフォーマンスメトリクス（レイテンシ、パケットロス、再送信など）を提供する
# CloudWatch Network Monitoringの機能です。
# モニターを作成することで、特定のワークロード間のネットワークフローを監視し、
# ネットワークヘルスインジケーター（NHI）を通じてAWSネットワークの問題を特定できます。
#
# AWS公式ドキュメント:
#   - What is Network Flow Monitor?: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch-NetworkFlowMonitor-What-is-NetworkFlowMonitor.html
#   - Monitor and analyze network flows: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch-NetworkFlowMonitor-monitor-and-analyze.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkflowmonitor_monitor
#
# Provider Version: 6.28.0
# Generated: 2026-01-29
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_networkflowmonitor_monitor" "this" {
  #---------------------------------------------------------------
  # 必須引数 (Required Arguments)
  #---------------------------------------------------------------

  # monitor_name (必須, string)
  # モニターの名前を指定します。
  # 作成後に変更することはできません。
  # モニターを識別するための一意の名前を設定してください。
  monitor_name = "example-monitor"

  # scope_arn (必須, string)
  # モニターのスコープのAmazon Resource Name (ARN)を指定します。
  # スコープは、Network Flow Monitorがメトリクスを収集する範囲を定義します。
  # 作成後に変更することはできません。
  # aws_networkflowmonitor_scopeリソースで作成したスコープのARNを指定します。
  scope_arn = aws_networkflowmonitor_scope.example.scope_arn

  #---------------------------------------------------------------
  # オプション引数 (Optional Arguments)
  #---------------------------------------------------------------

  # region (オプション, string)
  # このリソースを管理するAWSリージョンを指定します。
  # 指定しない場合、プロバイダー設定のリージョンが使用されます。
  # マルチリージョン構成で特定のリージョンにリソースを作成する場合に使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "ap-northeast-1"

  # tags (オプション, map(string))
  # リソースに割り当てるタグのマップを指定します。
  # プロバイダーレベルで default_tags が設定されている場合、
  # 同じキーを持つタグはこの設定で上書きされます。
  # コスト管理やリソース整理のためにタグを活用してください。
  tags = {
    Name        = "example-monitor"
    Environment = "production"
  }

  #---------------------------------------------------------------
  # local_resource ブロック (オプション, set)
  # 監視対象のローカルリソースを指定します。
  # ローカルリソースは、Network Flow Monitorエージェントがインストールされている
  # ホストが存在するワークロードの場所です。
  # 複数のlocal_resourceブロックを指定できます。
  #---------------------------------------------------------------
  local_resource {
    # type (必須, string)
    # リソースのタイプを指定します。
    # 有効な値:
    #   - "AWS::EC2::VPC"              : VPC全体を監視
    #   - "AWS::EC2::Subnet"           : 特定のサブネットを監視
    #   - "AWS::EC2::AvailabilityZone" : 特定のアベイラビリティゾーンを監視
    #   - "AWS::EC2::Region"           : リージョン全体を監視
    #   - "AWS::EKS::Cluster"          : EKSクラスターを監視
    type = "AWS::EC2::VPC"

    # identifier (必須, string)
    # リソースの識別子を指定します。
    # VPCリソースの場合はVPCのARNを指定します。
    # 例: arn:aws:ec2:ap-northeast-1:123456789012:vpc/vpc-xxxxxxxxxxxxxxxxx
    identifier = aws_vpc.example.arn
  }

  #---------------------------------------------------------------
  # remote_resource ブロック (オプション, set)
  # 監視対象のリモートリソースを指定します。
  # リモートリソースは、ローカルリソースとのネットワークフローの
  # もう一方のエンドポイントです。
  # 複数のremote_resourceブロックを指定できます。
  #---------------------------------------------------------------
  remote_resource {
    # type (必須, string)
    # リソースのタイプを指定します。
    # 有効な値はlocal_resourceと同じです:
    #   - "AWS::EC2::VPC"
    #   - "AWS::EC2::Subnet"
    #   - "AWS::EC2::AvailabilityZone"
    #   - "AWS::EC2::Region"
    #   - "AWS::EKS::Cluster"
    type = "AWS::EC2::VPC"

    # identifier (必須, string)
    # リソースの識別子を指定します。
    # VPCリソースの場合はVPCのARNを指定します。
    identifier = aws_vpc.remote.arn
  }

  #---------------------------------------------------------------
  # timeouts ブロック (オプション)
  # 各操作のタイムアウト時間を指定します。
  # 値は "30s", "2h45m" などの形式で指定します。
  # 有効な時間単位: "s" (秒), "m" (分), "h" (時間)
  #---------------------------------------------------------------
  timeouts {
    # create (オプション, string)
    # リソース作成時のタイムアウト時間を指定します。
    # Network Flow Monitorの初期化に時間がかかる場合に調整します。
    # create = "30m"

    # update (オプション, string)
    # リソース更新時のタイムアウト時間を指定します。
    # update = "30m"

    # delete (オプション, string)
    # リソース削除時のタイムアウト時間を指定します。
    # 削除操作は、destroy操作が発生する前に変更がstateに保存されている
    # 場合にのみ適用されます。
    # delete = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (参照用属性)
# 以下の属性はリソース作成後にTerraformによって自動的に設定されます。
# これらは他のリソースから参照する際に使用できます。
#---------------------------------------------------------------

# monitor_arn (string)
# モニターのAmazon Resource Name (ARN)。
# 他のAWSサービスやIAMポリシーでこのモニターを参照する際に使用します。
# 例: aws_networkflowmonitor_monitor.this.monitor_arn

# tags_all (map(string))
# プロバイダーの default_tags で設定されたタグを含む、
# リソースに割り当てられた全てのタグのマップ。
# 例: aws_networkflowmonitor_monitor.this.tags_all
