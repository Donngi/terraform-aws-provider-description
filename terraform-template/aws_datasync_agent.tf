#---------------------------------------------------------------
# AWS DataSync エージェント
#---------------------------------------------------------------
#
# DataSyncがオンプレミスまたはエッジロケーションとAWS間でデータを転送するためのエージェントです。
# VMware、Hyper-V、Linux KVMなどの仮想化環境にデプロイして使用します。
# PrivateLinkまたはパブリックエンドポイント経由でDataSyncサービスに接続可能です。
#
# AWS公式ドキュメント:
#   - DataSync Agent概要: https://docs.aws.amazon.com/datasync/latest/userguide/agent.html
#   - エージェントのデプロイ: https://docs.aws.amazon.com/datasync/latest/userguide/deploy-agents.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/datasync_agent
#
# Provider Version: 6.28.0
# Generated: 2026-02-13
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_datasync_agent" "example" {
  #---------------------------------------
  # エージェント登録設定
  #---------------------------------------
  # 設定内容: エージェントのアクティベーションキー
  # アクティベーションキーはDataSyncコンソールまたはCLIで生成
  # ip_addressとの併用不可、いずれか一方を指定
  activation_key = "ABCDE-12345-FGHIJ-67890-KLMNO"

  # 設定内容: エージェントのIPアドレス
  # エージェントVM上で取得可能なIPアドレスを指定
  # activation_keyとの併用不可、いずれか一方を指定
  # 省略時: activation_keyが使用される
  ip_address = "10.0.1.100"

  #---------------------------------------
  # エージェント識別設定
  #---------------------------------------
  # 設定内容: エージェントの名前
  # AWSコンソールで表示される識別名
  # 省略時: 自動生成された名前が付与される
  name = "on-premises-datasync-agent"

  #---------------------------------------
  # PrivateLink接続設定
  #---------------------------------------
  # 設定内容: DataSyncサービスのVPCエンドポイントID
  # PrivateLinkを使用してプライベート接続する場合に指定
  # 省略時: パブリックエンドポイント経由で接続
  vpc_endpoint_id = "vpce-0123456789abcdef0"

  # 設定内容: VPCエンドポイント用のサブネットARNのセット
  # PrivateLink経由での接続時に必要
  # 最小1個、最大4個のサブネットを指定可能
  # 省略時: パブリックエンドポイント経由で接続
  subnet_arns = [
    "arn:aws:ec2:us-west-2:123456789012:subnet/subnet-0123456789abcdef0",
    "arn:aws:ec2:us-west-2:123456789012:subnet/subnet-fedcba9876543210f"
  ]

  # 設定内容: VPCエンドポイント用のセキュリティグループARNのセット
  # PrivateLink経由での接続時に必要
  # エージェントからのアウトバウンド通信を許可する設定が必要
  # 省略時: パブリックエンドポイント経由で接続
  security_group_arns = [
    "arn:aws:ec2:us-west-2:123456789012:security-group/sg-0123456789abcdef0"
  ]

  # 設定内容: PrivateLinkエンドポイントのFQDN
  # PrivateLink経由でDataSyncサービスに接続する際のエンドポイント
  # 通常はvpc_endpoint_idから自動設定される
  # 省略時: vpc_endpoint_idから自動的に解決
  private_link_endpoint = "vpce-0123456789abcdef0-abcd1234.datasync.us-west-2.vpce.amazonaws.com"

  #---------------------------------------
  # リージョン設定
  #---------------------------------------
  # 設定内容: エージェントを管理するAWSリージョン
  # エージェント自体はオンプレミスにデプロイされるが、管理リージョンを指定
  # 省略時: プロバイダーのデフォルトリージョン
  region = "us-west-2"

  #---------------------------------------
  # タグ設定
  #---------------------------------------
  # 設定内容: リソースに付与するタグのマップ
  # エージェントの管理や分類に使用
  # 省略時: タグなし
  tags = {
    Name        = "on-premises-datasync-agent"
    Environment = "production"
    Location    = "datacenter-tokyo"
  }

  #---------------------------------------
  # タイムアウト設定
  #---------------------------------------
  timeouts {
    # 設定内容: エージェント作成のタイムアウト時間
    # エージェントのアクティベーション完了までの待機時間
    # 省略時: 10分
    create = "10m"
  }
}

#---------------------------------------
# Attributes Reference（参照可能な属性）
#---------------------------------------
# 以下の属性がリソース作成後に参照可能:
#
# id                      - エージェントID（例: agent-0123456789abcdef0）
# arn                     - エージェントのARN
# tags_all                - デフォルトタグを含む全タグのマップ
# activation_key          - 使用されたアクティベーションキー（指定時）
# ip_address              - エージェントのIPアドレス（指定時または検出値）
# private_link_endpoint   - 解決されたPrivateLinkエンドポイントFQDN
# region                  - エージェントが管理されているリージョン
#
# 参照例:
# output "agent_id" {
#   value = aws_datasync_agent.example.id
# }
# output "agent_arn" {
#   value = aws_datasync_agent.example.arn
# }
