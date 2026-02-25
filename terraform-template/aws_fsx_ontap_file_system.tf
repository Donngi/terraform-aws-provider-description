#---------------------------------------
# Amazon FSx for NetApp ONTAP ファイルシステム
#---------------------------------------
# Provider Version: 6.28.0
# Generated: 2026-02-17
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/fsx_ontap_file_system
#
# NOTE:
# FSx for NetApp ONTAPファイルシステムを作成・管理します。
# エンタープライズグレードのファイルストレージとデータ管理機能を提供し、
# マルチプロトコル（NFS、SMB、iSCSI）対応のストレージソリューションを構築できます。
#
# 主な用途:
# - エンタープライズアプリケーション向けの高性能ファイルストレージ
# - データベースやVMwareワークロード向けのストレージ
# - マルチプロトコル対応のファイル共有環境
# - SnapMirrorを利用したディザスタリカバリ構成
#
# 参考: https://docs.aws.amazon.com/fsx/latest/ONTAPGuide/what-is-fsx-ontap.html

#-------
# 基本設定
#-------

resource "aws_fsx_ontap_file_system" "example" {
  #-------
  # デプロイメント設定（必須）
  #-------

  # デプロイメントタイプ
  # 設定内容: ファイルシステムの可用性構成
  # 設定可能な値:
  #   - MULTI_AZ_1: 第1世代マルチAZ構成（高可用性）
  #   - MULTI_AZ_2: 第2世代マルチAZ構成（高可用性・高スループット）
  #   - SINGLE_AZ_1: 第1世代シングルAZ構成
  #   - SINGLE_AZ_2: 第2世代シングルAZ構成（最大12 HAペア対応）
  # 省略時: なし（必須項目）
  deployment_type = "MULTI_AZ_1"

  # ストレージ容量（GiB）
  # 設定内容: ファイルシステムの総ストレージ容量
  # 設定可能な値:
  #   - SINGLE_AZ_1/MULTI_AZ_1: 1024～196608 GiB
  #   - MULTI_AZ_2: 1024～524288 GiB
  #   - SINGLE_AZ_2: 1024～1048576 GiB（HAペア数により上限が変動）
  # 省略時: なし（必須項目）
  storage_capacity = 1024

  # サブネットID
  # 設定内容: ファイルシステムがアクセス可能なサブネットのIDリスト
  # 設定可能な値: 最大2つのサブネットID（マルチAZの場合は2つ、シングルAZの場合は1つ）
  # 省略時: なし（必須項目）
  subnet_ids = ["subnet-12345678", "subnet-87654321"]

  # 優先サブネットID
  # 設定内容: プライマリファイルサーバーを配置するサブネットID
  # 設定可能な値: subnet_idsに含まれるサブネットID
  # 省略時: なし（必須項目）
  preferred_subnet_id = "subnet-12345678"

  #-------
  # パフォーマンス設定
  #-------

  # スループット容量（MBps）
  # 設定内容: ファイルシステム全体のスループット容量
  # 設定可能な値: 128、256、512、1024、2048、4096 MBps
  # 省略時: なし（throughput_capacity_per_ha_pairと排他、どちらか必須）
  # 注意: ha_pairs未指定時に使用
  throughput_capacity = 512

  # HAペアあたりのスループット容量（MBps）
  # 設定内容: 各HAペアのスループット容量
  # 設定可能な値:
  #   - MULTI_AZ_1/SINGLE_AZ_1: 128、256、512、1024、2048、4096 MBps
  #   - MULTI_AZ_2/SINGLE_AZ_2（HAペア=1）: 384、768、1536、3072、6144 MBps
  #   - SINGLE_AZ_2（HAペア>1）: 1536、3072、6144 MBps
  # 省略時: なし（throughput_capacityと排他、どちらか必須）
  # 注意: ha_pairs指定時に使用
  throughput_capacity_per_ha_pair = 384

  # HAペア数
  # 設定内容: デプロイするHAペアの数
  # 設定可能な値:
  #   - SINGLE_AZ_1/MULTI_AZ_1/MULTI_AZ_2: 1（固定）
  #   - SINGLE_AZ_2: 1～12
  # 省略時: デプロイメントタイプのデフォルト値
  ha_pairs = 1

  # ストレージタイプ
  # 設定内容: ファイルシステムのストレージタイプ
  # 設定可能な値: SSD
  # 省略時: SSD
  storage_type = "SSD"

  #-------
  # ネットワーク設定
  #-------

  # セキュリティグループID
  # 設定内容: ファイルシステムアクセス用ネットワークインターフェイスに適用するセキュリティグループ
  # 設定可能な値: セキュリティグループIDのリスト
  # 省略時: VPCのデフォルトセキュリティグループ
  security_group_ids = ["sg-12345678"]

  # エンドポイントIPアドレス範囲
  # 設定内容: ファイルシステムエンドポイントが作成されるIPアドレス範囲（CIDR）
  # 設定可能な値: 198.19.0.0/16の範囲内のCIDRブロック
  # 省略時: AWSが自動的に選択（198.19.*）
  # 注意: WorkSpacesやAppStream 2.0の管理ネットワークと競合する可能性あり
  endpoint_ip_address_range = "198.19.250.0/24"

  # ルートテーブルID
  # 設定内容: ファイルシステムエンドポイントを作成するVPCルートテーブルのIDリスト
  # 設定可能な値: VPCルートテーブルIDのリスト
  # 省略時: VPCのデフォルトルートテーブル
  route_table_ids = ["rtb-12345678"]

  #-------
  # バックアップ設定
  #-------

  # 自動バックアップ保持日数
  # 設定内容: 自動バックアップの保持期間
  # 設定可能な値: 0～90日（0で自動バックアップ無効化）
  # 省略時: 0（自動バックアップなし）
  automatic_backup_retention_days = 7

  # 日次自動バックアップ開始時刻
  # 設定内容: 日次自動バックアップを実行する時刻（UTC）
  # 設定可能な値: HH:MM形式（例: 05:00）
  # 省略時: AWSが自動選択
  # 注意: automatic_backup_retention_daysの設定が必要
  daily_automatic_backup_start_time = "05:00"

  # 週次メンテナンス開始時刻
  # 設定内容: 週次メンテナンスウィンドウの開始時刻（UTC）
  # 設定可能な値: d:HH:MM形式（d=曜日1-7、HH=時00-23、MM=分00-59）
  # 省略時: AWSが自動選択
  weekly_maintenance_start_time = "1:05:00"

  #-------
  # セキュリティ設定
  #-------

  # KMSキーID
  # 設定内容: 保存時の暗号化に使用するKMSキーのARN
  # 設定可能な値: KMSキーARN
  # 省略時: AWS管理のKMSキー
  kms_key_id = "arn:aws:kms:us-west-2:123456789012:key/abcd1234-a123-456a-a12b-a123b4cd56ef"

  # FSx管理者パスワード
  # 設定内容: fsxadminユーザーのパスワード（ONTAP CLIおよびREST API用）
  # 設定可能な値: 8～50文字の英数字記号
  # 省略時: AWSが自動生成
  # 注意: 機密情報のためTerraformの外部で管理推奨
  fsx_admin_password = var.fsx_admin_password

  #-------
  # ディスクIOPS設定
  #-------

  # disk_iops_configuration {
  #   # IOPSモード
  #   # 設定内容: ディスクIOPSのプロビジョニングモード
  #   # 設定可能な値:
  #   #   - AUTOMATIC: 自動的にIOPSを管理
  #   #   - USER_PROVISIONED: ユーザーが手動でIOPSを指定
  #   # 省略時: AUTOMATIC
  #   mode = "AUTOMATIC"

  #   # プロビジョンドIOPS
  #   # 設定内容: ファイルシステムのSSD IOPS総数
  #   # 設定可能な値: ストレージ容量とデプロイメントタイプに依存
  #   # 省略時: modeがAUTOMATICの場合は自動計算、USER_PROVISIONEDの場合は必須
  #   # 注意: mode = "USER_PROVISIONED"の場合に指定
  #   # iops = 3000
  # }

  #-------
  # リージョン設定
  #-------

  # リージョン
  # 設定内容: リソースを管理するAWSリージョン
  # 設定可能な値: AWSリージョンコード（us-west-2、ap-northeast-1など）
  # 省略時: プロバイダー設定のリージョン
  region = "us-west-2"

  #-------
  # タグ設定
  #-------

  # タグ
  # 設定内容: ファイルシステムに付与するタグのマップ
  # 設定可能な値: キーと値のペア
  # 省略時: タグなし
  tags = {
    Name        = "example-ontap-filesystem"
    Environment = "production"
  }

  #-------
  # タイムアウト設定
  #-------

  # timeouts {
  #   # 作成タイムアウト
  #   # 設定内容: リソース作成の最大待機時間
  #   # 設定可能な値: 時間文字列（例: 60m、2h）
  #   # 省略時: デフォルトタイムアウト
  #   # create = "60m"

  #   # 更新タイムアウト
  #   # 設定内容: リソース更新の最大待機時間
  #   # 設定可能な値: 時間文字列（例: 60m、2h）
  #   # 省略時: デフォルトタイムアウト
  #   # update = "60m"

  #   # 削除タイムアウト
  #   # 設定内容: リソース削除の最大待機時間
  #   # 設定可能な値: 時間文字列（例: 60m、2h）
  #   # 省略時: デフォルトタイムアウト
  #   # delete = "60m"
  # }
}

#---------------------------------------
# Attributes Reference（参照専用属性）
#---------------------------------------
# このリソースでは以下の属性が参照可能です:
#
# - arn: ファイルシステムのAmazon Resource Name
# - dns_name: ファイルシステムのDNS名（ONTAPではSVM経由でアクセスするため未設定）
# - endpoints: ONTAPの管理・データアクセス用エンドポイント情報
#   - intercluster: SnapMirror用のクラスタ間エンドポイント
#   - management: ONTAP CLI/API管理用エンドポイント
# - id: ファイルシステムの識別子（例: fs-12345678）
# - network_interface_ids: ファイルシステムアクセス用のENIのIDリスト
# - owner_id: ファイルシステムを作成したAWSアカウントID
# - tags_all: リソースに割り当てられた全タグ（プロバイダーのdefault_tags含む）
# - vpc_id: ファイルシステムが所属するVPCの識別子
