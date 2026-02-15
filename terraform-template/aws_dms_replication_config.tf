#---------------------------------------
# AWS DMS Replication Config
#---------------------------------------
# DMS Serverlessレプリケーション設定を管理するリソース
# 従来のレプリケーションインスタンスベースのアプローチに代わる、
# サーバーレス型のデータ移行・レプリケーション機能を提供
#
# Provider Version: 6.28.0
# Generated: 2026-02-14
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/dms_replication_config
#
# NOTE: このテンプレートはプロバイダースキーマv6.28.0から自動生成されており、
#       実際の使用時は環境に応じて不要なパラメータを削除してください

resource "aws_dms_replication_config" "example" {
  #---------------------------------------
  # 基本設定
  #---------------------------------------
  # レプリケーション設定の識別子
  # 設定内容: レプリケーション設定を一意に識別する名前
  # 設定可能な値: 英数字、ハイフン、アンダースコア
  # 必須パラメータ
  replication_config_identifier = "my-replication-config"

  # レプリケーションタイプ
  # 設定内容: 実行するレプリケーションの種類
  # 設定可能な値:
  #   - full-load: 全データを一度だけコピー
  #   - cdc: 変更データキャプチャ（継続的な変更のみ）
  #   - full-load-and-cdc: 全データコピー後、継続的な変更をキャプチャ
  # 必須パラメータ
  replication_type = "full-load-and-cdc"

  #---------------------------------------
  # エンドポイント設定
  #---------------------------------------
  # ソースエンドポイントARN
  # 設定内容: データソースとなるDMSエンドポイントのARN
  # 参考リソース: aws_dms_endpoint
  # 必須パラメータ
  source_endpoint_arn = "arn:aws:dms:us-east-1:123456789012:endpoint:ABCDEFGHIJKLMNOPQRSTUVWXYZ"

  # ターゲットエンドポイントARN
  # 設定内容: データ移行先となるDMSエンドポイントのARN
  # 参考リソース: aws_dms_endpoint
  # 必須パラメータ
  target_endpoint_arn = "arn:aws:dms:us-east-1:123456789012:endpoint:ZYXWVUTSRQPONMLKJIHGFEDCBA"

  #---------------------------------------
  # テーブルマッピング設定
  #---------------------------------------
  # テーブルマッピング
  # 設定内容: レプリケーション対象のテーブルとスキーマを定義するJSON文字列
  # 設定形式: selection-rules、transformation-rulesを含むJSON
  # 必須パラメータ
  table_mappings = jsonencode({
    rules = [
      {
        rule-type = "selection"
        rule-id   = "1"
        rule-name = "1"
        object-locator = {
          schema-name = "public"
          table-name  = "%"
        }
        rule-action = "include"
      }
    ]
  })

  #---------------------------------------
  # コンピューティング設定
  #---------------------------------------
  compute_config {
    # レプリケーションサブネットグループID
    # 設定内容: レプリケーションインスタンスを配置するサブネットグループ
    # 参考リソース: aws_dms_replication_subnet_group
    # 必須パラメータ
    replication_subnet_group_id = "my-replication-subnet-group"

    # 最小容量ユニット
    # 設定内容: レプリケーション処理に割り当てる最小容量（DCU）
    # 設定可能な値: 1以上の整数
    # 省略時: DMSのデフォルト値が適用
    min_capacity_units = 2

    # 最大容量ユニット
    # 設定内容: レプリケーション処理に割り当てる最大容量（DCU）
    # 設定可能な値: min_capacity_units以上の整数
    # 省略時: DMSのデフォルト値が適用
    max_capacity_units = 16

    # VPCセキュリティグループID
    # 設定内容: レプリケーションインスタンスに適用するセキュリティグループ
    # 設定可能な値: セキュリティグループIDのリスト
    # 省略時: デフォルトのセキュリティグループが適用
    vpc_security_group_ids = ["sg-0123456789abcdef0"]

    # マルチAZ配置
    # 設定内容: 高可用性のためのマルチAZ配置の有効化
    # 設定可能な値: true（有効）、false（無効）
    # 省略時: false（シングルAZ）
    multi_az = false

    # アベイラビリティーゾーン
    # 設定内容: レプリケーションインスタンスを配置する優先AZ
    # 設定可能な値: 有効なAZ名（例: us-east-1a）
    # 省略時: 自動選択
    # availability_zone = "us-east-1a"

    # KMSキーID
    # 設定内容: レプリケーションデータの暗号化に使用するKMSキー
    # 設定可能な値: KMSキーID、ARN、エイリアス
    # 省略時: AWS管理キーを使用
    # kms_key_id = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"

    # 優先メンテナンスウィンドウ
    # 設定内容: システムメンテナンスを実施する時間帯
    # 設定可能な値: ddd:hh24:mi-ddd:hh24:mi形式（UTC）
    # 省略時: 自動選択
    # preferred_maintenance_window = "sun:05:00-sun:06:00"

    # DNSネームサーバー
    # 設定内容: カスタムDNSサーバーのIPアドレス
    # 設定可能な値: カンマ区切りのIPアドレスリスト
    # 省略時: VPCのDNSサーバーを使用
    # dns_name_servers = "10.0.0.2,10.0.1.2"
  }

  #---------------------------------------
  # レプリケーション設定（詳細）
  #---------------------------------------
  # レプリケーション設定
  # 設定内容: レプリケーションタスクの詳細設定（JSON形式）
  # 設定項目例: ログ設定、エラーハンドリング、パフォーマンスチューニング
  # 省略時: DMSのデフォルト設定が適用
  replication_settings = jsonencode({
    TargetMetadata = {
      TargetSchema       = ""
      SupportLobs        = true
      FullLobMode        = false
      LobChunkSize       = 0
      LimitedSizeLobMode = true
      LobMaxSize         = 32
    }
    FullLoadSettings = {
      TargetTablePrepMode              = "DROP_AND_CREATE"
      CreatePkAfterFullLoad            = false
      StopTaskCachedChangesApplied     = false
      StopTaskCachedChangesNotApplied  = false
      MaxFullLoadSubTasks              = 8
      TransactionConsistencyTimeout    = 600
      CommitRate                       = 10000
    }
  })

  # 補足設定
  # 設定内容: エンジン固有の追加設定（JSON形式）
  # 設定項目例: Oracleのアーカイブログ設定、MySQLのバイナリログ設定
  # 省略時: デフォルト設定が適用
  supplemental_settings = jsonencode({
    BatchApplyEnabled   = true
    ParallelLoadThreads = 8
  })

  #---------------------------------------
  # レプリケーション制御
  #---------------------------------------
  # レプリケーション自動開始
  # 設定内容: リソース作成時にレプリケーションを自動開始
  # 設定可能な値: true（自動開始）、false（手動開始）
  # 省略時: false（手動開始が必要）
  start_replication = false

  #---------------------------------------
  # リージョン設定
  #---------------------------------------
  # リージョン
  # 設定内容: リソースを管理するAWSリージョン
  # 設定可能な値: 有効なAWSリージョン名
  # 省略時: プロバイダー設定のリージョンを使用
  region = "us-east-1"

  # リソース識別子
  # 設定内容: カスタムリソース識別子（内部管理用）
  # 設定可能な値: 英数字、ハイフン、アンダースコア
  # 省略時: replication_config_identifierと同じ値を使用
  resource_identifier = "custom-identifier"

  #---------------------------------------
  # タグ設定
  #---------------------------------------
  # タグ
  # 設定内容: リソースに付与する任意のタグ
  # 設定可能な値: キー・バリューペアのマップ
  # 省略時: タグなし
  tags = {
    Name        = "my-replication-config"
    Environment = "production"
    ManagedBy   = "terraform"
  }

  # 全タグ
  # 設定内容: プロバイダーレベルのdefault_tagsと統合された全タグ
  # 省略時: tagsとdefault_tagsをマージした値が自動設定
  # 通常は設定不要（Terraform管理）
  # tags_all = {}

  #---------------------------------------
  # タイムアウト設定
  #---------------------------------------
  timeouts {
    # 作成タイムアウト
    # 設定内容: リソース作成時の最大待機時間
    # 設定可能な値: 時間文字列（例: "30m", "1h"）
    # 省略時: 30m
    # create = "30m"

    # 更新タイムアウト
    # 設定内容: リソース更新時の最大待機時間
    # 設定可能な値: 時間文字列（例: "30m", "1h"）
    # 省略時: 30m
    # update = "30m"

    # 削除タイムアウト
    # 設定内容: リソース削除時の最大待機時間
    # 設定可能な値: 時間文字列（例: "30m", "1h"）
    # 省略時: 30m
    # delete = "30m"
  }
}

#---------------------------------------
# Attributes Reference
#---------------------------------------
# arn - レプリケーション設定のARN
# id - レプリケーション設定の識別子（replication_config_identifierと同じ）
# compute_config.availability_zone - 実際に配置されたAZ
# compute_config.kms_key_id - 使用中のKMSキーID
# compute_config.multi_az - マルチAZ設定の状態
# compute_config.preferred_maintenance_window - メンテナンスウィンドウ
# compute_config.vpc_security_group_ids - 適用されているセキュリティグループ
# region - リソースが管理されているリージョン
# replication_settings - 適用されているレプリケーション設定
# resource_identifier - リソース識別子
# tags_all - 全タグ（default_tags含む）
