#---------------------------------------------------------------
# AWS Elastic Disaster Recovery (DRS) Replication Configuration Template
#---------------------------------------------------------------
#
# AWS Elastic Disaster Recovery (AWS DRS) のレプリケーション設定テンプレートを管理するリソースです。
# このテンプレートは、ソースサーバーからAWSへのデータレプリケーションに使用される
# レプリケーションサーバーの設定を定義します。
#
# 重要: DRSを使用する前に、アカウントを初期化する必要があります。
# https://docs.aws.amazon.com/drs/latest/userguide/getting-started-initializing.html
#
# 注意: AWSのルールにより、pit_policy は基本設定で示されている構成を使用する必要があります。
# 変更可能なのは rule_id 3 の retention_duration のみです。
#
# AWS公式ドキュメント:
#   - DRS 概要: https://docs.aws.amazon.com/drs/latest/userguide/what-is-drs.html
#   - DRS 設定: https://docs.aws.amazon.com/drs/latest/userguide/settings.html
#   - DRS API リファレンス: https://docs.aws.amazon.com/drs/latest/APIReference/Welcome.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/drs_replication_configuration_template
#
# Provider Version: 6.28.0
# Generated: 2026-01-22
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_drs_replication_configuration_template" "example" {
  #-------------------------------------------------------------
  # セキュリティグループ設定
  #-------------------------------------------------------------

  # associate_default_security_group (Required)
  # 設定内容: デフォルトのElastic Disaster Recoveryセキュリティグループをレプリケーション設定テンプレートに関連付けるかどうかを指定します。
  # 設定可能な値:
  #   - true: デフォルトのDRSセキュリティグループを関連付ける
  #   - false: デフォルトのDRSセキュリティグループを関連付けない
  # 関連機能: DRS セキュリティグループ
  #   レプリケーションサーバーのネットワークアクセスを制御。
  #   - https://docs.aws.amazon.com/drs/latest/userguide/individual-replication-settings.html
  associate_default_security_group = false

  # replication_servers_security_groups_ids (Required)
  # 設定内容: レプリケーションサーバーで使用するセキュリティグループIDのリストを指定します。
  # 設定可能な値: 有効なVPCセキュリティグループIDの文字列リスト（最大32個）
  # 関連機能: レプリケーションサーバーのセキュリティ
  #   レプリケーションサーバーへのインバウンド/アウトバウンドトラフィックを制御。
  #   - https://docs.aws.amazon.com/drs/latest/userguide/individual-replication-settings.html
  replication_servers_security_groups_ids = ["sg-0123456789abcdef0"]

  #-------------------------------------------------------------
  # ネットワーク設定
  #-------------------------------------------------------------

  # staging_area_subnet_id (Required)
  # 設定内容: レプリケーションステージングエリアで使用するサブネットIDを指定します。
  # 設定可能な値: 有効なVPCサブネットID
  # 関連機能: ステージングエリアサブネット
  #   レプリケーションサーバーがデプロイされるサブネットを定義。
  #   - https://docs.aws.amazon.com/drs/latest/userguide/individual-replication-settings.html
  staging_area_subnet_id = "subnet-0123456789abcdef0"

  # data_plane_routing (Required)
  # 設定内容: レプリケーションに使用するデータプレーンルーティングメカニズムを指定します。
  # 設定可能な値:
  #   - "PRIVATE_IP": プライベートIPを使用（VPN/Direct Connect環境向け）
  #   - "PUBLIC_IP": パブリックIPを使用（インターネット経由でのレプリケーション）
  # 関連機能: データプレーンルーティング
  #   ソースサーバーからレプリケーションサーバーへのデータ転送経路を定義。
  #   - https://docs.aws.amazon.com/drs/latest/userguide/individual-replication-settings.html
  data_plane_routing = "PRIVATE_IP"

  # create_public_ip (Required)
  # 設定内容: リカバリインスタンスにデフォルトでパブリックIPを作成するかどうかを指定します。
  # 設定可能な値:
  #   - true: パブリックIPを作成
  #   - false: パブリックIPを作成しない
  # 関連機能: リカバリインスタンスのネットワーク設定
  #   フェイルオーバー時に起動するEC2インスタンスのネットワーク設定。
  create_public_ip = false

  # bandwidth_throttling (Required)
  # 設定内容: ソースサーバーのアウトバウンドデータ転送レートの帯域幅制限をMbpsで指定します。
  # 設定可能な値: 0以上の整数（Mbps単位）。0は無制限を意味します。
  # 関連機能: ネットワーク帯域幅スロットリング
  #   ソースサーバーのネットワークパフォーマンスへの影響を制御。
  #   - https://docs.aws.amazon.com/drs/latest/userguide/individual-replication-settings.html
  bandwidth_throttling = 0

  #-------------------------------------------------------------
  # レプリケーションサーバー設定
  #-------------------------------------------------------------

  # replication_server_instance_type (Required)
  # 設定内容: レプリケーションサーバーに使用するEC2インスタンスタイプを指定します。
  # 設定可能な値: 有効なEC2インスタンスタイプ（例: t3.small, m5.large）
  # 推奨: デフォルトはt3.smallですが、CloudWatchメトリクスを監視して必要に応じて調整
  # 注意: レプリケーションサーバーは最大60ボリュームをサポート
  # 関連機能: レプリケーションサーバーインスタンスタイプ
  #   レプリケーションパフォーマンスとコストのバランスを調整。
  #   - https://docs.aws.amazon.com/drs/latest/userguide/individual-replication-settings.html
  replication_server_instance_type = "t3.small"

  # use_dedicated_replication_server (Required)
  # 設定内容: レプリケーションステージングエリアで専用のレプリケーションサーバーを使用するかどうかを指定します。
  # 設定可能な値:
  #   - true: 専用のレプリケーションサーバーを使用（ソースサーバーごとに1台）
  #   - false: 複数のソースサーバーでレプリケーションサーバーを共有（デフォルト動作）
  # 注意: 専用サーバーを使用するとEC2コストが増加する可能性があります
  # 関連機能: 専用レプリケーションサーバー
  #   頻繁なラグやバックログが発生する場合に使用を検討。
  #   - https://docs.aws.amazon.com/drs/latest/userguide/individual-replication-settings.html
  use_dedicated_replication_server = false

  # auto_replicate_new_disks (Optional, Computed)
  # 設定内容: AWSレプリケーションエージェントが新しく追加されたディスクを自動的にレプリケートするかどうかを指定します。
  # 設定可能な値:
  #   - true: 新しいディスクを自動的にレプリケート
  #   - false: 新しいディスクは手動で追加する必要あり
  # 省略時: AWSデフォルト値が使用されます
  auto_replicate_new_disks = true

  #-------------------------------------------------------------
  # EBS暗号化設定
  #-------------------------------------------------------------

  # ebs_encryption (Required)
  # 設定内容: レプリケーション中に使用するEBS暗号化のタイプを指定します。
  # 設定可能な値:
  #   - "DEFAULT": AWSアカウントのデフォルト暗号化設定を使用
  #   - "CUSTOM": カスタムKMSキーを使用（ebs_encryption_key_arnの指定が必要）
  # 関連機能: EBS暗号化
  #   ステージングエリアのEBSボリュームとスナップショットを暗号化。
  #   - https://docs.aws.amazon.com/drs/latest/userguide/individual-replication-settings.html
  ebs_encryption = "DEFAULT"

  # ebs_encryption_key_arn (Optional)
  # 設定内容: レプリケーション中に使用するEBS暗号化キーのARNを指定します。
  # 設定可能な値: 有効なKMSキーのARN
  # 用途: ebs_encryption が "CUSTOM" の場合に必須
  # 関連機能: カスタムKMSキーによるEBS暗号化
  #   独自の暗号化キーでデータを保護。
  ebs_encryption_key_arn = null

  #-------------------------------------------------------------
  # ステージングディスク設定
  #-------------------------------------------------------------

  # default_large_staging_disk_type (Required)
  # 設定内容: レプリケーション中に使用するステージングディスクのEBSボリュームタイプを指定します。
  # 設定可能な値:
  #   - "GP2": 汎用SSD (gp2)
  #   - "GP3": 汎用SSD (gp3) - コスト効率が良い
  #   - "ST1": スループット最適化HDD
  #   - "AUTO": 自動選択
  # 関連機能: ステージングディスクタイプ
  #   レプリケーションのパフォーマンスとコストを調整。
  default_large_staging_disk_type = "GP3"

  #-------------------------------------------------------------
  # ステージングエリアタグ設定
  #-------------------------------------------------------------

  # staging_area_tags (Required)
  # 設定内容: レプリケーションステージングエリアで作成される全リソースに関連付けるタグのセットを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 適用対象: EC2レプリケーションサーバー、EBSボリューム、EBSスナップショットなど
  # 関連機能: ステージングエリアリソースタグ
  #   コスト配分やリソース管理のためにタグを設定。
  staging_area_tags = {
    Environment = "disaster-recovery"
    ManagedBy   = "terraform"
  }

  #-------------------------------------------------------------
  # Point-in-Time (PIT) ポリシー設定
  #-------------------------------------------------------------
  # 重要: AWSのルールにより、以下の3つのpit_policyブロックを必ず設定する必要があります。
  # 変更可能なのは rule_id 3 の retention_duration のみです。

  # pit_policy (Required)
  # 設定内容: レプリケーション中に取得されるスナップショットを管理するためのPoint-in-Timeポリシーを指定します。
  # 用途: 障害発生時に復旧可能なポイントを定義
  # 制約: 最小1個、最大10個のルールを指定可能
  # 関連機能: Point-in-Time リカバリ
  #   特定の時点にリカバリするためのスナップショット保持ポリシー。
  #   - https://docs.aws.amazon.com/drs/latest/userguide/individual-replication-settings.html

  # Rule 1: 10分間隔で60分保持（分単位）
  pit_policy {
    # enabled (Optional)
    # 設定内容: このルールを有効にするかどうかを指定します。
    # 設定可能な値: true または false
    enabled = true

    # interval (Required)
    # 設定内容: スナップショットを取得する間隔を指定します。
    # 設定可能な値: 正の整数（units で指定した単位）
    interval = 10

    # retention_duration (Required)
    # 設定内容: スナップショットを保持する期間を指定します。
    # 設定可能な値: 正の整数（units で指定した単位）
    retention_duration = 60

    # units (Required)
    # 設定内容: interval と retention_duration の単位を指定します。
    # 設定可能な値:
    #   - "MINUTE": 分
    #   - "HOUR": 時間
    #   - "DAY": 日
    units = "MINUTE"

    # rule_id (Optional)
    # 設定内容: ルールのIDを指定します。
    # 設定可能な値: 正の整数
    rule_id = 1
  }

  # Rule 2: 1時間間隔で24時間保持（時間単位）
  pit_policy {
    enabled            = true
    interval           = 1
    retention_duration = 24
    units              = "HOUR"
    rule_id            = 2
  }

  # Rule 3: 1日間隔でN日保持（日単位）- retention_duration のみ変更可能
  pit_policy {
    enabled            = true
    interval           = 1
    retention_duration = 7  # この値のみ変更可能（デフォルトは3日）
    units              = "DAY"
    rule_id            = 3
  }

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: レプリケーション設定テンプレートリソースに割り当てるタグのセットを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-drs-replication-template"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定します。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "30s", "2h45m"）
    create = "20m"

    # update (Optional)
    # 設定内容: リソース更新のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "30s", "2h45m"）
    update = "20m"

    # delete (Optional)
    # 設定内容: リソース削除のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "30s", "2h45m"）
    delete = "20m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: レプリケーション設定テンプレートのAmazon Resource Name (ARN)
#
# - id: レプリケーション設定テンプレートID
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#   リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
