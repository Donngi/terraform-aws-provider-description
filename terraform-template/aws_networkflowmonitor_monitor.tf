#---------------------------------------------------------------
# Amazon CloudWatch Network Flow Monitor - Monitor
#---------------------------------------------------------------
#
# Amazon CloudWatch Network Flow Monitorのモニターをプロビジョニングするリソースです。
# Network Flow Monitorは、AWS上のネットワークフローを監視し、VPCやワークロード間の
# ネットワーク通信のパフォーマンスと到達可能性に関するメトリクスを収集します。
# スコープ（監視対象リソースの集合）に関連付けてモニターを作成し、
# ローカルリソースとリモートリソース間のネットワークフローを可視化します。
#
# AWS公式ドキュメント:
#   - Network Flow Monitor概要: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch-NetworkFlowMonitor.html
#   - モニターの作成: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch-NetworkFlowMonitor-getting-started.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkflowmonitor_monitor
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_networkflowmonitor_monitor" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # monitor_name (Required)
  # 設定内容: モニターの名前を指定します。
  # 設定可能な値: 文字列（アカウント内で一意な名前）
  monitor_name = "example-monitor"

  # scope_arn (Required)
  # 設定内容: このモニターに関連付けるスコープのARNを指定します。
  #           スコープはNetwork Flow Monitorで監視対象となるリソースの集合を定義します。
  # 設定可能な値: 有効なaws_networkflowmonitor_scopeリソースのARN文字列
  scope_arn = "arn:aws:networkflowmonitor:ap-northeast-1:123456789012:scope/example-scope-id"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # ローカルリソース設定
  #-------------------------------------------------------------

  # local_resource (Optional)
  # 設定内容: モニター対象とするローカル側のネットワークリソースを指定するブロックです。
  #           ローカルリソースはネットワークフロー送信元または自ネットワーク内のリソースを表します。
  # 設定可能な値: 繰り返しブロック（複数指定可能）
  # 省略時: ローカルリソースの指定なし
  local_resource {

    # identifier (Required)
    # 設定内容: ローカルリソースの識別子（ARNまたはID）を指定します。
    # 設定可能な値: 有効なAWSリソースARNまたはリソースID文字列
    identifier = "arn:aws:ec2:ap-northeast-1:123456789012:instance/i-1234567890abcdef0"

    # type (Required)
    # 設定内容: ローカルリソースの種別を指定します。
    # 設定可能な値:
    #   - "AWS::EC2::Instance": EC2インスタンス
    #   - "AWS::ECS::TaskDefinition": ECSタスク定義
    #   - "AWS::EKS::Cluster": EKSクラスター
    #   - "AWS::NetworkInterface": ネットワークインターフェース
    type = "AWS::EC2::Instance"
  }

  #-------------------------------------------------------------
  # リモートリソース設定
  #-------------------------------------------------------------

  # remote_resource (Optional)
  # 設定内容: モニター対象とするリモート側のネットワークリソースを指定するブロックです。
  #           リモートリソースはネットワークフロー通信先または外部ネットワーク上のリソースを表します。
  # 設定可能な値: 繰り返しブロック（複数指定可能）
  # 省略時: リモートリソースの指定なし
  remote_resource {

    # identifier (Required)
    # 設定内容: リモートリソースの識別子（ARNまたはID）を指定します。
    # 設定可能な値: 有効なAWSリソースARNまたはリソースID文字列
    identifier = "arn:aws:ec2:ap-northeast-1:123456789012:instance/i-0fedcba9876543210"

    # type (Required)
    # 設定内容: リモートリソースの種別を指定します。
    # 設定可能な値:
    #   - "AWS::EC2::Instance": EC2インスタンス
    #   - "AWS::ECS::TaskDefinition": ECSタスク定義
    #   - "AWS::EKS::Cluster": EKSクラスター
    #   - "AWS::NetworkInterface": ネットワークインターフェース
    type = "AWS::EC2::Instance"
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  tags = {
    Name        = "example-networkflowmonitor"
    Environment = "production"
    ManagedBy   = "terraform"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定するブロックです。
  # 省略時: プロバイダーのデフォルトタイムアウトを使用
  timeouts {

    # create (Optional)
    # 設定内容: リソース作成のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "5m", "2h" 等のduration文字列（s=秒, m=分, h=時間）
    # 省略時: デフォルトタイムアウトを使用
    create = "30m"

    # update (Optional)
    # 設定内容: リソース更新のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "5m", "2h" 等のduration文字列（s=秒, m=分, h=時間）
    # 省略時: デフォルトタイムアウトを使用
    update = "30m"

    # delete (Optional)
    # 設定内容: リソース削除のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "5m", "2h" 等のduration文字列（s=秒, m=分, h=時間）
    # 省略時: デフォルトタイムアウトを使用
    delete = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - monitor_arn: モニターのAmazon Resource Name (ARN)
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
