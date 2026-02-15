#---------------------------------------
# AWS DataSync NFS Location
#---------------------------------------
# Provider Version: 6.28.0
# Generated: 2026-02-14
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/datasync_location_nfs
#
# NOTE: DataSyncエージェント経由でアクセスするNFSサーバーのロケーション定義
#
# 主な用途:
# - オンプレミスNFSサーバーとAWS間のデータ同期
# - Network Attached Storage (NAS) デバイスからのデータ移行
# - 複数のDataSyncエージェントを使った高可用性構成
#
# 前提条件:
# - DataSyncエージェント（aws_datasync_agentリソース）が事前にデプロイされていること
# - NFSサーバーがエージェントから到達可能であること
# - 適切なNFSバージョンとマウントオプションが設定されていること
#
# 制限事項:
# - NFSロケーションはオンプレミス環境またはAWS上のNFSサーバーの両方に対応
# - NFSv3とNFSv4.0/4.1をサポート（デフォルトはAutomatic）
# - エージェントARNは最低1つ、最大4つまで指定可能
#---------------------------------------

resource "aws_datasync_location_nfs" "example" {
  #---------------------------------------
  # 必須パラメータ
  #---------------------------------------

  # 設定内容: NFSサーバーのホスト名またはIPアドレス
  # 形式: ホスト名またはIPv4/IPv6アドレス（FQDN推奨）
  # 注意: DNSで解決可能なホスト名、またはDataSyncエージェントから到達可能なIPアドレスを指定
  server_hostname = "nfs-server.example.com"

  # 設定内容: エクスポートされたNFSディレクトリのサブディレクトリパス
  # 形式: パスは / から始まる必要がある
  # 例: "/exports/data", "/mnt/nfs_share"
  # 注意: NFSサーバー上で実際にエクスポートされているパスを指定
  subdirectory = "/exports/data"

  #---------------------------------------
  # オンプレミス接続設定（必須ブロック）
  #---------------------------------------

  on_prem_config {
    # 設定内容: NFSサーバーへのアクセスに使用するDataSyncエージェントのARN一覧
    # 形式: ARNのセット（1～4個）
    # 高可用性: 複数エージェントを指定すると冗長性が向上
    # 注意: 全てのエージェントがNFSサーバーにアクセス可能である必要がある
    agent_arns = [
      "arn:aws:datasync:us-east-1:123456789012:agent/agent-01234567890abcdef",
    ]
  }

  #---------------------------------------
  # NFSマウントオプション
  #---------------------------------------

  mount_options {
    # 設定内容: 使用するNFSプロトコルバージョン
    # 設定可能な値:
    #   - AUTOMATIC: NFSサーバーがサポートする最高バージョンを自動選択（推奨）
    #   - NFS3: NFSバージョン3を使用
    #   - NFS4_0: NFSバージョン4.0を使用
    #   - NFS4_1: NFSバージョン4.1を使用
    # 省略時: AUTOMATIC（サーバー側の対応バージョンに応じて自動選択）
    # パフォーマンス: NFSv4.1が最も高速だが、サーバー対応状況により選択
    version = "AUTOMATIC"
  }

  #---------------------------------------
  # リージョン設定
  #---------------------------------------

  # 設定内容: リソースが管理されるAWSリージョン
  # 省略時: プロバイダー設定のリージョンを使用
  # 用途: マルチリージョン構成の場合に明示的にリージョンを指定
  region = "us-east-1"

  #---------------------------------------
  # タグ設定
  #---------------------------------------

  # 設定内容: リソース管理用のタグ
  # 用途: コスト配分、環境識別、運用管理
  tags = {
    Name        = "nfs-location-example"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

#---------------------------------------
# Attributes Reference（参照可能な属性）
#---------------------------------------
# arn          - ロケーションのAmazon Resource Name
# id           - リソース識別子（ARNと同値）
# uri          - NFSロケーションのURI（nfs://server_hostname/subdirectory形式）
# region       - リソースが管理されるリージョン
# tags_all     - デフォルトタグを含む全タグのマップ
#
# 出力例:
# output "nfs_location_arn" {
#   value = aws_datasync_location_nfs.example.arn
# }
# output "nfs_uri" {
#   value = aws_datasync_location_nfs.example.uri
# }
